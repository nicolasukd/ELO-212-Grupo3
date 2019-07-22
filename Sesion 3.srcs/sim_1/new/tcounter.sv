`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 10:54:57
// Design Name: 
// Module Name: tcounter
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


module tcounter();
     logic [3:0]BCD;
    logic clk,reset;
    
    counter U1(.clk(clk),.reset(reset),.BCD(BCD));
    always #5 clk = ~clk;
    
    initial begin
        clk = 1;
        reset = 1;
        #3
        reset = 0;
    end
    
endmodule
