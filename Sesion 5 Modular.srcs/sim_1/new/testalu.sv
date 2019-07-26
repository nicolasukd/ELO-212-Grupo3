`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2019 12:40:19
// Design Name: 
// Module Name: testalu
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


module testalu(
    );
    logic [7:0]A,B,salida;
    logic [3:0]botones;
    logic invalido;
    alu U0(.A(A),.B(B),.botones(botones),.salida(salida),.invalido(invalido));
    initial begin
    A = 8'b00000001;
    B = 8'b00000001;
    botones = 4'b1000;
    #5
    botones = 4'b0100;
    
    end
endmodule
