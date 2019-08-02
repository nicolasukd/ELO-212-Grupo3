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
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,//DP,
    output logic [15:0]LED
    );
    logic [15:0] A,B,G1,G2;
    logic izquierdo,derecho,arriba,abajo;
    logic centro,clkout;
    logic [7:0]digitos;
    logic [3:0]operacion,cont;
    logic [15:0]resultado;
    int count = 1;
    
    clockDivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    PBdebouncer botonabajo(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTND),.PB_pressed_status(abajo));
    PBdebouncer botonarriba(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNU),.PB_pressed_status(arriba));
    PBdebouncer botonizquierdo(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNL),.PB_pressed_status(izquierdo));
    PBdebouncer botonderecho(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNR),.PB_pressed_status(derecho));
    PBdebouncer botoncentro(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNC),.PB_pressed_pulse(centro));
    
    bancoregistros #(16) bancoA(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(G1),.salida(A),.enable(1'b1));
    bancoregistros #(16) bancoB(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(G2),.salida(B),.enable(1'b1));
    
    alubits #(16)U0(.botones(operacion),.A(A),.B(B),.salida(resultado));
    //assign resultado = A+B;
    
     display  U1(.digitos(digitos),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(cont),.d2(4'd0),.d3(4'd0),.d4(4'd0),.d5(resultado[15:12]),.d6(resultado[11:8]),.d7(resultado[7:4]),.d8(resultado[3:0]));
    
     always_ff @(posedge CLK100MHZ ) begin
     if(~CPU_RESETN)begin
            count = 1;
            cont = 4'd1;
        end
     if(centro)begin
        count = count + 1;
        LED = 16'b0;
     end
     case (count)
        1:  begin 
            digitos = 8'b10000000;
            cont = 4'd1;
            G1 = SW[15:0];
            LED = SW;
            end
        2: begin
            digitos = 8'b10000000;
            cont = 4'd2;
            G2 = SW[15:0];
            LED = SW;
            end
        3: begin
            digitos = 8'b10000000;
            cont = 4'd3;
            LED = 16'd0;
            if(abajo || arriba || izquierdo || derecho)
                operacion = {arriba,abajo,derecho,izquierdo};
                
           end
        4: begin
            digitos = 8'b10001111;
            cont = 4'd4;
            LED = resultado;
            end
        5: count = 1;   
            
            
        default: begin
                LED = SW;
                cont = 4'd1;
                 end
     endcase

     end
endmodule
