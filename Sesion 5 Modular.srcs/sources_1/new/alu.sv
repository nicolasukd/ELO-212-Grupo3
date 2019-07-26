`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2019 12:16:53
// Design Name: 
// Module Name: alu
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


module alu(
    input logic [3:0]botones, // (+,-,and,or)
    input logic [7:0]A,B,
    output logic [7:0]salida,
    output logic invalido
    );
    always_comb begin
        case(botones)
            4'b1000:
            begin
                salida = A+B;
                if (salida> 8'b11111111)begin
                    invalido = 0;
                end
            end
            4'b0100: begin                
                salida = A-B;
                if (salida> 8'b11111111)begin
                    invalido = 0;
                end
                
             end
            4'b0010: begin
                salida = A|B;
                invalido=1;
            end
            4'b0001: begin 
                salida = A&B;
                invalido=1;
            end
            default: begin
                salida=0;
                invalido = 1;
            end
        endcase
    end
endmodule
