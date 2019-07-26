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
    logic [7:0]resultado,respuesta;
    logic [3:0]BCD;
    clockdivider #(100000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    alu U0(.botones({BTNU,BTND,BTNL,BTNR}),.A(SW[7:0]),.B(SW[15:8]),.salida(resultado),.invalido(invalido));
    display U1(.an(AN),.BCD(BCD),.clk(clkout),.reset(CPU_RESETN),.d1(SW[15:12]),.d2(SW[11:8]),.d4(resultado[7:4]),.d5(resultado[3:0]),.d7(SW[7:4]),.d8(SW[3:0]));
    BCDto7 U2(.BCD(BCD),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}));
    always_comb begin
    
        if(AN == 8'b00010000)begin
            DP = invalido;
        end
        else begin
            DP = 0;
        end
        
        if(BTNU == 1 || BTND == 1)begin
            respuesta = resultado;
        end
        else if (BTNL == 1 || BTNR == 1)begin
            LED[7:0] = resultado;
            LED[15:8]= 8'd0; 
        end
        else if (BTNL == 0 || BTNR == 0)begin
            LED = SW;
        end
    end
    
    
endmodule
