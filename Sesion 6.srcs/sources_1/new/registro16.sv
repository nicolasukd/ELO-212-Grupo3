`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2019 15:09:25
// Design Name: 
// Module Name: registro16
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


module registro16(
    input logic [15:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNC,BTNL,BTNR,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [15:0]LED
    );
    logic [15:0]digitos1,digitos2;
    logic clkout;
    clockdivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    logic [6:0]sevenSeg1,sevenSeg2,sevenSeg3,sevenSeg4,sevenSeg5,sevenSeg6,sevenSeg7,sevenSeg8;
    
    BCDto7 U1(.BCD(digitos1[15:12]),.sevenSeg(sevenSeg1));
    BCDto7 U2(.BCD(digitos1[11:8]),.sevenSeg(sevenSeg2));
    BCDto7 U3(.BCD(digitos1[7:4]),.sevenSeg(sevenSeg3));
    BCDto7 U4(.BCD(digitos1[3:0]),.sevenSeg(sevenSeg4));
    BCDto7 U5(.BCD(digitos2[15:12]),.sevenSeg(sevenSeg5));
    BCDto7 U6(.BCD(digitos2[11:8]),.sevenSeg(sevenSeg6));
    BCDto7 U7(.BCD(digitos2[7:4]),.sevenSeg(sevenSeg7));
    BCDto7 U8(.BCD(digitos2[3:0]),.sevenSeg(sevenSeg8));
    
    assign LED = SW;
    int count = 0;
    always_ff @(posedge clkout)begin
        count <= count + 1;
        if (BTNC == 1)begin
            digitos1 <= 16'd0;
            digitos2 <= 16'd0;
        end
        else if (BTNL == 1)begin
            digitos1 <= SW[15:0];
        end
        else if (BTNR == 1)begin
            digitos2 <= SW[15:0];
        end
        
        if (count == 1)begin
             AN <= 8'b01111111;
             CA <= sevenSeg1[6];
             CB <= sevenSeg1[5];
             CC <= sevenSeg1[4];
             CD <= sevenSeg1[3];
             CE <= sevenSeg1[2];
             CF <= sevenSeg1[1];
             CG <= sevenSeg1[0];
        end
        else if (count == 2)begin
             AN <= 8'b10111111;
             CA <= sevenSeg2[6];
             CB <= sevenSeg2[5];
             CC <= sevenSeg2[4];
             CD <= sevenSeg2[3];
             CE <= sevenSeg2[2];
             CF <= sevenSeg2[1];
             CG <= sevenSeg2[0];
        end
        else if (count == 3)begin
             AN <= 8'b11011111;
             CA <= sevenSeg3[6];
             CB <= sevenSeg3[5];
             CC <= sevenSeg3[4];
             CD <= sevenSeg3[3];
             CE <= sevenSeg3[2];
             CF <= sevenSeg3[1];
             CG <= sevenSeg3[0];
        end
        else if (count == 4)begin
             AN <= 8'b11101111;
             CA <= sevenSeg4[6];
             CB <= sevenSeg4[5];
             CC <= sevenSeg4[4];
             CD <= sevenSeg4[3];
             CE <= sevenSeg4[2];
             CF <= sevenSeg4[1];
             CG <= sevenSeg4[0];
        end
        else if (count == 5)begin
             AN <= 8'b11110111;
             CA <= sevenSeg5[6];
             CB <= sevenSeg5[5];
             CC <= sevenSeg5[4];
             CD <= sevenSeg5[3];
             CE <= sevenSeg5[2];
             CF <= sevenSeg5[1];
             CG <= sevenSeg5[0];
        end
        else if (count == 6)begin
             AN <= 8'b11111011;
             CA <= sevenSeg6[6];
             CB <= sevenSeg6[5];
             CC <= sevenSeg6[4];
             CD <= sevenSeg6[3];
             CE <= sevenSeg6[2];
             CF <= sevenSeg6[1];
             CG <= sevenSeg6[0];
        end
        else if (count == 7)begin
             AN <= 8'b11111101;
             CA <= sevenSeg7[6];
             CB <= sevenSeg7[5];
             CC <= sevenSeg7[4];
             CD <= sevenSeg7[3];
             CE <= sevenSeg7[2];
             CF <= sevenSeg7[1];
             CG <= sevenSeg7[0];
        end
        else if (count == 8)begin
             count <= 0;
             AN <= 8'b11111110;
             CA <= sevenSeg8[6];
             CB <= sevenSeg8[5];
             CC <= sevenSeg8[4];
             CD <= sevenSeg8[3];
             CE <= sevenSeg8[2];
             CF <= sevenSeg8[1];
             CG <= sevenSeg8[0];
        end
    end
endmodule
