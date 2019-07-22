`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2019 21:15:24
// Design Name: 
// Module Name: counter
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


module counter(
    input logic clk,reset,
    output logic [3:0] BCD
    
    );
    always_ff @(posedge clk) begin
        if (reset)
            BCD <= 4'b0;          
        else
            BCD <= BCD + 1;
            
    end
    
endmodule
