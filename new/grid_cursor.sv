`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2019 16:51:39
// Design Name: 
// Module Name: grid_cursor
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


module grid_cursor(
	input clk, rst,
	input restriction,
	input dir_up, dir_down, dir_left, dir_right,
	output logic [2:0] pos_x,
	output logic [1:0] pos_y,
	output logic [4:0] val
	);
    
	logic [2:0]pos_x_next;
	logic [1:0]pos_y_next;

	logic [1:0] ff;
	logic [1:0]count_ne;
	logic restriction_ne;
    
//definición de val
	always_comb
		case(pos_x)
			3'd0:
					case(pos_y)
						2'd0: val = 5'd0;
						2'd1: val = 5'd4;
						2'd2: val = 5'd8;
						2'd3: val = 5'hc;
					endcase
			3'd1:
					case(pos_y)
						2'd0: val = 5'd1;
						2'd1: val = 5'd5;
						2'd2: val = 5'd9;
						2'd3: val = 5'hd;
					endcase
		
			3'd2:
					case(pos_y)
						2'd0: val = 5'd2;
						2'd1: val = 5'd6;
						2'd2: val = 5'ha;
						2'd3: val = 5'he;
					endcase
			3'd3:
					case(pos_y)
						2'd0: val = 5'd3;
						2'd1: val = 5'd7;
						2'd2: val = 5'hb;
						2'd3: val = 5'hf;
					endcase
			3'd4:
					case(pos_y)
						2'd0: val = 5'b1_0000;//suma
						2'd1: val = 5'b1_0001;//mult
						2'd2: val = 5'b1_0010;//and
						2'd3: val = 5'b1_0011;//EXE
					endcase
			3'd5:
					case(pos_y)
						2'd0: val = 5'b1_0100;//resta
						2'd1: val = 5'b1_0101;//or
						2'd2: val = 5'b1_0110;//CE
						2'd3: val = 5'b1_0111;//CLR
					endcase
			default:
					val = 5'h1F;
		endcase

	
	
	
	enum logic [3:0] {quieto, up, down, left, right} state, next_state;

	always_comb 	
		begin
			pos_x_next = pos_x;
			pos_y_next = pos_y;
			
			if (dir_up)                           
				next_state = up;
			else
				if (dir_down)
					next_state = down;
				else
					if (dir_left)
						next_state = left;
					else
						if (dir_right)
							next_state = right;
						else
							next_state = quieto;
case (state)
                                            quieto:
                                                begin
                                                    pos_x_next = pos_x;
                                                    pos_y_next = pos_y; 
                                                    if(restriction)begin
                                                        if(val == 5'hf | val==5'hd | val==5'he | val==5'hc | val==5'ha | val==5'hb )begin
                                                            pos_x_next = 3'd0;
                                                            pos_y_next = 2'd0;    
                                                        end
                                                    end
                                                    
                                                    end
                                            up: 
                                                begin
                                                if (pos_y != 'd0) begin
                                                    if (~restriction)
                                                        pos_y_next = pos_y - 1;
                                                    else begin
                                                        if (pos_y <= 'd1 || pos_x >'d3 || (pos_y=='d2 && pos_x<'d2) )
                                                        pos_y_next = pos_y - 1;
                                                            end
                                                    end
                                                end
                                            down:
                                                begin
                                                if (pos_y != 'd3) begin
                                                    if (~restriction)
                                                        pos_y_next = pos_y + 1;
                                                    else begin
                                                        if (pos_x>='d4 || pos_y=='d0 || (pos_y=='d1 && pos_x<'d2) )
                                                            pos_y_next = pos_y + 1;
                                                        end
                                                    end
                                                end
                                            left:
                                                begin
                                                if (pos_x != 'd0) begin
                                                    if (~restriction)
                                                        pos_x_next = pos_x - 1;
                                                    else begin
                                                        if (pos_y <= 'd1 || pos_x =='d5 || (pos_y=='d2 && pos_x<'d2) )
                                                            pos_x_next = pos_x - 1;
                                                        end
                                                    end
                                                end
                                            right:
                                                begin
                                                if (pos_x != 'd5) begin
                                                    if (~restriction)
                                                        pos_x_next = pos_x + 1;
                                                    else begin
                                                        if (pos_y <= 'd1 || pos_x >'d3 || (pos_y=='d2 && pos_x=='d0) )
                                                            pos_x_next = pos_x + 1;
                                                        end
                                                    end
                                                end
                                            endcase                    
				
			end
		
		always_ff@(posedge clk)
			if(rst) begin
				pos_x <= 'd0;
				pos_y <= 'd0;
				state <= quieto;
				end
			else begin
				state <= next_state;
				pos_x <= pos_x_next;
				pos_y <= pos_y_next; 
				end


endmodule
