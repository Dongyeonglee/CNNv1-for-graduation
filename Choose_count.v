`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Choose_count
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


module Choose_count(clk, reset, weight_num, pool_read_en );

input clk, reset;
input pool_read_en;
output reg [3:0] weight_num;
reg [4:0] cnt;
always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        weight_num <= 0;
        cnt <= 0;
    end
    else
    begin
        if(pool_read_en)
        begin
            if((weight_num == 9) && (cnt == 27))
            begin
                weight_num <= 0;
                cnt <= 0;
            end
            else if(cnt == 27)
            begin
                weight_num <= weight_num +1;
                cnt <=0;
            end
            else
            begin
                cnt <= cnt + 1;
            end
        end
        else
        begin
            weight_num <= 0;
            cnt <= 0;
        end
    end
end
endmodule