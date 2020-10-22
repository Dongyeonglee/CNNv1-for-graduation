`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:28:24
// Design Name: 
// Module Name: Convolution
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


module Convolution(data_im_a, data_im_b, data_im_c, data_fi_a, data_fi_b, data_fi_c, clk, reset, data_out );

parameter DW = 8; //bit of pixel
parameter CAL_DW = DW*2+4; // bit of calculation
parameter OUT_DW = DW; //bit of out pixel

input [DW*3-1:0] data_im_a;
input [DW*3-1:0] data_im_b;
input [DW*3-1:0] data_im_c;
input [DW*3-1:0] data_fi_a;
input [DW*3-1:0] data_fi_b;
input [DW*3-1:0] data_fi_c;
input clk, reset;
//input conv_en;
output [OUT_DW-1:0] data_out;

wire signed [DW-1+1:0] im_data [0:8];
wire signed [DW-1:0] fi_data [0:8];

wire signed [DW*2:0] mul_data [0:8];//multiplied data
wire signed [CAL_DW-1:0] input_data [0:8];//multiplied data
reg signed [CAL_DW-1:0] add_data1;//save first add data
reg signed [CAL_DW-1:0] add_data2;//save first add data
reg signed [CAL_DW-1:0] add_data3;//save first add data
reg signed [CAL_DW-1:0] add_data_2;//save sencond add data

wire [CAL_DW-1:0] connect[0:2];
wire [CAL_DW-1:0] connect2;
wire [CAL_DW-1:0] k1_1;
wire [CAL_DW-1:0] k1_2;
wire [CAL_DW-1:0] k1_3;
wire [CAL_DW-1:0] k2;
genvar i;

//
assign im_data[0] = {1'd0,data_im_a[DW*3-1:DW*2]};
assign im_data[1] = {1'd0,data_im_a[DW*2-1:DW]};
assign im_data[2] = {1'd0,data_im_a[DW-1:0]};
assign im_data[3] = {1'd0,data_im_b[DW*3-1:DW*2]};
assign im_data[4] = {1'd0,data_im_b[DW*2-1:DW]};
assign im_data[5] = {1'd0,data_im_b[DW-1:0]};
assign im_data[6] = {1'd0,data_im_c[DW*3-1:DW*2]};
assign im_data[7] = {1'd0,data_im_c[DW*2-1:DW]};
assign im_data[8] = {1'd0,data_im_c[DW-1:0]};

assign fi_data[0] = {data_fi_a[DW*3-1:DW*2]};
assign fi_data[1] = {data_fi_a[DW*2-1:DW]};
assign fi_data[2] = {data_fi_a[DW-1:0]};
assign fi_data[3] = {data_fi_b[DW*3-1:DW*2]};
assign fi_data[4] = {data_fi_b[DW*2-1:DW]};
assign fi_data[5] = {data_fi_b[DW-1:0]};
assign fi_data[6] = {data_fi_c[DW*3-1:DW*2]};
assign fi_data[7] = {data_fi_c[DW*2-1:DW]};
assign fi_data[8] = {data_fi_c[DW-1:0]};


generate
for(i=0;i<9;i=i+1) begin : make_input
    assign input_data[i] = (mul_data[i][DW*2-1]) ? {mul_data[i][DW*2-1],4'b1111,mul_data[i][DW*2-2:0]} : {mul_data[i][DW*2-1],4'b0000,mul_data[i][DW*2-2:0]};
end
endgenerate


always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        add_data1 <= 0;
        add_data2 <= 0;
        add_data3 <= 0;
        add_data_2 <= 0;
    end
    else
    begin
        //first adding          
        add_data1 <= connect[0];
        add_data2 <= connect[1];
        add_data3 <= connect[2];
        //second adding
        add_data_2 <= connect2;
    end
end

//multiplied 
generate
for(i=0;i<9;i=i+1) begin : multiplier
    DRUM6_8_u #( .ACCURATE_DW(DW-3), .A_BW(DW+1), .B_BW(DW) ) approx_mul (.a(im_data[i]) , .b(fi_data[i]), .out(mul_data[i])) ;
    //assign mul_data[i] = im_data[i] * fi_data[i];
end
endgenerate

assign data_out = add_data_2[CAL_DW-1] ? 8'b0 : add_data_2[CAL_DW-1-4:CAL_DW-OUT_DW-4];

approx_adder_4th  #(.DW(CAL_DW), .PORTION(4)) conadder1_1(input_data[0],input_data[1],k1_1);
approx_adder_4th  #(.DW(CAL_DW), .PORTION(4)) conadder1_2(k1_1,input_data[2],connect[0]);

// approx_adder_4th #(.BW(), .PORTION(4)) conadder1_2(k1_1,input_data[2],connect[0]);

approx_adder_4th  #(.DW(CAL_DW), .PORTION(4)) conadder2_1(input_data[3],input_data[4],k1_2);
approx_adder_4th  #(.DW(CAL_DW), .PORTION(4))conadder2_2(k1_2,input_data[5],connect[1]);

approx_adder_4th  #(.DW(CAL_DW), .PORTION(4))conadder3_1(input_data[6],input_data[7],k1_3);
approx_adder_4th  #(.DW(CAL_DW), .PORTION(4))conadder3_2(k1_3,input_data[8],connect[2]);

//second adding
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) conadder4_1(add_data1,add_data2,k2);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) conadder4_2(k2,add_data3,connect2);

endmodule
