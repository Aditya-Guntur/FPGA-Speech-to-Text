`timescale 1ns / 1ps

module fft_tb;
    reg clk;
    reg signed [15:0] audio_in;
    wire signed [15:0] fft_output_0, fft_output_1, fft_output_2, fft_output_3;
    wire signed [15:0] fft_output_4, fft_output_5, fft_output_6, fft_output_7;
    wire signed [15:0] fft_output_8, fft_output_9, fft_output_10, fft_output_11;
    wire signed [15:0] fft_output_12, fft_output_13, fft_output_14, fft_output_15;
    wire signed [15:0] fft_output_16, fft_output_17, fft_output_18, fft_output_19;
    wire signed [15:0] fft_output_20, fft_output_21, fft_output_22, fft_output_23;
    wire signed [15:0] fft_output_24, fft_output_25, fft_output_26, fft_output_27;
    wire signed [15:0] fft_output_28, fft_output_29, fft_output_30, fft_output_31;
    wire signed [15:0] fft_output_32, fft_output_33, fft_output_34, fft_output_35;
    wire signed [15:0] fft_output_36, fft_output_37, fft_output_38, fft_output_39;
    wire signed [15:0] fft_output_40, fft_output_41, fft_output_42, fft_output_43;
    wire signed [15:0] fft_output_44, fft_output_45, fft_output_46, fft_output_47;
    wire signed [15:0] fft_output_48, fft_output_49, fft_output_50, fft_output_51;
    wire signed [15:0] fft_output_52, fft_output_53, fft_output_54, fft_output_55;
    wire signed [15:0] fft_output_56, fft_output_57, fft_output_58, fft_output_59;
    wire signed [15:0] fft_output_60, fft_output_61, fft_output_62, fft_output_63;

    fft uut (
        .clk(clk),
        .audio_in(audio_in),
        .fft_output_0(fft_output_0), .fft_output_1(fft_output_1),
        .fft_output_2(fft_output_2), .fft_output_3(fft_output_3),
        .fft_output_4(fft_output_4), .fft_output_5(fft_output_5),
        .fft_output_6(fft_output_6), .fft_output_7(fft_output_7),
        .fft_output_8(fft_output_8), .fft_output_9(fft_output_9),
        .fft_output_10(fft_output_10), .fft_output_11(fft_output_11),
        .fft_output_12(fft_output_12), .fft_output_13(fft_output_13),
        .fft_output_14(fft_output_14), .fft_output_15(fft_output_15),
        .fft_output_16(fft_output_16), .fft_output_17(fft_output_17),
        .fft_output_18(fft_output_18), .fft_output_19(fft_output_19),
        .fft_output_20(fft_output_20), .fft_output_21(fft_output_21),
        .fft_output_22(fft_output_22), .fft_output_23(fft_output_23),
        .fft_output_24(fft_output_24), .fft_output_25(fft_output_25),
        .fft_output_26(fft_output_26), .fft_output_27(fft_output_27),
        .fft_output_28(fft_output_28), .fft_output_29(fft_output_29),
        .fft_output_30(fft_output_30), .fft_output_31(fft_output_31),
        .fft_output_32(fft_output_32), .fft_output_33(fft_output_33),
        .fft_output_34(fft_output_34), .fft_output_35(fft_output_35),
        .fft_output_36(fft_output_36), .fft_output_37(fft_output_37),
        .fft_output_38(fft_output_38), .fft_output_39(fft_output_39),
        .fft_output_40(fft_output_40), .fft_output_41(fft_output_41),
        .fft_output_42(fft_output_42), .fft_output_43(fft_output_43),
        .fft_output_44(fft_output_44), .fft_output_45(fft_output_45),
        .fft_output_46(fft_output_46), .fft_output_47(fft_output_47),
        .fft_output_48(fft_output_48), .fft_output_49(fft_output_49),
        .fft_output_50(fft_output_50), .fft_output_51(fft_output_51),
        .fft_output_52(fft_output_52), .fft_output_53(fft_output_53),
        .fft_output_54(fft_output_54), .fft_output_55(fft_output_55),
        .fft_output_56(fft_output_56), .fft_output_57(fft_output_57),
        .fft_output_58(fft_output_58), .fft_output_59(fft_output_59),
        .fft_output_60(fft_output_60), .fft_output_61(fft_output_61),
        .fft_output_62(fft_output_62), .fft_output_63(fft_output_63)
    );

    always #5 clk = ~clk;

    // Validates the 64-tap, 32-bin direct-form DFT the same way
    // the previous 16-tap/8-bin version was validated: drive a pure tone at
    // bin 5's exact frequency (1250.0Hz) and confirm the magnitude
    // output peaks at bin 5, not anywhere else.
    integer i;
    reg signed [15:0] samples [0:399];
    integer real_vals [0:32-1];
    integer imag_vals [0:32-1];
    integer mag_vals [0:32-1];
    integer peak_bin, peak_val;

    initial begin
        samples[0] = 16'sd0;
        samples[1] = 16'sd3771;
        samples[2] = 16'sd6651;
        samples[3] = 16'sd7961;
        samples[4] = 16'sd7391;
        samples[5] = 16'sd5075;
        samples[6] = 16'sd1560;
        samples[7] = -16'sd2322;
        samples[8] = -16'sd5656;
        samples[9] = -16'sd7655;
        samples[10] = -16'sd7846;
        samples[11] = -16'sd6184;
        samples[12] = -16'sd3061;
        samples[13] = 16'sd784;
        samples[14] = 16'sd4444;
        samples[15] = 16'sd7055;
        samples[16] = 16'sd8000;
        samples[17] = 16'sd7055;
        samples[18] = 16'sd4444;
        samples[19] = 16'sd784;
        samples[20] = -16'sd3061;
        samples[21] = -16'sd6184;
        samples[22] = -16'sd7846;
        samples[23] = -16'sd7655;
        samples[24] = -16'sd5656;
        samples[25] = -16'sd2322;
        samples[26] = 16'sd1560;
        samples[27] = 16'sd5075;
        samples[28] = 16'sd7391;
        samples[29] = 16'sd7961;
        samples[30] = 16'sd6651;
        samples[31] = 16'sd3771;
        samples[32] = 16'sd0;
        samples[33] = -16'sd3771;
        samples[34] = -16'sd6651;
        samples[35] = -16'sd7961;
        samples[36] = -16'sd7391;
        samples[37] = -16'sd5075;
        samples[38] = -16'sd1560;
        samples[39] = 16'sd2322;
        samples[40] = 16'sd5656;
        samples[41] = 16'sd7655;
        samples[42] = 16'sd7846;
        samples[43] = 16'sd6184;
        samples[44] = 16'sd3061;
        samples[45] = -16'sd784;
        samples[46] = -16'sd4444;
        samples[47] = -16'sd7055;
        samples[48] = -16'sd8000;
        samples[49] = -16'sd7055;
        samples[50] = -16'sd4444;
        samples[51] = -16'sd784;
        samples[52] = 16'sd3061;
        samples[53] = 16'sd6184;
        samples[54] = 16'sd7846;
        samples[55] = 16'sd7655;
        samples[56] = 16'sd5656;
        samples[57] = 16'sd2322;
        samples[58] = -16'sd1560;
        samples[59] = -16'sd5075;
        samples[60] = -16'sd7391;
        samples[61] = -16'sd7961;
        samples[62] = -16'sd6651;
        samples[63] = -16'sd3771;
        samples[64] = 16'sd0;
        samples[65] = 16'sd3771;
        samples[66] = 16'sd6651;
        samples[67] = 16'sd7961;
        samples[68] = 16'sd7391;
        samples[69] = 16'sd5075;
        samples[70] = 16'sd1560;
        samples[71] = -16'sd2322;
        samples[72] = -16'sd5656;
        samples[73] = -16'sd7655;
        samples[74] = -16'sd7846;
        samples[75] = -16'sd6184;
        samples[76] = -16'sd3061;
        samples[77] = 16'sd784;
        samples[78] = 16'sd4444;
        samples[79] = 16'sd7055;
        samples[80] = 16'sd8000;
        samples[81] = 16'sd7055;
        samples[82] = 16'sd4444;
        samples[83] = 16'sd784;
        samples[84] = -16'sd3061;
        samples[85] = -16'sd6184;
        samples[86] = -16'sd7846;
        samples[87] = -16'sd7655;
        samples[88] = -16'sd5656;
        samples[89] = -16'sd2322;
        samples[90] = 16'sd1560;
        samples[91] = 16'sd5075;
        samples[92] = 16'sd7391;
        samples[93] = 16'sd7961;
        samples[94] = 16'sd6651;
        samples[95] = 16'sd3771;
        samples[96] = 16'sd0;
        samples[97] = -16'sd3771;
        samples[98] = -16'sd6651;
        samples[99] = -16'sd7961;
        samples[100] = -16'sd7391;
        samples[101] = -16'sd5075;
        samples[102] = -16'sd1560;
        samples[103] = 16'sd2322;
        samples[104] = 16'sd5656;
        samples[105] = 16'sd7655;
        samples[106] = 16'sd7846;
        samples[107] = 16'sd6184;
        samples[108] = 16'sd3061;
        samples[109] = -16'sd784;
        samples[110] = -16'sd4444;
        samples[111] = -16'sd7055;
        samples[112] = -16'sd8000;
        samples[113] = -16'sd7055;
        samples[114] = -16'sd4444;
        samples[115] = -16'sd784;
        samples[116] = 16'sd3061;
        samples[117] = 16'sd6184;
        samples[118] = 16'sd7846;
        samples[119] = 16'sd7655;
        samples[120] = 16'sd5656;
        samples[121] = 16'sd2322;
        samples[122] = -16'sd1560;
        samples[123] = -16'sd5075;
        samples[124] = -16'sd7391;
        samples[125] = -16'sd7961;
        samples[126] = -16'sd6651;
        samples[127] = -16'sd3771;
        samples[128] = 16'sd0;
        samples[129] = 16'sd3771;
        samples[130] = 16'sd6651;
        samples[131] = 16'sd7961;
        samples[132] = 16'sd7391;
        samples[133] = 16'sd5075;
        samples[134] = 16'sd1560;
        samples[135] = -16'sd2322;
        samples[136] = -16'sd5656;
        samples[137] = -16'sd7655;
        samples[138] = -16'sd7846;
        samples[139] = -16'sd6184;
        samples[140] = -16'sd3061;
        samples[141] = 16'sd784;
        samples[142] = 16'sd4444;
        samples[143] = 16'sd7055;
        samples[144] = 16'sd8000;
        samples[145] = 16'sd7055;
        samples[146] = 16'sd4444;
        samples[147] = 16'sd784;
        samples[148] = -16'sd3061;
        samples[149] = -16'sd6184;
        samples[150] = -16'sd7846;
        samples[151] = -16'sd7655;
        samples[152] = -16'sd5656;
        samples[153] = -16'sd2322;
        samples[154] = 16'sd1560;
        samples[155] = 16'sd5075;
        samples[156] = 16'sd7391;
        samples[157] = 16'sd7961;
        samples[158] = 16'sd6651;
        samples[159] = 16'sd3771;
        samples[160] = 16'sd0;
        samples[161] = -16'sd3771;
        samples[162] = -16'sd6651;
        samples[163] = -16'sd7961;
        samples[164] = -16'sd7391;
        samples[165] = -16'sd5075;
        samples[166] = -16'sd1560;
        samples[167] = 16'sd2322;
        samples[168] = 16'sd5656;
        samples[169] = 16'sd7655;
        samples[170] = 16'sd7846;
        samples[171] = 16'sd6184;
        samples[172] = 16'sd3061;
        samples[173] = -16'sd784;
        samples[174] = -16'sd4444;
        samples[175] = -16'sd7055;
        samples[176] = -16'sd8000;
        samples[177] = -16'sd7055;
        samples[178] = -16'sd4444;
        samples[179] = -16'sd784;
        samples[180] = 16'sd3061;
        samples[181] = 16'sd6184;
        samples[182] = 16'sd7846;
        samples[183] = 16'sd7655;
        samples[184] = 16'sd5656;
        samples[185] = 16'sd2322;
        samples[186] = -16'sd1560;
        samples[187] = -16'sd5075;
        samples[188] = -16'sd7391;
        samples[189] = -16'sd7961;
        samples[190] = -16'sd6651;
        samples[191] = -16'sd3771;
        samples[192] = 16'sd0;
        samples[193] = 16'sd3771;
        samples[194] = 16'sd6651;
        samples[195] = 16'sd7961;
        samples[196] = 16'sd7391;
        samples[197] = 16'sd5075;
        samples[198] = 16'sd1560;
        samples[199] = -16'sd2322;
        samples[200] = -16'sd5656;
        samples[201] = -16'sd7655;
        samples[202] = -16'sd7846;
        samples[203] = -16'sd6184;
        samples[204] = -16'sd3061;
        samples[205] = 16'sd784;
        samples[206] = 16'sd4444;
        samples[207] = 16'sd7055;
        samples[208] = 16'sd8000;
        samples[209] = 16'sd7055;
        samples[210] = 16'sd4444;
        samples[211] = 16'sd784;
        samples[212] = -16'sd3061;
        samples[213] = -16'sd6184;
        samples[214] = -16'sd7846;
        samples[215] = -16'sd7655;
        samples[216] = -16'sd5656;
        samples[217] = -16'sd2322;
        samples[218] = 16'sd1560;
        samples[219] = 16'sd5075;
        samples[220] = 16'sd7391;
        samples[221] = 16'sd7961;
        samples[222] = 16'sd6651;
        samples[223] = 16'sd3771;
        samples[224] = 16'sd0;
        samples[225] = -16'sd3771;
        samples[226] = -16'sd6651;
        samples[227] = -16'sd7961;
        samples[228] = -16'sd7391;
        samples[229] = -16'sd5075;
        samples[230] = -16'sd1560;
        samples[231] = 16'sd2322;
        samples[232] = 16'sd5656;
        samples[233] = 16'sd7655;
        samples[234] = 16'sd7846;
        samples[235] = 16'sd6184;
        samples[236] = 16'sd3061;
        samples[237] = -16'sd784;
        samples[238] = -16'sd4444;
        samples[239] = -16'sd7055;
        samples[240] = -16'sd8000;
        samples[241] = -16'sd7055;
        samples[242] = -16'sd4444;
        samples[243] = -16'sd784;
        samples[244] = 16'sd3061;
        samples[245] = 16'sd6184;
        samples[246] = 16'sd7846;
        samples[247] = 16'sd7655;
        samples[248] = 16'sd5656;
        samples[249] = 16'sd2322;
        samples[250] = -16'sd1560;
        samples[251] = -16'sd5075;
        samples[252] = -16'sd7391;
        samples[253] = -16'sd7961;
        samples[254] = -16'sd6651;
        samples[255] = -16'sd3771;
        samples[256] = 16'sd0;
        samples[257] = 16'sd3771;
        samples[258] = 16'sd6651;
        samples[259] = 16'sd7961;
        samples[260] = 16'sd7391;
        samples[261] = 16'sd5075;
        samples[262] = 16'sd1560;
        samples[263] = -16'sd2322;
        samples[264] = -16'sd5656;
        samples[265] = -16'sd7655;
        samples[266] = -16'sd7846;
        samples[267] = -16'sd6184;
        samples[268] = -16'sd3061;
        samples[269] = 16'sd784;
        samples[270] = 16'sd4444;
        samples[271] = 16'sd7055;
        samples[272] = 16'sd8000;
        samples[273] = 16'sd7055;
        samples[274] = 16'sd4444;
        samples[275] = 16'sd784;
        samples[276] = -16'sd3061;
        samples[277] = -16'sd6184;
        samples[278] = -16'sd7846;
        samples[279] = -16'sd7655;
        samples[280] = -16'sd5656;
        samples[281] = -16'sd2322;
        samples[282] = 16'sd1560;
        samples[283] = 16'sd5075;
        samples[284] = 16'sd7391;
        samples[285] = 16'sd7961;
        samples[286] = 16'sd6651;
        samples[287] = 16'sd3771;
        samples[288] = 16'sd0;
        samples[289] = -16'sd3771;
        samples[290] = -16'sd6651;
        samples[291] = -16'sd7961;
        samples[292] = -16'sd7391;
        samples[293] = -16'sd5075;
        samples[294] = -16'sd1560;
        samples[295] = 16'sd2322;
        samples[296] = 16'sd5656;
        samples[297] = 16'sd7655;
        samples[298] = 16'sd7846;
        samples[299] = 16'sd6184;
        samples[300] = 16'sd3061;
        samples[301] = -16'sd784;
        samples[302] = -16'sd4444;
        samples[303] = -16'sd7055;
        samples[304] = -16'sd8000;
        samples[305] = -16'sd7055;
        samples[306] = -16'sd4444;
        samples[307] = -16'sd784;
        samples[308] = 16'sd3061;
        samples[309] = 16'sd6184;
        samples[310] = 16'sd7846;
        samples[311] = 16'sd7655;
        samples[312] = 16'sd5656;
        samples[313] = 16'sd2322;
        samples[314] = -16'sd1560;
        samples[315] = -16'sd5075;
        samples[316] = -16'sd7391;
        samples[317] = -16'sd7961;
        samples[318] = -16'sd6651;
        samples[319] = -16'sd3771;
        samples[320] = 16'sd0;
        samples[321] = 16'sd3771;
        samples[322] = 16'sd6651;
        samples[323] = 16'sd7961;
        samples[324] = 16'sd7391;
        samples[325] = 16'sd5075;
        samples[326] = 16'sd1560;
        samples[327] = -16'sd2322;
        samples[328] = -16'sd5656;
        samples[329] = -16'sd7655;
        samples[330] = -16'sd7846;
        samples[331] = -16'sd6184;
        samples[332] = -16'sd3061;
        samples[333] = 16'sd784;
        samples[334] = 16'sd4444;
        samples[335] = 16'sd7055;
        samples[336] = 16'sd8000;
        samples[337] = 16'sd7055;
        samples[338] = 16'sd4444;
        samples[339] = 16'sd784;
        samples[340] = -16'sd3061;
        samples[341] = -16'sd6184;
        samples[342] = -16'sd7846;
        samples[343] = -16'sd7655;
        samples[344] = -16'sd5656;
        samples[345] = -16'sd2322;
        samples[346] = 16'sd1560;
        samples[347] = 16'sd5075;
        samples[348] = 16'sd7391;
        samples[349] = 16'sd7961;
        samples[350] = 16'sd6651;
        samples[351] = 16'sd3771;
        samples[352] = 16'sd0;
        samples[353] = -16'sd3771;
        samples[354] = -16'sd6651;
        samples[355] = -16'sd7961;
        samples[356] = -16'sd7391;
        samples[357] = -16'sd5075;
        samples[358] = -16'sd1560;
        samples[359] = 16'sd2322;
        samples[360] = 16'sd5656;
        samples[361] = 16'sd7655;
        samples[362] = 16'sd7846;
        samples[363] = 16'sd6184;
        samples[364] = 16'sd3061;
        samples[365] = -16'sd784;
        samples[366] = -16'sd4444;
        samples[367] = -16'sd7055;
        samples[368] = -16'sd8000;
        samples[369] = -16'sd7055;
        samples[370] = -16'sd4444;
        samples[371] = -16'sd784;
        samples[372] = 16'sd3061;
        samples[373] = 16'sd6184;
        samples[374] = 16'sd7846;
        samples[375] = 16'sd7655;
        samples[376] = 16'sd5656;
        samples[377] = 16'sd2322;
        samples[378] = -16'sd1560;
        samples[379] = -16'sd5075;
        samples[380] = -16'sd7391;
        samples[381] = -16'sd7961;
        samples[382] = -16'sd6651;
        samples[383] = -16'sd3771;
        samples[384] = 16'sd0;
        samples[385] = 16'sd3771;
        samples[386] = 16'sd6651;
        samples[387] = 16'sd7961;
        samples[388] = 16'sd7391;
        samples[389] = 16'sd5075;
        samples[390] = 16'sd1560;
        samples[391] = -16'sd2322;
        samples[392] = -16'sd5656;
        samples[393] = -16'sd7655;
        samples[394] = -16'sd7846;
        samples[395] = -16'sd6184;
        samples[396] = -16'sd3061;
        samples[397] = 16'sd784;
        samples[398] = 16'sd4444;
        samples[399] = 16'sd7055;
    end

    initial begin
        clk = 0;
        for (i = 0; i < 400; i = i + 1) begin
            audio_in = samples[i];
            #10;
        end

        real_vals[0] = fft_output_0; real_vals[1] = fft_output_1; real_vals[2] = fft_output_2; real_vals[3] = fft_output_3; real_vals[4] = fft_output_4; real_vals[5] = fft_output_5; real_vals[6] = fft_output_6; real_vals[7] = fft_output_7; real_vals[8] = fft_output_8; real_vals[9] = fft_output_9; real_vals[10] = fft_output_10; real_vals[11] = fft_output_11; real_vals[12] = fft_output_12; real_vals[13] = fft_output_13; real_vals[14] = fft_output_14; real_vals[15] = fft_output_15; real_vals[16] = fft_output_16; real_vals[17] = fft_output_17; real_vals[18] = fft_output_18; real_vals[19] = fft_output_19; real_vals[20] = fft_output_20; real_vals[21] = fft_output_21; real_vals[22] = fft_output_22; real_vals[23] = fft_output_23; real_vals[24] = fft_output_24; real_vals[25] = fft_output_25; real_vals[26] = fft_output_26; real_vals[27] = fft_output_27; real_vals[28] = fft_output_28; real_vals[29] = fft_output_29; real_vals[30] = fft_output_30; real_vals[31] = fft_output_31;
        imag_vals[0] = fft_output_32; imag_vals[1] = fft_output_33; imag_vals[2] = fft_output_34; imag_vals[3] = fft_output_35; imag_vals[4] = fft_output_36; imag_vals[5] = fft_output_37; imag_vals[6] = fft_output_38; imag_vals[7] = fft_output_39; imag_vals[8] = fft_output_40; imag_vals[9] = fft_output_41; imag_vals[10] = fft_output_42; imag_vals[11] = fft_output_43; imag_vals[12] = fft_output_44; imag_vals[13] = fft_output_45; imag_vals[14] = fft_output_46; imag_vals[15] = fft_output_47; imag_vals[16] = fft_output_48; imag_vals[17] = fft_output_49; imag_vals[18] = fft_output_50; imag_vals[19] = fft_output_51; imag_vals[20] = fft_output_52; imag_vals[21] = fft_output_53; imag_vals[22] = fft_output_54; imag_vals[23] = fft_output_55; imag_vals[24] = fft_output_56; imag_vals[25] = fft_output_57; imag_vals[26] = fft_output_58; imag_vals[27] = fft_output_59; imag_vals[28] = fft_output_60; imag_vals[29] = fft_output_61; imag_vals[30] = fft_output_62; imag_vals[31] = fft_output_63;
        peak_bin = 0; peak_val = 0;
        for (i = 0; i < 32; i = i + 1) begin
            mag_vals[i] = (real_vals[i]<0 ? -real_vals[i] : real_vals[i]) + (imag_vals[i]<0 ? -imag_vals[i] : imag_vals[i]);
            if (mag_vals[i] > peak_val) begin
                peak_val = mag_vals[i];
                peak_bin = i;
            end
        end
        $display("peak bin = %d (expect 5), peak magnitude = %d", peak_bin, peak_val);
        for (i = 0; i < 10; i = i + 1)
            $display("bin %d: mag=%d", i, mag_vals[i]);
        $finish;
    end
endmodule
