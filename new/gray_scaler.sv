`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:37:37
// Design Name: 
// Module Name: gray_scaler
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


module gray_scaler (
	input logic SW, //SWITCH 1
	input logic [23:0] input_line,
	output logic [23:0] gray_scaled
);
	logic [7:0] gray_scaled_out;
	always_comb begin
		//defaults
		case(SW)
			1'b0:	gray_scaled = input_line;
			1'b1:	begin 
				gray_scaled_out = (((input_line[7:0] *30)/10) + ((input_line[15:8] *59)/100) + ((input_line[23:16] *11)/100));
				gray_scaled = {gray_scaled_out,gray_scaled_out,gray_scaled_out};
			end
			default: gray_scaled = input_line;
		endcase
	end
endmodule
