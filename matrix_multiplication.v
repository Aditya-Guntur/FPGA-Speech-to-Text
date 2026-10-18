module matrix_multiplication (
    input wire clk,
    // 13 inputs, matching mel_filterbank's actual output count. This used
    // to declare 40 inputs, with top_module hardcoding 27 of them to zero
    // ("Missing connections, temporarily set to zero") because there was
    // never a stage that produced more than 13 real features - weights.mem
    // correspondingly carried 320 entries (8 neurons * 40 features), of
    // which 68% were permanently multiplied by a hardcoded zero and could
    // never affect the output. Shrinking the layer to the 13 features that
    // actually exist removes that dead weight storage and dead multiply-
    // accumulate hardware instead of masking it with wired-in zeros.
    input wire [15:0] mfcc_features_flat_0, input wire [15:0] mfcc_features_flat_1,
    input wire [15:0] mfcc_features_flat_2, input wire [15:0] mfcc_features_flat_3,
    input wire [15:0] mfcc_features_flat_4, input wire [15:0] mfcc_features_flat_5,
    input wire [15:0] mfcc_features_flat_6, input wire [15:0] mfcc_features_flat_7,
    input wire [15:0] mfcc_features_flat_8, input wire [15:0] mfcc_features_flat_9,
    input wire [15:0] mfcc_features_flat_10, input wire [15:0] mfcc_features_flat_11,
    input wire [15:0] mfcc_features_flat_12,
    output reg signed [15:0] output_probabilities_flat_0, output reg signed [15:0] output_probabilities_flat_1,
    output reg signed [15:0] output_probabilities_flat_2, output reg signed [15:0] output_probabilities_flat_3,
    output reg signed [15:0] output_probabilities_flat_4, output reg signed [15:0] output_probabilities_flat_5,
    output reg signed [15:0] output_probabilities_flat_6, output reg signed [15:0] output_probabilities_flat_7
);

    localparam NUM_FEATURES = 13;
    localparam NUM_NEURONS = 8;

    reg signed [15:0] mfcc_features [0:NUM_FEATURES-1];
    reg signed [15:0] output_probabilities [0:NUM_NEURONS-1];
    reg signed [15:0] weights_flat [0:(NUM_NEURONS*NUM_FEATURES)-1];
    reg signed [15:0] biases [0:NUM_NEURONS-1];
    integer i, j;

    initial begin
        $readmemh("weights.mem", weights_flat);
        $readmemh("biases.mem", biases);
    end

    always @(posedge clk) begin
        mfcc_features[0] = mfcc_features_flat_0; mfcc_features[1] = mfcc_features_flat_1;
        mfcc_features[2] = mfcc_features_flat_2; mfcc_features[3] = mfcc_features_flat_3;
        mfcc_features[4] = mfcc_features_flat_4; mfcc_features[5] = mfcc_features_flat_5;
        mfcc_features[6] = mfcc_features_flat_6; mfcc_features[7] = mfcc_features_flat_7;
        mfcc_features[8] = mfcc_features_flat_8; mfcc_features[9] = mfcc_features_flat_9;
        mfcc_features[10] = mfcc_features_flat_10; mfcc_features[11] = mfcc_features_flat_11;
        mfcc_features[12] = mfcc_features_flat_12;

        // Compute neuron activations
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            output_probabilities[i] = biases[i];  // Start with bias
            for (j = 0; j < NUM_FEATURES; j = j + 1) begin
                output_probabilities[i] = output_probabilities[i] + ((mfcc_features[j] * weights_flat[i * NUM_FEATURES + j]) >>> 15);
            end
        end

        // Assign output probabilities
        output_probabilities_flat_0 = output_probabilities[0];
        output_probabilities_flat_1 = output_probabilities[1];
        output_probabilities_flat_2 = output_probabilities[2];
        output_probabilities_flat_3 = output_probabilities[3];
        output_probabilities_flat_4 = output_probabilities[4];
        output_probabilities_flat_5 = output_probabilities[5];
        output_probabilities_flat_6 = output_probabilities[6];
        output_probabilities_flat_7 = output_probabilities[7];
    end

endmodule
