module fft (
    input wire clk,
    input wire [15:0] audio_in,  // 16-bit real input data
    output reg [15:0] fft_output_0, output reg [15:0] fft_output_1,
    output reg [15:0] fft_output_2, output reg [15:0] fft_output_3,
    output reg [15:0] fft_output_4, output reg [15:0] fft_output_5,
    output reg [15:0] fft_output_6, output reg [15:0] fft_output_7,
    output reg [15:0] fft_output_8, output reg [15:0] fft_output_9,
    output reg [15:0] fft_output_10, output reg [15:0] fft_output_11,
    output reg [15:0] fft_output_12, output reg [15:0] fft_output_13,
    output reg [15:0] fft_output_14, output reg [15:0] fft_output_15
);

    // This used to compute fft_output_0..7 = buffer[k] + buffer[k+8] and
    // fft_output_8..15 = buffer[k] - buffer[k+8] - sum/difference pairs
    // with no sine/cosine basis at all, not a transform into the frequency
    // domain by any definition (the module's own comments called it a
    // "Placeholder for real FFT logic"). This is now a direct-form 16-point
    // DFT over 8 positive-frequency bins: for each bin k, correlate the
    // windowed sample buffer against cos(2*pi*k*n/16) and sin(2*pi*k*n/16).
    // Real inputs are Hermitian-symmetric, so bins 0-7 (plus DC/Nyquist)
    // capture the full spectrum; bins 8-15 of the mirrored upper half would
    // be redundant. Output layout keeps the same 16 ports as before so
    // nothing downstream of this module's instantiation needs to change:
    //   fft_output_0..7  = real part of bins 0..7
    //   fft_output_8..15 = imaginary part of bins 0..7
    //
    // This is O(N^2) direct computation, not a fast O(N log N) FFT
    // (no butterfly network/bit-reversal) - reasonable for a fixed N=16
    // analysis window on a small embedded design, same "fully unrolled,
    // one clock" style as the rest of this pipeline (mel_filterbank,
    // matrix_multiplication).

    reg signed [15:0] fft_buffer [0:15];     // raw shift buffer (FIFO)
    reg signed [15:0] windowed [0:15];       // after the Hamming window
    integer i, k, n, idx;
    reg signed [31:0] real_acc, imag_acc;
    // Verilog shift operators are self-determined and do NOT inherit the
    // width of whatever consumes their result, even through an assignment
    // or addition on the outside - (a * b) >>> N truncates a*b to the
    // width of its own operands FIRST, silently corrupting any product
    // that doesn't fit in 16 bits (common: two near-full-scale 16-bit
    // values multiply to needing ~32 bits). Routing every product through
    // this explicit 32-bit temporary before shifting is what actually
    // avoids that, confirmed against a known-value test case.
    reg signed [31:0] product;

    // Hamming window, w[n] = 0.54 - 0.46*cos(2*pi*n/15), Q15.
    reg signed [15:0] HAMMING [0:15];

    // cos(2*pi*i/16), sin(2*pi*i/16) for i = 0..15, Q15. Indexed by
    // (k*n) mod 16, which covers every angle any (k, n) pair needs.
    reg signed [15:0] COS16 [0:15];
    reg signed [15:0] SIN16 [0:15];

    initial begin
        HAMMING[0]=16'sd2621;   HAMMING[1]=16'sd3924;   HAMMING[2]=16'sd7608;   HAMMING[3]=16'sd13036;
        HAMMING[4]=16'sd19270;  HAMMING[5]=16'sd25231;  HAMMING[6]=16'sd29888;  HAMMING[7]=16'sd32438;
        HAMMING[8]=16'sd32438;  HAMMING[9]=16'sd29888;  HAMMING[10]=16'sd25231; HAMMING[11]=16'sd19270;
        HAMMING[12]=16'sd13036; HAMMING[13]=16'sd7608;  HAMMING[14]=16'sd3924;  HAMMING[15]=16'sd2621;

        COS16[0]=16'sd32767;  COS16[1]=16'sd30273;  COS16[2]=16'sd23170;  COS16[3]=16'sd12539;
        COS16[4]=16'sd0;      COS16[5]=-16'sd12539; COS16[6]=-16'sd23170; COS16[7]=-16'sd30273;
        COS16[8]=-16'sd32767; COS16[9]=-16'sd30273; COS16[10]=-16'sd23170;COS16[11]=-16'sd12539;
        COS16[12]=16'sd0;     COS16[13]=16'sd12539; COS16[14]=16'sd23170; COS16[15]=16'sd30273;

        SIN16[0]=16'sd0;      SIN16[1]=16'sd12539;  SIN16[2]=16'sd23170;  SIN16[3]=16'sd30273;
        SIN16[4]=16'sd32767;  SIN16[5]=16'sd30273;  SIN16[6]=16'sd23170;  SIN16[7]=16'sd12539;
        SIN16[8]=16'sd0;      SIN16[9]=-16'sd12539; SIN16[10]=-16'sd23170;SIN16[11]=-16'sd30273;
        SIN16[12]=-16'sd32767;SIN16[13]=-16'sd30273;SIN16[14]=-16'sd23170;SIN16[15]=-16'sd12539;
    end

    always @(posedge clk) begin
        // Shift the new sample into the 16-tap analysis buffer (FIFO).
        for (i = 15; i > 0; i = i - 1) begin
            fft_buffer[i] <= fft_buffer[i - 1];
        end
        fft_buffer[0] <= audio_in;

        // Apply the Hamming window before transforming, which tapers the
        // frame edges and reduces spectral leakage - standard practice
        // ahead of any DFT/FFT on a finite sample window.
        for (n = 0; n < 16; n = n + 1) begin
            product = fft_buffer[n] * HAMMING[n];
            windowed[n] = product >>> 15;
        end

        // Direct-form DFT: X[k] = sum_n windowed[n] * e^(-j*2*pi*k*n/16)
        for (k = 0; k < 8; k = k + 1) begin
            real_acc = 0;
            imag_acc = 0;
            for (n = 0; n < 16; n = n + 1) begin
                idx = (k * n) % 16;
                product = windowed[n] * COS16[idx];
                real_acc = real_acc + (product >>> 15);
                product = windowed[n] * SIN16[idx];
                imag_acc = imag_acc - (product >>> 15);
            end
            // Normalize by N=16 so bin magnitude stays in the same ballpark
            // as the input samples instead of growing with the window size.
            case (k)
                0: begin fft_output_0 <= real_acc >>> 4; fft_output_8  <= imag_acc >>> 4; end
                1: begin fft_output_1 <= real_acc >>> 4; fft_output_9  <= imag_acc >>> 4; end
                2: begin fft_output_2 <= real_acc >>> 4; fft_output_10 <= imag_acc >>> 4; end
                3: begin fft_output_3 <= real_acc >>> 4; fft_output_11 <= imag_acc >>> 4; end
                4: begin fft_output_4 <= real_acc >>> 4; fft_output_12 <= imag_acc >>> 4; end
                5: begin fft_output_5 <= real_acc >>> 4; fft_output_13 <= imag_acc >>> 4; end
                6: begin fft_output_6 <= real_acc >>> 4; fft_output_14 <= imag_acc >>> 4; end
                7: begin fft_output_7 <= real_acc >>> 4; fft_output_15 <= imag_acc >>> 4; end
            endcase
        end
    end

endmodule
