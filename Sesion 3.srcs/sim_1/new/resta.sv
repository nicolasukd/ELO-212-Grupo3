`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2019 20:13:52
// Design Name: 
// Module Name: resta
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


module resta(

    );
    logic [7:0] A;
    logic [7:0] B;
    logic [32:0] C;
    assign C=A-B;
    initial begin
    A=8'b11000000;
    B=8'b00000000;
    end
endmodule
