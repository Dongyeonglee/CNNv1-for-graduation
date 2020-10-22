`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:28:24
// Design Name: 
// Module Name: fully_count
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


module fully_count(reset, clk, fully_en, in_addr, reset_signal );

input reset, clk;
input fully_en;
output reg [3:0] in_addr;
//output reg [3:0] out_addr;
output reg reset_signal;
reg [5:0] count;

reg [3:0] delay;//make delay fully's input address 

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        in_addr <= 0;
        delay <= 0;
        reset_signal <= 0;
        count <= 0;
    end
    else
    begin
        in_addr <= delay;
        if(fully_en)
        begin
            if((delay == 9) && (count == 27))
            begin
                reset_signal <= 1;
                delay <= 0;
                count <= 0;
            end
            else if(count == 27)
            begin
                reset_signal <= 1;
                delay <= delay +1;
                count <=0;
            end
            else
            begin
                reset_signal <= 0;
                count <= count + 1;
            end
        end
        else
        begin
            reset_signal <= 0;
        end
    end
end
endmodule
