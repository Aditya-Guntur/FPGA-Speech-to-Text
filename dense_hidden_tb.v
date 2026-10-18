`timescale 1ns / 1ps

module dense_hidden_tb;
    reg clk;
    reg [15:0] mfcc_features_flat_0, mfcc_features_flat_1;
    reg [15:0] mfcc_features_flat_2, mfcc_features_flat_3;
    reg [15:0] mfcc_features_flat_4, mfcc_features_flat_5;
    reg [15:0] mfcc_features_flat_6, mfcc_features_flat_7;
    reg [15:0] mfcc_features_flat_8, mfcc_features_flat_9;
    reg [15:0] mfcc_features_flat_10, mfcc_features_flat_11;
    reg [15:0] mfcc_features_flat_12;

    wire signed [15:0] hidden_flat_0, hidden_flat_1, hidden_flat_2, hidden_flat_3;
    wire signed [15:0] hidden_flat_4, hidden_flat_5, hidden_flat_6, hidden_flat_7;
    wire signed [15:0] hidden_flat_8, hidden_flat_9, hidden_flat_10, hidden_flat_11;
    wire signed [15:0] hidden_flat_12, hidden_flat_13, hidden_flat_14, hidden_flat_15;

    dense_hidden uut (
        .clk(clk),
        .mfcc_features_flat_0(mfcc_features_flat_0), .mfcc_features_flat_1(mfcc_features_flat_1),
        .mfcc_features_flat_2(mfcc_features_flat_2), .mfcc_features_flat_3(mfcc_features_flat_3),
        .mfcc_features_flat_4(mfcc_features_flat_4), .mfcc_features_flat_5(mfcc_features_flat_5),
        .mfcc_features_flat_6(mfcc_features_flat_6), .mfcc_features_flat_7(mfcc_features_flat_7),
        .mfcc_features_flat_8(mfcc_features_flat_8), .mfcc_features_flat_9(mfcc_features_flat_9),
        .mfcc_features_flat_10(mfcc_features_flat_10), .mfcc_features_flat_11(mfcc_features_flat_11),
        .mfcc_features_flat_12(mfcc_features_flat_12),
        .hidden_flat_0(hidden_flat_0), .hidden_flat_1(hidden_flat_1),
        .hidden_flat_2(hidden_flat_2), .hidden_flat_3(hidden_flat_3),
        .hidden_flat_4(hidden_flat_4), .hidden_flat_5(hidden_flat_5),
        .hidden_flat_6(hidden_flat_6), .hidden_flat_7(hidden_flat_7),
        .hidden_flat_8(hidden_flat_8), .hidden_flat_9(hidden_flat_9),
        .hidden_flat_10(hidden_flat_10), .hidden_flat_11(hidden_flat_11),
        .hidden_flat_12(hidden_flat_12), .hidden_flat_13(hidden_flat_13),
        .hidden_flat_14(hidden_flat_14), .hidden_flat_15(hidden_flat_15)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mfcc_features_flat_0 = 16'd10; mfcc_features_flat_1 = 16'd20;
        mfcc_features_flat_2 = 16'd30; mfcc_features_flat_3 = 16'd40;
        mfcc_features_flat_4 = 16'd50; mfcc_features_flat_5 = 16'd60;
        mfcc_features_flat_6 = 16'd70; mfcc_features_flat_7 = 16'd80;
        mfcc_features_flat_8 = 16'd90; mfcc_features_flat_9 = 16'd100;
        mfcc_features_flat_10 = 16'd110; mfcc_features_flat_11 = 16'd120;
        mfcc_features_flat_12 = 16'd130;

        #100;
        $finish;
    end

    initial begin
        $monitor("Time = %t | H0 = %d | H5 = %d | H10 = %d | H15 = %d",
                 $time, hidden_flat_0, hidden_flat_5, hidden_flat_10, hidden_flat_15);
    end
endmodule
