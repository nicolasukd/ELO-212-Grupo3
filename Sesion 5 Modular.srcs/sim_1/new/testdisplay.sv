`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2019 14:11:02
// Design Name: 
// Module Name: testdisplay
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


module testdisplay(

    );
    logic [7:0]an;
    logic [6:0]sevenSeg;
    logic clk,reset;
    logic [3:0]d1,d2,d3,d4,d5,d6,d7,d8;
    display U1(.an(an),.sevenSeg(sevenSeg),.clk(clk),
    .reset(reset),.d1(d1),.d2(d2),.d4(d4),.d5(d5),.d7(d7),.d8(d8));
    
    always #5 clk = ~clk;
    initial begin
        clk=0;
        reset=0;
        #3
        reset=1;
        d1=4'd1;
        d2=4'd2;
        d3=4'd3;
        d4=4'd4;
        d5=4'd5;
        d6=4'd6;
        d7=4'd7;
        d8=4'd8;
    end
endmodule
