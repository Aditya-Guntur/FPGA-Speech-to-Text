module matrix_multiplication (
    input wire clk,
    // Output layer of the classifier: 256 hidden-layer activations in,
    // 8 class scores out. Takes dense_hidden.v's (ReLU'd) output.
    input wire [15:0] hidden_features_flat_0, input wire [15:0] hidden_features_flat_1,
    input wire [15:0] hidden_features_flat_2, input wire [15:0] hidden_features_flat_3,
    input wire [15:0] hidden_features_flat_4, input wire [15:0] hidden_features_flat_5,
    input wire [15:0] hidden_features_flat_6, input wire [15:0] hidden_features_flat_7,
    input wire [15:0] hidden_features_flat_8, input wire [15:0] hidden_features_flat_9,
    input wire [15:0] hidden_features_flat_10, input wire [15:0] hidden_features_flat_11,
    input wire [15:0] hidden_features_flat_12, input wire [15:0] hidden_features_flat_13,
    input wire [15:0] hidden_features_flat_14, input wire [15:0] hidden_features_flat_15,
    input wire [15:0] hidden_features_flat_16, input wire [15:0] hidden_features_flat_17,
    input wire [15:0] hidden_features_flat_18, input wire [15:0] hidden_features_flat_19,
    input wire [15:0] hidden_features_flat_20, input wire [15:0] hidden_features_flat_21,
    input wire [15:0] hidden_features_flat_22, input wire [15:0] hidden_features_flat_23,
    input wire [15:0] hidden_features_flat_24, input wire [15:0] hidden_features_flat_25,
    input wire [15:0] hidden_features_flat_26, input wire [15:0] hidden_features_flat_27,
    input wire [15:0] hidden_features_flat_28, input wire [15:0] hidden_features_flat_29,
    input wire [15:0] hidden_features_flat_30, input wire [15:0] hidden_features_flat_31,
    input wire [15:0] hidden_features_flat_32, input wire [15:0] hidden_features_flat_33,
    input wire [15:0] hidden_features_flat_34, input wire [15:0] hidden_features_flat_35,
    input wire [15:0] hidden_features_flat_36, input wire [15:0] hidden_features_flat_37,
    input wire [15:0] hidden_features_flat_38, input wire [15:0] hidden_features_flat_39,
    input wire [15:0] hidden_features_flat_40, input wire [15:0] hidden_features_flat_41,
    input wire [15:0] hidden_features_flat_42, input wire [15:0] hidden_features_flat_43,
    input wire [15:0] hidden_features_flat_44, input wire [15:0] hidden_features_flat_45,
    input wire [15:0] hidden_features_flat_46, input wire [15:0] hidden_features_flat_47,
    input wire [15:0] hidden_features_flat_48, input wire [15:0] hidden_features_flat_49,
    input wire [15:0] hidden_features_flat_50, input wire [15:0] hidden_features_flat_51,
    input wire [15:0] hidden_features_flat_52, input wire [15:0] hidden_features_flat_53,
    input wire [15:0] hidden_features_flat_54, input wire [15:0] hidden_features_flat_55,
    input wire [15:0] hidden_features_flat_56, input wire [15:0] hidden_features_flat_57,
    input wire [15:0] hidden_features_flat_58, input wire [15:0] hidden_features_flat_59,
    input wire [15:0] hidden_features_flat_60, input wire [15:0] hidden_features_flat_61,
    input wire [15:0] hidden_features_flat_62, input wire [15:0] hidden_features_flat_63,
    input wire [15:0] hidden_features_flat_64, input wire [15:0] hidden_features_flat_65,
    input wire [15:0] hidden_features_flat_66, input wire [15:0] hidden_features_flat_67,
    input wire [15:0] hidden_features_flat_68, input wire [15:0] hidden_features_flat_69,
    input wire [15:0] hidden_features_flat_70, input wire [15:0] hidden_features_flat_71,
    input wire [15:0] hidden_features_flat_72, input wire [15:0] hidden_features_flat_73,
    input wire [15:0] hidden_features_flat_74, input wire [15:0] hidden_features_flat_75,
    input wire [15:0] hidden_features_flat_76, input wire [15:0] hidden_features_flat_77,
    input wire [15:0] hidden_features_flat_78, input wire [15:0] hidden_features_flat_79,
    input wire [15:0] hidden_features_flat_80, input wire [15:0] hidden_features_flat_81,
    input wire [15:0] hidden_features_flat_82, input wire [15:0] hidden_features_flat_83,
    input wire [15:0] hidden_features_flat_84, input wire [15:0] hidden_features_flat_85,
    input wire [15:0] hidden_features_flat_86, input wire [15:0] hidden_features_flat_87,
    input wire [15:0] hidden_features_flat_88, input wire [15:0] hidden_features_flat_89,
    input wire [15:0] hidden_features_flat_90, input wire [15:0] hidden_features_flat_91,
    input wire [15:0] hidden_features_flat_92, input wire [15:0] hidden_features_flat_93,
    input wire [15:0] hidden_features_flat_94, input wire [15:0] hidden_features_flat_95,
    input wire [15:0] hidden_features_flat_96, input wire [15:0] hidden_features_flat_97,
    input wire [15:0] hidden_features_flat_98, input wire [15:0] hidden_features_flat_99,
    input wire [15:0] hidden_features_flat_100, input wire [15:0] hidden_features_flat_101,
    input wire [15:0] hidden_features_flat_102, input wire [15:0] hidden_features_flat_103,
    input wire [15:0] hidden_features_flat_104, input wire [15:0] hidden_features_flat_105,
    input wire [15:0] hidden_features_flat_106, input wire [15:0] hidden_features_flat_107,
    input wire [15:0] hidden_features_flat_108, input wire [15:0] hidden_features_flat_109,
    input wire [15:0] hidden_features_flat_110, input wire [15:0] hidden_features_flat_111,
    input wire [15:0] hidden_features_flat_112, input wire [15:0] hidden_features_flat_113,
    input wire [15:0] hidden_features_flat_114, input wire [15:0] hidden_features_flat_115,
    input wire [15:0] hidden_features_flat_116, input wire [15:0] hidden_features_flat_117,
    input wire [15:0] hidden_features_flat_118, input wire [15:0] hidden_features_flat_119,
    input wire [15:0] hidden_features_flat_120, input wire [15:0] hidden_features_flat_121,
    input wire [15:0] hidden_features_flat_122, input wire [15:0] hidden_features_flat_123,
    input wire [15:0] hidden_features_flat_124, input wire [15:0] hidden_features_flat_125,
    input wire [15:0] hidden_features_flat_126, input wire [15:0] hidden_features_flat_127,
    input wire [15:0] hidden_features_flat_128, input wire [15:0] hidden_features_flat_129,
    input wire [15:0] hidden_features_flat_130, input wire [15:0] hidden_features_flat_131,
    input wire [15:0] hidden_features_flat_132, input wire [15:0] hidden_features_flat_133,
    input wire [15:0] hidden_features_flat_134, input wire [15:0] hidden_features_flat_135,
    input wire [15:0] hidden_features_flat_136, input wire [15:0] hidden_features_flat_137,
    input wire [15:0] hidden_features_flat_138, input wire [15:0] hidden_features_flat_139,
    input wire [15:0] hidden_features_flat_140, input wire [15:0] hidden_features_flat_141,
    input wire [15:0] hidden_features_flat_142, input wire [15:0] hidden_features_flat_143,
    input wire [15:0] hidden_features_flat_144, input wire [15:0] hidden_features_flat_145,
    input wire [15:0] hidden_features_flat_146, input wire [15:0] hidden_features_flat_147,
    input wire [15:0] hidden_features_flat_148, input wire [15:0] hidden_features_flat_149,
    input wire [15:0] hidden_features_flat_150, input wire [15:0] hidden_features_flat_151,
    input wire [15:0] hidden_features_flat_152, input wire [15:0] hidden_features_flat_153,
    input wire [15:0] hidden_features_flat_154, input wire [15:0] hidden_features_flat_155,
    input wire [15:0] hidden_features_flat_156, input wire [15:0] hidden_features_flat_157,
    input wire [15:0] hidden_features_flat_158, input wire [15:0] hidden_features_flat_159,
    input wire [15:0] hidden_features_flat_160, input wire [15:0] hidden_features_flat_161,
    input wire [15:0] hidden_features_flat_162, input wire [15:0] hidden_features_flat_163,
    input wire [15:0] hidden_features_flat_164, input wire [15:0] hidden_features_flat_165,
    input wire [15:0] hidden_features_flat_166, input wire [15:0] hidden_features_flat_167,
    input wire [15:0] hidden_features_flat_168, input wire [15:0] hidden_features_flat_169,
    input wire [15:0] hidden_features_flat_170, input wire [15:0] hidden_features_flat_171,
    input wire [15:0] hidden_features_flat_172, input wire [15:0] hidden_features_flat_173,
    input wire [15:0] hidden_features_flat_174, input wire [15:0] hidden_features_flat_175,
    input wire [15:0] hidden_features_flat_176, input wire [15:0] hidden_features_flat_177,
    input wire [15:0] hidden_features_flat_178, input wire [15:0] hidden_features_flat_179,
    input wire [15:0] hidden_features_flat_180, input wire [15:0] hidden_features_flat_181,
    input wire [15:0] hidden_features_flat_182, input wire [15:0] hidden_features_flat_183,
    input wire [15:0] hidden_features_flat_184, input wire [15:0] hidden_features_flat_185,
    input wire [15:0] hidden_features_flat_186, input wire [15:0] hidden_features_flat_187,
    input wire [15:0] hidden_features_flat_188, input wire [15:0] hidden_features_flat_189,
    input wire [15:0] hidden_features_flat_190, input wire [15:0] hidden_features_flat_191,
    input wire [15:0] hidden_features_flat_192, input wire [15:0] hidden_features_flat_193,
    input wire [15:0] hidden_features_flat_194, input wire [15:0] hidden_features_flat_195,
    input wire [15:0] hidden_features_flat_196, input wire [15:0] hidden_features_flat_197,
    input wire [15:0] hidden_features_flat_198, input wire [15:0] hidden_features_flat_199,
    input wire [15:0] hidden_features_flat_200, input wire [15:0] hidden_features_flat_201,
    input wire [15:0] hidden_features_flat_202, input wire [15:0] hidden_features_flat_203,
    input wire [15:0] hidden_features_flat_204, input wire [15:0] hidden_features_flat_205,
    input wire [15:0] hidden_features_flat_206, input wire [15:0] hidden_features_flat_207,
    input wire [15:0] hidden_features_flat_208, input wire [15:0] hidden_features_flat_209,
    input wire [15:0] hidden_features_flat_210, input wire [15:0] hidden_features_flat_211,
    input wire [15:0] hidden_features_flat_212, input wire [15:0] hidden_features_flat_213,
    input wire [15:0] hidden_features_flat_214, input wire [15:0] hidden_features_flat_215,
    input wire [15:0] hidden_features_flat_216, input wire [15:0] hidden_features_flat_217,
    input wire [15:0] hidden_features_flat_218, input wire [15:0] hidden_features_flat_219,
    input wire [15:0] hidden_features_flat_220, input wire [15:0] hidden_features_flat_221,
    input wire [15:0] hidden_features_flat_222, input wire [15:0] hidden_features_flat_223,
    input wire [15:0] hidden_features_flat_224, input wire [15:0] hidden_features_flat_225,
    input wire [15:0] hidden_features_flat_226, input wire [15:0] hidden_features_flat_227,
    input wire [15:0] hidden_features_flat_228, input wire [15:0] hidden_features_flat_229,
    input wire [15:0] hidden_features_flat_230, input wire [15:0] hidden_features_flat_231,
    input wire [15:0] hidden_features_flat_232, input wire [15:0] hidden_features_flat_233,
    input wire [15:0] hidden_features_flat_234, input wire [15:0] hidden_features_flat_235,
    input wire [15:0] hidden_features_flat_236, input wire [15:0] hidden_features_flat_237,
    input wire [15:0] hidden_features_flat_238, input wire [15:0] hidden_features_flat_239,
    input wire [15:0] hidden_features_flat_240, input wire [15:0] hidden_features_flat_241,
    input wire [15:0] hidden_features_flat_242, input wire [15:0] hidden_features_flat_243,
    input wire [15:0] hidden_features_flat_244, input wire [15:0] hidden_features_flat_245,
    input wire [15:0] hidden_features_flat_246, input wire [15:0] hidden_features_flat_247,
    input wire [15:0] hidden_features_flat_248, input wire [15:0] hidden_features_flat_249,
    input wire [15:0] hidden_features_flat_250, input wire [15:0] hidden_features_flat_251,
    input wire [15:0] hidden_features_flat_252, input wire [15:0] hidden_features_flat_253,
    input wire [15:0] hidden_features_flat_254, input wire [15:0] hidden_features_flat_255,
    output reg signed [15:0] output_probabilities_flat_0, output reg signed [15:0] output_probabilities_flat_1,
    output reg signed [15:0] output_probabilities_flat_2, output reg signed [15:0] output_probabilities_flat_3,
    output reg signed [15:0] output_probabilities_flat_4, output reg signed [15:0] output_probabilities_flat_5,
    output reg signed [15:0] output_probabilities_flat_6, output reg signed [15:0] output_probabilities_flat_7
);

    localparam NUM_FEATURES = 256;
    localparam NUM_NEURONS = 8;

    reg signed [15:0] hidden_features [0:NUM_FEATURES-1];
    reg signed [15:0] output_probabilities [0:NUM_NEURONS-1];
    reg signed [15:0] weights_flat [0:(NUM_NEURONS*NUM_FEATURES)-1];
    reg signed [15:0] biases [0:NUM_NEURONS-1];
    integer i, j;
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
        hidden_features[16] = hidden_features_flat_16; hidden_features[17] = hidden_features_flat_17;
        hidden_features[18] = hidden_features_flat_18; hidden_features[19] = hidden_features_flat_19;
        hidden_features[20] = hidden_features_flat_20; hidden_features[21] = hidden_features_flat_21;
        hidden_features[22] = hidden_features_flat_22; hidden_features[23] = hidden_features_flat_23;
        hidden_features[24] = hidden_features_flat_24; hidden_features[25] = hidden_features_flat_25;
        hidden_features[26] = hidden_features_flat_26; hidden_features[27] = hidden_features_flat_27;
        hidden_features[28] = hidden_features_flat_28; hidden_features[29] = hidden_features_flat_29;
        hidden_features[30] = hidden_features_flat_30; hidden_features[31] = hidden_features_flat_31;
        hidden_features[32] = hidden_features_flat_32; hidden_features[33] = hidden_features_flat_33;
        hidden_features[34] = hidden_features_flat_34; hidden_features[35] = hidden_features_flat_35;
        hidden_features[36] = hidden_features_flat_36; hidden_features[37] = hidden_features_flat_37;
        hidden_features[38] = hidden_features_flat_38; hidden_features[39] = hidden_features_flat_39;
        hidden_features[40] = hidden_features_flat_40; hidden_features[41] = hidden_features_flat_41;
        hidden_features[42] = hidden_features_flat_42; hidden_features[43] = hidden_features_flat_43;
        hidden_features[44] = hidden_features_flat_44; hidden_features[45] = hidden_features_flat_45;
        hidden_features[46] = hidden_features_flat_46; hidden_features[47] = hidden_features_flat_47;
        hidden_features[48] = hidden_features_flat_48; hidden_features[49] = hidden_features_flat_49;
        hidden_features[50] = hidden_features_flat_50; hidden_features[51] = hidden_features_flat_51;
        hidden_features[52] = hidden_features_flat_52; hidden_features[53] = hidden_features_flat_53;
        hidden_features[54] = hidden_features_flat_54; hidden_features[55] = hidden_features_flat_55;
        hidden_features[56] = hidden_features_flat_56; hidden_features[57] = hidden_features_flat_57;
        hidden_features[58] = hidden_features_flat_58; hidden_features[59] = hidden_features_flat_59;
        hidden_features[60] = hidden_features_flat_60; hidden_features[61] = hidden_features_flat_61;
        hidden_features[62] = hidden_features_flat_62; hidden_features[63] = hidden_features_flat_63;
        hidden_features[64] = hidden_features_flat_64; hidden_features[65] = hidden_features_flat_65;
        hidden_features[66] = hidden_features_flat_66; hidden_features[67] = hidden_features_flat_67;
        hidden_features[68] = hidden_features_flat_68; hidden_features[69] = hidden_features_flat_69;
        hidden_features[70] = hidden_features_flat_70; hidden_features[71] = hidden_features_flat_71;
        hidden_features[72] = hidden_features_flat_72; hidden_features[73] = hidden_features_flat_73;
        hidden_features[74] = hidden_features_flat_74; hidden_features[75] = hidden_features_flat_75;
        hidden_features[76] = hidden_features_flat_76; hidden_features[77] = hidden_features_flat_77;
        hidden_features[78] = hidden_features_flat_78; hidden_features[79] = hidden_features_flat_79;
        hidden_features[80] = hidden_features_flat_80; hidden_features[81] = hidden_features_flat_81;
        hidden_features[82] = hidden_features_flat_82; hidden_features[83] = hidden_features_flat_83;
        hidden_features[84] = hidden_features_flat_84; hidden_features[85] = hidden_features_flat_85;
        hidden_features[86] = hidden_features_flat_86; hidden_features[87] = hidden_features_flat_87;
        hidden_features[88] = hidden_features_flat_88; hidden_features[89] = hidden_features_flat_89;
        hidden_features[90] = hidden_features_flat_90; hidden_features[91] = hidden_features_flat_91;
        hidden_features[92] = hidden_features_flat_92; hidden_features[93] = hidden_features_flat_93;
        hidden_features[94] = hidden_features_flat_94; hidden_features[95] = hidden_features_flat_95;
        hidden_features[96] = hidden_features_flat_96; hidden_features[97] = hidden_features_flat_97;
        hidden_features[98] = hidden_features_flat_98; hidden_features[99] = hidden_features_flat_99;
        hidden_features[100] = hidden_features_flat_100; hidden_features[101] = hidden_features_flat_101;
        hidden_features[102] = hidden_features_flat_102; hidden_features[103] = hidden_features_flat_103;
        hidden_features[104] = hidden_features_flat_104; hidden_features[105] = hidden_features_flat_105;
        hidden_features[106] = hidden_features_flat_106; hidden_features[107] = hidden_features_flat_107;
        hidden_features[108] = hidden_features_flat_108; hidden_features[109] = hidden_features_flat_109;
        hidden_features[110] = hidden_features_flat_110; hidden_features[111] = hidden_features_flat_111;
        hidden_features[112] = hidden_features_flat_112; hidden_features[113] = hidden_features_flat_113;
        hidden_features[114] = hidden_features_flat_114; hidden_features[115] = hidden_features_flat_115;
        hidden_features[116] = hidden_features_flat_116; hidden_features[117] = hidden_features_flat_117;
        hidden_features[118] = hidden_features_flat_118; hidden_features[119] = hidden_features_flat_119;
        hidden_features[120] = hidden_features_flat_120; hidden_features[121] = hidden_features_flat_121;
        hidden_features[122] = hidden_features_flat_122; hidden_features[123] = hidden_features_flat_123;
        hidden_features[124] = hidden_features_flat_124; hidden_features[125] = hidden_features_flat_125;
        hidden_features[126] = hidden_features_flat_126; hidden_features[127] = hidden_features_flat_127;
        hidden_features[128] = hidden_features_flat_128; hidden_features[129] = hidden_features_flat_129;
        hidden_features[130] = hidden_features_flat_130; hidden_features[131] = hidden_features_flat_131;
        hidden_features[132] = hidden_features_flat_132; hidden_features[133] = hidden_features_flat_133;
        hidden_features[134] = hidden_features_flat_134; hidden_features[135] = hidden_features_flat_135;
        hidden_features[136] = hidden_features_flat_136; hidden_features[137] = hidden_features_flat_137;
        hidden_features[138] = hidden_features_flat_138; hidden_features[139] = hidden_features_flat_139;
        hidden_features[140] = hidden_features_flat_140; hidden_features[141] = hidden_features_flat_141;
        hidden_features[142] = hidden_features_flat_142; hidden_features[143] = hidden_features_flat_143;
        hidden_features[144] = hidden_features_flat_144; hidden_features[145] = hidden_features_flat_145;
        hidden_features[146] = hidden_features_flat_146; hidden_features[147] = hidden_features_flat_147;
        hidden_features[148] = hidden_features_flat_148; hidden_features[149] = hidden_features_flat_149;
        hidden_features[150] = hidden_features_flat_150; hidden_features[151] = hidden_features_flat_151;
        hidden_features[152] = hidden_features_flat_152; hidden_features[153] = hidden_features_flat_153;
        hidden_features[154] = hidden_features_flat_154; hidden_features[155] = hidden_features_flat_155;
        hidden_features[156] = hidden_features_flat_156; hidden_features[157] = hidden_features_flat_157;
        hidden_features[158] = hidden_features_flat_158; hidden_features[159] = hidden_features_flat_159;
        hidden_features[160] = hidden_features_flat_160; hidden_features[161] = hidden_features_flat_161;
        hidden_features[162] = hidden_features_flat_162; hidden_features[163] = hidden_features_flat_163;
        hidden_features[164] = hidden_features_flat_164; hidden_features[165] = hidden_features_flat_165;
        hidden_features[166] = hidden_features_flat_166; hidden_features[167] = hidden_features_flat_167;
        hidden_features[168] = hidden_features_flat_168; hidden_features[169] = hidden_features_flat_169;
        hidden_features[170] = hidden_features_flat_170; hidden_features[171] = hidden_features_flat_171;
        hidden_features[172] = hidden_features_flat_172; hidden_features[173] = hidden_features_flat_173;
        hidden_features[174] = hidden_features_flat_174; hidden_features[175] = hidden_features_flat_175;
        hidden_features[176] = hidden_features_flat_176; hidden_features[177] = hidden_features_flat_177;
        hidden_features[178] = hidden_features_flat_178; hidden_features[179] = hidden_features_flat_179;
        hidden_features[180] = hidden_features_flat_180; hidden_features[181] = hidden_features_flat_181;
        hidden_features[182] = hidden_features_flat_182; hidden_features[183] = hidden_features_flat_183;
        hidden_features[184] = hidden_features_flat_184; hidden_features[185] = hidden_features_flat_185;
        hidden_features[186] = hidden_features_flat_186; hidden_features[187] = hidden_features_flat_187;
        hidden_features[188] = hidden_features_flat_188; hidden_features[189] = hidden_features_flat_189;
        hidden_features[190] = hidden_features_flat_190; hidden_features[191] = hidden_features_flat_191;
        hidden_features[192] = hidden_features_flat_192; hidden_features[193] = hidden_features_flat_193;
        hidden_features[194] = hidden_features_flat_194; hidden_features[195] = hidden_features_flat_195;
        hidden_features[196] = hidden_features_flat_196; hidden_features[197] = hidden_features_flat_197;
        hidden_features[198] = hidden_features_flat_198; hidden_features[199] = hidden_features_flat_199;
        hidden_features[200] = hidden_features_flat_200; hidden_features[201] = hidden_features_flat_201;
        hidden_features[202] = hidden_features_flat_202; hidden_features[203] = hidden_features_flat_203;
        hidden_features[204] = hidden_features_flat_204; hidden_features[205] = hidden_features_flat_205;
        hidden_features[206] = hidden_features_flat_206; hidden_features[207] = hidden_features_flat_207;
        hidden_features[208] = hidden_features_flat_208; hidden_features[209] = hidden_features_flat_209;
        hidden_features[210] = hidden_features_flat_210; hidden_features[211] = hidden_features_flat_211;
        hidden_features[212] = hidden_features_flat_212; hidden_features[213] = hidden_features_flat_213;
        hidden_features[214] = hidden_features_flat_214; hidden_features[215] = hidden_features_flat_215;
        hidden_features[216] = hidden_features_flat_216; hidden_features[217] = hidden_features_flat_217;
        hidden_features[218] = hidden_features_flat_218; hidden_features[219] = hidden_features_flat_219;
        hidden_features[220] = hidden_features_flat_220; hidden_features[221] = hidden_features_flat_221;
        hidden_features[222] = hidden_features_flat_222; hidden_features[223] = hidden_features_flat_223;
        hidden_features[224] = hidden_features_flat_224; hidden_features[225] = hidden_features_flat_225;
        hidden_features[226] = hidden_features_flat_226; hidden_features[227] = hidden_features_flat_227;
        hidden_features[228] = hidden_features_flat_228; hidden_features[229] = hidden_features_flat_229;
        hidden_features[230] = hidden_features_flat_230; hidden_features[231] = hidden_features_flat_231;
        hidden_features[232] = hidden_features_flat_232; hidden_features[233] = hidden_features_flat_233;
        hidden_features[234] = hidden_features_flat_234; hidden_features[235] = hidden_features_flat_235;
        hidden_features[236] = hidden_features_flat_236; hidden_features[237] = hidden_features_flat_237;
        hidden_features[238] = hidden_features_flat_238; hidden_features[239] = hidden_features_flat_239;
        hidden_features[240] = hidden_features_flat_240; hidden_features[241] = hidden_features_flat_241;
        hidden_features[242] = hidden_features_flat_242; hidden_features[243] = hidden_features_flat_243;
        hidden_features[244] = hidden_features_flat_244; hidden_features[245] = hidden_features_flat_245;
        hidden_features[246] = hidden_features_flat_246; hidden_features[247] = hidden_features_flat_247;
        hidden_features[248] = hidden_features_flat_248; hidden_features[249] = hidden_features_flat_249;
        hidden_features[250] = hidden_features_flat_250; hidden_features[251] = hidden_features_flat_251;
        hidden_features[252] = hidden_features_flat_252; hidden_features[253] = hidden_features_flat_253;
        hidden_features[254] = hidden_features_flat_254; hidden_features[255] = hidden_features_flat_255;

        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            output_probabilities[i] = biases[i];
            for (j = 0; j < NUM_FEATURES; j = j + 1) begin
                product = hidden_features[j] * weights_flat[i * NUM_FEATURES + j];
                output_probabilities[i] = output_probabilities[i] + (product >>> 15);
            end
        end

        output_probabilities_flat_0 = output_probabilities[0]; output_probabilities_flat_1 = output_probabilities[1];
        output_probabilities_flat_2 = output_probabilities[2]; output_probabilities_flat_3 = output_probabilities[3];
        output_probabilities_flat_4 = output_probabilities[4]; output_probabilities_flat_5 = output_probabilities[5];
        output_probabilities_flat_6 = output_probabilities[6]; output_probabilities_flat_7 = output_probabilities[7];
    end

endmodule
