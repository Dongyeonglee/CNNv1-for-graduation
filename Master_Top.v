`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 15:19:48
// Design Name: 
// Module Name: Master_Top
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


module Master_Top(	MISO,         //Master input Slave output
    SS,     //slave select
    SCK,    //output clock
    MOSI,   //Mater output Slave input
    
    //parallel interface
    addr,
    wr_data,  //transmit data
    rd_data, //received data
    rd_sig,    //received signature from slave (during address phase)
    start,
    busy,
    done,   //done flag after sending/recieving data
    SCK_div,                      //clock divider
    
    NoD,
    spi_done_sign,
    state_sign,
    //general inputs
    clk,
    nRst
    );
    
    parameter DWIDTH = 16;    //width of each SPI transfer
    
    input MISO;         //Master input Slave output
    output SS;     //slave select
    output SCK;    //output clock
    output MOSI;   //Mater output Slave input
    
    //parallel interface
    input [DWIDTH-1:0] addr;
    input [DWIDTH-1:0] wr_data;  //transmit data
    output reg [DWIDTH-1:0] rd_data; //received data
    output reg [DWIDTH-1:0] rd_sig; //received data
    input start;
    output  busy;
    output reg done;   //done flag after sending/recieving data
    input [7:0] SCK_div;                      //clock divider
    
    input [15:0] NoD;
    
    //general inputs
    input clk;
    input nRst;
    
    output spi_done_sign;
    output [2:0] state_sign;
    
    localparam idle     =3'b000;    //idle phase, new transfer can start, subject to spi_start signal
    localparam aphase =3'b001;    //address phase of SPI transaction
    localparam holdp     =3'b010;    //hold phase between address and data phases
    localparam dphase =3'b011;    //data phase of SPI transaction
    localparam endp     =3'b100;//100    //wait at the end of data phase
    
    reg [15:0] CoD;
    
    reg [2:0] state;
    
    reg [DWIDTH-1:0] tx_data;        //data to be sent via SPI
    wire [DWIDTH-1:0] rx_data;        //data to be received via SPI
    reg spi_start;
    
    wire spi_done;
    
    //storage register for data to be sent during address phase
    reg [DWIDTH-1:0] dphase_wrdata;  //data to be written to address
    
    reg [7:0] SCKdiv_val;
    reg [7:0] dly_cntr;
    
    assign spi_done_sign = spi_done;
    assign state_sign = state;
    
    always@(posedge clk or negedge nRst) begin
    if(~nRst) begin
        spi_start <= 1'b0;
        state <= idle;
        done <= 1'b0;
        rd_data <= {(DWIDTH){1'b0}};
        rd_sig  <= {(DWIDTH){1'b0}};
        tx_data <= {(DWIDTH){1'b0}};
        dphase_wrdata <= {(DWIDTH){1'b0}};
        dly_cntr <= 'd0;
        SCKdiv_val <= 8'd0;  //SCK_div;        //f_SCK = f_CLK/(2*(SCK_div+1))
        CoD <= 0;
    end else begin
        case(state)
            idle: begin
                done <= 1'b0;
                CoD <= 0;
                if(start &&(~busy)) begin
                    SCKdiv_val <= SCK_div;        //f_SCK = f_CLK/(2*(SCK_div+1))
                    //dphase_wrdata    <= wr_data;    //storing data to be sent during dphase
                    rd_sig  <= {(DWIDTH){1'b0}};/////////////////////
                    tx_data <= addr;
                    spi_start <= 1'b1;
                    state <= aphase;    //start of address phase
                end
            end
            aphase: begin
                if(~spi_done) begin    //this is still address phase
                    spi_start <= 1'b0;
                end else begin        //end of data phase
                    //tx_data <= wr_data;////////////////////////////////////
                    
                    //read signature data send by slave during address phase (optional)
                    rd_sig   <= rx_data;
                    
                    spi_start <= 1'b0;
                    state <= holdp;    //start of data phase
                    dly_cntr <= 'd0;
                end
            end
            holdp: begin
                if(dly_cntr == SCKdiv_val) begin
                    tx_data <= wr_data;/////////////////////////////////////
                    spi_start <= 1'b1;
                    state <= dphase;    //start of data phase
                    dly_cntr <= 'd0;
                end else begin
                    dly_cntr <= dly_cntr + 1;
                end
            end
            dphase: begin
                if(~spi_done) begin    //data phase transfer has not completed yet 
                    spi_start <= 1'b0;
                end else begin        //end data phase
                    tx_data <= wr_data;
                    if(CoD == NoD-1)
                    begin
                        //no need to send any new datatx_data <= dphase_wrdata;
                        rd_data <= rx_data;
                        state <= endp;    //end of data phase, goto "end" phase
                        dly_cntr <= 'd0;
                        CoD <= 1'b0;
                    end
                    else
                    begin
                        //no need to send any new datatx_data <= dphase_wrdata;
                        rd_data <= rx_data;
                        state <= holdp;    //end of data phase, goto "end" phase
                        dly_cntr <= 'd0;
                        CoD <= CoD + 1'b1;
                    end
                end
            end
            endp: begin
                if(dly_cntr == SCKdiv_val) begin
                    state <= idle;        //goto idle phase
                    dly_cntr <= 'd0;
                    done <= 1'b1;
                end else begin
                    dly_cntr <= dly_cntr + 1;
                end
            end
        endcase
        
    end
    end
    assign SS = ~(state[2] | state[1] | state[0]);
    assign busy = ~SS;
    
    Master SPIM1(
    .MISO(MISO),    //Master input Slave output
    .SS(SS),            //slave select
    .SCK(SCK),        //output clock
    .MOSI(MOSI),   //Mater output Slave input
    
    .start(spi_start),
    .spi_done(spi_done),    //done flag after sending/recieving data
    .tx_data(tx_data),    //transmit data
    .rx_data(rx_data),    //received data
    
    //clock divider value
    .SCKdiv_val(SCKdiv_val),    //f_SCK = f_clk/(2*(SCKdiv+1))
                
    //general inputs
    .clk(clk),        .nRst(nRst)
    );
endmodule