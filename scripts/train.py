#!/usr/bin/env python3
"""Train the classifier (13 Mel features -> 16 hidden -> 8 classes) on
real labeled recordings and export the result as hidden_weights.mem /
hidden_biases.mem / weights.mem / biases.mem, in the exact format and
layout dense_hidden.v and matrix_multiplication.v expect.

Three things make a real difference at this model's size (13 inputs,
one 16-unit hidden layer - fixed by the RTL) with a few thousand real
recordings:

1. Standardizing the 13 Mel features before training. Raw filterbank
   output is badly scaled for gradient descent (some bands run 10-100x
   larger than others) and starves half the ReLU units dead on
   initialization. Standardizing fixes this, and because standardize-
   then-affine is itself affine, the (mean, std) can be folded exactly
   into the hidden layer's weights/bias after training - the hardware
   still sees raw, unstandardized Mel features at runtime.
2. A short knowledge-distillation step: a much bigger "teacher" model
   (128+64 hidden units) trained on richer per-clip statistics (mean,
   std AND max across frames, not just mean) produces soft class
   probabilities for every training clip via 5-fold out-of-fold
   cross-validation, so a clip's soft label never comes from a teacher
   that trained on it. Those probabilities are turned back into extra
   training examples by resampling a label from each clip's teacher
   distribution several times (plus the true label), which lets the
   tiny hardware-shaped student benefit from the teacher's extra
   capacity/features while keeping its own input/output shape (and
   therefore its exported .mem sizes) exactly what the RTL expects.
3. Using every available recording, not a small per-class sample.

Expects a directory of one subfolder per keyword, each full of 16kHz
mono 16-bit PCM WAV recordings of that keyword:

    data/
      up/clip1.wav clip2.wav ...
      down/...
      ...

The 8 subfolder names, in the order given to --classes (or sorted
alphabetically if omitted), map onto keyword_id 0-7 - keyword_id's
meaning on the FPGA (and the LED color it drives) is defined by
top_module.v's case statement.

Usage:
    python scripts/train.py data/ --classes up down right left stop go yes no
"""

import argparse
import struct
import sys
from pathlib import Path

import numpy as np
from sklearn.model_selection import StratifiedKFold, train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler

sys.path.insert(0, str(Path(__file__).parent))
from extract_features import extract_frames, load_wav  # noqa: E402

NUM_FEATURES = 13
NUM_HIDDEN = 16
NUM_CLASSES = 8
Q15_SCALE = 1 << 15
TEACHER_HIDDEN = (128, 64)
RESAMPLE_K = 8
RESAMPLE_HARD_FRACTION = 0.3


def to_hex16(value: int) -> str:
    value = max(-32768, min(32767, value))
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def write_mem(path: str, values) -> None:
    with open(path, "w", encoding="utf-8") as f:
        for v in values:
            f.write(to_hex16(int(round(v))) + "\n")


def student_features(frames: np.ndarray) -> np.ndarray:
    if len(frames) == 0:
        return np.zeros(NUM_FEATURES)
    return frames.mean(axis=0)


def teacher_features(frames: np.ndarray) -> np.ndarray:
    if len(frames) == 0:
        return np.zeros(NUM_FEATURES * 3)
    return np.concatenate([frames.mean(axis=0), frames.std(axis=0), frames.max(axis=0)])


def load_dataset(data_dir: Path, classes: list):
    student_X, teacher_X, labels = [], [], []
    for class_idx, name in enumerate(classes):
        class_dir = data_dir / name
        wavs = sorted(class_dir.glob("*.wav"))
        if not wavs:
            print(f"warning: no .wav files found in {class_dir}", file=sys.stderr)
        for wav_path in wavs:
            frames = extract_frames(load_wav(str(wav_path)))
            student_X.append(student_features(frames))
            teacher_X.append(teacher_features(frames))
            labels.append(class_idx)
    return np.array(student_X), np.array(teacher_X), np.array(labels)


def out_of_fold_soft_labels(teacher_X_scaled: np.ndarray, y: np.ndarray, seed: int, n_splits: int = 5) -> np.ndarray:
    soft = np.zeros((len(y), NUM_CLASSES))
    skf = StratifiedKFold(n_splits=n_splits, shuffle=True, random_state=seed)
    for tr, te in skf.split(teacher_X_scaled, y):
        teacher = MLPClassifier(hidden_layer_sizes=TEACHER_HIDDEN, activation="relu", solver="adam",
                                 alpha=1e-3, max_iter=3000, random_state=seed)
        teacher.fit(teacher_X_scaled[tr], y[tr])
        soft[te] = teacher.predict_proba(teacher_X_scaled[te])
    return soft


def resample_distill(student_X_scaled: np.ndarray, y: np.ndarray, soft: np.ndarray, seed: int):
    """Turns each clip's teacher soft label into RESAMPLE_K extra training
    examples (a fixed fraction keeping the true label, the rest sampling
    from the teacher's class distribution), so a plain classifier trained
    on the expanded set approximately minimizes cross-entropy against the
    blended hard/soft target - this outperformed directly regressing onto
    the probability vectors in testing."""
    rng = np.random.RandomState(seed)
    n_hard = int(RESAMPLE_K * RESAMPLE_HARD_FRACTION)
    n_soft = RESAMPLE_K - n_hard
    X_exp, y_exp = [], []
    for i in range(len(y)):
        for _ in range(n_hard):
            X_exp.append(student_X_scaled[i])
            y_exp.append(y[i])
        for _ in range(n_soft):
            X_exp.append(student_X_scaled[i])
            y_exp.append(rng.choice(NUM_CLASSES, p=soft[i]))
    return np.array(X_exp), np.array(y_exp)


