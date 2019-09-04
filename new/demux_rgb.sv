`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:38:24
// Design Name: 
// Module Name: demux_rgb
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


module demux_rgb(
	input logic [1:0] switches,
	input logic [23:0] channel,
	output logic [7:0] channel_out
);
	always_comb begin
		//defaults
		case(switches)
			2'b00:	channel_out = channel[7:0];
			2'b01:	channel_out = channel [15:8];
			2'b10:	channel_out = channel [23:16];
			2'b11:	channel_out = 'd0;
			default: channel_out = 'd1;
		endcase
	end
endmodule