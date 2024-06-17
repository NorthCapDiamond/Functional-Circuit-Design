module crc8(input clk,
			input rst,
			input [7:0] data,
			input data_ready,
			output done,
			output [7:0] out
		   );
	
	reg done_reg = 0;
	reg [7:0] out_reg = 0;
	reg [7:0] shift_reg = 0;
	reg shifted_bit;

	assign done = done_reg;
	assign out = out_reg;

	integer LOOPER = 8;

	localparam START = 3'b000;
	localparam SHIFT = 3'b001;
	localparam STEP8 = 3'b010;
	localparam IF_ST = 3'b011;
	localparam ANOTHER_SUM = 3'b100;
	localparam DONE = 3'b111;

	reg[2:0] STATE = START;


	always @(posedge clk) begin
		if (rst) begin
			done_reg <= 0;
			out_reg <= 0;
			STATE <= START;
		end
		else if (data_ready) begin
			//$monitor("out_reg : %d; shift_reg : %d; shifted_bit : %d; done_reg : %d; LOOPER", out_reg, shift_reg, shifted_bit, done_reg, LOOPER);
			case(STATE)
				START : begin
					//$display("START");
					done_reg <= 0;
					shift_reg <= data ^ out_reg;
					STATE <= SHIFT;
				end

				SHIFT : begin
					//$display("SHIFT");
					shifted_bit <= shift_reg[7];
					shift_reg <= shift_reg << 1;
					STATE <= IF_ST;
				end

				IF_ST : begin
					//$display("IF_ST");
					if(~shifted_bit) begin
						STATE <= STEP8;
					end
					else begin
						STATE <= ANOTHER_SUM;
					end
				end

				ANOTHER_SUM : begin
					//$display("ANOTHER_SUM");
					shift_reg <= shift_reg ^ (8'b01110001);
					STATE <= STEP8;
				end

				STEP8 : begin
					//$display("STEP8");
					out_reg <= shift_reg;
					if(LOOPER) begin
						STATE <= START;
						LOOPER = LOOPER - 1;
					end
					else begin
						//$display("DONE");
						done_reg <= 1;
					end
				end
			endcase
		end
		
		else begin
			STATE <= START;
		end
	end
endmodule