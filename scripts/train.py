#!/usr/bin/env python3
"""Train the classifier (78 segment-pooled Mel features -> 16 hidden ->
8 classes) on real labeled recordings and export the result as
hidden_weights.mem / hidden_biases.mem / weights.mem / biases.mem, in
the exact format and layout dense_hidden.v and matrix_multiplication.v
expect.

Three things make a real difference at this model's size (fixed by
the RTL: a hidden layer of 16 units) with a few thousand real
recordings:

1. Segment-pooling instead of whole-clip mean-pooling. Averaging every
   frame of a ~1s clip into one vector throws away virtually all of
   the word's time structure - exactly the weakness small-footprint
   keyword-spotting literature (e.g. Zhang et al., "Hello Edge:
   Keyword Spotting on Microcontrollers") identifies in plain DNNs
   trained on pooled/flattened features. extract_features.
   extract_segments mean-pools 6 equal time segments separately
   instead of the whole clip at once (matching segment_buffer.v's
   hardware buffer exactly), which alone roughly doubled held-out
   accuracy in testing versus single-vector pooling.
2. Per-utterance gain normalization (extract_segments also applies
   extract_features.gain_normalize, matching gain_normalize.v)
   compensates for how loud a given recording happens to be, instead
   of leaving that nuisance variation for the classifier to absorb.
   Standardizing the result before training (folding that back into
   the hidden layer's weights/bias afterward, so the exported .mem
   files still expect raw, unstandardized hardware input) further
   fixes how badly scaled raw filterbank output is for gradient
   descent. Both measurably improve held-out accuracy, and they stack.
3. Data augmentation: time-shifting and adding light Gaussian noise to
   the raw audio before feature extraction (train-time only - the
   evaluation/held-out audio is never augmented) gives the classifier
   several slightly different versions of the same recording, which
   on this little data measurably improves generalization on top of
   everything else.

Plain standardized hard-label training on top of all of this already
beats every knowledge-distillation variant tried (the extra signal in
78 segment-pooled, gain-normalized features made the distillation step
that helped an earlier 13-feature, whole-clip-mean version of this
model actively counterproductive here), so this script doesn't do
that.

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
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler

sys.path.insert(0, str(Path(__file__).parent))
from extract_features import extract_segments, load_wav, NUM_SEGMENTS, NUM_BANDS  # noqa: E402

NUM_FEATURES = NUM_SEGMENTS * NUM_BANDS  # 78
NUM_HIDDEN = 16
NUM_CLASSES = 8
Q15_SCALE = 1 << 15
AUG_COPIES_PER_CLIP = 2
AUG_MAX_SHIFT_SAMPLES = 1600  # ~0.1s at 16kHz
AUG_NOISE_STD = 300  # relative to +/-32768 full scale


def to_hex16(value: int) -> str:
    value = max(-32768, min(32767, value))
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def write_mem(path: str, values) -> None:
    with open(path, "w", encoding="utf-8") as f:
        for v in values:
            f.write(to_hex16(int(round(v))) + "\n")


def load_raw_dataset(data_dir: Path, classes: list):
    """Raw waveforms and labels, not yet turned into features - kept
    around (rather than just their pooled features) so augment_and_
    extract can make several differently time-shifted/noised copies of
    each training clip."""
    samples, labels = [], []
    for class_idx, name in enumerate(classes):
        class_dir = data_dir / name
        wavs = sorted(class_dir.glob("*.wav"))
        if not wavs:
            print(f"warning: no .wav files found in {class_dir}", file=sys.stderr)
        for wav_path in wavs:
            samples.append(load_wav(str(wav_path)))
            labels.append(class_idx)
    return samples, np.array(labels)


def augment_clip(samples: np.ndarray, rng: np.random.RandomState) -> np.ndarray:
    shift = rng.randint(-AUG_MAX_SHIFT_SAMPLES, AUG_MAX_SHIFT_SAMPLES + 1)
    out = np.roll(samples, shift)
    out = out + rng.normal(0, AUG_NOISE_STD, size=out.shape)
    return out


def extract_training_features(samples_list: list, labels: np.ndarray, seed: int):
    """The real clip plus AUG_COPIES_PER_CLIP augmented copies of each,
    all carrying the same label."""
    rng = np.random.RandomState(seed)
    X, y = [], []
    for samples, label in zip(samples_list, labels):
        X.append(extract_segments(samples))
        y.append(label)
        for _ in range(AUG_COPIES_PER_CLIP):
            X.append(extract_segments(augment_clip(samples, rng)))
            y.append(label)
    return np.array(X), np.array(y)


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


def train_classifier(X: np.ndarray, y: np.ndarray, seed: int) -> MLPClassifier:
    clf = MLPClassifier(hidden_layer_sizes=(NUM_HIDDEN,), activation="relu", solver="adam",
                         alpha=1e-2, max_iter=3000, random_state=seed)
    clf.fit(X, y)
    return clf


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
    raw_samples, y_all = load_raw_dataset(data_dir, classes)
    if len(raw_samples) == 0:
        parser.error(f"No training data found under {data_dir}")
    print(f"Loaded {len(y_all)} examples across {len(set(y_all.tolist()))} classes")

    # Honest held-out estimate: split the raw clips first, augment only
    # the training side, and evaluate on clean, un-augmented held-out
    # audio - this never touches the weights actually shipped below.
    idx_tr, idx_te = train_test_split(
        np.arange(len(y_all)), test_size=0.2, stratify=y_all, random_state=args.seed)
    X_tr, y_tr = extract_training_features([raw_samples[i] for i in idx_tr], y_all[idx_tr], args.seed)
    X_te = np.array([extract_segments(raw_samples[i]) for i in idx_te])
    y_te = y_all[idx_te]

    scaler_eval = StandardScaler().fit(X_tr)
    eval_clf = train_classifier(scaler_eval.transform(X_tr), y_tr, args.seed)
    held_out_acc = eval_clf.score(scaler_eval.transform(X_te), y_te)
    print(f"Held-out accuracy estimate (80/20 split, clean held-out audio): {held_out_acc:.3f}")

    # Final shipped weights: same pipeline, trained (with augmentation)
    # on every example.
    X, y = extract_training_features(raw_samples, y_all, args.seed)
    scaler = StandardScaler().fit(X)
    clf = train_classifier(scaler.transform(X), y, args.seed)
    print(f"Final model training accuracy (all data + augmented copies): {clf.score(scaler.transform(X), y):.3f}")

    hidden_w, hidden_b = fold_scaler_into_first_layer(clf, scaler)
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
