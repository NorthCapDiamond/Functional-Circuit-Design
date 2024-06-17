`include "lfsr2.v"

module lfsr2_tb;

	reg clk, rst;
	reg [7:0] x = 0;
	reg data_ready = 0;
	wire [7:0] answer;
	wire done;

	integer i;
	

	lfsr2 test_lfsr(clk, rst, answer); 


	initial begin
		clk = 0;
		forever begin
			#50
			clk = ~clk;
		end
	end


	initial begin
		$dumpfile("lfsr2.vcd");
		$dumpvars(0, lfsr2_tb);

		for(i = 1; i < 256; i=i+1) begin
			#100
			$display("answer : %d", answer);
		end

		$display("FINISHED");
		$finish;
	end

endmodule