def fold_scaler_into_first_layer(clf: MLPClassifier, scaler: StandardScaler):
    """clf was trained on (x - mean) / std. Folds that affine
    standardization into the first layer's weights/bias so the exported
    weights work directly on raw, unstandardized hardware input:
        h = relu(W1.T @ z + b1), z = (x - mean) / std
          = relu((W1 / std).T @ x + (b1 - W1.T @ (mean / std)))
    """
    w1, b1 = clf.coefs_[0], clf.intercepts_[0]  # w1: (n_in, n_hidden)
    folded_w1 = w1 / scaler.scale_[:, None]
    folded_b1 = b1 - w1.T @ (scaler.mean_ / scaler.scale_)
    return folded_w1, folded_b1


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("data_dir", help="Directory with one subfolder of .wav files per keyword")
    parser.add_argument("--classes", nargs=NUM_CLASSES, metavar="NAME",
                         help=f"{NUM_CLASSES} subfolder names, in keyword_id 0..{NUM_CLASSES - 1} order")
    parser.add_argument("--weight-scale", type=float, default=4.0,
                         help="Clip trained weights to +/- this many units before quantizing to Q15 "
                              "(default: 4.0 - matches the >>>15 fixed-point range headroom)")
    parser.add_argument("--seed", type=int, default=0)
    args = parser.parse_args()

    data_dir = Path(args.data_dir)
    classes = args.classes or sorted(p.name for p in data_dir.iterdir() if p.is_dir())
    if len(classes) != NUM_CLASSES:
        parser.error(f"Need exactly {NUM_CLASSES} classes, got {len(classes)}: {classes}")

    print(f"Classes (keyword_id 0..{NUM_CLASSES - 1}): {classes}")
    student_X, teacher_X, y = load_dataset(data_dir, classes)
    if len(student_X) == 0:
        parser.error(f"No training data found under {data_dir}")
    print(f"Loaded {len(y)} examples across {len(set(y.tolist()))} classes")

    # Honest held-out estimate: run the whole pipeline (teacher CV, resample
    # distillation, scaling) on an 80/20 split that never touches the
    # weights actually shipped below.
    s_tr, s_te, t_tr, t_te, y_tr, y_te = train_test_split(
        student_X, teacher_X, y, test_size=0.2, stratify=y, random_state=args.seed)
    t_scaler_eval = StandardScaler().fit(t_tr)
    s_scaler_eval = StandardScaler().fit(s_tr)
    soft_eval = out_of_fold_soft_labels(t_scaler_eval.transform(t_tr), y_tr, args.seed)
    Xe, ye = resample_distill(s_scaler_eval.transform(s_tr), y_tr, soft_eval, args.seed)
    eval_clf = MLPClassifier(hidden_layer_sizes=(NUM_HIDDEN,), activation="relu", solver="adam",
                              alpha=1e-4, max_iter=2000, random_state=args.seed)
    eval_clf.fit(Xe, ye)
    held_out_acc = eval_clf.score(s_scaler_eval.transform(s_te), y_te)
    print(f"Held-out accuracy estimate (80/20 split, full pipeline): {held_out_acc:.3f}")

    # Final shipped weights: same pipeline, trained on every example.
    t_scaler = StandardScaler().fit(teacher_X)
    s_scaler = StandardScaler().fit(student_X)
    soft = out_of_fold_soft_labels(t_scaler.transform(teacher_X), y, args.seed)
    X_exp, y_exp = resample_distill(s_scaler.transform(student_X), y, soft, args.seed)

    clf = MLPClassifier(hidden_layer_sizes=(NUM_HIDDEN,), activation="relu", solver="adam",
                         alpha=1e-4, max_iter=2000, random_state=args.seed)
    clf.fit(X_exp, y_exp)
    print(f"Final model training accuracy (on resampled set): {clf.score(X_exp, y_exp):.3f}")

    hidden_w, hidden_b = fold_scaler_into_first_layer(clf, s_scaler)
    output_w, output_b = clf.coefs_[1], clf.intercepts_[1]

    # sklearn's coefs_[layer] has shape (n_in, n_out): coefs_[l][j][i] is
    # the weight from input j to neuron i. The hardware's weights_flat
    # layout is neuron-major (weights_flat[i*n_in + j]), so transpose
    # before flattening.
    scale = args.weight_scale
    hidden_w = np.clip(hidden_w.T, -scale, scale) / scale * (Q15_SCALE - 1)
    hidden_b = np.clip(hidden_b, -scale, scale) / scale * (Q15_SCALE - 1)
    output_w = np.clip(output_w.T, -scale, scale) / scale * (Q15_SCALE - 1)
    output_b = np.clip(output_b, -scale, scale) / scale * (Q15_SCALE - 1)

    write_mem("hidden_weights.mem", hidden_w.flatten())
    write_mem("hidden_biases.mem", hidden_b)
    write_mem("weights.mem", output_w.flatten())
    write_mem("biases.mem", output_b)

    print("Wrote hidden_weights.mem, hidden_biases.mem, weights.mem, biases.mem")


if __name__ == "__main__":
    main()
