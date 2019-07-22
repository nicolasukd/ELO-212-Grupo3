`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2019 10:50:23
// Design Name: 
// Module Name: writetest
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


module writetest(
    input logic  CLK100MHZ,CPU_RESETN,[15:0]SW,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [15:0]LED
    );
    write U0(.BCD(SW),.clkin(CLK100MHZ),.reset(CPU_RESETN),.an(AN),.C_A(CA),.C_B(CB),.C_C(CC),.C_D(CD),.C_E(CE),.C_F(CF),.C_G(CG),.led(LED));
    
endmodule
