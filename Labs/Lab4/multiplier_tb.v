`timescale 1ns / 1ps
`include "multiplier.v"
module multiplier_tb;
    reg clk;
    reg [8:0] i, j;
    reg [15:0] test_out;

    reg [7:0] a_in, b_in;
    reg start, rst;

    wire [15:0] out;
    wire out_busy;

    multiplier mull_test(
        .clk(clk),
        .rst(rst),
        .a(a_in),
        .b(b_in),
        .start(start),
        .busy(out_busy),
        .y(out)
    );

    localparam SETUP = 3'b000;
    localparam J_LOOP = 3'b001;
    localparam I_LOOP = 3'b010;
    localparam ITERATOR = 3'b011;
    localparam SETUP_MUL = 3'b100;
    localparam SETUP_MUL_DONE = 3'b101;
    localparam WAIT = 3'b110;
    localparam CHECK_RES = 3'b111;

    reg [3:0] STATE = SETUP;


    initial begin
        $dumpfile("multiplier.vcd");
        $timeformat(-9, 1, "ns", 8);
        $dumpvars(0, multiplier_tb);
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
                    rst <= 1;
                    STATE <= J_LOOP;
                end

            J_LOOP:
                begin
                    if (j == 256) begin
                        i <= i + 1;
                        STATE <= I_LOOP;
                    end else begin
                        STATE <= SETUP_MUL;
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
            SETUP_MUL:
                begin
                    mul_setup(i,j);
                end
            SETUP_MUL_DONE:
                begin
                    start <= 0;
                    STATE <= WAIT;
                end
            WAIT:
                begin
                    if (out_busy == 0) begin
                        STATE <= CHECK_RES;
                    end
                end
            CHECK_RES:
                begin
                    if (out == test_out) begin
                        $display("Test passed! a = %d, b = %d, Found = %d, Expected = %d", a_in, b_in, out, test_out);
                    end else begin
                        $display("Incorrect! a = %d, b = %d, Found = %d, Expected = %d", a_in, b_in, out, test_out);
                    end
                    STATE <= ITERATOR;
                end
        endcase
    end

    task mul_setup;
        input [7:0] i_task, j_task;
        begin
            a_in <= i_task;
            b_in <= j_task;
            test_out <= i_task * j_task;
            start <= 1;
            rst <= 0;
            STATE <= SETUP_MUL_DONE;
        end
    endtask

endmodule