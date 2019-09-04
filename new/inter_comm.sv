`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:21:06
// Design Name: 
// Module Name: inter_comm
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


module inter_comm #(parameter PIXEL_COUNT =172800)(
	input logic clk,
	input logic reset,
	input logic tx_ready,
	input logic [7:0] data_in,
	output logic enable_flag,
	output logic [23:0] data_ram,
	output logic [address_bit-1:0] address
);
	//parametros locales
	localparam address_bit = $clog2(PIXEL_COUNT);
	localparam add_max = PIXEL_COUNT -'d1;
	//definicion estados
	enum logic [2:0] {wp_1,reg1,wp_2,reg2,wp_3,reg3,enable,ch_add} state,next_state;
	//logica estados

	logic [23:0] temp,pre_temp;
	logic [address_bit-1:0] n_addr;
	always_comb begin
		//defaults
		next_state = state;
		enable_flag = 'd0;
		n_addr = address;
		pre_temp = temp;
		case(state)
			wp_1:	begin
				if(tx_ready) begin
					next_state = reg1;
				end
				else begin
					next_state = state;
				end
			end
			reg1:	begin
				pre_temp = {16'd0,data_in};
				next_state = wp_2;
			end
			wp_2:	begin
				if(tx_ready) begin
					next_state = reg2;
				end
				else begin
					next_state = state;
				end
			end
			reg2:	begin
				pre_temp = {8'd0,data_in,temp[7:0]};
				next_state = wp_3;
			end
			wp_3:	begin
				if(tx_ready) begin
					next_state = reg3;
				end
				else begin
					next_state = state;
				end
			end
			reg3:	begin
				pre_temp = {data_in,temp[15:0]};
				next_state = enable;
			end
			enable:	begin
				next_state = ch_add;
				enable_flag = 'd1;
			end
			ch_add:	begin
				next_state = wp_1;
				if (address >= add_max)
					n_addr = 'd0;
				else
					n_addr = address + 'd1;
			end
		endcase
	end
	//ff
	always_ff @(posedge clk) begin
		if(reset) begin
			state <= wp_1;

			temp <= 'd0;
			address <= 'd0;
		end
		else begin
			state <= next_state;

			temp <= pre_temp;

			address <= n_addr;
		end
	end
	assign data_ram = temp;
endmodule
