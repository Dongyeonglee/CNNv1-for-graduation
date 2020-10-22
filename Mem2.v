`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 15:00:02
// Design Name: 
// Module Name: Mem2
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


module Mem2(
input clk,
input reset,
input rd_en,
input wr_en,
input [2:0] addr,
input [2:0] addr1,
input [7:0] data_in,
output reg [7:0] data_out
);

integer i;
integer j;

reg [7:0] mem [0:3][0:3];
always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        for(i=0;i<4;i=i+1)
        begin
            for(j=0;j<4;j=j+1)
            begin
                mem[i][j] <= 0;
            end
        end
    end
    else
    begin
        if(wr_en && (!rd_en))
        begin
            mem[addr][addr1] <= data_in;
        end
    end
end
always @ (*)
begin
    if(rd_en)
    begin
        data_out = ((addr < 4) && (addr1 < 4)) ? mem[addr][addr1] : 0;
    end
    else
    begin
        data_out = 0;
    end
end
endmodule
