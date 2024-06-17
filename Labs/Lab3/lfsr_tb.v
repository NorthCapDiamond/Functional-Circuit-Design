`include "lfsr.v"

module lfsr_tb;

	reg clk, rst;
	reg [7:0] x = 0;
	reg data_ready = 0;
	wire [7:0] answer;
	wire done;

	integer i;
	

	lfsr #(8) test_lfsr(clk, rst, data_ready, x, answer, done); 


	initial begin
		clk = 0;
		forever begin
			#50
			clk = ~clk;
		end
	end


	initial begin
		$dumpfile("lfsr.vcd");
		$dumpvars(0, lfsr_tb);

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
			rst <= 1;
			data_ready <= 1;
			#100
			rst <= 0;
			#5000
			$display("FOR : %d; DONE : %d; Value : %d", x_t, done, answer);

		end
	endtask
endmodule



