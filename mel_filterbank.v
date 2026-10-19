module mel_filterbank (
    input wire clk,
    input wire rst,
    // fft_output_0..31 = real part of DFT bins 0..31,
    // fft_output_32..63 = imaginary part of the same bins (see
    // fft.v) - this module's job starts with turning those real/imaginary
    // pairs into a magnitude spectrum before Mel-weighting it.
    input wire [15:0] fft_output_0, input wire [15:0] fft_output_1,
    input wire [15:0] fft_output_2, input wire [15:0] fft_output_3,
    input wire [15:0] fft_output_4, input wire [15:0] fft_output_5,
    input wire [15:0] fft_output_6, input wire [15:0] fft_output_7,
    input wire [15:0] fft_output_8, input wire [15:0] fft_output_9,
    input wire [15:0] fft_output_10, input wire [15:0] fft_output_11,
    input wire [15:0] fft_output_12, input wire [15:0] fft_output_13,
    input wire [15:0] fft_output_14, input wire [15:0] fft_output_15,
    input wire [15:0] fft_output_16, input wire [15:0] fft_output_17,
    input wire [15:0] fft_output_18, input wire [15:0] fft_output_19,
    input wire [15:0] fft_output_20, input wire [15:0] fft_output_21,
    input wire [15:0] fft_output_22, input wire [15:0] fft_output_23,
    input wire [15:0] fft_output_24, input wire [15:0] fft_output_25,
    input wire [15:0] fft_output_26, input wire [15:0] fft_output_27,
    input wire [15:0] fft_output_28, input wire [15:0] fft_output_29,
    input wire [15:0] fft_output_30, input wire [15:0] fft_output_31,
    input wire [15:0] fft_output_32, input wire [15:0] fft_output_33,
    input wire [15:0] fft_output_34, input wire [15:0] fft_output_35,
    input wire [15:0] fft_output_36, input wire [15:0] fft_output_37,
    input wire [15:0] fft_output_38, input wire [15:0] fft_output_39,
    input wire [15:0] fft_output_40, input wire [15:0] fft_output_41,
    input wire [15:0] fft_output_42, input wire [15:0] fft_output_43,
    input wire [15:0] fft_output_44, input wire [15:0] fft_output_45,
    input wire [15:0] fft_output_46, input wire [15:0] fft_output_47,
    input wire [15:0] fft_output_48, input wire [15:0] fft_output_49,
    input wire [15:0] fft_output_50, input wire [15:0] fft_output_51,
    input wire [15:0] fft_output_52, input wire [15:0] fft_output_53,
    input wire [15:0] fft_output_54, input wire [15:0] fft_output_55,
    input wire [15:0] fft_output_56, input wire [15:0] fft_output_57,
    input wire [15:0] fft_output_58, input wire [15:0] fft_output_59,
    input wire [15:0] fft_output_60, input wire [15:0] fft_output_61,
    input wire [15:0] fft_output_62, input wire [15:0] fft_output_63,
    output reg [15:0] mel_features_0, output reg [15:0] mel_features_1,
    output reg [15:0] mel_features_2, output reg [15:0] mel_features_3,
    output reg [15:0] mel_features_4, output reg [15:0] mel_features_5,
    output reg [15:0] mel_features_6, output reg [15:0] mel_features_7,
    output reg [15:0] mel_features_8, output reg [15:0] mel_features_9,
    output reg [15:0] mel_features_10, output reg [15:0] mel_features_11,
    output reg [15:0] mel_features_12
);

    localparam NUM_BINS = 32;
    localparam NUM_BANDS = 13;

    reg signed [15:0] bin_real [0:NUM_BINS-1];
    reg signed [15:0] bin_imag [0:NUM_BINS-1];
    reg [15:0] magnitude [0:NUM_BINS-1];   // |real| + |imag|: a cheap magnitude
                                            // estimate that avoids a sqrt, a
                                            // standard approximation in small
                                            // embedded DSP designs.
    reg signed [15:0] mel_features [0:NUM_BANDS-1];
    reg signed [15:0] mel_filter [0:NUM_BINS-1][0:NUM_BANDS-1];
    integer i, j;
    // See fft.v: (a * b) >>> N truncates a*b to 16 bits before shifting
    // unless routed through an explicitly wider temporary first.
    reg signed [31:0] product;

    initial begin
        $readmemh("mel_filter.mem", mel_filter);  // Load filter coefficients
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < NUM_BANDS; i = i + 1) begin
                mel_features[i] <= 0;
            end
        end else begin
            bin_real[0] = fft_output_0; bin_real[1] = fft_output_1;
            bin_real[2] = fft_output_2; bin_real[3] = fft_output_3;
            bin_real[4] = fft_output_4; bin_real[5] = fft_output_5;
            bin_real[6] = fft_output_6; bin_real[7] = fft_output_7;
            bin_real[8] = fft_output_8; bin_real[9] = fft_output_9;
            bin_real[10] = fft_output_10; bin_real[11] = fft_output_11;
            bin_real[12] = fft_output_12; bin_real[13] = fft_output_13;
            bin_real[14] = fft_output_14; bin_real[15] = fft_output_15;
            bin_real[16] = fft_output_16; bin_real[17] = fft_output_17;
            bin_real[18] = fft_output_18; bin_real[19] = fft_output_19;
            bin_real[20] = fft_output_20; bin_real[21] = fft_output_21;
            bin_real[22] = fft_output_22; bin_real[23] = fft_output_23;
            bin_real[24] = fft_output_24; bin_real[25] = fft_output_25;
            bin_real[26] = fft_output_26; bin_real[27] = fft_output_27;
            bin_real[28] = fft_output_28; bin_real[29] = fft_output_29;
            bin_real[30] = fft_output_30; bin_real[31] = fft_output_31;

            bin_imag[0] = fft_output_32; bin_imag[1] = fft_output_33;
            bin_imag[2] = fft_output_34; bin_imag[3] = fft_output_35;
            bin_imag[4] = fft_output_36; bin_imag[5] = fft_output_37;
            bin_imag[6] = fft_output_38; bin_imag[7] = fft_output_39;
            bin_imag[8] = fft_output_40; bin_imag[9] = fft_output_41;
            bin_imag[10] = fft_output_42; bin_imag[11] = fft_output_43;
            bin_imag[12] = fft_output_44; bin_imag[13] = fft_output_45;
            bin_imag[14] = fft_output_46; bin_imag[15] = fft_output_47;
            bin_imag[16] = fft_output_48; bin_imag[17] = fft_output_49;
            bin_imag[18] = fft_output_50; bin_imag[19] = fft_output_51;
            bin_imag[20] = fft_output_52; bin_imag[21] = fft_output_53;
            bin_imag[22] = fft_output_54; bin_imag[23] = fft_output_55;
            bin_imag[24] = fft_output_56; bin_imag[25] = fft_output_57;
            bin_imag[26] = fft_output_58; bin_imag[27] = fft_output_59;
            bin_imag[28] = fft_output_60; bin_imag[29] = fft_output_61;
            bin_imag[30] = fft_output_62; bin_imag[31] = fft_output_63;

            for (i = 0; i < NUM_BINS; i = i + 1) begin
                magnitude[i] = (bin_real[i] < 0 ? -bin_real[i] : bin_real[i])
                             + (bin_imag[i] < 0 ? -bin_imag[i] : bin_imag[i]);
            end

            // Apply Mel Filter Bank
            for (i = 0; i < NUM_BANDS; i = i + 1) begin
                mel_features[i] = 0;
                for (j = 0; j < NUM_BINS; j = j + 1) begin
                    product = magnitude[j] * mel_filter[j][i];
                    mel_features[i] = mel_features[i] + (product >>> 8);
                end
            end

            // Assign output registers
            mel_features_0 = mel_features[0]; mel_features_1 = mel_features[1];
            mel_features_2 = mel_features[2]; mel_features_3 = mel_features[3];
            mel_features_4 = mel_features[4]; mel_features_5 = mel_features[5];
            mel_features_6 = mel_features[6]; mel_features_7 = mel_features[7];
            mel_features_8 = mel_features[8]; mel_features_9 = mel_features[9];
            mel_features_10 = mel_features[10]; mel_features_11 = mel_features[11];
            mel_features_12 = mel_features[12];
        end
    end

endmodule
