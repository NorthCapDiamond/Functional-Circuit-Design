`include "debounce.v"

module debounce_tb;


	reg clk;
	reg button = 0;
	wire answer;

	debounce mydeb(clk, button, answer);

    initial begin
        $dumpfile("debounce.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, debounce_tb); 
        clk = 0;
        forever
            #5
            clk = ~clk;
    end


	initial begin
		button <= 1;
		#1000
		button <= 0;
		#1000
		$display("ANSWER : %d", answer);

		button <= 1;
		#1000
		$display("ANSWER : %d", answer);

		button <= 0;
		#1000
		$display("ANSWER : %d", answer);
		$finish;
	end
endmodule