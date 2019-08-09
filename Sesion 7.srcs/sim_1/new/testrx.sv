`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2019 22:37:26
// Design Name: 
// Module Name: testrx
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


module testrx(

    );
    logic clk,reset,PB;
    logic [7:0]in,estado;
    logic [15:0]op1,op2;
    logic [1:0]cmd;
    
    rx_control U1(.clk(clk),.reset(reset),.rx_ready(PB),.rx_in_data(in),.rx_out1_data(op1),.rx_out2_data(op2),.alu_ctrl(cmd),.estado(estado));
    
    always #5 clk = ~clk;
     
    initial begin
        reset = 1;
        clk = 1;
        #60
        reset = 0;
        #40
        in = 8'b11111111;
        #30
        PB = 1;
        #50
        PB = 0;
        #40
        in = 8'd0;
        #30
        PB = 1;
        #50
        PB = 0;
        #40
        in = 8'b10101010;
        #30
        PB = 1;
        #50
        PB = 0;
        #40
        in = 8'b10101010;
        #30
        PB = 1;
        #50
        PB = 0;
        #40
        in = 8'b10101001;
        #30
        PB = 1;
        #50
        PB = 0;
       
        
    end
endmodule
