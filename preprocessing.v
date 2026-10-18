module preprocessing (
    input wire clk,
    input wire rst,
    output reg signed [15:0] audio_out
);

// audio.mem holds 21760 real 16-bit PCM samples (~1.36s at 16kHz). The
// buffer used to be sized [0:1023] with a 10-bit address register - far too
// small to hold the actual recording, which starts with a run of silence,
// so the design only ever read the first 1024 samples (leading silence)
// and the FFT/Mel/classifier stages never saw the actual spoken word.
localparam SAMPLE_COUNT = 21760;
localparam ADDR_WIDTH = 15; // ceil(log2(21760)) = 15, holds up to 32768

// First-order pre-emphasis: y[n] = x[n] - ALPHA*x[n-1]. Speech energy falls
// off at high frequencies, so this boosts them before the DFT stage, which
// is standard practice ahead of any spectral feature extraction. ALPHA is
// Q15 for 0.95 (round(0.95 * 32768)).
localparam signed [15:0] ALPHA_Q15 = 16'sd31130;

reg [15:0] audio_memory [0:SAMPLE_COUNT-1];
reg [ADDR_WIDTH-1:0] address;
reg signed [15:0] prev_sample;

initial begin
    $readmemh("audio.mem", audio_memory);
end

// Pre-emphasis can exceed the 16-bit range (two near-full-scale samples of
// opposite sign), so compute it wide and saturate back down rather than
// silently wrapping around, which would distort the filtered signal.
reg signed [16:0] emphasized_wide;
localparam signed [16:0] SAT_MAX = 17'sd32767;
localparam signed [16:0] SAT_MIN = -17'sd32768;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        address <= {ADDR_WIDTH{1'b0}};
        audio_out <= 16'sd0;
        prev_sample <= 16'sd0;
    end else begin
        emphasized_wide = $signed(audio_memory[address]) - (($signed(prev_sample) * ALPHA_Q15) >>> 15);
        if (emphasized_wide > SAT_MAX) begin
            audio_out <= SAT_MAX[15:0];
        end else if (emphasized_wide < SAT_MIN) begin
            audio_out <= SAT_MIN[15:0];
        end else begin
            audio_out <= emphasized_wide[15:0];
        end

        prev_sample <= audio_memory[address];

        // Loop back to the start once the whole recording has played,
        // instead of reading past the end of the real sample data.
        if (address == SAMPLE_COUNT - 1) begin
            address <= {ADDR_WIDTH{1'b0}};
        end else begin
            address <= address + 1'b1;
        end
    end
end

endmodule
