`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2019 20:45:46
// Design Name: 
// Module Name: testeclockDivider
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


module testeclockDivider();
    logic CLK100MHZ,reset,clkout10,clkout30,clkout500;
    
    clockDiv U0(.clkin(CLK100MHZ),.reset(reset),.clkout10(clkout10),.clkout30(clkout30),.clkout500(clkout500));

    
    initial begin
        reset = 0;
        #11
        reset=1;
    end
endmodule
