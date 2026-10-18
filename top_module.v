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
