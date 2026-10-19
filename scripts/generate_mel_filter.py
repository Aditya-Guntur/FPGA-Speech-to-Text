#!/usr/bin/env python3
"""Generate mel_filter.mem: a standard triangular Mel filterbank, sized
and formatted for mel_filterbank.v's actual [0:31][0:12] array (32
frequency bins -> 13 Mel bands - fft.v's direct-form DFT bin count,
doubled twice from an original 8 since each doubling measurably
improved held-out classifier accuracy; see extract_features.py).

Output: mel_filter.mem, 416 lines of 16-bit hex (row-major [bin][band],
matching `reg signed [15:0] mel_filter [0:31][0:12]`), Q8 fixed point
to match mel_filterbank.v's `>>> 8` shift.

Usage: python scripts/generate_mel_filter.py [--bins 32] [--bands 13] [--sample-rate 16000]
"""

import argparse
import struct


def hz_to_mel(hz: float) -> float:
    return 2595.0 * __import__("math").log10(1.0 + hz / 700.0)


def mel_to_hz(mel: float) -> float:
    return 700.0 * (10.0 ** (mel / 2595.0) - 1.0)


def to_hex16(value: int) -> str:
    value = max(-32768, min(32767, value))
    return format(struct.unpack("<H", struct.pack("<h", value))[0], "04x")


def build_filterbank(num_bins: int, num_bands: int, sample_rate: int, q_scale: int):
    nyquist = sample_rate / 2.0
    mel_min, mel_max = hz_to_mel(0), hz_to_mel(nyquist)
    mel_points = [mel_min + i * (mel_max - mel_min) / (num_bands + 1) for i in range(num_bands + 2)]
    hz_points = [mel_to_hz(m) for m in mel_points]
    # Map each of the 16 "bins" onto 0..nyquist, same as a real FFT bin grid.
    bin_hz = [b * nyquist / (num_bins - 1) for b in range(num_bins)]

    filt = [[0.0] * num_bands for _ in range(num_bins)]
    for band in range(num_bands):
        left, center, right = hz_points[band], hz_points[band + 1], hz_points[band + 2]
        for b in range(num_bins):
            f = bin_hz[b]
            if left <= f <= center and center > left:
                weight = (f - left) / (center - left)
            elif center < f <= right and right > center:
                weight = (right - f) / (right - center)
            else:
                weight = 0.0
            filt[b][band] = weight

    return [[int(round(filt[b][band] * q_scale)) for band in range(num_bands)] for b in range(num_bins)]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bins", type=int, default=32)
    parser.add_argument("--bands", type=int, default=13)
    parser.add_argument("--sample-rate", type=int, default=16000)
    parser.add_argument("--q-scale", type=int, default=256, help="Fixed-point scale (2^8, matches the >>>8 shift)")
    parser.add_argument("-o", "--output", default="mel_filter.mem")
    args = parser.parse_args()

    filt = build_filterbank(args.bins, args.bands, args.sample_rate, args.q_scale)

    with open(args.output, "w", encoding="utf-8") as f:
        for row in filt:
            for value in row:
                f.write(to_hex16(value) + "\n")

    print(f"Wrote {args.bins * args.bands} words to {args.output}")


if __name__ == "__main__":
    main()
