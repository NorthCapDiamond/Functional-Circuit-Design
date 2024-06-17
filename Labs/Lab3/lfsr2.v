module lfsr2 (input clk,
			 input rst,
			 input data_ready,
			 input [n_bits-1:0] x,
			 output [n_bits-1:0] x_out,
			 output done
			);

	parameter n_bits = 8;
	reg [n_bits-1:0] current;
	reg [n_bits-1:0] x_reg;
	reg [n_bits-1:0] out_reg;
	reg done_reg;
	integer ITER;
	integer LOOPER;

	localparam START = 4'b0000;
	localparam PRESET = 4'b0001;
	localparam CALC_BIT = 4'b0010;
	localparam SHIFT = 4'b0011;
	localparam PUT_BIT = 4'b0100;
	localparam DONE = 4'b0101;

	reg [3:0] STATE = START;
	reg res_bit;

	assign done = done_reg;
	assign x_out = out_reg;

	always @(posedge clk) begin
		//$monitor("x : %d | current : %d | LOOPER : %d", x_reg, current, LOOPER);
		if (rst) begin
			current <= 0;
			x_reg <= x;
			res_bit <= 0;
			STATE <= START;
			LOOPER <= 0;
			ITER <= 0;
			done_reg <= 0;
			out_reg <= 0;
		end
		else begin
			if(data_ready) begin
				case(STATE)
					START : begin
						//$display("START");
						current <= 0;
						x_reg <= x;
						res_bit <= 0;
						STATE <= PRESET;
						LOOPER <= 0;
						ITER <= 0;
						done_reg <= 0;
						out_reg <= 0;
					end

					PRESET : begin
						//$display("PRESET");
						current <= (1 + x_reg*x_reg*x_reg*x_reg + x_reg*x_reg*x_reg*x_reg*x_reg*x_reg  + x_reg*x_reg*x_reg*x_reg*x_reg*x_reg*x_reg + x_reg*x_reg*x_reg*x_reg*x_reg*x_reg*x_reg*x_reg);
						STATE <= CALC_BIT;
						ITER <= 0;
					end

					CALC_BIT : begin
						//$display("CALC_BIT");
						if(LOOPER == 3) begin
							STATE <= DONE;
						end
						else begin
							if(ITER >= n_bits) begin
								STATE <= SHIFT;
							end
							else begin
								res_bit <= res_bit ^ current[ITER];
								ITER <= ITER + 1;

							end
						end
					end

					SHIFT : begin
						//$display("SHIFT");
						current <= current >> 1;
						STATE <= PUT_BIT;
					end

					PUT_BIT : begin
						//$display("PUT_BIT");
						current[n_bits-1] <= res_bit;
						LOOPER <= LOOPER + 1;
						res_bit <= 0;
						STATE <= CALC_BIT;
						ITER <= 0;
					end

					DONE : begin
						//$display("DONE");
						done_reg <= 1;
						out_reg <= current;
					end
				endcase
			end
		end
	end
endmodule