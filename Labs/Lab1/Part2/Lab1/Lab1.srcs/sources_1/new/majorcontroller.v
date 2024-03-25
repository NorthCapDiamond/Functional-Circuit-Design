`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITMO
// Engineer: Drobysh Dmitry P33082
// 
// Create Date: 02.03.2024 12:12:29
// Design Name: 
// Module Name: majorcontroller
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


module majorcontroller(
    input a1,
    input a2,
    input b1,
    input b2,
    input c,
    output ans
    );
    
    wire not_a1, not_a2, not_b1, not_b2, not_c;
    wire res1, res2, res3, res4, res5, res6, res7, res8, res9, res10;
    wire tmp;
    
    nor(not_a1, a1, a1);
    nor(not_a2, a2, a2);
    nor(not_b1, b1, b1);
    nor(not_b2, b2, b2);
    nor(not_c, c, c);
    
    nor(res1, not_a1, not_a2, not_b1);
    nor(res2, not_a1, not_a2, not_b2);
    nor(res3, not_a1, not_a2, not_c);
    nor(res4, not_a1, not_b1, not_b2);
    nor(res5, not_a1, not_b1, not_c);
    nor(res6, not_a1, not_b2, not_c);
    nor(res7, not_a2, not_b1, not_b2);
    nor(res8, not_a2, not_b1, not_c);
    nor(res9, not_a2, not_b2, not_c);
    nor(res10, not_b1, not_b2, not_c);
    
    nor(tmp, res1, res2, res3, res4, res5, res6, res7, res8, res9, res10);
    nor(ans, tmp, tmp);
    
endmodule
