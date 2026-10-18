#!/usr/bin/env python3
"""Generate default-initialized weights.mem/biases.mem for
matrix_multiplication.v's 13-feature, 8-neuron linear layer.

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
NUM_NEURONS = 8
Q15_SCALE = 1 << 15


def to_hex16(value: int) -> str:
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--scale", type=float, default=0.05,
                         help="Initial weight magnitude as a fraction of full scale (default: 0.05)")
    args = parser.parse_args()

    # A tiny LCG keeps this dependency-free (no numpy/random needed just to
    # produce a deterministic init file).
    state = args.seed or 1

    def next_unit() -> float:
        nonlocal state
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        return (state / 0x7FFFFFFF) * 2 - 1  # in [-1, 1)

    with open("weights.mem", "w", encoding="utf-8") as f:
        for _ in range(NUM_NEURONS * NUM_FEATURES):
            w = next_unit() * args.scale
            f.write(to_hex16(int(round(w * Q15_SCALE))) + "\n")

    with open("biases.mem", "w", encoding="utf-8") as f:
        for _ in range(NUM_NEURONS):
            f.write(to_hex16(0) + "\n")

    print(f"Wrote weights.mem ({NUM_NEURONS * NUM_FEATURES} words) and biases.mem ({NUM_NEURONS} words)")


if __name__ == "__main__":
    main()
