`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Pooled_count
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


module Pooled_count(clk, reset, pool_write_en, pool_read_en, pool_add_in_col, pool_add_in_row, pool_add_in_col2, pool_add_in_row2,
 pool_add_in_col3, pool_add_in_row3, pool_add_in_col4, pool_add_in_row4 , pool_off_row );

parameter POOL_SIZE_COL = 7;
parameter POOL_SIZE_ROW = 28;
parameter POOL_ADDR_COL = 3;
parameter POOL_ADDR_ROW = 5;

input clk, reset;
input pool_write_en;
input pool_read_en;

output reg [POOL_ADDR_COL-1:0] pool_add_in_col;
output reg [POOL_ADDR_ROW-1:0] pool_add_in_row;
output reg [POOL_ADDR_COL-1:0] pool_add_in_col2;
output reg [POOL_ADDR_ROW-1:0] pool_add_in_row2;
output reg [POOL_ADDR_COL-1:0] pool_add_in_col3;
output reg [POOL_ADDR_ROW-1:0] pool_add_in_row3;
output reg [POOL_ADDR_COL-1:0] pool_add_in_col4;
output reg [POOL_ADDR_ROW-1:0] pool_add_in_row4;

output reg [POOL_ADDR_ROW-1:0] pool_off_row;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        pool_add_in_col <= 0;
        pool_add_in_row <= 0;
        pool_add_in_col2 <= 0;
        pool_add_in_row2 <= 0;
        pool_add_in_col3 <= 0;
        pool_add_in_row3 <= 0;
        pool_add_in_col4 <= 0;
        pool_add_in_row4 <= 0;                       
        pool_off_row <= 0;
    end
    else
    begin
        if(pool_write_en)
        begin
            if( (pool_add_in_col4 == 0) && (pool_add_in_col == 0 ))
            begin
                pool_add_in_row <= 'd0;
                pool_add_in_col <= 'd0;
                pool_add_in_row2 <= 'd0;
                pool_add_in_col2 <= 'd1;
                pool_add_in_row3 <= 'd0;
                pool_add_in_col3 <= 'd2;
                pool_add_in_row4 <= 'd0;
                pool_add_in_col4 <= 'd3;
            end            
            else if( (pool_add_in_row == (POOL_SIZE_ROW-1)) && (pool_add_in_col4 == (POOL_SIZE_COL-1)) )
            begin
                pool_add_in_row <= 'd0;
                pool_add_in_col <= 'd0;
                pool_add_in_row2 <= 'd0;
                pool_add_in_col2 <= 'd0;
                pool_add_in_row3 <= 'd0;
                pool_add_in_col3 <= 'd0;
                pool_add_in_row4 <= 'd0;
                pool_add_in_col4 <= 'd0;                       
            end
            else if((pool_add_in_col4 == (POOL_SIZE_COL-1)))
            begin
                pool_add_in_row <= pool_add_in_row + 1'b1;
                pool_add_in_col <= 'd0;
                pool_add_in_row2 <= pool_add_in_row2 + 1'b1;
                pool_add_in_col2 <= 'd1;
                pool_add_in_row3 <= pool_add_in_row3 + 1'b1;
                pool_add_in_col3 <= 'd2;
                pool_add_in_row4 <= pool_add_in_row4 + 1'b1;
                pool_add_in_col4 <= 'd3;                       
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-2))
            begin 
                pool_add_in_col <= 'd6;
                pool_add_in_row2 <= pool_add_in_row2 + 1'b1;
                pool_add_in_col2 <= 'd0;
                pool_add_in_row3 <= pool_add_in_row3 + 1'b1;
                pool_add_in_col3 <= 'd1;
                pool_add_in_row4 <= pool_add_in_row4 + 1'b1;
                pool_add_in_col4 <= 'd2;                                              
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-3))
            begin
                pool_add_in_col <= 'd5;
                pool_add_in_col2 <= 'd6;
                pool_add_in_row3 <= pool_add_in_row3 + 1'b1;
                pool_add_in_col3 <= 'd0;
                pool_add_in_row4 <= pool_add_in_row4 + 1'b1;
                pool_add_in_col4 <= 'd1;                            
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-4))
            begin
                pool_add_in_col <= 'd4;
                pool_add_in_col2 <= 'd5;
                pool_add_in_col3 <= 'd6;
                pool_add_in_row4 <= pool_add_in_row4 + 1'b1;
                pool_add_in_col4 <= 'd0;
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-5))
            begin
                pool_add_in_row <= pool_add_in_row + 'd1;
                pool_add_in_col <= 'd3;
                pool_add_in_col2 <= pool_add_in_col2 + 'd4;
                pool_add_in_col3 <= pool_add_in_col3 + 'd4;
                pool_add_in_col4 <= pool_add_in_col4 + 'd4;
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-6))
            begin
                pool_add_in_row <= pool_add_in_row + 'd1;
                pool_add_in_col <= 'd2;
                pool_add_in_row2 <= pool_add_in_row2 + 'd1;
                pool_add_in_col2 <= 'd3;            
                pool_add_in_col3 <= pool_add_in_col3 + 'd4;
                pool_add_in_col4 <= pool_add_in_col4 + 'd4;
            end
            else if(pool_add_in_col4 == (POOL_SIZE_COL-7))
            begin
                pool_add_in_row <= pool_add_in_row + 'd1;
                pool_add_in_col <= 'd1;
                pool_add_in_row2 <= pool_add_in_row2 + 'd1;
                pool_add_in_col2 <= 'd2;
                pool_add_in_row3 <= pool_add_in_row3 + 'd1;
                pool_add_in_col3 <= 'd3; 
                pool_add_in_col4 <= pool_add_in_col4 + 'd4;
            end                                         
        end
        else if(pool_read_en)
        begin
            if( pool_off_row == (POOL_SIZE_ROW-1) )
            begin
                pool_off_row <= 0;
            end//off-row finish
            else
            begin
                pool_off_row <= pool_off_row + 1'b1;
            end//off-col finish
        end
        else
        begin
            pool_off_row <= 0;
        end
    end
end
endmodule