`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Conved_count
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


module Conved_count(clk, reset, cv_write_en, cv_read_en, cv_add_in_col, cv_add_in_row, cv_off_col, cv_off_row );

parameter CON_SIZE = 4; //conved memory y X y
parameter CON_ADDR = 2;

input clk, reset;
input cv_write_en;
input cv_read_en;

output reg [CON_ADDR-1:0] cv_add_in_col;
output reg [CON_ADDR-1:0] cv_add_in_row;

output reg [CON_ADDR-2-1:0] cv_off_col;
output reg [CON_ADDR-2-1:0] cv_off_row;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        cv_add_in_col <= 0;
        cv_add_in_row <= 0;
        cv_off_row <= 0;
        cv_off_col <= 0;
    end
    else
    begin
        if(cv_write_en)
        begin
            if( (cv_add_in_row == (CON_SIZE-1)) && (cv_add_in_col == (CON_SIZE-1)) )
            begin
                cv_add_in_row <= 0;
                cv_add_in_col <= 0;    
            end
            else if(cv_add_in_col == (CON_SIZE-1))
            begin
                cv_add_in_row <= cv_add_in_row + 1'b1;
                cv_add_in_col <= 0;
            end
            else cv_add_in_col <= cv_add_in_col + 1'b1;
        end
        else if(cv_read_en)
        begin
            if( (cv_off_row == (6)) && (cv_off_col == (6)) )
            begin
                cv_off_row <= 0;
                cv_off_col <= 0;
            end//off-row finish
            else if( (cv_off_col == (6)) )
            begin
                cv_off_row <= cv_off_row + 1'b1;
                cv_off_col <= 0;
            end//off-col finish
            else
            begin
                cv_off_col <= cv_off_col + 1'b1;
            end //row finish
        end
        else
        begin
            cv_off_row <= 0;
            cv_off_col <= 0;
        end
    end
end
endmodule