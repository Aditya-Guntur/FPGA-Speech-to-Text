`timescale 1ns / 1ps

module gain_normalize_tb;
    reg clk;
    reg signed [15:0] seg [0:77];
    wire signed [15:0] norm [0:77];

    gain_normalize uut (
        .clk(clk),
        .segment_features_0(seg[0]), .segment_features_1(seg[1]), .segment_features_2(seg[2]), .segment_features_3(seg[3]),
        .segment_features_4(seg[4]), .segment_features_5(seg[5]), .segment_features_6(seg[6]), .segment_features_7(seg[7]),
        .segment_features_8(seg[8]), .segment_features_9(seg[9]), .segment_features_10(seg[10]), .segment_features_11(seg[11]),
        .segment_features_12(seg[12]), .segment_features_13(seg[13]), .segment_features_14(seg[14]), .segment_features_15(seg[15]),
        .segment_features_16(seg[16]), .segment_features_17(seg[17]), .segment_features_18(seg[18]), .segment_features_19(seg[19]),
        .segment_features_20(seg[20]), .segment_features_21(seg[21]), .segment_features_22(seg[22]), .segment_features_23(seg[23]),
        .segment_features_24(seg[24]), .segment_features_25(seg[25]), .segment_features_26(seg[26]), .segment_features_27(seg[27]),
        .segment_features_28(seg[28]), .segment_features_29(seg[29]), .segment_features_30(seg[30]), .segment_features_31(seg[31]),
        .segment_features_32(seg[32]), .segment_features_33(seg[33]), .segment_features_34(seg[34]), .segment_features_35(seg[35]),
        .segment_features_36(seg[36]), .segment_features_37(seg[37]), .segment_features_38(seg[38]), .segment_features_39(seg[39]),
        .segment_features_40(seg[40]), .segment_features_41(seg[41]), .segment_features_42(seg[42]), .segment_features_43(seg[43]),
        .segment_features_44(seg[44]), .segment_features_45(seg[45]), .segment_features_46(seg[46]), .segment_features_47(seg[47]),
        .segment_features_48(seg[48]), .segment_features_49(seg[49]), .segment_features_50(seg[50]), .segment_features_51(seg[51]),
        .segment_features_52(seg[52]), .segment_features_53(seg[53]), .segment_features_54(seg[54]), .segment_features_55(seg[55]),
        .segment_features_56(seg[56]), .segment_features_57(seg[57]), .segment_features_58(seg[58]), .segment_features_59(seg[59]),
        .segment_features_60(seg[60]), .segment_features_61(seg[61]), .segment_features_62(seg[62]), .segment_features_63(seg[63]),
        .segment_features_64(seg[64]), .segment_features_65(seg[65]), .segment_features_66(seg[66]), .segment_features_67(seg[67]),
        .segment_features_68(seg[68]), .segment_features_69(seg[69]), .segment_features_70(seg[70]), .segment_features_71(seg[71]),
        .segment_features_72(seg[72]), .segment_features_73(seg[73]), .segment_features_74(seg[74]), .segment_features_75(seg[75]),
        .segment_features_76(seg[76]), .segment_features_77(seg[77]),
        .normalized_features_0(norm[0]), .normalized_features_12(norm[12]), .normalized_features_65(norm[65])
    );

    integer i;
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        // Case 1: every feature = 400. Sum = 78*400 = 31200 (~2^14.9), close
        // to the TARGET_LOG2=15 reference, so shift should land near 0 and
        // each output should stay close to 400.
        for (i = 0; i < 78; i = i + 1) seg[i] = 400;
        @(posedge clk); #1;
        $display("quiet clip (sum~31200, near target): norm[0]=%d (expect close to 400)", norm[0]);

        // Case 2: every feature = 50 (sum = 3900, ~2^11.9 - 3 bits below
        // target). Expect an upward shift (louder output) to compensate.
        for (i = 0; i < 78; i = i + 1) seg[i] = 50;
        @(posedge clk); #1;
        $display("quiet clip (sum~3900, 3 bits under target): norm[0]=%d (expect ~ 8x of 50 = 400, shift clipped to +3)", norm[0]);

        // Case 3: every feature = 6000 (sum = 468000, ~2^18.8 - way above
        // target). Expect a downward shift (quieter output) to compensate.
        for (i = 0; i < 78; i = i + 1) seg[i] = 6000;
        @(posedge clk); #1;
        $display("loud clip (sum~468000, well over target): norm[0]=%d (expect roughly 1/8 of 6000 = 750, shift clipped to -3)", norm[0]);

        // Case 4: all-zero clip (silence) - must not divide-by-zero/garbage.
        for (i = 0; i < 78; i = i + 1) seg[i] = 0;
        @(posedge clk); #1;
        $display("silence: norm[0]=%d (expect 0)", norm[0]);
        $finish;
    end
endmodule
