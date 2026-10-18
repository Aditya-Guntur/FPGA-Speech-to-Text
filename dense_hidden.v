module dense_hidden (
    input wire clk,
    // First layer of the classifier: 78 segment-pooled Mel features in
    // (6 time segments x 13 bands - see segment_buffer.v, which replaced
    // classifying each raw per-sample Mel vector on its own with pooling
    // over a sliding window long enough to span a spoken word, giving the
    // classifier the temporal context a single-frame or whole-clip-mean
    // input never has), 16 hidden pre-activations out (ReLU is applied
    // outside this module, by the same relu.v instances used on the output
    // layer - see top_module.v).
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
    output reg signed [15:0] hidden_flat_0, output reg signed [15:0] hidden_flat_1, output reg signed [15:0] hidden_flat_2, output reg signed [15:0] hidden_flat_3, output reg signed [15:0] hidden_flat_4, output reg signed [15:0] hidden_flat_5, output reg signed [15:0] hidden_flat_6, output reg signed [15:0] hidden_flat_7, output reg signed [15:0] hidden_flat_8, output reg signed [15:0] hidden_flat_9, output reg signed [15:0] hidden_flat_10, output reg signed [15:0] hidden_flat_11, output reg signed [15:0] hidden_flat_12, output reg signed [15:0] hidden_flat_13, output reg signed [15:0] hidden_flat_14, output reg signed [15:0] hidden_flat_15
);

    localparam NUM_FEATURES = 78;
    localparam NUM_NEURONS = 16;

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
    end

endmodule
