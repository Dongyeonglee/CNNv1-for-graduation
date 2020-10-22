`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: lastcalculate
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


module lastcalculate(data_connect, data_weight, clk, reset, data_out );

parameter DW = 8; //bit of pixel
parameter MUL_DW = 2*DW;
parameter CAL_DW = MUL_DW+4;
parameter OUT_DW = 8; //bit of out pixel
parameter MEM_SIZE = 10; ////memory size

input [MEM_SIZE*DW-1:0] data_connect;
input [MEM_SIZE*DW-1:0] data_weight;
input clk, reset;

output signed [OUT_DW:0] data_out;//save fourtH add data;

wire signed [DW:0] connect_da [0:MEM_SIZE-1];
wire signed [DW-1:0] weight_da [0:MEM_SIZE-1];

wire signed [MUL_DW:0] mul_data [0:MEM_SIZE-1];//multiplied data
wire signed [CAL_DW-1:0] input_data [0:MEM_SIZE-1];//multiplied data mul_data -> add_data1_

reg signed [CAL_DW-1:0] add_data1_1;//save first add data
reg signed [CAL_DW-1:0] add_data1_2;
reg signed [CAL_DW-1:0] add_data1_3;
reg signed [CAL_DW-1:0] add_data1_4;
reg signed [CAL_DW-1:0] add_data1_5;

reg signed [CAL_DW-1:0] add_data2_1;//save sencond add data
reg signed [CAL_DW-1:0] add_data2_2;
reg signed [CAL_DW-1:0] add_data2_3;

reg signed [CAL_DW-1:0] add_data3_1;//save third add data
reg signed [CAL_DW-1:0] add_data3_2;

reg signed [CAL_DW-1:0] add_data4;

wire [CAL_DW-1:0] connect [0:4];
wire [CAL_DW-1:0] connect2 [0:1];
wire [CAL_DW-1:0] connect3 ;
wire [CAL_DW-1:0] connect4 ;

wire [MUL_DW-1+3:0] c;

genvar i;

generate
for(i=0;i<10;i=i+1) begin : S_layer
    assign connect_da[i] = {1'd0,data_connect[(10-i)*DW-1:(9-i)*DW]};
end
endgenerate

generate
for(i=0;i<10;i=i+1) begin : S_weight2
    assign weight_da[i] = {data_weight[(10-i)*DW-1:(9-i)*DW]};
end
endgenerate

           //multiplied 
generate
for(i=0;i<10;i=i+1) begin : multiplier
   // assign mul_data[i] = connect_da[i] * weight_da[i];
   DRUM6_8_u #( .ACCURATE_DW(DW-3), .A_BW(DW+1), .B_BW(DW) ) approx_mul (.a(connect_da[i]) , .b(weight_da[i]), .out(mul_data[i])) ;
end
endgenerate

generate
for(i=0;i<10;i=i+1) begin : make_input
    assign input_data[i] = (mul_data[i][MUL_DW-1]) ? {mul_data[i][MUL_DW-1],4'b1111,mul_data[i][MUL_DW-2:0]} : {mul_data[i][MUL_DW-1],4'b0000,mul_data[i][MUL_DW-2:0]};
end
endgenerate

always @ (posedge clk or negedge reset)
begin
    if( !reset )
    begin
        add_data1_1 <= 0;
        add_data1_2 <= 0;
        add_data1_3 <= 0;
        add_data1_4 <= 0;
        add_data1_5 <= 0;
        add_data2_1 <= 0;
        add_data2_2 <= 0;
        add_data2_3 <= 0;
        add_data3_1 <= 0;
        add_data3_2 <= 0;
        add_data4 <= 0;
    end
    else
    begin
        //first adding
        add_data1_1 <= connect[0];
        add_data1_2 <= connect[1];
        add_data1_3 <= connect[2];
        add_data1_4 <= connect[3];
        add_data1_5 <= connect[4];
        //second adding
        add_data2_1 <= connect2[0];
        add_data2_2 <= connect2[1];
        add_data2_3 <= add_data1_5;
        //third adding
        add_data3_1 <= connect3;
        add_data3_2 <= add_data2_3;
        //fourth adding
        add_data4 <= connect4;
    end
end

// first adder
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder1_1(input_data[0],input_data[1],connect[0]);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder1_2(input_data[2],input_data[3],connect[1]);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder1_3(input_data[4],input_data[5],connect[2]);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder1_4(input_data[6],input_data[7],connect[3]);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder1_5(input_data[8],input_data[9],connect[4]);

// second adder
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder2_1(add_data1_1,add_data1_2,connect2[0]);
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder2_2(add_data1_3,add_data1_4,connect2[1]);

// third adder
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder3_1(add_data2_1,add_data2_2,connect3);


// last adder
approx_adder_4th #(.DW(CAL_DW), .PORTION(4)) FC2adder4_1(add_data3_1,add_data3_2,connect4);


//assign data_out = add_data4[CAL_DW-1:CAL_DW-OUT_DW];
assign data_out = {add_data4[CAL_DW-1],add_data4[CAL_DW-2-4:CAL_DW-OUT_DW-5]};
endmodule