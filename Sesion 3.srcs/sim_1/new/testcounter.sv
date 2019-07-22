`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2019 21:34:19
// Design Name: 
// Module Name: testcounter
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
    logic reset;
    counter U1(.clk(clk),.reset(reset),.BCD(BCD));
    
    always #3 clk = ~clk;
    initial begin
       clk = 0;
       reset = 1;
       #5
       reset = 0;
       
    end
endmodule

