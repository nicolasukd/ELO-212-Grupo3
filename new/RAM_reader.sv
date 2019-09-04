`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:28:35
// Design Name: 
// Module Name: RAM_reader
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


// RAM_WIDTH -> tama;o de una palabra
// RAM_HEIGHT -> numero de "slots" en la RAM
// N_BITS-> numero totales de bits a guardar
module RAM_reader #(parameter RAM_WIDTH = 32, parameter N_BITS = 480*360*24)
(
  input logic [RAM_WIDTH-1:0] data,
  input logic rst, clk, visible,
  output logic [ADRESS_BITS-1:0] adress,
  output logic [RAM_WIDTH-1:0] data_out
);
  localparam RAM_DEPTH = (N_BITS)/RAM_WIDTH;
  localparam MAX_ADRESS = RAM_DEPTH - 1;
  localparam ADRESS_BITS = $clog2(RAM_DEPTH); // numero de bits de adress
	
  logic [ADRESS_BITS-1:0] next_adress;
  logic [RAM_WIDTH-1:0] next_output;
	
  enum logic [1:0] {DATA_AVAILABLE, DATA_UNAVAILABLE} next_state, state;

  always_ff @(posedge clk) begin
    if (rst) begin
      	data_out <= 'd0;
     	adress <= 'd0;
      	state <= DATA_AVAILABLE;
    end
    else begin
    	data_out <= next_output;
    	adress <= next_adress;
     	state <= next_state;
    end
   end
  always_comb begin
    next_state = state;
    next_output = data_out;
    next_adress = adress;
    case(state)
      DATA_AVAILABLE: begin
	      next_output = data;
	      if (!visible)
		next_state = DATA_UNAVAILABLE;
	      if (adress >= MAX_ADRESS)
		      next_adress = 'd0;
	      else
		next_adress = adress + 'd1;
      end
      DATA_UNAVAILABLE: begin
	      next_output = 'd0;
	      next_adress = adress;
	      //if (visible)
		      //next_state = IDLE;
		      end
      endcase
    end
  endmodule
