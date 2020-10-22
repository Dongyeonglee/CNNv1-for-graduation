`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: New_mem_1d1out
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


module New_mem_1d1out(data_in, clk, reset, write_en, read_en, chiprd_en, in_address, out_address, data_out, result_out);

parameter DW = 8;
parameter OUT_DW = DW;
parameter MEM_SIZE = 14;//memory size
parameter MEM_ADDR = 4;//memory address size
integer i;

input signed [DW:0] data_in;
input clk, reset;
input write_en;
input read_en;
input chiprd_en;
input [MEM_ADDR-1:0] in_address;
input [MEM_ADDR-1:0] out_address;
output reg signed [OUT_DW:0] data_out;
output reg [(OUT_DW+1)*MEM_SIZE-1:0] result_out;//signed로 되어있었음
reg signed [DW:0] mem [0:MEM_SIZE-1];

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<14;i=i+1)
        begin
            mem[i] <= 0;
        end
    end
    else
    begin
        if(write_en)
        begin
            mem[in_address] <= data_in;
        end
    end
end

always @ (*)
begin
    if(read_en)
    begin
        data_out = (out_address < 14) ? mem[out_address] : 0;
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
        result_out = { mem[0],mem[1],mem[2],mem[3],mem[4],mem[5],mem[6],mem[7],mem[8],mem[9],mem[10],mem[11],mem[12],mem[13] };
    end
    else
    begin
        result_out = 0;
    end
end
endmodule