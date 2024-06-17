`timescale 1ns / 1ps
`include "adder.v"
`include "cbrt.v"

module cbrt_tb();

    reg clk;
    initial begin
        $dumpfile("cbrt.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, cbrt_tb); 
        clk = 0;
        forever
            #5
            clk = ~clk;
    end

    reg [8:0] i;
    reg [7:0] a;
    reg start, rst;

    wire [3:0] out;
    wire out_busy;

    wire [15:0] sum_a, sum_b;
    wire [15:0] sum_res;

    integer left_bound;
    integer right_bound;

    adder sum(.A(sum_a),
              .B(sum_b),
              .S(sum_res)
             );

    cbrt cqrt(.clk(clk),
              .rst(rst),
              .a(a),
              .start(start),
              .res(out),
              .busy(out_busy),
              .adder_s_out(sum_res),
              .adder_a_in(sum_a),
              .adder_b_in(sum_b)
             );


    localparam SETUP = 4'b0001;
    localparam LOOP = 4'b0010;
    localparam ITERATOR = 4'b0011;
    localparam MAIN = 4'b0100;
    localparam MAIN_1 = 4'b0101;
    localparam WAIT = 4'b0110;
    localparam CHECK = 4'b0111;


    reg [3:0] STATE = SETUP;

    always @(posedge clk) begin
        
        case (STATE)
            SETUP:
                begin
                    i <= 0;
                    rst <= 1;
                    STATE <= LOOP;
                end
            LOOP:
                begin
                    if (i == 256) begin
                        $display("ALL TESTS PASSED");
                        $finish;
                    end else begin
                        STATE <= MAIN;
                    end
                end
            ITERATOR:
                begin
                    i <= i + 1;
                    STATE <= LOOP;
                end
            MAIN:
                begin
                    a <= i;
                    start <= 1;
                    rst <= 0;
                    STATE <= MAIN_1;
                end
            MAIN_1:
                begin
                    start <= 0;
                    STATE <= WAIT;
                end
            WAIT:
                begin
                    if (out_busy == 0) begin
                        change_state();
                    end
                end
            CHECK:
                begin
                    if (out == $floor($pow(a, 1.0/3.0)) | out == $floor($pow(a, 1.0/3.0)) + 1) begin
                        $display("Test Passed! For : %0d, Root : %0d", a, out);
                    end else begin
                        $display("Test Failed! For : %0d, Root : %0d But %0d", a, out, $floor($pow(a, 1.0/3.0)));
                    end
                    STATE <= ITERATOR;
                end
        endcase
    end

    task change_state;
        begin
            STATE <= CHECK;
        end
    endtask
endmodule