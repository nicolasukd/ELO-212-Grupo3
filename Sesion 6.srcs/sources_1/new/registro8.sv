`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2019 14:41:20
// Design Name: 
// Module Name: registro8
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


module registro8(
    input logic [7:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNC,BTNU,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [7:0]LED
    );
    logic [7:0]digitos;
    logic clkout;
    clockdivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    logic [6:0]sevenSeg1,sevenSeg2;
    
    BCDto7 U1(.BCD(digitos[3:0]),.sevenSeg(sevenSeg1));
    BCDto7 U2(.BCD(digitos[7:4]),.sevenSeg(sevenSeg2));
    
    assign LED = SW;
    int count = 0;
    always_ff @(posedge clkout)begin
        count <= count + 1;
        if (BTNU == 1)begin
            digitos <= 8'b00000000;
        end
        if (BTNC == 1)begin
            digitos <= SW[7:0];
        end
        
        if (count == 1)begin
             AN <= 8'b11111110;
             CA <= sevenSeg1[6];
             CB <= sevenSeg1[5];
             CC <= sevenSeg1[4];
             CD <= sevenSeg1[3];
             CE <= sevenSeg1[2];
             CF <= sevenSeg1[1];
             CG <= sevenSeg1[0];
        end
        else if (count == 2)begin
             AN <= 8'b11111101;
             CA <= sevenSeg2[6];
             CB <= sevenSeg2[5];
             CC <= sevenSeg2[4];
             CD <= sevenSeg2[3];
             CE <= sevenSeg2[2];
             CF <= sevenSeg2[1];
             CG <= sevenSeg2[0];
             count <= 0;
        end
    end
endmodule