#!/usr/bin/env python3
"""Reference feature extraction, mirroring the exact signal flow the
Verilog implements (preprocessing.v -> fft.v -> mel_filterbank.v), in
floating point:

    pre-emphasis -> Hamming window -> 8-bin direct-form DFT ->
    magnitude (|re| + |im|) -> 13-band Mel filterbank

Used by train.py so features seen during training match what the
hardware actually computes, not a generic MFCC pipeline. Expects
16kHz mono 16-bit PCM WAV input, same as audio.mem.

Usage (standalone):
    python scripts/extract_features.py path/to/clip.wav
Prints one 13-value Mel feature vector per sliding-window frame, mean-
pooled feature vector last.
"""

import sys
import wave

import numpy as np

ALPHA = 0.95
NUM_TAPS = 16
NUM_BINS = 8
NUM_BANDS = 13
SAMPLE_RATE = 16000


def load_wav(path: str) -> np.ndarray:
    """Read 16-bit mono PCM, resampled to SAMPLE_RATE if needed isn't
    handled here - matches the hardware, which assumes 16kHz input."""
    with wave.open(path, "rb") as wf:
        if wf.getsampwidth() != 2:
            raise ValueError(f"{path}: expected 16-bit PCM, got {wf.getsampwidth() * 8}-bit")
        n_channels = wf.getnchannels()
        raw = wf.readframes(wf.getnframes())
        samples = np.frombuffer(raw, dtype="<i2").astype(np.float64)
        if n_channels > 1:
            samples = samples.reshape(-1, n_channels).mean(axis=1)
        if wf.getframerate() != SAMPLE_RATE:
            print(f"warning: {path} is {wf.getframerate()}Hz, not {SAMPLE_RATE}Hz - "
                  "the hardware assumes 16kHz and this script does not resample.",
                  file=sys.stderr)
    return samples


def pre_emphasize(samples: np.ndarray) -> np.ndarray:
    out = np.empty_like(samples)
    prev = 0.0
    for n, x in enumerate(samples):
        out[n] = x - ALPHA * prev
        prev = x
    return out


def hamming_window(n: int) -> np.ndarray:
    return 0.54 - 0.46 * np.cos(2 * np.pi * np.arange(n) / (n - 1))


def build_mel_filterbank(num_bins: int, num_bands: int, sample_rate: int) -> np.ndarray:
    """Same construction as scripts/generate_mel_filter.py, unscaled."""

    def hz_to_mel(hz):
        return 2595.0 * np.log10(1.0 + hz / 700.0)

    def mel_to_hz(mel):
        return 700.0 * (10.0 ** (mel / 2595.0) - 1.0)

    nyquist = sample_rate / 2.0
    mel_min, mel_max = hz_to_mel(0), hz_to_mel(nyquist)
    mel_points = mel_min + np.arange(num_bands + 2) * (mel_max - mel_min) / (num_bands + 1)
    hz_points = mel_to_hz(mel_points)
    bin_hz = np.arange(num_bins) * nyquist / (num_bins - 1)

    filt = np.zeros((num_bins, num_bands))
    for band in range(num_bands):
        left, center, right = hz_points[band], hz_points[band + 1], hz_points[band + 2]
        for b in range(num_bins):
            f = bin_hz[b]
            if left <= f <= center and center > left:
                filt[b, band] = (f - left) / (center - left)
            elif center < f <= right and right > center:
                filt[b, band] = (right - f) / (right - center)
    return filt


_WINDOW = hamming_window(NUM_TAPS)
_COS = np.array([[np.cos(2 * np.pi * k * n / NUM_TAPS) for n in range(NUM_TAPS)] for k in range(NUM_BINS)])
_SIN = np.array([[np.sin(2 * np.pi * k * n / NUM_TAPS) for n in range(NUM_TAPS)] for k in range(NUM_BINS)])
_MEL_FILTER = build_mel_filterbank(NUM_BINS, NUM_BANDS, SAMPLE_RATE)


def extract_frames(samples: np.ndarray) -> np.ndarray:
    """Returns an (num_frames, NUM_BANDS) array - one Mel feature vector
    per sample, sliding a 16-tap window forward by 1 sample at a time,
    exactly like the hardware's shift-register buffer."""
    emphasized = pre_emphasize(samples)
    n = len(emphasized)
    if n < NUM_TAPS:
        return np.zeros((0, NUM_BANDS))

    frames = []
    for start in range(n - NUM_TAPS + 1):
        windowed = emphasized[start:start + NUM_TAPS] * _WINDOW
        real = _COS @ windowed
        imag = -_SIN @ windowed
        magnitude = np.abs(real) + np.abs(imag)
        frames.append(magnitude @ _MEL_FILTER)
    return np.array(frames)


