`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Choose2_count
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


module Choose2_count(clk, reset, rd_en, weight_cnt );

parameter MEM_SIZE = 10;//memory size
parameter MEM_ADDR = 4;//memory address size
parameter OUTPUT_NUM = 14;

input clk, reset;
input rd_en;

output reg [MEM_ADDR-1:0] weight_cnt;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        weight_cnt <= 0;
    end
    else
    begin
        if(rd_en)
        begin
            if( weight_cnt == (OUTPUT_NUM-1) )
            begin
                weight_cnt <= 'b0;
            end
            else 
               weight_cnt <= weight_cnt + 1'b1;
        end
    end   
end
endmodule