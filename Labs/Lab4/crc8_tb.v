`include "crc8.v"

module crc8_tb;
	reg clk, rst;
	reg [9:0] x = 0;
	wire [7:0] answer;
	reg partition = 0;
	reg bobat = 0;
	integer iterator = 0;


	crc8 mycrc8(clk, rst, bobat, x, partition, answer);


	initial begin
		clk = 0;
		$dumpfile("crc8.vcd");
		$dumpvars(0, crc8_tb);
		rst = 0;
		forever begin
			#50
			clk = ~clk;
		end
	end

	localparam SET_VALUES = 2'b00;
	localparam WAIT1 = 2'b01;
	localparam DONE = 2'b10;
	localparam WAIT2 = 2'b11;

	reg [1:0] STATE = SET_VALUES;


	always @(posedge clk) begin
		if (rst) begin
			STATE <= SET_VALUES;
			x <= 0;
			partition <= 0;
			bobat <= 0;
		end
		else begin
			case(STATE)
				SET_VALUES : begin
					$display("Current answer is : %d", answer);
					x <= iterator;
					bobat <= 1;
					partition <= 0;
					STATE <= WAIT1;
					if(iterator == 1024) begin
						STATE <= DONE;
					end
				end 

				WAIT1 : begin
					bobat <= 0;
					STATE <= WAIT2;
				end

				WAIT2 : begin
					partition <= 1;
					STATE <= SET_VALUES;
					iterator = iterator + 1;
				end

				DONE : begin
					$display("FINISHED!");
					$finish;
				end
			endcase
		end
	end
endmodule