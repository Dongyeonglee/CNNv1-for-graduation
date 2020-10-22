`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: comparator
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


module comparator(data_in, clk, reset, start_sign, read_en, address, result, finish);
parameter DW = 8;
parameter OUT_DW = 4;
parameter MEM_ADDR = 4;
input signed [DW:0] data_in;
input clk, reset;
input start_sign;
input read_en;
input [MEM_ADDR-1:0] address;
output reg [OUT_DW-1:0] result;
output reg  finish;

reg [2:0] finish_cnt;
reg signed [DW:0] maxvalue;

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        maxvalue <= 0;
        result <= 0;
    end
    else
    begin
        if(read_en)
        begin
            if(data_in > maxvalue)
            begin
                maxvalue <= data_in;
                result <= address;
            end
            else
            begin
                maxvalue <= maxvalue;
                result <= result;
            end
        end
        else
        begin
            maxvalue <= 0;
            result <= result;
        end
    end
end

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        finish <= 1'b0;
    end
    else
    begin
        if(address == 13)
        begin
            finish <= 1'b1;
        end
        else if(start_sign)
        begin
            finish <= 1'b0;
        end
        else
            finish <= finish;
    end
end

endmodule