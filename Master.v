`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 15:19:48
// Design Name: 
// Module Name: Master
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


module Master(		//SPI interface signals
    MISO,            //Master Slave output
    SS,             //slave select
    SCK,    //clock
    MOSI,  //Mater Slave input
    
    //parallel interface
    start,
    spi_done,                  //done flag after sending/recieving data
    tx_data,         //transmit data
    rx_data, //received data
    SCKdiv_val,              //clock divider value
    
    //general inputs
    clk,
    nRst
    );
    
    parameter DWIDTH = 16;    //witdh of each SPI transfer
    parameter SWIDTH = 8;    //Width of SCK witdh
    
    //SPI interface signals
    input MISO;            //Master input Slave output
    input SS;             //slave select
    output reg SCK;    //output clock
    output reg MOSI;  //Mater output Slave input
    
    //parallel interface
    input start;
    output reg spi_done;                  //done flag after sending/recieving data
    input [DWIDTH-1:0] tx_data;         //transmit data
    output reg [DWIDTH-1:0] rx_data; //received data
    input [7:0] SCKdiv_val;              //clock divider value
    
    //general inputs
    input clk;
    input nRst;
    
    reg [DWIDTH-1:0] tx_reg;
    wire [7:0] sck_cnt;
                    
    reg SCK_prev;        //value of SCK during the previous cycle of CLK
    
    localparam idle=2'b00;        
    localparam send=2'b10; 
    localparam finish=2'b11; 
    
    reg [1:0] state;
    //state machine
    always @(posedge clk or negedge nRst) begin
    if(~nRst) begin
    spi_done <=1'b0;
    tx_reg <= {(DWIDTH){1'b0}};
    state <= idle;    //idle state
    end else begin    //rising edge of clk
    case(state)
        idle: begin    //idle
            if(start) begin
                tx_reg <= tx_data;
                state <= send;    //next state is send, else stay idle
            end
        end
        send: begin    //send
            if(sck_cnt==DWIDTH) begin
                state <= finish;    //next sate is finish
                spi_done <= 1'b1;
            end
        end
        finish: begin    //finish
            spi_done <= 1'b0;
            state <= idle;        //next state is idle, always
        end
        default: begin
            state <= idle;
        end
    endcase
    end
    end
    
    //SCK Generator
    
    reg [7:0] SCKdiv_cnt;
    reg [7:0] SCKgen_cnt;
    always@(posedge clk or negedge nRst) begin
    if(!nRst) begin
    SCK <= 1'b1;
    SCKdiv_cnt <= 'd0;
    SCKgen_cnt <= 'd0;
    end else begin
    if(state==idle && start) begin
        SCKdiv_cnt <= 'd0;
        SCK <= 1'b1;
        SCKgen_cnt <= 'd0;
    end else    if((state == send) && (SCKgen_cnt<DWIDTH)) begin
        if(SCKdiv_cnt==SCKdiv_val) begin
            SCK <= ~SCK;
            SCKdiv_cnt <= 'd0;
            if(~SCK)    //only increment sck count upon rising edge of SCK
                SCKgen_cnt <= SCKgen_cnt +1;
        end else begin
            SCKdiv_cnt <= SCKdiv_cnt + 1; 
        end
    end //end of else    if(state == send) begin
    end //end of if(!nRst) begin
    end //end of always
    
    //SPI shifting and SCK counting
    assign sck_cnt = SCKgen_cnt;
    reg [7:0] sample_index;
    always @ (posedge clk or negedge nRst) begin        //SPI_reception
    if(~nRst) begin
    //sck_cnt <= {(SWIDTH){1'b0}};
    rx_data <= {DWIDTH{1'b0}};
    MOSI <= 1'b0;
    SCK_prev <= 1'b1;
    end else if(SS) begin    //Active low, if slave select is high (disable) 
    //sck_cnt <= {(SWIDTH){1'b0}};;
    //spi_done <= 0;
    MOSI <= 1'b0;
    SCK_prev <= 1'b1;
    end else begin
    if(SCK_prev && ~SCK) begin                 //falling edge on SCK, change MISO
        MOSI <= tx_reg[DWIDTH-sck_cnt-1];
        sample_index <= sck_cnt;
    end else if (~SCK_prev && SCK)begin     //rising edge on SCK, sample MOSI
        rx_data[DWIDTH-sample_index-1] <= MISO;
    end
    SCK_prev <= SCK;
    end
    end
endmodule
