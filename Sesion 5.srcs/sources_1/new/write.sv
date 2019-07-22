`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2019 21:18:04
// Design Name: 
// Module Name: write
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


module write(
    input logic [15:0]BCD,
    input logic clkin,
    input logic reset,
    output logic [7:0]an,
    output logic C_A,C_B,C_C,C_D,C_E,C_F,C_G
    );
    logic clkout;
    clockDivider #(10000) diez(.clkin(clkin),.reset(reset),.clkout(clkout));
    logic [6:0]sevenSeg1,sevenSeg2,sevenSeg3,sevenSeg4;
    int count = 2'b00;
    BCDto7 U1(.BCD(BCD[15:12]),.sevenSeg(sevenSeg1));
    BCDto7 U2(.BCD(BCD[11:8]),.sevenSeg(sevenSeg2));
    BCDto7 U3(.BCD(BCD[7:4]),.sevenSeg(sevenSeg3));
    BCDto7 U4(.BCD(BCD[3:0]),.sevenSeg(sevenSeg4));
    always_ff @(posedge clkout)begin
        count <= count + 1;
        if (count == 1)begin
             an <= 8'b01111111;
             C_A <= sevenSeg1[6];
             C_B <= sevenSeg1[5];
             C_C <= sevenSeg1[4];
             C_D <= sevenSeg1[3];
             C_E <= sevenSeg1[2];
             C_F <= sevenSeg1[1];
             C_G <= sevenSeg1[0];
        end
        else if (count == 2)begin
             an <= 8'b10111111;
             C_A <= sevenSeg2[6];
             C_B <= sevenSeg2[5];
             C_C <= sevenSeg2[4];
             C_D <= sevenSeg2[3];
             C_E <= sevenSeg2[2];
             C_F <= sevenSeg2[1];
             C_G <= sevenSeg2[0];
        end
        else if (count == 3)begin
             an <= 8'b11111101;
             C_A <= sevenSeg3[6];
             C_B <= sevenSeg3[5];
             C_C <= sevenSeg3[4];
             C_D <= sevenSeg3[3];
             C_E <= sevenSeg3[2];
             C_F <= sevenSeg3[1];
             C_G <= sevenSeg3[0];
        end
        else if (count == 4)begin
             an <= 8'b11111110;
             C_A <= sevenSeg4[6];
             C_B <= sevenSeg4[5];
             C_C <= sevenSeg4[4];
             C_D <= sevenSeg4[3];
             C_E <= sevenSeg4[2];
             C_F <= sevenSeg4[1];
             C_G <= sevenSeg4[0];
             count <= 0;
        end
    end
endmodule
