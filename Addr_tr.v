`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/14 15:42:28
// Design Name: 
// Module Name: Addr_tr
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


module Addr_tr(
   //general input
     wr_en, rd_en, mem_en, addr_mem, wr_data_mem, rd_data_mem,
     ima_wr_en, fil_wr_en1, fil_wr_en2, fil_wr_en3, fil_wr_en4,
     
     wei1_wr_en1, wei1_wr_en2, wei1_wr_en3, wei1_wr_en4, wei1_wr_en5,
     wei1_wr_en6, wei1_wr_en7, wei1_wr_en8, wei1_wr_en9, wei1_wr_en10,
     
     wei2_wr_en1, wei2_wr_en2, wei2_wr_en3, wei2_wr_en4, wei2_wr_en5, wei2_wr_en6, wei2_wr_en7,
     wei2_wr_en8, wei2_wr_en9, wei2_wr_en10, wei2_wr_en11, wei2_wr_en12, wei2_wr_en13, wei2_wr_en14,
     
     // Cnn Input Data
     ima_data_in, fil_data_in1, fil_data_in2, fil_data_in3, fil_data_in4,
     wei1_data_in0, wei1_data_in1, wei1_data_in2, wei1_data_in3, wei1_data_in4, wei1_data_in5,
     wei1_data_in6, wei1_data_in7, wei1_data_in8, wei1_data_in9,
     
     wei2_data_in0,wei2_data_in1,wei2_data_in2,wei2_data_in3,wei2_data_in4,
     wei2_data_in5,wei2_data_in6,wei2_data_in7,wei2_data_in8,wei2_data_in9,
     wei2_data_in10,wei2_data_in11,wei2_data_in12,wei2_data_in13,
     
     // Cnn Output Data
     CNN_out_result, CNN_out_data0, CNN_out_data1, CNN_out_data2, CNN_out_data3,
     CNN_out_data4, CNN_out_data5, CNN_out_data6, CNN_out_data7, CNN_out_data8,
     CNN_out_data9, CNN_out_data10, CNN_out_data11, CNN_out_data12, CNN_out_data13,
    
     // address
     ima_add_col,ima_add_row,
     fil_add_col1, fil_add_row1, fil_add_col2, fil_add_row2, fil_add_col3, fil_add_row3, fil_add_col4, fil_add_row4,
     
     wei1_add_col1, wei1_add_row1, wei1_add_col2, wei1_add_row2, wei1_add_col3, wei1_add_row3, wei1_add_col4, wei1_add_row4,
     wei1_add_col5, wei1_add_row5, wei1_add_col6, wei1_add_row6, wei1_add_col7, wei1_add_row7, wei1_add_col8, wei1_add_row8,
     wei1_add_col9, wei1_add_row9, wei1_add_col10, wei1_add_row10,
     
     wei2_add1, wei2_add2, wei2_add3, wei2_add4, wei2_add5, wei2_add6, wei2_add7,
     wei2_add8, wei2_add9, wei2_add10, wei2_add11, wei2_add12, wei2_add13, wei2_add14,
     /////////////////////////////////
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
        
    //memory enable signal
    input wr_en;
    input rd_en;
    input mem_en;
    
    //memory
    input wire [DWIDTH-1:0] addr_mem;
    input wire [CWIDTH-1:0] wr_data_mem;
    output reg [DWIDTH-1:0] rd_data_mem;
    
    output [IWIDTH-1:0] ima_add_row;
    output [IWIDTH-1:0] ima_add_col;
    output [FWIDTH-1:0] fil_add_row1;
    output [FWIDTH-1:0] fil_add_row2;
    output [FWIDTH-1:0] fil_add_row3;
    output [FWIDTH-1:0] fil_add_row4;
    output [FWIDTH-1:0] fil_add_col1;
    output [FWIDTH-1:0] fil_add_col2;
    output [FWIDTH-1:0] fil_add_col3;
    output [FWIDTH-1:0] fil_add_col4;
    output [W1_WIDTH_R-1:0] wei1_add_row1;
    output [W1_WIDTH_R-1:0] wei1_add_row2;
    output [W1_WIDTH_R-1:0] wei1_add_row3;
    output [W1_WIDTH_R-1:0] wei1_add_row4;
    output [W1_WIDTH_R-1:0] wei1_add_row5;
    output [W1_WIDTH_R-1:0] wei1_add_row6;
    output [W1_WIDTH_R-1:0] wei1_add_row7;
    output [W1_WIDTH_R-1:0] wei1_add_row8;
    output [W1_WIDTH_R-1:0] wei1_add_row9;
    output [W1_WIDTH_R-1:0] wei1_add_row10;
    output [W1_WIDTH_C-1:0] wei1_add_col1;
    output [W1_WIDTH_C-1:0] wei1_add_col2;
    output [W1_WIDTH_C-1:0] wei1_add_col3;
    output [W1_WIDTH_C-1:0] wei1_add_col4;
    output [W1_WIDTH_C-1:0] wei1_add_col5;
    output [W1_WIDTH_C-1:0] wei1_add_col6;
    output [W1_WIDTH_C-1:0] wei1_add_col7;
    output [W1_WIDTH_C-1:0] wei1_add_col8;
    output [W1_WIDTH_C-1:0] wei1_add_col9;
    output [W1_WIDTH_C-1:0] wei1_add_col10;
        
    output [W2_WIDTH-1:0] wei2_add1;
    output [W2_WIDTH-1:0] wei2_add2;
    output [W2_WIDTH-1:0] wei2_add3;
    output [W2_WIDTH-1:0] wei2_add4;
    output [W2_WIDTH-1:0] wei2_add5;
    output [W2_WIDTH-1:0] wei2_add6;
    output [W2_WIDTH-1:0] wei2_add7;
    output [W2_WIDTH-1:0] wei2_add8;
    output [W2_WIDTH-1:0] wei2_add9;
    output [W2_WIDTH-1:0] wei2_add10;
    output [W2_WIDTH-1:0] wei2_add11;
    output [W2_WIDTH-1:0] wei2_add12;
    output [W2_WIDTH-1:0] wei2_add13;
    output [W2_WIDTH-1:0] wei2_add14;
    
    output [CWIDTH-1:0] ima_data_in;
    output signed [CWIDTH-1:0] fil_data_in1;
    output signed [CWIDTH-1:0] fil_data_in2;
    output signed [CWIDTH-1:0] fil_data_in3;
    output signed [CWIDTH-1:0] fil_data_in4;
    
    output signed [CWIDTH-1:0] wei1_data_in0;
    output signed [CWIDTH-1:0] wei1_data_in1;
    output signed [CWIDTH-1:0] wei1_data_in2;
    output signed [CWIDTH-1:0] wei1_data_in3;
    output signed [CWIDTH-1:0] wei1_data_in4;
    output signed [CWIDTH-1:0] wei1_data_in5;
    output signed [CWIDTH-1:0] wei1_data_in6;
    output signed [CWIDTH-1:0] wei1_data_in7;
    output signed [CWIDTH-1:0] wei1_data_in8;
    output signed [CWIDTH-1:0] wei1_data_in9;
    
    output signed [CWIDTH-1:0] wei2_data_in0;
    output signed [CWIDTH-1:0] wei2_data_in1;
    output signed [CWIDTH-1:0] wei2_data_in2;
    output signed [CWIDTH-1:0] wei2_data_in3;
    output signed [CWIDTH-1:0] wei2_data_in4;
    output signed [CWIDTH-1:0] wei2_data_in5;
    output signed [CWIDTH-1:0] wei2_data_in6;
    output signed [CWIDTH-1:0] wei2_data_in7;
    output signed [CWIDTH-1:0] wei2_data_in8;
    output signed [CWIDTH-1:0] wei2_data_in9;
    output signed [CWIDTH-1:0] wei2_data_in10;
    output signed [CWIDTH-1:0] wei2_data_in11;
    output signed [CWIDTH-1:0] wei2_data_in12;
    output signed [CWIDTH-1:0] wei2_data_in13;
    
    output ima_wr_en;
    output fil_wr_en1;
    output fil_wr_en2;
    output fil_wr_en3;
    output fil_wr_en4;
    
    output wei1_wr_en1;
    output wei1_wr_en2;
    output wei1_wr_en3;
    output wei1_wr_en4;
    output wei1_wr_en5;
    output wei1_wr_en6;
    output wei1_wr_en7;
    output wei1_wr_en8;
    output wei1_wr_en9;
    output wei1_wr_en10;
    
    output wei2_wr_en1;
    output wei2_wr_en2;
    output wei2_wr_en3;
    output wei2_wr_en4;
    output wei2_wr_en5;
    output wei2_wr_en6;
    output wei2_wr_en7;
    output wei2_wr_en8;
    output wei2_wr_en9;
    output wei2_wr_en10;
    output wei2_wr_en11;
    output wei2_wr_en12;
    output wei2_wr_en13;
    output wei2_wr_en14;
    
    input wire [OWIDTH-1:0] CNN_out_result;       // prediction
    input wire signed [CWIDTH:0] CNN_out_data0;   // result of all calculation
    input wire signed [CWIDTH:0] CNN_out_data1;
    input wire signed [CWIDTH:0] CNN_out_data2;
    input wire signed [CWIDTH:0] CNN_out_data3;
    input wire signed [CWIDTH:0] CNN_out_data4;
    input wire signed [CWIDTH:0] CNN_out_data5;
    input wire signed [CWIDTH:0] CNN_out_data6;
    input wire signed [CWIDTH:0] CNN_out_data7;
    input wire signed [CWIDTH:0] CNN_out_data8;
    input wire signed [CWIDTH:0] CNN_out_data9;
    input wire signed [CWIDTH:0] CNN_out_data10;
    input wire signed [CWIDTH:0] CNN_out_data11;
    input wire signed [CWIDTH:0] CNN_out_data12;
    input wire signed [CWIDTH:0] CNN_out_data13;
    
    output [IWIDTH-1:0] con_add_row1;
    output [IWIDTH-1:0] con_add_col1;
    output [IWIDTH-1:0] con_add_row2;
    output [IWIDTH-1:0] con_add_col2;
    output [IWIDTH-1:0] con_add_row3;
    output [IWIDTH-1:0] con_add_col3;
    output [IWIDTH-1:0] con_add_row4;
    output [IWIDTH-1:0] con_add_col4;
    
    output [W1_WIDTH_R-1:0] inp_add_row;
    output [W1_WIDTH_C-1:0] inp_add_col;
    output [HWIDTH-1:0] hid_add;
    
    output ima_rd_en;
    output fil_rd_en1;
    output fil_rd_en2;
    output fil_rd_en3;
    output fil_rd_en4;
    output wei1_rd_en1;
    output wei1_rd_en2;
    output wei1_rd_en3;
    output wei1_rd_en4;
    output wei1_rd_en5;
    output wei1_rd_en6;
    output wei1_rd_en7;
    output wei1_rd_en8;
    output wei1_rd_en9;
    output wei1_rd_en10;
    output wei2_rd_en1;
    output wei2_rd_en2;
    output wei2_rd_en3;
    output wei2_rd_en4;
    output wei2_rd_en5;
    output wei2_rd_en6;
    output wei2_rd_en7;
    output wei2_rd_en8;
    output wei2_rd_en9;
    output wei2_rd_en10;
    output wei2_rd_en11;
    output wei2_rd_en12;
    output wei2_rd_en13;
    output wei2_rd_en14;
    output con_rd_en1;
    output con_rd_en2;
    output con_rd_en3;
    output con_rd_en4;
    output inp_rd_en;
    output hid_rd_en;
    output res_rd_en;
    
    input wire [CWIDTH-1:0] ima_out_data;
    input wire signed [CWIDTH-1:0] fil_out_data1;
    input wire signed [CWIDTH-1:0] fil_out_data2;
    input wire signed [CWIDTH-1:0] fil_out_data3;
    input wire signed [CWIDTH-1:0] fil_out_data4;
    input wire [CWIDTH-1:0] con_out_data1;
    input wire [CWIDTH-1:0] con_out_data2;
    input wire [CWIDTH-1:0] con_out_data3;
    input wire [CWIDTH-1:0] con_out_data4;
    input wire signed [CWIDTH-1:0] wei1_out_data1;
    input wire signed [CWIDTH-1:0] wei1_out_data2;
    input wire signed [CWIDTH-1:0] wei1_out_data3;
    input wire signed [CWIDTH-1:0] wei1_out_data4;
    input wire signed [CWIDTH-1:0] wei1_out_data5;
    input wire signed [CWIDTH-1:0] wei1_out_data6;
    input wire signed [CWIDTH-1:0] wei1_out_data7;
    input wire signed [CWIDTH-1:0] wei1_out_data8;
    input wire signed [CWIDTH-1:0] wei1_out_data9;
    input wire signed [CWIDTH-1:0] wei1_out_data10;
    input wire signed [CWIDTH-1:0] wei2_out_data1;
    input wire signed [CWIDTH-1:0] wei2_out_data2;
    input wire signed [CWIDTH-1:0] wei2_out_data3;
    input wire signed [CWIDTH-1:0] wei2_out_data4;
    input wire signed [CWIDTH-1:0] wei2_out_data5;
    input wire signed [CWIDTH-1:0] wei2_out_data6;
    input wire signed [CWIDTH-1:0] wei2_out_data7;
    input wire signed [CWIDTH-1:0] wei2_out_data8;
    input wire signed [CWIDTH-1:0] wei2_out_data9;
    input wire signed [CWIDTH-1:0] wei2_out_data10;
    input wire signed [CWIDTH-1:0] wei2_out_data11;
    input wire signed [CWIDTH-1:0] wei2_out_data12;
    input wire signed [CWIDTH-1:0] wei2_out_data13;
    input wire signed [CWIDTH-1:0] wei2_out_data14;
    input wire [CWIDTH-1:0] inp_out_data;
    input wire [CWIDTH-1:0] hid_out_data;
    //write enable sign assign
    assign ima_wr_en = (addr_mem[14:12] == 3'b000 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign fil_wr_en1 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd0 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign fil_wr_en2 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign fil_wr_en3 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign fil_wr_en4 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    
    assign wei1_wr_en1 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei1_wr_en2 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei1_wr_en3 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0; 
    assign wei1_wr_en4 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei1_wr_en5 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei1_wr_en6 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;      
    assign wei1_wr_en7 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei1_wr_en8 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei1_wr_en9 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei1_wr_en10 = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    
    assign wei2_wr_en1 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en2 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en3 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0; 
    assign wei2_wr_en4 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei2_wr_en5 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei2_wr_en6 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;      
    assign wei2_wr_en7 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei2_wr_en8 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei2_wr_en9 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;    
    assign wei2_wr_en10 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en11 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd11 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en12 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd12 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en13 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd13 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    assign wei2_wr_en14 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd14 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_en : 1'b0;
    //memory address assign (these will be used to write and read)
    assign {ima_add_row, ima_add_col} = (addr_mem[14:12] == 3'b000 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[9:5], addr_mem[4:0]} : 10'b0;
    assign {fil_add_row1, fil_add_col1} = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd0 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[3:2], addr_mem[1:0]} : 4'b0;
    assign {fil_add_row2, fil_add_col2} = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd1 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[3:2], addr_mem[1:0]} : 4'b0;
    assign {fil_add_row3, fil_add_col3} = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd2 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[3:2], addr_mem[1:0]} : 4'b0;
    assign {fil_add_row4, fil_add_col4} = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd3 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[3:2], addr_mem[1:0]} : 4'b0;
        
    assign {wei1_add_row1, wei1_add_col1} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;
    assign {wei1_add_row2, wei1_add_col2} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;
    assign {wei1_add_row3, wei1_add_col3} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0; 
    assign {wei1_add_row4, wei1_add_col4} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;    
    assign {wei1_add_row5, wei1_add_col5} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;    
    assign {wei1_add_row6, wei1_add_col6} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;      
    assign {wei1_add_row7, wei1_add_col7} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;    
    assign {wei1_add_row8, wei1_add_col8} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;    
    assign {wei1_add_row9, wei1_add_col9} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;    
    assign {wei1_add_row10, wei1_add_col10} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? {addr_mem[7:3], addr_mem[2:0]} : 8'b0;   
    
    assign wei2_add1 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add2 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add3 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add4 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add5 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;  
    assign wei2_add6 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;  
    assign wei2_add7 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add8 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add9 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;    
    assign wei2_add10 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add11 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd11 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add12 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd12 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add13 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd13 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    assign wei2_add14 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd14 && mem_en == 1'b1 && (wr_en==1 || rd_en==1)) ? addr_mem[3:0] : 4'b0;
    //memory input data
    assign ima_data_in = (addr_mem[14:12] == 3'b000 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign fil_data_in1 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd0 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign fil_data_in2 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign fil_data_in3 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign fil_data_in4 = (addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    
    assign {wei1_data_in0} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign {wei1_data_in1} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign {wei1_data_in2} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0; 
    assign {wei1_data_in3} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;    
    assign {wei1_data_in4} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;    
    assign {wei1_data_in5} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;      
    assign {wei1_data_in6} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;    
    assign {wei1_data_in7} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;    
    assign {wei1_data_in8} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;    
    assign {wei1_data_in9} = (addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    
    assign wei2_data_in0 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd1 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in1 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd2 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in2 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd3 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in3 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd4 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in4 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd5 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in5 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd6 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in6 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd7 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in7 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd8 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in8 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd9 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in9 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd10 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in10 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd11 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in11 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd12 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in12 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd13 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    assign wei2_data_in13 = (addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'd14 && mem_en == 1'b1 && wr_en ==1'b1) ? wr_data_mem[7:0] : 8'b0;
    //memory output data
    always @ (*)
    begin
        if(mem_en)
        begin
            if(rd_en)
            begin
                case(addr_mem[14:12])
                    3'b000:begin
                        rd_data_mem = {8'd0,ima_out_data};
                    end
                    3'b001:begin
                        case(addr_mem[5:4])
                            2'b00: rd_data_mem = {8'd0,fil_out_data1};
                            2'b01: rd_data_mem = {8'd0,fil_out_data2};
                            2'b10: rd_data_mem = {8'd0,fil_out_data3};
                            2'b11: rd_data_mem = {8'd0,fil_out_data4};
                        endcase
                    end
                    3'b010:begin
                        case(addr_mem[11:8])
                            4'b0001 : rd_data_mem = {8'd0,wei1_out_data1};
                            4'b0010 : rd_data_mem = {8'd0,wei1_out_data2};
                            4'b0011 : rd_data_mem = {8'd0,wei1_out_data3};
                            4'b0100 : rd_data_mem = {8'd0,wei1_out_data4};
                            4'b0101 : rd_data_mem = {8'd0,wei1_out_data5};
                            4'b0110 : rd_data_mem = {8'd0,wei1_out_data6};
                            4'b0111 : rd_data_mem = {8'd0,wei1_out_data7};
                            4'b1000 : rd_data_mem = {8'd0,wei1_out_data8};
                            4'b1001 : rd_data_mem = {8'd0,wei1_out_data9};
                            4'b1010 : rd_data_mem = {8'd0,wei1_out_data10};
                            default : rd_data_mem = 16'd0;
                        endcase
                    end
                    3'b011:begin
                        case(addr_mem[11:8])
                            4'b0001 : rd_data_mem = {8'd0,wei2_out_data1};
                            4'b0010 : rd_data_mem = {8'd0,wei2_out_data2};
                            4'b0011 : rd_data_mem = {8'd0,wei2_out_data3};
                            4'b0100 : rd_data_mem = {8'd0,wei2_out_data4};
                            4'b0101 : rd_data_mem = {8'd0,wei2_out_data5};
                            4'b0110 : rd_data_mem = {8'd0,wei2_out_data6};
                            4'b0111 : rd_data_mem = {8'd0,wei2_out_data7};
                            4'b1000 : rd_data_mem = {8'd0,wei2_out_data8};
                            4'b1001 : rd_data_mem = {8'd0,wei2_out_data9};
                            4'b1010 : rd_data_mem = {8'd0,wei2_out_data10};
                            4'b1011 : rd_data_mem = {8'd0,wei2_out_data11};
                            4'b1100 : rd_data_mem = {8'd0,wei2_out_data12};
                            4'b1101 : rd_data_mem = {8'd0,wei2_out_data13};
                            4'b1110 : rd_data_mem = {8'd0,wei2_out_data14};
                            default : rd_data_mem = 16'd0;
                        endcase
                    end
                    3'b100:begin
                        case(addr_mem[3:0])
                            4'b0001 : rd_data_mem = {7'd0,CNN_out_data0};
                            4'b0010 : rd_data_mem = {7'd0,CNN_out_data1};
                            4'b0011 : rd_data_mem = {7'd0,CNN_out_data2};
                            4'b0100 : rd_data_mem = {7'd0,CNN_out_data3};
                            4'b0101 : rd_data_mem = {7'd0,CNN_out_data4};
                            4'b0110 : rd_data_mem = {7'd0,CNN_out_data5};
                            4'b0111 : rd_data_mem = {7'd0,CNN_out_data6};
                            4'b1000 : rd_data_mem = {7'd0,CNN_out_data7};
                            4'b1001 : rd_data_mem = {7'd0,CNN_out_data8};
                            4'b1010 : rd_data_mem = {7'd0,CNN_out_data9};
                            4'b1011 : rd_data_mem = {7'd0,CNN_out_data10};
                            4'b1100 : rd_data_mem = {7'd0,CNN_out_data11};
                            4'b1101 : rd_data_mem = {7'd0,CNN_out_data12};
                            4'b1110 : rd_data_mem = {7'd0,CNN_out_data13};
                            4'b1111 : rd_data_mem = {12'd0,CNN_out_result};
                            default : begin
                                rd_data_mem = 16'd0;
                            end
                        endcase
                    end
                    3'b101:begin
                        case(addr_mem[11:10])
                            2'b00: rd_data_mem = {8'd0,con_out_data1};
                            2'b01: rd_data_mem = {8'd0,con_out_data2};
                            3'b10: rd_data_mem = {8'd0,con_out_data3};
                            4'b11: rd_data_mem = {8'd0,con_out_data4};
                        endcase
                    end
                    3'b110:begin
                        rd_data_mem = {8'd0,inp_out_data};
                    end
                    3'b111:begin
                        rd_data_mem = {8'd0,hid_out_data};
                    end
                endcase
            end
            else
            begin
                rd_data_mem = 16'd0;
            end
        end
        else
        begin
            rd_data_mem = 16'd0;
        end
    end
    //memory address( these will be used to only read)
    assign con_add_row1 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b00)) ? addr_mem[9:5] : 5'b0;
    assign con_add_col1 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b00)) ? addr_mem[4:0] : 5'b0;
    assign con_add_row2 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b01)) ? addr_mem[9:5] : 5'b0;
    assign con_add_col2 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b01)) ? addr_mem[4:0] : 5'b0;
    assign con_add_row3 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b10)) ? addr_mem[9:5] : 5'b0;
    assign con_add_col3 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b10)) ? addr_mem[4:0] : 5'b0;
    assign con_add_row4 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b11)) ? addr_mem[9:5] : 5'b0;
    assign con_add_col4 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b11)) ? addr_mem[4:0] : 5'b0;
    assign inp_add_row = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b110) ? addr_mem[7:3] : 5'b0;
    assign inp_add_col = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b110) ? addr_mem[2:0] : 3'b0;
    assign hid_add = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b111) ? addr_mem[3:0] : 4'b0;
    //read enable sign assign
    assign ima_rd_en = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b000) ? rd_en : 1'b0;
    
    assign fil_rd_en1 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'b00) ? rd_en : 1'b0;
    assign fil_rd_en2 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'b01) ? rd_en : 1'b0;
    assign fil_rd_en3 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'b10) ? rd_en : 1'b0;
    assign fil_rd_en4 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b001 && addr_mem[5:4] == 2'b11) ? rd_en : 1'b0;
    
    assign wei1_rd_en1 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0001) ? rd_en : 1'b0;
    assign wei1_rd_en2 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0010) ? rd_en : 1'b0;
    assign wei1_rd_en3 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0011) ? rd_en : 1'b0;
    assign wei1_rd_en4 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0100) ? rd_en : 1'b0;
    assign wei1_rd_en5 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0101) ? rd_en : 1'b0;
    assign wei1_rd_en6 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0110) ? rd_en : 1'b0;
    assign wei1_rd_en7 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b0111) ? rd_en : 1'b0;
    assign wei1_rd_en8 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b1000) ? rd_en : 1'b0;
    assign wei1_rd_en9 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b1001) ? rd_en : 1'b0;
    assign wei1_rd_en10 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b010 && addr_mem[11:8] == 4'b1010) ? rd_en : 1'b0;
    
    assign wei2_rd_en1 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0001) ? rd_en : 1'b0;
    assign wei2_rd_en2 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0010) ? rd_en : 1'b0;
    assign wei2_rd_en3 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0011) ? rd_en : 1'b0;
    assign wei2_rd_en4 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0100) ? rd_en : 1'b0;
    assign wei2_rd_en5 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0101) ? rd_en : 1'b0;
    assign wei2_rd_en6 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0110) ? rd_en : 1'b0;
    assign wei2_rd_en7 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b0111) ? rd_en : 1'b0;
    assign wei2_rd_en8 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1000) ? rd_en : 1'b0;
    assign wei2_rd_en9 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1001) ? rd_en : 1'b0;
    assign wei2_rd_en10 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1010) ? rd_en : 1'b0;
    assign wei2_rd_en11 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1011) ? rd_en : 1'b0;
    assign wei2_rd_en12 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1100) ? rd_en : 1'b0;
    assign wei2_rd_en13 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1101) ? rd_en : 1'b0;
    assign wei2_rd_en14 = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b011 && addr_mem[11:8] == 4'b1110) ? rd_en : 1'b0;
    
    assign res_rd_en = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b100) ? rd_en : 1'b0;
    
    assign con_rd_en1 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b00)) ? rd_en : 1'b0;
    assign con_rd_en2 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b01)) ? rd_en : 1'b0;
    assign con_rd_en3 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b10)) ? rd_en : 1'b0;
    assign con_rd_en4 = (mem_en == 1'b1 && rd_en == 1'b1 && (addr_mem[14:12] == 3'b101) && (addr_mem[11:10] == 2'b11)) ? rd_en : 1'b0;
    
    assign inp_rd_en = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b110) ? rd_en : 1'b0;
    
    assign hid_rd_en = (mem_en == 1'b1 && rd_en == 1'b1 && addr_mem[14:12] == 3'b111) ? rd_en : 1'b0;

endmodule