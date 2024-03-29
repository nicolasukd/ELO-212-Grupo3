`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2019 10:22:23
// Design Name: 
// Module Name: bancoregistros
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


module bancoregistros
    #(parameter
 bits = 16 )
(
    input logic guardar, clock, reset, enable,
    input logic [bits-1:0] entrada,
    output logic [bits-1:0] salida
    );
    
    
    logic [bits-1:0] intermedio;
    
   always_comb begin
   
            if(guardar & enable) 
                intermedio = entrada;
             else
                intermedio = salida;
            
   end
        
    always@(posedge clock or posedge reset)
    	if(~reset)
    		salida <= 'b0;
    	else
    	   salida <= intermedio;
endmodule
