`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS Lab, CBNU
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 03/17/2020 10:28:51 AM
// Design Name: Approximate Adder
// Module Name: approx_adder_4th
// Project Name: Convolution Neural Network (CNN) Accelerator
// Target Devices: ASIC 
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


module approx_adder_4th #(

   parameter DW = 20,
   parameter PORTION = 4

   )                  (
   
   input [DW-1:0] a , b, 
   output [DW-1:0]   c 

    );
     
     wire [DW-1: (DW/PORTION) -1] W1 ; 
     //reg [DW:0] c;
       
           genvar i; 
           
           generate 
           
               for (i=0; i < ((DW/PORTION)); i=i+1) begin 
               
                 or (c[i],a[i],b[i]); 
                   
               end 
           endgenerate
       
             
      // and (carry_in, a[(DW/4)-1] , b[(DW/4)-1]); 
        
            genvar k;
            
            generate 
                
                for (k= (DW/PORTION) ; k<DW ; k=k+1) begin 
                
                    full_adder FA_k  (.a(a[k]) , .b(b[k]), .carry_in(W1[k-1]), .s(c[k]) , .carry_out(W1[k])); 
                                 
                 end
                 //assign c[DW] = W1[DW];
                 
              endgenerate 
    
     and (W1[(DW/PORTION)-1], a[(DW/PORTION)-1] , b[(DW/PORTION)-1]);   
    
       
    // FA_k full_adder (.a(a[(DW/2)]) , .b(b[(DW/2)]), .carry_in(W1[k-1]), .s(c[k]) , .carry_out(W1[k])); 
     
    //assign c[DW] = W1[DW-1];
endmodule
