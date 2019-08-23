`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2019 16:54:51
// Design Name: 
// Module Name: ALU
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


module ALU(
    input logic [15:0] A,B,
    input logic [4:0] operador,
    output logic [15:0] resultado
    );
    
    
    always_comb
    begin
    case(operador)
        5'b1_0000: resultado=A+B;
        5'b1_0100: resultado=A-B;
        5'b1_0010: resultado=A|B;
        5'b1_0101: resultado=A&B;
        5'b1_0001: resultado=A*B;
        default: resultado=8'd0;
    endcase end
endmodule

