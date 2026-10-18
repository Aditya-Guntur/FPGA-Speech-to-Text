module segment_buffer (
    input wire clk,
    input wire rst,
    input wire [15:0] mel_features_0, input wire [15:0] mel_features_1, input wire [15:0] mel_features_2, input wire [15:0] mel_features_3, input wire [15:0] mel_features_4, input wire [15:0] mel_features_5, input wire [15:0] mel_features_6, input wire [15:0] mel_features_7, input wire [15:0] mel_features_8, input wire [15:0] mel_features_9, input wire [15:0] mel_features_10, input wire [15:0] mel_features_11, input wire [15:0] mel_features_12,
    output reg signed [15:0] segment_features_0,
    output reg signed [15:0] segment_features_1,
    output reg signed [15:0] segment_features_2,
    output reg signed [15:0] segment_features_3,
    output reg signed [15:0] segment_features_4,
    output reg signed [15:0] segment_features_5,
    output reg signed [15:0] segment_features_6,
    output reg signed [15:0] segment_features_7,
    output reg signed [15:0] segment_features_8,
    output reg signed [15:0] segment_features_9,
    output reg signed [15:0] segment_features_10,
    output reg signed [15:0] segment_features_11,
    output reg signed [15:0] segment_features_12,
    output reg signed [15:0] segment_features_13,
    output reg signed [15:0] segment_features_14,
    output reg signed [15:0] segment_features_15,
    output reg signed [15:0] segment_features_16,
    output reg signed [15:0] segment_features_17,
    output reg signed [15:0] segment_features_18,
    output reg signed [15:0] segment_features_19,
    output reg signed [15:0] segment_features_20,
    output reg signed [15:0] segment_features_21,
    output reg signed [15:0] segment_features_22,
    output reg signed [15:0] segment_features_23,
    output reg signed [15:0] segment_features_24,
    output reg signed [15:0] segment_features_25,
    output reg signed [15:0] segment_features_26,
    output reg signed [15:0] segment_features_27,
    output reg signed [15:0] segment_features_28,
    output reg signed [15:0] segment_features_29,
    output reg signed [15:0] segment_features_30,
    output reg signed [15:0] segment_features_31,
    output reg signed [15:0] segment_features_32,
    output reg signed [15:0] segment_features_33,
    output reg signed [15:0] segment_features_34,
    output reg signed [15:0] segment_features_35,
    output reg signed [15:0] segment_features_36,
    output reg signed [15:0] segment_features_37,
    output reg signed [15:0] segment_features_38,
    output reg signed [15:0] segment_features_39,
    output reg signed [15:0] segment_features_40,
    output reg signed [15:0] segment_features_41,
    output reg signed [15:0] segment_features_42,
    output reg signed [15:0] segment_features_43,
    output reg signed [15:0] segment_features_44,
    output reg signed [15:0] segment_features_45,
    output reg signed [15:0] segment_features_46,
    output reg signed [15:0] segment_features_47,
    output reg signed [15:0] segment_features_48,
    output reg signed [15:0] segment_features_49,
    output reg signed [15:0] segment_features_50,
    output reg signed [15:0] segment_features_51,
    output reg signed [15:0] segment_features_52,
    output reg signed [15:0] segment_features_53,
    output reg signed [15:0] segment_features_54,
    output reg signed [15:0] segment_features_55,
    output reg signed [15:0] segment_features_56,
    output reg signed [15:0] segment_features_57,
    output reg signed [15:0] segment_features_58,
    output reg signed [15:0] segment_features_59,
    output reg signed [15:0] segment_features_60,
    output reg signed [15:0] segment_features_61,
    output reg signed [15:0] segment_features_62,
    output reg signed [15:0] segment_features_63,
    output reg signed [15:0] segment_features_64,
    output reg signed [15:0] segment_features_65,
    output reg signed [15:0] segment_features_66,
    output reg signed [15:0] segment_features_67,
    output reg signed [15:0] segment_features_68,
    output reg signed [15:0] segment_features_69,
    output reg signed [15:0] segment_features_70,
    output reg signed [15:0] segment_features_71,
    output reg signed [15:0] segment_features_72,
    output reg signed [15:0] segment_features_73,
    output reg signed [15:0] segment_features_74,
    output reg signed [15:0] segment_features_75,
    output reg signed [15:0] segment_features_76,
    output reg signed [15:0] segment_features_77
);

    localparam NUM_BANDS = 13;
    localparam NUM_SEGMENTS = 6;
    localparam SEG_LEN = 2048;   // cycles (~samples) averaged into one segment
    localparam SEG_SHIFT = 11;  // log2(SEG_LEN), power-of-2 divide via shift

    reg signed [15:0] mel_features [0:NUM_BANDS-1];
    reg signed [31:0] accum [0:NUM_BANDS-1];
    reg signed [15:0] segments [0:NUM_SEGMENTS-1][0:NUM_BANDS-1];  // segments[0]=newest
    reg [31:0] cycle_count;
    integer i, k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < NUM_BANDS; i = i + 1) begin
                accum[i] <= 0;
                for (k = 0; k < NUM_SEGMENTS; k = k + 1)
                    segments[k][i] <= 0;
            end
            cycle_count <= 0;
        end else begin
            mel_features[0] = mel_features_0;
            mel_features[1] = mel_features_1;
            mel_features[2] = mel_features_2;
            mel_features[3] = mel_features_3;
            mel_features[4] = mel_features_4;
            mel_features[5] = mel_features_5;
            mel_features[6] = mel_features_6;
            mel_features[7] = mel_features_7;
            mel_features[8] = mel_features_8;
            mel_features[9] = mel_features_9;
            mel_features[10] = mel_features_10;
            mel_features[11] = mel_features_11;
            mel_features[12] = mel_features_12;

            if (cycle_count == SEG_LEN - 1) begin
                // Segment boundary: shift the buffer (drop the oldest segment,
                // slide the rest down), finalize the just-completed segment's
                // running sum into a mean (right-shift, since SEG_LEN is a power
                // of 2), and start accumulating the next one.
                for (k = NUM_SEGMENTS - 1; k > 0; k = k - 1)
                    for (i = 0; i < NUM_BANDS; i = i + 1)
                        segments[k][i] <= segments[k-1][i];
                for (i = 0; i < NUM_BANDS; i = i + 1) begin
                    segments[0][i] <= (accum[i] + mel_features[i]) >>> SEG_SHIFT;
                    accum[i] <= 0;
                end
                cycle_count <= 0;
            end else begin
                for (i = 0; i < NUM_BANDS; i = i + 1)
                    accum[i] <= accum[i] + mel_features[i];
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // Flatten the buffer, oldest segment first (segments[NUM_SEGMENTS-1])
    // through newest (segments[0]), matching the chronological ordering
    // scripts/train.py uses when it concatenates segment-pooled features.
    always @(*) begin
        segment_features_65 = segments[0][0];
        segment_features_66 = segments[0][1];
        segment_features_67 = segments[0][2];
        segment_features_68 = segments[0][3];
        segment_features_69 = segments[0][4];
        segment_features_70 = segments[0][5];
        segment_features_71 = segments[0][6];
        segment_features_72 = segments[0][7];
        segment_features_73 = segments[0][8];
        segment_features_74 = segments[0][9];
        segment_features_75 = segments[0][10];
        segment_features_76 = segments[0][11];
        segment_features_77 = segments[0][12];
        segment_features_52 = segments[1][0];
        segment_features_53 = segments[1][1];
        segment_features_54 = segments[1][2];
        segment_features_55 = segments[1][3];
        segment_features_56 = segments[1][4];
        segment_features_57 = segments[1][5];
        segment_features_58 = segments[1][6];
        segment_features_59 = segments[1][7];
        segment_features_60 = segments[1][8];
        segment_features_61 = segments[1][9];
        segment_features_62 = segments[1][10];
        segment_features_63 = segments[1][11];
        segment_features_64 = segments[1][12];
        segment_features_39 = segments[2][0];
        segment_features_40 = segments[2][1];
        segment_features_41 = segments[2][2];
        segment_features_42 = segments[2][3];
        segment_features_43 = segments[2][4];
        segment_features_44 = segments[2][5];
        segment_features_45 = segments[2][6];
        segment_features_46 = segments[2][7];
        segment_features_47 = segments[2][8];
        segment_features_48 = segments[2][9];
        segment_features_49 = segments[2][10];
        segment_features_50 = segments[2][11];
        segment_features_51 = segments[2][12];
        segment_features_26 = segments[3][0];
        segment_features_27 = segments[3][1];
        segment_features_28 = segments[3][2];
        segment_features_29 = segments[3][3];
        segment_features_30 = segments[3][4];
        segment_features_31 = segments[3][5];
        segment_features_32 = segments[3][6];
        segment_features_33 = segments[3][7];
        segment_features_34 = segments[3][8];
        segment_features_35 = segments[3][9];
        segment_features_36 = segments[3][10];
        segment_features_37 = segments[3][11];
        segment_features_38 = segments[3][12];
        segment_features_13 = segments[4][0];
        segment_features_14 = segments[4][1];
        segment_features_15 = segments[4][2];
        segment_features_16 = segments[4][3];
        segment_features_17 = segments[4][4];
        segment_features_18 = segments[4][5];
        segment_features_19 = segments[4][6];
        segment_features_20 = segments[4][7];
        segment_features_21 = segments[4][8];
        segment_features_22 = segments[4][9];
        segment_features_23 = segments[4][10];
        segment_features_24 = segments[4][11];
        segment_features_25 = segments[4][12];
        segment_features_0 = segments[5][0];
        segment_features_1 = segments[5][1];
        segment_features_2 = segments[5][2];
        segment_features_3 = segments[5][3];
        segment_features_4 = segments[5][4];
        segment_features_5 = segments[5][5];
        segment_features_6 = segments[5][6];
        segment_features_7 = segments[5][7];
        segment_features_8 = segments[5][8];
        segment_features_9 = segments[5][9];
        segment_features_10 = segments[5][10];
        segment_features_11 = segments[5][11];
        segment_features_12 = segments[5][12];
    end

endmodule
