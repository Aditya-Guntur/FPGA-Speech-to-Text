`timescale 1ns / 1ps

module matrix_multiplication_tb;
    reg clk;
    reg [15:0] hidden_features_flat_0, hidden_features_flat_1;
    reg [15:0] hidden_features_flat_2, hidden_features_flat_3;
    reg [15:0] hidden_features_flat_4, hidden_features_flat_5;
    reg [15:0] hidden_features_flat_6, hidden_features_flat_7;
    reg [15:0] hidden_features_flat_8, hidden_features_flat_9;
    reg [15:0] hidden_features_flat_10, hidden_features_flat_11;
    reg [15:0] hidden_features_flat_12, hidden_features_flat_13;
    reg [15:0] hidden_features_flat_14, hidden_features_flat_15;

    wire signed [15:0] output_probabilities_flat_0, output_probabilities_flat_1;
    wire signed [15:0] output_probabilities_flat_2, output_probabilities_flat_3;
    wire signed [15:0] output_probabilities_flat_4, output_probabilities_flat_5;
    wire signed [15:0] output_probabilities_flat_6, output_probabilities_flat_7;

    // Instantiate the matrix_multiplication module (classifier output layer)
    matrix_multiplication uut (
        .clk(clk),
        .hidden_features_flat_0(hidden_features_flat_0), .hidden_features_flat_1(hidden_features_flat_1),
        .hidden_features_flat_2(hidden_features_flat_2), .hidden_features_flat_3(hidden_features_flat_3),
        .hidden_features_flat_4(hidden_features_flat_4), .hidden_features_flat_5(hidden_features_flat_5),
        .hidden_features_flat_6(hidden_features_flat_6), .hidden_features_flat_7(hidden_features_flat_7),
        .hidden_features_flat_8(hidden_features_flat_8), .hidden_features_flat_9(hidden_features_flat_9),
        .hidden_features_flat_10(hidden_features_flat_10), .hidden_features_flat_11(hidden_features_flat_11),
        .hidden_features_flat_12(hidden_features_flat_12), .hidden_features_flat_13(hidden_features_flat_13),
        .hidden_features_flat_14(hidden_features_flat_14), .hidden_features_flat_15(hidden_features_flat_15),
        .output_probabilities_flat_0(output_probabilities_flat_0),
        .output_probabilities_flat_1(output_probabilities_flat_1),
        .output_probabilities_flat_2(output_probabilities_flat_2),
        .output_probabilities_flat_3(output_probabilities_flat_3),
        .output_probabilities_flat_4(output_probabilities_flat_4),
        .output_probabilities_flat_5(output_probabilities_flat_5),
        .output_probabilities_flat_6(output_probabilities_flat_6),
        .output_probabilities_flat_7(output_probabilities_flat_7)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock (10ns period)

    initial begin
        // Initialize
        clk = 0;
        hidden_features_flat_0 = 16'd10; hidden_features_flat_1 = 16'd20;
        hidden_features_flat_2 = 16'd30; hidden_features_flat_3 = 16'd40;
        hidden_features_flat_4 = 16'd50; hidden_features_flat_5 = 16'd60;
        hidden_features_flat_6 = 16'd70; hidden_features_flat_7 = 16'd80;
        hidden_features_flat_8 = 16'd90; hidden_features_flat_9 = 16'd100;
        hidden_features_flat_10 = 16'd110; hidden_features_flat_11 = 16'd120;
        hidden_features_flat_12 = 16'd130; hidden_features_flat_13 = 16'd140;
        hidden_features_flat_14 = 16'd150; hidden_features_flat_15 = 16'd160;

        // Let the module process the inputs
        #100;

        // Stop simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %t | P_0 = %d | P_1 = %d | P_2 = %d | P_3 = %d | P_4 = %d | P_5 = %d | P_6 = %d | P_7 = %d",
                 $time, output_probabilities_flat_0, output_probabilities_flat_1,
                 output_probabilities_flat_2, output_probabilities_flat_3,
                 output_probabilities_flat_4, output_probabilities_flat_5,
                 output_probabilities_flat_6, output_probabilities_flat_7);
    end
endmodule
