`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:28:24
// Design Name: 
// Module Name: Pooling
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


module Pooling(data_in_a, data_in_b, data_in_c, data_in_d, data_out );

parameter DW = 8; //bit of out pixel
parameter IN_DW = DW * 4;

input [IN_DW-1:0] data_in_a; //get four datas
input [IN_DW-1:0] data_in_b;
input [IN_DW-1:0] data_in_c;
input [IN_DW-1:0] data_in_d;
//input clk, reset;
output [DW-1:0] data_out;

wire [DW-1:0] data [0:15];

wire [DW-1:0] max1;
wire [DW-1:0] max2;
wire [DW-1:0] max3;
wire [DW-1:0] max4;
wire [DW-1:0] max5;
wire [DW-1:0] max6;
wire [DW-1:0] max7;
wire [DW-1:0] max8;
wire [DW-1:0] max2_1;
wire [DW-1:0] max2_2;
wire [DW-1:0] max2_3;
wire [DW-1:0] max2_4;
wire [DW-1:0] max3_1;
wire [DW-1:0] max3_2;
wire [DW-1:0] finalmax;

assign data[0] = { data_in_a[DW*4-1:DW*3] };
assign data[1] = { data_in_a[DW*3-1:DW*2] };
assign data[2] = { data_in_a[DW*2-1:DW] };
assign data[3] = { data_in_a[DW-1:0] };
assign data[4] = { data_in_b[DW*4-1:DW*3] };
assign data[5] = { data_in_b[DW*3-1:DW*2] };
assign data[6] = { data_in_b[DW*2-1:DW] };
assign data[7] = { data_in_b[DW-1:0] };
assign data[8] = { data_in_c[DW*4-1:DW*3] };
assign data[9] = { data_in_c[DW*3-1:DW*2] };
assign data[10] = { data_in_c[DW*2-1:DW] };
assign data[11] = { data_in_c[DW-1:0] };
assign data[12] = { data_in_d[DW*4-1:DW*3] };
assign data[13] = { data_in_d[DW*3-1:DW*2] };
assign data[14] = { data_in_d[DW*2-1:DW] };
assign data[15] = { data_in_d[DW-1:0] };

//compare 2 values 8 -> 4
assign max1 = data[0] > data[1] ? data[0] : data[1];
assign max2 = data[2] > data[3] ? data[2] : data[3];
assign max3 = data[4] > data[5] ? data[4] : data[5];
assign max4 = data[6] > data[7] ? data[6] : data[7];
assign max5 = data[8] > data[9] ? data[8] : data[9];
assign max6 = data[10] > data[11] ? data[10] : data[11];
assign max7 = data[12] > data[13] ? data[12] : data[13];
assign max8 = data[14] > data[15] ? data[14] : data[15];
//compare 2 values 4 -> 2
assign max2_1 = max1 > max2 ? max1 : max2;
assign max2_2 = max3 > max4 ? max3 : max4;
assign max2_3 = max5 > max6 ? max5 : max6;
assign max2_4 = max7 > max8 ? max7 : max8;
//compare 2 values 2 -> 1
assign max3_1 = max2_1 > max2_2 ? max2_1 : max2_2;
assign max3_2 = max2_3 > max2_4 ? max2_3 : max2_4;
assign finalmax = max3_1 > max3_2 ? max3_1 : max3_2;
//output last value
assign data_out = finalmax;
endmodule
