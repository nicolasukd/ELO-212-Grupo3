`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2019 12:28:36
// Design Name: 
// Module Name: Topmodule
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


module Topmodule(
    input logic [15:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNU,BTND,BTNL,BTNR,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,DP,
    output logic [15:0]LED
    );
    logic clkout,invalido;
    logic [7:0]resultado;
    logic [7:0]respuesta,digitos;
    logic [3:0]BCD;
    clockdivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    
    //alu U0(.botones({BTNU,BTND,BTNL,BTNR}),.A(SW[7:0]),.B(SW[15:8]),.salida(resultado),.invalido(invalido));
    alubits #(8)U0(.botones({BTNU,BTND,BTNL,BTNR}),.A(SW[7:0]),.B(SW[15:8]),.salida(resultado),.invalido(invalido));
    
    
    display  U1(.digitos(digitos),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(SW[15:12]),.d2(SW[11:8]),.d3(4'd0),.d4(respuesta[7:4]),.d5(respuesta[3:0]),.d6(4'd0),.d7(SW[7:4]),.d8(SW[3:0]));
    
    always_ff @(posedge CLK100MHZ)begin
        if (~CPU_RESETN)
            digitos = 8'd0;
                    
        if(BTNU == 1 || BTND == 1)begin
            digitos = 8'b11011011;
            respuesta = resultado[7:0];
            if(AN == ~8'b00010000)
                DP = invalido;
            else 
                DP = 1;
        end
        else
            digitos = 8'b11000011;
        if (BTNL == 1 || BTNR == 1)begin
            LED[7:0] = resultado;
            LED[15:8]= 8'd0; 
        end
        else 
            LED = SW;
    end
    
    
endmodule
