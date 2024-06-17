`timescale 1ns / 1ps
`include "cbrt.v"
`include "adder.v"

module functions(input clk,
                 input rst,
                 input [7:0] a,
                 input [7:0] b,
                 input start,
                 output reg [9:0] out,
                 output wire busy
                );

    wire [15:0] cbrt_adder_a, cbrt_adder_b;
    wire [15:0] adder_a_in, adder_b_in;
    wire [31:0] adder_s_out;

    adder #(16) sum(.A(adder_a_in),
                    .B(adder_b_in),
                    .S(adder_s_out)
                    );

    wire [3:0] cqrt_out;
    wire cqrt_busy;
    cbrt crt(.clk(clk),
             .rst(rst),
             .a(b),
             .start(start),
             .res(cqrt_out),
             .busy(cqrt_busy),
             .adder_s_out(adder_s_out),
             .adder_a_in(cbrt_adder_a),
             .adder_b_in(cbrt_adder_b)
            );

    wire [15:0] mul_out;
    wire mul_busy;
    multiplier mult(.clk(clk),
                    .rst(rst),
                    .a(a),
                    .b(3),
                    .start(start),
                    .busy(mul_busy),
                    .y(mul_out)
                    );

    localparam INACTIVE = 2'b00;
    localparam WAIT = 2'b01;
    localparam FINISH = 2'b10;
    reg [1:0] STATE;

    assign busy = (STATE!=INACTIVE);
    assign adder_a_in = STATE == FINISH ? mul_out : cbrt_adder_a;
    assign adder_b_in = STATE == FINISH ? cqrt_out << 1 : cbrt_adder_b;
    

    always @(posedge clk)
        if (rst) begin
            out <= 0;
            STATE <= INACTIVE;
        end else begin
            case (STATE)
                INACTIVE :
                    if (start) begin
                        STATE <= WAIT;
                    end
                WAIT:
                    begin
                        if (~mul_busy && ~cqrt_busy) begin
                            STATE <= FINISH;
                        end
                    end
                FINISH:
                    begin
                        out <= adder_s_out;
                        STATE <= INACTIVE;
                    end
            endcase
        end
endmodule
