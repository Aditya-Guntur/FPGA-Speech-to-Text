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
    output reg [15:0] fft_output_14, output reg [15:0] fft_output_15,
    output reg [15:0] fft_output_16, output reg [15:0] fft_output_17,
    output reg [15:0] fft_output_18, output reg [15:0] fft_output_19,
    output reg [15:0] fft_output_20, output reg [15:0] fft_output_21,
    output reg [15:0] fft_output_22, output reg [15:0] fft_output_23,
    output reg [15:0] fft_output_24, output reg [15:0] fft_output_25,
    output reg [15:0] fft_output_26, output reg [15:0] fft_output_27,
    output reg [15:0] fft_output_28, output reg [15:0] fft_output_29,
    output reg [15:0] fft_output_30, output reg [15:0] fft_output_31,
    output reg [15:0] fft_output_32, output reg [15:0] fft_output_33,
    output reg [15:0] fft_output_34, output reg [15:0] fft_output_35,
    output reg [15:0] fft_output_36, output reg [15:0] fft_output_37,
    output reg [15:0] fft_output_38, output reg [15:0] fft_output_39,
    output reg [15:0] fft_output_40, output reg [15:0] fft_output_41,
    output reg [15:0] fft_output_42, output reg [15:0] fft_output_43,
    output reg [15:0] fft_output_44, output reg [15:0] fft_output_45,
    output reg [15:0] fft_output_46, output reg [15:0] fft_output_47,
    output reg [15:0] fft_output_48, output reg [15:0] fft_output_49,
    output reg [15:0] fft_output_50, output reg [15:0] fft_output_51,
    output reg [15:0] fft_output_52, output reg [15:0] fft_output_53,
    output reg [15:0] fft_output_54, output reg [15:0] fft_output_55,
    output reg [15:0] fft_output_56, output reg [15:0] fft_output_57,
    output reg [15:0] fft_output_58, output reg [15:0] fft_output_59,
    output reg [15:0] fft_output_60, output reg [15:0] fft_output_61,
    output reg [15:0] fft_output_62, output reg [15:0] fft_output_63
);

    // This computes a direct-form N-point DFT over NUM_BINS
    // positive-frequency bins: for each bin k, correlate the windowed
    // sample buffer against cos(2*pi*k*n/64) and sin(2*pi*k*n/64).
    // Real inputs are Hermitian-symmetric, so these bins capture the
    // full spectrum; the mirrored upper half would be redundant.
    // NUM_TAPS/NUM_BINS were doubled from an original 16/8 (then 32/16)
    // to 64/32 - each doubling measurably improved held-out
    // classifier accuracy in testing (see scripts/extract_features.py),
    // at the cost of this module's O(taps*bins) direct-DFT cost growing
    // the same way. Output layout keeps the same two-halves-of-the-port-
    // list convention as before:
    //   fft_output_0..31  = real part of bins 0..31
    //   fft_output_32..63 = imaginary part of bins 0..31
    //
    // This is O(N^2) direct computation, not a fast O(N log N) FFT (no
    // butterfly network/bit-reversal) - reasonable for a fixed-size
    // analysis window on a small embedded design, same "fully unrolled,
    // one clock" style as the rest of this pipeline (mel_filterbank,
    // matrix_multiplication).

    localparam NUM_TAPS = 64;
    localparam NUM_BINS = 32;

    reg signed [15:0] fft_buffer [0:NUM_TAPS-1];     // raw shift buffer (FIFO)
    reg signed [15:0] windowed [0:NUM_TAPS-1];       // after the Hamming window
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

    // Hamming window, w[n] = 0.54 - 0.46*cos(2*pi*n/63), Q15.
    reg signed [15:0] HAMMING [0:NUM_TAPS-1];

    // cos(2*pi*i/64), sin(2*pi*i/64) for i = 0..63, Q15.
    // Indexed by (k*n) mod 64, which covers every angle any (k, n) pair needs.
    reg signed [15:0] COS64 [0:NUM_TAPS-1];
    reg signed [15:0] SIN64 [0:NUM_TAPS-1];

    initial begin
        HAMMING[0]=16'sd2621; HAMMING[1]=16'sd2696; HAMMING[2]=16'sd2920; HAMMING[3]=16'sd3291;
        HAMMING[4]=16'sd3805; HAMMING[5]=16'sd4457; HAMMING[6]=16'sd5240; HAMMING[7]=16'sd6148;
        HAMMING[8]=16'sd7170; HAMMING[9]=16'sd8296; HAMMING[10]=16'sd9516; HAMMING[11]=16'sd10818;
        HAMMING[12]=16'sd12187; HAMMING[13]=16'sd13612; HAMMING[14]=16'sd15077; HAMMING[15]=16'sd16568;
        HAMMING[16]=16'sd18070; HAMMING[17]=16'sd19568; HAMMING[18]=16'sd21048; HAMMING[19]=16'sd22495;
        HAMMING[20]=16'sd23893; HAMMING[21]=16'sd25231; HAMMING[22]=16'sd26493; HAMMING[23]=16'sd27668;
        HAMMING[24]=16'sd28743; HAMMING[25]=16'sd29709; HAMMING[26]=16'sd30556; HAMMING[27]=16'sd31274;
        HAMMING[28]=16'sd31858; HAMMING[29]=16'sd32301; HAMMING[30]=16'sd32599; HAMMING[31]=16'sd32748;
        HAMMING[32]=16'sd32748; HAMMING[33]=16'sd32599; HAMMING[34]=16'sd32301; HAMMING[35]=16'sd31858;
        HAMMING[36]=16'sd31274; HAMMING[37]=16'sd30556; HAMMING[38]=16'sd29709; HAMMING[39]=16'sd28743;
        HAMMING[40]=16'sd27668; HAMMING[41]=16'sd26493; HAMMING[42]=16'sd25231; HAMMING[43]=16'sd23893;
        HAMMING[44]=16'sd22495; HAMMING[45]=16'sd21048; HAMMING[46]=16'sd19568; HAMMING[47]=16'sd18070;
        HAMMING[48]=16'sd16568; HAMMING[49]=16'sd15077; HAMMING[50]=16'sd13612; HAMMING[51]=16'sd12187;
        HAMMING[52]=16'sd10818; HAMMING[53]=16'sd9516; HAMMING[54]=16'sd8296; HAMMING[55]=16'sd7170;
        HAMMING[56]=16'sd6148; HAMMING[57]=16'sd5240; HAMMING[58]=16'sd4457; HAMMING[59]=16'sd3805;
        HAMMING[60]=16'sd3291; HAMMING[61]=16'sd2920; HAMMING[62]=16'sd2696; HAMMING[63]=16'sd2621;

        COS64[0]=16'sd32767; COS64[1]=16'sd32609; COS64[2]=16'sd32137; COS64[3]=16'sd31356;
        COS64[4]=16'sd30273; COS64[5]=16'sd28898; COS64[6]=16'sd27245; COS64[7]=16'sd25329;
        COS64[8]=16'sd23170; COS64[9]=16'sd20787; COS64[10]=16'sd18204; COS64[11]=16'sd15446;
        COS64[12]=16'sd12539; COS64[13]=16'sd9512; COS64[14]=16'sd6393; COS64[15]=16'sd3212;
        COS64[16]=16'sd0; COS64[17]=-16'sd3212; COS64[18]=-16'sd6393; COS64[19]=-16'sd9512;
        COS64[20]=-16'sd12539; COS64[21]=-16'sd15446; COS64[22]=-16'sd18204; COS64[23]=-16'sd20787;
        COS64[24]=-16'sd23170; COS64[25]=-16'sd25329; COS64[26]=-16'sd27245; COS64[27]=-16'sd28898;
        COS64[28]=-16'sd30273; COS64[29]=-16'sd31356; COS64[30]=-16'sd32137; COS64[31]=-16'sd32609;
        COS64[32]=-16'sd32767; COS64[33]=-16'sd32609; COS64[34]=-16'sd32137; COS64[35]=-16'sd31356;
        COS64[36]=-16'sd30273; COS64[37]=-16'sd28898; COS64[38]=-16'sd27245; COS64[39]=-16'sd25329;
        COS64[40]=-16'sd23170; COS64[41]=-16'sd20787; COS64[42]=-16'sd18204; COS64[43]=-16'sd15446;
        COS64[44]=-16'sd12539; COS64[45]=-16'sd9512; COS64[46]=-16'sd6393; COS64[47]=-16'sd3212;
        COS64[48]=16'sd0; COS64[49]=16'sd3212; COS64[50]=16'sd6393; COS64[51]=16'sd9512;
        COS64[52]=16'sd12539; COS64[53]=16'sd15446; COS64[54]=16'sd18204; COS64[55]=16'sd20787;
        COS64[56]=16'sd23170; COS64[57]=16'sd25329; COS64[58]=16'sd27245; COS64[59]=16'sd28898;
        COS64[60]=16'sd30273; COS64[61]=16'sd31356; COS64[62]=16'sd32137; COS64[63]=16'sd32609;

        SIN64[0]=16'sd0; SIN64[1]=16'sd3212; SIN64[2]=16'sd6393; SIN64[3]=16'sd9512;
        SIN64[4]=16'sd12539; SIN64[5]=16'sd15446; SIN64[6]=16'sd18204; SIN64[7]=16'sd20787;
        SIN64[8]=16'sd23170; SIN64[9]=16'sd25329; SIN64[10]=16'sd27245; SIN64[11]=16'sd28898;
        SIN64[12]=16'sd30273; SIN64[13]=16'sd31356; SIN64[14]=16'sd32137; SIN64[15]=16'sd32609;
        SIN64[16]=16'sd32767; SIN64[17]=16'sd32609; SIN64[18]=16'sd32137; SIN64[19]=16'sd31356;
        SIN64[20]=16'sd30273; SIN64[21]=16'sd28898; SIN64[22]=16'sd27245; SIN64[23]=16'sd25329;
        SIN64[24]=16'sd23170; SIN64[25]=16'sd20787; SIN64[26]=16'sd18204; SIN64[27]=16'sd15446;
        SIN64[28]=16'sd12539; SIN64[29]=16'sd9512; SIN64[30]=16'sd6393; SIN64[31]=16'sd3212;
        SIN64[32]=16'sd0; SIN64[33]=-16'sd3212; SIN64[34]=-16'sd6393; SIN64[35]=-16'sd9512;
        SIN64[36]=-16'sd12539; SIN64[37]=-16'sd15446; SIN64[38]=-16'sd18204; SIN64[39]=-16'sd20787;
        SIN64[40]=-16'sd23170; SIN64[41]=-16'sd25329; SIN64[42]=-16'sd27245; SIN64[43]=-16'sd28898;
        SIN64[44]=-16'sd30273; SIN64[45]=-16'sd31356; SIN64[46]=-16'sd32137; SIN64[47]=-16'sd32609;
        SIN64[48]=-16'sd32767; SIN64[49]=-16'sd32609; SIN64[50]=-16'sd32137; SIN64[51]=-16'sd31356;
        SIN64[52]=-16'sd30273; SIN64[53]=-16'sd28898; SIN64[54]=-16'sd27245; SIN64[55]=-16'sd25329;
        SIN64[56]=-16'sd23170; SIN64[57]=-16'sd20787; SIN64[58]=-16'sd18204; SIN64[59]=-16'sd15446;
        SIN64[60]=-16'sd12539; SIN64[61]=-16'sd9512; SIN64[62]=-16'sd6393; SIN64[63]=-16'sd3212;
    end

    always @(posedge clk) begin
        // Shift the new sample into the analysis buffer (FIFO).
        for (i = NUM_TAPS-1; i > 0; i = i - 1) begin
            fft_buffer[i] <= fft_buffer[i - 1];
        end
        fft_buffer[0] <= audio_in;

        // Apply the Hamming window before transforming, which tapers the
        // frame edges and reduces spectral leakage - standard practice
        // ahead of any DFT/FFT on a finite sample window.
        for (n = 0; n < NUM_TAPS; n = n + 1) begin
            product = fft_buffer[n] * HAMMING[n];
            windowed[n] = product >>> 15;
        end

        // Direct-form DFT: X[k] = sum_n windowed[n] * e^(-j*2*pi*k*n/64)
        for (k = 0; k < NUM_BINS; k = k + 1) begin
            real_acc = 0;
            imag_acc = 0;
            for (n = 0; n < NUM_TAPS; n = n + 1) begin
                idx = (k * n) % NUM_TAPS;
                product = windowed[n] * COS64[idx];
                real_acc = real_acc + (product >>> 15);
                product = windowed[n] * SIN64[idx];
                imag_acc = imag_acc - (product >>> 15);
            end
            // Normalize by N=64 so bin magnitude stays in the same ballpark
            // as the input samples instead of growing with the window size.
            case (k)
                0: begin fft_output_0 <= real_acc >>> 6; fft_output_32  <= imag_acc >>> 6; end
                1: begin fft_output_1 <= real_acc >>> 6; fft_output_33  <= imag_acc >>> 6; end
                2: begin fft_output_2 <= real_acc >>> 6; fft_output_34  <= imag_acc >>> 6; end
                3: begin fft_output_3 <= real_acc >>> 6; fft_output_35  <= imag_acc >>> 6; end
                4: begin fft_output_4 <= real_acc >>> 6; fft_output_36  <= imag_acc >>> 6; end
                5: begin fft_output_5 <= real_acc >>> 6; fft_output_37  <= imag_acc >>> 6; end
                6: begin fft_output_6 <= real_acc >>> 6; fft_output_38  <= imag_acc >>> 6; end
                7: begin fft_output_7 <= real_acc >>> 6; fft_output_39  <= imag_acc >>> 6; end
                8: begin fft_output_8 <= real_acc >>> 6; fft_output_40  <= imag_acc >>> 6; end
                9: begin fft_output_9 <= real_acc >>> 6; fft_output_41  <= imag_acc >>> 6; end
                10: begin fft_output_10 <= real_acc >>> 6; fft_output_42  <= imag_acc >>> 6; end
                11: begin fft_output_11 <= real_acc >>> 6; fft_output_43  <= imag_acc >>> 6; end
                12: begin fft_output_12 <= real_acc >>> 6; fft_output_44  <= imag_acc >>> 6; end
                13: begin fft_output_13 <= real_acc >>> 6; fft_output_45  <= imag_acc >>> 6; end
                14: begin fft_output_14 <= real_acc >>> 6; fft_output_46  <= imag_acc >>> 6; end
                15: begin fft_output_15 <= real_acc >>> 6; fft_output_47  <= imag_acc >>> 6; end
                16: begin fft_output_16 <= real_acc >>> 6; fft_output_48  <= imag_acc >>> 6; end
                17: begin fft_output_17 <= real_acc >>> 6; fft_output_49  <= imag_acc >>> 6; end
                18: begin fft_output_18 <= real_acc >>> 6; fft_output_50  <= imag_acc >>> 6; end
                19: begin fft_output_19 <= real_acc >>> 6; fft_output_51  <= imag_acc >>> 6; end
                20: begin fft_output_20 <= real_acc >>> 6; fft_output_52  <= imag_acc >>> 6; end
                21: begin fft_output_21 <= real_acc >>> 6; fft_output_53  <= imag_acc >>> 6; end
                22: begin fft_output_22 <= real_acc >>> 6; fft_output_54  <= imag_acc >>> 6; end
                23: begin fft_output_23 <= real_acc >>> 6; fft_output_55  <= imag_acc >>> 6; end
                24: begin fft_output_24 <= real_acc >>> 6; fft_output_56  <= imag_acc >>> 6; end
                25: begin fft_output_25 <= real_acc >>> 6; fft_output_57  <= imag_acc >>> 6; end
                26: begin fft_output_26 <= real_acc >>> 6; fft_output_58  <= imag_acc >>> 6; end
                27: begin fft_output_27 <= real_acc >>> 6; fft_output_59  <= imag_acc >>> 6; end
                28: begin fft_output_28 <= real_acc >>> 6; fft_output_60  <= imag_acc >>> 6; end
                29: begin fft_output_29 <= real_acc >>> 6; fft_output_61  <= imag_acc >>> 6; end
                30: begin fft_output_30 <= real_acc >>> 6; fft_output_62  <= imag_acc >>> 6; end
                31: begin fft_output_31 <= real_acc >>> 6; fft_output_63  <= imag_acc >>> 6; end
            endcase
        end
    end

endmodule
