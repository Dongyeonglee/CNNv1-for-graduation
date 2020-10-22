`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 21:03:11
// Design Name: 
// Module Name: FPGA_TOP
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


module FPGA_TOP(    
    //GPIO_SW_C,//start
    //GPIO_DIP_SW0,
	USER_SI570_P,
    USER_SI570_N,
    
    PMOD1_0,    //MOSI, input
    PMOD1_1,    //MISO, output
    PMOD1_2,    //SCK, input
    PMOD1_3,    //nSS, input

    PMOD1_4,    //start, input
    PMOD1_5,    //finish, output
    
    //PMOD1_7,    //reset
    
    //GPIO_LED_0,//for making sure about start
    GPIO_LED_2,//for making sure about finish

    CPU_RESET
    );
    
    //input GPIO_SW_C;
    //input GPIO_DIP_SW0;
    
    input USER_SI570_P;
    input USER_SI570_N;
    
    input PMOD1_0;  //MOSI
    output PMOD1_1;  //MISO
    input PMOD1_2;  //SCK
    input PMOD1_3;  //nSS
    
    input PMOD1_4;  //start
    output PMOD1_5;  //finish
    
    //input PMOD1_7;  //reset
    
    //output GPIO_LED_0;
    output GPIO_LED_2;
    
    input CPU_RESET;
    
    wire clk;
    wire reset;
    wire reset_sig;
    assign reset_sig = ~CPU_RESET;

    IBUFGDS #(.DIFF_TERM("FALSE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT")) cw1(
        // Clock out ports
        .O(clk),
        // Clock in ports
        .I(USER_SI570_P),
        .IB(USER_SI570_N)
        );
        
    IBUFG cw2(
            // Clock out ports
            .O(reset),
            .I(reset_sig)
            );
    
    //assign GPIO_LED_0 = PMOD1_4;
    assign GPIO_LED_2 = PMOD1_5;
   
TOP My_top(
    .MOSI(PMOD1_0),    //Mater output .Slave input
    .MISO(PMOD1_1),    //Master input .Slave output
    .SCK(PMOD1_2),      //SPI clock
    .nSS(PMOD1_3),      //slave select
    
    .start_sign(PMOD1_4),
    .finish_sign(PMOD1_5),
   
    .clk(clk),
    .reset(reset));
endmodule
