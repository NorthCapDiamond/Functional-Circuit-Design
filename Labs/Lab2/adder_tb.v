`timescale 1ns / 1ps

`include "adder.v"

module n_bit_adder_tb;
    reg [N-1:0] A, B;
    wire [2*N-1:0] S;

    parameter N = 8;

    adder #(N) DUT(.A(A), .B(B), .S(S));


    integer i, j, k;
    reg [N-1:0] test_value1;
    reg [N-1:0] test_value2;
    reg [N:0] expected_value;

    initial begin
        $dumpfile("adder.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, n_bit_adder_tb);
        $monitor($time, "| a=%d, b=%d, s=%d, ", A, B, S);


        for(i = 0; i < 256; i = i + 1 ) begin
            for (j = 0; j < 256; j = j + 1 )begin
                test_value1 = i;
                test_value2 = j;

                A = test_value1;
                B = test_value2;

                expected_value = test_value1 + test_value2;

                #10

                if(S == expected_value) begin
                    $display("Test Passed!");
                end else begin
                    $display("Test failed on values: a=%d, b=%d, s=%d", A, B, S);
                    $display("Returned %d expected %d",  S, expected_value);
                    $finish;
                    
                end

            end
        end
        $display("ALL TESTS PASSED");
    end
endmodule



