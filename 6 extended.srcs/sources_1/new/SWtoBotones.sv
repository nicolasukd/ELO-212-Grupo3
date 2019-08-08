`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2019 11:50:45
// Design Name: 
// Module Name: SWtoBotones
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


module SWtoBotones(
    input logic [1:0] sw,
    output logic [3:0] botones
    );
    always_comb begin
        case(sw)
            2'b00: botones = 4'b1000;
            2'b01: botones = 4'b0100;
            2'b10: botones = 4'b0001;
            2'b11: botones = 4'b0010;
            
        endcase
   
    end
endmodule
