`timescale 1ns / 1ps

module onset_trigger_tb;
    reg clk, rst;
    reg signed [15:0] audio_in;
    wire triggered;
    integer i;

    onset_trigger uut (.clk(clk), .rst(rst), .audio_in(audio_in), .triggered(triggered));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; audio_in = 0;
        #12 rst = 0;

        // Block energy here is 256*100 = 25600, well under the 51739
        // threshold - should never trigger across several such blocks
        // (quiet/silence section of a recording).
        for (i = 0; i < 256 * 4; i = i + 1) begin
            @(posedge clk);
            audio_in = 100;
        end
        $display("after quiet audio (256*100=25600/block, under threshold): triggered=%b (expect 0)", triggered);

        // Block energy now 256*500 = 128000, over the 51739 threshold -
        // should trigger partway through this block.
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge clk);
            audio_in = 500;
        end
        $display("after one loud block (256*500=128000/block, over threshold): triggered=%b", triggered);

        // The threshold check lands on the block's last cycle and the
        // latch takes effect the cycle after, so the actual trigger shows
        // up once the next block starts - still correctly latched (and
        // staying latched) even once audio goes quiet again.
        for (i = 0; i < 256 * 2; i = i + 1) begin
            @(posedge clk);
            audio_in = 0;
        end
        $display("one block later, now in silence: triggered=%b (expect 1, latched)", triggered);
        $finish;
    end
endmodule
