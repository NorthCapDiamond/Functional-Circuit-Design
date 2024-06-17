`timescale 1ns / 1ps

module adder(input wire [N-1:0] A,
             input wire [N-1:0] B,
             output wire [2*N-1:0] S
            );

    parameter N = 8;
    assign S = A + B;

endmodule