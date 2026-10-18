module matrix_multiplication (
    input wire clk,
    // Output layer of the classifier: 16 hidden-layer activations in,
    // 8 class scores out. Takes dense_hidden.v's (ReLU'd) output, not the
    // 13 raw Mel features directly - see dense_hidden.v for the first
    // layer. This used to be a single 40-input linear layer wired
    // straight from 13 real Mel features plus 27 hardcoded zeros; it's
    // now the second layer of an actual two-layer MLP.
    input wire [15:0] hidden_features_flat_0, input wire [15:0] hidden_features_flat_1,
    input wire [15:0] hidden_features_flat_2, input wire [15:0] hidden_features_flat_3,
    input wire [15:0] hidden_features_flat_4, input wire [15:0] hidden_features_flat_5,
    input wire [15:0] hidden_features_flat_6, input wire [15:0] hidden_features_flat_7,
    input wire [15:0] hidden_features_flat_8, input wire [15:0] hidden_features_flat_9,
    input wire [15:0] hidden_features_flat_10, input wire [15:0] hidden_features_flat_11,
    input wire [15:0] hidden_features_flat_12, input wire [15:0] hidden_features_flat_13,
    input wire [15:0] hidden_features_flat_14, input wire [15:0] hidden_features_flat_15,
    output reg signed [15:0] output_probabilities_flat_0, output reg signed [15:0] output_probabilities_flat_1,
    output reg signed [15:0] output_probabilities_flat_2, output reg signed [15:0] output_probabilities_flat_3,
    output reg signed [15:0] output_probabilities_flat_4, output reg signed [15:0] output_probabilities_flat_5,
    output reg signed [15:0] output_probabilities_flat_6, output reg signed [15:0] output_probabilities_flat_7
);

    localparam NUM_FEATURES = 16;
    localparam NUM_NEURONS = 8;

    reg signed [15:0] hidden_features [0:NUM_FEATURES-1];
    reg signed [15:0] output_probabilities [0:NUM_NEURONS-1];
    reg signed [15:0] weights_flat [0:(NUM_NEURONS*NUM_FEATURES)-1];
    reg signed [15:0] biases [0:NUM_NEURONS-1];
    integer i, j;
    // (a * b) >>> N truncates a*b to 16 bits before shifting unless routed
    // through an explicitly wider temporary first - see fft.v for the
    // worked-out example of why. This was the original bug here too: every
    // weighted sum in this layer silently wrapped instead of accumulating
    // correctly whenever a product exceeded 16 bits, which is routine for
    // 16-bit features times 16-bit weights.
    reg signed [31:0] product;

    initial begin
        $readmemh("weights.mem", weights_flat);
        $readmemh("biases.mem", biases);
    end

    always @(posedge clk) begin
        hidden_features[0] = hidden_features_flat_0; hidden_features[1] = hidden_features_flat_1;
        hidden_features[2] = hidden_features_flat_2; hidden_features[3] = hidden_features_flat_3;
        hidden_features[4] = hidden_features_flat_4; hidden_features[5] = hidden_features_flat_5;
        hidden_features[6] = hidden_features_flat_6; hidden_features[7] = hidden_features_flat_7;
        hidden_features[8] = hidden_features_flat_8; hidden_features[9] = hidden_features_flat_9;
        hidden_features[10] = hidden_features_flat_10; hidden_features[11] = hidden_features_flat_11;
        hidden_features[12] = hidden_features_flat_12; hidden_features[13] = hidden_features_flat_13;
        hidden_features[14] = hidden_features_flat_14; hidden_features[15] = hidden_features_flat_15;

        // Compute neuron activations
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            output_probabilities[i] = biases[i];  // Start with bias
            for (j = 0; j < NUM_FEATURES; j = j + 1) begin
                product = hidden_features[j] * weights_flat[i * NUM_FEATURES + j];
                output_probabilities[i] = output_probabilities[i] + (product >>> 15);
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
