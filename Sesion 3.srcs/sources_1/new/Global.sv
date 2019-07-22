`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 10:19:05
// Design Name: 
// Module Name: Global
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


module Global(
    input logic clk,reset,
    output logic [6:0] sevenSeg,
    output logic ONOFF,fib
    );
    logic [3:0]BCD;
    counter U0(.clk(clk),.reset(reset),.BCD(BCD));
    BCDto7 U1(.BCD(BCD),.sevenSeg(sevenSeg));
    fibRec U2(.BCD(BCD),.fib(fib));
    
endmodule
