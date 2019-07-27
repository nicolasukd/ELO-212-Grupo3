`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2019 11:23:15
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
    input logic CPU_RESETN,BTNL,BTNR,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [15:0]LED
    );
    logic centro,derecha,izquierda,clkout;
    logic [15:0]numizq,numder;
    assign LED=SW;
    clockDivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    PBdebouncer botonizq(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNL),.PB_pressed_status(izquierda));
    PBdebouncer botonder(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNR),.PB_pressed_status(derecha));
    bancoregistros #(16) banco1(.guardar(izquierda),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(numizq),.enable(1'b1));
    bancoregistros #(16) banco2(.guardar(derecha),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(numder),.enable(1'b1));
    display  U1(.digitos(8'b11111111),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(numizq[15:12]),.d2(numizq[11:8]),.d3(numizq[7:4]),.d4(numizq[3:0]),.d5(numder[15:12]),.d6(numder[11:8]),.d7(numder[7:4]),.d8(numder[3:0]));
    

endmodule
