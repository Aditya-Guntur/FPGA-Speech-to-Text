#!/usr/bin/env python3
"""Train the classifier (13 Mel features -> 16 hidden -> 8 classes) on
real labeled recordings and export the result as hidden_weights.mem /
hidden_biases.mem / weights.mem / biases.mem, in the exact format and
layout dense_hidden.v and matrix_multiplication.v expect.

Expects a directory of one subfolder per keyword, each full of 16kHz
mono 16-bit PCM WAV recordings of that keyword:

    data/
      up/clip1.wav clip2.wav ...
      down/...
      right/...
      left/...
      stop/...
      go/...
      dharwad/...
      hubli/...

The 8 subfolder names, in the order given to --classes (or sorted
alphabetically if omitted), map onto keyword_id 0-7 - keyword_id's
meaning on the FPGA (and the LED color it drives) is defined by
top_module.v's case statement.

Usage:
    python scripts/train.py data/ --classes up down right left stop go dharwad hubli
"""

import argparse
import struct
import sys
from pathlib import Path

import numpy as np
from sklearn.neural_network import MLPClassifier

sys.path.insert(0, str(Path(__file__).parent))
from extract_features import extract_pooled, load_wav  # noqa: E402

NUM_FEATURES = 13
NUM_HIDDEN = 16
NUM_CLASSES = 8
Q15_SCALE = 1 << 15


def to_hex16(value: int) -> str:
    value = max(-32768, min(32767, value))
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def write_mem(path: str, values) -> None:
    with open(path, "w", encoding="utf-8") as f:
        for v in values:
            f.write(to_hex16(int(round(v))) + "\n")


def load_dataset(data_dir: Path, classes: list):
    features, labels = [], []
    for class_idx, name in enumerate(classes):
        class_dir = data_dir / name
        wavs = sorted(class_dir.glob("*.wav"))
        if not wavs:
            print(f"warning: no .wav files found in {class_dir}", file=sys.stderr)
        for wav_path in wavs:
            samples = load_wav(str(wav_path))
            features.append(extract_pooled(samples))
            labels.append(class_idx)
    return np.array(features), np.array(labels)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("data_dir", help="Directory with one subfolder of .wav files per keyword")
    parser.add_argument("--classes", nargs=NUM_CLASSES, metavar="NAME",
                         help=f"{NUM_CLASSES} subfolder names, in keyword_id 0..{NUM_CLASSES - 1} order")
    parser.add_argument("--weight-scale", type=float, default=4.0,
                         help="Clip trained weights to +/- this many units before quantizing to Q15 "
                              "(default: 4.0 - matches the >>>15 fixed-point range headroom)")
    args = parser.parse_args()

    data_dir = Path(args.data_dir)
    classes = args.classes or sorted(p.name for p in data_dir.iterdir() if p.is_dir())
    if len(classes) != NUM_CLASSES:
        parser.error(f"Need exactly {NUM_CLASSES} classes, got {len(classes)}: {classes}")

    print(f"Classes (keyword_id 0..{NUM_CLASSES - 1}): {classes}")
    X, y = load_dataset(data_dir, classes)
    if len(X) == 0:
        parser.error(f"No training data found under {data_dir}")
    print(f"Loaded {len(X)} examples across {len(set(y.tolist()))} classes")

    clf = MLPClassifier(
        hidden_layer_sizes=(NUM_HIDDEN,),
        activation="relu",
        solver="adam",
        max_iter=2000,
        random_state=0,
    )
    clf.fit(X, y)
    print(f"Training accuracy: {clf.score(X, y):.3f}")

    # sklearn's coefs_[layer] has shape (n_in, n_out): coefs_[l][j][i] is
    # the weight from input j to neuron i. The hardware's weights_flat
    # layout is neuron-major (weights_flat[i*n_in + j]), so transpose
    # before flattening.
    scale = args.weight_scale
    hidden_w = np.clip(clf.coefs_[0].T, -scale, scale) / scale * (Q15_SCALE - 1)
    hidden_b = np.clip(clf.intercepts_[0], -scale, scale) / scale * (Q15_SCALE - 1)
    output_w = np.clip(clf.coefs_[1].T, -scale, scale) / scale * (Q15_SCALE - 1)
    output_b = np.clip(clf.intercepts_[1], -scale, scale) / scale * (Q15_SCALE - 1)

    write_mem("hidden_weights.mem", hidden_w.flatten())
    write_mem("hidden_biases.mem", hidden_b)
    write_mem("weights.mem", output_w.flatten())
    write_mem("biases.mem", output_b)

    print("Wrote hidden_weights.mem, hidden_biases.mem, weights.mem, biases.mem")


if __name__ == "__main__":
    main()
