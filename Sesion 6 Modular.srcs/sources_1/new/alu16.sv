`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2019 15:53:33
// Design Name: 
// Module Name: alu16
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


module alu16(
        input logic [15:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNC,BTNL,BTNR,BTNU,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,//DP,
    output logic [15:0]LED
    );
    logic [15:0] A,B,C,resultado;
    logic [31:0]Z;
    logic izquierdo,derecho,centro,arriba;
    logic invalido,clkout,aux,aux1;
    logic [7:0]digitos;
    logic [15:0]suma;
    
    clockDivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    PBdebouncer botonarriba(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNU),.PB_pressed_status(arriba));
    PBdebouncer botonizquierdo(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNL),.PB_pressed_status(izquierdo));
    PBdebouncer botonderecho(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNR),.PB_pressed_status(derecho));
    PBdebouncer botoncentro(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNC),.PB_pressed_status(centro));
    bancoregistros #(16) bancoA(.guardar(izquierdo),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(A),.enable(1'b1));
    bancoregistros #(16) bancoB(.guardar(derecho),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(B),.enable(1'b1));
    bancoregistros #(16) bancoC(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(resultado),.salida(C),.enable(1'b1));
    alubits #(16)U0(.botones({centro,0,0,0}),.A(A),.B(B),.salida(resultado),.invalido(invalido));
    //assign resultado = A+B;
    
    display  U1(.digitos(digitos),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(Z[31:28]),.d2(Z[27:24]),.d3(Z[23:20]),.d4(Z[19:16]),.d5(Z[15:12]),.d6(Z[11:8]),.d7(Z[7:4]),.d8(Z[3:0]));
    
    always_ff @(posedge CLK100MHZ ) begin
        LED = SW;
        if(~CPU_RESETN)begin
          aux = 0;
          aux1 = 0;
          Z[31:16]= 16'd0;
          Z[15:0]= 16'd0;
          digitos = 8'b11111111;
        end  
        if(izquierdo)begin
            aux = 0;
            aux1 = 0;
            Z[31:16] = A;
            digitos = 8'b11111111;
        end
        else if(derecho)begin
            aux = 0;
            aux1 = 0;
            Z[15:0] = B;
            digitos = 8'b11111111;
        end
        else if((centro) || (aux1 && ~arriba))begin
            aux = 1;
            Z[23:8] = C;
            digitos = 8'b00111100;
            //DP = invalido;
        end
        else if(aux && arriba && digitos == 8'b00111100)begin
            Z[31:16] = A;
            Z[15:0] = B;
            digitos = 8'b11111111; 
            aux1=1; 
        end
        else
            Z = Z;
            
            
           
     
    
    end
endmodule
