module dense_hidden (
    input wire clk,
    // First layer of the classifier: 78 segment-pooled, gain-normalized
    // Mel features in, 256 hidden pre-activations out (ReLU is applied
    // outside this module, by the same relu.v instances used on the
    // output layer - see top_module.v). NUM_NEURONS went from 16 to 256
    // after testing showed held-out accuracy kept climbing well past 16
    // units given enough real training data - see scripts/train.py.
    input wire [15:0] mfcc_features_flat_0, input wire [15:0] mfcc_features_flat_1,
    input wire [15:0] mfcc_features_flat_2, input wire [15:0] mfcc_features_flat_3,
    input wire [15:0] mfcc_features_flat_4, input wire [15:0] mfcc_features_flat_5,
    input wire [15:0] mfcc_features_flat_6, input wire [15:0] mfcc_features_flat_7,
    input wire [15:0] mfcc_features_flat_8, input wire [15:0] mfcc_features_flat_9,
    input wire [15:0] mfcc_features_flat_10, input wire [15:0] mfcc_features_flat_11,
    input wire [15:0] mfcc_features_flat_12, input wire [15:0] mfcc_features_flat_13,
    input wire [15:0] mfcc_features_flat_14, input wire [15:0] mfcc_features_flat_15,
    input wire [15:0] mfcc_features_flat_16, input wire [15:0] mfcc_features_flat_17,
    input wire [15:0] mfcc_features_flat_18, input wire [15:0] mfcc_features_flat_19,
    input wire [15:0] mfcc_features_flat_20, input wire [15:0] mfcc_features_flat_21,
    input wire [15:0] mfcc_features_flat_22, input wire [15:0] mfcc_features_flat_23,
    input wire [15:0] mfcc_features_flat_24, input wire [15:0] mfcc_features_flat_25,
    input wire [15:0] mfcc_features_flat_26, input wire [15:0] mfcc_features_flat_27,
    input wire [15:0] mfcc_features_flat_28, input wire [15:0] mfcc_features_flat_29,
    input wire [15:0] mfcc_features_flat_30, input wire [15:0] mfcc_features_flat_31,
    input wire [15:0] mfcc_features_flat_32, input wire [15:0] mfcc_features_flat_33,
    input wire [15:0] mfcc_features_flat_34, input wire [15:0] mfcc_features_flat_35,
    input wire [15:0] mfcc_features_flat_36, input wire [15:0] mfcc_features_flat_37,
    input wire [15:0] mfcc_features_flat_38, input wire [15:0] mfcc_features_flat_39,
    input wire [15:0] mfcc_features_flat_40, input wire [15:0] mfcc_features_flat_41,
    input wire [15:0] mfcc_features_flat_42, input wire [15:0] mfcc_features_flat_43,
    input wire [15:0] mfcc_features_flat_44, input wire [15:0] mfcc_features_flat_45,
    input wire [15:0] mfcc_features_flat_46, input wire [15:0] mfcc_features_flat_47,
    input wire [15:0] mfcc_features_flat_48, input wire [15:0] mfcc_features_flat_49,
    input wire [15:0] mfcc_features_flat_50, input wire [15:0] mfcc_features_flat_51,
    input wire [15:0] mfcc_features_flat_52, input wire [15:0] mfcc_features_flat_53,
    input wire [15:0] mfcc_features_flat_54, input wire [15:0] mfcc_features_flat_55,
    input wire [15:0] mfcc_features_flat_56, input wire [15:0] mfcc_features_flat_57,
    input wire [15:0] mfcc_features_flat_58, input wire [15:0] mfcc_features_flat_59,
    input wire [15:0] mfcc_features_flat_60, input wire [15:0] mfcc_features_flat_61,
    input wire [15:0] mfcc_features_flat_62, input wire [15:0] mfcc_features_flat_63,
    input wire [15:0] mfcc_features_flat_64, input wire [15:0] mfcc_features_flat_65,
    input wire [15:0] mfcc_features_flat_66, input wire [15:0] mfcc_features_flat_67,
    input wire [15:0] mfcc_features_flat_68, input wire [15:0] mfcc_features_flat_69,
    input wire [15:0] mfcc_features_flat_70, input wire [15:0] mfcc_features_flat_71,
    input wire [15:0] mfcc_features_flat_72, input wire [15:0] mfcc_features_flat_73,
    input wire [15:0] mfcc_features_flat_74, input wire [15:0] mfcc_features_flat_75,
    input wire [15:0] mfcc_features_flat_76, input wire [15:0] mfcc_features_flat_77,
    output reg signed [15:0] hidden_flat_0, output reg signed [15:0] hidden_flat_1,
    output reg signed [15:0] hidden_flat_2, output reg signed [15:0] hidden_flat_3,
    output reg signed [15:0] hidden_flat_4, output reg signed [15:0] hidden_flat_5,
    output reg signed [15:0] hidden_flat_6, output reg signed [15:0] hidden_flat_7,
    output reg signed [15:0] hidden_flat_8, output reg signed [15:0] hidden_flat_9,
    output reg signed [15:0] hidden_flat_10, output reg signed [15:0] hidden_flat_11,
    output reg signed [15:0] hidden_flat_12, output reg signed [15:0] hidden_flat_13,
    output reg signed [15:0] hidden_flat_14, output reg signed [15:0] hidden_flat_15,
    output reg signed [15:0] hidden_flat_16, output reg signed [15:0] hidden_flat_17,
    output reg signed [15:0] hidden_flat_18, output reg signed [15:0] hidden_flat_19,
    output reg signed [15:0] hidden_flat_20, output reg signed [15:0] hidden_flat_21,
    output reg signed [15:0] hidden_flat_22, output reg signed [15:0] hidden_flat_23,
    output reg signed [15:0] hidden_flat_24, output reg signed [15:0] hidden_flat_25,
    output reg signed [15:0] hidden_flat_26, output reg signed [15:0] hidden_flat_27,
    output reg signed [15:0] hidden_flat_28, output reg signed [15:0] hidden_flat_29,
    output reg signed [15:0] hidden_flat_30, output reg signed [15:0] hidden_flat_31,
    output reg signed [15:0] hidden_flat_32, output reg signed [15:0] hidden_flat_33,
    output reg signed [15:0] hidden_flat_34, output reg signed [15:0] hidden_flat_35,
    output reg signed [15:0] hidden_flat_36, output reg signed [15:0] hidden_flat_37,
    output reg signed [15:0] hidden_flat_38, output reg signed [15:0] hidden_flat_39,
    output reg signed [15:0] hidden_flat_40, output reg signed [15:0] hidden_flat_41,
    output reg signed [15:0] hidden_flat_42, output reg signed [15:0] hidden_flat_43,
    output reg signed [15:0] hidden_flat_44, output reg signed [15:0] hidden_flat_45,
    output reg signed [15:0] hidden_flat_46, output reg signed [15:0] hidden_flat_47,
    output reg signed [15:0] hidden_flat_48, output reg signed [15:0] hidden_flat_49,
    output reg signed [15:0] hidden_flat_50, output reg signed [15:0] hidden_flat_51,
    output reg signed [15:0] hidden_flat_52, output reg signed [15:0] hidden_flat_53,
    output reg signed [15:0] hidden_flat_54, output reg signed [15:0] hidden_flat_55,
    output reg signed [15:0] hidden_flat_56, output reg signed [15:0] hidden_flat_57,
    output reg signed [15:0] hidden_flat_58, output reg signed [15:0] hidden_flat_59,
    output reg signed [15:0] hidden_flat_60, output reg signed [15:0] hidden_flat_61,
    output reg signed [15:0] hidden_flat_62, output reg signed [15:0] hidden_flat_63,
    output reg signed [15:0] hidden_flat_64, output reg signed [15:0] hidden_flat_65,
    output reg signed [15:0] hidden_flat_66, output reg signed [15:0] hidden_flat_67,
    output reg signed [15:0] hidden_flat_68, output reg signed [15:0] hidden_flat_69,
    output reg signed [15:0] hidden_flat_70, output reg signed [15:0] hidden_flat_71,
    output reg signed [15:0] hidden_flat_72, output reg signed [15:0] hidden_flat_73,
    output reg signed [15:0] hidden_flat_74, output reg signed [15:0] hidden_flat_75,
    output reg signed [15:0] hidden_flat_76, output reg signed [15:0] hidden_flat_77,
    output reg signed [15:0] hidden_flat_78, output reg signed [15:0] hidden_flat_79,
    output reg signed [15:0] hidden_flat_80, output reg signed [15:0] hidden_flat_81,
    output reg signed [15:0] hidden_flat_82, output reg signed [15:0] hidden_flat_83,
    output reg signed [15:0] hidden_flat_84, output reg signed [15:0] hidden_flat_85,
    output reg signed [15:0] hidden_flat_86, output reg signed [15:0] hidden_flat_87,
    output reg signed [15:0] hidden_flat_88, output reg signed [15:0] hidden_flat_89,
    output reg signed [15:0] hidden_flat_90, output reg signed [15:0] hidden_flat_91,
    output reg signed [15:0] hidden_flat_92, output reg signed [15:0] hidden_flat_93,
    output reg signed [15:0] hidden_flat_94, output reg signed [15:0] hidden_flat_95,
    output reg signed [15:0] hidden_flat_96, output reg signed [15:0] hidden_flat_97,
    output reg signed [15:0] hidden_flat_98, output reg signed [15:0] hidden_flat_99,
    output reg signed [15:0] hidden_flat_100, output reg signed [15:0] hidden_flat_101,
    output reg signed [15:0] hidden_flat_102, output reg signed [15:0] hidden_flat_103,
    output reg signed [15:0] hidden_flat_104, output reg signed [15:0] hidden_flat_105,
    output reg signed [15:0] hidden_flat_106, output reg signed [15:0] hidden_flat_107,
    output reg signed [15:0] hidden_flat_108, output reg signed [15:0] hidden_flat_109,
    output reg signed [15:0] hidden_flat_110, output reg signed [15:0] hidden_flat_111,
    output reg signed [15:0] hidden_flat_112, output reg signed [15:0] hidden_flat_113,
    output reg signed [15:0] hidden_flat_114, output reg signed [15:0] hidden_flat_115,
    output reg signed [15:0] hidden_flat_116, output reg signed [15:0] hidden_flat_117,
    output reg signed [15:0] hidden_flat_118, output reg signed [15:0] hidden_flat_119,
    output reg signed [15:0] hidden_flat_120, output reg signed [15:0] hidden_flat_121,
    output reg signed [15:0] hidden_flat_122, output reg signed [15:0] hidden_flat_123,
    output reg signed [15:0] hidden_flat_124, output reg signed [15:0] hidden_flat_125,
    output reg signed [15:0] hidden_flat_126, output reg signed [15:0] hidden_flat_127,
    output reg signed [15:0] hidden_flat_128, output reg signed [15:0] hidden_flat_129,
    output reg signed [15:0] hidden_flat_130, output reg signed [15:0] hidden_flat_131,
    output reg signed [15:0] hidden_flat_132, output reg signed [15:0] hidden_flat_133,
    output reg signed [15:0] hidden_flat_134, output reg signed [15:0] hidden_flat_135,
    output reg signed [15:0] hidden_flat_136, output reg signed [15:0] hidden_flat_137,
    output reg signed [15:0] hidden_flat_138, output reg signed [15:0] hidden_flat_139,
    output reg signed [15:0] hidden_flat_140, output reg signed [15:0] hidden_flat_141,
    output reg signed [15:0] hidden_flat_142, output reg signed [15:0] hidden_flat_143,
    output reg signed [15:0] hidden_flat_144, output reg signed [15:0] hidden_flat_145,
    output reg signed [15:0] hidden_flat_146, output reg signed [15:0] hidden_flat_147,
    output reg signed [15:0] hidden_flat_148, output reg signed [15:0] hidden_flat_149,
    output reg signed [15:0] hidden_flat_150, output reg signed [15:0] hidden_flat_151,
    output reg signed [15:0] hidden_flat_152, output reg signed [15:0] hidden_flat_153,
    output reg signed [15:0] hidden_flat_154, output reg signed [15:0] hidden_flat_155,
    output reg signed [15:0] hidden_flat_156, output reg signed [15:0] hidden_flat_157,
    output reg signed [15:0] hidden_flat_158, output reg signed [15:0] hidden_flat_159,
    output reg signed [15:0] hidden_flat_160, output reg signed [15:0] hidden_flat_161,
    output reg signed [15:0] hidden_flat_162, output reg signed [15:0] hidden_flat_163,
    output reg signed [15:0] hidden_flat_164, output reg signed [15:0] hidden_flat_165,
    output reg signed [15:0] hidden_flat_166, output reg signed [15:0] hidden_flat_167,
    output reg signed [15:0] hidden_flat_168, output reg signed [15:0] hidden_flat_169,
    output reg signed [15:0] hidden_flat_170, output reg signed [15:0] hidden_flat_171,
    output reg signed [15:0] hidden_flat_172, output reg signed [15:0] hidden_flat_173,
    output reg signed [15:0] hidden_flat_174, output reg signed [15:0] hidden_flat_175,
    output reg signed [15:0] hidden_flat_176, output reg signed [15:0] hidden_flat_177,
    output reg signed [15:0] hidden_flat_178, output reg signed [15:0] hidden_flat_179,
    output reg signed [15:0] hidden_flat_180, output reg signed [15:0] hidden_flat_181,
    output reg signed [15:0] hidden_flat_182, output reg signed [15:0] hidden_flat_183,
    output reg signed [15:0] hidden_flat_184, output reg signed [15:0] hidden_flat_185,
    output reg signed [15:0] hidden_flat_186, output reg signed [15:0] hidden_flat_187,
    output reg signed [15:0] hidden_flat_188, output reg signed [15:0] hidden_flat_189,
    output reg signed [15:0] hidden_flat_190, output reg signed [15:0] hidden_flat_191,
    output reg signed [15:0] hidden_flat_192, output reg signed [15:0] hidden_flat_193,
    output reg signed [15:0] hidden_flat_194, output reg signed [15:0] hidden_flat_195,
    output reg signed [15:0] hidden_flat_196, output reg signed [15:0] hidden_flat_197,
    output reg signed [15:0] hidden_flat_198, output reg signed [15:0] hidden_flat_199,
    output reg signed [15:0] hidden_flat_200, output reg signed [15:0] hidden_flat_201,
    output reg signed [15:0] hidden_flat_202, output reg signed [15:0] hidden_flat_203,
    output reg signed [15:0] hidden_flat_204, output reg signed [15:0] hidden_flat_205,
    output reg signed [15:0] hidden_flat_206, output reg signed [15:0] hidden_flat_207,
    output reg signed [15:0] hidden_flat_208, output reg signed [15:0] hidden_flat_209,
    output reg signed [15:0] hidden_flat_210, output reg signed [15:0] hidden_flat_211,
    output reg signed [15:0] hidden_flat_212, output reg signed [15:0] hidden_flat_213,
    output reg signed [15:0] hidden_flat_214, output reg signed [15:0] hidden_flat_215,
    output reg signed [15:0] hidden_flat_216, output reg signed [15:0] hidden_flat_217,
    output reg signed [15:0] hidden_flat_218, output reg signed [15:0] hidden_flat_219,
    output reg signed [15:0] hidden_flat_220, output reg signed [15:0] hidden_flat_221,
    output reg signed [15:0] hidden_flat_222, output reg signed [15:0] hidden_flat_223,
    output reg signed [15:0] hidden_flat_224, output reg signed [15:0] hidden_flat_225,
    output reg signed [15:0] hidden_flat_226, output reg signed [15:0] hidden_flat_227,
    output reg signed [15:0] hidden_flat_228, output reg signed [15:0] hidden_flat_229,
    output reg signed [15:0] hidden_flat_230, output reg signed [15:0] hidden_flat_231,
    output reg signed [15:0] hidden_flat_232, output reg signed [15:0] hidden_flat_233,
    output reg signed [15:0] hidden_flat_234, output reg signed [15:0] hidden_flat_235,
    output reg signed [15:0] hidden_flat_236, output reg signed [15:0] hidden_flat_237,
    output reg signed [15:0] hidden_flat_238, output reg signed [15:0] hidden_flat_239,
    output reg signed [15:0] hidden_flat_240, output reg signed [15:0] hidden_flat_241,
    output reg signed [15:0] hidden_flat_242, output reg signed [15:0] hidden_flat_243,
    output reg signed [15:0] hidden_flat_244, output reg signed [15:0] hidden_flat_245,
    output reg signed [15:0] hidden_flat_246, output reg signed [15:0] hidden_flat_247,
    output reg signed [15:0] hidden_flat_248, output reg signed [15:0] hidden_flat_249,
    output reg signed [15:0] hidden_flat_250, output reg signed [15:0] hidden_flat_251,
    output reg signed [15:0] hidden_flat_252, output reg signed [15:0] hidden_flat_253,
    output reg signed [15:0] hidden_flat_254, output reg signed [15:0] hidden_flat_255
);

    localparam NUM_FEATURES = 78;
    localparam NUM_NEURONS = 256;

    reg signed [15:0] mfcc_features [0:NUM_FEATURES-1];
    reg signed [15:0] hidden [0:NUM_NEURONS-1];
    reg signed [15:0] weights_flat [0:(NUM_NEURONS*NUM_FEATURES)-1];
    reg signed [15:0] biases [0:NUM_NEURONS-1];
    integer i, j;
    reg signed [31:0] product; // see fft.v for why this has to be explicit

    initial begin
        $readmemh("hidden_weights.mem", weights_flat);
        $readmemh("hidden_biases.mem", biases);
    end

    always @(posedge clk) begin
        mfcc_features[0] = mfcc_features_flat_0; mfcc_features[1] = mfcc_features_flat_1;
        mfcc_features[2] = mfcc_features_flat_2; mfcc_features[3] = mfcc_features_flat_3;
        mfcc_features[4] = mfcc_features_flat_4; mfcc_features[5] = mfcc_features_flat_5;
        mfcc_features[6] = mfcc_features_flat_6; mfcc_features[7] = mfcc_features_flat_7;
        mfcc_features[8] = mfcc_features_flat_8; mfcc_features[9] = mfcc_features_flat_9;
        mfcc_features[10] = mfcc_features_flat_10; mfcc_features[11] = mfcc_features_flat_11;
        mfcc_features[12] = mfcc_features_flat_12; mfcc_features[13] = mfcc_features_flat_13;
        mfcc_features[14] = mfcc_features_flat_14; mfcc_features[15] = mfcc_features_flat_15;
        mfcc_features[16] = mfcc_features_flat_16; mfcc_features[17] = mfcc_features_flat_17;
        mfcc_features[18] = mfcc_features_flat_18; mfcc_features[19] = mfcc_features_flat_19;
        mfcc_features[20] = mfcc_features_flat_20; mfcc_features[21] = mfcc_features_flat_21;
        mfcc_features[22] = mfcc_features_flat_22; mfcc_features[23] = mfcc_features_flat_23;
        mfcc_features[24] = mfcc_features_flat_24; mfcc_features[25] = mfcc_features_flat_25;
        mfcc_features[26] = mfcc_features_flat_26; mfcc_features[27] = mfcc_features_flat_27;
        mfcc_features[28] = mfcc_features_flat_28; mfcc_features[29] = mfcc_features_flat_29;
        mfcc_features[30] = mfcc_features_flat_30; mfcc_features[31] = mfcc_features_flat_31;
        mfcc_features[32] = mfcc_features_flat_32; mfcc_features[33] = mfcc_features_flat_33;
        mfcc_features[34] = mfcc_features_flat_34; mfcc_features[35] = mfcc_features_flat_35;
        mfcc_features[36] = mfcc_features_flat_36; mfcc_features[37] = mfcc_features_flat_37;
        mfcc_features[38] = mfcc_features_flat_38; mfcc_features[39] = mfcc_features_flat_39;
        mfcc_features[40] = mfcc_features_flat_40; mfcc_features[41] = mfcc_features_flat_41;
        mfcc_features[42] = mfcc_features_flat_42; mfcc_features[43] = mfcc_features_flat_43;
        mfcc_features[44] = mfcc_features_flat_44; mfcc_features[45] = mfcc_features_flat_45;
        mfcc_features[46] = mfcc_features_flat_46; mfcc_features[47] = mfcc_features_flat_47;
        mfcc_features[48] = mfcc_features_flat_48; mfcc_features[49] = mfcc_features_flat_49;
        mfcc_features[50] = mfcc_features_flat_50; mfcc_features[51] = mfcc_features_flat_51;
        mfcc_features[52] = mfcc_features_flat_52; mfcc_features[53] = mfcc_features_flat_53;
        mfcc_features[54] = mfcc_features_flat_54; mfcc_features[55] = mfcc_features_flat_55;
        mfcc_features[56] = mfcc_features_flat_56; mfcc_features[57] = mfcc_features_flat_57;
        mfcc_features[58] = mfcc_features_flat_58; mfcc_features[59] = mfcc_features_flat_59;
        mfcc_features[60] = mfcc_features_flat_60; mfcc_features[61] = mfcc_features_flat_61;
        mfcc_features[62] = mfcc_features_flat_62; mfcc_features[63] = mfcc_features_flat_63;
        mfcc_features[64] = mfcc_features_flat_64; mfcc_features[65] = mfcc_features_flat_65;
        mfcc_features[66] = mfcc_features_flat_66; mfcc_features[67] = mfcc_features_flat_67;
        mfcc_features[68] = mfcc_features_flat_68; mfcc_features[69] = mfcc_features_flat_69;
        mfcc_features[70] = mfcc_features_flat_70; mfcc_features[71] = mfcc_features_flat_71;
        mfcc_features[72] = mfcc_features_flat_72; mfcc_features[73] = mfcc_features_flat_73;
        mfcc_features[74] = mfcc_features_flat_74; mfcc_features[75] = mfcc_features_flat_75;
        mfcc_features[76] = mfcc_features_flat_76; mfcc_features[77] = mfcc_features_flat_77;

        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            hidden[i] = biases[i];
            for (j = 0; j < NUM_FEATURES; j = j + 1) begin
                product = mfcc_features[j] * weights_flat[i * NUM_FEATURES + j];
                hidden[i] = hidden[i] + (product >>> 15);
            end
        end

        hidden_flat_0 = hidden[0];   hidden_flat_1 = hidden[1];
        hidden_flat_2 = hidden[2];   hidden_flat_3 = hidden[3];
        hidden_flat_4 = hidden[4];   hidden_flat_5 = hidden[5];
        hidden_flat_6 = hidden[6];   hidden_flat_7 = hidden[7];
        hidden_flat_8 = hidden[8];   hidden_flat_9 = hidden[9];
        hidden_flat_10 = hidden[10];   hidden_flat_11 = hidden[11];
        hidden_flat_12 = hidden[12];   hidden_flat_13 = hidden[13];
        hidden_flat_14 = hidden[14];   hidden_flat_15 = hidden[15];
        hidden_flat_16 = hidden[16];   hidden_flat_17 = hidden[17];
        hidden_flat_18 = hidden[18];   hidden_flat_19 = hidden[19];
        hidden_flat_20 = hidden[20];   hidden_flat_21 = hidden[21];
        hidden_flat_22 = hidden[22];   hidden_flat_23 = hidden[23];
        hidden_flat_24 = hidden[24];   hidden_flat_25 = hidden[25];
        hidden_flat_26 = hidden[26];   hidden_flat_27 = hidden[27];
        hidden_flat_28 = hidden[28];   hidden_flat_29 = hidden[29];
        hidden_flat_30 = hidden[30];   hidden_flat_31 = hidden[31];
        hidden_flat_32 = hidden[32];   hidden_flat_33 = hidden[33];
        hidden_flat_34 = hidden[34];   hidden_flat_35 = hidden[35];
        hidden_flat_36 = hidden[36];   hidden_flat_37 = hidden[37];
        hidden_flat_38 = hidden[38];   hidden_flat_39 = hidden[39];
        hidden_flat_40 = hidden[40];   hidden_flat_41 = hidden[41];
        hidden_flat_42 = hidden[42];   hidden_flat_43 = hidden[43];
        hidden_flat_44 = hidden[44];   hidden_flat_45 = hidden[45];
        hidden_flat_46 = hidden[46];   hidden_flat_47 = hidden[47];
        hidden_flat_48 = hidden[48];   hidden_flat_49 = hidden[49];
        hidden_flat_50 = hidden[50];   hidden_flat_51 = hidden[51];
        hidden_flat_52 = hidden[52];   hidden_flat_53 = hidden[53];
        hidden_flat_54 = hidden[54];   hidden_flat_55 = hidden[55];
        hidden_flat_56 = hidden[56];   hidden_flat_57 = hidden[57];
        hidden_flat_58 = hidden[58];   hidden_flat_59 = hidden[59];
        hidden_flat_60 = hidden[60];   hidden_flat_61 = hidden[61];
        hidden_flat_62 = hidden[62];   hidden_flat_63 = hidden[63];
        hidden_flat_64 = hidden[64];   hidden_flat_65 = hidden[65];
        hidden_flat_66 = hidden[66];   hidden_flat_67 = hidden[67];
        hidden_flat_68 = hidden[68];   hidden_flat_69 = hidden[69];
        hidden_flat_70 = hidden[70];   hidden_flat_71 = hidden[71];
        hidden_flat_72 = hidden[72];   hidden_flat_73 = hidden[73];
        hidden_flat_74 = hidden[74];   hidden_flat_75 = hidden[75];
        hidden_flat_76 = hidden[76];   hidden_flat_77 = hidden[77];
        hidden_flat_78 = hidden[78];   hidden_flat_79 = hidden[79];
        hidden_flat_80 = hidden[80];   hidden_flat_81 = hidden[81];
        hidden_flat_82 = hidden[82];   hidden_flat_83 = hidden[83];
        hidden_flat_84 = hidden[84];   hidden_flat_85 = hidden[85];
        hidden_flat_86 = hidden[86];   hidden_flat_87 = hidden[87];
        hidden_flat_88 = hidden[88];   hidden_flat_89 = hidden[89];
        hidden_flat_90 = hidden[90];   hidden_flat_91 = hidden[91];
        hidden_flat_92 = hidden[92];   hidden_flat_93 = hidden[93];
        hidden_flat_94 = hidden[94];   hidden_flat_95 = hidden[95];
        hidden_flat_96 = hidden[96];   hidden_flat_97 = hidden[97];
        hidden_flat_98 = hidden[98];   hidden_flat_99 = hidden[99];
        hidden_flat_100 = hidden[100];   hidden_flat_101 = hidden[101];
        hidden_flat_102 = hidden[102];   hidden_flat_103 = hidden[103];
        hidden_flat_104 = hidden[104];   hidden_flat_105 = hidden[105];
        hidden_flat_106 = hidden[106];   hidden_flat_107 = hidden[107];
        hidden_flat_108 = hidden[108];   hidden_flat_109 = hidden[109];
        hidden_flat_110 = hidden[110];   hidden_flat_111 = hidden[111];
        hidden_flat_112 = hidden[112];   hidden_flat_113 = hidden[113];
        hidden_flat_114 = hidden[114];   hidden_flat_115 = hidden[115];
        hidden_flat_116 = hidden[116];   hidden_flat_117 = hidden[117];
        hidden_flat_118 = hidden[118];   hidden_flat_119 = hidden[119];
        hidden_flat_120 = hidden[120];   hidden_flat_121 = hidden[121];
        hidden_flat_122 = hidden[122];   hidden_flat_123 = hidden[123];
        hidden_flat_124 = hidden[124];   hidden_flat_125 = hidden[125];
        hidden_flat_126 = hidden[126];   hidden_flat_127 = hidden[127];
        hidden_flat_128 = hidden[128];   hidden_flat_129 = hidden[129];
        hidden_flat_130 = hidden[130];   hidden_flat_131 = hidden[131];
        hidden_flat_132 = hidden[132];   hidden_flat_133 = hidden[133];
        hidden_flat_134 = hidden[134];   hidden_flat_135 = hidden[135];
        hidden_flat_136 = hidden[136];   hidden_flat_137 = hidden[137];
        hidden_flat_138 = hidden[138];   hidden_flat_139 = hidden[139];
        hidden_flat_140 = hidden[140];   hidden_flat_141 = hidden[141];
        hidden_flat_142 = hidden[142];   hidden_flat_143 = hidden[143];
        hidden_flat_144 = hidden[144];   hidden_flat_145 = hidden[145];
        hidden_flat_146 = hidden[146];   hidden_flat_147 = hidden[147];
        hidden_flat_148 = hidden[148];   hidden_flat_149 = hidden[149];
        hidden_flat_150 = hidden[150];   hidden_flat_151 = hidden[151];
        hidden_flat_152 = hidden[152];   hidden_flat_153 = hidden[153];
        hidden_flat_154 = hidden[154];   hidden_flat_155 = hidden[155];
        hidden_flat_156 = hidden[156];   hidden_flat_157 = hidden[157];
        hidden_flat_158 = hidden[158];   hidden_flat_159 = hidden[159];
        hidden_flat_160 = hidden[160];   hidden_flat_161 = hidden[161];
        hidden_flat_162 = hidden[162];   hidden_flat_163 = hidden[163];
        hidden_flat_164 = hidden[164];   hidden_flat_165 = hidden[165];
        hidden_flat_166 = hidden[166];   hidden_flat_167 = hidden[167];
        hidden_flat_168 = hidden[168];   hidden_flat_169 = hidden[169];
        hidden_flat_170 = hidden[170];   hidden_flat_171 = hidden[171];
        hidden_flat_172 = hidden[172];   hidden_flat_173 = hidden[173];
        hidden_flat_174 = hidden[174];   hidden_flat_175 = hidden[175];
        hidden_flat_176 = hidden[176];   hidden_flat_177 = hidden[177];
        hidden_flat_178 = hidden[178];   hidden_flat_179 = hidden[179];
        hidden_flat_180 = hidden[180];   hidden_flat_181 = hidden[181];
        hidden_flat_182 = hidden[182];   hidden_flat_183 = hidden[183];
        hidden_flat_184 = hidden[184];   hidden_flat_185 = hidden[185];
        hidden_flat_186 = hidden[186];   hidden_flat_187 = hidden[187];
        hidden_flat_188 = hidden[188];   hidden_flat_189 = hidden[189];
        hidden_flat_190 = hidden[190];   hidden_flat_191 = hidden[191];
        hidden_flat_192 = hidden[192];   hidden_flat_193 = hidden[193];
        hidden_flat_194 = hidden[194];   hidden_flat_195 = hidden[195];
        hidden_flat_196 = hidden[196];   hidden_flat_197 = hidden[197];
        hidden_flat_198 = hidden[198];   hidden_flat_199 = hidden[199];
        hidden_flat_200 = hidden[200];   hidden_flat_201 = hidden[201];
        hidden_flat_202 = hidden[202];   hidden_flat_203 = hidden[203];
        hidden_flat_204 = hidden[204];   hidden_flat_205 = hidden[205];
        hidden_flat_206 = hidden[206];   hidden_flat_207 = hidden[207];
        hidden_flat_208 = hidden[208];   hidden_flat_209 = hidden[209];
        hidden_flat_210 = hidden[210];   hidden_flat_211 = hidden[211];
        hidden_flat_212 = hidden[212];   hidden_flat_213 = hidden[213];
        hidden_flat_214 = hidden[214];   hidden_flat_215 = hidden[215];
        hidden_flat_216 = hidden[216];   hidden_flat_217 = hidden[217];
        hidden_flat_218 = hidden[218];   hidden_flat_219 = hidden[219];
        hidden_flat_220 = hidden[220];   hidden_flat_221 = hidden[221];
        hidden_flat_222 = hidden[222];   hidden_flat_223 = hidden[223];
        hidden_flat_224 = hidden[224];   hidden_flat_225 = hidden[225];
        hidden_flat_226 = hidden[226];   hidden_flat_227 = hidden[227];
        hidden_flat_228 = hidden[228];   hidden_flat_229 = hidden[229];
        hidden_flat_230 = hidden[230];   hidden_flat_231 = hidden[231];
        hidden_flat_232 = hidden[232];   hidden_flat_233 = hidden[233];
        hidden_flat_234 = hidden[234];   hidden_flat_235 = hidden[235];
        hidden_flat_236 = hidden[236];   hidden_flat_237 = hidden[237];
        hidden_flat_238 = hidden[238];   hidden_flat_239 = hidden[239];
        hidden_flat_240 = hidden[240];   hidden_flat_241 = hidden[241];
        hidden_flat_242 = hidden[242];   hidden_flat_243 = hidden[243];
        hidden_flat_244 = hidden[244];   hidden_flat_245 = hidden[245];
        hidden_flat_246 = hidden[246];   hidden_flat_247 = hidden[247];
        hidden_flat_248 = hidden[248];   hidden_flat_249 = hidden[249];
        hidden_flat_250 = hidden[250];   hidden_flat_251 = hidden[251];
        hidden_flat_252 = hidden[252];   hidden_flat_253 = hidden[253];
        hidden_flat_254 = hidden[254];   hidden_flat_255 = hidden[255];
    end

endmodule
