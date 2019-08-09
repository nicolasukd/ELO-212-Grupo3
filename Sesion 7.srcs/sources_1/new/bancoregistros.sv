`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2019 22:11:52
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
//bancoregistros #(16) banco1(.guardar(izquierda),.clock(CLK100MHZ),.reset(CPU_RESETN),.entrada(SW),.salida(numizq),.enable(1'b1));

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
