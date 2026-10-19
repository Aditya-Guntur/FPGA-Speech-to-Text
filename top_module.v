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
    // 32-bin direct-form DFT (see fft.v) - fft_out_0..31 real, fft_out_32..63 imaginary.
    wire [15:0] fft_out_0, fft_out_1, fft_out_2, fft_out_3;
    wire [15:0] fft_out_4, fft_out_5, fft_out_6, fft_out_7;
    wire [15:0] fft_out_8, fft_out_9, fft_out_10, fft_out_11;
    wire [15:0] fft_out_12, fft_out_13, fft_out_14, fft_out_15;
    wire [15:0] fft_out_16, fft_out_17, fft_out_18, fft_out_19;
    wire [15:0] fft_out_20, fft_out_21, fft_out_22, fft_out_23;
    wire [15:0] fft_out_24, fft_out_25, fft_out_26, fft_out_27;
    wire [15:0] fft_out_28, fft_out_29, fft_out_30, fft_out_31;
    wire [15:0] fft_out_32, fft_out_33, fft_out_34, fft_out_35;
    wire [15:0] fft_out_36, fft_out_37, fft_out_38, fft_out_39;
    wire [15:0] fft_out_40, fft_out_41, fft_out_42, fft_out_43;
    wire [15:0] fft_out_44, fft_out_45, fft_out_46, fft_out_47;
    wire [15:0] fft_out_48, fft_out_49, fft_out_50, fft_out_51;
    wire [15:0] fft_out_52, fft_out_53, fft_out_54, fft_out_55;
    wire [15:0] fft_out_56, fft_out_57, fft_out_58, fft_out_59;
    wire [15:0] fft_out_60, fft_out_61, fft_out_62, fft_out_63;

    wire [15:0] mel_out_0, mel_out_1, mel_out_2, mel_out_3;
    wire [15:0] mel_out_4, mel_out_5, mel_out_6, mel_out_7;
    wire [15:0] mel_out_8, mel_out_9, mel_out_10, mel_out_11, mel_out_12;

    // 6 segments x 13 Mel bands = 78 - see segment_buffer.v.
    wire signed [15:0] seg_feat_0, seg_feat_1, seg_feat_2, seg_feat_3, seg_feat_4, seg_feat_5;
    wire signed [15:0] seg_feat_6, seg_feat_7, seg_feat_8, seg_feat_9, seg_feat_10, seg_feat_11;
    wire signed [15:0] seg_feat_12, seg_feat_13, seg_feat_14, seg_feat_15, seg_feat_16, seg_feat_17;
    wire signed [15:0] seg_feat_18, seg_feat_19, seg_feat_20, seg_feat_21, seg_feat_22, seg_feat_23;
    wire signed [15:0] seg_feat_24, seg_feat_25, seg_feat_26, seg_feat_27, seg_feat_28, seg_feat_29;
    wire signed [15:0] seg_feat_30, seg_feat_31, seg_feat_32, seg_feat_33, seg_feat_34, seg_feat_35;
    wire signed [15:0] seg_feat_36, seg_feat_37, seg_feat_38, seg_feat_39, seg_feat_40, seg_feat_41;
    wire signed [15:0] seg_feat_42, seg_feat_43, seg_feat_44, seg_feat_45, seg_feat_46, seg_feat_47;
    wire signed [15:0] seg_feat_48, seg_feat_49, seg_feat_50, seg_feat_51, seg_feat_52, seg_feat_53;
    wire signed [15:0] seg_feat_54, seg_feat_55, seg_feat_56, seg_feat_57, seg_feat_58, seg_feat_59;
    wire signed [15:0] seg_feat_60, seg_feat_61, seg_feat_62, seg_feat_63, seg_feat_64, seg_feat_65;
    wire signed [15:0] seg_feat_66, seg_feat_67, seg_feat_68, seg_feat_69, seg_feat_70, seg_feat_71;
    wire signed [15:0] seg_feat_72, seg_feat_73, seg_feat_74, seg_feat_75, seg_feat_76, seg_feat_77;

    // Same 78 values after gain_normalize.v's per-utterance loudness
    // compensation.
    wire signed [15:0] norm_feat_0, norm_feat_1, norm_feat_2, norm_feat_3, norm_feat_4, norm_feat_5;
    wire signed [15:0] norm_feat_6, norm_feat_7, norm_feat_8, norm_feat_9, norm_feat_10, norm_feat_11;
    wire signed [15:0] norm_feat_12, norm_feat_13, norm_feat_14, norm_feat_15, norm_feat_16, norm_feat_17;
    wire signed [15:0] norm_feat_18, norm_feat_19, norm_feat_20, norm_feat_21, norm_feat_22, norm_feat_23;
    wire signed [15:0] norm_feat_24, norm_feat_25, norm_feat_26, norm_feat_27, norm_feat_28, norm_feat_29;
    wire signed [15:0] norm_feat_30, norm_feat_31, norm_feat_32, norm_feat_33, norm_feat_34, norm_feat_35;
    wire signed [15:0] norm_feat_36, norm_feat_37, norm_feat_38, norm_feat_39, norm_feat_40, norm_feat_41;
    wire signed [15:0] norm_feat_42, norm_feat_43, norm_feat_44, norm_feat_45, norm_feat_46, norm_feat_47;
    wire signed [15:0] norm_feat_48, norm_feat_49, norm_feat_50, norm_feat_51, norm_feat_52, norm_feat_53;
    wire signed [15:0] norm_feat_54, norm_feat_55, norm_feat_56, norm_feat_57, norm_feat_58, norm_feat_59;
    wire signed [15:0] norm_feat_60, norm_feat_61, norm_feat_62, norm_feat_63, norm_feat_64, norm_feat_65;
    wire signed [15:0] norm_feat_66, norm_feat_67, norm_feat_68, norm_feat_69, norm_feat_70, norm_feat_71;
    wire signed [15:0] norm_feat_72, norm_feat_73, norm_feat_74, norm_feat_75, norm_feat_76, norm_feat_77;

    wire [15:0] hidden_0, hidden_1, hidden_2, hidden_3;
    wire [15:0] hidden_4, hidden_5, hidden_6, hidden_7;
    wire [15:0] hidden_8, hidden_9, hidden_10, hidden_11;
    wire [15:0] hidden_12, hidden_13, hidden_14, hidden_15;
    wire [15:0] hidden_16, hidden_17, hidden_18, hidden_19;
    wire [15:0] hidden_20, hidden_21, hidden_22, hidden_23;
    wire [15:0] hidden_24, hidden_25, hidden_26, hidden_27;
    wire [15:0] hidden_28, hidden_29, hidden_30, hidden_31;
    wire [15:0] hidden_32, hidden_33, hidden_34, hidden_35;
    wire [15:0] hidden_36, hidden_37, hidden_38, hidden_39;
    wire [15:0] hidden_40, hidden_41, hidden_42, hidden_43;
    wire [15:0] hidden_44, hidden_45, hidden_46, hidden_47;
    wire [15:0] hidden_48, hidden_49, hidden_50, hidden_51;
    wire [15:0] hidden_52, hidden_53, hidden_54, hidden_55;
    wire [15:0] hidden_56, hidden_57, hidden_58, hidden_59;
    wire [15:0] hidden_60, hidden_61, hidden_62, hidden_63;
    wire [15:0] hidden_64, hidden_65, hidden_66, hidden_67;
    wire [15:0] hidden_68, hidden_69, hidden_70, hidden_71;
    wire [15:0] hidden_72, hidden_73, hidden_74, hidden_75;
    wire [15:0] hidden_76, hidden_77, hidden_78, hidden_79;
    wire [15:0] hidden_80, hidden_81, hidden_82, hidden_83;
    wire [15:0] hidden_84, hidden_85, hidden_86, hidden_87;
    wire [15:0] hidden_88, hidden_89, hidden_90, hidden_91;
    wire [15:0] hidden_92, hidden_93, hidden_94, hidden_95;
    wire [15:0] hidden_96, hidden_97, hidden_98, hidden_99;
    wire [15:0] hidden_100, hidden_101, hidden_102, hidden_103;
    wire [15:0] hidden_104, hidden_105, hidden_106, hidden_107;
    wire [15:0] hidden_108, hidden_109, hidden_110, hidden_111;
    wire [15:0] hidden_112, hidden_113, hidden_114, hidden_115;
    wire [15:0] hidden_116, hidden_117, hidden_118, hidden_119;
    wire [15:0] hidden_120, hidden_121, hidden_122, hidden_123;
    wire [15:0] hidden_124, hidden_125, hidden_126, hidden_127;
    wire [15:0] hidden_128, hidden_129, hidden_130, hidden_131;
    wire [15:0] hidden_132, hidden_133, hidden_134, hidden_135;
    wire [15:0] hidden_136, hidden_137, hidden_138, hidden_139;
    wire [15:0] hidden_140, hidden_141, hidden_142, hidden_143;
    wire [15:0] hidden_144, hidden_145, hidden_146, hidden_147;
    wire [15:0] hidden_148, hidden_149, hidden_150, hidden_151;
    wire [15:0] hidden_152, hidden_153, hidden_154, hidden_155;
    wire [15:0] hidden_156, hidden_157, hidden_158, hidden_159;
    wire [15:0] hidden_160, hidden_161, hidden_162, hidden_163;
    wire [15:0] hidden_164, hidden_165, hidden_166, hidden_167;
    wire [15:0] hidden_168, hidden_169, hidden_170, hidden_171;
    wire [15:0] hidden_172, hidden_173, hidden_174, hidden_175;
    wire [15:0] hidden_176, hidden_177, hidden_178, hidden_179;
    wire [15:0] hidden_180, hidden_181, hidden_182, hidden_183;
    wire [15:0] hidden_184, hidden_185, hidden_186, hidden_187;
    wire [15:0] hidden_188, hidden_189, hidden_190, hidden_191;
    wire [15:0] hidden_192, hidden_193, hidden_194, hidden_195;
    wire [15:0] hidden_196, hidden_197, hidden_198, hidden_199;
    wire [15:0] hidden_200, hidden_201, hidden_202, hidden_203;
    wire [15:0] hidden_204, hidden_205, hidden_206, hidden_207;
    wire [15:0] hidden_208, hidden_209, hidden_210, hidden_211;
    wire [15:0] hidden_212, hidden_213, hidden_214, hidden_215;
    wire [15:0] hidden_216, hidden_217, hidden_218, hidden_219;
    wire [15:0] hidden_220, hidden_221, hidden_222, hidden_223;
    wire [15:0] hidden_224, hidden_225, hidden_226, hidden_227;
    wire [15:0] hidden_228, hidden_229, hidden_230, hidden_231;
    wire [15:0] hidden_232, hidden_233, hidden_234, hidden_235;
    wire [15:0] hidden_236, hidden_237, hidden_238, hidden_239;
    wire [15:0] hidden_240, hidden_241, hidden_242, hidden_243;
    wire [15:0] hidden_244, hidden_245, hidden_246, hidden_247;
    wire [15:0] hidden_248, hidden_249, hidden_250, hidden_251;
    wire [15:0] hidden_252, hidden_253, hidden_254, hidden_255;

    wire [15:0] hidden_relu_0, hidden_relu_1, hidden_relu_2, hidden_relu_3;
    wire [15:0] hidden_relu_4, hidden_relu_5, hidden_relu_6, hidden_relu_7;
    wire [15:0] hidden_relu_8, hidden_relu_9, hidden_relu_10, hidden_relu_11;
    wire [15:0] hidden_relu_12, hidden_relu_13, hidden_relu_14, hidden_relu_15;
    wire [15:0] hidden_relu_16, hidden_relu_17, hidden_relu_18, hidden_relu_19;
    wire [15:0] hidden_relu_20, hidden_relu_21, hidden_relu_22, hidden_relu_23;
    wire [15:0] hidden_relu_24, hidden_relu_25, hidden_relu_26, hidden_relu_27;
    wire [15:0] hidden_relu_28, hidden_relu_29, hidden_relu_30, hidden_relu_31;
    wire [15:0] hidden_relu_32, hidden_relu_33, hidden_relu_34, hidden_relu_35;
    wire [15:0] hidden_relu_36, hidden_relu_37, hidden_relu_38, hidden_relu_39;
    wire [15:0] hidden_relu_40, hidden_relu_41, hidden_relu_42, hidden_relu_43;
    wire [15:0] hidden_relu_44, hidden_relu_45, hidden_relu_46, hidden_relu_47;
    wire [15:0] hidden_relu_48, hidden_relu_49, hidden_relu_50, hidden_relu_51;
    wire [15:0] hidden_relu_52, hidden_relu_53, hidden_relu_54, hidden_relu_55;
    wire [15:0] hidden_relu_56, hidden_relu_57, hidden_relu_58, hidden_relu_59;
    wire [15:0] hidden_relu_60, hidden_relu_61, hidden_relu_62, hidden_relu_63;
    wire [15:0] hidden_relu_64, hidden_relu_65, hidden_relu_66, hidden_relu_67;
    wire [15:0] hidden_relu_68, hidden_relu_69, hidden_relu_70, hidden_relu_71;
    wire [15:0] hidden_relu_72, hidden_relu_73, hidden_relu_74, hidden_relu_75;
    wire [15:0] hidden_relu_76, hidden_relu_77, hidden_relu_78, hidden_relu_79;
    wire [15:0] hidden_relu_80, hidden_relu_81, hidden_relu_82, hidden_relu_83;
    wire [15:0] hidden_relu_84, hidden_relu_85, hidden_relu_86, hidden_relu_87;
    wire [15:0] hidden_relu_88, hidden_relu_89, hidden_relu_90, hidden_relu_91;
    wire [15:0] hidden_relu_92, hidden_relu_93, hidden_relu_94, hidden_relu_95;
    wire [15:0] hidden_relu_96, hidden_relu_97, hidden_relu_98, hidden_relu_99;
    wire [15:0] hidden_relu_100, hidden_relu_101, hidden_relu_102, hidden_relu_103;
    wire [15:0] hidden_relu_104, hidden_relu_105, hidden_relu_106, hidden_relu_107;
    wire [15:0] hidden_relu_108, hidden_relu_109, hidden_relu_110, hidden_relu_111;
    wire [15:0] hidden_relu_112, hidden_relu_113, hidden_relu_114, hidden_relu_115;
    wire [15:0] hidden_relu_116, hidden_relu_117, hidden_relu_118, hidden_relu_119;
    wire [15:0] hidden_relu_120, hidden_relu_121, hidden_relu_122, hidden_relu_123;
    wire [15:0] hidden_relu_124, hidden_relu_125, hidden_relu_126, hidden_relu_127;
    wire [15:0] hidden_relu_128, hidden_relu_129, hidden_relu_130, hidden_relu_131;
    wire [15:0] hidden_relu_132, hidden_relu_133, hidden_relu_134, hidden_relu_135;
    wire [15:0] hidden_relu_136, hidden_relu_137, hidden_relu_138, hidden_relu_139;
    wire [15:0] hidden_relu_140, hidden_relu_141, hidden_relu_142, hidden_relu_143;
    wire [15:0] hidden_relu_144, hidden_relu_145, hidden_relu_146, hidden_relu_147;
    wire [15:0] hidden_relu_148, hidden_relu_149, hidden_relu_150, hidden_relu_151;
    wire [15:0] hidden_relu_152, hidden_relu_153, hidden_relu_154, hidden_relu_155;
    wire [15:0] hidden_relu_156, hidden_relu_157, hidden_relu_158, hidden_relu_159;
    wire [15:0] hidden_relu_160, hidden_relu_161, hidden_relu_162, hidden_relu_163;
    wire [15:0] hidden_relu_164, hidden_relu_165, hidden_relu_166, hidden_relu_167;
    wire [15:0] hidden_relu_168, hidden_relu_169, hidden_relu_170, hidden_relu_171;
    wire [15:0] hidden_relu_172, hidden_relu_173, hidden_relu_174, hidden_relu_175;
    wire [15:0] hidden_relu_176, hidden_relu_177, hidden_relu_178, hidden_relu_179;
    wire [15:0] hidden_relu_180, hidden_relu_181, hidden_relu_182, hidden_relu_183;
    wire [15:0] hidden_relu_184, hidden_relu_185, hidden_relu_186, hidden_relu_187;
    wire [15:0] hidden_relu_188, hidden_relu_189, hidden_relu_190, hidden_relu_191;
    wire [15:0] hidden_relu_192, hidden_relu_193, hidden_relu_194, hidden_relu_195;
    wire [15:0] hidden_relu_196, hidden_relu_197, hidden_relu_198, hidden_relu_199;
    wire [15:0] hidden_relu_200, hidden_relu_201, hidden_relu_202, hidden_relu_203;
    wire [15:0] hidden_relu_204, hidden_relu_205, hidden_relu_206, hidden_relu_207;
    wire [15:0] hidden_relu_208, hidden_relu_209, hidden_relu_210, hidden_relu_211;
    wire [15:0] hidden_relu_212, hidden_relu_213, hidden_relu_214, hidden_relu_215;
    wire [15:0] hidden_relu_216, hidden_relu_217, hidden_relu_218, hidden_relu_219;
    wire [15:0] hidden_relu_220, hidden_relu_221, hidden_relu_222, hidden_relu_223;
    wire [15:0] hidden_relu_224, hidden_relu_225, hidden_relu_226, hidden_relu_227;
    wire [15:0] hidden_relu_228, hidden_relu_229, hidden_relu_230, hidden_relu_231;
    wire [15:0] hidden_relu_232, hidden_relu_233, hidden_relu_234, hidden_relu_235;
    wire [15:0] hidden_relu_236, hidden_relu_237, hidden_relu_238, hidden_relu_239;
    wire [15:0] hidden_relu_240, hidden_relu_241, hidden_relu_242, hidden_relu_243;
    wire [15:0] hidden_relu_244, hidden_relu_245, hidden_relu_246, hidden_relu_247;
    wire [15:0] hidden_relu_248, hidden_relu_249, hidden_relu_250, hidden_relu_251;
    wire [15:0] hidden_relu_252, hidden_relu_253, hidden_relu_254, hidden_relu_255;

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
        .fft_output_14(fft_out_14), .fft_output_15(fft_out_15),
        .fft_output_16(fft_out_16), .fft_output_17(fft_out_17),
        .fft_output_18(fft_out_18), .fft_output_19(fft_out_19),
        .fft_output_20(fft_out_20), .fft_output_21(fft_out_21),
        .fft_output_22(fft_out_22), .fft_output_23(fft_out_23),
        .fft_output_24(fft_out_24), .fft_output_25(fft_out_25),
        .fft_output_26(fft_out_26), .fft_output_27(fft_out_27),
        .fft_output_28(fft_out_28), .fft_output_29(fft_out_29),
        .fft_output_30(fft_out_30), .fft_output_31(fft_out_31),
        .fft_output_32(fft_out_32), .fft_output_33(fft_out_33),
        .fft_output_34(fft_out_34), .fft_output_35(fft_out_35),
        .fft_output_36(fft_out_36), .fft_output_37(fft_out_37),
        .fft_output_38(fft_out_38), .fft_output_39(fft_out_39),
        .fft_output_40(fft_out_40), .fft_output_41(fft_out_41),
        .fft_output_42(fft_out_42), .fft_output_43(fft_out_43),
        .fft_output_44(fft_out_44), .fft_output_45(fft_out_45),
        .fft_output_46(fft_out_46), .fft_output_47(fft_out_47),
        .fft_output_48(fft_out_48), .fft_output_49(fft_out_49),
        .fft_output_50(fft_out_50), .fft_output_51(fft_out_51),
        .fft_output_52(fft_out_52), .fft_output_53(fft_out_53),
        .fft_output_54(fft_out_54), .fft_output_55(fft_out_55),
        .fft_output_56(fft_out_56), .fft_output_57(fft_out_57),
        .fft_output_58(fft_out_58), .fft_output_59(fft_out_59),
        .fft_output_60(fft_out_60), .fft_output_61(fft_out_61),
        .fft_output_62(fft_out_62), .fft_output_63(fft_out_63)
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
        .fft_output_16(fft_out_16), .fft_output_17(fft_out_17),
        .fft_output_18(fft_out_18), .fft_output_19(fft_out_19),
        .fft_output_20(fft_out_20), .fft_output_21(fft_out_21),
        .fft_output_22(fft_out_22), .fft_output_23(fft_out_23),
        .fft_output_24(fft_out_24), .fft_output_25(fft_out_25),
        .fft_output_26(fft_out_26), .fft_output_27(fft_out_27),
        .fft_output_28(fft_out_28), .fft_output_29(fft_out_29),
        .fft_output_30(fft_out_30), .fft_output_31(fft_out_31),
        .fft_output_32(fft_out_32), .fft_output_33(fft_out_33),
        .fft_output_34(fft_out_34), .fft_output_35(fft_out_35),
        .fft_output_36(fft_out_36), .fft_output_37(fft_out_37),
        .fft_output_38(fft_out_38), .fft_output_39(fft_out_39),
        .fft_output_40(fft_out_40), .fft_output_41(fft_out_41),
        .fft_output_42(fft_out_42), .fft_output_43(fft_out_43),
        .fft_output_44(fft_out_44), .fft_output_45(fft_out_45),
        .fft_output_46(fft_out_46), .fft_output_47(fft_out_47),
        .fft_output_48(fft_out_48), .fft_output_49(fft_out_49),
        .fft_output_50(fft_out_50), .fft_output_51(fft_out_51),
        .fft_output_52(fft_out_52), .fft_output_53(fft_out_53),
        .fft_output_54(fft_out_54), .fft_output_55(fft_out_55),
        .fft_output_56(fft_out_56), .fft_output_57(fft_out_57),
        .fft_output_58(fft_out_58), .fft_output_59(fft_out_59),
        .fft_output_60(fft_out_60), .fft_output_61(fft_out_61),
        .fft_output_62(fft_out_62), .fft_output_63(fft_out_63),
        .mel_features_0(mel_out_0), .mel_features_1(mel_out_1),
        .mel_features_2(mel_out_2), .mel_features_3(mel_out_3),
        .mel_features_4(mel_out_4), .mel_features_5(mel_out_5),
        .mel_features_6(mel_out_6), .mel_features_7(mel_out_7),
        .mel_features_8(mel_out_8), .mel_features_9(mel_out_9),
        .mel_features_10(mel_out_10), .mel_features_11(mel_out_11),
        .mel_features_12(mel_out_12)
    );

    // Segment Buffer - pools the streaming per-sample Mel output into 6
    // time segments (~2048 cycles each), so the classifier sees enough of
    // a spoken word's shape over time instead of one instantaneous frame.
    // Classifying each raw per-sample Mel vector independently (the only
    // thing dense_hidden could see before this) discards essentially all
    // temporal structure - the same failure mode small-footprint keyword
    // spotting literature (e.g. Zhang et al., "Hello Edge: Keyword
    // Spotting on Microcontrollers") identifies as the main weakness of
    // plain per-frame/pooled-feature DNNs versus anything that keeps time
    // context.
    // Onset Trigger - watches the raw audio stream feeding fft.v and
    // stays low until a short-time energy threshold is crossed, so
    // segment_buffer doesn't start its window on whatever silence
    // happens to precede the spoken word in this recording.
    wire onset_triggered;
    onset_trigger onset_inst (
        .clk(clk), .rst(rst),
        .audio_in(fft_input),
        .triggered(onset_triggered)
    );

    segment_buffer segbuf_inst (
        .clk(clk), .rst(rst),
        .start_enable(onset_triggered),
        .mel_features_0(mel_out_0), .mel_features_1(mel_out_1), .mel_features_2(mel_out_2), .mel_features_3(mel_out_3), .mel_features_4(mel_out_4), .mel_features_5(mel_out_5), .mel_features_6(mel_out_6), .mel_features_7(mel_out_7), .mel_features_8(mel_out_8), .mel_features_9(mel_out_9), .mel_features_10(mel_out_10), .mel_features_11(mel_out_11), .mel_features_12(mel_out_12),
        .segment_features_0(seg_feat_0), .segment_features_1(seg_feat_1), .segment_features_2(seg_feat_2), .segment_features_3(seg_feat_3), .segment_features_4(seg_feat_4), .segment_features_5(seg_feat_5),
        .segment_features_6(seg_feat_6), .segment_features_7(seg_feat_7), .segment_features_8(seg_feat_8), .segment_features_9(seg_feat_9), .segment_features_10(seg_feat_10), .segment_features_11(seg_feat_11),
        .segment_features_12(seg_feat_12), .segment_features_13(seg_feat_13), .segment_features_14(seg_feat_14), .segment_features_15(seg_feat_15), .segment_features_16(seg_feat_16), .segment_features_17(seg_feat_17),
        .segment_features_18(seg_feat_18), .segment_features_19(seg_feat_19), .segment_features_20(seg_feat_20), .segment_features_21(seg_feat_21), .segment_features_22(seg_feat_22), .segment_features_23(seg_feat_23),
        .segment_features_24(seg_feat_24), .segment_features_25(seg_feat_25), .segment_features_26(seg_feat_26), .segment_features_27(seg_feat_27), .segment_features_28(seg_feat_28), .segment_features_29(seg_feat_29),
        .segment_features_30(seg_feat_30), .segment_features_31(seg_feat_31), .segment_features_32(seg_feat_32), .segment_features_33(seg_feat_33), .segment_features_34(seg_feat_34), .segment_features_35(seg_feat_35),
        .segment_features_36(seg_feat_36), .segment_features_37(seg_feat_37), .segment_features_38(seg_feat_38), .segment_features_39(seg_feat_39), .segment_features_40(seg_feat_40), .segment_features_41(seg_feat_41),
        .segment_features_42(seg_feat_42), .segment_features_43(seg_feat_43), .segment_features_44(seg_feat_44), .segment_features_45(seg_feat_45), .segment_features_46(seg_feat_46), .segment_features_47(seg_feat_47),
        .segment_features_48(seg_feat_48), .segment_features_49(seg_feat_49), .segment_features_50(seg_feat_50), .segment_features_51(seg_feat_51), .segment_features_52(seg_feat_52), .segment_features_53(seg_feat_53),
        .segment_features_54(seg_feat_54), .segment_features_55(seg_feat_55), .segment_features_56(seg_feat_56), .segment_features_57(seg_feat_57), .segment_features_58(seg_feat_58), .segment_features_59(seg_feat_59),
        .segment_features_60(seg_feat_60), .segment_features_61(seg_feat_61), .segment_features_62(seg_feat_62), .segment_features_63(seg_feat_63), .segment_features_64(seg_feat_64), .segment_features_65(seg_feat_65),
        .segment_features_66(seg_feat_66), .segment_features_67(seg_feat_67), .segment_features_68(seg_feat_68), .segment_features_69(seg_feat_69), .segment_features_70(seg_feat_70), .segment_features_71(seg_feat_71),
        .segment_features_72(seg_feat_72), .segment_features_73(seg_feat_73), .segment_features_74(seg_feat_74), .segment_features_75(seg_feat_75), .segment_features_76(seg_feat_76), .segment_features_77(seg_feat_77)
    );

    // Gain Normalize - per-utterance loudness compensation (see
    // gain_normalize.v): shifts the 78 segment-pooled features toward a
    // fixed reference energy, so the classifier isn't thrown off by two
    // recordings of the same word at very different volumes/mic gains.
    gain_normalize gainnorm_inst (
        .clk(clk),
        .segment_features_0(seg_feat_0), .segment_features_1(seg_feat_1), .segment_features_2(seg_feat_2), .segment_features_3(seg_feat_3), .segment_features_4(seg_feat_4), .segment_features_5(seg_feat_5),
        .segment_features_6(seg_feat_6), .segment_features_7(seg_feat_7), .segment_features_8(seg_feat_8), .segment_features_9(seg_feat_9), .segment_features_10(seg_feat_10), .segment_features_11(seg_feat_11),
        .segment_features_12(seg_feat_12), .segment_features_13(seg_feat_13), .segment_features_14(seg_feat_14), .segment_features_15(seg_feat_15), .segment_features_16(seg_feat_16), .segment_features_17(seg_feat_17),
        .segment_features_18(seg_feat_18), .segment_features_19(seg_feat_19), .segment_features_20(seg_feat_20), .segment_features_21(seg_feat_21), .segment_features_22(seg_feat_22), .segment_features_23(seg_feat_23),
        .segment_features_24(seg_feat_24), .segment_features_25(seg_feat_25), .segment_features_26(seg_feat_26), .segment_features_27(seg_feat_27), .segment_features_28(seg_feat_28), .segment_features_29(seg_feat_29),
        .segment_features_30(seg_feat_30), .segment_features_31(seg_feat_31), .segment_features_32(seg_feat_32), .segment_features_33(seg_feat_33), .segment_features_34(seg_feat_34), .segment_features_35(seg_feat_35),
        .segment_features_36(seg_feat_36), .segment_features_37(seg_feat_37), .segment_features_38(seg_feat_38), .segment_features_39(seg_feat_39), .segment_features_40(seg_feat_40), .segment_features_41(seg_feat_41),
        .segment_features_42(seg_feat_42), .segment_features_43(seg_feat_43), .segment_features_44(seg_feat_44), .segment_features_45(seg_feat_45), .segment_features_46(seg_feat_46), .segment_features_47(seg_feat_47),
        .segment_features_48(seg_feat_48), .segment_features_49(seg_feat_49), .segment_features_50(seg_feat_50), .segment_features_51(seg_feat_51), .segment_features_52(seg_feat_52), .segment_features_53(seg_feat_53),
        .segment_features_54(seg_feat_54), .segment_features_55(seg_feat_55), .segment_features_56(seg_feat_56), .segment_features_57(seg_feat_57), .segment_features_58(seg_feat_58), .segment_features_59(seg_feat_59),
        .segment_features_60(seg_feat_60), .segment_features_61(seg_feat_61), .segment_features_62(seg_feat_62), .segment_features_63(seg_feat_63), .segment_features_64(seg_feat_64), .segment_features_65(seg_feat_65),
        .segment_features_66(seg_feat_66), .segment_features_67(seg_feat_67), .segment_features_68(seg_feat_68), .segment_features_69(seg_feat_69), .segment_features_70(seg_feat_70), .segment_features_71(seg_feat_71),
        .segment_features_72(seg_feat_72), .segment_features_73(seg_feat_73), .segment_features_74(seg_feat_74), .segment_features_75(seg_feat_75), .segment_features_76(seg_feat_76), .segment_features_77(seg_feat_77),
        .normalized_features_0(norm_feat_0), .normalized_features_1(norm_feat_1), .normalized_features_2(norm_feat_2), .normalized_features_3(norm_feat_3), .normalized_features_4(norm_feat_4), .normalized_features_5(norm_feat_5),
        .normalized_features_6(norm_feat_6), .normalized_features_7(norm_feat_7), .normalized_features_8(norm_feat_8), .normalized_features_9(norm_feat_9), .normalized_features_10(norm_feat_10), .normalized_features_11(norm_feat_11),
        .normalized_features_12(norm_feat_12), .normalized_features_13(norm_feat_13), .normalized_features_14(norm_feat_14), .normalized_features_15(norm_feat_15), .normalized_features_16(norm_feat_16), .normalized_features_17(norm_feat_17),
        .normalized_features_18(norm_feat_18), .normalized_features_19(norm_feat_19), .normalized_features_20(norm_feat_20), .normalized_features_21(norm_feat_21), .normalized_features_22(norm_feat_22), .normalized_features_23(norm_feat_23),
        .normalized_features_24(norm_feat_24), .normalized_features_25(norm_feat_25), .normalized_features_26(norm_feat_26), .normalized_features_27(norm_feat_27), .normalized_features_28(norm_feat_28), .normalized_features_29(norm_feat_29),
        .normalized_features_30(norm_feat_30), .normalized_features_31(norm_feat_31), .normalized_features_32(norm_feat_32), .normalized_features_33(norm_feat_33), .normalized_features_34(norm_feat_34), .normalized_features_35(norm_feat_35),
        .normalized_features_36(norm_feat_36), .normalized_features_37(norm_feat_37), .normalized_features_38(norm_feat_38), .normalized_features_39(norm_feat_39), .normalized_features_40(norm_feat_40), .normalized_features_41(norm_feat_41),
        .normalized_features_42(norm_feat_42), .normalized_features_43(norm_feat_43), .normalized_features_44(norm_feat_44), .normalized_features_45(norm_feat_45), .normalized_features_46(norm_feat_46), .normalized_features_47(norm_feat_47),
        .normalized_features_48(norm_feat_48), .normalized_features_49(norm_feat_49), .normalized_features_50(norm_feat_50), .normalized_features_51(norm_feat_51), .normalized_features_52(norm_feat_52), .normalized_features_53(norm_feat_53),
        .normalized_features_54(norm_feat_54), .normalized_features_55(norm_feat_55), .normalized_features_56(norm_feat_56), .normalized_features_57(norm_feat_57), .normalized_features_58(norm_feat_58), .normalized_features_59(norm_feat_59),
        .normalized_features_60(norm_feat_60), .normalized_features_61(norm_feat_61), .normalized_features_62(norm_feat_62), .normalized_features_63(norm_feat_63), .normalized_features_64(norm_feat_64), .normalized_features_65(norm_feat_65),
        .normalized_features_66(norm_feat_66), .normalized_features_67(norm_feat_67), .normalized_features_68(norm_feat_68), .normalized_features_69(norm_feat_69), .normalized_features_70(norm_feat_70), .normalized_features_71(norm_feat_71),
        .normalized_features_72(norm_feat_72), .normalized_features_73(norm_feat_73), .normalized_features_74(norm_feat_74), .normalized_features_75(norm_feat_75), .normalized_features_76(norm_feat_76), .normalized_features_77(norm_feat_77)
    );

    // Hidden Layer - 78 segment-pooled Mel features in, 16 hidden
    // pre-activations out. The classifier used to take 13 raw per-sample
    // Mel features straight from mel_filterbank; this is the first layer
    // of the same two-layer MLP, just fed from segment_buffer instead.
    // Hidden Layer - 78 segment-pooled Mel features in, 256 hidden
    // pre-activations out. NUM_NEURONS went from 16 to 256 after testing
    // showed accuracy kept climbing well past 16 units given enough real
    // training data (scripts/train.py).
    dense_hidden hidden_inst (
        .clk(clk),

        .mfcc_features_flat_0(norm_feat_0), .mfcc_features_flat_1(norm_feat_1),
        .mfcc_features_flat_2(norm_feat_2), .mfcc_features_flat_3(norm_feat_3),
        .mfcc_features_flat_4(norm_feat_4), .mfcc_features_flat_5(norm_feat_5),
        .mfcc_features_flat_6(norm_feat_6), .mfcc_features_flat_7(norm_feat_7),
        .mfcc_features_flat_8(norm_feat_8), .mfcc_features_flat_9(norm_feat_9),
        .mfcc_features_flat_10(norm_feat_10), .mfcc_features_flat_11(norm_feat_11),
        .mfcc_features_flat_12(norm_feat_12), .mfcc_features_flat_13(norm_feat_13),
        .mfcc_features_flat_14(norm_feat_14), .mfcc_features_flat_15(norm_feat_15),
        .mfcc_features_flat_16(norm_feat_16), .mfcc_features_flat_17(norm_feat_17),
        .mfcc_features_flat_18(norm_feat_18), .mfcc_features_flat_19(norm_feat_19),
        .mfcc_features_flat_20(norm_feat_20), .mfcc_features_flat_21(norm_feat_21),
        .mfcc_features_flat_22(norm_feat_22), .mfcc_features_flat_23(norm_feat_23),
        .mfcc_features_flat_24(norm_feat_24), .mfcc_features_flat_25(norm_feat_25),
        .mfcc_features_flat_26(norm_feat_26), .mfcc_features_flat_27(norm_feat_27),
        .mfcc_features_flat_28(norm_feat_28), .mfcc_features_flat_29(norm_feat_29),
        .mfcc_features_flat_30(norm_feat_30), .mfcc_features_flat_31(norm_feat_31),
        .mfcc_features_flat_32(norm_feat_32), .mfcc_features_flat_33(norm_feat_33),
        .mfcc_features_flat_34(norm_feat_34), .mfcc_features_flat_35(norm_feat_35),
        .mfcc_features_flat_36(norm_feat_36), .mfcc_features_flat_37(norm_feat_37),
        .mfcc_features_flat_38(norm_feat_38), .mfcc_features_flat_39(norm_feat_39),
        .mfcc_features_flat_40(norm_feat_40), .mfcc_features_flat_41(norm_feat_41),
        .mfcc_features_flat_42(norm_feat_42), .mfcc_features_flat_43(norm_feat_43),
        .mfcc_features_flat_44(norm_feat_44), .mfcc_features_flat_45(norm_feat_45),
        .mfcc_features_flat_46(norm_feat_46), .mfcc_features_flat_47(norm_feat_47),
        .mfcc_features_flat_48(norm_feat_48), .mfcc_features_flat_49(norm_feat_49),
        .mfcc_features_flat_50(norm_feat_50), .mfcc_features_flat_51(norm_feat_51),
        .mfcc_features_flat_52(norm_feat_52), .mfcc_features_flat_53(norm_feat_53),
        .mfcc_features_flat_54(norm_feat_54), .mfcc_features_flat_55(norm_feat_55),
        .mfcc_features_flat_56(norm_feat_56), .mfcc_features_flat_57(norm_feat_57),
        .mfcc_features_flat_58(norm_feat_58), .mfcc_features_flat_59(norm_feat_59),
        .mfcc_features_flat_60(norm_feat_60), .mfcc_features_flat_61(norm_feat_61),
        .mfcc_features_flat_62(norm_feat_62), .mfcc_features_flat_63(norm_feat_63),
        .mfcc_features_flat_64(norm_feat_64), .mfcc_features_flat_65(norm_feat_65),
        .mfcc_features_flat_66(norm_feat_66), .mfcc_features_flat_67(norm_feat_67),
        .mfcc_features_flat_68(norm_feat_68), .mfcc_features_flat_69(norm_feat_69),
        .mfcc_features_flat_70(norm_feat_70), .mfcc_features_flat_71(norm_feat_71),
        .mfcc_features_flat_72(norm_feat_72), .mfcc_features_flat_73(norm_feat_73),
        .mfcc_features_flat_74(norm_feat_74), .mfcc_features_flat_75(norm_feat_75),
        .mfcc_features_flat_76(norm_feat_76), .mfcc_features_flat_77(norm_feat_77),

        .hidden_flat_0(hidden_0), .hidden_flat_1(hidden_1),
        .hidden_flat_2(hidden_2), .hidden_flat_3(hidden_3),
        .hidden_flat_4(hidden_4), .hidden_flat_5(hidden_5),
        .hidden_flat_6(hidden_6), .hidden_flat_7(hidden_7),
        .hidden_flat_8(hidden_8), .hidden_flat_9(hidden_9),
        .hidden_flat_10(hidden_10), .hidden_flat_11(hidden_11),
        .hidden_flat_12(hidden_12), .hidden_flat_13(hidden_13),
        .hidden_flat_14(hidden_14), .hidden_flat_15(hidden_15),
        .hidden_flat_16(hidden_16), .hidden_flat_17(hidden_17),
        .hidden_flat_18(hidden_18), .hidden_flat_19(hidden_19),
        .hidden_flat_20(hidden_20), .hidden_flat_21(hidden_21),
        .hidden_flat_22(hidden_22), .hidden_flat_23(hidden_23),
        .hidden_flat_24(hidden_24), .hidden_flat_25(hidden_25),
        .hidden_flat_26(hidden_26), .hidden_flat_27(hidden_27),
        .hidden_flat_28(hidden_28), .hidden_flat_29(hidden_29),
        .hidden_flat_30(hidden_30), .hidden_flat_31(hidden_31),
        .hidden_flat_32(hidden_32), .hidden_flat_33(hidden_33),
        .hidden_flat_34(hidden_34), .hidden_flat_35(hidden_35),
        .hidden_flat_36(hidden_36), .hidden_flat_37(hidden_37),
        .hidden_flat_38(hidden_38), .hidden_flat_39(hidden_39),
        .hidden_flat_40(hidden_40), .hidden_flat_41(hidden_41),
        .hidden_flat_42(hidden_42), .hidden_flat_43(hidden_43),
        .hidden_flat_44(hidden_44), .hidden_flat_45(hidden_45),
        .hidden_flat_46(hidden_46), .hidden_flat_47(hidden_47),
        .hidden_flat_48(hidden_48), .hidden_flat_49(hidden_49),
        .hidden_flat_50(hidden_50), .hidden_flat_51(hidden_51),
        .hidden_flat_52(hidden_52), .hidden_flat_53(hidden_53),
        .hidden_flat_54(hidden_54), .hidden_flat_55(hidden_55),
        .hidden_flat_56(hidden_56), .hidden_flat_57(hidden_57),
        .hidden_flat_58(hidden_58), .hidden_flat_59(hidden_59),
        .hidden_flat_60(hidden_60), .hidden_flat_61(hidden_61),
        .hidden_flat_62(hidden_62), .hidden_flat_63(hidden_63),
        .hidden_flat_64(hidden_64), .hidden_flat_65(hidden_65),
        .hidden_flat_66(hidden_66), .hidden_flat_67(hidden_67),
        .hidden_flat_68(hidden_68), .hidden_flat_69(hidden_69),
        .hidden_flat_70(hidden_70), .hidden_flat_71(hidden_71),
        .hidden_flat_72(hidden_72), .hidden_flat_73(hidden_73),
        .hidden_flat_74(hidden_74), .hidden_flat_75(hidden_75),
        .hidden_flat_76(hidden_76), .hidden_flat_77(hidden_77),
        .hidden_flat_78(hidden_78), .hidden_flat_79(hidden_79),
        .hidden_flat_80(hidden_80), .hidden_flat_81(hidden_81),
        .hidden_flat_82(hidden_82), .hidden_flat_83(hidden_83),
        .hidden_flat_84(hidden_84), .hidden_flat_85(hidden_85),
        .hidden_flat_86(hidden_86), .hidden_flat_87(hidden_87),
        .hidden_flat_88(hidden_88), .hidden_flat_89(hidden_89),
        .hidden_flat_90(hidden_90), .hidden_flat_91(hidden_91),
        .hidden_flat_92(hidden_92), .hidden_flat_93(hidden_93),
        .hidden_flat_94(hidden_94), .hidden_flat_95(hidden_95),
        .hidden_flat_96(hidden_96), .hidden_flat_97(hidden_97),
        .hidden_flat_98(hidden_98), .hidden_flat_99(hidden_99),
        .hidden_flat_100(hidden_100), .hidden_flat_101(hidden_101),
        .hidden_flat_102(hidden_102), .hidden_flat_103(hidden_103),
        .hidden_flat_104(hidden_104), .hidden_flat_105(hidden_105),
        .hidden_flat_106(hidden_106), .hidden_flat_107(hidden_107),
        .hidden_flat_108(hidden_108), .hidden_flat_109(hidden_109),
        .hidden_flat_110(hidden_110), .hidden_flat_111(hidden_111),
        .hidden_flat_112(hidden_112), .hidden_flat_113(hidden_113),
        .hidden_flat_114(hidden_114), .hidden_flat_115(hidden_115),
        .hidden_flat_116(hidden_116), .hidden_flat_117(hidden_117),
        .hidden_flat_118(hidden_118), .hidden_flat_119(hidden_119),
        .hidden_flat_120(hidden_120), .hidden_flat_121(hidden_121),
        .hidden_flat_122(hidden_122), .hidden_flat_123(hidden_123),
        .hidden_flat_124(hidden_124), .hidden_flat_125(hidden_125),
        .hidden_flat_126(hidden_126), .hidden_flat_127(hidden_127),
        .hidden_flat_128(hidden_128), .hidden_flat_129(hidden_129),
        .hidden_flat_130(hidden_130), .hidden_flat_131(hidden_131),
        .hidden_flat_132(hidden_132), .hidden_flat_133(hidden_133),
        .hidden_flat_134(hidden_134), .hidden_flat_135(hidden_135),
        .hidden_flat_136(hidden_136), .hidden_flat_137(hidden_137),
        .hidden_flat_138(hidden_138), .hidden_flat_139(hidden_139),
        .hidden_flat_140(hidden_140), .hidden_flat_141(hidden_141),
        .hidden_flat_142(hidden_142), .hidden_flat_143(hidden_143),
        .hidden_flat_144(hidden_144), .hidden_flat_145(hidden_145),
        .hidden_flat_146(hidden_146), .hidden_flat_147(hidden_147),
        .hidden_flat_148(hidden_148), .hidden_flat_149(hidden_149),
        .hidden_flat_150(hidden_150), .hidden_flat_151(hidden_151),
        .hidden_flat_152(hidden_152), .hidden_flat_153(hidden_153),
        .hidden_flat_154(hidden_154), .hidden_flat_155(hidden_155),
        .hidden_flat_156(hidden_156), .hidden_flat_157(hidden_157),
        .hidden_flat_158(hidden_158), .hidden_flat_159(hidden_159),
        .hidden_flat_160(hidden_160), .hidden_flat_161(hidden_161),
        .hidden_flat_162(hidden_162), .hidden_flat_163(hidden_163),
        .hidden_flat_164(hidden_164), .hidden_flat_165(hidden_165),
        .hidden_flat_166(hidden_166), .hidden_flat_167(hidden_167),
        .hidden_flat_168(hidden_168), .hidden_flat_169(hidden_169),
        .hidden_flat_170(hidden_170), .hidden_flat_171(hidden_171),
        .hidden_flat_172(hidden_172), .hidden_flat_173(hidden_173),
        .hidden_flat_174(hidden_174), .hidden_flat_175(hidden_175),
        .hidden_flat_176(hidden_176), .hidden_flat_177(hidden_177),
        .hidden_flat_178(hidden_178), .hidden_flat_179(hidden_179),
        .hidden_flat_180(hidden_180), .hidden_flat_181(hidden_181),
        .hidden_flat_182(hidden_182), .hidden_flat_183(hidden_183),
        .hidden_flat_184(hidden_184), .hidden_flat_185(hidden_185),
        .hidden_flat_186(hidden_186), .hidden_flat_187(hidden_187),
        .hidden_flat_188(hidden_188), .hidden_flat_189(hidden_189),
        .hidden_flat_190(hidden_190), .hidden_flat_191(hidden_191),
        .hidden_flat_192(hidden_192), .hidden_flat_193(hidden_193),
        .hidden_flat_194(hidden_194), .hidden_flat_195(hidden_195),
        .hidden_flat_196(hidden_196), .hidden_flat_197(hidden_197),
        .hidden_flat_198(hidden_198), .hidden_flat_199(hidden_199),
        .hidden_flat_200(hidden_200), .hidden_flat_201(hidden_201),
        .hidden_flat_202(hidden_202), .hidden_flat_203(hidden_203),
        .hidden_flat_204(hidden_204), .hidden_flat_205(hidden_205),
        .hidden_flat_206(hidden_206), .hidden_flat_207(hidden_207),
        .hidden_flat_208(hidden_208), .hidden_flat_209(hidden_209),
        .hidden_flat_210(hidden_210), .hidden_flat_211(hidden_211),
        .hidden_flat_212(hidden_212), .hidden_flat_213(hidden_213),
        .hidden_flat_214(hidden_214), .hidden_flat_215(hidden_215),
        .hidden_flat_216(hidden_216), .hidden_flat_217(hidden_217),
        .hidden_flat_218(hidden_218), .hidden_flat_219(hidden_219),
        .hidden_flat_220(hidden_220), .hidden_flat_221(hidden_221),
        .hidden_flat_222(hidden_222), .hidden_flat_223(hidden_223),
        .hidden_flat_224(hidden_224), .hidden_flat_225(hidden_225),
        .hidden_flat_226(hidden_226), .hidden_flat_227(hidden_227),
        .hidden_flat_228(hidden_228), .hidden_flat_229(hidden_229),
        .hidden_flat_230(hidden_230), .hidden_flat_231(hidden_231),
        .hidden_flat_232(hidden_232), .hidden_flat_233(hidden_233),
        .hidden_flat_234(hidden_234), .hidden_flat_235(hidden_235),
        .hidden_flat_236(hidden_236), .hidden_flat_237(hidden_237),
        .hidden_flat_238(hidden_238), .hidden_flat_239(hidden_239),
        .hidden_flat_240(hidden_240), .hidden_flat_241(hidden_241),
        .hidden_flat_242(hidden_242), .hidden_flat_243(hidden_243),
        .hidden_flat_244(hidden_244), .hidden_flat_245(hidden_245),
        .hidden_flat_246(hidden_246), .hidden_flat_247(hidden_247),
        .hidden_flat_248(hidden_248), .hidden_flat_249(hidden_249),
        .hidden_flat_250(hidden_250), .hidden_flat_251(hidden_251),
        .hidden_flat_252(hidden_252), .hidden_flat_253(hidden_253),
        .hidden_flat_254(hidden_254), .hidden_flat_255(hidden_255)
    );

    // Hidden-layer ReLU activation, 256 units.
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
    relu hidden_relu_inst_16(.clk(clk), .nn_input(hidden_16), .relu_output(hidden_relu_16));
    relu hidden_relu_inst_17(.clk(clk), .nn_input(hidden_17), .relu_output(hidden_relu_17));
    relu hidden_relu_inst_18(.clk(clk), .nn_input(hidden_18), .relu_output(hidden_relu_18));
    relu hidden_relu_inst_19(.clk(clk), .nn_input(hidden_19), .relu_output(hidden_relu_19));
    relu hidden_relu_inst_20(.clk(clk), .nn_input(hidden_20), .relu_output(hidden_relu_20));
    relu hidden_relu_inst_21(.clk(clk), .nn_input(hidden_21), .relu_output(hidden_relu_21));
    relu hidden_relu_inst_22(.clk(clk), .nn_input(hidden_22), .relu_output(hidden_relu_22));
    relu hidden_relu_inst_23(.clk(clk), .nn_input(hidden_23), .relu_output(hidden_relu_23));
    relu hidden_relu_inst_24(.clk(clk), .nn_input(hidden_24), .relu_output(hidden_relu_24));
    relu hidden_relu_inst_25(.clk(clk), .nn_input(hidden_25), .relu_output(hidden_relu_25));
    relu hidden_relu_inst_26(.clk(clk), .nn_input(hidden_26), .relu_output(hidden_relu_26));
    relu hidden_relu_inst_27(.clk(clk), .nn_input(hidden_27), .relu_output(hidden_relu_27));
    relu hidden_relu_inst_28(.clk(clk), .nn_input(hidden_28), .relu_output(hidden_relu_28));
    relu hidden_relu_inst_29(.clk(clk), .nn_input(hidden_29), .relu_output(hidden_relu_29));
    relu hidden_relu_inst_30(.clk(clk), .nn_input(hidden_30), .relu_output(hidden_relu_30));
    relu hidden_relu_inst_31(.clk(clk), .nn_input(hidden_31), .relu_output(hidden_relu_31));
    relu hidden_relu_inst_32(.clk(clk), .nn_input(hidden_32), .relu_output(hidden_relu_32));
    relu hidden_relu_inst_33(.clk(clk), .nn_input(hidden_33), .relu_output(hidden_relu_33));
    relu hidden_relu_inst_34(.clk(clk), .nn_input(hidden_34), .relu_output(hidden_relu_34));
    relu hidden_relu_inst_35(.clk(clk), .nn_input(hidden_35), .relu_output(hidden_relu_35));
    relu hidden_relu_inst_36(.clk(clk), .nn_input(hidden_36), .relu_output(hidden_relu_36));
    relu hidden_relu_inst_37(.clk(clk), .nn_input(hidden_37), .relu_output(hidden_relu_37));
    relu hidden_relu_inst_38(.clk(clk), .nn_input(hidden_38), .relu_output(hidden_relu_38));
    relu hidden_relu_inst_39(.clk(clk), .nn_input(hidden_39), .relu_output(hidden_relu_39));
    relu hidden_relu_inst_40(.clk(clk), .nn_input(hidden_40), .relu_output(hidden_relu_40));
    relu hidden_relu_inst_41(.clk(clk), .nn_input(hidden_41), .relu_output(hidden_relu_41));
    relu hidden_relu_inst_42(.clk(clk), .nn_input(hidden_42), .relu_output(hidden_relu_42));
    relu hidden_relu_inst_43(.clk(clk), .nn_input(hidden_43), .relu_output(hidden_relu_43));
    relu hidden_relu_inst_44(.clk(clk), .nn_input(hidden_44), .relu_output(hidden_relu_44));
    relu hidden_relu_inst_45(.clk(clk), .nn_input(hidden_45), .relu_output(hidden_relu_45));
    relu hidden_relu_inst_46(.clk(clk), .nn_input(hidden_46), .relu_output(hidden_relu_46));
    relu hidden_relu_inst_47(.clk(clk), .nn_input(hidden_47), .relu_output(hidden_relu_47));
    relu hidden_relu_inst_48(.clk(clk), .nn_input(hidden_48), .relu_output(hidden_relu_48));
    relu hidden_relu_inst_49(.clk(clk), .nn_input(hidden_49), .relu_output(hidden_relu_49));
    relu hidden_relu_inst_50(.clk(clk), .nn_input(hidden_50), .relu_output(hidden_relu_50));
    relu hidden_relu_inst_51(.clk(clk), .nn_input(hidden_51), .relu_output(hidden_relu_51));
    relu hidden_relu_inst_52(.clk(clk), .nn_input(hidden_52), .relu_output(hidden_relu_52));
    relu hidden_relu_inst_53(.clk(clk), .nn_input(hidden_53), .relu_output(hidden_relu_53));
    relu hidden_relu_inst_54(.clk(clk), .nn_input(hidden_54), .relu_output(hidden_relu_54));
    relu hidden_relu_inst_55(.clk(clk), .nn_input(hidden_55), .relu_output(hidden_relu_55));
    relu hidden_relu_inst_56(.clk(clk), .nn_input(hidden_56), .relu_output(hidden_relu_56));
    relu hidden_relu_inst_57(.clk(clk), .nn_input(hidden_57), .relu_output(hidden_relu_57));
    relu hidden_relu_inst_58(.clk(clk), .nn_input(hidden_58), .relu_output(hidden_relu_58));
    relu hidden_relu_inst_59(.clk(clk), .nn_input(hidden_59), .relu_output(hidden_relu_59));
    relu hidden_relu_inst_60(.clk(clk), .nn_input(hidden_60), .relu_output(hidden_relu_60));
    relu hidden_relu_inst_61(.clk(clk), .nn_input(hidden_61), .relu_output(hidden_relu_61));
    relu hidden_relu_inst_62(.clk(clk), .nn_input(hidden_62), .relu_output(hidden_relu_62));
    relu hidden_relu_inst_63(.clk(clk), .nn_input(hidden_63), .relu_output(hidden_relu_63));
    relu hidden_relu_inst_64(.clk(clk), .nn_input(hidden_64), .relu_output(hidden_relu_64));
    relu hidden_relu_inst_65(.clk(clk), .nn_input(hidden_65), .relu_output(hidden_relu_65));
    relu hidden_relu_inst_66(.clk(clk), .nn_input(hidden_66), .relu_output(hidden_relu_66));
    relu hidden_relu_inst_67(.clk(clk), .nn_input(hidden_67), .relu_output(hidden_relu_67));
    relu hidden_relu_inst_68(.clk(clk), .nn_input(hidden_68), .relu_output(hidden_relu_68));
    relu hidden_relu_inst_69(.clk(clk), .nn_input(hidden_69), .relu_output(hidden_relu_69));
    relu hidden_relu_inst_70(.clk(clk), .nn_input(hidden_70), .relu_output(hidden_relu_70));
    relu hidden_relu_inst_71(.clk(clk), .nn_input(hidden_71), .relu_output(hidden_relu_71));
    relu hidden_relu_inst_72(.clk(clk), .nn_input(hidden_72), .relu_output(hidden_relu_72));
    relu hidden_relu_inst_73(.clk(clk), .nn_input(hidden_73), .relu_output(hidden_relu_73));
    relu hidden_relu_inst_74(.clk(clk), .nn_input(hidden_74), .relu_output(hidden_relu_74));
    relu hidden_relu_inst_75(.clk(clk), .nn_input(hidden_75), .relu_output(hidden_relu_75));
    relu hidden_relu_inst_76(.clk(clk), .nn_input(hidden_76), .relu_output(hidden_relu_76));
    relu hidden_relu_inst_77(.clk(clk), .nn_input(hidden_77), .relu_output(hidden_relu_77));
    relu hidden_relu_inst_78(.clk(clk), .nn_input(hidden_78), .relu_output(hidden_relu_78));
    relu hidden_relu_inst_79(.clk(clk), .nn_input(hidden_79), .relu_output(hidden_relu_79));
    relu hidden_relu_inst_80(.clk(clk), .nn_input(hidden_80), .relu_output(hidden_relu_80));
    relu hidden_relu_inst_81(.clk(clk), .nn_input(hidden_81), .relu_output(hidden_relu_81));
    relu hidden_relu_inst_82(.clk(clk), .nn_input(hidden_82), .relu_output(hidden_relu_82));
    relu hidden_relu_inst_83(.clk(clk), .nn_input(hidden_83), .relu_output(hidden_relu_83));
    relu hidden_relu_inst_84(.clk(clk), .nn_input(hidden_84), .relu_output(hidden_relu_84));
    relu hidden_relu_inst_85(.clk(clk), .nn_input(hidden_85), .relu_output(hidden_relu_85));
    relu hidden_relu_inst_86(.clk(clk), .nn_input(hidden_86), .relu_output(hidden_relu_86));
    relu hidden_relu_inst_87(.clk(clk), .nn_input(hidden_87), .relu_output(hidden_relu_87));
    relu hidden_relu_inst_88(.clk(clk), .nn_input(hidden_88), .relu_output(hidden_relu_88));
    relu hidden_relu_inst_89(.clk(clk), .nn_input(hidden_89), .relu_output(hidden_relu_89));
    relu hidden_relu_inst_90(.clk(clk), .nn_input(hidden_90), .relu_output(hidden_relu_90));
    relu hidden_relu_inst_91(.clk(clk), .nn_input(hidden_91), .relu_output(hidden_relu_91));
    relu hidden_relu_inst_92(.clk(clk), .nn_input(hidden_92), .relu_output(hidden_relu_92));
    relu hidden_relu_inst_93(.clk(clk), .nn_input(hidden_93), .relu_output(hidden_relu_93));
    relu hidden_relu_inst_94(.clk(clk), .nn_input(hidden_94), .relu_output(hidden_relu_94));
    relu hidden_relu_inst_95(.clk(clk), .nn_input(hidden_95), .relu_output(hidden_relu_95));
    relu hidden_relu_inst_96(.clk(clk), .nn_input(hidden_96), .relu_output(hidden_relu_96));
    relu hidden_relu_inst_97(.clk(clk), .nn_input(hidden_97), .relu_output(hidden_relu_97));
    relu hidden_relu_inst_98(.clk(clk), .nn_input(hidden_98), .relu_output(hidden_relu_98));
    relu hidden_relu_inst_99(.clk(clk), .nn_input(hidden_99), .relu_output(hidden_relu_99));
    relu hidden_relu_inst_100(.clk(clk), .nn_input(hidden_100), .relu_output(hidden_relu_100));
    relu hidden_relu_inst_101(.clk(clk), .nn_input(hidden_101), .relu_output(hidden_relu_101));
    relu hidden_relu_inst_102(.clk(clk), .nn_input(hidden_102), .relu_output(hidden_relu_102));
    relu hidden_relu_inst_103(.clk(clk), .nn_input(hidden_103), .relu_output(hidden_relu_103));
    relu hidden_relu_inst_104(.clk(clk), .nn_input(hidden_104), .relu_output(hidden_relu_104));
    relu hidden_relu_inst_105(.clk(clk), .nn_input(hidden_105), .relu_output(hidden_relu_105));
    relu hidden_relu_inst_106(.clk(clk), .nn_input(hidden_106), .relu_output(hidden_relu_106));
    relu hidden_relu_inst_107(.clk(clk), .nn_input(hidden_107), .relu_output(hidden_relu_107));
    relu hidden_relu_inst_108(.clk(clk), .nn_input(hidden_108), .relu_output(hidden_relu_108));
    relu hidden_relu_inst_109(.clk(clk), .nn_input(hidden_109), .relu_output(hidden_relu_109));
    relu hidden_relu_inst_110(.clk(clk), .nn_input(hidden_110), .relu_output(hidden_relu_110));
    relu hidden_relu_inst_111(.clk(clk), .nn_input(hidden_111), .relu_output(hidden_relu_111));
    relu hidden_relu_inst_112(.clk(clk), .nn_input(hidden_112), .relu_output(hidden_relu_112));
    relu hidden_relu_inst_113(.clk(clk), .nn_input(hidden_113), .relu_output(hidden_relu_113));
    relu hidden_relu_inst_114(.clk(clk), .nn_input(hidden_114), .relu_output(hidden_relu_114));
    relu hidden_relu_inst_115(.clk(clk), .nn_input(hidden_115), .relu_output(hidden_relu_115));
    relu hidden_relu_inst_116(.clk(clk), .nn_input(hidden_116), .relu_output(hidden_relu_116));
    relu hidden_relu_inst_117(.clk(clk), .nn_input(hidden_117), .relu_output(hidden_relu_117));
    relu hidden_relu_inst_118(.clk(clk), .nn_input(hidden_118), .relu_output(hidden_relu_118));
    relu hidden_relu_inst_119(.clk(clk), .nn_input(hidden_119), .relu_output(hidden_relu_119));
    relu hidden_relu_inst_120(.clk(clk), .nn_input(hidden_120), .relu_output(hidden_relu_120));
    relu hidden_relu_inst_121(.clk(clk), .nn_input(hidden_121), .relu_output(hidden_relu_121));
    relu hidden_relu_inst_122(.clk(clk), .nn_input(hidden_122), .relu_output(hidden_relu_122));
    relu hidden_relu_inst_123(.clk(clk), .nn_input(hidden_123), .relu_output(hidden_relu_123));
    relu hidden_relu_inst_124(.clk(clk), .nn_input(hidden_124), .relu_output(hidden_relu_124));
    relu hidden_relu_inst_125(.clk(clk), .nn_input(hidden_125), .relu_output(hidden_relu_125));
    relu hidden_relu_inst_126(.clk(clk), .nn_input(hidden_126), .relu_output(hidden_relu_126));
    relu hidden_relu_inst_127(.clk(clk), .nn_input(hidden_127), .relu_output(hidden_relu_127));
    relu hidden_relu_inst_128(.clk(clk), .nn_input(hidden_128), .relu_output(hidden_relu_128));
    relu hidden_relu_inst_129(.clk(clk), .nn_input(hidden_129), .relu_output(hidden_relu_129));
    relu hidden_relu_inst_130(.clk(clk), .nn_input(hidden_130), .relu_output(hidden_relu_130));
    relu hidden_relu_inst_131(.clk(clk), .nn_input(hidden_131), .relu_output(hidden_relu_131));
    relu hidden_relu_inst_132(.clk(clk), .nn_input(hidden_132), .relu_output(hidden_relu_132));
    relu hidden_relu_inst_133(.clk(clk), .nn_input(hidden_133), .relu_output(hidden_relu_133));
    relu hidden_relu_inst_134(.clk(clk), .nn_input(hidden_134), .relu_output(hidden_relu_134));
    relu hidden_relu_inst_135(.clk(clk), .nn_input(hidden_135), .relu_output(hidden_relu_135));
    relu hidden_relu_inst_136(.clk(clk), .nn_input(hidden_136), .relu_output(hidden_relu_136));
    relu hidden_relu_inst_137(.clk(clk), .nn_input(hidden_137), .relu_output(hidden_relu_137));
    relu hidden_relu_inst_138(.clk(clk), .nn_input(hidden_138), .relu_output(hidden_relu_138));
    relu hidden_relu_inst_139(.clk(clk), .nn_input(hidden_139), .relu_output(hidden_relu_139));
    relu hidden_relu_inst_140(.clk(clk), .nn_input(hidden_140), .relu_output(hidden_relu_140));
    relu hidden_relu_inst_141(.clk(clk), .nn_input(hidden_141), .relu_output(hidden_relu_141));
    relu hidden_relu_inst_142(.clk(clk), .nn_input(hidden_142), .relu_output(hidden_relu_142));
    relu hidden_relu_inst_143(.clk(clk), .nn_input(hidden_143), .relu_output(hidden_relu_143));
    relu hidden_relu_inst_144(.clk(clk), .nn_input(hidden_144), .relu_output(hidden_relu_144));
    relu hidden_relu_inst_145(.clk(clk), .nn_input(hidden_145), .relu_output(hidden_relu_145));
    relu hidden_relu_inst_146(.clk(clk), .nn_input(hidden_146), .relu_output(hidden_relu_146));
    relu hidden_relu_inst_147(.clk(clk), .nn_input(hidden_147), .relu_output(hidden_relu_147));
    relu hidden_relu_inst_148(.clk(clk), .nn_input(hidden_148), .relu_output(hidden_relu_148));
    relu hidden_relu_inst_149(.clk(clk), .nn_input(hidden_149), .relu_output(hidden_relu_149));
    relu hidden_relu_inst_150(.clk(clk), .nn_input(hidden_150), .relu_output(hidden_relu_150));
    relu hidden_relu_inst_151(.clk(clk), .nn_input(hidden_151), .relu_output(hidden_relu_151));
    relu hidden_relu_inst_152(.clk(clk), .nn_input(hidden_152), .relu_output(hidden_relu_152));
    relu hidden_relu_inst_153(.clk(clk), .nn_input(hidden_153), .relu_output(hidden_relu_153));
    relu hidden_relu_inst_154(.clk(clk), .nn_input(hidden_154), .relu_output(hidden_relu_154));
    relu hidden_relu_inst_155(.clk(clk), .nn_input(hidden_155), .relu_output(hidden_relu_155));
    relu hidden_relu_inst_156(.clk(clk), .nn_input(hidden_156), .relu_output(hidden_relu_156));
    relu hidden_relu_inst_157(.clk(clk), .nn_input(hidden_157), .relu_output(hidden_relu_157));
    relu hidden_relu_inst_158(.clk(clk), .nn_input(hidden_158), .relu_output(hidden_relu_158));
    relu hidden_relu_inst_159(.clk(clk), .nn_input(hidden_159), .relu_output(hidden_relu_159));
    relu hidden_relu_inst_160(.clk(clk), .nn_input(hidden_160), .relu_output(hidden_relu_160));
    relu hidden_relu_inst_161(.clk(clk), .nn_input(hidden_161), .relu_output(hidden_relu_161));
    relu hidden_relu_inst_162(.clk(clk), .nn_input(hidden_162), .relu_output(hidden_relu_162));
    relu hidden_relu_inst_163(.clk(clk), .nn_input(hidden_163), .relu_output(hidden_relu_163));
    relu hidden_relu_inst_164(.clk(clk), .nn_input(hidden_164), .relu_output(hidden_relu_164));
    relu hidden_relu_inst_165(.clk(clk), .nn_input(hidden_165), .relu_output(hidden_relu_165));
    relu hidden_relu_inst_166(.clk(clk), .nn_input(hidden_166), .relu_output(hidden_relu_166));
    relu hidden_relu_inst_167(.clk(clk), .nn_input(hidden_167), .relu_output(hidden_relu_167));
    relu hidden_relu_inst_168(.clk(clk), .nn_input(hidden_168), .relu_output(hidden_relu_168));
    relu hidden_relu_inst_169(.clk(clk), .nn_input(hidden_169), .relu_output(hidden_relu_169));
    relu hidden_relu_inst_170(.clk(clk), .nn_input(hidden_170), .relu_output(hidden_relu_170));
    relu hidden_relu_inst_171(.clk(clk), .nn_input(hidden_171), .relu_output(hidden_relu_171));
    relu hidden_relu_inst_172(.clk(clk), .nn_input(hidden_172), .relu_output(hidden_relu_172));
    relu hidden_relu_inst_173(.clk(clk), .nn_input(hidden_173), .relu_output(hidden_relu_173));
    relu hidden_relu_inst_174(.clk(clk), .nn_input(hidden_174), .relu_output(hidden_relu_174));
    relu hidden_relu_inst_175(.clk(clk), .nn_input(hidden_175), .relu_output(hidden_relu_175));
    relu hidden_relu_inst_176(.clk(clk), .nn_input(hidden_176), .relu_output(hidden_relu_176));
    relu hidden_relu_inst_177(.clk(clk), .nn_input(hidden_177), .relu_output(hidden_relu_177));
    relu hidden_relu_inst_178(.clk(clk), .nn_input(hidden_178), .relu_output(hidden_relu_178));
    relu hidden_relu_inst_179(.clk(clk), .nn_input(hidden_179), .relu_output(hidden_relu_179));
    relu hidden_relu_inst_180(.clk(clk), .nn_input(hidden_180), .relu_output(hidden_relu_180));
    relu hidden_relu_inst_181(.clk(clk), .nn_input(hidden_181), .relu_output(hidden_relu_181));
    relu hidden_relu_inst_182(.clk(clk), .nn_input(hidden_182), .relu_output(hidden_relu_182));
    relu hidden_relu_inst_183(.clk(clk), .nn_input(hidden_183), .relu_output(hidden_relu_183));
    relu hidden_relu_inst_184(.clk(clk), .nn_input(hidden_184), .relu_output(hidden_relu_184));
    relu hidden_relu_inst_185(.clk(clk), .nn_input(hidden_185), .relu_output(hidden_relu_185));
    relu hidden_relu_inst_186(.clk(clk), .nn_input(hidden_186), .relu_output(hidden_relu_186));
    relu hidden_relu_inst_187(.clk(clk), .nn_input(hidden_187), .relu_output(hidden_relu_187));
    relu hidden_relu_inst_188(.clk(clk), .nn_input(hidden_188), .relu_output(hidden_relu_188));
    relu hidden_relu_inst_189(.clk(clk), .nn_input(hidden_189), .relu_output(hidden_relu_189));
    relu hidden_relu_inst_190(.clk(clk), .nn_input(hidden_190), .relu_output(hidden_relu_190));
    relu hidden_relu_inst_191(.clk(clk), .nn_input(hidden_191), .relu_output(hidden_relu_191));
    relu hidden_relu_inst_192(.clk(clk), .nn_input(hidden_192), .relu_output(hidden_relu_192));
    relu hidden_relu_inst_193(.clk(clk), .nn_input(hidden_193), .relu_output(hidden_relu_193));
    relu hidden_relu_inst_194(.clk(clk), .nn_input(hidden_194), .relu_output(hidden_relu_194));
    relu hidden_relu_inst_195(.clk(clk), .nn_input(hidden_195), .relu_output(hidden_relu_195));
    relu hidden_relu_inst_196(.clk(clk), .nn_input(hidden_196), .relu_output(hidden_relu_196));
    relu hidden_relu_inst_197(.clk(clk), .nn_input(hidden_197), .relu_output(hidden_relu_197));
    relu hidden_relu_inst_198(.clk(clk), .nn_input(hidden_198), .relu_output(hidden_relu_198));
    relu hidden_relu_inst_199(.clk(clk), .nn_input(hidden_199), .relu_output(hidden_relu_199));
    relu hidden_relu_inst_200(.clk(clk), .nn_input(hidden_200), .relu_output(hidden_relu_200));
    relu hidden_relu_inst_201(.clk(clk), .nn_input(hidden_201), .relu_output(hidden_relu_201));
    relu hidden_relu_inst_202(.clk(clk), .nn_input(hidden_202), .relu_output(hidden_relu_202));
    relu hidden_relu_inst_203(.clk(clk), .nn_input(hidden_203), .relu_output(hidden_relu_203));
    relu hidden_relu_inst_204(.clk(clk), .nn_input(hidden_204), .relu_output(hidden_relu_204));
    relu hidden_relu_inst_205(.clk(clk), .nn_input(hidden_205), .relu_output(hidden_relu_205));
    relu hidden_relu_inst_206(.clk(clk), .nn_input(hidden_206), .relu_output(hidden_relu_206));
    relu hidden_relu_inst_207(.clk(clk), .nn_input(hidden_207), .relu_output(hidden_relu_207));
    relu hidden_relu_inst_208(.clk(clk), .nn_input(hidden_208), .relu_output(hidden_relu_208));
    relu hidden_relu_inst_209(.clk(clk), .nn_input(hidden_209), .relu_output(hidden_relu_209));
    relu hidden_relu_inst_210(.clk(clk), .nn_input(hidden_210), .relu_output(hidden_relu_210));
    relu hidden_relu_inst_211(.clk(clk), .nn_input(hidden_211), .relu_output(hidden_relu_211));
    relu hidden_relu_inst_212(.clk(clk), .nn_input(hidden_212), .relu_output(hidden_relu_212));
    relu hidden_relu_inst_213(.clk(clk), .nn_input(hidden_213), .relu_output(hidden_relu_213));
    relu hidden_relu_inst_214(.clk(clk), .nn_input(hidden_214), .relu_output(hidden_relu_214));
    relu hidden_relu_inst_215(.clk(clk), .nn_input(hidden_215), .relu_output(hidden_relu_215));
    relu hidden_relu_inst_216(.clk(clk), .nn_input(hidden_216), .relu_output(hidden_relu_216));
    relu hidden_relu_inst_217(.clk(clk), .nn_input(hidden_217), .relu_output(hidden_relu_217));
    relu hidden_relu_inst_218(.clk(clk), .nn_input(hidden_218), .relu_output(hidden_relu_218));
    relu hidden_relu_inst_219(.clk(clk), .nn_input(hidden_219), .relu_output(hidden_relu_219));
    relu hidden_relu_inst_220(.clk(clk), .nn_input(hidden_220), .relu_output(hidden_relu_220));
    relu hidden_relu_inst_221(.clk(clk), .nn_input(hidden_221), .relu_output(hidden_relu_221));
    relu hidden_relu_inst_222(.clk(clk), .nn_input(hidden_222), .relu_output(hidden_relu_222));
    relu hidden_relu_inst_223(.clk(clk), .nn_input(hidden_223), .relu_output(hidden_relu_223));
    relu hidden_relu_inst_224(.clk(clk), .nn_input(hidden_224), .relu_output(hidden_relu_224));
    relu hidden_relu_inst_225(.clk(clk), .nn_input(hidden_225), .relu_output(hidden_relu_225));
    relu hidden_relu_inst_226(.clk(clk), .nn_input(hidden_226), .relu_output(hidden_relu_226));
    relu hidden_relu_inst_227(.clk(clk), .nn_input(hidden_227), .relu_output(hidden_relu_227));
    relu hidden_relu_inst_228(.clk(clk), .nn_input(hidden_228), .relu_output(hidden_relu_228));
    relu hidden_relu_inst_229(.clk(clk), .nn_input(hidden_229), .relu_output(hidden_relu_229));
    relu hidden_relu_inst_230(.clk(clk), .nn_input(hidden_230), .relu_output(hidden_relu_230));
    relu hidden_relu_inst_231(.clk(clk), .nn_input(hidden_231), .relu_output(hidden_relu_231));
    relu hidden_relu_inst_232(.clk(clk), .nn_input(hidden_232), .relu_output(hidden_relu_232));
    relu hidden_relu_inst_233(.clk(clk), .nn_input(hidden_233), .relu_output(hidden_relu_233));
    relu hidden_relu_inst_234(.clk(clk), .nn_input(hidden_234), .relu_output(hidden_relu_234));
    relu hidden_relu_inst_235(.clk(clk), .nn_input(hidden_235), .relu_output(hidden_relu_235));
    relu hidden_relu_inst_236(.clk(clk), .nn_input(hidden_236), .relu_output(hidden_relu_236));
    relu hidden_relu_inst_237(.clk(clk), .nn_input(hidden_237), .relu_output(hidden_relu_237));
    relu hidden_relu_inst_238(.clk(clk), .nn_input(hidden_238), .relu_output(hidden_relu_238));
    relu hidden_relu_inst_239(.clk(clk), .nn_input(hidden_239), .relu_output(hidden_relu_239));
    relu hidden_relu_inst_240(.clk(clk), .nn_input(hidden_240), .relu_output(hidden_relu_240));
    relu hidden_relu_inst_241(.clk(clk), .nn_input(hidden_241), .relu_output(hidden_relu_241));
    relu hidden_relu_inst_242(.clk(clk), .nn_input(hidden_242), .relu_output(hidden_relu_242));
    relu hidden_relu_inst_243(.clk(clk), .nn_input(hidden_243), .relu_output(hidden_relu_243));
    relu hidden_relu_inst_244(.clk(clk), .nn_input(hidden_244), .relu_output(hidden_relu_244));
    relu hidden_relu_inst_245(.clk(clk), .nn_input(hidden_245), .relu_output(hidden_relu_245));
    relu hidden_relu_inst_246(.clk(clk), .nn_input(hidden_246), .relu_output(hidden_relu_246));
    relu hidden_relu_inst_247(.clk(clk), .nn_input(hidden_247), .relu_output(hidden_relu_247));
    relu hidden_relu_inst_248(.clk(clk), .nn_input(hidden_248), .relu_output(hidden_relu_248));
    relu hidden_relu_inst_249(.clk(clk), .nn_input(hidden_249), .relu_output(hidden_relu_249));
    relu hidden_relu_inst_250(.clk(clk), .nn_input(hidden_250), .relu_output(hidden_relu_250));
    relu hidden_relu_inst_251(.clk(clk), .nn_input(hidden_251), .relu_output(hidden_relu_251));
    relu hidden_relu_inst_252(.clk(clk), .nn_input(hidden_252), .relu_output(hidden_relu_252));
    relu hidden_relu_inst_253(.clk(clk), .nn_input(hidden_253), .relu_output(hidden_relu_253));
    relu hidden_relu_inst_254(.clk(clk), .nn_input(hidden_254), .relu_output(hidden_relu_254));
    relu hidden_relu_inst_255(.clk(clk), .nn_input(hidden_255), .relu_output(hidden_relu_255));

    // Output Layer - 256 hidden activations in, 8 class scores out.
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
    .hidden_features_flat_16(hidden_relu_16), .hidden_features_flat_17(hidden_relu_17),
    .hidden_features_flat_18(hidden_relu_18), .hidden_features_flat_19(hidden_relu_19),
    .hidden_features_flat_20(hidden_relu_20), .hidden_features_flat_21(hidden_relu_21),
    .hidden_features_flat_22(hidden_relu_22), .hidden_features_flat_23(hidden_relu_23),
    .hidden_features_flat_24(hidden_relu_24), .hidden_features_flat_25(hidden_relu_25),
    .hidden_features_flat_26(hidden_relu_26), .hidden_features_flat_27(hidden_relu_27),
    .hidden_features_flat_28(hidden_relu_28), .hidden_features_flat_29(hidden_relu_29),
    .hidden_features_flat_30(hidden_relu_30), .hidden_features_flat_31(hidden_relu_31),
    .hidden_features_flat_32(hidden_relu_32), .hidden_features_flat_33(hidden_relu_33),
    .hidden_features_flat_34(hidden_relu_34), .hidden_features_flat_35(hidden_relu_35),
    .hidden_features_flat_36(hidden_relu_36), .hidden_features_flat_37(hidden_relu_37),
    .hidden_features_flat_38(hidden_relu_38), .hidden_features_flat_39(hidden_relu_39),
    .hidden_features_flat_40(hidden_relu_40), .hidden_features_flat_41(hidden_relu_41),
    .hidden_features_flat_42(hidden_relu_42), .hidden_features_flat_43(hidden_relu_43),
    .hidden_features_flat_44(hidden_relu_44), .hidden_features_flat_45(hidden_relu_45),
    .hidden_features_flat_46(hidden_relu_46), .hidden_features_flat_47(hidden_relu_47),
    .hidden_features_flat_48(hidden_relu_48), .hidden_features_flat_49(hidden_relu_49),
    .hidden_features_flat_50(hidden_relu_50), .hidden_features_flat_51(hidden_relu_51),
    .hidden_features_flat_52(hidden_relu_52), .hidden_features_flat_53(hidden_relu_53),
    .hidden_features_flat_54(hidden_relu_54), .hidden_features_flat_55(hidden_relu_55),
    .hidden_features_flat_56(hidden_relu_56), .hidden_features_flat_57(hidden_relu_57),
    .hidden_features_flat_58(hidden_relu_58), .hidden_features_flat_59(hidden_relu_59),
    .hidden_features_flat_60(hidden_relu_60), .hidden_features_flat_61(hidden_relu_61),
    .hidden_features_flat_62(hidden_relu_62), .hidden_features_flat_63(hidden_relu_63),
    .hidden_features_flat_64(hidden_relu_64), .hidden_features_flat_65(hidden_relu_65),
    .hidden_features_flat_66(hidden_relu_66), .hidden_features_flat_67(hidden_relu_67),
    .hidden_features_flat_68(hidden_relu_68), .hidden_features_flat_69(hidden_relu_69),
    .hidden_features_flat_70(hidden_relu_70), .hidden_features_flat_71(hidden_relu_71),
    .hidden_features_flat_72(hidden_relu_72), .hidden_features_flat_73(hidden_relu_73),
    .hidden_features_flat_74(hidden_relu_74), .hidden_features_flat_75(hidden_relu_75),
    .hidden_features_flat_76(hidden_relu_76), .hidden_features_flat_77(hidden_relu_77),
    .hidden_features_flat_78(hidden_relu_78), .hidden_features_flat_79(hidden_relu_79),
    .hidden_features_flat_80(hidden_relu_80), .hidden_features_flat_81(hidden_relu_81),
    .hidden_features_flat_82(hidden_relu_82), .hidden_features_flat_83(hidden_relu_83),
    .hidden_features_flat_84(hidden_relu_84), .hidden_features_flat_85(hidden_relu_85),
    .hidden_features_flat_86(hidden_relu_86), .hidden_features_flat_87(hidden_relu_87),
    .hidden_features_flat_88(hidden_relu_88), .hidden_features_flat_89(hidden_relu_89),
    .hidden_features_flat_90(hidden_relu_90), .hidden_features_flat_91(hidden_relu_91),
    .hidden_features_flat_92(hidden_relu_92), .hidden_features_flat_93(hidden_relu_93),
    .hidden_features_flat_94(hidden_relu_94), .hidden_features_flat_95(hidden_relu_95),
    .hidden_features_flat_96(hidden_relu_96), .hidden_features_flat_97(hidden_relu_97),
    .hidden_features_flat_98(hidden_relu_98), .hidden_features_flat_99(hidden_relu_99),
    .hidden_features_flat_100(hidden_relu_100), .hidden_features_flat_101(hidden_relu_101),
    .hidden_features_flat_102(hidden_relu_102), .hidden_features_flat_103(hidden_relu_103),
    .hidden_features_flat_104(hidden_relu_104), .hidden_features_flat_105(hidden_relu_105),
    .hidden_features_flat_106(hidden_relu_106), .hidden_features_flat_107(hidden_relu_107),
    .hidden_features_flat_108(hidden_relu_108), .hidden_features_flat_109(hidden_relu_109),
    .hidden_features_flat_110(hidden_relu_110), .hidden_features_flat_111(hidden_relu_111),
    .hidden_features_flat_112(hidden_relu_112), .hidden_features_flat_113(hidden_relu_113),
    .hidden_features_flat_114(hidden_relu_114), .hidden_features_flat_115(hidden_relu_115),
    .hidden_features_flat_116(hidden_relu_116), .hidden_features_flat_117(hidden_relu_117),
    .hidden_features_flat_118(hidden_relu_118), .hidden_features_flat_119(hidden_relu_119),
    .hidden_features_flat_120(hidden_relu_120), .hidden_features_flat_121(hidden_relu_121),
    .hidden_features_flat_122(hidden_relu_122), .hidden_features_flat_123(hidden_relu_123),
    .hidden_features_flat_124(hidden_relu_124), .hidden_features_flat_125(hidden_relu_125),
    .hidden_features_flat_126(hidden_relu_126), .hidden_features_flat_127(hidden_relu_127),
    .hidden_features_flat_128(hidden_relu_128), .hidden_features_flat_129(hidden_relu_129),
    .hidden_features_flat_130(hidden_relu_130), .hidden_features_flat_131(hidden_relu_131),
    .hidden_features_flat_132(hidden_relu_132), .hidden_features_flat_133(hidden_relu_133),
    .hidden_features_flat_134(hidden_relu_134), .hidden_features_flat_135(hidden_relu_135),
    .hidden_features_flat_136(hidden_relu_136), .hidden_features_flat_137(hidden_relu_137),
    .hidden_features_flat_138(hidden_relu_138), .hidden_features_flat_139(hidden_relu_139),
    .hidden_features_flat_140(hidden_relu_140), .hidden_features_flat_141(hidden_relu_141),
    .hidden_features_flat_142(hidden_relu_142), .hidden_features_flat_143(hidden_relu_143),
    .hidden_features_flat_144(hidden_relu_144), .hidden_features_flat_145(hidden_relu_145),
    .hidden_features_flat_146(hidden_relu_146), .hidden_features_flat_147(hidden_relu_147),
    .hidden_features_flat_148(hidden_relu_148), .hidden_features_flat_149(hidden_relu_149),
    .hidden_features_flat_150(hidden_relu_150), .hidden_features_flat_151(hidden_relu_151),
    .hidden_features_flat_152(hidden_relu_152), .hidden_features_flat_153(hidden_relu_153),
    .hidden_features_flat_154(hidden_relu_154), .hidden_features_flat_155(hidden_relu_155),
    .hidden_features_flat_156(hidden_relu_156), .hidden_features_flat_157(hidden_relu_157),
    .hidden_features_flat_158(hidden_relu_158), .hidden_features_flat_159(hidden_relu_159),
    .hidden_features_flat_160(hidden_relu_160), .hidden_features_flat_161(hidden_relu_161),
    .hidden_features_flat_162(hidden_relu_162), .hidden_features_flat_163(hidden_relu_163),
    .hidden_features_flat_164(hidden_relu_164), .hidden_features_flat_165(hidden_relu_165),
    .hidden_features_flat_166(hidden_relu_166), .hidden_features_flat_167(hidden_relu_167),
    .hidden_features_flat_168(hidden_relu_168), .hidden_features_flat_169(hidden_relu_169),
    .hidden_features_flat_170(hidden_relu_170), .hidden_features_flat_171(hidden_relu_171),
    .hidden_features_flat_172(hidden_relu_172), .hidden_features_flat_173(hidden_relu_173),
    .hidden_features_flat_174(hidden_relu_174), .hidden_features_flat_175(hidden_relu_175),
    .hidden_features_flat_176(hidden_relu_176), .hidden_features_flat_177(hidden_relu_177),
    .hidden_features_flat_178(hidden_relu_178), .hidden_features_flat_179(hidden_relu_179),
    .hidden_features_flat_180(hidden_relu_180), .hidden_features_flat_181(hidden_relu_181),
    .hidden_features_flat_182(hidden_relu_182), .hidden_features_flat_183(hidden_relu_183),
    .hidden_features_flat_184(hidden_relu_184), .hidden_features_flat_185(hidden_relu_185),
    .hidden_features_flat_186(hidden_relu_186), .hidden_features_flat_187(hidden_relu_187),
    .hidden_features_flat_188(hidden_relu_188), .hidden_features_flat_189(hidden_relu_189),
    .hidden_features_flat_190(hidden_relu_190), .hidden_features_flat_191(hidden_relu_191),
    .hidden_features_flat_192(hidden_relu_192), .hidden_features_flat_193(hidden_relu_193),
    .hidden_features_flat_194(hidden_relu_194), .hidden_features_flat_195(hidden_relu_195),
    .hidden_features_flat_196(hidden_relu_196), .hidden_features_flat_197(hidden_relu_197),
    .hidden_features_flat_198(hidden_relu_198), .hidden_features_flat_199(hidden_relu_199),
    .hidden_features_flat_200(hidden_relu_200), .hidden_features_flat_201(hidden_relu_201),
    .hidden_features_flat_202(hidden_relu_202), .hidden_features_flat_203(hidden_relu_203),
    .hidden_features_flat_204(hidden_relu_204), .hidden_features_flat_205(hidden_relu_205),
    .hidden_features_flat_206(hidden_relu_206), .hidden_features_flat_207(hidden_relu_207),
    .hidden_features_flat_208(hidden_relu_208), .hidden_features_flat_209(hidden_relu_209),
    .hidden_features_flat_210(hidden_relu_210), .hidden_features_flat_211(hidden_relu_211),
    .hidden_features_flat_212(hidden_relu_212), .hidden_features_flat_213(hidden_relu_213),
    .hidden_features_flat_214(hidden_relu_214), .hidden_features_flat_215(hidden_relu_215),
    .hidden_features_flat_216(hidden_relu_216), .hidden_features_flat_217(hidden_relu_217),
    .hidden_features_flat_218(hidden_relu_218), .hidden_features_flat_219(hidden_relu_219),
    .hidden_features_flat_220(hidden_relu_220), .hidden_features_flat_221(hidden_relu_221),
    .hidden_features_flat_222(hidden_relu_222), .hidden_features_flat_223(hidden_relu_223),
    .hidden_features_flat_224(hidden_relu_224), .hidden_features_flat_225(hidden_relu_225),
    .hidden_features_flat_226(hidden_relu_226), .hidden_features_flat_227(hidden_relu_227),
    .hidden_features_flat_228(hidden_relu_228), .hidden_features_flat_229(hidden_relu_229),
    .hidden_features_flat_230(hidden_relu_230), .hidden_features_flat_231(hidden_relu_231),
    .hidden_features_flat_232(hidden_relu_232), .hidden_features_flat_233(hidden_relu_233),
    .hidden_features_flat_234(hidden_relu_234), .hidden_features_flat_235(hidden_relu_235),
    .hidden_features_flat_236(hidden_relu_236), .hidden_features_flat_237(hidden_relu_237),
    .hidden_features_flat_238(hidden_relu_238), .hidden_features_flat_239(hidden_relu_239),
    .hidden_features_flat_240(hidden_relu_240), .hidden_features_flat_241(hidden_relu_241),
    .hidden_features_flat_242(hidden_relu_242), .hidden_features_flat_243(hidden_relu_243),
    .hidden_features_flat_244(hidden_relu_244), .hidden_features_flat_245(hidden_relu_245),
    .hidden_features_flat_246(hidden_relu_246), .hidden_features_flat_247(hidden_relu_247),
    .hidden_features_flat_248(hidden_relu_248), .hidden_features_flat_249(hidden_relu_249),
    .hidden_features_flat_250(hidden_relu_250), .hidden_features_flat_251(hidden_relu_251),
    .hidden_features_flat_252(hidden_relu_252), .hidden_features_flat_253(hidden_relu_253),
    .hidden_features_flat_254(hidden_relu_254), .hidden_features_flat_255(hidden_relu_255),

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
