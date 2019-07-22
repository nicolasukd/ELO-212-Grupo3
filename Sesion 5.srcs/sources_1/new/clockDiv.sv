`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2019 21:49:38
// Design Name: 
// Module Name: clockDiv
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


module clockDiv(
    inout logic CLK100MHZ,
    input logic CPU_RESETN,
    output logic clkout10,clkout30,clkout500
    );
    clockDivider #(5000000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout10));
    clockDivider #(1666666) treinta(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout30));
    clockDivider #(100000) quinientos(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout500));
endmodule
