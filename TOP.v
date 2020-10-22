`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: TOP
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


module TOP(
        //SPI Interfave
    MOSI,
    MISO,
    SCK,
    nSS,

    start_sign,
    finish_sign,
    
    //general input
    clk,
    reset
    );
    
    //de
    parameter DWIDTH = 16;
    parameter CWIDTH = 8;
    parameter IWIDTH = 5; //image memory
    parameter FWIDTH = 2;
    parameter W1_WIDTH_R = 5;
    parameter W1_WIDTH_C = 3;
    parameter W2_WIDTH = 4;
    parameter OWIDTH = 4;        
    parameter HWIDTH = 4;
    parameter RWIDTH = 4;
    
    input clk,reset;
    //de    
    //SPI Interface
    input wire MOSI;   //input wire
    output wire MISO;  //output wire
    input SCK;    //input wire
    input nSS;    //input wire
    
    //spi
    input start_sign;
    reg start_sign_reg;
    output finish_sign;
    
    wire [DWIDTH-1:0] in_data; // tx_data
    wire [DWIDTH-1:0] out_data; // rx_data
    wire spi_done;
  
    wire signed [CWIDTH:0] CNN_out_data[0:13];   // result of all calculation
    wire [OWIDTH-1:0] CNN_out_result;       // prediction
    
    wire [IWIDTH-1:0] ima_addr_row;
    wire [IWIDTH-1:0] ima_addr_col;
    wire [FWIDTH-1:0] fil_addr_row [0:3];
    wire [FWIDTH-1:0] fil_addr_col [0:3];
    wire [W1_WIDTH_R-1:0] wei1_addr_row[0:9];
    wire [W1_WIDTH_C-1:0] wei1_addr_col[0:9];
    wire [W2_WIDTH-1:0] wei2_addr[0:13];
    
    wire [CWIDTH-1:0] ima_data_in;
    wire signed [CWIDTH-1:0] fil_data_in[0:3];
    wire signed [CWIDTH-1:0] wei1_data_in[0:9];
    wire signed [CWIDTH-1:0] wei2_data_in[0:13];
    
    //memory enable signal
    wire wr_en;
    wire rd_en;
    wire mem_en;
    wire [DWIDTH-1:0] addr_mem;
    
    wire ima_wr_en;
    wire fil_wr_en[0:3];
    wire wei1_wr_en[0:9];
    wire wei2_wr_en[0:13];

 ////////////////////////////////////////////   
    wire [IWIDTH-1:0] con_add_row[0:3];
    wire [IWIDTH-1:0] con_add_col[0:3];
    
    wire [W1_WIDTH_R-1:0] inp_add_row;
    wire [W1_WIDTH_C-1:0] inp_add_col;
    wire [HWIDTH-1:0] hid_add;
    
    wire ima_rd_en;
    wire fil_rd_en[0:3];
    wire wei1_rd_en[0:9];
    wire wei2_rd_en[0:13];
    wire con_rd_en[0:3];
    wire inp_rd_en;
    wire hid_rd_en;
    wire res_rd_en;
    
    wire [CWIDTH-1:0] ima_out_data;
    wire signed [CWIDTH-1:0] fil_out_data[0:3];
    wire signed [CWIDTH-1:0] con_out_data[0:3];
    wire signed [CWIDTH-1:0] wei1_out_data[0:9];
    wire signed [CWIDTH-1:0] wei2_out_data[0:13];
    wire [CWIDTH-1:0] inp_out_data;
    wire [CWIDTH-1:0] hid_out_data;
    
    //Register SCK and SS signals to avoid SPI errors due to different clocks
    reg SCK_reg;
    reg nSS_reg;
    
    always@(posedge clk or negedge reset)
    begin
        if( !reset ) begin
            SCK_reg <= 1'b0;
            nSS_reg <= 1'b1;    //Active low, default value is 1
            start_sign_reg <= 1'b0;
        end else begin
            start_sign_reg <= start_sign;
            SCK_reg <= SCK;
            nSS_reg <= nSS; 
        end
    end
    
    SPI_Slave_Top SPI_Slave_Top(
        //SPI Interface
        .MOSI(MOSI),
        .MISO(MISO),
        .SCK(SCK_reg),
        .SS(nSS_reg),
        
        //general inputs
        .clk(clk), .rst_n(reset),
        .wr_en(wr_en), .rd_en(rd_en), .mem_en(mem_en), .addr_mem(addr_mem), 
        .wr_data_mem(in_data), .rd_data_mem(out_data)
        );
    
    Addr_tr Addr_tr(
    //general input
    .wr_en(wr_en), .rd_en(rd_en), .mem_en(mem_en), .addr_mem(addr_mem), .wr_data_mem(in_data[7:0]), .rd_data_mem(out_data),
    .ima_wr_en(ima_wr_en), .fil_wr_en1(fil_wr_en[0]), .fil_wr_en2(fil_wr_en[1]), .fil_wr_en3(fil_wr_en[2]), .fil_wr_en4(fil_wr_en[3]),
    
    .wei1_wr_en1(wei1_wr_en[0]), .wei1_wr_en2(wei1_wr_en[1]), .wei1_wr_en3(wei1_wr_en[2]), .wei1_wr_en4(wei1_wr_en[3]), .wei1_wr_en5(wei1_wr_en[4]),
    .wei1_wr_en6(wei1_wr_en[5]), .wei1_wr_en7(wei1_wr_en[6]), .wei1_wr_en8(wei1_wr_en[7]), .wei1_wr_en9(wei1_wr_en[8]), .wei1_wr_en10(wei1_wr_en[9]),
    
    .wei2_wr_en1(wei2_wr_en[0]), .wei2_wr_en2(wei2_wr_en[1]), .wei2_wr_en3(wei2_wr_en[2]), .wei2_wr_en4(wei2_wr_en[3]), .wei2_wr_en5(wei2_wr_en[4]),
    .wei2_wr_en6(wei2_wr_en[5]), .wei2_wr_en7(wei2_wr_en[6]), .wei2_wr_en8(wei2_wr_en[7]), .wei2_wr_en9(wei2_wr_en[8]), .wei2_wr_en10(wei2_wr_en[9]), 
    .wei2_wr_en11(wei2_wr_en[10]), .wei2_wr_en12(wei2_wr_en[11]), .wei2_wr_en13(wei2_wr_en[12]), .wei2_wr_en14(wei2_wr_en[13]), 
    
    // input data
    .ima_data_in(ima_data_in),
    .fil_data_in1(fil_data_in[0]), .fil_data_in2(fil_data_in[1]), .fil_data_in3(fil_data_in[2]), .fil_data_in4(fil_data_in[3]),
    
    .wei1_data_in0(wei1_data_in[0]), .wei1_data_in1(wei1_data_in[1]), .wei1_data_in2(wei1_data_in[2]),
    .wei1_data_in3(wei1_data_in[3]), .wei1_data_in4(wei1_data_in[4]), .wei1_data_in5(wei1_data_in[5]),
    .wei1_data_in6(wei1_data_in[6]), .wei1_data_in7(wei1_data_in[7]), .wei1_data_in8(wei1_data_in[8]),
    .wei1_data_in9(wei1_data_in[9]), 
    
    .wei2_data_in0(wei2_data_in[0]), .wei2_data_in1(wei2_data_in[1]), .wei2_data_in2(wei2_data_in[2]),
    .wei2_data_in3(wei2_data_in[3]), .wei2_data_in4(wei2_data_in[4]), .wei2_data_in5(wei2_data_in[5]),
    .wei2_data_in6(wei2_data_in[6]), .wei2_data_in7(wei2_data_in[7]), .wei2_data_in8(wei2_data_in[8]),
    .wei2_data_in9(wei2_data_in[9]), .wei2_data_in10(wei2_data_in[10]), .wei2_data_in11(wei2_data_in[11]),
    .wei2_data_in12(wei2_data_in[12]), .wei2_data_in13(wei2_data_in[13]),
    
    // output data
    .CNN_out_result(CNN_out_result), .CNN_out_data0(CNN_out_data[0]), .CNN_out_data1(CNN_out_data[1]), .CNN_out_data2(CNN_out_data[2]), .CNN_out_data3(CNN_out_data[3]),
    .CNN_out_data4(CNN_out_data[4]), .CNN_out_data5(CNN_out_data[5]), .CNN_out_data6(CNN_out_data[6]), .CNN_out_data7(CNN_out_data[7]), .CNN_out_data8(CNN_out_data[8]),
    .CNN_out_data9(CNN_out_data[9]), .CNN_out_data10(CNN_out_data[10]), .CNN_out_data11(CNN_out_data[11]), .CNN_out_data12(CNN_out_data[12]), .CNN_out_data13(CNN_out_data[13]),
    
    // address
    .ima_add_col(ima_addr_col), .ima_add_row(ima_addr_row),
    .fil_add_col1(fil_addr_col[0]), .fil_add_row1(fil_addr_row[0]), .fil_add_col2(fil_addr_col[1]), .fil_add_row2(fil_addr_row[1]),
    .fil_add_col3(fil_addr_col[2]), .fil_add_row3(fil_addr_row[2]), .fil_add_col4(fil_addr_col[3]), .fil_add_row4(fil_addr_row[3]),
    
    .wei1_add_col1(wei1_addr_col[0]), .wei1_add_row1(wei1_addr_row[0]), .wei1_add_col2(wei1_addr_col[1]), .wei1_add_row2(wei1_addr_row[1]),
    .wei1_add_col3(wei1_addr_col[2]), .wei1_add_row3(wei1_addr_row[2]), .wei1_add_col4(wei1_addr_col[3]), .wei1_add_row4(wei1_addr_row[3]),
    .wei1_add_col5(wei1_addr_col[4]), .wei1_add_row5(wei1_addr_row[4]), .wei1_add_col6(wei1_addr_col[5]), .wei1_add_row6(wei1_addr_row[5]),
    .wei1_add_col7(wei1_addr_col[6]), .wei1_add_row7(wei1_addr_row[6]), .wei1_add_col8(wei1_addr_col[7]), .wei1_add_row8(wei1_addr_row[7]),
    .wei1_add_col9(wei1_addr_col[8]), .wei1_add_row9(wei1_addr_row[8]), .wei1_add_col10(wei1_addr_col[9]), .wei1_add_row10(wei1_addr_row[9]),
    
    .wei2_add1(wei2_addr[0]), .wei2_add2(wei2_addr[1]), .wei2_add3(wei2_addr[2]), .wei2_add4(wei2_addr[3]),
    .wei2_add5(wei2_addr[4]), .wei2_add6(wei2_addr[5]), .wei2_add7(wei2_addr[6]), .wei2_add8(wei2_addr[7]),
    .wei2_add9(wei2_addr[8]), .wei2_add10(wei2_addr[9]), .wei2_add11(wei2_addr[10]), .wei2_add12(wei2_addr[11]),
    .wei2_add13(wei2_addr[12]), .wei2_add14(wei2_addr[13]),
    ////////////////////////////////////////////////////////////////
    .con_add_row1(con_add_row[0]), .con_add_col1(con_add_col[0]), .con_add_row2(con_add_row[1]), .con_add_col2(con_add_col[1]),
    .con_add_row3(con_add_row[2]), .con_add_col3(con_add_col[2]), .con_add_row4(con_add_row[3]), .con_add_col4(con_add_col[3]),
    
    .inp_add_row(inp_add_row), .inp_add_col(inp_add_col), .hid_add(hid_add),
    
    .ima_rd_en(ima_rd_en), .fil_rd_en1(fil_rd_en[0]), .fil_rd_en2(fil_rd_en[1]), .fil_rd_en3(fil_rd_en[2]), .fil_rd_en4(fil_rd_en[3]),
    .wei1_rd_en1(wei1_rd_en[0]), .wei1_rd_en2(wei1_rd_en[1]), .wei1_rd_en3(wei1_rd_en[2]), .wei1_rd_en4(wei1_rd_en[3]), .wei1_rd_en5(wei1_rd_en[4]),
    .wei1_rd_en6(wei1_rd_en[5]), .wei1_rd_en7(wei1_rd_en[6]), .wei1_rd_en8(wei1_rd_en[7]), .wei1_rd_en9(wei1_rd_en[8]), .wei1_rd_en10(wei1_rd_en[9]),
    .wei2_rd_en1(wei2_rd_en[0]), .wei2_rd_en2(wei2_rd_en[1]), .wei2_rd_en3(wei2_rd_en[2]), .wei2_rd_en4(wei2_rd_en[3]), .wei2_rd_en5(wei2_rd_en[4]),
    .wei2_rd_en6(wei2_rd_en[5]), .wei2_rd_en7(wei2_rd_en[6]), .wei2_rd_en8(wei2_rd_en[7]), .wei2_rd_en9(wei2_rd_en[8]), .wei2_rd_en10(wei2_rd_en[9]),
    .wei2_rd_en11(wei2_rd_en[10]), .wei2_rd_en12(wei2_rd_en[11]), .wei2_rd_en13(wei2_rd_en[12]), .wei2_rd_en14(wei2_rd_en[13]),
    .con_rd_en1(con_rd_en[0]), .con_rd_en2(con_rd_en[1]), .con_rd_en3(con_rd_en[2]), .con_rd_en4(con_rd_en[3]), .inp_rd_en(inp_rd_en), .hid_rd_en(hid_rd_en), .res_rd_en(res_rd_en),
    
    .ima_out_data(ima_out_data), .fil_out_data1(fil_out_data[0]), .fil_out_data2(fil_out_data[1]), .fil_out_data3(fil_out_data[2]), .fil_out_data4(fil_out_data[3]),
    .con_out_data1(con_out_data[0]), .con_out_data2(con_out_data[1]), .con_out_data3(con_out_data[2]), .con_out_data4(con_out_data[3]),
    .wei1_out_data1(wei1_out_data[0]), .wei1_out_data2(wei1_out_data[1]), .wei1_out_data3(wei1_out_data[2]), .wei1_out_data4(wei1_out_data[3]), .wei1_out_data5(wei1_out_data[4]),
    .wei1_out_data6(wei1_out_data[5]), .wei1_out_data7(wei1_out_data[6]), .wei1_out_data8(wei1_out_data[7]), .wei1_out_data9(wei1_out_data[8]), .wei1_out_data10(wei1_out_data[9]),
    .wei2_out_data1(wei2_out_data[0]), .wei2_out_data2(wei2_out_data[1]), .wei2_out_data3(wei2_out_data[2]), .wei2_out_data4(wei2_out_data[3]), .wei2_out_data5(wei2_out_data[4]),
    .wei2_out_data6(wei2_out_data[5]), .wei2_out_data7(wei2_out_data[6]), .wei2_out_data8(wei2_out_data[7]), .wei2_out_data9(wei2_out_data[8]), .wei2_out_data10(wei2_out_data[9]),
    .wei2_out_data11(wei2_out_data[10]), .wei2_out_data12(wei2_out_data[11]), .wei2_out_data13(wei2_out_data[12]), .wei2_out_data14(wei2_out_data[13]),
    .inp_out_data(inp_out_data), .hid_out_data(hid_out_data)
    );
    
    CNN CNN(
    //enable
    .clk(clk), .reset(reset),
    .start_sign(start_sign_reg), .finish_sign(finish_sign),
    .im_write_en(ima_wr_en), .fi_write_en1(fil_wr_en[0]), .fi_write_en2(fil_wr_en[1]), .fi_write_en3(fil_wr_en[2]), .fi_write_en4(fil_wr_en[3]),
    
    .weight1_write_en1(wei1_wr_en[0]), .weight1_write_en2(wei1_wr_en[1]), .weight1_write_en3(wei1_wr_en[2]), .weight1_write_en4(wei1_wr_en[3]), .weight1_write_en5(wei1_wr_en[4]),
    .weight1_write_en6(wei1_wr_en[5]), .weight1_write_en7(wei1_wr_en[6]), .weight1_write_en8(wei1_wr_en[7]), .weight1_write_en9(wei1_wr_en[8]), .weight1_write_en10(wei1_wr_en[9]),
    
    .weight2_write_en1(wei2_wr_en[0]), .weight2_write_en2(wei2_wr_en[1]), .weight2_write_en3(wei2_wr_en[2]), .weight2_write_en4(wei2_wr_en[3]), .weight2_write_en5(wei2_wr_en[4]),
    .weight2_write_en6(wei2_wr_en[5]), .weight2_write_en7(wei2_wr_en[6]), .weight2_write_en8(wei2_wr_en[7]), .weight2_write_en9(wei2_wr_en[8]), .weight2_write_en10(wei2_wr_en[9]), 
    .weight2_write_en11(wei2_wr_en[10]), .weight2_write_en12(wei2_wr_en[11]), .weight2_write_en13(wei2_wr_en[12]), .weight2_write_en14(wei2_wr_en[13]), 
    
    // input data
    .image_data_in(ima_data_in),
    .filter_data_in1(fil_data_in[0]), .filter_data_in2(fil_data_in[1]), .filter_data_in3(fil_data_in[2]), .filter_data_in4(fil_data_in[3]),
    
    .weight1_data_in0(wei1_data_in[0]), .weight1_data_in1(wei1_data_in[1]), .weight1_data_in2(wei1_data_in[2]),
    .weight1_data_in3(wei1_data_in[3]), .weight1_data_in4(wei1_data_in[4]), .weight1_data_in5(wei1_data_in[5]),
    .weight1_data_in6(wei1_data_in[6]), .weight1_data_in7(wei1_data_in[7]), .weight1_data_in8(wei1_data_in[8]),
    .weight1_data_in9(wei1_data_in[9]), 
    
    .weight2_data_in0(wei2_data_in[0]), .weight2_data_in1(wei2_data_in[1]), .weight2_data_in2(wei2_data_in[2]),
    .weight2_data_in3(wei2_data_in[3]), .weight2_data_in4(wei2_data_in[4]), .weight2_data_in5(wei2_data_in[5]),
    .weight2_data_in6(wei2_data_in[6]), .weight2_data_in7(wei2_data_in[7]), .weight2_data_in8(wei2_data_in[8]),
    .weight2_data_in9(wei2_data_in[9]), .weight2_data_in10(wei2_data_in[10]), .weight2_data_in11(wei2_data_in[11]),
    .weight2_data_in12(wei2_data_in[12]), .weight2_data_in13(wei2_data_in[13]),
    
    // output data
    .data_out(CNN_out_result), .result_out0(CNN_out_data[0]), .result_out1(CNN_out_data[1]), .result_out2(CNN_out_data[2]), .result_out3(CNN_out_data[3]),
    .result_out4(CNN_out_data[4]), .result_out5(CNN_out_data[5]), .result_out6(CNN_out_data[6]), .result_out7(CNN_out_data[7]), .result_out8(CNN_out_data[8]),
    .result_out9(CNN_out_data[9]), .result_out10(CNN_out_data[10]), .result_out11(CNN_out_data[11]), .result_out12(CNN_out_data[12]), .result_out13(CNN_out_data[13]),
    
    // address
    .im_add_in_col(ima_addr_col), .im_add_in_row(ima_addr_row),
    .fi_add_in_col1(fil_addr_col[0]), .fi_add_in_row1(fil_addr_row[0]), .fi_add_in_col2(fil_addr_col[1]), .fi_add_in_row2(fil_addr_row[1]),
    .fi_add_in_col3(fil_addr_col[2]), .fi_add_in_row3(fil_addr_row[2]), .fi_add_in_col4(fil_addr_col[3]), .fi_add_in_row4(fil_addr_row[3]),
    
    .weight1_add_in_col1(wei1_addr_col[0]), .weight1_add_in_row1(wei1_addr_row[0]), .weight1_add_in_col2(wei1_addr_col[1]), .weight1_add_in_row2(wei1_addr_row[1]),
    .weight1_add_in_col3(wei1_addr_col[2]), .weight1_add_in_row3(wei1_addr_row[2]), .weight1_add_in_col4(wei1_addr_col[3]), .weight1_add_in_row4(wei1_addr_row[3]),
    .weight1_add_in_col5(wei1_addr_col[4]), .weight1_add_in_row5(wei1_addr_row[4]), .weight1_add_in_col6(wei1_addr_col[5]), .weight1_add_in_row6(wei1_addr_row[5]),
    .weight1_add_in_col7(wei1_addr_col[6]), .weight1_add_in_row7(wei1_addr_row[6]), .weight1_add_in_col8(wei1_addr_col[7]), .weight1_add_in_row8(wei1_addr_row[7]),
    .weight1_add_in_col9(wei1_addr_col[8]), .weight1_add_in_row9(wei1_addr_row[8]), .weight1_add_in_col10(wei1_addr_col[9]), .weight1_add_in_row10(wei1_addr_row[9]),
    
    .weight2_add_in1(wei2_addr[0]), .weight2_add_in2(wei2_addr[1]), .weight2_add_in3(wei2_addr[2]), .weight2_add_in4(wei2_addr[3]),
    .weight2_add_in5(wei2_addr[4]), .weight2_add_in6(wei2_addr[5]), .weight2_add_in7(wei2_addr[6]), .weight2_add_in8(wei2_addr[7]),
    .weight2_add_in9(wei2_addr[8]), .weight2_add_in10(wei2_addr[9]), .weight2_add_in11(wei2_addr[10]), .weight2_add_in12(wei2_addr[11]),
    .weight2_add_in13(wei2_addr[12]), .weight2_add_in14(wei2_addr[13]),
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    .con_add_row1(con_add_row[0]), .con_add_col1(con_add_col[0]), .con_add_row2(con_add_row[1]), .con_add_col2(con_add_col[1]),
    .con_add_row3(con_add_row[2]), .con_add_col3(con_add_col[2]), .con_add_row4(con_add_row[3]), .con_add_col4(con_add_col[3]),
    
    .inp_add_row(inp_add_row), .inp_add_col(inp_add_col), .hid_add(hid_add),
    
    .ima_rd_en(ima_rd_en), .fil_rd_en1(fil_rd_en[0]), .fil_rd_en2(fil_rd_en[1]), .fil_rd_en3(fil_rd_en[2]), .fil_rd_en4(fil_rd_en[3]),
    .wei1_rd_en1(wei1_rd_en[0]), .wei1_rd_en2(wei1_rd_en[1]), .wei1_rd_en3(wei1_rd_en[2]), .wei1_rd_en4(wei1_rd_en[3]), .wei1_rd_en5(wei1_rd_en[4]),
    .wei1_rd_en6(wei1_rd_en[5]), .wei1_rd_en7(wei1_rd_en[6]), .wei1_rd_en8(wei1_rd_en[7]), .wei1_rd_en9(wei1_rd_en[8]), .wei1_rd_en10(wei1_rd_en[9]),
    .wei2_rd_en1(wei2_rd_en[0]), .wei2_rd_en2(wei2_rd_en[1]), .wei2_rd_en3(wei2_rd_en[2]), .wei2_rd_en4(wei2_rd_en[3]), .wei2_rd_en5(wei2_rd_en[4]),
    .wei2_rd_en6(wei2_rd_en[5]), .wei2_rd_en7(wei2_rd_en[6]), .wei2_rd_en8(wei2_rd_en[7]), .wei2_rd_en9(wei2_rd_en[8]), .wei2_rd_en10(wei2_rd_en[9]),
    .wei2_rd_en11(wei2_rd_en[10]), .wei2_rd_en12(wei2_rd_en[11]), .wei2_rd_en13(wei2_rd_en[12]), .wei2_rd_en14(wei2_rd_en[13]),
    .con_rd_en1(con_rd_en[0]), .con_rd_en2(con_rd_en[1]), .con_rd_en3(con_rd_en[2]), .con_rd_en4(con_rd_en[3]), .inp_rd_en(inp_rd_en), .hid_rd_en(hid_rd_en), .res_rd_en(res_rd_en),
    
    .ima_out_data(ima_out_data), .fil_out_data1(fil_out_data[0]), .fil_out_data2(fil_out_data[1]), .fil_out_data3(fil_out_data[2]), .fil_out_data4(fil_out_data[3]),
    .con_out_data1(con_out_data[0]), .con_out_data2(con_out_data[1]), .con_out_data3(con_out_data[2]), .con_out_data4(con_out_data[3]),
    .wei1_out_data1(wei1_out_data[0]), .wei1_out_data2(wei1_out_data[1]), .wei1_out_data3(wei1_out_data[2]), .wei1_out_data4(wei1_out_data[3]), .wei1_out_data5(wei1_out_data[4]),
    .wei1_out_data6(wei1_out_data[5]), .wei1_out_data7(wei1_out_data[6]), .wei1_out_data8(wei1_out_data[7]), .wei1_out_data9(wei1_out_data[8]), .wei1_out_data10(wei1_out_data[9]),
    .wei2_out_data1(wei2_out_data[0]), .wei2_out_data2(wei2_out_data[1]), .wei2_out_data3(wei2_out_data[2]), .wei2_out_data4(wei2_out_data[3]), .wei2_out_data5(wei2_out_data[4]),
    .wei2_out_data6(wei2_out_data[5]), .wei2_out_data7(wei2_out_data[6]), .wei2_out_data8(wei2_out_data[7]), .wei2_out_data9(wei2_out_data[8]), .wei2_out_data10(wei2_out_data[9]),
    .wei2_out_data11(wei2_out_data[10]), .wei2_out_data12(wei2_out_data[11]), .wei2_out_data13(wei2_out_data[12]), .wei2_out_data14(wei2_out_data[13]),
    .inp_out_data(inp_out_data), .hid_out_data(hid_out_data)
    );
endmodule