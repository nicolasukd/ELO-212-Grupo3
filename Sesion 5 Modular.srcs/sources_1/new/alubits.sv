`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2019 18:13:08
// Design Name: 
// Module Name: alubits
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


module alubits #(bits = 16)(
    input logic [3:0]botones, // (+,-,and,or)
    input logic [bits-1:0]A,B,
    output logic [bits:0]salida,
    output logic invalido
    );
    logic over = ~'d0;
    always_comb begin
        case(botones)
            4'b1000:
            begin
                salida = A+B;
                if (salida > over)
                    invalido = 0;
                else
                    invalido = 1;
            end
            4'b0100: begin                
                salida = A-B;
                if (salida > over)
                    invalido = 0;
                else 
                    invalido = 1;                
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
                invalido = 0;
            end
        endcase
    end
endmodule
