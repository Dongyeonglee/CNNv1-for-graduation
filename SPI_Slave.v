`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/09 14:12:35
// Design Name: 
// Module Name: SPI_Slave
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


module SPI_Slave(
    //SPI Interface
    MOSI,
    MISO,
    SCK,
    SS,
    
    //parallel Interface
    spi_data_in,
    spi_data_out,
    spi_done,
    
    //general inputs
    clk,
    rst_n
    );
    
    parameter DWIDTH = 16; //width of each SPI transfer
    parameter SWIDTH = 8; //width of SCK width
    
    //SPI Interface
    input wire MOSI;
    output reg MISO;
    input wire SCK;
    input wire SS;
    
    //Parallel Interface
    input wire [DWIDTH-1:0] spi_data_in; //addr and data value
    output reg [DWIDTH-1:0] spi_data_out; //addr and data value
    output reg spi_done;
    
    //general inputs
    input clk;
    input rst_n;
    
    reg [DWIDTH-1:0] spi_in_reg;
    wire [DWIDTH-1:0] spi_in_mux;
    
    reg [SWIDTH-1:0] sck_cnt;
    
    reg SCK_prev; //value of SCK during the previous cycle of HCLK
    
    assign spi_in_mux = (sck_cnt == 0) ? spi_data_in : spi_in_reg; //during first cycle use in_data, afterwards use in_buffer(in_reg)
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_in_reg <= {(DWIDTH){1'b0}};
            sck_cnt <= {(DWIDTH){1'b0}};
            spi_done <= 1'b0;
            MISO <= 1'b0;
            SCK_prev <= 1'b1;
            spi_data_out <= {(DWIDTH){1'b0}};
        end
        else if(SS) begin
            spi_in_reg <= {(DWIDTH){1'b0}};
            sck_cnt <= {(DWIDTH){1'b0}};
            spi_done <= 1'b0;
            MISO <= 1'b0;
            SCK_prev <= 1'b1;
        end
        else begin
            if(SCK_prev && ~SCK) begin //falling edge on SCK, change MISO
                MISO <= spi_in_mux[16-sck_cnt[4:0]-1];
                spi_done <= 1'b0;
                
                if(sck_cnt == 'd0) begin
                    spi_in_reg <= spi_data_in; //save spi_in_register and send to spi_in_mux
                end
            end
            else if(~SCK_prev && SCK) begin
                    spi_data_out[DWIDTH-sck_cnt-1] <= MOSI;
                    
                    //SCK counter
                    if(sck_cnt == $unsigned(DWIDTH-1)) begin
                        sck_cnt <= 8'd0;
                        spi_done <= 1'b1;
                    end
                    else begin
                        spi_done <= 1'b0;
                        sck_cnt <= sck_cnt + 1;
                    end
                    
            end
            else begin
                spi_done <= 1'b0;
            end
            SCK_prev <= SCK;
        end
    end
endmodule
