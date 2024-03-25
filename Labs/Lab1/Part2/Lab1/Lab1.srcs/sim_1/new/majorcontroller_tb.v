`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITMO
// Engineer: Drobysh Dmitry P33082
// 
// Create Date: 02.03.2024 13:38:18
// Design Name: 
// Module Name: majorcontroller_tb
// Project Name: Lab1
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module majorcontroller_tb;

    reg a1_in, a2_in, b1_in, b2_in, c_in;
    wire ans_out;
    
    majorcontroller majorcontroller_1 (
        .a1 (a1_in),
        .a2 (a2_in),
        .b1 (b1_in),
        .b2 (b2_in),
        .c (c_in),
        .ans (ans_out)
    );
    
    integer i;
    reg[4:0] test_value;
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            test_value = i;
            a1_in = test_value[0];
            a2_in = test_value[1];
            b1_in = test_value[2];
            b2_in = test_value[3];
            c_in = test_value[4];
            
            #10
            
            $display("a1 = %b; a2 = %b; b1 = %b; b2 = $b; c = %b; answer = %b",
            a1_in, a2_in, b1_in, b2_in, c_in, ans_out);
        end
   
    #10 $stop;
    end
endmodule
