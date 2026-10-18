module dense_hidden (
    input wire clk,
    // First layer of the classifier: 13 real Mel features in, 16 hidden
    // pre-activations out (ReLU is applied outside this module, by the
    // same relu.v instances used on the output layer - see top_module.v).
    // matrix_multiplication.v used to be the only layer, taking these
    // same 13 features (plus 27 hardcoded zeros) straight to 8 output
    // classes - a single linear layer, not actually a network. This adds
    // a real hidden layer ahead of it.
    input wire [15:0] mfcc_features_flat_0, input wire [15:0] mfcc_features_flat_1,
    input wire [15:0] mfcc_features_flat_2, input wire [15:0] mfcc_features_flat_3,
    input wire [15:0] mfcc_features_flat_4, input wire [15:0] mfcc_features_flat_5,
    input wire [15:0] mfcc_features_flat_6, input wire [15:0] mfcc_features_flat_7,
    input wire [15:0] mfcc_features_flat_8, input wire [15:0] mfcc_features_flat_9,
    input wire [15:0] mfcc_features_flat_10, input wire [15:0] mfcc_features_flat_11,
    input wire [15:0] mfcc_features_flat_12,
    output reg signed [15:0] hidden_flat_0, output reg signed [15:0] hidden_flat_1,
    output reg signed [15:0] hidden_flat_2, output reg signed [15:0] hidden_flat_3,
    output reg signed [15:0] hidden_flat_4, output reg signed [15:0] hidden_flat_5,
    output reg signed [15:0] hidden_flat_6, output reg signed [15:0] hidden_flat_7,
    output reg signed [15:0] hidden_flat_8, output reg signed [15:0] hidden_flat_9,
    output reg signed [15:0] hidden_flat_10, output reg signed [15:0] hidden_flat_11,
    output reg signed [15:0] hidden_flat_12, output reg signed [15:0] hidden_flat_13,
    output reg signed [15:0] hidden_flat_14, output reg signed [15:0] hidden_flat_15
);

    localparam NUM_FEATURES = 13;
    localparam NUM_NEURONS = 16;

    reg signed [15:0] mfcc_features [0:NUM_FEATURES-1];
    reg signed [15:0] hidden [0:NUM_NEURONS-1];
    reg signed [15:0] weights_flat [0:(NUM_NEURONS*NUM_FEATURES)-1];
    reg signed [15:0] biases [0:NUM_NEURONS-1];
    integer i, j;
    reg signed [31:0] product; // see fft.v for why this has to be explicit

    initial begin
        $readmemh("hidden_weights.mem", weights_flat);
        $readmemh("hidden_biases.mem", biases);
    end

    always @(posedge clk) begin
        mfcc_features[0] = mfcc_features_flat_0; mfcc_features[1] = mfcc_features_flat_1;
        mfcc_features[2] = mfcc_features_flat_2; mfcc_features[3] = mfcc_features_flat_3;
        mfcc_features[4] = mfcc_features_flat_4; mfcc_features[5] = mfcc_features_flat_5;
        mfcc_features[6] = mfcc_features_flat_6; mfcc_features[7] = mfcc_features_flat_7;
        mfcc_features[8] = mfcc_features_flat_8; mfcc_features[9] = mfcc_features_flat_9;
        mfcc_features[10] = mfcc_features_flat_10; mfcc_features[11] = mfcc_features_flat_11;
        mfcc_features[12] = mfcc_features_flat_12;

        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            hidden[i] = biases[i];
            for (j = 0; j < NUM_FEATURES; j = j + 1) begin
                product = mfcc_features[j] * weights_flat[i * NUM_FEATURES + j];
                hidden[i] = hidden[i] + (product >>> 15);
            end
        end

        hidden_flat_0 = hidden[0];   hidden_flat_1 = hidden[1];
        hidden_flat_2 = hidden[2];   hidden_flat_3 = hidden[3];
        hidden_flat_4 = hidden[4];   hidden_flat_5 = hidden[5];
        hidden_flat_6 = hidden[6];   hidden_flat_7 = hidden[7];
        hidden_flat_8 = hidden[8];   hidden_flat_9 = hidden[9];
        hidden_flat_10 = hidden[10]; hidden_flat_11 = hidden[11];
        hidden_flat_12 = hidden[12]; hidden_flat_13 = hidden[13];
        hidden_flat_14 = hidden[14]; hidden_flat_15 = hidden[15];
    end

endmodule
