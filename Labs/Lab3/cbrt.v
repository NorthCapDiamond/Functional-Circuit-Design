`timescale 1ns / 1ps
`include "multiplier.v"

module cbrt(input clk,
            input rst,
            input [7:0] a,
            input start,

            output reg [3:0] res,
            output wire busy,

            input wire [15:0] adder_s_out,
            output reg [15:0] adder_a_in,
            output reg [15:0] adder_b_in
            );

    reg [7:0] a_mul, b_mul;
    wire [15:0] y_mul;
    reg mult_start;
    wire mult_busy;
    multiplier mull(
        .clk(clk),
        .rst(rst),
        .a(a_mul),
        .b(b_mul),
        .start(mult_start),
        .busy(mult_busy),
        .y(y_mul)
    );

    localparam  INACTIVE = 4'b0000;
    localparam  EXIT_CONDITION = 4'b0001;
    localparam  MUL1_SETUP = 4'b0010;
    localparam  MUL2_SETUP = 4'b0011;
    localparam  MUL3_SETUP = 4'b0100;
    localparam  MUL1_START = 4'b0101;
    localparam  MUL2_START = 4'b0110;
    localparam  WAIT_MUL = 4'b0111;
    localparam  WAIT_B = 4'b1000;
    localparam  ITERATOR = 4'b1001;
    localparam  DECR = 4'b1010;
    localparam  INCR = 4'b1011;
    localparam  INCR_WAIT = 4'b1100;


    reg [7:0] s;
    wire end_step;
    reg [7:0] x;
    reg [31:0] b, y, tmp;
    reg [4:0] STATE;

    assign end_step = (s == 'hfd);
    assign busy = (STATE != INACTIVE);

    always@(posedge clk) begin
        if(rst) begin
            STATE <= INACTIVE;
        end
        else begin
            case (STATE)
                INACTIVE:
                    begin
                        if(start) begin
                            mult_start <= 0;
                            x <= a;
                            s <= 30;
                            y <= 0;
                            STATE <= EXIT_CONDITION;
                        end
                    end

                EXIT_CONDITION:
                    begin
                        if(end_step) begin
                            STATE <= INACTIVE;
                            res <= y;
                        end else begin
                            y <= y << 1;
                            STATE <= MUL1_SETUP;
                        end
                    end

                MUL1_SETUP:
                    begin
                        STATE <= MUL2_SETUP;
                        tmp <= y << 1;
                    end

                MUL2_SETUP:
                    begin
                        STATE <= MUL3_SETUP;
                        adder_a_in <= tmp;
                        adder_b_in <= y;
                    end

                MUL3_SETUP:
                    begin
                        STATE <= MUL1_START;
                        tmp <= adder_s_out;
                        adder_a_in <= y;
                        adder_b_in <= 1;
                    end

                MUL1_START:
                    begin
                        STATE <= MUL2_START;
                        a_mul <= tmp;
                        b_mul <= adder_s_out;
                        mult_start <= 1;
                    end

                MUL2_START:
                    begin
                        mult_start <= 0;
                        STATE <= WAIT_MUL;
                    end

                WAIT_MUL:
                    begin
                        if(~mult_busy) begin
                            STATE <= WAIT_B;
                            adder_a_in <= y_mul;
                            adder_b_in <= 1;
                        end
                    end

                WAIT_B:
                    begin
                        STATE <= ITERATOR;
                        b <= adder_s_out << s;
                        adder_a_in <= s;
                        adder_b_in <= -3;
                    end

                ITERATOR:
                    begin
                        if(x >= b) begin
                            STATE <= DECR;
                            adder_a_in <= ~b;
                            adder_b_in <= 1;
                        end else begin
                            STATE <= EXIT_CONDITION;
                        end
                        s <= adder_s_out;
                    end

                DECR:
                    begin
                        STATE <= INCR;
                        adder_a_in <= x;
                        adder_b_in <= adder_s_out;
                    end

                INCR:
                    begin
                        STATE <= INCR_WAIT;
                        x <= adder_s_out;
                        adder_a_in <= y;
                        adder_b_in <= 1;
                    end

                INCR_WAIT:
                    begin
                        STATE <= EXIT_CONDITION;
                        y <= adder_s_out;
                    end
            endcase
        end
    end
endmodule