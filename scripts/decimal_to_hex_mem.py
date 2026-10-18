#!/usr/bin/env python3
"""Convert a one-signed-decimal-integer-per-line .mem file into the
16-bit two's-complement hex format Verilog's $readmemh actually expects.

$readmemh parses hex digits only - no sign, no decimal. A file full of
lines like "-27392" isn't hex at all ('-' isn't a hex digit), so
$readmemh fails outright and leaves the target memory uninitialized
(X in simulation). This script doesn't change any values, just their
base and representation.

Usage: python scripts/decimal_to_hex_mem.py <in.mem> <out.mem> [--bits 16]
"""

import argparse


def convert(in_path: str, out_path: str, bits: int) -> int:
    mask = (1 << bits) - 1
    hex_digits = bits // 4
    count = 0
    with open(in_path, "r", encoding="utf-8") as f_in, open(out_path, "w", encoding="utf-8") as f_out:
        for line in f_in:
            line = line.strip()
            if not line:
                continue
            value = int(line, 10)
            f_out.write(f"{value & mask:0{hex_digits}x}\n")
            count += 1
    return count


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", help="Source .mem file, one signed decimal integer per line")
    parser.add_argument("output", help="Destination .mem file, one hex word per line")
    parser.add_argument("--bits", type=int, default=16, help="Word width in bits (default: 16)")
    args = parser.parse_args()

    count = convert(args.input, args.output, args.bits)
    print(f"Wrote {count} {args.bits}-bit hex words to {args.output}")


if __name__ == "__main__":
    main()
