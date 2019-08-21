`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2019 11:39:12
// Design Name: 
// Module Name: bancoregistros_sin_clk
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


module bancoregistros_sin_clk
    #(parameter
 bits = 16 )
(
    input logic guardar,
    input logic [bits-1:0] entrada,
    output logic [bits-1:0] salida
    );
    

    

    
   always_comb begin 
             
            case(guardar) 
               1:begin 
                    salida = entrada;
                    end
               default:begin
                    salida = salida;
                end
            endcase
            
 end
        
endmodule
