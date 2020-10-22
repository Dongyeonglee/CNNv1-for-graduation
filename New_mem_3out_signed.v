`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: New_mem_3out_signed
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


module New_mem_3out_signed(data_in, reset, clk, in_add_col, in_add_row, a_add_col, a_add_row, wr_en, rd_en, data_out_a, data_out_b, data_out_c, chiprd_en, chip_data_out );

parameter DW = 8;
parameter MEM_SIZE = 5;//memory size
parameter MEM_ADDR = 3;//memory address size
integer i;//just count
integer j;

input signed [DW-1:0] data_in;
input reset, clk;
input [MEM_ADDR-1:0] in_add_col;//for input addres
input [MEM_ADDR-1:0] in_add_row;
input [MEM_ADDR-1:0] a_add_col;//for output address
input [MEM_ADDR-1:0] a_add_row;
input wr_en;
input rd_en;
output reg [DW*3-1:0] data_out_a;//first line
output reg [DW*3-1:0] data_out_b;//second line
output reg [DW*3-1:0] data_out_c;//third line
reg signed [DW-1:0] mem[0:MEM_SIZE-1][0:MEM_SIZE-1];

input chiprd_en;
output reg signed [DW-1:0] chip_data_out;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<MEM_SIZE;i=i+1)
        begin
            for(j=0;j<MEM_SIZE;j=j+1)
                mem[i][j] <= 0;//reset all mem
        end        
    end
    else
    begin
        if(wr_en && (!rd_en))//make sure that write mode and read mode don't activate same time
        begin
            mem[in_add_row][in_add_col] <= data_in;
        end
    end
end

always @ (*)
begin
    if(rd_en)
    begin
        //make output data using 3 memory data. 3 -> 1
        data_out_a = (( a_add_row == 1 ) && ( a_add_col == 1 )) ? {mem[a_add_row-1][a_add_col-1],mem[a_add_row-1][a_add_col],mem[a_add_row-1][a_add_col+1]} : 0;
        data_out_b = (( a_add_row == 1 ) && ( a_add_col == 1 )) ? {mem[a_add_row][a_add_col-1],mem[a_add_row][a_add_col],mem[a_add_row][a_add_col+1]} : 0;
        data_out_c = (( a_add_row == 1 ) && ( a_add_col == 1 )) ? {mem[a_add_row+1][a_add_col-1],mem[a_add_row+1][a_add_col],mem[a_add_row+1][a_add_col+1]} : 0;
    end
    else
    begin
        data_out_a = 0;
        data_out_b = 0;
        data_out_c = 0;
    end
end

always @ (*)
begin
    if(chiprd_en)
    begin
        chip_data_out = ((in_add_row < 3) && (in_add_col < 3)) ? mem[in_add_row][in_add_col] : 0;
    end
    else
    begin
        chip_data_out = 0;
    end
end
endmodule