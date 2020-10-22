`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:28:24
// Design Name: 
// Module Name: New_mem_1d2
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


module New_mem_1d2(data_in, reset, clk, in_add, wr_en, rd_en, data_out, chip_add, chiprd_en, chip_data_out );

parameter DW = 16;
parameter MEM_SIZE = 10;//memory size
parameter MEM_ADDR = 4;//memory address size
integer i;//just count

input [DW-1:0] data_in;
input reset, clk;
input [MEM_ADDR-1:0] in_add;//for input addres
input wr_en;
input rd_en;
output reg [MEM_SIZE*DW-1:0] data_out;//first line
reg [DW-1:0] mem [0:MEM_SIZE-1];

input [MEM_ADDR-1:0] chip_add;
input chiprd_en;
output reg [DW-1:0] chip_data_out;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<MEM_SIZE;i=i+1) begin
            mem[i] <= 0;//reset all mem
        end
    end
    else
    begin
        if(wr_en && (!rd_en))//make sure that write mode and read mode don't activate same time
        begin
            mem[in_add] <= data_in;
        end
    end
end

always @ (*)
begin
    if(rd_en)
    begin
        //make output data using 1 memory data. 10 -> 1
        data_out = {mem[0],mem[1],mem[2],mem[3],mem[4],mem[5],mem[6],mem[7],mem[8],mem[9]};
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
        chip_data_out = (chip_add < 10) ? mem[chip_add] : 0;
    end
    else
    begin
        chip_data_out = 0;
    end
end
endmodule
