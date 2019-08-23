`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 15:48:59
// Design Name: 
// Module Name: hex_to_ascii
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


module hex_to_ascii(
	input [3:0] hex_num,
	output logic[7:0] ascii_conv
	);

	always_comb begin
	   case(hex_num)
	       4'h0: ascii_conv = "0";
	       4'h1: ascii_conv = "1";
	       4'h2: ascii_conv = "2";
	       4'h3: ascii_conv = "3";
	       4'h4: ascii_conv = "4";
	       4'h5: ascii_conv = "5";
	       4'h6: ascii_conv = "6";
	       4'h7: ascii_conv = "7";
	       4'h8: ascii_conv = "8";
	       4'h9: ascii_conv = "9";
	       4'ha: ascii_conv = "a";
	       4'hb: ascii_conv = "b";
	       4'hc: ascii_conv = "c";
	       4'hd: ascii_conv = "d";
	       4'he: ascii_conv = "e";
	       4'hf: ascii_conv = "f";
	       default: ascii_conv = 8'd32;
	   endcase
	end
endmodule
