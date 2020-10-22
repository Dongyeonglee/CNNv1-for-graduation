`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:28:24
// Design Name: 
// Module Name: MES
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


module MES( clk, reset, chip_en, read_en, cv_write_en, input_write_en, cv_read_en, input_read_en, hidden_read_en, fully_en, result_write_en, result_read_en );

    input clk;
    input reset;
    input chip_en;
    output reg read_en;
    output reg cv_write_en;
    output reg input_write_en;
    output reg cv_read_en;
    output reg input_read_en;
    output reg hidden_read_en;
    output reg fully_en;
    output reg result_write_en;
    output reg result_read_en;
    
    reg [10:0] cnt;
    always @ (*)
    begin
        if(chip_en)
        begin
            if(cnt==0)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1 && cnt < 3)
            begin
                read_en = 1'b1;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;            
            end
            else if(cnt >= 3 && cnt < 785)
            begin
                read_en = 1'b1;
                cv_write_en = 1'b1;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;   
            end
            else if(cnt >= 785 && cnt < 786)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b1;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;  
            end
            else if(cnt >= 786 && cnt < 787)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b1;
                input_write_en = 1'b1;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;  
            end
            else if(cnt >= 787 && cnt < 836)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b1;
                cv_read_en = 1'b1;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;  
            end
            else if(cnt >= 836 && cnt < 838)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b1;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;  
            end
            else if(cnt >= 838 && cnt < 1116)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b1;
                hidden_read_en = 1'b0;
                fully_en = 1'b1;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1116 && cnt < 1118)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b1;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1118 && cnt < 1119)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1119 && cnt < 1123)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b1;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1123 && cnt < 1133)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b1;
                fully_en = 1'b0;
                result_write_en = 1'b1;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1133 && cnt < 1137)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b1;
                result_read_en = 1'b0;
            end
            else if(cnt >= 1137 && cnt < 1151)
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b1;
            end
            else
            begin
                read_en = 1'b0;
                cv_write_en = 1'b0;
                input_write_en = 1'b0;
                cv_read_en = 1'b0;
                input_read_en = 1'b0;
                hidden_read_en = 1'b0;
                fully_en = 1'b0;
                result_write_en = 1'b0;
                result_read_en = 1'b0;
            end
        end
        else
        begin
            read_en = 1'b0;
            cv_write_en = 1'b0;
            input_write_en = 1'b0;
            cv_read_en = 1'b0;
            input_read_en = 1'b0;
            hidden_read_en = 1'b0;
            fully_en = 1'b0;
            result_write_en = 1'b0;
            result_read_en = 1'b0;
        end
    end
    always @ (posedge clk or negedge reset)
    begin
        if( !reset )
        begin
            cnt <= 0;
        end
        else
        begin
            if(chip_en)
            begin
                cnt <= cnt + 1'b1;
            end
            else
            begin
                cnt <= 0;
            end
        end
    end
endmodule
