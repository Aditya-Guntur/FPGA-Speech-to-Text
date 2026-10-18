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

reg [15:0] audio_memory [0:SAMPLE_COUNT-1];
reg [ADDR_WIDTH-1:0] address;

initial begin
    $readmemh("audio.mem", audio_memory);
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        address <= {ADDR_WIDTH{1'b0}};
        audio_out <= 16'd0;
    end else begin
        audio_out <= audio_memory[address];
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