def extract_pooled(samples: np.ndarray) -> np.ndarray:
    """Mean-pools Mel features across the whole clip into one 13-value
    vector. Mostly useful for quick inspection (see the CLI below) - the
    classifier itself uses extract_segments, not this."""
    frames = extract_frames(samples)
    if len(frames) == 0:
        return np.zeros(NUM_BANDS)
    return frames.mean(axis=0)


NUM_SEGMENTS = 6
SEG_LEN = 2048  # cycles/samples per segment - see segment_buffer.v
CANONICAL_SAMPLES = NUM_SEGMENTS * SEG_LEN + NUM_TAPS - 1


# log2(median per-utterance total energy) over the real training set was
# ~14.76 - the nearest integer bit position gain_normalize.v targets.
GAIN_TARGET_LOG2 = 15
GAIN_MAX_SHIFT = 3


def gain_normalize(features: np.ndarray) -> np.ndarray:
    """Bit-exact match for gain_normalize.v: true per-utterance division is
    expensive in fixed-point RTL, so instead this finds the position of the
    highest set bit in the total energy (a priority encoder) and shifts
    every feature by up to +/-GAIN_MAX_SHIFT bits to bring that total back
    toward a fixed reference magnitude - the same idea as floating-point
    mantissa normalization. Must be called on already-quantized integer
    values (what segment_buffer.v actually outputs), not raw floats, for
    the shift amount to match the hardware exactly."""
    total = int(round(features.sum()))
    if total <= 0:
        return features
    msb_pos = total.bit_length() - 1
    shift = max(-GAIN_MAX_SHIFT, min(GAIN_MAX_SHIFT, GAIN_TARGET_LOG2 - msb_pos))
    if shift >= 0:
        shifted = features * (1 << shift)
    else:
        shifted = np.floor(features / (1 << -shift))
    return np.clip(shifted, -32768, 32767)


ONSET_BLOCK_LEN = 256
# 65th percentile of per-block sum(|sample|) over the real training set -
# see onset_trigger.v's THRESHOLD.
ONSET_THRESHOLD = 51739


def onset_align(samples: np.ndarray) -> np.ndarray:
    """Bit-exact match for onset_trigger.v + segment_buffer.v's
    start_enable gating: a real recording pads the spoken word with a
    variable amount of silence, so starting the classifier's window at
    sample 0 of every clip means the word lands in a different part of
    the window on every recording - the single biggest source of noise
    in this classifier's input before this was added. Scans forward in
    fixed 256-sample blocks (matching the hardware's energy accumulator)
    for the first one whose sum(|sample|) crosses ONSET_THRESHOLD, then
    returns a fixed-length window starting there - streaming-feasible
    (no look-ahead into the clip), unlike centering on the clip's single
    loudest point, which would need to see the whole clip first."""
    n_blocks = max(1, len(samples) // ONSET_BLOCK_LEN)
    start = 0
    for i in range(n_blocks):
        block = samples[i * ONSET_BLOCK_LEN:(i + 1) * ONSET_BLOCK_LEN]
        if np.sum(np.abs(block)) >= ONSET_THRESHOLD:
            start = i * ONSET_BLOCK_LEN
            break
    windowed = samples[start:start + CANONICAL_SAMPLES]
    if len(windowed) < CANONICAL_SAMPLES:
        windowed = np.concatenate([windowed, np.zeros(CANONICAL_SAMPLES - len(windowed))])
    return windowed


def extract_segments(samples: np.ndarray) -> np.ndarray:
    """Mirrors onset_trigger.v + segment_buffer.v + gain_normalize.v: finds
    where the word actually starts (see onset_align), mean-pools each of
    NUM_SEGMENTS equal-length chunks of frames from that point separately
    instead of averaging the whole window into one vector (so the
    classifier gets to see roughly how the Mel features evolve over the
    word, not just their overall average), then applies the same
    per-utterance gain normalization the hardware does. Returns a single
    (NUM_SEGMENTS * NUM_BANDS,) vector, oldest segment first - the same
    flattening order segment_buffer.v outputs."""
    samples = onset_align(samples)
    frames = extract_frames(samples)
    if len(frames) == 0:
        return np.zeros(NUM_SEGMENTS * NUM_BANDS)
    chunks = np.array_split(frames, NUM_SEGMENTS)
    pooled = np.concatenate([chunk.mean(axis=0) for chunk in chunks])
    return gain_normalize(pooled)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python scripts/extract_features.py path/to/clip.wav", file=sys.stderr)
        sys.exit(1)

    wav_samples = load_wav(sys.argv[1])
    all_frames = extract_frames(wav_samples)
    for row in all_frames:
        print(" ".join(f"{v:.1f}" for v in row))
    print("--- mean-pooled ---")
    print(" ".join(f"{v:.1f}" for v in all_frames.mean(axis=0)))
