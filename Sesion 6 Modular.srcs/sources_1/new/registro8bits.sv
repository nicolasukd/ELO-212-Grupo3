`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2019 10:46:49
// Design Name: 
// Module Name: registro8bits
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


module registro8bits(
    input logic [7:0]SW,
    input logic CLK100MHZ,
    input logic CPU_RESETN,BTNC,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [7:0]LED
    );
    logic centro,clkout;
    logic [7:0]num;
    assign LED=SW;
    clockDivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    PBdebouncer botoncentro(.clk(CLK100MHZ),.rst(CPU_RESETN),.PB(BTNC),.PB_pressed_status(centro));
    bancoregistros #(8) banco8(.guardar(centro),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(num),.enable(1'b1));
    display  U1(.digitos(8'b00000011),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(4'd0),.d2(4'd0),.d3(4'd0),.d4(4'd0),.d5(4'd0),.d6(4'd0),.d7(num[7:4]),.d8(num[3:0]));
endmodule