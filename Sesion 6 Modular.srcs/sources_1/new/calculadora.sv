`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2019 18:19:46
// Design Name: 
// Module Name: calculadora
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


module calculadora(
     input logic [15:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNC,BTNL,BTNR,BTNU,BTND,
    //output logic [7:0]AN,
    //output logic CA,CB,CC,CD,CE,CF,CG,//DP,
    output logic [15:0]LED
    );
    logic [15:0] A,B,G1,G2;
    logic izquierdo,derecho,arriba,abajo;
    logic centro;
    logic [3:0]operacion;
    logic [15:0]resultado;
    int count = 0;
    

    PBdebouncer botonabajo(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTND),.PB_pressed_status(abajo));
    PBdebouncer botonarriba(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNU),.PB_pressed_status(arriba));
    PBdebouncer botonizquierdo(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNL),.PB_pressed_status(izquierdo));
    PBdebouncer botonderecho(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNR),.PB_pressed_status(derecho));
    PBdebouncer botoncentro(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNC),.PB_pressed_status(centro));
    
    bancoregistros #(16) bancoA(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(G1),.salida(A),.enable(1'b1));
    bancoregistros #(16) bancoB(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(G2),.salida(B),.enable(1'b1));
    
    alubits #(16)U0(.botones(operacion),.A(A),.B(B),.salida(resultado));
    //assign resultado = A+B;
    

    
     always_ff @(posedge CLK100MHZ ) begin
     if(centro)
        count = count + 1;
     case (count)
        1:  begin 
            G1 = SW[15:0];
            end
        2: begin
            G2 = SW[15:0];
            end
        3: begin
            LED = 16'd0;
            if(abajo || arriba || izquierdo || derecho)
                operacion = {arriba,abajo,derecho,izquierdo};
                
           end
        4: begin
            LED = resultado;
            count = 0;
        end
     endcase

     end
endmodule
