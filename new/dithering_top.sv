`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:36:48
// Design Name: 
// Module Name: dithering_top
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


module dithering_top (
  input logic [23:0] data_in,
  output logic [23:0] data_out,
  input logic clk, rst, SW, visible
);
  logic [7:0] dith_red_out, dith_green_out, dith_blue_out;
  dithering_8bit RED_dithering(
    .entrada_color_8_bit(data_in[7:0]),
    .clk(clk), .rst(rst),
    .salida_color_8_bit(dith_red_out),
    .visible(visible)
);
  dithering_8bit GREEN_dithering(
    .entrada_color_8_bit(data_in[15:8]),
    .clk(clk), .rst(rst),
    .salida_color_8_bit(dith_green_out),
    .visible(visible)
);
  dithering_8bit BLUE_dithering(
    .entrada_color_8_bit(data_in[23:16]),
    .clk(clk), .rst(rst),
    .salida_color_8_bit(dith_blue_out),
    .visible(visible)
);

  always_comb begin
    case (SW)
      1'b0: data_out = data_in;
      1'b1: data_out = (visible == 1'b1)? {dith_blue_out,  dith_green_out, dith_red_out}:24'd0;
    endcase
  end
endmodule


module dithering_8bit (
	input logic [7:0] entrada_color_8_bit,
  	input logic clk, rst, visible,
	output logic [7:0] salida_color_8_bit
);
localparam THRESHOLD = 'd4;

// cables para calcular error
	//logic [7:0] error, next_error;
// resultado y overflow ALU
	logic [15:0] resultado;
logic overflow;

// se separara a la salida de la ALU como MSN (most significant Nibble) y LSN (Less significant Nibble)
logic [3:0] MSN, LSN;
	assign MSN = resultado[7:4];
	assign LSN = resultado [3:0];

	/*ALU_generalizado #(16) alu(
		.entrada_a({8'b0,entrada_color_8_bit}), .entrada_b({8'd0,8'd0}), // Entradas ALU
	.operacion(3'b000), // SUMA
	.resultado(resultado), // Resultado de la operacion
    );*/
    
     alubits #(16)U0(.botones(4'b0000),.A({8'b0,entrada_color_8_bit}),.B({8'd0,8'd0}),.salida(resultado));
    
always_comb begin
		if (LSN >= THRESHOLD) begin
			//next_error = error - (8'd16 - {4'd0 , LSN});
			if (resultado >= 8'hFF) begin
				salida_color_8_bit = {MSN , 4'd0};
			end
			else begin
				salida_color_8_bit = {MSN + 'd1 , 4'd0};
			end
		end
    		else begin
			//next_error = error + {4'd0 , LSN};
			salida_color_8_bit = {MSN , 4'd0};
    		end
end
	// logica secuencial del error
	//always_ff @(posedge clk) begin
	//	if (rst) begin
	//		error <= 'd0;
	//	end
	//	else begin
	//		if (visible)
	//			error <= next_error;
	//		else
	//			error <= 'd0;
	//	end
	//end
endmodule
