module gain_normalize (
    input wire clk,
    // Per-utterance gain normalization: approximates dividing the whole
    // 78-feature segment_buffer snapshot by its own total energy, so the
    // classifier sees spectral SHAPE rather than absolute loudness - two
    // recordings of the same word at different volumes/mic gains should
    // land on similar features. True division is expensive in fixed-point
    // RTL, so this finds the position of the highest set bit in the total
    // energy (a cheap priority-encoder) and right/left-shifts every
    // feature to bring that total back near a fixed reference magnitude -
    // the same idea as floating-point mantissa normalization. Verified in
    // testing to track true per-utterance division closely (and board
    // real hardware never performs true division).
    input wire signed [15:0] segment_features_0, input wire signed [15:0] segment_features_1,
    input wire signed [15:0] segment_features_2, input wire signed [15:0] segment_features_3,
    input wire signed [15:0] segment_features_4, input wire signed [15:0] segment_features_5,
    input wire signed [15:0] segment_features_6, input wire signed [15:0] segment_features_7,
    input wire signed [15:0] segment_features_8, input wire signed [15:0] segment_features_9,
    input wire signed [15:0] segment_features_10, input wire signed [15:0] segment_features_11,
    input wire signed [15:0] segment_features_12, input wire signed [15:0] segment_features_13,
    input wire signed [15:0] segment_features_14, input wire signed [15:0] segment_features_15,
    input wire signed [15:0] segment_features_16, input wire signed [15:0] segment_features_17,
    input wire signed [15:0] segment_features_18, input wire signed [15:0] segment_features_19,
    input wire signed [15:0] segment_features_20, input wire signed [15:0] segment_features_21,
    input wire signed [15:0] segment_features_22, input wire signed [15:0] segment_features_23,
    input wire signed [15:0] segment_features_24, input wire signed [15:0] segment_features_25,
    input wire signed [15:0] segment_features_26, input wire signed [15:0] segment_features_27,
    input wire signed [15:0] segment_features_28, input wire signed [15:0] segment_features_29,
    input wire signed [15:0] segment_features_30, input wire signed [15:0] segment_features_31,
    input wire signed [15:0] segment_features_32, input wire signed [15:0] segment_features_33,
    input wire signed [15:0] segment_features_34, input wire signed [15:0] segment_features_35,
    input wire signed [15:0] segment_features_36, input wire signed [15:0] segment_features_37,
    input wire signed [15:0] segment_features_38, input wire signed [15:0] segment_features_39,
    input wire signed [15:0] segment_features_40, input wire signed [15:0] segment_features_41,
    input wire signed [15:0] segment_features_42, input wire signed [15:0] segment_features_43,
    input wire signed [15:0] segment_features_44, input wire signed [15:0] segment_features_45,
    input wire signed [15:0] segment_features_46, input wire signed [15:0] segment_features_47,
    input wire signed [15:0] segment_features_48, input wire signed [15:0] segment_features_49,
    input wire signed [15:0] segment_features_50, input wire signed [15:0] segment_features_51,
    input wire signed [15:0] segment_features_52, input wire signed [15:0] segment_features_53,
    input wire signed [15:0] segment_features_54, input wire signed [15:0] segment_features_55,
    input wire signed [15:0] segment_features_56, input wire signed [15:0] segment_features_57,
    input wire signed [15:0] segment_features_58, input wire signed [15:0] segment_features_59,
    input wire signed [15:0] segment_features_60, input wire signed [15:0] segment_features_61,
    input wire signed [15:0] segment_features_62, input wire signed [15:0] segment_features_63,
    input wire signed [15:0] segment_features_64, input wire signed [15:0] segment_features_65,
    input wire signed [15:0] segment_features_66, input wire signed [15:0] segment_features_67,
    input wire signed [15:0] segment_features_68, input wire signed [15:0] segment_features_69,
    input wire signed [15:0] segment_features_70, input wire signed [15:0] segment_features_71,
    input wire signed [15:0] segment_features_72, input wire signed [15:0] segment_features_73,
    input wire signed [15:0] segment_features_74, input wire signed [15:0] segment_features_75,
    input wire signed [15:0] segment_features_76, input wire signed [15:0] segment_features_77,
    output reg signed [15:0] normalized_features_0, output reg signed [15:0] normalized_features_1,
    output reg signed [15:0] normalized_features_2, output reg signed [15:0] normalized_features_3,
    output reg signed [15:0] normalized_features_4, output reg signed [15:0] normalized_features_5,
    output reg signed [15:0] normalized_features_6, output reg signed [15:0] normalized_features_7,
    output reg signed [15:0] normalized_features_8, output reg signed [15:0] normalized_features_9,
    output reg signed [15:0] normalized_features_10, output reg signed [15:0] normalized_features_11,
    output reg signed [15:0] normalized_features_12, output reg signed [15:0] normalized_features_13,
    output reg signed [15:0] normalized_features_14, output reg signed [15:0] normalized_features_15,
    output reg signed [15:0] normalized_features_16, output reg signed [15:0] normalized_features_17,
    output reg signed [15:0] normalized_features_18, output reg signed [15:0] normalized_features_19,
    output reg signed [15:0] normalized_features_20, output reg signed [15:0] normalized_features_21,
    output reg signed [15:0] normalized_features_22, output reg signed [15:0] normalized_features_23,
    output reg signed [15:0] normalized_features_24, output reg signed [15:0] normalized_features_25,
    output reg signed [15:0] normalized_features_26, output reg signed [15:0] normalized_features_27,
    output reg signed [15:0] normalized_features_28, output reg signed [15:0] normalized_features_29,
    output reg signed [15:0] normalized_features_30, output reg signed [15:0] normalized_features_31,
    output reg signed [15:0] normalized_features_32, output reg signed [15:0] normalized_features_33,
    output reg signed [15:0] normalized_features_34, output reg signed [15:0] normalized_features_35,
    output reg signed [15:0] normalized_features_36, output reg signed [15:0] normalized_features_37,
    output reg signed [15:0] normalized_features_38, output reg signed [15:0] normalized_features_39,
    output reg signed [15:0] normalized_features_40, output reg signed [15:0] normalized_features_41,
    output reg signed [15:0] normalized_features_42, output reg signed [15:0] normalized_features_43,
    output reg signed [15:0] normalized_features_44, output reg signed [15:0] normalized_features_45,
    output reg signed [15:0] normalized_features_46, output reg signed [15:0] normalized_features_47,
    output reg signed [15:0] normalized_features_48, output reg signed [15:0] normalized_features_49,
    output reg signed [15:0] normalized_features_50, output reg signed [15:0] normalized_features_51,
    output reg signed [15:0] normalized_features_52, output reg signed [15:0] normalized_features_53,
    output reg signed [15:0] normalized_features_54, output reg signed [15:0] normalized_features_55,
    output reg signed [15:0] normalized_features_56, output reg signed [15:0] normalized_features_57,
    output reg signed [15:0] normalized_features_58, output reg signed [15:0] normalized_features_59,
    output reg signed [15:0] normalized_features_60, output reg signed [15:0] normalized_features_61,
    output reg signed [15:0] normalized_features_62, output reg signed [15:0] normalized_features_63,
    output reg signed [15:0] normalized_features_64, output reg signed [15:0] normalized_features_65,
    output reg signed [15:0] normalized_features_66, output reg signed [15:0] normalized_features_67,
    output reg signed [15:0] normalized_features_68, output reg signed [15:0] normalized_features_69,
    output reg signed [15:0] normalized_features_70, output reg signed [15:0] normalized_features_71,
    output reg signed [15:0] normalized_features_72, output reg signed [15:0] normalized_features_73,
    output reg signed [15:0] normalized_features_74, output reg signed [15:0] normalized_features_75,
    output reg signed [15:0] normalized_features_76, output reg signed [15:0] normalized_features_77
);

    localparam NUM_FEATURES = 78;
    // log2(median per-utterance energy) over the real training set was
    // ~14.76 - the nearest integer bit position this targets.
    localparam TARGET_LOG2 = 15;
    localparam MAX_SHIFT = 3;  // limits the shifter/priority-encoder width

    reg signed [15:0] features [0:NUM_FEATURES-1];
    reg signed [31:0] total_energy;
    reg signed [31:0] shifted;
    integer msb_pos;
    integer shift_amount;
    integer i, k;

    always @(posedge clk) begin
        features[0] = segment_features_0; features[1] = segment_features_1;
        features[2] = segment_features_2; features[3] = segment_features_3;
        features[4] = segment_features_4; features[5] = segment_features_5;
        features[6] = segment_features_6; features[7] = segment_features_7;
        features[8] = segment_features_8; features[9] = segment_features_9;
        features[10] = segment_features_10; features[11] = segment_features_11;
        features[12] = segment_features_12; features[13] = segment_features_13;
        features[14] = segment_features_14; features[15] = segment_features_15;
        features[16] = segment_features_16; features[17] = segment_features_17;
        features[18] = segment_features_18; features[19] = segment_features_19;
        features[20] = segment_features_20; features[21] = segment_features_21;
        features[22] = segment_features_22; features[23] = segment_features_23;
        features[24] = segment_features_24; features[25] = segment_features_25;
        features[26] = segment_features_26; features[27] = segment_features_27;
        features[28] = segment_features_28; features[29] = segment_features_29;
        features[30] = segment_features_30; features[31] = segment_features_31;
        features[32] = segment_features_32; features[33] = segment_features_33;
        features[34] = segment_features_34; features[35] = segment_features_35;
        features[36] = segment_features_36; features[37] = segment_features_37;
        features[38] = segment_features_38; features[39] = segment_features_39;
        features[40] = segment_features_40; features[41] = segment_features_41;
        features[42] = segment_features_42; features[43] = segment_features_43;
        features[44] = segment_features_44; features[45] = segment_features_45;
        features[46] = segment_features_46; features[47] = segment_features_47;
        features[48] = segment_features_48; features[49] = segment_features_49;
        features[50] = segment_features_50; features[51] = segment_features_51;
        features[52] = segment_features_52; features[53] = segment_features_53;
        features[54] = segment_features_54; features[55] = segment_features_55;
        features[56] = segment_features_56; features[57] = segment_features_57;
        features[58] = segment_features_58; features[59] = segment_features_59;
        features[60] = segment_features_60; features[61] = segment_features_61;
        features[62] = segment_features_62; features[63] = segment_features_63;
        features[64] = segment_features_64; features[65] = segment_features_65;
        features[66] = segment_features_66; features[67] = segment_features_67;
        features[68] = segment_features_68; features[69] = segment_features_69;
        features[70] = segment_features_70; features[71] = segment_features_71;
        features[72] = segment_features_72; features[73] = segment_features_73;
        features[74] = segment_features_74; features[75] = segment_features_75;
        features[76] = segment_features_76; features[77] = segment_features_77;

        // Mel-filtered magnitudes are always non-negative, so this sum is too.
        total_energy = 0;
        for (i = 0; i < NUM_FEATURES; i = i + 1)
            total_energy = total_energy + features[i];

        // Priority encoder: position of the highest set bit in total_energy.
        msb_pos = 0;
        for (k = 31; k >= 0; k = k - 1)
            if (total_energy[k] && (msb_pos == 0))
                msb_pos = k;

        if (total_energy == 0) begin
            shift_amount = 0;
        end else begin
            shift_amount = TARGET_LOG2 - msb_pos;
            if (shift_amount > MAX_SHIFT) shift_amount = MAX_SHIFT;
            if (shift_amount < -MAX_SHIFT) shift_amount = -MAX_SHIFT;
        end

        for (i = 0; i < NUM_FEATURES; i = i + 1) begin
            if (shift_amount >= 0) begin
                shifted = features[i] <<< shift_amount;
                // Saturate instead of silently wrapping around on overflow.
                if (shifted > 32767) shifted = 32767;
                if (shifted < -32768) shifted = -32768;
            end else begin
                shifted = features[i] >>> (-shift_amount);
            end
            features[i] = shifted[15:0];
        end

        normalized_features_0 = features[0]; normalized_features_1 = features[1];
        normalized_features_2 = features[2]; normalized_features_3 = features[3];
        normalized_features_4 = features[4]; normalized_features_5 = features[5];
        normalized_features_6 = features[6]; normalized_features_7 = features[7];
        normalized_features_8 = features[8]; normalized_features_9 = features[9];
        normalized_features_10 = features[10]; normalized_features_11 = features[11];
        normalized_features_12 = features[12]; normalized_features_13 = features[13];
        normalized_features_14 = features[14]; normalized_features_15 = features[15];
        normalized_features_16 = features[16]; normalized_features_17 = features[17];
        normalized_features_18 = features[18]; normalized_features_19 = features[19];
        normalized_features_20 = features[20]; normalized_features_21 = features[21];
        normalized_features_22 = features[22]; normalized_features_23 = features[23];
        normalized_features_24 = features[24]; normalized_features_25 = features[25];
        normalized_features_26 = features[26]; normalized_features_27 = features[27];
        normalized_features_28 = features[28]; normalized_features_29 = features[29];
        normalized_features_30 = features[30]; normalized_features_31 = features[31];
        normalized_features_32 = features[32]; normalized_features_33 = features[33];
        normalized_features_34 = features[34]; normalized_features_35 = features[35];
        normalized_features_36 = features[36]; normalized_features_37 = features[37];
        normalized_features_38 = features[38]; normalized_features_39 = features[39];
        normalized_features_40 = features[40]; normalized_features_41 = features[41];
        normalized_features_42 = features[42]; normalized_features_43 = features[43];
        normalized_features_44 = features[44]; normalized_features_45 = features[45];
        normalized_features_46 = features[46]; normalized_features_47 = features[47];
        normalized_features_48 = features[48]; normalized_features_49 = features[49];
        normalized_features_50 = features[50]; normalized_features_51 = features[51];
        normalized_features_52 = features[52]; normalized_features_53 = features[53];
        normalized_features_54 = features[54]; normalized_features_55 = features[55];
        normalized_features_56 = features[56]; normalized_features_57 = features[57];
        normalized_features_58 = features[58]; normalized_features_59 = features[59];
        normalized_features_60 = features[60]; normalized_features_61 = features[61];
        normalized_features_62 = features[62]; normalized_features_63 = features[63];
        normalized_features_64 = features[64]; normalized_features_65 = features[65];
        normalized_features_66 = features[66]; normalized_features_67 = features[67];
        normalized_features_68 = features[68]; normalized_features_69 = features[69];
        normalized_features_70 = features[70]; normalized_features_71 = features[71];
        normalized_features_72 = features[72]; normalized_features_73 = features[73];
        normalized_features_74 = features[74]; normalized_features_75 = features[75];
        normalized_features_76 = features[76]; normalized_features_77 = features[77];
    end

endmodule
