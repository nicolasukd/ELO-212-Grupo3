`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2019 19:07:11
// Design Name: 
// Module Name: testalubits
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


module testalubits(

    );
    logic BTNU,BTND,BTNL,BTNR,invalido;
    logic [15:0]SW;
    logic [7:0]over,resultado;
    alubits #(8)U0(.botones({BTNU,BTND,BTNL,BTNR}),.A(SW[7:0]),.B(SW[15:8]),.salida(resultado),.invalido(invalido),.over(over));
    initial begin
        {BTNU,BTND,BTNL,BTNR}=4'b1000;
        SW[15:8]=8'b11111111;
        SW[7:0]=8'b11111111;
        #5
        
        SW[15:8]=8'b00001001;
        SW[7:0]=8'b00000001;
    end
endmodule
