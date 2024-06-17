module lfsr (
    input get,
    input rst,
    output reg [7:0] state = 8'h11
);
  reg rst_delay = 0;
  always @(posedge get) begin
    rst_delay <= rst;
  end

  wire rst_pos = rst & ~rst_delay;

  always @(posedge get) begin
    if (rst_pos) state <= 8'h11;
    else state <= {state[6:0], (state[4] ^ state[6] ^ state[7] ^ state[0])};
  end
endmodule