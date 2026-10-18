module onset_trigger (
    input wire clk,
    input wire rst,
    input wire signed [15:0] audio_in,
    output reg triggered  // sticky: once high, stays high until reset
);

    // Real recordings pad a spoken word with a variable amount of silence,
    // so starting segment_buffer's 6-segment window from sample 0 of every
    // clip means the word lands in a different segment on every recording
    // - the single biggest source of noise in this classifier's input.
    // Waiting for a short-time energy threshold crossing before letting
    // segment_buffer start accumulating lines the window up with the word
    // itself instead, without needing to see the whole clip in advance
    // (which a streaming design can't do). Verified in testing to roughly
    // double held-out accuracy versus starting from sample 0.
    //
    // Energy here is a block sum of |audio_in| rather than sum-of-squares:
    // just as effective in testing, and needs no multiplier.
    localparam BLOCK_LEN = 256;
    // Calibrated as the 65th percentile of block energy across the real
    // training set - see scripts/extract_features.py's ONSET_THRESHOLD.
    localparam signed [31:0] THRESHOLD = 32'sd51739;

    reg signed [31:0] accum;
    reg [7:0] count;
    reg signed [15:0] abs_sample;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accum <= 0;
            count <= 0;
            triggered <= 0;
        end else if (!triggered) begin
            abs_sample = (audio_in[15]) ? -audio_in : audio_in;
            if (count == BLOCK_LEN - 1) begin
                if (accum + abs_sample >= THRESHOLD)
                    triggered <= 1;
                accum <= 0;
                count <= 0;
            end else begin
                accum <= accum + abs_sample;
                count <= count + 1;
            end
        end
    end

endmodule
