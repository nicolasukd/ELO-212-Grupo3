`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2019 18:35:28
// Design Name: 
// Module Name: testBCDto7
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


module testcounter();
    logic [3:0] BCD ;
    logic clk ;
    logic reset
    counter U1(.clk(clk),.reset(reset),.BCD(BCD));
    
    always #5 clk = -clk;
    initial begin
       
       
    end
endmodule
