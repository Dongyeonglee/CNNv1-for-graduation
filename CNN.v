`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: CNN
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


module CNN(
// enable
clk, reset,
start_sign, finish_sign, im_write_en,
fi_write_en1,fi_write_en2,fi_write_en3,fi_write_en4,

weight1_write_en1,weight1_write_en2,weight1_write_en3,weight1_write_en4,weight1_write_en5,
weight1_write_en6,weight1_write_en7,weight1_write_en8,weight1_write_en9,weight1_write_en10,

weight2_write_en1,weight2_write_en2,weight2_write_en3,weight2_write_en4,weight2_write_en5,weight2_write_en6,weight2_write_en7,
weight2_write_en8,weight2_write_en9,weight2_write_en10,weight2_write_en11,weight2_write_en12,weight2_write_en13,weight2_write_en14,

// input data
image_data_in, filter_data_in1, filter_data_in2, filter_data_in3, filter_data_in4,
weight1_data_in0, weight1_data_in1, weight1_data_in2, weight1_data_in3, weight1_data_in4, weight1_data_in5,
weight1_data_in6, weight1_data_in7, weight1_data_in8, weight1_data_in9,

weight2_data_in0,weight2_data_in1,weight2_data_in2,weight2_data_in3,weight2_data_in4,
weight2_data_in5,weight2_data_in6,weight2_data_in7,weight2_data_in8,weight2_data_in9,
weight2_data_in10,weight2_data_in11,weight2_data_in12,weight2_data_in13,

// output data
data_out, result_out0, result_out1, result_out2, result_out3,
result_out4, result_out5, result_out6, result_out7, result_out8,
result_out9, result_out10, result_out11, result_out12, result_out13,

// address
im_add_in_col,im_add_in_row,
fi_add_in_col1,fi_add_in_row1,fi_add_in_col2,fi_add_in_row2,fi_add_in_col3,fi_add_in_row3,fi_add_in_col4,fi_add_in_row4,

weight1_add_in_col1, weight1_add_in_row1, weight1_add_in_col2, weight1_add_in_row2, weight1_add_in_col3, weight1_add_in_row3, weight1_add_in_col4, weight1_add_in_row4,
weight1_add_in_col5, weight1_add_in_row5, weight1_add_in_col6, weight1_add_in_row6, weight1_add_in_col7, weight1_add_in_row7, weight1_add_in_col8, weight1_add_in_row8,
weight1_add_in_col9, weight1_add_in_row9, weight1_add_in_col10, weight1_add_in_row10,

weight2_add_in1, weight2_add_in2, weight2_add_in3, weight2_add_in4, weight2_add_in5, weight2_add_in6, weight2_add_in7,
weight2_add_in8, weight2_add_in9, weight2_add_in10, weight2_add_in11, weight2_add_in12, weight2_add_in13, weight2_add_in14,
///////////////////////////////////////////////////////////////////////////////////////////////////////////
con_add_row1 ,con_add_col1, con_add_row2, con_add_col2, con_add_row3, con_add_col3, con_add_row4, con_add_col4,

inp_add_row ,inp_add_col, hid_add,

ima_rd_en, fil_rd_en1, fil_rd_en2, fil_rd_en3, fil_rd_en4,
wei1_rd_en1, wei1_rd_en2, wei1_rd_en3, wei1_rd_en4, wei1_rd_en5, wei1_rd_en6, wei1_rd_en7, wei1_rd_en8, wei1_rd_en9, wei1_rd_en10,
wei2_rd_en1, wei2_rd_en2, wei2_rd_en3, wei2_rd_en4, wei2_rd_en5, wei2_rd_en6, wei2_rd_en7,
wei2_rd_en8, wei2_rd_en9, wei2_rd_en10, wei2_rd_en11, wei2_rd_en12, wei2_rd_en13, wei2_rd_en14,
con_rd_en1, con_rd_en2, con_rd_en3, con_rd_en4, inp_rd_en, hid_rd_en, res_rd_en,

ima_out_data, fil_out_data1, fil_out_data2, fil_out_data3, fil_out_data4,
con_out_data1, con_out_data2, con_out_data3, con_out_data4,
wei1_out_data1, wei1_out_data2, wei1_out_data3, wei1_out_data4, wei1_out_data5, wei1_out_data6, wei1_out_data7, wei1_out_data8, wei1_out_data9, wei1_out_data10,
wei2_out_data1, wei2_out_data2, wei2_out_data3, wei2_out_data4, wei2_out_data5, wei2_out_data6, wei2_out_data7,
wei2_out_data8, wei2_out_data9, wei2_out_data10, wei2_out_data11, wei2_out_data12, wei2_out_data13, wei2_out_data14,
inp_out_data, hid_out_data
);

parameter DW = 8; //bit of pixel
parameter OUT_DW = 4;//bit of out pixel//4
parameter IMA_SIZE = 28; //image memory x X x
parameter IMA_ADDR = 5;
parameter FIL_SIZE = 3; //filter memory y X y//FIL
parameter FIL_ADDR = 2;
parameter CON_SIZE = 28; //conved memory y X y
parameter CON_ADDR = 5;
parameter POOL_SIZE_COL = 7;//input
parameter POOL_SIZE_ROW = 28;
parameter POOL_ADDR_COL = 3;
parameter POOL_ADDR_ROW = 5;
parameter HID_SIZE = 10;//memory size//Hid
parameter HID_ADDR = 4;//memory address size
parameter RES_SIZE = 14;//RES
parameter RES_ADDR = 4;
genvar i;

////////////////////////////////////////input data
//image and weight data input
input [DW-1:0] image_data_in; //image data
input signed [DW-1:0] filter_data_in1; //filter 1 data
input signed [DW-1:0] filter_data_in2; //filter 2 data
input signed [DW-1:0] filter_data_in3; //filter 3 data
input signed [DW-1:0] filter_data_in4; //filter 4 data
//weight input 
input signed [DW-1:0] weight1_data_in0;
input signed [DW-1:0] weight1_data_in1;
input signed [DW-1:0] weight1_data_in2;
input signed [DW-1:0] weight1_data_in3;
input signed [DW-1:0] weight1_data_in4;
input signed [DW-1:0] weight1_data_in5;
input signed [DW-1:0] weight1_data_in6;
input signed [DW-1:0] weight1_data_in7;
input signed [DW-1:0] weight1_data_in8;
input signed [DW-1:0] weight1_data_in9;
//weight2 input 
input signed [DW-1:0] weight2_data_in0;
input signed [DW-1:0] weight2_data_in1;
input signed [DW-1:0] weight2_data_in2;
input signed [DW-1:0] weight2_data_in3;
input signed [DW-1:0] weight2_data_in4;
input signed [DW-1:0] weight2_data_in5;
input signed [DW-1:0] weight2_data_in6;
input signed [DW-1:0] weight2_data_in7;
input signed [DW-1:0] weight2_data_in8;
input signed [DW-1:0] weight2_data_in9;
input signed [DW-1:0] weight2_data_in10;
input signed [DW-1:0] weight2_data_in11;
input signed [DW-1:0] weight2_data_in12;
input signed [DW-1:0] weight2_data_in13;

////////////////////////////////////////input data wire
//filter data
wire signed [DW-1:0] filter_data_in[0:3];
assign filter_data_in[0] = filter_data_in1;
assign filter_data_in[1] = filter_data_in2;
assign filter_data_in[2] = filter_data_in3;
assign filter_data_in[3] = filter_data_in4;
//weight input 
wire signed [DW-1:0] weight1_data_in[0:9];
assign weight1_data_in[0] = weight1_data_in0;
assign weight1_data_in[1] = weight1_data_in1;
assign weight1_data_in[2] = weight1_data_in2;
assign weight1_data_in[3] = weight1_data_in3;
assign weight1_data_in[4] = weight1_data_in4;
assign weight1_data_in[5] = weight1_data_in5;
assign weight1_data_in[6] = weight1_data_in6;
assign weight1_data_in[7] = weight1_data_in7;
assign weight1_data_in[8] = weight1_data_in8;
assign weight1_data_in[9] = weight1_data_in9;
//weight2 input 
wire signed [DW-1:0] weight2_data_in[0:13];
assign weight2_data_in[0] = weight2_data_in0;
assign weight2_data_in[1] = weight2_data_in1;
assign weight2_data_in[2] = weight2_data_in2;
assign weight2_data_in[3] = weight2_data_in3;
assign weight2_data_in[4] = weight2_data_in4;
assign weight2_data_in[5] = weight2_data_in5;
assign weight2_data_in[6] = weight2_data_in6;
assign weight2_data_in[7] = weight2_data_in7;
assign weight2_data_in[8] = weight2_data_in8;
assign weight2_data_in[9] = weight2_data_in9;
assign weight2_data_in[10] = weight2_data_in10;
assign weight2_data_in[11] = weight2_data_in11;
assign weight2_data_in[12] = weight2_data_in12;
assign weight2_data_in[13] = weight2_data_in13;

//////////////////////////////////////// signal
input clk, reset;
input start_sign;
output wire finish_sign;

input im_write_en; //image memory write en
input fi_write_en1; //filter memory write en
input fi_write_en2; //filter memory write en
input fi_write_en3; //filter memory write en
input fi_write_en4; //filter memory write en

input weight1_write_en1; //weight memory write en
input weight1_write_en2; //weight memory write en
input weight1_write_en3; //weight memory write en
input weight1_write_en4; //weight memory write en
input weight1_write_en5; //weight memory write en
input weight1_write_en6; //weight memory write en
input weight1_write_en7; //weight memory write en
input weight1_write_en8; //weight memory write en
input weight1_write_en9; //weight memory write en
input weight1_write_en10; //weight memory write en

input weight2_write_en1; //weight memory2 write en
input weight2_write_en2; //weight memory2 write en
input weight2_write_en3; //weight memory2 write en
input weight2_write_en4; //weight memory2 write en
input weight2_write_en5; //weight memory2 write en
input weight2_write_en6; //weight memory2 write en
input weight2_write_en7; //weight memory2 write en
input weight2_write_en8; //weight memory2 write en
input weight2_write_en9; //weight memory2 write en
input weight2_write_en10; //weight memory2 write en
input weight2_write_en11; //weight memory2 write en
input weight2_write_en12; //weight memory2 write en
input weight2_write_en13; //weight memory2 write en
input weight2_write_en14; //weight memory2 write en
wire cv_write_en; //after convolution data's memory write en
wire input_write_en; //after input layer's memory write en
wire result_write_en; //result layer write en
wire read_en; //image and filter read en
wire cv_read_en; //after convolution data's memory read en
wire input_read_en; //after pooling data's memory read en
wire hidden_read_en; //hidden layer's read en
wire fully_en; //in fully connected layer for counting reset 
wire result_read_en; //result layer read en
reg chip_en;

//////////////////////////////////////// signal wire
//filter enable
wire fi_write_en[0:3];
assign fi_write_en[0] = fi_write_en1;
assign fi_write_en[1] = fi_write_en2;
assign fi_write_en[2] = fi_write_en3;
assign fi_write_en[3] = fi_write_en4;
//weight enable
wire weight1_write_en [0:9];
assign weight1_write_en[0] = weight1_write_en1;
assign weight1_write_en[1] = weight1_write_en2;
assign weight1_write_en[2] = weight1_write_en3;
assign weight1_write_en[3] = weight1_write_en4;
assign weight1_write_en[4] = weight1_write_en5;
assign weight1_write_en[5] = weight1_write_en6;
assign weight1_write_en[6] = weight1_write_en7;
assign weight1_write_en[7] = weight1_write_en8;
assign weight1_write_en[8] = weight1_write_en9;
assign weight1_write_en[9] = weight1_write_en10;
//weight2 enable 
wire weight2_write_en [0:13];
assign weight2_write_en[0] = weight2_write_en1;
assign weight2_write_en[1] = weight2_write_en2;
assign weight2_write_en[2] = weight2_write_en3;
assign weight2_write_en[3] = weight2_write_en4;
assign weight2_write_en[4] = weight2_write_en5;
assign weight2_write_en[5] = weight2_write_en6;
assign weight2_write_en[6] = weight2_write_en7;
assign weight2_write_en[7] = weight2_write_en8;
assign weight2_write_en[8] = weight2_write_en9;
assign weight2_write_en[9] = weight2_write_en10;
assign weight2_write_en[10] = weight2_write_en11;
assign weight2_write_en[11] = weight2_write_en12;
assign weight2_write_en[12] = weight2_write_en13;
assign weight2_write_en[13] = weight2_write_en14;

////////////////////////////////address

input [IMA_ADDR-1:0] im_add_in_col; //input address for image
input [IMA_ADDR-1:0] im_add_in_row; //input address for image
wire [IMA_ADDR-1:0] im_off_col; //output address for image
wire [IMA_ADDR-1:0] im_off_row; //output address for image
input [FIL_ADDR-1:0] fi_add_in_col1; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_row1; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_col2; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_row2; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_col3; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_row3; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_col4; //input address for filter
input [FIL_ADDR-1:0] fi_add_in_row4; //input address for filter
wire [FIL_ADDR-1:0] fi_off_col; //output address for filter
wire [FIL_ADDR-1:0] fi_off_row; //output address for filter

input [POOL_ADDR_COL-1:0] weight1_add_in_col1; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row1; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col2; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row2; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col3; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row3; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col4; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row4; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col5; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row5; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col6; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row6; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col7; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row7; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col8; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row8; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col9; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row9; //input layer's input address
input [POOL_ADDR_COL-1:0] weight1_add_in_col10; //input layer's input address
input [POOL_ADDR_ROW-1:0] weight1_add_in_row10; //input layer's input address

wire [POOL_ADDR_COL-1:0] weight1_off_col; //input layer's output address
wire [POOL_ADDR_ROW-1:0] weight1_off_row; //input layer's output address

input [HID_ADDR-1:0] weight2_add_in1;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in2;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in3;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in4;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in5;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in6;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in7;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in8;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in9;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in10;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in11;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in12;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in13;//weight2 memory's input address
input [HID_ADDR-1:0] weight2_add_in14;//weight2 memory's input address
//////////////////////////////////////////////////////////////////////////////////////////////////////////
input [CON_ADDR-1:0] con_add_row1;
input [CON_ADDR-1:0] con_add_col1;
input [CON_ADDR-1:0] con_add_row2;
input [CON_ADDR-1:0] con_add_col2;
input [CON_ADDR-1:0] con_add_row3;
input [CON_ADDR-1:0] con_add_col3;
input [CON_ADDR-1:0] con_add_row4;
input [CON_ADDR-1:0] con_add_col4;

input [POOL_ADDR_ROW-1:0] inp_add_row;
input [POOL_ADDR_COL-1:0] inp_add_col;
input [HID_ADDR-1:0] hid_add;

input ima_rd_en;
input fil_rd_en1;
input fil_rd_en2;
input fil_rd_en3;
input fil_rd_en4;
input wei1_rd_en1;
input wei1_rd_en2;
input wei1_rd_en3;
input wei1_rd_en4;
input wei1_rd_en5;
input wei1_rd_en6;
input wei1_rd_en7;
input wei1_rd_en8;
input wei1_rd_en9;
input wei1_rd_en10;
input wei2_rd_en1;
input wei2_rd_en2;
input wei2_rd_en3;
input wei2_rd_en4;
input wei2_rd_en5;
input wei2_rd_en6;
input wei2_rd_en7;
input wei2_rd_en8;
input wei2_rd_en9;
input wei2_rd_en10;
input wei2_rd_en11;
input wei2_rd_en12;
input wei2_rd_en13;
input wei2_rd_en14;
input con_rd_en1;
input con_rd_en2;
input con_rd_en3;
input con_rd_en4;
input inp_rd_en;
input hid_rd_en;
input res_rd_en;

output [DW-1:0] ima_out_data;
output signed [DW-1:0] fil_out_data1;
output signed [DW-1:0] fil_out_data2;
output signed [DW-1:0] fil_out_data3;
output signed [DW-1:0] fil_out_data4;
output [DW-1:0] con_out_data1;
output [DW-1:0] con_out_data2;
output [DW-1:0] con_out_data3;
output [DW-1:0] con_out_data4;
output signed [DW-1:0] wei1_out_data1;
output signed [DW-1:0] wei1_out_data2;
output signed [DW-1:0] wei1_out_data3;
output signed [DW-1:0] wei1_out_data4;
output signed [DW-1:0] wei1_out_data5;
output signed [DW-1:0] wei1_out_data6;
output signed [DW-1:0] wei1_out_data7;
output signed [DW-1:0] wei1_out_data8;
output signed [DW-1:0] wei1_out_data9;
output signed [DW-1:0] wei1_out_data10;
output signed [DW-1:0] wei2_out_data1;
output signed [DW-1:0] wei2_out_data2;
output signed [DW-1:0] wei2_out_data3;
output signed [DW-1:0] wei2_out_data4;
output signed [DW-1:0] wei2_out_data5;
output signed [DW-1:0] wei2_out_data6;
output signed [DW-1:0] wei2_out_data7;
output signed [DW-1:0] wei2_out_data8;
output signed [DW-1:0] wei2_out_data9;
output signed [DW-1:0] wei2_out_data10;
output signed [DW-1:0] wei2_out_data11;
output signed [DW-1:0] wei2_out_data12;
output signed [DW-1:0] wei2_out_data13;
output signed [DW-1:0] wei2_out_data14;
output [DW-1:0] inp_out_data;
output [DW-1:0] hid_out_data;

wire signed [DW-1:0] fil_out_data[0:3];
assign fil_out_data1 = fil_out_data[0];
assign fil_out_data2 = fil_out_data[1];
assign fil_out_data3 = fil_out_data[2];
assign fil_out_data4 = fil_out_data[3];
wire fil_rd_en[0:3];
assign fil_rd_en[0] = fil_rd_en1;
assign fil_rd_en[1] = fil_rd_en2;
assign fil_rd_en[2] = fil_rd_en3;
assign fil_rd_en[3] = fil_rd_en4;

wire signed [DW-1:0] wei1_out_data[0:9];
assign wei1_out_data1 = wei1_out_data[0];
assign wei1_out_data2 = wei1_out_data[1];
assign wei1_out_data3 = wei1_out_data[2];
assign wei1_out_data4 = wei1_out_data[3];
assign wei1_out_data5 = wei1_out_data[4];
assign wei1_out_data6 = wei1_out_data[5];
assign wei1_out_data7 = wei1_out_data[6];
assign wei1_out_data8 = wei1_out_data[7];
assign wei1_out_data9 = wei1_out_data[8];
assign wei1_out_data10 = wei1_out_data[9];
wire wei1_rd_en[0:9];
assign wei1_rd_en[0] = wei1_rd_en1;
assign wei1_rd_en[1] = wei1_rd_en2;
assign wei1_rd_en[2] = wei1_rd_en3;
assign wei1_rd_en[3] = wei1_rd_en4;
assign wei1_rd_en[4] = wei1_rd_en5;
assign wei1_rd_en[5] = wei1_rd_en6;
assign wei1_rd_en[6] = wei1_rd_en7;
assign wei1_rd_en[7] = wei1_rd_en8;
assign wei1_rd_en[8] = wei1_rd_en9;
assign wei1_rd_en[9] = wei1_rd_en10;

wire signed [DW-1:0] wei2_out_data[0:13];
assign wei2_out_data1 = wei2_out_data[0];
assign wei2_out_data2 = wei2_out_data[1];
assign wei2_out_data3 = wei2_out_data[2];
assign wei2_out_data4 = wei2_out_data[3];
assign wei2_out_data5 = wei2_out_data[4];
assign wei2_out_data6 = wei2_out_data[5];
assign wei2_out_data7 = wei2_out_data[6];
assign wei2_out_data8 = wei2_out_data[7];
assign wei2_out_data9 = wei2_out_data[8];
assign wei2_out_data10 = wei2_out_data[9];
assign wei2_out_data11 = wei2_out_data[10];
assign wei2_out_data12 = wei2_out_data[11];
assign wei2_out_data13 = wei2_out_data[12];
assign wei2_out_data14 = wei2_out_data[13];
wire wei2_rd_en[0:13];
assign wei2_rd_en[0] = wei2_rd_en1;
assign wei2_rd_en[1] = wei2_rd_en2;
assign wei2_rd_en[2] = wei2_rd_en3;
assign wei2_rd_en[3] = wei2_rd_en4;
assign wei2_rd_en[4] = wei2_rd_en5;
assign wei2_rd_en[5] = wei2_rd_en6;
assign wei2_rd_en[6] = wei2_rd_en7;
assign wei2_rd_en[7] = wei2_rd_en8;
assign wei2_rd_en[8] = wei2_rd_en9;
assign wei2_rd_en[9] = wei2_rd_en10;
assign wei2_rd_en[10] = wei2_rd_en11;
assign wei2_rd_en[11] = wei2_rd_en12;
assign wei2_rd_en[12] = wei2_rd_en13;
assign wei2_rd_en[13] = wei2_rd_en14;

wire [DW-1:0] con_out_data[0:3];
assign con_out_data1 = con_out_data[0];
assign con_out_data2 = con_out_data[1];
assign con_out_data3 = con_out_data[2];
assign con_out_data4 = con_out_data[3];
wire con_rd_en[0:3];
assign con_rd_en[0] = con_rd_en1;
assign con_rd_en[1] = con_rd_en2;
assign con_rd_en[2] = con_rd_en3;
assign con_rd_en[3] = con_rd_en4;
wire [CON_ADDR-1:0] con_add_row[0:3];
assign con_add_row[0] = con_add_row1;
assign con_add_row[1] = con_add_row2;
assign con_add_row[2] = con_add_row3;
assign con_add_row[3] = con_add_row4;
wire [CON_ADDR-1:0] con_add_col[0:3];
assign con_add_col[0] = con_add_col1;
assign con_add_col[1] = con_add_col2;
assign con_add_col[2] = con_add_col3;
assign con_add_col[3] = con_add_col4;

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// signal wire
//filter enable
wire [FIL_ADDR-1:0] fi_add_in_col[0:3];
assign fi_add_in_col[0] = fi_add_in_col1;
assign fi_add_in_col[1] = fi_add_in_col2;
assign fi_add_in_col[2] = fi_add_in_col3;
assign fi_add_in_col[3] = fi_add_in_col4;

wire [FIL_ADDR-1:0] fi_add_in_row[0:3];
assign fi_add_in_row[0] = fi_add_in_row1;
assign fi_add_in_row[1] = fi_add_in_row2;
assign fi_add_in_row[2] = fi_add_in_row3;
assign fi_add_in_row[3] = fi_add_in_row4;

//weight enable
wire [POOL_ADDR_COL-1:0] weight1_add_in_col [0:9];
assign weight1_add_in_col[0] = weight1_add_in_col1;
assign weight1_add_in_col[1] = weight1_add_in_col2;
assign weight1_add_in_col[2] = weight1_add_in_col3;
assign weight1_add_in_col[3] = weight1_add_in_col4;
assign weight1_add_in_col[4] = weight1_add_in_col5;
assign weight1_add_in_col[5] = weight1_add_in_col6;
assign weight1_add_in_col[6] = weight1_add_in_col7;
assign weight1_add_in_col[7] = weight1_add_in_col8;
assign weight1_add_in_col[8] = weight1_add_in_col9;
assign weight1_add_in_col[9] = weight1_add_in_col10;

wire [POOL_ADDR_ROW-1:0] weight1_add_in_row [0:9];
assign weight1_add_in_row[0] = weight1_add_in_row1;
assign weight1_add_in_row[1] = weight1_add_in_row2;
assign weight1_add_in_row[2] = weight1_add_in_row3;
assign weight1_add_in_row[3] = weight1_add_in_row4;
assign weight1_add_in_row[4] = weight1_add_in_row5;
assign weight1_add_in_row[5] = weight1_add_in_row6;
assign weight1_add_in_row[6] = weight1_add_in_row7;
assign weight1_add_in_row[7] = weight1_add_in_row8;
assign weight1_add_in_row[8] = weight1_add_in_row9;
assign weight1_add_in_row[9] = weight1_add_in_row10;

//weight2 enable 
wire [HID_ADDR-1:0] weight2_add_in [0:13];
assign weight2_add_in[0] = weight2_add_in1;
assign weight2_add_in[1] = weight2_add_in2;
assign weight2_add_in[2] = weight2_add_in3;
assign weight2_add_in[3] = weight2_add_in4;
assign weight2_add_in[4] = weight2_add_in5;
assign weight2_add_in[5] = weight2_add_in6;
assign weight2_add_in[6] = weight2_add_in7;
assign weight2_add_in[7] = weight2_add_in8;
assign weight2_add_in[8] = weight2_add_in9;
assign weight2_add_in[9] = weight2_add_in10;
assign weight2_add_in[10] = weight2_add_in11;
assign weight2_add_in[11] = weight2_add_in12;
assign weight2_add_in[12] = weight2_add_in13;
assign weight2_add_in[13] = weight2_add_in14;

wire [CON_ADDR-1:0] cv_add_in_col; //input address for convolution memory
wire [CON_ADDR-1:0] cv_add_in_row; //input address for convolution memory
wire [CON_ADDR-2-1:0] cv_off_col; //output address for convolution memory
wire [CON_ADDR-2-1:0] cv_off_row; //output address for convolution memory

wire [POOL_ADDR_COL-1:0] input_add_in_col; //input address for input layer
wire [POOL_ADDR_ROW-1:0] input_add_in_row; //input address for input layer
wire [POOL_ADDR_COL-1:0] input_add_in_col2; //input address for input layer
wire [POOL_ADDR_ROW-1:0] input_add_in_row2; //input address for input layer
wire [POOL_ADDR_COL-1:0] input_add_in_col3; //input address for input layer
wire [POOL_ADDR_ROW-1:0] input_add_in_row3; //input address for input layer
wire [POOL_ADDR_COL-1:0] input_add_in_col4; //input address for input layer
wire [POOL_ADDR_ROW-1:0] input_add_in_row4; //input address for input layer

wire [POOL_ADDR_COL-1:0] input_off_col; //input address for input layer
wire [POOL_ADDR_ROW-1:0] input_off_row; //input address for input layer

wire [HID_ADDR-1:0] hidden_add_in;//hidden layer's input address

wire [RES_ADDR-1:0] result_add_in;//result layer's input address
wire [RES_ADDR-1:0] result_add_out;//result layer's output address
///////////////////////////////else
wire reset_signal;//hidden layer's write en that is sent by fully count

wire [RES_ADDR-1:0] weight2_cnt;//for choosing weight2 memory 
wire [HID_ADDR-1:0] weight_cnt;//for choosing weight1 memory

//////////////////////////////////////// etc

output [3:0] data_out; //final data

//image memory's output having 3 pixels
wire [DW*3-1:0] im_data_a;
wire [DW*3-1:0] im_data_b;
wire [DW*3-1:0] im_data_c;
//filter memory's output having 3 pixels
wire [DW*3-1:0] fi_data_a[0:3];
wire [DW*3-1:0] fi_data_b[0:3];
wire [DW*3-1:0] fi_data_c[0:3];

wire [7*DW-1:0] weight1_data_out[0:9];//weight1 memory's output

reg [7*DW-1:0] weight1_data;//choosed weight1 memory's data

wire [HID_SIZE*DW-1:0] weight2_data_out[0:13];//weight2 memory's data

reg [HID_SIZE*DW-1:0] weight2_data;//choosed weight2 memory's data

wire [DW-1:0] cv_data_in[0:3]; //output of Convolutioncycle, Convolution memory1's input
//output of Convolution memory
wire [DW*4-1:0] cv_data_a[0:3];
wire [DW*4-1:0] cv_data_b[0:3];
wire [DW*4-1:0] cv_data_c[0:3];
wire [DW*4-1:0] cv_data_d[0:3];

wire [DW-1:0] input_data_in[0:3];//output of poolingcycle, input layer's input

wire [7*DW-1:0] input_data;//input layer's output

wire [DW-1:0] hidden_data_in;//hidden layer's input
wire [HID_SIZE*DW-1:0] hidden_data;//hidden layer's output

wire signed [DW:0] result_data_in;//result layer's input
wire signed [DW:0] result_data;//result layer's output
wire [(DW+1)*RES_SIZE-1:0] result_out;//result layer's output

output wire signed [DW:0] result_out0;
output wire signed [DW:0] result_out1;
output wire signed [DW:0] result_out2;
output wire signed [DW:0] result_out3;
output wire signed [DW:0] result_out4;
output wire signed [DW:0] result_out5;
output wire signed [DW:0] result_out6;
output wire signed [DW:0] result_out7;
output wire signed [DW:0] result_out8;
output wire signed [DW:0] result_out9;
output wire signed [DW:0] result_out10;
output wire signed [DW:0] result_out11;
output wire signed [DW:0] result_out12;
output wire signed [DW:0] result_out13;

assign result_out13 = result_out[(DW+1)-1:0];
assign result_out12 = result_out[2*(DW+1)-1:(DW+1)];
assign result_out11 = result_out[3*(DW+1)-1:2*(DW+1)];
assign result_out10 = result_out[4*(DW+1)-1:3*(DW+1)];
assign result_out9 = result_out[5*(DW+1)-1:4*(DW+1)];
assign result_out8 = result_out[6*(DW+1)-1:5*(DW+1)];
assign result_out7 = result_out[7*(DW+1)-1:6*(DW+1)];
assign result_out6 = result_out[8*(DW+1)-1:7*(DW+1)];
assign result_out5 = result_out[9*(DW+1)-1:8*(DW+1)];
assign result_out4 = result_out[10*(DW+1)-1:9*(DW+1)];
assign result_out3 = result_out[11*(DW+1)-1:10*(DW+1)];
assign result_out2 = result_out[12*(DW+1)-1:11*(DW+1)];
assign result_out1 = result_out[13*(DW+1)-1:12*(DW+1)];
assign result_out0 = result_out[14*(DW+1)-1:13*(DW+1)];

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        chip_en <= 0;
    end
    else
    begin
        if(start_sign)
        begin
            chip_en <= 1'b1; 
        end
        else if(finish_sign)
        begin
            chip_en <= 1'b0;
        end
        else
        begin
            chip_en <= chip_en;
        end
    end
end

MES Make_enable_signal ( clk, reset, chip_en, read_en, cv_write_en, input_write_en, cv_read_en, input_read_en, hidden_read_en, fully_en, result_write_en, result_read_en );

//image memory
New_mem_3out #(.DW(DW), .MEM_SIZE(IMA_SIZE+2), .MEM_ADDR(IMA_ADDR)) Image ( .data_in(image_data_in), .reset(reset), .clk(clk),
.in_add_col(im_add_in_col+1'b1), .in_add_row(im_add_in_row+1'b1), .a_add_col(im_off_col+1'b1), .a_add_row(im_off_row+1'b1),
.wr_en(im_write_en), .rd_en(read_en), .data_out_a(im_data_a), .data_out_b(im_data_b), .data_out_c(im_data_c), .chiprd_en(ima_rd_en), .chip_data_out(ima_out_data) );

//image memory's address counter
Image_count #(.IMA_SIZE(IMA_SIZE), .IMA_ADDR(IMA_ADDR), .CON_SIZE(CON_SIZE), .CON_ADDR(CON_ADDR)) IC( clk, reset, read_en, im_off_col, im_off_row );

//filter memories
generate
for(i=0;i<4;i=i+1) begin : Filter_mem
    New_mem_3out_signed #(.DW(DW), .MEM_SIZE(FIL_SIZE), .MEM_ADDR(FIL_ADDR)) Filter1 (.data_in(filter_data_in[i]), .reset(reset), .clk(clk),
    .in_add_col(fi_add_in_col[i]), .in_add_row(fi_add_in_row[i]), .a_add_col(2'b01), .a_add_row(2'b01),// .a_add_col(fi_off_col+1'b1), .a_add_row(fi_off_row+1'b1),
    .wr_en(fi_write_en[i]), .rd_en(read_en), .data_out_a(fi_data_a[i]), .data_out_b(fi_data_b[i]), .data_out_c(fi_data_c[i]), .chiprd_en(fil_rd_en[i]), .chip_data_out(fil_out_data[i]) );
end
endgenerate

//Convolution calculate
generate
for(i=0;i<4;i=i+1) begin : Convolution_layer
    Convolution #(.DW(DW), .OUT_DW(DW)) convolutioncycle(.data_im_a(im_data_a), .data_im_b(im_data_b), .data_im_c(im_data_c),
    .data_fi_a(fi_data_a[i]), .data_fi_b(fi_data_b[i]), .data_fi_c(fi_data_c[i]),
    .clk(clk), .reset(reset), .data_out(cv_data_in[i]) );
end
endgenerate

//Convolution memories
generate
for(i=0;i<4;i=i+1) begin : Convolution_mem
    New_mem_2out #(.DW(DW), .MEM_SIZE(CON_SIZE), .MEM_ADDR(CON_ADDR)) Convolution_memory1 (.data_in(cv_data_in[i]), .reset(reset), .clk(clk),
    .in_add_col(cv_add_in_col), .in_add_row(cv_add_in_row), .a_add_col({cv_off_col,2'b00}), .a_add_row({cv_off_row,2'b00}),
    .wr_en(cv_write_en), .rd_en(cv_read_en), .data_out_a(cv_data_a[i]), .data_out_b(cv_data_b[i]), .data_out_c(cv_data_c[i]), .data_out_d(cv_data_d[i]),
    .chip_add_row(con_add_row[i]), .chip_add_col(con_add_col[i]), .chiprd_en(con_rd_en[i]), .chip_data_out(con_out_data[i]) );
end
endgenerate

//Convolution memory's address counter
Conved_count #(.CON_SIZE(CON_SIZE), .CON_ADDR(CON_ADDR)) CC( clk, reset, cv_write_en, cv_read_en, cv_add_in_col, cv_add_in_row, cv_off_col, cv_off_row );

//Pooling calculate
generate
for(i=0;i<4;i=i+1) begin : poolingcycle
    Pooling #(.DW(DW)) poolingcycle1( cv_data_a[i], cv_data_b[i], cv_data_c[i], cv_data_d[i], input_data_in[i] );
end
endgenerate

//input layer
New_mem_4in7out #(.DW(DW), .MEM_SIZE_COL(POOL_SIZE_COL), .MEM_SIZE_ROW(POOL_SIZE_ROW), .MEM_ADDR_COL(POOL_ADDR_COL), .MEM_ADDR_ROW(POOL_ADDR_ROW)) inputlayer
( .data_in1(input_data_in[0]), .data_in2(input_data_in[1]), .data_in3(input_data_in[2]), .data_in4(input_data_in[3]), .reset(reset), .clk(clk), .wr_en(input_write_en), .rd_en(input_read_en),
.in_add_col1(input_add_in_col), .in_add_row1(input_add_in_row),.in_add_col2(input_add_in_col2), .in_add_row2(input_add_in_row2),.in_add_col3(input_add_in_col3), .in_add_row3(input_add_in_row3),
.in_add_col4(input_add_in_col4), .in_add_row4(input_add_in_row4),.out_add_col( 3'b000 ), .out_add_row(input_off_row), .data_out(input_data),
.chip_add_row(inp_add_row), .chip_add_col(inp_add_col), .chiprd_en(inp_rd_en), .chip_data_out(inp_out_data) );

//input layer's address counter
Pooled_count #(.POOL_SIZE_COL(POOL_SIZE_COL), .POOL_SIZE_ROW(POOL_SIZE_ROW), .POOL_ADDR_COL(POOL_ADDR_COL), .POOL_ADDR_ROW(POOL_ADDR_ROW)) PC (clk, reset, input_write_en, input_read_en,
input_add_in_col, input_add_in_row, input_add_in_col2, input_add_in_row2, input_add_in_col3, input_add_in_row3, input_add_in_col4, input_add_in_row4, input_off_row );

//weight1 memories
generate
for(i=0;i<10;i=i+1) begin : weight1_mem
    New_mem_7out #(.DW(DW), .MEM_SIZE_COL(POOL_SIZE_COL), .MEM_SIZE_ROW(POOL_SIZE_ROW), .MEM_ADDR_COL(POOL_ADDR_COL), .MEM_ADDR_ROW(POOL_ADDR_ROW)) weight1_memory1(.data_in1(weight1_data_in[i]),
    .reset(reset), .clk(clk), .wr_en(weight1_write_en[i]), .rd_en(input_read_en),
    .in_add_col1(weight1_add_in_col[i]), .in_add_row1(weight1_add_in_row[i]), .out_add_col( 3'b000 ), .out_add_row(weight1_off_row), .data_out(weight1_data_out[i]),
    .chiprd_en(wei1_rd_en[i]), .chip_data_out(wei1_out_data[i]) );
end
endgenerate

//weight1 memory's address counter
weight_count #(.WEIGHT_SIZE_COL(POOL_SIZE_COL), .WEIGHT_SIZE_ROW(POOL_SIZE_ROW), .WEIGHT_ADDR_COL(POOL_ADDR_COL), .WEIGHT_ADDR_ROW(POOL_ADDR_ROW)) WC( .clk(clk), .reset(reset), .weight_read_en(input_read_en),
.weight_off_row(weight1_off_row) );

//selecting weight1 memory counter
Choose_count CHC( .clk(clk), .reset(reset), .weight_num(weight_cnt), .pool_read_en(input_read_en) );

//first fully connected layer calculate
fullyconnect #(.DW(DW), .OUT_DW(DW)) fullycycle( .data_layer_in(input_data),
.data_weight_in(weight1_data),
.clk(clk), .reset(reset), .signal_accum(reset_signal), .data_out(hidden_data_in) );

//counter for first fully connected layer calculate
fully_count FUC( .reset(reset), .clk(clk), .fully_en(fully_en),
.in_addr(hidden_add_in), .reset_signal(reset_signal) );

//hidden layer
New_mem_1d2 #(.DW(DW), .MEM_SIZE(HID_SIZE), .MEM_ADDR(HID_ADDR)) hiddenlayer(.data_in(hidden_data_in), .reset(reset), .clk(clk),
.in_add(hidden_add_in), .wr_en(reset_signal), .rd_en(hidden_read_en), .data_out(hidden_data),
.chip_add(hid_add), .chiprd_en(hid_rd_en), .chip_data_out(hid_out_data));

//weight2 memories
generate
for(i=0;i<14;i=i+1) begin : weight2_mem
    New_mem_1d #(.DW(DW), .MEM_SIZE(HID_SIZE), .MEM_ADDR(HID_ADDR)) weight2_memory0 (.data_in(weight2_data_in[i]),
    .reset(reset), .clk(clk), .in_add(weight2_add_in[i]), .wr_en(weight2_write_en[i]), .rd_en(hidden_read_en), .data_out(weight2_data_out[i]),
    .chiprd_en(wei2_rd_en[i]), .chip_data_out(wei2_out_data[i]));
end
endgenerate

//selecting weight2 memory counter
Choose2_count CHC2( .clk(clk), .reset(reset), .rd_en(hidden_read_en), .weight_cnt(weight2_cnt) );

//counter for second fully connected layer calculate
lastcalculate #(.DW(DW), .OUT_DW(DW), .MEM_SIZE(HID_SIZE)) secondfullycycle( .data_connect(hidden_data), .data_weight(weight2_data)
, .reset(reset), .clk(clk), .data_out(result_data_in) );

//result layer
New_mem_1d1out #(.DW(DW), .MEM_SIZE(RES_SIZE), .MEM_ADDR(RES_ADDR)) resultlayer( .data_in(result_data_in), .clk(clk), .reset(reset), .write_en(result_write_en), .read_en(result_read_en),
.chiprd_en(res_rd_en), .in_address(result_add_in), .out_address(result_add_out), .data_out(result_data), .result_out(result_out) );

//result layer's address counter
result_count RC( .clk(clk), .reset(reset), .read_en(result_read_en), .write_en(result_write_en), .in_address(result_add_in), .out_address(result_add_out) );

//result layer's data comparator
comparator #(.DW(DW), .OUT_DW(OUT_DW), .MEM_ADDR(RES_ADDR)) Comparator( .data_in(result_data), .clk(clk), .reset(reset), .start_sign(start_sign), .read_en(result_read_en), .address(result_add_out), .result(data_out), .finish(finish_sign) );

//Mux for selecting weight1 momory
always @ (*)
begin
    case(weight_cnt)
    4'd0 : weight1_data = weight1_data_out[0];
    4'd1 : weight1_data = weight1_data_out[1];
    4'd2 : weight1_data = weight1_data_out[2];
    4'd3 : weight1_data = weight1_data_out[3];
    4'd4 : weight1_data = weight1_data_out[4];
    4'd5 : weight1_data = weight1_data_out[5];
    4'd6 : weight1_data = weight1_data_out[6];
    4'd7 : weight1_data = weight1_data_out[7];
    4'd8 : weight1_data = weight1_data_out[8];
    4'd9 : weight1_data = weight1_data_out[9];
    default : weight1_data = 0;
    endcase
end
//Mux for selecting weight2 momory
always @ (*)
begin
    case (weight2_cnt)
        'd0 : weight2_data = weight2_data_out[0];
        'd1 : weight2_data = weight2_data_out[1];
        'd2 : weight2_data = weight2_data_out[2];
        'd3 : weight2_data = weight2_data_out[3];
        'd4 : weight2_data = weight2_data_out[4];
        'd5 : weight2_data = weight2_data_out[5];
        'd6 : weight2_data = weight2_data_out[6];
        'd7 : weight2_data = weight2_data_out[7];
        'd8 : weight2_data = weight2_data_out[8];
        'd9 : weight2_data = weight2_data_out[9];
        'd10 : weight2_data = weight2_data_out[10];
        'd11 : weight2_data = weight2_data_out[11];
        'd12 : weight2_data = weight2_data_out[12];
        'd13 : weight2_data = weight2_data_out[13];
        default : weight2_data = 0;
    endcase  
end

endmodule