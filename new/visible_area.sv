`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:34:28
// Design Name: 
// Module Name: visible_area
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


module visible_area #(parameter X_POS = 0, parameter Y_POS = 0) (
  input logic [10:0] hc, vc,
  input logic clk, rst,
  output logic visible
);
  localparam WIDTH = 480;
  localparam HEIGHT = 360;
  

  logic [10:0]hc_visible;
  logic [10:0]vc_visible;
  logic next_visible;
	
	assign hc_visible = ((hc <= (X_POS + WIDTH)) && (hc > (X_POS)))?(hc - X_POS):11'd0;
	assign vc_visible = ((vc <= (Y_POS + HEIGHT)) && (vc > (Y_POS)))?(vc - Y_POS):11'd0;
  
	assign  visible = (|hc_visible) & (|vc_visible);

endmodule
