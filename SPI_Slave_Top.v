`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 14:12:35
// Design Name: 
// Module Name: SPI_Slave_Top
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


module SPI_Slave_Top(
    MOSI,
    MISO,
    SCK,
    SS,
    
    //general inputs
    clk,
    rst_n,
    
    wr_en,
    rd_en,
    mem_en,
    addr_mem,
    
    wr_data_mem,
    rd_data_mem
    );
        
    parameter DWIDTH = 16; //width of each SPI transfer
    //parameter SWIDTH = 8; //width of SCK width

    //SPI Interface
    input MOSI;
    output MISO;
    input wire SCK;
    input wire SS;
    
    //general inputs
    input clk;
    input rst_n;
    
    output wire wr_en;
    output wire rd_en;
    output wire mem_en;
    output wire [DWIDTH-1:0] addr_mem;
        
    output [DWIDTH-1:0] wr_data_mem;
    input [DWIDTH-1:0] rd_data_mem;
        
    reg spi_status;
    reg [DWIDTH-1:0] aphase_inoutbuff;
    
    reg  [DWIDTH-1:0] in_data;
    wire [DWIDTH-1:0] out_data;
    
    wire spi_done;

    //Handling SPI phases (Address phase and DATA phase)
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin
            spi_status <= 1'b0;
            aphase_inoutbuff <= {DWIDTH{1'b0}};
        end
        else if(SS) begin
            spi_status <= 1'b0;
        end
        else begin
            if(spi_done) begin
                if(~spi_status) begin //first transfer in SPI transanction
                    if(out_data[DWIDTH-1])
                        aphase_inoutbuff <= out_data;
                    else
                        aphase_inoutbuff <= out_data + 1;
                    spi_status <= 1'b1;
                end else begin
                    aphase_inoutbuff <= aphase_inoutbuff + 1'b1;/////////////////////new
                    //this is second (or higher) transfer completed
                end
            end
        end
    end
    
    //sample the data coming from the memory
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin
            in_data <= {(DWIDTH-1){1'b0}};
        end
        else begin
            if (mem_en) begin
                if(rd_en) begin
                    in_data <= rd_data_mem;
                end else if (wr_en) begin
                    in_data <= "w_ok";
                end
            end
            
        end
    end
    assign addr_mem = ((spi_status == 0) && spi_done) ? out_data[DWIDTH-1:0] : aphase_inoutbuff;
    //assign in_data = rd_data_mem;
    assign wr_data_mem = out_data;
    assign wr_en = addr_mem[DWIDTH-1] && spi_done && spi_status; //addr[31] is W/R bit, 0-Read, 1-Write.
    assign rd_en = (~addr_mem[DWIDTH-1]) && spi_done;// && (~spi_status)////////////////////////////////////////////////
    assign mem_en = spi_done;

    SPI_Slave SPI_Slave(
        //SPI Interface
        .MOSI(MOSI),
        .MISO(MISO),
        .SCK(SCK),
        .SS(SS),
        
        //parallel Interface
        .spi_data_in(in_data),
        .spi_data_out(out_data),
        .spi_done(spi_done),
        
        //general inputs
        .clk(clk),
        .rst_n(rst_n)
        );
endmodule
