#!/usr/bin/env python3
"""Generate default-initialized weight/bias .mem files for the two-layer
classifier: dense_hidden.v (13 Mel features -> 16 hidden units) and
matrix_multiplication.v (16 hidden units -> 8 classes).

Produces small, deterministic (seeded) values in the Q1.15 fixed-point
format the hardware's `>>> 15` shift expects, written as 16-bit hex -
one word per line, matching $readmemh. Run scripts/train.py against
real labeled recordings to replace these with trained values in the
same format.

Usage: python scripts/init_weights.py [--seed 0]
"""

import argparse
import struct

NUM_FEATURES = 13
NUM_HIDDEN = 16
NUM_CLASSES = 8
Q15_SCALE = 1 << 15


def to_hex16(value: int) -> str:
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def make_rng(seed: int):
    state = seed or 1

    def next_unit() -> float:
        nonlocal state
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        return (state / 0x7FFFFFFF) * 2 - 1  # in [-1, 1)

    return next_unit


def write_layer(weights_path: str, biases_path: str, num_in: int, num_out: int, rng, scale: float) -> None:
    with open(weights_path, "w", encoding="utf-8") as f:
        for _ in range(num_out * num_in):
            w = rng() * scale
            f.write(to_hex16(int(round(w * Q15_SCALE))) + "\n")

    with open(biases_path, "w", encoding="utf-8") as f:
        for _ in range(num_out):
            f.write(to_hex16(0) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--scale", type=float, default=0.05,
                         help="Initial weight magnitude as a fraction of full scale (default: 0.05)")
    args = parser.parse_args()

    rng = make_rng(args.seed)
    write_layer("hidden_weights.mem", "hidden_biases.mem", NUM_FEATURES, NUM_HIDDEN, rng, args.scale)
    write_layer("weights.mem", "biases.mem", NUM_HIDDEN, NUM_CLASSES, rng, args.scale)

    print(f"Wrote hidden_weights.mem ({NUM_HIDDEN * NUM_FEATURES} words), hidden_biases.mem ({NUM_HIDDEN} words)")
    print(f"Wrote weights.mem ({NUM_CLASSES * NUM_HIDDEN} words), biases.mem ({NUM_CLASSES} words)")


if __name__ == "__main__":
    main()
