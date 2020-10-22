`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Image_count
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


module Image_count(clk, reset, read_en, off_col, off_row );

parameter IMA_SIZE = 6; //image memory x X x
parameter IMA_ADDR = 3;
parameter CON_SIZE = 3; //filter memory y X y
parameter CON_ADDR = 2;

input clk, reset;
input read_en;

output reg [CON_ADDR-1:0] off_col;
output reg [CON_ADDR-1:0] off_row;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        off_row <= 0;
        off_col <= 0;
    end
    else
    begin
        if(read_en)
        begin
            if( (off_row == (CON_SIZE-1)) && (off_col == (CON_SIZE-1)) )
            begin
                off_row <= 0;
                off_col <= 0;
            end//off-row finish
            else if( (off_col == (CON_SIZE-1)) )
            begin
                off_row <= off_row + 1'b1;
                off_col <= 0;
            end//off-col finish
            else
            begin
                off_col <= off_col + 1'b1;
            end //row finish
        end
        else
        begin
            off_row <= 0;
            off_col <= 0;
        end
    end
end
endmodule