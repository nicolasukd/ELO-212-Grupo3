`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2019 10:30:55
// Design Name: 
// Module Name: testGlobal
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


module testGlobal();
    logic clk,reset,ONOFF,fib;
    logic [6:0]sevenSeg;
    
    Global U1(.clk(clk),.reset(reset),.ONOFF(ONOFF),.sevenSeg(sevenSeg),.fib(fib));
    always #5 clk = ~clk;
    
    initial begin
        clk = 1;
        reset = 1;
        #7
        reset = 0;
    end
endmodule
