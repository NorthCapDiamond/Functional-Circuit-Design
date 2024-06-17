`timescale 1ns / 1ps
`include "function.v"
`include "crc8.v"
`include "debounce.v"
`include "lfsr2.v"
`include "lfsr.v"

module bist(input CLK100MHZ,
            input BTNU,
            input BTNL,
            input [15:0] SW,
            input BTNC,
            output LED16_B,
            output [15:0] LED
            );

            reg test_button;

            wire rst_button_deb;
            wire start_button_deb;

            wire[7:0] a, b;

            wire [15:0] out;
            wire busy_f;

            reg [15:0] led_reg = 1;
            reg led16_b_reg = 1;

            assign a = SW[7:0];
            assign b = SW[15:8];
            assign LED = out;
            assign LED16_B = busy_f;

            functions func_tester(.clk(CLK100MHZ),
                             .rst(rst_button_deb),
                             .a(a),
                             .b(b),
                             .start(start_button_deb),
                             .out(out),
                             .busy(busy_f)
                             );


            debounce reseter(CLK100MHZ, BTNU, rst_button_deb);
            debounce starter(CLK100MHZ, BTNC, start_button_deb);
            


            localparam START = 3'b000;
            localparam LOOP = 3'b001;
            localparam DONE = 3'b011;

            reg [1:0] STATE = START;

            reg [15:0] led_reg = 1;
            reg led16_b_reg = 1;
endmodule