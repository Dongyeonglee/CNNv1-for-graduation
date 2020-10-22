`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 14:14:26
// Design Name: 
// Module Name: Mem
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


module Mem(
input clk,
input reset,
input rd_en,
input wr_en,
input [2:0] addr,
input [7:0] data_in,
output reg [7:0] data_out
);

integer i;

reg [7:0] mem [0:7];
always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<8;i=i+1)
        begin
            mem[i] <= 0;
        end
    end
    else
    begin
        if(wr_en && (!rd_en))
        begin
            mem[addr] <= data_in;
        end
    end
end
always @ (*)
begin
    if(rd_en)
    begin
        data_out = mem[addr];
    end
    else
    begin
        data_out = 0;
    end
end
endmodule
