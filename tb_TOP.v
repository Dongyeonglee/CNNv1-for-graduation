`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/08 19:40:42
// Design Name: 
// Module Name: tb_TOP
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


module tb_TOP();

    parameter DWIDTH = 16;  //width of each SPI transfer
    // parameter CWIDTH = 14;  //Number of control signals needed for each converter
    
    //SC Conv x4  Signals
    wire MISO, MOSI, nSS, SCK;
    
    //global signals
    reg clk, clkS, nRst;
    
    //SPI Master
    reg [DWIDTH-1:0] addr;
    reg [DWIDTH-1:0] wr_data;  //transmit data
    reg [DWIDTH-1:0] addr_nxt;
    reg [DWIDTH-1:0] wr_data_nxt;  //transmit data
    wire [DWIDTH-1:0] rd_data; //received data
    wire [DWIDTH-1:0] rd_sig; //received signature from slave
    wire [7:0] SCK_div;
    
    //SPI Testing Signals
    reg spi_valid_data;
    reg spi_valid_data_p1;
    integer state_cnt_p1;
    
    reg spi_start;
    wire busy;
    wire spi_done;   //done flag after sending/recieving data
    reg [7:0] spi_done_pre;
    integer state_cnt; 
    reg spi_complete;  //SPI Write/Read operation has been completed 
    
    reg start_sign;
    wire finish_sign;
    reg [7:0] test_weight1_1[0:3253];
    
    wire [2:0] state_sign;
    wire spi_done_sign;
    reg [15:0] cscnt;
    
    //Clock/ Reset Generation
    always #100 clk= ~clk;
    always #99.9 clkS= ~clkS;
    //initializing clock and reset
    initial begin
    
        //force tb_TOP.top.CNN.resultlayer.mem[0] = 8'h2c;
        clk = 1'd0;
        clkS = 1'd0;
        nRst = 1'd0;
        start_sign = 1'b0;
        $readmemh("weight1_1.mem",test_weight1_1);
        #900;
        nRst = 1'd1;
        #88544900;//313135400
        start_sign = 1'b1;
        #400;
        start_sign = 1'b0;
        #1462750;//2589500
        start_sign = 1'b1;
        #400;
        start_sign = 1'b0;
    end
    
    always @ (posedge clk or negedge nRst)
    begin
        if( ~nRst )
        begin
            wr_data_nxt <= 0;
            cscnt <= 0;
        end
        else
        begin
            if(spi_done_sign)
            begin
                if (addr[15])
                begin
                    if(state_sign == 3'b001)
                    begin
                        wr_data_nxt     <= 0;
                        cscnt <= cscnt;
                    end
                    else
                    begin
                        wr_data_nxt     <= {8'b0,test_weight1_1[cscnt]};
                        cscnt <= cscnt + 1'b1;
                    end
                end
                else
                begin
                    wr_data_nxt     <= 0 ;
                    cscnt <= cscnt + 1;
                end
            end
            else
            begin
                if(addr[15])
                    wr_data_nxt     <=   {8'b0,test_weight1_1[cscnt]};
                else
                    wr_data_nxt     <= 0;
            end
        end
    end
    
    always @ (posedge clk or negedge nRst)
    begin
        if( ~nRst )
        begin
            wr_data <= 0;
        end
        else
        begin
            if( (state_cnt_p1 >= 2) && (state_cnt_p1 <= 335) )
            begin
                wr_data     <= wr_data_nxt;
            end
            else
            begin
                wr_data     <= 0;
            end
        end
    end
    
    //SPI Read Write Operation Test    
    assign SCK_div = 8'd1;
    always@(posedge clk or negedge nRst) begin
        if(~nRst) begin
            spi_start <= 1'b0;
            state_cnt <= 0;
            spi_valid_data_p1 = 0;
            state_cnt_p1 <= 'd0;
            addr        <= 'd0;
            wr_data     <= 'd0;
            spi_done_pre <= 8'b00000000;
            spi_complete <= 1'b0;
        end else begin
            if((spi_done_pre[7] ~^ spi_valid_data_p1) || (state_cnt<=1)) begin
                spi_valid_data_p1   <= spi_valid_data;
                spi_start   <= spi_valid_data;
                addr        <= addr_nxt;  
                //wr_data     <= wr_data_nxt;
                state_cnt_p1 <= state_cnt;
                if(state_cnt <= 10000) begin
                    state_cnt <= state_cnt +1;
                end else begin
                    spi_complete <= 1'b1;
                //    state_cnt <= 'd5;
                end
            end else begin
                spi_start <= 1'b0;
            end
            spi_done_pre <= {spi_done_pre[6:0], spi_done};
        end
    end
    
    reg [15:0] pscnt;
    
    always @(state_cnt or negedge nRst)
    begin
        if( !nRst )
        begin
            pscnt <= 0;
        end
        else
        begin
            if((state_cnt_p1 >= 2) && (state_cnt_p1 <= 29))
            begin
                pscnt <= 16'd28;
            end
            else if((29 < state_cnt_p1) && (state_cnt_p1 <= 41))
            begin
                pscnt <= 16'd3;
            end
            else if((41 < state_cnt_p1) && (state_cnt_p1 <= 321))
            begin
                pscnt <= 16'd7;
            end
            else if((321 < state_cnt_p1) && (state_cnt_p1 <= 335))
            begin
                pscnt <= 16'd10;
            end
            else if((1584 == state_cnt_p1))
            begin
                pscnt <= 16'd15;
            end
            else
            begin
                pscnt <= 0;
            end
        end
    end
    
    reg [3:0] nuum1;//weight1
    reg [2:0] cool1;//weight1
    reg [4:0] roow1;//weight1
    reg [3:0] nuum2;//weight2
    reg [3:0] roow2;
    reg [1:0] nuum3;//fiter
    reg [1:0] cool3;//fiter
    reg [1:0] roow3;//fiter
    reg [4:0] cool4;//image
    reg [4:0] roow4;//image
    reg [3:0] roow5;   
    always @(state_cnt or negedge nRst)
    begin
        if( !nRst )
        begin
            nuum1 <= 4'b0001;
            cool1 <= 0;
            roow1 <= 0;
            nuum2 <= 4'b0001;
            roow2 <= 0;
            nuum3 <= 0;
            cool3 <= 0;
            roow3 <= 0;
            cool4 <= 0;
            roow4 <= 0;
            roow5 <= 4'b0001;
        end
        else
        begin
            if((state_cnt_p1 >= 2) && (state_cnt_p1 <= 29))
            begin
                if(roow4 == 27)
                begin
                    roow4 <= 0;
                end
                else
                begin
                    roow4 <= roow4 + 1;
                end
            end
            else if((29 < state_cnt_p1) && (state_cnt_p1 <= 41))
            begin
                if(roow3 == 2)
                begin
                    roow3 <= 0;
                end
                else
                begin
                    roow3 <= roow3 + 1;
                end
            end
            else if((41 < state_cnt_p1) && (state_cnt_p1 <= 321))
            begin
                if(roow1 == 27)
                begin
                    roow1 <= 0;
                end
                else
                begin
                    roow1 <= roow1 + 1;
                end
            end
            else if((321 < state_cnt_p1) && (state_cnt_p1 <= 335))
            begin
                if(nuum2 == 14)
                begin
                    nuum2 <= 4'b0001;
                end
                else
                begin
                    nuum2 <= nuum2 + 1'b1;
                end
            end
            else
            begin
                roow1 <= 0;
                roow3 <= 0;
                roow4 <= 0;
                nuum2 <= 1;
            end
        end
    end
    always @(state_cnt or negedge nRst)
    begin
        if( !nRst )
        begin
            addr_nxt <= 0;
            wr_data_nxt <= 0;
            spi_valid_data <= 0;
        end
        else
        begin
            if((state_cnt_p1 >= 2) && (state_cnt_p1 <= 29))
            begin
                addr <= {1'b1,3'b000,2'b0,roow4,5'b0};
            end
            else if((29 < state_cnt_p1) && (state_cnt_p1 <= 32))
            begin
                addr <= {1'b1,3'b001,6'b0,2'b00,roow3,2'b00}; 
            end
            else if((32 < state_cnt_p1) && (state_cnt_p1 <= 35))
            begin
                addr <= {1'b1,3'b001,6'b0,2'b01,roow3,2'b00};         
            end
            else if((35 < state_cnt_p1) && (state_cnt_p1 <= 38))
            begin
                addr <= {1'b1,3'b001,6'b0,2'b10,roow3,2'b00};           
            end
            else if((38 < state_cnt_p1) && (state_cnt_p1 <= 41))
            begin
                addr <= {1'b1,3'b001,6'b0,2'b11,roow3,2'b00};              
            end
            else if((41 < state_cnt_p1) && (state_cnt_p1 <= 69))
            begin
                addr <= {1'b1,3'b010,4'b0001,roow1,3'b000};
            end
            else if((69 < state_cnt_p1) && (state_cnt_p1 <= 97))
            begin
                addr <= {1'b1,3'b010,4'b0010,roow1,3'b000};
            end
            else if((97 < state_cnt_p1) && (state_cnt_p1 <= 125))
            begin
                addr <= {1'b1,3'b010,4'b0011,roow1,3'b000};
            end
            else if((125 < state_cnt_p1) && (state_cnt_p1 <= 153))
            begin
                addr <= {1'b1,3'b010,4'b0100,roow1,3'b000};
            end
            else if((153 < state_cnt_p1) && (state_cnt_p1 <= 181))
            begin
                addr <= {1'b1,3'b010,4'b0101,roow1,3'b000};
            end
            else if((181 < state_cnt_p1) && (state_cnt_p1 <= 209))
            begin
                addr <= {1'b1,3'b010,4'b0110,roow1,3'b000};
            end
            else if((209 < state_cnt_p1) && (state_cnt_p1 <= 237))
            begin
                addr <= {1'b1,3'b010,4'b0111,roow1,3'b000};
            end
            else if((237 < state_cnt_p1) && (state_cnt_p1 <= 265))
            begin
                addr <= {1'b1,3'b010,4'b1000,roow1,3'b000};
            end
            else if((265 < state_cnt_p1) && (state_cnt_p1 <= 293))
            begin
                addr <= {1'b1,3'b010,4'b1001,roow1,3'b000};
            end
            else if((293 < state_cnt_p1) && (state_cnt_p1 <= 321))
            begin
                addr <= {1'b1,3'b010,4'b1010,roow1,3'b000};
            end
            else if((321 < state_cnt_p1) && (state_cnt_p1 <= 335))
            begin
                addr <= {1'b1,3'b011,nuum2,4'b0,4'b0};       
            end
            else if((1584 == state_cnt_p1))
            begin
                addr <= {1'b0,3'b100,4'b0,4'b0,4'b0001};  
            end
            else
            begin
                addr <= 16'd0;
            end
        end
    end

always @(state_cnt or negedge nRst)
begin
    if( !nRst )
    begin
        addr_nxt <= 0;
        wr_data_nxt <= 0;
        spi_valid_data <= 0;
    end
    else
    begin
        if((state_cnt >= 2) && (state_cnt <= 29))
        begin
            spi_valid_data <= 1'b1;  
        end
        else if((29 < state_cnt) && (state_cnt <= 32))
        begin
            spi_valid_data <= 1'b1;                
        end
        else if((32 < state_cnt) && (state_cnt <= 35))
        begin
            spi_valid_data <= 1'b1;                
        end
        else if((35 < state_cnt) && (state_cnt <= 38))
        begin
            spi_valid_data <= 1'b1;                
        end
        else if((38 < state_cnt) && (state_cnt <= 41))
        begin
            spi_valid_data <= 1'b1;                
        end
        else if((41 < state_cnt) && (state_cnt <= 69))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((69 < state_cnt) && (state_cnt <= 97))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((97 < state_cnt) && (state_cnt <= 125))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((125 < state_cnt) && (state_cnt <= 153))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((153 < state_cnt) && (state_cnt <= 181))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((181 < state_cnt) && (state_cnt <= 209))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((209 < state_cnt) && (state_cnt <= 237))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((237 < state_cnt) && (state_cnt <= 265))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((265 < state_cnt) && (state_cnt <= 293))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((293 < state_cnt) && (state_cnt <= 321))
        begin
            spi_valid_data <= 1'b1;
        end
        else if((321 < state_cnt) && (state_cnt <= 335))
        begin
            spi_valid_data <= 1'b1;            
        end
        else if((1584 == state_cnt))
        begin
            spi_valid_data <= 1'b1;
        end        
        else
        begin
            spi_valid_data <= 1'b0;
        end
    end
end
    
    //SPI Read Verification Test
    always@(posedge clk or negedge nRst) begin
        if(~nRst) begin
        end else begin
            if(spi_done) begin
                //$write("\nState_cnt value is : %3d - ", state_cnt_p1);
                if(!addr[15]) begin                //value was read////31
                    $display("%3d) --Read value from mem[%3d]: %3d (\"%s\")", state_cnt_p1, addr[14:0], rd_data, rd_data);//////30
                end
            end
        end
    end
    
    Master_Top SPIMT(
    
    .MISO(MISO),         //Master .Slave output
    .SS(nSS),     //slave select
    .SCK(SCK),    //.clock
    .MOSI(MOSI),   //Mater .Slave input
    
    //parallel interface
    .addr(addr),
    .wr_data(wr_data),  //transmit data
    .rd_data(rd_data), //received data
    .rd_sig(rd_sig), //received data
    .start(spi_start),
    .busy(busy),
    .done(spi_done),   //done flag after sending/recieving data
    
    //clock divider value
    .SCK_div(8'd3),    //f_SCK = f_clk/(2*(SCK_div+1))
    
    .NoD(pscnt),
    .spi_done_sign(spi_done_sign),
    .state_sign(state_sign),
    //general inputs
    .clk(clk),        .nRst(nRst)
    );
    
    
    TOP top(
    
    .MOSI(MOSI),
    .MISO(MISO),
    .SCK(SCK),
    .nSS(nSS),

    .start_sign(start_sign),
    .finish_sign(finish_sign),
    .clk(clkS),
    .reset(nRst)
    );

endmodule
