module mel_filterbank (
    input wire clk,
    input wire rst,
    // fft_output_0..7 = real part of DFT bins 0..7, fft_output_8..15 =
    // imaginary part of the same bins (see fft.v) - fft.v now computes an
    // actual DFT instead of its earlier sum/difference placeholder, so
    // this module's job starts with turning those real/imaginary pairs
    // into a magnitude spectrum before Mel-weighting it.
    input wire [15:0] fft_output_0, input wire [15:0] fft_output_1,
    input wire [15:0] fft_output_2, input wire [15:0] fft_output_3,
    input wire [15:0] fft_output_4, input wire [15:0] fft_output_5,
    input wire [15:0] fft_output_6, input wire [15:0] fft_output_7,
    input wire [15:0] fft_output_8, input wire [15:0] fft_output_9,
    input wire [15:0] fft_output_10, input wire [15:0] fft_output_11,
    input wire [15:0] fft_output_12, input wire [15:0] fft_output_13,
    input wire [15:0] fft_output_14, input wire [15:0] fft_output_15,
    output reg [15:0] mel_features_0, output reg [15:0] mel_features_1,
    output reg [15:0] mel_features_2, output reg [15:0] mel_features_3,
    output reg [15:0] mel_features_4, output reg [15:0] mel_features_5,
    output reg [15:0] mel_features_6, output reg [15:0] mel_features_7,
    output reg [15:0] mel_features_8, output reg [15:0] mel_features_9,
    output reg [15:0] mel_features_10, output reg [15:0] mel_features_11,
    output reg [15:0] mel_features_12
);

    localparam NUM_BINS = 8;
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

            bin_imag[0] = fft_output_8;  bin_imag[1] = fft_output_9;
            bin_imag[2] = fft_output_10; bin_imag[3] = fft_output_11;
            bin_imag[4] = fft_output_12; bin_imag[5] = fft_output_13;
            bin_imag[6] = fft_output_14; bin_imag[7] = fft_output_15;

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
