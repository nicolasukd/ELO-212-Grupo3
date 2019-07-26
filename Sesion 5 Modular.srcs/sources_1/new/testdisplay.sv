`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2019 13:43:26
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
    input logic CLK100MHZ,
    input logic CPU_RESETN,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG
    );
    logic clkout;
    clockdivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    display U1(.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),.d1(4'd1),.d2(4'd2),.d3(4'd3),.d4(4'd4),.d5(4'd5),.d6(4'd6),.d7(4'd7),.d8(4'd8));
endmodule
