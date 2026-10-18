`timescale 1ns / 1ps

module dense_hidden_tb;
    reg clk;
    reg [15:0] mfcc_features_flat_0, mfcc_features_flat_1, mfcc_features_flat_2, mfcc_features_flat_3;
    reg [15:0] mfcc_features_flat_4, mfcc_features_flat_5, mfcc_features_flat_6, mfcc_features_flat_7;
    reg [15:0] mfcc_features_flat_8, mfcc_features_flat_9, mfcc_features_flat_10, mfcc_features_flat_11;
    reg [15:0] mfcc_features_flat_12, mfcc_features_flat_13, mfcc_features_flat_14, mfcc_features_flat_15;
    reg [15:0] mfcc_features_flat_16, mfcc_features_flat_17, mfcc_features_flat_18, mfcc_features_flat_19;
    reg [15:0] mfcc_features_flat_20, mfcc_features_flat_21, mfcc_features_flat_22, mfcc_features_flat_23;
    reg [15:0] mfcc_features_flat_24, mfcc_features_flat_25, mfcc_features_flat_26, mfcc_features_flat_27;
    reg [15:0] mfcc_features_flat_28, mfcc_features_flat_29, mfcc_features_flat_30, mfcc_features_flat_31;
    reg [15:0] mfcc_features_flat_32, mfcc_features_flat_33, mfcc_features_flat_34, mfcc_features_flat_35;
    reg [15:0] mfcc_features_flat_36, mfcc_features_flat_37, mfcc_features_flat_38, mfcc_features_flat_39;
    reg [15:0] mfcc_features_flat_40, mfcc_features_flat_41, mfcc_features_flat_42, mfcc_features_flat_43;
    reg [15:0] mfcc_features_flat_44, mfcc_features_flat_45, mfcc_features_flat_46, mfcc_features_flat_47;
    reg [15:0] mfcc_features_flat_48, mfcc_features_flat_49, mfcc_features_flat_50, mfcc_features_flat_51;
    reg [15:0] mfcc_features_flat_52, mfcc_features_flat_53, mfcc_features_flat_54, mfcc_features_flat_55;
    reg [15:0] mfcc_features_flat_56, mfcc_features_flat_57, mfcc_features_flat_58, mfcc_features_flat_59;
    reg [15:0] mfcc_features_flat_60, mfcc_features_flat_61, mfcc_features_flat_62, mfcc_features_flat_63;
    reg [15:0] mfcc_features_flat_64, mfcc_features_flat_65, mfcc_features_flat_66, mfcc_features_flat_67;
    reg [15:0] mfcc_features_flat_68, mfcc_features_flat_69, mfcc_features_flat_70, mfcc_features_flat_71;
    reg [15:0] mfcc_features_flat_72, mfcc_features_flat_73, mfcc_features_flat_74, mfcc_features_flat_75;
    reg [15:0] mfcc_features_flat_76, mfcc_features_flat_77;

    wire signed [15:0] hidden_flat_0, hidden_flat_1, hidden_flat_2, hidden_flat_3;
    wire signed [15:0] hidden_flat_4, hidden_flat_5, hidden_flat_6, hidden_flat_7;
    wire signed [15:0] hidden_flat_8, hidden_flat_9, hidden_flat_10, hidden_flat_11;
    wire signed [15:0] hidden_flat_12, hidden_flat_13, hidden_flat_14, hidden_flat_15;

    dense_hidden uut (
        .clk(clk),
        .mfcc_features_flat_0(mfcc_features_flat_0),
        .mfcc_features_flat_1(mfcc_features_flat_1),
        .mfcc_features_flat_2(mfcc_features_flat_2),
        .mfcc_features_flat_3(mfcc_features_flat_3),
        .mfcc_features_flat_4(mfcc_features_flat_4),
        .mfcc_features_flat_5(mfcc_features_flat_5),
        .mfcc_features_flat_6(mfcc_features_flat_6),
        .mfcc_features_flat_7(mfcc_features_flat_7),
        .mfcc_features_flat_8(mfcc_features_flat_8),
        .mfcc_features_flat_9(mfcc_features_flat_9),
        .mfcc_features_flat_10(mfcc_features_flat_10),
        .mfcc_features_flat_11(mfcc_features_flat_11),
        .mfcc_features_flat_12(mfcc_features_flat_12),
        .mfcc_features_flat_13(mfcc_features_flat_13),
        .mfcc_features_flat_14(mfcc_features_flat_14),
        .mfcc_features_flat_15(mfcc_features_flat_15),
        .mfcc_features_flat_16(mfcc_features_flat_16),
        .mfcc_features_flat_17(mfcc_features_flat_17),
        .mfcc_features_flat_18(mfcc_features_flat_18),
        .mfcc_features_flat_19(mfcc_features_flat_19),
        .mfcc_features_flat_20(mfcc_features_flat_20),
        .mfcc_features_flat_21(mfcc_features_flat_21),
        .mfcc_features_flat_22(mfcc_features_flat_22),
        .mfcc_features_flat_23(mfcc_features_flat_23),
        .mfcc_features_flat_24(mfcc_features_flat_24),
        .mfcc_features_flat_25(mfcc_features_flat_25),
        .mfcc_features_flat_26(mfcc_features_flat_26),
        .mfcc_features_flat_27(mfcc_features_flat_27),
        .mfcc_features_flat_28(mfcc_features_flat_28),
        .mfcc_features_flat_29(mfcc_features_flat_29),
        .mfcc_features_flat_30(mfcc_features_flat_30),
        .mfcc_features_flat_31(mfcc_features_flat_31),
        .mfcc_features_flat_32(mfcc_features_flat_32),
        .mfcc_features_flat_33(mfcc_features_flat_33),
        .mfcc_features_flat_34(mfcc_features_flat_34),
        .mfcc_features_flat_35(mfcc_features_flat_35),
        .mfcc_features_flat_36(mfcc_features_flat_36),
        .mfcc_features_flat_37(mfcc_features_flat_37),
        .mfcc_features_flat_38(mfcc_features_flat_38),
        .mfcc_features_flat_39(mfcc_features_flat_39),
        .mfcc_features_flat_40(mfcc_features_flat_40),
        .mfcc_features_flat_41(mfcc_features_flat_41),
        .mfcc_features_flat_42(mfcc_features_flat_42),
        .mfcc_features_flat_43(mfcc_features_flat_43),
        .mfcc_features_flat_44(mfcc_features_flat_44),
        .mfcc_features_flat_45(mfcc_features_flat_45),
        .mfcc_features_flat_46(mfcc_features_flat_46),
        .mfcc_features_flat_47(mfcc_features_flat_47),
        .mfcc_features_flat_48(mfcc_features_flat_48),
        .mfcc_features_flat_49(mfcc_features_flat_49),
        .mfcc_features_flat_50(mfcc_features_flat_50),
        .mfcc_features_flat_51(mfcc_features_flat_51),
        .mfcc_features_flat_52(mfcc_features_flat_52),
        .mfcc_features_flat_53(mfcc_features_flat_53),
        .mfcc_features_flat_54(mfcc_features_flat_54),
        .mfcc_features_flat_55(mfcc_features_flat_55),
        .mfcc_features_flat_56(mfcc_features_flat_56),
        .mfcc_features_flat_57(mfcc_features_flat_57),
        .mfcc_features_flat_58(mfcc_features_flat_58),
        .mfcc_features_flat_59(mfcc_features_flat_59),
        .mfcc_features_flat_60(mfcc_features_flat_60),
        .mfcc_features_flat_61(mfcc_features_flat_61),
        .mfcc_features_flat_62(mfcc_features_flat_62),
        .mfcc_features_flat_63(mfcc_features_flat_63),
        .mfcc_features_flat_64(mfcc_features_flat_64),
        .mfcc_features_flat_65(mfcc_features_flat_65),
        .mfcc_features_flat_66(mfcc_features_flat_66),
        .mfcc_features_flat_67(mfcc_features_flat_67),
        .mfcc_features_flat_68(mfcc_features_flat_68),
        .mfcc_features_flat_69(mfcc_features_flat_69),
        .mfcc_features_flat_70(mfcc_features_flat_70),
        .mfcc_features_flat_71(mfcc_features_flat_71),
        .mfcc_features_flat_72(mfcc_features_flat_72),
        .mfcc_features_flat_73(mfcc_features_flat_73),
        .mfcc_features_flat_74(mfcc_features_flat_74),
        .mfcc_features_flat_75(mfcc_features_flat_75),
        .mfcc_features_flat_76(mfcc_features_flat_76),
        .mfcc_features_flat_77(mfcc_features_flat_77),
        .hidden_flat_0(hidden_flat_0),
        .hidden_flat_1(hidden_flat_1),
        .hidden_flat_2(hidden_flat_2),
        .hidden_flat_3(hidden_flat_3),
        .hidden_flat_4(hidden_flat_4),
        .hidden_flat_5(hidden_flat_5),
        .hidden_flat_6(hidden_flat_6),
        .hidden_flat_7(hidden_flat_7),
        .hidden_flat_8(hidden_flat_8),
        .hidden_flat_9(hidden_flat_9),
        .hidden_flat_10(hidden_flat_10),
        .hidden_flat_11(hidden_flat_11),
        .hidden_flat_12(hidden_flat_12),
        .hidden_flat_13(hidden_flat_13),
        .hidden_flat_14(hidden_flat_14),
        .hidden_flat_15(hidden_flat_15)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mfcc_features_flat_0 = 16'd10;
        mfcc_features_flat_1 = 16'd20;
        mfcc_features_flat_2 = 16'd30;
        mfcc_features_flat_3 = 16'd40;
        mfcc_features_flat_4 = 16'd50;
        mfcc_features_flat_5 = 16'd60;
        mfcc_features_flat_6 = 16'd70;
        mfcc_features_flat_7 = 16'd80;
        mfcc_features_flat_8 = 16'd90;
        mfcc_features_flat_9 = 16'd100;
        mfcc_features_flat_10 = 16'd110;
        mfcc_features_flat_11 = 16'd120;
        mfcc_features_flat_12 = 16'd130;
        mfcc_features_flat_13 = 16'd140;
        mfcc_features_flat_14 = 16'd150;
        mfcc_features_flat_15 = 16'd160;
        mfcc_features_flat_16 = 16'd170;
        mfcc_features_flat_17 = 16'd180;
        mfcc_features_flat_18 = 16'd190;
        mfcc_features_flat_19 = 16'd200;
        mfcc_features_flat_20 = 16'd210;
        mfcc_features_flat_21 = 16'd220;
        mfcc_features_flat_22 = 16'd230;
        mfcc_features_flat_23 = 16'd240;
        mfcc_features_flat_24 = 16'd250;
        mfcc_features_flat_25 = 16'd260;
        mfcc_features_flat_26 = 16'd270;
        mfcc_features_flat_27 = 16'd280;
        mfcc_features_flat_28 = 16'd290;
        mfcc_features_flat_29 = 16'd300;
        mfcc_features_flat_30 = 16'd310;
        mfcc_features_flat_31 = 16'd320;
        mfcc_features_flat_32 = 16'd330;
        mfcc_features_flat_33 = 16'd340;
        mfcc_features_flat_34 = 16'd350;
        mfcc_features_flat_35 = 16'd360;
        mfcc_features_flat_36 = 16'd370;
        mfcc_features_flat_37 = 16'd380;
        mfcc_features_flat_38 = 16'd390;
        mfcc_features_flat_39 = 16'd400;
        mfcc_features_flat_40 = 16'd410;
        mfcc_features_flat_41 = 16'd420;
        mfcc_features_flat_42 = 16'd430;
        mfcc_features_flat_43 = 16'd440;
        mfcc_features_flat_44 = 16'd450;
        mfcc_features_flat_45 = 16'd460;
        mfcc_features_flat_46 = 16'd470;
        mfcc_features_flat_47 = 16'd480;
        mfcc_features_flat_48 = 16'd490;
        mfcc_features_flat_49 = 16'd500;
        mfcc_features_flat_50 = 16'd510;
        mfcc_features_flat_51 = 16'd520;
        mfcc_features_flat_52 = 16'd530;
        mfcc_features_flat_53 = 16'd540;
        mfcc_features_flat_54 = 16'd550;
        mfcc_features_flat_55 = 16'd560;
        mfcc_features_flat_56 = 16'd570;
        mfcc_features_flat_57 = 16'd580;
        mfcc_features_flat_58 = 16'd590;
        mfcc_features_flat_59 = 16'd600;
        mfcc_features_flat_60 = 16'd610;
        mfcc_features_flat_61 = 16'd620;
        mfcc_features_flat_62 = 16'd630;
        mfcc_features_flat_63 = 16'd640;
        mfcc_features_flat_64 = 16'd650;
        mfcc_features_flat_65 = 16'd660;
        mfcc_features_flat_66 = 16'd670;
        mfcc_features_flat_67 = 16'd680;
        mfcc_features_flat_68 = 16'd690;
        mfcc_features_flat_69 = 16'd700;
        mfcc_features_flat_70 = 16'd710;
        mfcc_features_flat_71 = 16'd720;
        mfcc_features_flat_72 = 16'd730;
        mfcc_features_flat_73 = 16'd740;
        mfcc_features_flat_74 = 16'd750;
        mfcc_features_flat_75 = 16'd760;
        mfcc_features_flat_76 = 16'd770;
        mfcc_features_flat_77 = 16'd780;

        #100;
        $finish;
    end

    initial begin
        $monitor("Time = %t | H0 = %d | H5 = %d | H10 = %d | H15 = %d",
                 $time, hidden_flat_0, hidden_flat_5, hidden_flat_10, hidden_flat_15);
    end
endmodule
