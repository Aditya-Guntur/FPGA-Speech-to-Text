// Top Module (Keyword Detection System)
module top_module (
    input wire clk,
    input wire rst,
    output wire [3:0] keyword_id, // Detected keyword (debounced)

    output reg led_r,  // Red LED
    output reg led_g,  // Green LED
    output reg led_b   // Blue LED

    );
    wire [15:0] fft_input;
    wire [15:0] fft_out_0, fft_out_1, fft_out_2, fft_out_3;
    wire [15:0] fft_out_4, fft_out_5, fft_out_6, fft_out_7;
    wire [15:0] fft_out_8, fft_out_9, fft_out_10, fft_out_11;
    wire [15:0] fft_out_12, fft_out_13, fft_out_14, fft_out_15;

    wire [15:0] mel_out_0, mel_out_1, mel_out_2, mel_out_3;
    wire [15:0] mel_out_4, mel_out_5, mel_out_6, mel_out_7;
    wire [15:0] mel_out_8, mel_out_9, mel_out_10, mel_out_11, mel_out_12;


    wire [15:0] hidden_0, hidden_1, hidden_2, hidden_3;
    wire [15:0] hidden_4, hidden_5, hidden_6, hidden_7;
    wire [15:0] hidden_8, hidden_9, hidden_10, hidden_11;
    wire [15:0] hidden_12, hidden_13, hidden_14, hidden_15;

    wire [15:0] hidden_relu_0, hidden_relu_1, hidden_relu_2, hidden_relu_3;
    wire [15:0] hidden_relu_4, hidden_relu_5, hidden_relu_6, hidden_relu_7;
    wire [15:0] hidden_relu_8, hidden_relu_9, hidden_relu_10, hidden_relu_11;
    wire [15:0] hidden_relu_12, hidden_relu_13, hidden_relu_14, hidden_relu_15;

    wire [15:0] relu_out_0, relu_out_1, relu_out_2, relu_out_3;
    wire [15:0] relu_out_4, relu_out_5, relu_out_6, relu_out_7;

    wire [15:0] nn_out_0, nn_out_1, nn_out_2, nn_out_3;
    wire [15:0] nn_out_4, nn_out_5, nn_out_6, nn_out_7;

    wire [15:0] softmax_out_0, softmax_out_1, softmax_out_2, softmax_out_3;
    wire [15:0] softmax_out_4, softmax_out_5, softmax_out_6, softmax_out_7;

    wire [3:0] raw_keyword_id;
    wire [3:0] debounce_keyword_id;

    // Preprocessing Module (Pre-emphasis & Hamming Window)
   preprocessing preprocess_inst (
    .clk(clk),
    .rst(rst),
    .audio_out(fft_input)  // Sending audio sample to FFT
);



    // FFT Module
    fft fft_inst (
        .clk(clk),
        .audio_in(fft_input),
        .fft_output_0(fft_out_0), .fft_output_1(fft_out_1),
        .fft_output_2(fft_out_2), .fft_output_3(fft_out_3),
        .fft_output_4(fft_out_4), .fft_output_5(fft_out_5),
        .fft_output_6(fft_out_6), .fft_output_7(fft_out_7),
        .fft_output_8(fft_out_8), .fft_output_9(fft_out_9),
        .fft_output_10(fft_out_10), .fft_output_11(fft_out_11),
        .fft_output_12(fft_out_12), .fft_output_13(fft_out_13),
        .fft_output_14(fft_out_14), .fft_output_15(fft_out_15)
    );

    // Mel Filterbank Module
    mel_filterbank mel_inst (
        .clk(clk), .rst(rst),
        .fft_output_0(fft_out_0), .fft_output_1(fft_out_1),
        .fft_output_2(fft_out_2), .fft_output_3(fft_out_3),
        .fft_output_4(fft_out_4), .fft_output_5(fft_out_5),
        .fft_output_6(fft_out_6), .fft_output_7(fft_out_7),
        .fft_output_8(fft_out_8), .fft_output_9(fft_out_9),
        .fft_output_10(fft_out_10), .fft_output_11(fft_out_11),
        .fft_output_12(fft_out_12), .fft_output_13(fft_out_13),
        .fft_output_14(fft_out_14), .fft_output_15(fft_out_15),
        .mel_features_0(mel_out_0), .mel_features_1(mel_out_1),
        .mel_features_2(mel_out_2), .mel_features_3(mel_out_3),
        .mel_features_4(mel_out_4), .mel_features_5(mel_out_5),
        .mel_features_6(mel_out_6), .mel_features_7(mel_out_7),
        .mel_features_8(mel_out_8), .mel_features_9(mel_out_9),
        .mel_features_10(mel_out_10), .mel_features_11(mel_out_11),
        .mel_features_12(mel_out_12)
    );

    // Hidden Layer - 13 real Mel features in, 16 hidden pre-activations
    // out. The classifier used to be a single linear layer straight from
    // features to class scores; this is the first layer of an actual
    // two-layer MLP, same ReLU module reused for its activation below.
    dense_hidden hidden_inst (
        .clk(clk),

        .mfcc_features_flat_0(mel_out_0), .mfcc_features_flat_1(mel_out_1),
        .mfcc_features_flat_2(mel_out_2), .mfcc_features_flat_3(mel_out_3),
        .mfcc_features_flat_4(mel_out_4), .mfcc_features_flat_5(mel_out_5),
        .mfcc_features_flat_6(mel_out_6), .mfcc_features_flat_7(mel_out_7),
        .mfcc_features_flat_8(mel_out_8), .mfcc_features_flat_9(mel_out_9),
        .mfcc_features_flat_10(mel_out_10), .mfcc_features_flat_11(mel_out_11),
        .mfcc_features_flat_12(mel_out_12),

        .hidden_flat_0(hidden_0), .hidden_flat_1(hidden_1),
        .hidden_flat_2(hidden_2), .hidden_flat_3(hidden_3),
        .hidden_flat_4(hidden_4), .hidden_flat_5(hidden_5),
        .hidden_flat_6(hidden_6), .hidden_flat_7(hidden_7),
        .hidden_flat_8(hidden_8), .hidden_flat_9(hidden_9),
        .hidden_flat_10(hidden_10), .hidden_flat_11(hidden_11),
        .hidden_flat_12(hidden_12), .hidden_flat_13(hidden_13),
        .hidden_flat_14(hidden_14), .hidden_flat_15(hidden_15)
    );

    // Hidden-layer ReLU activation, 16 units.
    relu hidden_relu_inst_0(.clk(clk), .nn_input(hidden_0), .relu_output(hidden_relu_0));
    relu hidden_relu_inst_1(.clk(clk), .nn_input(hidden_1), .relu_output(hidden_relu_1));
    relu hidden_relu_inst_2(.clk(clk), .nn_input(hidden_2), .relu_output(hidden_relu_2));
    relu hidden_relu_inst_3(.clk(clk), .nn_input(hidden_3), .relu_output(hidden_relu_3));
    relu hidden_relu_inst_4(.clk(clk), .nn_input(hidden_4), .relu_output(hidden_relu_4));
    relu hidden_relu_inst_5(.clk(clk), .nn_input(hidden_5), .relu_output(hidden_relu_5));
    relu hidden_relu_inst_6(.clk(clk), .nn_input(hidden_6), .relu_output(hidden_relu_6));
    relu hidden_relu_inst_7(.clk(clk), .nn_input(hidden_7), .relu_output(hidden_relu_7));
    relu hidden_relu_inst_8(.clk(clk), .nn_input(hidden_8), .relu_output(hidden_relu_8));
    relu hidden_relu_inst_9(.clk(clk), .nn_input(hidden_9), .relu_output(hidden_relu_9));
    relu hidden_relu_inst_10(.clk(clk), .nn_input(hidden_10), .relu_output(hidden_relu_10));
    relu hidden_relu_inst_11(.clk(clk), .nn_input(hidden_11), .relu_output(hidden_relu_11));
    relu hidden_relu_inst_12(.clk(clk), .nn_input(hidden_12), .relu_output(hidden_relu_12));
    relu hidden_relu_inst_13(.clk(clk), .nn_input(hidden_13), .relu_output(hidden_relu_13));
    relu hidden_relu_inst_14(.clk(clk), .nn_input(hidden_14), .relu_output(hidden_relu_14));
    relu hidden_relu_inst_15(.clk(clk), .nn_input(hidden_15), .relu_output(hidden_relu_15));

    // Output Layer - 16 hidden activations in, 8 class scores out.
   matrix_multiplication nn_inst (
    .clk(clk),

    .hidden_features_flat_0(hidden_relu_0), .hidden_features_flat_1(hidden_relu_1),
    .hidden_features_flat_2(hidden_relu_2), .hidden_features_flat_3(hidden_relu_3),
    .hidden_features_flat_4(hidden_relu_4), .hidden_features_flat_5(hidden_relu_5),
    .hidden_features_flat_6(hidden_relu_6), .hidden_features_flat_7(hidden_relu_7),
    .hidden_features_flat_8(hidden_relu_8), .hidden_features_flat_9(hidden_relu_9),
    .hidden_features_flat_10(hidden_relu_10), .hidden_features_flat_11(hidden_relu_11),
    .hidden_features_flat_12(hidden_relu_12), .hidden_features_flat_13(hidden_relu_13),
    .hidden_features_flat_14(hidden_relu_14), .hidden_features_flat_15(hidden_relu_15),

    .output_probabilities_flat_0(nn_out_0), .output_probabilities_flat_1(nn_out_1),
    .output_probabilities_flat_2(nn_out_2), .output_probabilities_flat_3(nn_out_3),
    .output_probabilities_flat_4(nn_out_4), .output_probabilities_flat_5(nn_out_5),
    .output_probabilities_flat_6(nn_out_6), .output_probabilities_flat_7(nn_out_7)
);



    // Output-layer ReLU Activation - takes each neuron's raw output, feeds
    // the clamped result to relu_out_X below. Previously wired to
    // nn_input_X / relu_output_X, neither of which was declared anywhere,
    // so Verilog silently auto-created them as unconnected 1-bit wires:
    // ReLU computed into a void and softmax ran on raw unactivated values
    // instead.
    relu relu_inst_0(.clk(clk), .nn_input(nn_out_0), .relu_output(relu_out_0));
    relu relu_inst_1(.clk(clk), .nn_input(nn_out_1), .relu_output(relu_out_1));
    relu relu_inst_2(.clk(clk), .nn_input(nn_out_2), .relu_output(relu_out_2));
    relu relu_inst_3(.clk(clk), .nn_input(nn_out_3), .relu_output(relu_out_3));
    relu relu_inst_4(.clk(clk), .nn_input(nn_out_4), .relu_output(relu_out_4));
    relu relu_inst_5(.clk(clk), .nn_input(nn_out_5), .relu_output(relu_out_5));
    relu relu_inst_6(.clk(clk), .nn_input(nn_out_6), .relu_output(relu_out_6));
    relu relu_inst_7(.clk(clk), .nn_input(nn_out_7), .relu_output(relu_out_7));



    // Softmax Module - now actually reads the ReLU outputs instead of the
    // raw neuron outputs.
    softmax_lut softmax_inst (
        .clk(clk),
        .input_values_0(relu_out_0), .input_values_1(relu_out_1),
        .input_values_2(relu_out_2), .input_values_3(relu_out_3),
        .input_values_4(relu_out_4), .input_values_5(relu_out_5),
        .input_values_6(relu_out_6), .input_values_7(relu_out_7),
        .output_probabilities_0(softmax_out_0), .output_probabilities_1(softmax_out_1),
        .output_probabilities_2(softmax_out_2), .output_probabilities_3(softmax_out_3),
        .output_probabilities_4(softmax_out_4), .output_probabilities_5(softmax_out_5),
        .output_probabilities_6(softmax_out_6), .output_probabilities_7(softmax_out_7)
    );


    // Postprocessing (Debouncing). keyword_output is 4 bits - debounce_keyword_id
    // used to be declared as a bare 1-bit wire, so only its LSB ever connected
    // and the other 3 bits of the debounced result went nowhere. The debounced
    // value is also now what actually drives keyword_id and the LEDs below,
    // instead of being computed and discarded.
    debounce debounce_inst (
        .clk(clk),
        .rst(rst),
        .keyword_input(raw_keyword_id),
        .keyword_output(debounce_keyword_id)
    );

    assign keyword_id = debounce_keyword_id;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        led_r <= 0;
        led_g <= 0;
        led_b <= 0;
    end else begin
        case (debounce_keyword_id)
            4'd0: {led_r, led_g, led_b} <= 3'b000;  // OFF → Up
            4'd1: {led_r, led_g, led_b} <= 3'b100;  // RED → Down
            4'd2: {led_r, led_g, led_b} <= 3'b010;  // GREEN → Right
            4'd3: {led_r, led_g, led_b} <= 3'b001;  // BLUE → Left
            4'd4: {led_r, led_g, led_b} <= 3'b110;  // YELLOW → Stop
            4'd5: {led_r, led_g, led_b} <= 3'b011;  // CYAN → Go
            4'd6: {led_r, led_g, led_b} <= 3'b101;  // MAGENTA → Yes
            4'd7: {led_r, led_g, led_b} <= 3'b111;  // WHITE → No
            4'd8: {led_r, led_g, led_b} <= clk ? 3'b100 : 3'b000; // BLINKING RED → reserved
            4'd9: {led_r, led_g, led_b} <= clk ? 3'b010 : 3'b000; // BLINKING GREEN → reserved
            default: {led_r, led_g, led_b} <= 3'b000;  // Default OFF
        endcase
    end
