`include "crc8.v"

module crc8_tb;
	reg clk, rst;
	reg [7:0] x = 0;
	reg data_ready = 0;
	wire [7:0] answer;
	wire done;
	integer i;


	crc8 mycrc8(clk, rst, x, data_ready, done, answer);


	initial begin
		clk = 0;
		forever begin
			#50
			clk = ~clk;
		end
	end


	initial begin
		$dumpfile("crc8.vcd");
		$dumpvars(0, crc8_tb);
		rst <= 0;
		for(i = 1; i < 256; i=i+1) begin
			iterator(i);
			$display("FINISHED");
		end
		$finish;
	end


	task iterator;
		input [7:0] x_t;

		begin
			x <= x_t;
			data_ready <= 1;
			#100
			#500000
			data_ready<=0;
			#100
			$display("FOR : %d; DONE : %d; Value : %d", x_t, done, answer);

		end
	endtask

endmodule