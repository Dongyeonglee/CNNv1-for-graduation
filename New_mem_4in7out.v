`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: New_mem_4in7out
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


module New_mem_4in7out( data_in1, data_in2, data_in3, data_in4, reset, clk, wr_en, rd_en,
in_add_col1 ,in_add_row1, in_add_col2,in_add_row2, in_add_col3,in_add_row3, in_add_col4,in_add_row4, out_add_col, out_add_row, data_out,
chip_add_row, chip_add_col, chiprd_en, chip_data_out );

parameter DW = 8;
parameter OUT_DW = DW;//output data width
parameter MEM_SIZE_COL = 7;//memory size
parameter MEM_SIZE_ROW = 28;//memory size
parameter MEM_ADDR_COL = 3;//memory address size
parameter MEM_ADDR_ROW = 5;//memory address size
integer i;//just count
integer j;

input [DW-1:0] data_in1;//signed로 되어있었음
input [DW-1:0] data_in2;//signed로 되어있었음
input [DW-1:0] data_in3;//signed로 되어있었음
input [DW-1:0] data_in4;//signed로 되어있었음
input reset, clk;
input wr_en;
input rd_en;
input [MEM_ADDR_COL-1:0] in_add_col1;//for input addres
input [MEM_ADDR_ROW-1:0] in_add_row1;
input [MEM_ADDR_COL-1:0] in_add_col2;//for input addres
input [MEM_ADDR_ROW-1:0] in_add_row2;
input [MEM_ADDR_COL-1:0] in_add_col3;//for input addres
input [MEM_ADDR_ROW-1:0] in_add_row3;
input [MEM_ADDR_COL-1:0] in_add_col4;//for input addres
input [MEM_ADDR_ROW-1:0] in_add_row4;

input [MEM_ADDR_COL-1:0] out_add_col;//for output address
input [MEM_ADDR_ROW-1:0] out_add_row;
output reg [7*OUT_DW-1:0] data_out;

reg [DW-1:0] mem[0:MEM_SIZE_ROW-1][0:MEM_SIZE_COL-1];//signed 없었음

input [MEM_ADDR_ROW-1:0] chip_add_row;
input [MEM_ADDR_COL-1:0] chip_add_col;
input chiprd_en;
output reg [DW-1:0] chip_data_out;//signed 없었음

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<MEM_SIZE_ROW;i=i+1)
        begin
            for(j=0;j<MEM_SIZE_COL;j=j+1)
                mem[i][j] <= 0;//reset all mem
        end        
    end
    else
    begin
        if(wr_en && (!rd_en))//make sure that write mode and read mode don't activate same time
        begin
            mem[in_add_row1][in_add_col1] <= data_in1;
            mem[in_add_row2][in_add_col2] <= data_in2;
            mem[in_add_row3][in_add_col3] <= data_in3;
            mem[in_add_row4][in_add_col4] <= data_in4;
        end
    end
end

always @ (*)
begin
    if(rd_en)
    begin
        //make output data
        data_out = ((out_add_row < 28) && (out_add_col == 0)) ? {mem[out_add_row][out_add_col], mem[out_add_row][out_add_col+1], mem[out_add_row][out_add_col+2], mem[out_add_row][out_add_col+3], mem[out_add_row][out_add_col+4], mem[out_add_row][out_add_col+5], mem[out_add_row][out_add_col+6]} : 0;
    end
    else
    begin
        data_out = 0;
    end
end
always @ (*)
begin
    if(chiprd_en)
    begin
        chip_data_out = ((chip_add_row < 28) && (chip_add_col < 7)) ? mem[chip_add_row][chip_add_col] : 0;
    end
    else
    begin
        chip_data_out = 0;
    end
end
endmodule