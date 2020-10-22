`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: weight_count
// Project Name: 
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


module weight_count(clk, reset, weight_read_en, weight_off_row );

parameter WEIGHT_SIZE_COL = 7;
parameter WEIGHT_SIZE_ROW = 28;
parameter WEIGHT_ADDR_COL = 3;
parameter WEIGHT_ADDR_ROW = 5;

input clk, reset;
//input weight_write_en;
input weight_read_en;


output reg [WEIGHT_ADDR_ROW-1:0] weight_off_row;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        weight_off_row <= 0;
    end
    else
    begin
        if(weight_read_en)
        begin
            if( weight_off_row == (WEIGHT_SIZE_ROW-1) )
            begin
                weight_off_row <= 0;
            end//off-row finish
            else
            begin
                weight_off_row <= weight_off_row + 1'b1;
            end//off-col finish
        end
        else
        begin
            weight_off_row <= 0;
        end
    end
end
endmodule