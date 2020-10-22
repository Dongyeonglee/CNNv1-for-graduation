`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: fullyconnect
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


module fullyconnect(data_layer_in, data_weight_in, clk, reset,signal_accum, data_out );

parameter DW = 8; //bit of out pixel
parameter MUL_DW = 2*DW;
parameter CAL_DW = MUL_DW+8;
parameter OUT_DW = 8;
input [7*DW-1:0] data_layer_in;
input [7*DW-1:0] data_weight_in;
input clk, reset;
input signal_accum;
output [OUT_DW-1:0] data_out;

wire signed [DW-1+1:0] data_layer[0:6];
wire signed [DW-1:0] data_weight[0:6];

wire signed [CAL_DW-1:0] back_accum_data;

wire signed [MUL_DW:0] mul_data [0:6];//multiplied data
wire signed [CAL_DW-1:0] input_data [0:6];//multiplied data mul_data -> add_data~
reg signed [CAL_DW-1:0] add_data1;//save first add data
reg signed [CAL_DW-1:0] add_data2;//save first add data
reg signed [CAL_DW-1:0] add_data3;//save first add data
reg signed [CAL_DW-1:0] add_data4;//save first add data
reg signed [CAL_DW-1:0] accum_data;
genvar i;

wire [CAL_DW-1:0] connect[0:2];
wire [CAL_DW-1:0] connect2;
wire [CAL_DW-1:0] k1;
wire [CAL_DW-1:0] k2;

generate
for(i=0;i<7;i=i+1) begin : S_layer
    assign data_layer[i] = {1'd0,data_layer_in[(7-i)*DW-1:(6-i)*DW]};
end
endgenerate

generate
for(i=0;i<7;i=i+1) begin : S_weight1
    assign data_weight[i] = {data_weight_in[(7-i)*DW-1:(6-i)*DW]};
end
endgenerate

generate
for(i=0;i<7;i=i+1) begin : make_input
    assign input_data[i] = (mul_data[i][MUL_DW-1]) ? {mul_data[i][MUL_DW-1],8'b1111_1111,mul_data[i][MUL_DW-2:0]} : {mul_data[i][MUL_DW-1],8'b0000_0000,mul_data[i][MUL_DW-2:0]};
end
endgenerate


generate
for(i=0;i<7;i=i+1) begin : multiplier
    DRUM6_8_u #( .ACCURATE_DW(DW-3), .A_BW(DW+1), .B_BW(DW) ) approx_mul (.a(data_layer[i]) , .b(data_weight[i]), .out(mul_data[i])) ;
    //assign mul_data[i] = data_layer[i] * data_weight[i];
end
endgenerate

assign back_accum_data = (signal_accum) ? 0 : accum_data;
assign data_out = accum_data[CAL_DW-1] ? 8'b0 : accum_data[CAL_DW-1-7:CAL_DW-OUT_DW-7];

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        add_data1 <= 0;
        add_data2 <= 0;
        add_data3 <= 0;
        add_data4 <= 0;
        accum_data <= 0;
    end
    else
    begin
        add_data1 <= connect[0];
        add_data2 <= connect[1];
        add_data3 <= connect[2];
        
        add_data4 <= connect2;
        
        accum_data <= back_accum_data + add_data4;
    end
end

//first adding
approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder1_1(input_data[0],input_data[1],k1);
approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder1_2(k1,input_data[2],connect[0]);

approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder2_1(input_data[3],input_data[4],connect[1]);

approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder3_1(input_data[5],input_data[6],connect[2]);

//second adding
approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder4_1(add_data1,add_data2,k2);
approx_adder_4th #(.DW(CAL_DW), .PORTION(3)) FCadder4_2(k2,add_data3,connect2);


endmodule