end


     // Classification (Select highest probability output)
    assign raw_keyword_id = ( $unsigned(softmax_out_0) >= $unsigned(softmax_out_1) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_2) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_3) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_4) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_5) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_0) >= $unsigned(softmax_out_7) ) ? 4'd0 :
                    ( $unsigned(softmax_out_1) >= $unsigned(softmax_out_2) &&
                      $unsigned(softmax_out_1) >= $unsigned(softmax_out_3) &&
                      $unsigned(softmax_out_1) >= $unsigned(softmax_out_4) &&
                      $unsigned(softmax_out_1) >= $unsigned(softmax_out_5) &&
                      $unsigned(softmax_out_1) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_1) >= $unsigned(softmax_out_7) ) ? 4'd1 :
                    ( $unsigned(softmax_out_2) >= $unsigned(softmax_out_3) &&
                      $unsigned(softmax_out_2) >= $unsigned(softmax_out_4) &&
                      $unsigned(softmax_out_2) >= $unsigned(softmax_out_5) &&
                      $unsigned(softmax_out_2) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_2) >= $unsigned(softmax_out_7) ) ? 4'd2 :
                    ( $unsigned(softmax_out_3) >= $unsigned(softmax_out_4) &&
                      $unsigned(softmax_out_3) >= $unsigned(softmax_out_5) &&
                      $unsigned(softmax_out_3) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_3) >= $unsigned(softmax_out_7) ) ? 4'd3 :
                    ( $unsigned(softmax_out_4) >= $unsigned(softmax_out_5) &&
                      $unsigned(softmax_out_4) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_4) >= $unsigned(softmax_out_7) ) ? 4'd4 :
                    ( $unsigned(softmax_out_5) >= $unsigned(softmax_out_6) &&
                      $unsigned(softmax_out_5) >= $unsigned(softmax_out_7) ) ? 4'd5 :
                    ( $unsigned(softmax_out_6) >= $unsigned(softmax_out_7) ) ? 4'd6 : 4'd7;



endmodule
