`timescale 1ns / 1ps
module crc8(
    input clk,
    input rst,
    input bobat,
    input[9:0] data,
    input partition,
    output reg[7:0] crc
);

parameter DEFAULT = 8'b10111000;
parameter K = 8'b01110001; //polinome
//parameter K = 8'b10001110;
integer i;
reg[7:0] shift_reg = DEFAULT;
wire [7:0] data_i;

assign data_i = partition == 1 ? {6'b0, data[9:8]} : data[7:0];

always @(posedge bobat) begin
    shift_reg = crc;
    for (i = 0; i < 8; i = i + 1) begin
        shift_reg = shift_reg ^ data_i;
        if (shift_reg[7] == 1'b1) begin
            shift_reg = {shift_reg[6:0], 1'b0};
            shift_reg = shift_reg ^ K;    
        end 
        else begin
            shift_reg = {shift_reg[6:0], 1'b0};
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        crc <= DEFAULT;
        shift_reg <= DEFAULT;
    end else begin
        crc <= shift_reg;
    end
end

endmodule