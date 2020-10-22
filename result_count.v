`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: result_count
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


module result_count(clk, reset, read_en, write_en, in_address, out_address );
input clk, reset;
input read_en;
input write_en;
output reg [3:0] in_address;
output reg [3:0] out_address;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        in_address <= 0;
        out_address <= 0;
    end
    else
    begin
        if(read_en)
        begin
            if(out_address == 13)
            begin
                out_address <= 0;
            end
            else
            begin
                out_address <= out_address + 1;
            end
        end
        else if(write_en)
        begin
            if(in_address == 13)
            begin
                in_address <= 0;
            end
            else
            begin
                in_address <= in_address + 1;
            end
        end
    end
end
endmodule