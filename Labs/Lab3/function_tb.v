`timescale 1ns / 1ps
`include "function.v"
module functions_tb;

    reg clk;
    reg [8:0] i, j;
    reg [10:0] triple_i;
    reg [10:0] test_cbrt;
    reg [10:0] left_bound, right_bound;

    reg [7:0] a_in, b_in;
    reg start, in_rst;

    wire [9:0] out;
    wire out_busy;

    functions func(
        .clk(clk),
        .rst(in_rst),
        .a(a_in),
        .b(b_in),
        .start(start),
        .busy(out_busy),
        .out(out)
    );


    localparam SETUP = 4'b0000;
    localparam I_LOOP = 4'b0001;
    localparam J_LOOP = 4'b0010;
    localparam ITERATOR = 4'b0011;
    localparam MAIN_SET = 4'b0100;
    localparam MAIN_SET_FINISHED = 4'b0101;
    localparam MAIN_FINISH = 4'b0110;
    localparam RECALC_CBRT = 4'b0111;
    localparam BODY_4 = 4'b1000;
    localparam CHECK = 4'b1001;
    reg [3:0] STATE = SETUP;


    initial begin
        $dumpfile("function.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, functions_tb);
        clk = 0;
        forever
            #5
            clk = ~clk;
    end

    always @(posedge clk) begin
        case (STATE)
            SETUP:
                begin
                    i <= 0;
                    j <= 0;
                    in_rst <= 1;
                    STATE <= J_LOOP;
                end
            J_LOOP:
                begin
                    if (j == 256) begin
                        i <= i + 1;
                        STATE <= I_LOOP;
                    end else begin
                        set_main();
                    end
                end
            I_LOOP:
                begin
                    if (i == 256) begin
                        $display("ALL TESTS PASSED");
                        $finish;
                    end else begin
                        j <= 0;
                        STATE <= J_LOOP;
                    end
                end
            ITERATOR:
                begin
                    j <= j + 1;
                    STATE <= J_LOOP;
                end

            MAIN_SET_FINISHED:
                begin
                    start <= 0;
                    STATE <= MAIN_FINISH;
                end
            MAIN_FINISH:
                begin
                    if (out_busy == 0) begin
                        STATE <= RECALC_CBRT;
                    end
                end
            RECALC_CBRT:
                begin
                    test_cbrt <= (out - triple_i) >> 1;
                    STATE <= CHECK;
                    calc_bounds();
                end
            CHECK:
                begin
                    if (left_bound <= j && right_bound > j) begin
                        $display("TEST PASSED! a = %d, b = %d, y = %d", a_in, b_in, out);
                    end else begin
                        $display("TEST PASSED! a = %d, b = %d, y = %d", a_in, b_in, out);
                    end
                    STATE <= ITERATOR;
                end
        endcase
    end

    task calc_bounds;
        begin
            left_bound <= test_cbrt * test_cbrt * test_cbrt;
            right_bound <= (test_cbrt + 1) * (test_cbrt + 1) * (test_cbrt + 1);            
            STATE <= CHECK;
        end
    endtask

    task set_main;
        begin
            a_in <= i;
            b_in <= j;
            triple_i <= i*3;
            start <= 1;
            in_rst <= 0;
            STATE <= MAIN_SET_FINISHED; 
        end
    endtask
endmodule
