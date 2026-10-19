`timescale 1ns / 1ps

module tb_mel_filterbank;

    reg clk;
    reg rst;
    reg [15:0] fft_output_0, fft_output_1, fft_output_2, fft_output_3;
    reg [15:0] fft_output_4, fft_output_5, fft_output_6, fft_output_7;
    reg [15:0] fft_output_8, fft_output_9, fft_output_10, fft_output_11;
    reg [15:0] fft_output_12, fft_output_13, fft_output_14, fft_output_15;
    reg [15:0] fft_output_16, fft_output_17, fft_output_18, fft_output_19;
    reg [15:0] fft_output_20, fft_output_21, fft_output_22, fft_output_23;
    reg [15:0] fft_output_24, fft_output_25, fft_output_26, fft_output_27;
    reg [15:0] fft_output_28, fft_output_29, fft_output_30, fft_output_31;
    reg [15:0] fft_output_32, fft_output_33, fft_output_34, fft_output_35;
    reg [15:0] fft_output_36, fft_output_37, fft_output_38, fft_output_39;
    reg [15:0] fft_output_40, fft_output_41, fft_output_42, fft_output_43;
    reg [15:0] fft_output_44, fft_output_45, fft_output_46, fft_output_47;
    reg [15:0] fft_output_48, fft_output_49, fft_output_50, fft_output_51;
    reg [15:0] fft_output_52, fft_output_53, fft_output_54, fft_output_55;
    reg [15:0] fft_output_56, fft_output_57, fft_output_58, fft_output_59;
    reg [15:0] fft_output_60, fft_output_61, fft_output_62, fft_output_63;

    wire [15:0] mel_features_0, mel_features_1, mel_features_2, mel_features_3;
    wire [15:0] mel_features_4, mel_features_5, mel_features_6, mel_features_7;
    wire [15:0] mel_features_8, mel_features_9, mel_features_10, mel_features_11;
    wire [15:0] mel_features_12;

    mel_filterbank uut (
        .clk(clk),
        .rst(rst),
        .fft_output_0(fft_output_0),
        .fft_output_1(fft_output_1),
        .fft_output_2(fft_output_2),
        .fft_output_3(fft_output_3),
        .fft_output_4(fft_output_4),
        .fft_output_5(fft_output_5),
        .fft_output_6(fft_output_6),
        .fft_output_7(fft_output_7),
        .fft_output_8(fft_output_8),
        .fft_output_9(fft_output_9),
        .fft_output_10(fft_output_10),
        .fft_output_11(fft_output_11),
        .fft_output_12(fft_output_12),
        .fft_output_13(fft_output_13),
        .fft_output_14(fft_output_14),
        .fft_output_15(fft_output_15),
        .fft_output_16(fft_output_16),
        .fft_output_17(fft_output_17),
        .fft_output_18(fft_output_18),
        .fft_output_19(fft_output_19),
        .fft_output_20(fft_output_20),
        .fft_output_21(fft_output_21),
        .fft_output_22(fft_output_22),
        .fft_output_23(fft_output_23),
        .fft_output_24(fft_output_24),
        .fft_output_25(fft_output_25),
        .fft_output_26(fft_output_26),
        .fft_output_27(fft_output_27),
        .fft_output_28(fft_output_28),
        .fft_output_29(fft_output_29),
        .fft_output_30(fft_output_30),
        .fft_output_31(fft_output_31),
        .fft_output_32(fft_output_32),
        .fft_output_33(fft_output_33),
        .fft_output_34(fft_output_34),
        .fft_output_35(fft_output_35),
        .fft_output_36(fft_output_36),
        .fft_output_37(fft_output_37),
        .fft_output_38(fft_output_38),
        .fft_output_39(fft_output_39),
        .fft_output_40(fft_output_40),
        .fft_output_41(fft_output_41),
        .fft_output_42(fft_output_42),
        .fft_output_43(fft_output_43),
        .fft_output_44(fft_output_44),
        .fft_output_45(fft_output_45),
        .fft_output_46(fft_output_46),
        .fft_output_47(fft_output_47),
        .fft_output_48(fft_output_48),
        .fft_output_49(fft_output_49),
        .fft_output_50(fft_output_50),
        .fft_output_51(fft_output_51),
        .fft_output_52(fft_output_52),
        .fft_output_53(fft_output_53),
        .fft_output_54(fft_output_54),
        .fft_output_55(fft_output_55),
        .fft_output_56(fft_output_56),
        .fft_output_57(fft_output_57),
        .fft_output_58(fft_output_58),
        .fft_output_59(fft_output_59),
        .fft_output_60(fft_output_60),
        .fft_output_61(fft_output_61),
        .fft_output_62(fft_output_62),
        .fft_output_63(fft_output_63),
        .mel_features_0(mel_features_0),
        .mel_features_1(mel_features_1),
        .mel_features_2(mel_features_2),
        .mel_features_3(mel_features_3),
        .mel_features_4(mel_features_4),
        .mel_features_5(mel_features_5),
        .mel_features_6(mel_features_6),
        .mel_features_7(mel_features_7),
        .mel_features_8(mel_features_8),
        .mel_features_9(mel_features_9),
        .mel_features_10(mel_features_10),
        .mel_features_11(mel_features_11),
        .mel_features_12(mel_features_12)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        fft_output_0 = 16'd0;
        fft_output_1 = 16'd0;
        fft_output_2 = 16'd0;
        fft_output_3 = 16'd0;
        fft_output_4 = 16'd0;
        fft_output_5 = 16'd0;
        fft_output_6 = 16'd0;
        fft_output_7 = 16'd0;
        fft_output_8 = 16'd0;
        fft_output_9 = 16'd0;
        fft_output_10 = 16'd0;
        fft_output_11 = 16'd0;
        fft_output_12 = 16'd0;
        fft_output_13 = 16'd0;
        fft_output_14 = 16'd0;
        fft_output_15 = 16'd0;
        fft_output_16 = 16'd0;
        fft_output_17 = 16'd0;
        fft_output_18 = 16'd0;
        fft_output_19 = 16'd0;
        fft_output_20 = 16'd0;
        fft_output_21 = 16'd0;
        fft_output_22 = 16'd0;
        fft_output_23 = 16'd0;
        fft_output_24 = 16'd0;
        fft_output_25 = 16'd0;
        fft_output_26 = 16'd0;
        fft_output_27 = 16'd0;
        fft_output_28 = 16'd0;
        fft_output_29 = 16'd0;
        fft_output_30 = 16'd0;
        fft_output_31 = 16'd0;
        fft_output_32 = 16'd0;
        fft_output_33 = 16'd0;
        fft_output_34 = 16'd0;
        fft_output_35 = 16'd0;
        fft_output_36 = 16'd0;
        fft_output_37 = 16'd0;
        fft_output_38 = 16'd0;
        fft_output_39 = 16'd0;
        fft_output_40 = 16'd0;
        fft_output_41 = 16'd0;
        fft_output_42 = 16'd0;
        fft_output_43 = 16'd0;
        fft_output_44 = 16'd0;
        fft_output_45 = 16'd0;
        fft_output_46 = 16'd0;
        fft_output_47 = 16'd0;
        fft_output_48 = 16'd0;
        fft_output_49 = 16'd0;
        fft_output_50 = 16'd0;
        fft_output_51 = 16'd0;
        fft_output_52 = 16'd0;
        fft_output_53 = 16'd0;
        fft_output_54 = 16'd0;
        fft_output_55 = 16'd0;
        fft_output_56 = 16'd0;
        fft_output_57 = 16'd0;
        fft_output_58 = 16'd0;
        fft_output_59 = 16'd0;
        fft_output_60 = 16'd0;
        fft_output_61 = 16'd0;
        fft_output_62 = 16'd0;
        fft_output_63 = 16'd0;
        #20 rst = 0;

        // Drive a simple ramp across all bins - a smoke test, not a
        // quantitative check (see fft_tb.v for that).
        #2 fft_output_0 = 16'd50;
        #2 fft_output_1 = 16'd100;
        #2 fft_output_2 = 16'd150;
        #2 fft_output_3 = 16'd200;
        #2 fft_output_4 = 16'd250;
        #2 fft_output_5 = 16'd300;
        #2 fft_output_6 = 16'd350;
        #2 fft_output_7 = 16'd400;
        #2 fft_output_8 = 16'd450;
        #2 fft_output_9 = 16'd500;
        #2 fft_output_10 = 16'd550;
        #2 fft_output_11 = 16'd600;
        #2 fft_output_12 = 16'd650;
        #2 fft_output_13 = 16'd700;
        #2 fft_output_14 = 16'd750;
        #2 fft_output_15 = 16'd800;
        #2 fft_output_16 = 16'd850;
        #2 fft_output_17 = 16'd900;
        #2 fft_output_18 = 16'd950;
        #2 fft_output_19 = 16'd1000;
        #2 fft_output_20 = 16'd1050;
        #2 fft_output_21 = 16'd1100;
        #2 fft_output_22 = 16'd1150;
        #2 fft_output_23 = 16'd1200;
        #2 fft_output_24 = 16'd1250;
        #2 fft_output_25 = 16'd1300;
        #2 fft_output_26 = 16'd1350;
        #2 fft_output_27 = 16'd1400;
        #2 fft_output_28 = 16'd1450;
        #2 fft_output_29 = 16'd1500;
        #2 fft_output_30 = 16'd1550;
        #2 fft_output_31 = 16'd1600;
        #2 fft_output_32 = 16'd1650;
        #2 fft_output_33 = 16'd1700;
        #2 fft_output_34 = 16'd1750;
        #2 fft_output_35 = 16'd1800;
        #2 fft_output_36 = 16'd1850;
        #2 fft_output_37 = 16'd1900;
        #2 fft_output_38 = 16'd1950;
        #2 fft_output_39 = 16'd2000;
        #2 fft_output_40 = 16'd2050;
        #2 fft_output_41 = 16'd2100;
        #2 fft_output_42 = 16'd2150;
        #2 fft_output_43 = 16'd2200;
        #2 fft_output_44 = 16'd2250;
        #2 fft_output_45 = 16'd2300;
        #2 fft_output_46 = 16'd2350;
        #2 fft_output_47 = 16'd2400;
        #2 fft_output_48 = 16'd2450;
        #2 fft_output_49 = 16'd2500;
        #2 fft_output_50 = 16'd2550;
        #2 fft_output_51 = 16'd2600;
        #2 fft_output_52 = 16'd2650;
        #2 fft_output_53 = 16'd2700;
        #2 fft_output_54 = 16'd2750;
        #2 fft_output_55 = 16'd2800;
        #2 fft_output_56 = 16'd2850;
        #2 fft_output_57 = 16'd2900;
        #2 fft_output_58 = 16'd2950;
        #2 fft_output_59 = 16'd3000;
        #2 fft_output_60 = 16'd3050;
        #2 fft_output_61 = 16'd3100;
        #2 fft_output_62 = 16'd3150;
        #2 fft_output_63 = 16'd3200;

        #50;
        $display("Mel Features Output:");
        $display("Mel[0] = %d", mel_features_0);
        $display("Mel[1] = %d", mel_features_1);
        $display("Mel[2] = %d", mel_features_2);
        $display("Mel[3] = %d", mel_features_3);
        $display("Mel[4] = %d", mel_features_4);
        $display("Mel[5] = %d", mel_features_5);
        $display("Mel[6] = %d", mel_features_6);
        $display("Mel[7] = %d", mel_features_7);
        $display("Mel[8] = %d", mel_features_8);
        $display("Mel[9] = %d", mel_features_9);
        $display("Mel[10] = %d", mel_features_10);
        $display("Mel[11] = %d", mel_features_11);
        $display("Mel[12] = %d", mel_features_12);
        $finish;
    end
endmodule
