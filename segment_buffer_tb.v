`timescale 1ns / 1ps

module segment_buffer_tb;
    reg clk, rst;
    reg [15:0] mel_features_0, mel_features_1, mel_features_2, mel_features_3;
    reg [15:0] mel_features_4, mel_features_5, mel_features_6, mel_features_7;
    reg [15:0] mel_features_8, mel_features_9, mel_features_10, mel_features_11;
    reg [15:0] mel_features_12;

    wire signed [15:0] segment_features_12, segment_features_52;
    wire signed [15:0] segment_features_65, segment_features_77;

    integer cycle;

    segment_buffer uut (
        .clk(clk), .rst(rst), .start_enable(1'b1),
        .mel_features_0(mel_features_0), .mel_features_1(mel_features_1),
        .mel_features_2(mel_features_2), .mel_features_3(mel_features_3),
        .mel_features_4(mel_features_4), .mel_features_5(mel_features_5),
        .mel_features_6(mel_features_6), .mel_features_7(mel_features_7),
        .mel_features_8(mel_features_8), .mel_features_9(mel_features_9),
        .mel_features_10(mel_features_10), .mel_features_11(mel_features_11),
        .mel_features_12(mel_features_12),
        .segment_features_12(segment_features_12),
        .segment_features_52(segment_features_52),
        .segment_features_65(segment_features_65),
        .segment_features_77(segment_features_77)
    );

    always #5 clk = ~clk;

    // Feed band 0 a cycle-dependent ramp (so each segment's mean is
    // predictable: the mean of consecutive integers k..k+2047 is
    // k+1023.5, truncated to k+1023 by the hardware's integer right
    // shift) and every other band a constant 100, so segment_features_12
    // (band 12 of the oldest segment) should read exactly 100 once the
    // buffer has filled, regardless of the ramp.
    initial begin
        clk = 0; rst = 1;
        mel_features_0 = 0;
        mel_features_1 = 100; mel_features_2 = 100; mel_features_3 = 100;
        mel_features_4 = 100; mel_features_5 = 100; mel_features_6 = 100;
        mel_features_7 = 100; mel_features_8 = 100; mel_features_9 = 100;
        mel_features_10 = 100; mel_features_11 = 100; mel_features_12 = 100;
        #12 rst = 0;

        // Segment averages land one segment-length after the samples that
        // produced them finish streaming in (the average of a segment
        // can't be known until its last sample has arrived) - so check
        // each segment's result after driving the *next* one.
        for (cycle = 0; cycle < 2048; cycle = cycle + 1) begin
            @(posedge clk);
            mel_features_0 = cycle;  // segment 0: band-0 samples 0..2047
        end
        for (cycle = 0; cycle < 2048; cycle = cycle + 1) begin
            @(posedge clk);
            mel_features_0 = 2048 + cycle;  // segment 1: band-0 samples 2048..4095
        end
        // Newest slot now holds segment 0's average: mean(0..2047) = 1023.5 -> 1023.
        $display("segment 0 (oldest of 2 so far): newest_slot[band0]=%d (expect 1023), newest_slot[band12]=%d (expect 100)",
                 segment_features_65, segment_features_77);

        for (cycle = 0; cycle < 2048; cycle = cycle + 1) begin
            @(posedge clk);
            mel_features_0 = 4096 + cycle;  // segment 2: band-0 samples 4096..6143
        end
        // Newest slot now holds segment 1's average: mean(2048..4095) = 3071.5 -> 3071.
        // The slot it displaced (segment 0's average) should have shifted down intact.
        $display("segment 1 (newest of 3 so far): newest_slot[band0]=%d (expect 3071), shifted-down slot[band0]=%d (expect 1023)",
                 segment_features_65, segment_features_52);
        $display("still-unfilled oldest slot, band12=%d (expect 0 - buffer isn't warmed up past 3 of 6 segments yet)",
                 segment_features_12);
        $finish;
    end
endmodule
