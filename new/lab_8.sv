`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2019 15:21:53
// Design Name: 
// Module Name: lab_8
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


module lab_8(
	input CLK100MHZ,
	input [1:0]SW,
	input BTNC,	BTNU, BTNL, BTNR, BTND, CPU_RESETN,
	output [15:0] LED,
	output CA, CB, CC, CD, CE, CF, CG,
	output DP,
	output [7:0] AN,


	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B
	);
	
	
	logic CLK82MHZ;
	logic rst = 0;
	logic hw_rst = ~CPU_RESETN;
	logic UP,DOWN,LEFT,RIGHT,CENTER;
	
	PBdebouncer botonarriba(.clk(CLK82MHZ),.rst(CPU_RESETN),.PB(BTNU),.PB_pressed_pulse(UP));
	PBdebouncer botonabajo(.clk(CLK82MHZ),.rst(CPU_RESETN),.PB(BTND),.PB_pressed_pulse(DOWN));
	PBdebouncer botonizquierda(.clk(CLK82MHZ),.rst(CPU_RESETN),.PB(BTNL),.PB_pressed_pulse(LEFT));
	PBdebouncer botonderecha(.clk(CLK82MHZ),.rst(CPU_RESETN),.PB(BTNR),.PB_pressed_pulse(RIGHT));
	PBdebouncer botoncentro(.clk(CLK82MHZ),.rst(CPU_RESETN),.PB(BTNC),.PB_pressed_pulse(CENTER));
	
	
	

	
	
	clk_vga inst(
		// Clock out ports  
		.clk_out1(CLK82MHZ),
		// Status and control signals               
		.reset(1'b0), 
		//.locked(locked),
		// Clock in ports
		.clk_in1(CLK100MHZ)
		);
	//Fill here
	
	logic [4:0]val;










/*alubits #(16)alu(.botones(),
                .A(),
                .B(),
                .salida(),
                .invalido());*/
                


	/************************* VGA ********************/
	logic [2:0] op;
	logic [2:0] pos_x;
	logic [1:0] pos_y;
	logic [15:0] op1, op2;
	
	grid_cursor(
	 .clk(CLK82MHZ), .rst(~CPU_RESETN),
	 .restriction(SW[0]),
	 .dir_up(UP), .dir_down(DOWN), .dir_left(LEFT), .dir_right(RIGHT),
	 .pos_x(pos_x),
	 .pos_y(pos_y),
	 .val(val)
	);
    logic [15:0]resultado;
    logic [1:0]main_state;
	
	
	
	
	calculator_screen(
		.clk_vga(CLK82MHZ),
		.rst(rst),
		.mode(SW[0]),
		.op(op),
		.pos_x(pos_x),
		.pos_y(pos_y),
		.op1(op1),
		.op2(op2),
		.input_screen(16'd0),
		.resultado(resultado),
		.state(main_state),
		.BTNC(BTNC),
		
		
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B));








   logic [3:0] hold;
   
   estados instancia(.hold(hold),  .rst((~CPU_RESETN) ||((val == 5'b1_0111 )&& CENTER) || 
   (CENTER && (val == 5'b1_0011) && main_state == 2'b11)), .clk(CLK82MHZ), .trans(CENTER && (val == 5'b1_0011))
   , .estado(main_state));  //CLR, EXE respectivamente
    
   logic [15:0] op1_next, op2_next;
   logic [4:0] op_next;
   logic [19:0] op1_dec,op2_dec;
   logic [19:0] op1_dec_next, op2_dec_next;
   always_ff@( posedge CLK82MHZ)begin
   
     if ((~CPU_RESETN)||((val == 5'b1_0111) && CENTER ) || (CENTER && (val==5'b1_0011) && main_state == 2'b11))  begin //  CLR 
        op1 <= 'b0;
        op2 <= 'b0; 
        op <= 'b0 ;   
        op1_dec <= 'b0;
        op2_dec <= 'b0;        
        end
        
    else if (CENTER && (val == 5'b1_0110) && (main_state == 2'b00))  begin //CE
        op1 <= 'b0;
        op2 <= 'b0; 
        op <= 'b0;
        
        end
         
   else if (CENTER && (val == 5'b1_0110)  && (main_state == 2'b01)) begin //CE
        op1 <= op1_next;
        op2 <= 'b0; 
        op <= 'b0;
        end
   else if (CENTER && (val == 5'b1_0110)  &&(main_state == 2'b10)) begin
        op1 <= op1_next;
        op2 <= op2_next; 
        op <= 'b0; 
        end    
   else begin 
        op1 <= op1_next;
        op2 <= op2_next;
        op <= op_next; 
        op1_dec <= op1_dec_next;
        op2_dec <= op2_dec_next;
        end end
   

    
   always_comb begin
        op1_next = op1;
        op2_next = op2;
        op_next = op;
        
        case(main_state)
            2'b00: if ((CENTER == 'b1) && (val[4] == 0) && ({op1,val[3:0]} <= 16'hFFFF)) begin
                        if ((SW[0] ==1) && ((val[3:0] + op1*10) <= 16'hFFFF)) begin 
                             op1_next = val[3:0] + op1*10;
                              end
                    
                        else begin
                        op1_next = {op1[11:0],val[3:0]};
                       end end 
                
            2'b01: if ((CENTER == 'b1) && (val[4] == 0)&&({op2,val[3:0]} <= 16'hFFFF)) begin
                        if ((SW[0] ==1) && ((val[3:0] + op2*10) <= 16'hFFFF))begin 
                            op2_next = val[3:0] + op2*10;
                           end
                        
                        else begin 
                           op2_next = {op2[11:0],val[3:0]};
                          end end 
                 
            2'b10: if ((CENTER == 'b1) && (val[4] == 1) && (val!=5'b1_0011) && (val!=5'b1_0110) && (val!=5'b1_0111))
            
                  op_next = val;
            2'b11: if((CENTER == 'b1) && (val==5'b1_0011))           
                 ;          

        endcase
        end    

 
     
    
        
    ALU instALU(.A(op1), .B(op2), .operador(op), .resultado(resultado));





endmodule

/**
 * @brief Este modulo convierte un numero hexadecimal de 4 bits
 * en su equivalente ascii de 8 bits
 *
 * @param hex_num		Corresponde al numero que se ingresa
 * @param ascii_conv	Corresponde a la representacion ascii
 *
 */

module hex_to_ascii(
	input [4:0] hex_num,
	output logic[7:0] ascii_conv
	);
always_comb begin
      case(hex_num)
      5'h0: ascii_conv="0";
      5'h1: ascii_conv="1";
      5'h2: ascii_conv="2";
      5'h3: ascii_conv="3";
      5'h4: ascii_conv="4";
      5'h5: ascii_conv="5";
      5'h6: ascii_conv="6";
      5'h7: ascii_conv="7";
      5'h8: ascii_conv="8";
      5'h9: ascii_conv="9";
      5'hA: ascii_conv="A";
      5'hB: ascii_conv="B";
      5'hC: ascii_conv="C";
      5'hD: ascii_conv="D";
      5'hE: ascii_conv="E";
      5'hF: ascii_conv="F";
      5'b1_0000: ascii_conv="+";//suma
      5'b1_0001: ascii_conv="*";//mult
      5'b1_0010: ascii_conv="&";//and
      5'b1_0100: ascii_conv="-";//re
      5'b1_0101: ascii_conv="|";//or
      default: ascii_conv="X";
      
      endcase
      end
endmodule


/**
 * @brief Este modulo convierte un numero hexadecimal de 4 bits
 * en su equivalente ascii, pero binario, es decir,
 * si el numero ingresado es 4'hA, la salida debera sera la concatenacion
 * del string "1010" (cada caracter del string genera 8 bits).
 *
 * @param num		Corresponde al numero que se ingresa
 * @param bit_ascii	Corresponde a la representacion ascii pero del binario.
 *
 */
module hex_to_bit_ascii(
	input [3:0]num,
	output logic[4*8-1:0]bit_ascii
	);  
	always_comb begin
	   case(num)
	   4'h0: bit_ascii="0000";
	   4'h1: bit_ascii="0001";
	   4'h2: bit_ascii="0010";
	   4'h3: bit_ascii="0011";
	   4'h4: bit_ascii="0100";
	   4'h5: bit_ascii="0101";
	   4'h6: bit_ascii="0110";
	   4'h7: bit_ascii="0111";
	   4'h8: bit_ascii="1000";
	   4'h9: bit_ascii="1001";
	   4'hA: bit_ascii="1010";
	   4'hB: bit_ascii="1011"; 
	   4'hC: bit_ascii="1100";
	   4'hD: bit_ascii="1101";
	   4'hE: bit_ascii="1110";
	   4'hF: bit_ascii="1111";
	   
	   endcase
	   end
	
endmodule

/**
 * @brief Este modulo es el encargado de dibujar en pantalla
 * la calculadora y todos sus componentes graficos
 *
 * @param clk_vga		:Corresponde al reloj con que funciona el VGA.
 * @param rst			:Corresponde al reset de todos los registros
 * @param mode			:'0' si se esta operando en decimal, '1' si esta operando hexadecimal
 * @param op			:La operacion matematica a realizar
 * @param pos_x			:Corresponde a la posicion X del cursor dentro de la grilla.
 * @param pos_y			:Corresponde a la posicion Y del cursor dentro de la grilla.
 * @param op1			:El operando 1 en formato hexadecimal.
 * @param op2			;El operando 2 en formato hexadecimal.
 * @param input_screen	:Lo que se debe mostrar en la pantalla de ingreso de la calculadora (en hexa)
 * @param VGA_HS		:Sincronismo Horizontal para el monitor VGA
 * @param VGA_VS		:Sincronismo Vertical para el monitor VGA
 * @param VGA_R			:Color Rojo para la pantalla VGA
 * @param VGA_G			:Color Verde para la pantalla VGA
 * @param VGA_B			:Color Azul para la pantalla VGA
 */
module calculator_screen(
	input clk_vga,
	input rst,
	input mode, //bcd or dec.
	
	
	
	input logic[15:0]resultado,
	input logic[1:0]state,
	input logic BTNC,
	input logic [4:0]val,
	
	
	
	input [2:0]op,
	input [2:0]pos_x,
	input [1:0]pos_y,
	input [15:0] op1,
	input [15:0] op2,
	input [15:0] input_screen,
	
	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B
	);
	
	
	localparam CUADRILLA_XI = 		112;
	localparam CUADRILLA_XF = 		CUADRILLA_XI + 600;
	
	localparam CUADRILLA_YI = 		350;
	localparam CUADRILLA_YF = 		CUADRILLA_YI + 400;
	
	
	logic [10:0]vc_visible,hc_visible;
	
	// MODIFICAR ESTO PARA HACER LLAMADO POR NOMBRE DE PUERTO, NO POR ORDEN!!!!!
	driver_vga_1024x768 m_driver(.clk_vga(clk_vga), .hs(VGA_HS), .vs(VGA_VS), .hc_visible(hc_visible), .vc_visible(vc_visible));
	/*************************** VGA DISPLAY ************************/
		
	logic [10:0]hc_template, vc_template;
	logic [2:0]matrix_x;
	logic [1:0]matrix_y;
	logic lines;
	
	template_6x4_600x400 #( .GRID_XI(CUADRILLA_XI), 
							.GRID_XF(CUADRILLA_XF), 
							.GRID_YI(CUADRILLA_YI), 
							.GRID_YF(CUADRILLA_YF))
    // MODIFICAR ESTO PARA HACER LLAMADO POR NOMBRE DE PUERTO, NO POR ORDEN!!!!!
	template_1(.clk(clk_vga), .hc(hc_visible), .vc(vc_visible), .matrix_x(matrix_x), .matrix_y(matrix_y), .lines(lines));
	
	logic [11:0]VGA_COLOR;
	
	logic text_sqrt_fg;
	logic text_sqrt_bg;

	logic [50:0]generic_fg;
	logic [50:0]generic_bg;	

	localparam GRID_X_OFFSET	= 20;
	localparam GRID_Y_OFFSET	= 10;
	
	localparam FIRST_SQRT_X = 400;
	localparam FIRST_SQRT_Y = 200;
	

	
	hello_world_text_square m_hw(	.clk(clk_vga), 
									.rst(1'b0), 
									.hc_visible(hc_visible), 
									.vc_visible(vc_visible), 
									.in_square(text_sqrt_bg), 
									.in_character(text_sqrt_fg));
									
///////////////////////////////////////////////////////////////////////////////////////////////////////////////									
/*show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X - 300+ GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y  + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(13), 
					.n(15)) 
	show(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("        "), 
			.in_square(generic_bg[35]), 
			.in_character(generic_fg[35]));*/
			
			
			
												
	show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X - 300+ GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 80 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(5), 
					.n(4)) 
	bin1(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("0000"), 
			.in_square(generic_bg[50]), 
			.in_character(generic_fg[50]));

show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X - 150+ GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 80 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(5), 
					.n(4)) 
	bin2(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("0000"), 
			.in_square(generic_bg[30]), 
			.in_character(generic_fg[30]));

show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 80 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(5), 
					.n(4)) 
	bin3(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("0000"), 
			.in_square(generic_bg[31]), 
			.in_character(generic_fg[31]));

show_one_line #(.LINE_X_LOCATION(FIRST_SQRT_X + 150+ GRID_X_OFFSET), 
					.LINE_Y_LOCATION(FIRST_SQRT_Y + 80 + GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(4), 
					.ancho_pixel(5), 
					.n(4)) 
	bin4(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("0000"), 
			.in_square(generic_bg[32]), 
			.in_character(generic_fg[32]));		


///////////////////////////////////////////////Caracteres 1 fila ///////////////////////////////////////////////
	
	show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*0 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET)) 
	ch_00(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("0"),  
		  .in_character(generic_fg[0]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*1 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET))
	ch_01(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("1"),  
		  .in_character(generic_fg[1]));
		  
		  
		  
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*2 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET)) 
	ch_02(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("2"),  
		  .in_character(generic_fg[2]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*3 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET))
	ch_03(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("3"),  
		  .in_character(generic_fg[3]));
		  
		  	
		  	
		  	show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*4 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET)) 
	ch_0suma(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("+"),  
		  .in_character(generic_fg[4]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*5 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*0+ GRID_Y_OFFSET))
	ch_0resta(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("-"),  
		  .in_character(generic_fg[5]));
///////////////////////////////////////////////Caracteres 2 fila //////////////////////////////////////////////////		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*0 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET)) 
	ch_04(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("4"),  
		  .in_character(generic_fg[6]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*1 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET))
	ch_05(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("5"),  
		  .in_character(generic_fg[7]));
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*2 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET)) 
	ch_06(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("6"),  
		  .in_character(generic_fg[8]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*3 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET))
	ch_07(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("7"),  
		  .in_character(generic_fg[9]));
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*4 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET)) 
	ch_0mult(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("*"),  
		  .in_character(generic_fg[10]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*5 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*1+ GRID_Y_OFFSET))
	ch_0or(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("|"),  
		  .in_character(generic_fg[11]));
		  
	///////////////////////////////////////////////Caracteres 3 fila //////////////////////////////////////////////////	  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*0 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET)) 
	ch_08(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("8"),  
		  .in_character(generic_fg[12]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*1 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET))
	ch_09(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("9"),  
		  .in_character(generic_fg[13]));
		  
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*2 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET)) 
	ch_0a(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("A"),  
		  .in_character(generic_fg[14]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*3 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET))
	ch_0b(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("B"),  
		  .in_character(generic_fg[15]));
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*4 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET)) 
	ch_0and(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("&"),  
		  .in_character(generic_fg[16]));
		  
show_one_line #(.LINE_X_LOCATION((FIRST_SQRT_X - 280)+100*5-35 + GRID_X_OFFSET), 
					.LINE_Y_LOCATION((FIRST_SQRT_Y +160)+100*2+ GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(5), 
					.n(3)) 
	CE(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line(" CE"), 
			.in_character(generic_fg[49]));
		  
///////////////////////////////////////////////Caracteres 4 fila //////////////////////////////////////////////////		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*0 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET)) 
	ch_0c(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("C"),  
		  .in_character(generic_fg[18]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*1 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET))
	ch_0d(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("D"),  
		  .in_character(generic_fg[19]));
		  
		  
		  show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*2 + GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET)) 
	ch_0e(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("E"),  
		  .in_character(generic_fg[20]));
		  
show_one_char #(.CHAR_X_LOC((FIRST_SQRT_X - 280)+100*3+ GRID_X_OFFSET), 
					.CHAR_Y_LOC((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET))
	ch_0f(.clk(clk_vga), 
		  .rst(rst), 
		  .hc_visible(hc_visible), 
		  .vc_visible(vc_visible), 
		  .the_char("F"),  
		  .in_character(generic_fg[21]));
		  
		  
		  
		  
		  		  
show_one_line #(.LINE_X_LOCATION((FIRST_SQRT_X - 280)+100*4 -25 + GRID_X_OFFSET), 
					.LINE_Y_LOCATION((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(5), 
					.n(3)) 
	EXE(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("EXE"), 
			.in_character(generic_fg[48]));
		  
show_one_line #(.LINE_X_LOCATION((FIRST_SQRT_X - 280)+100*5 -25 + GRID_X_OFFSET), 
					.LINE_Y_LOCATION((FIRST_SQRT_Y +160)+100*3+ GRID_Y_OFFSET), 
					.MAX_CHARACTER_LINE(3), 
					.ancho_pixel(5), 
					.n(3)) 
	CLR(	.clk(clk_vga), 
			.rst(rst), 
			.hc_visible(hc_visible), 
			.vc_visible(vc_visible), 
			.the_line("CLR"), 
			.in_character(generic_fg[47]));
		  
		  
////////////////////////////////////////////////////////////////////////
		  
logic [7:0] modd;
	assign modd = (mode)? "1":"0";
	logic [15:0] numero_dec;
	

    logic [15:0] op_temp;
    
   
    
    always_comb begin
        case(state)
            2'b00: op_temp = op1;
            2'b01: op_temp = op2;
            2'b10: op_temp = 'b0;
            2'b11: op_temp = resultado;
            endcase end
            
    logic [15:0] show_num;
     
    double_dabble dab(.clk(clk_vga), .in(op_temp), .trigger(mode),.bcd(numero_dec));
    
    assign show_num = (mode)? numero_dec: op_temp;
            
    logic [7:0] bit4,bit3,bit2,bit1; 
    
    hex_to_ascii inst_bit4(.hex_num(show_num[15:12]), .ascii_conv(bit4));
    hex_to_ascii inst_bit3(.hex_num(show_num[11:8]), .ascii_conv(bit3));
    hex_to_ascii inst_bit2(.hex_num(show_num[7:4]), .ascii_conv(bit2));
    hex_to_ascii inst_bit1(.hex_num(show_num[3:0]), .ascii_conv(bit1)); 
    
    logic [31:0] bit_bin4 ,bit_bin3, bit_bin2, bit_bin1;                
    
    hex_to_bit_ascii inst_bit_bin4(.num(op_temp[15:12]), .bit_ascii(bit_bin4));
    hex_to_bit_ascii inst_bit_bin3(.num(op_temp[11:8]), .bit_ascii(bit_bin3));
    hex_to_bit_ascii inst_bit_bin2(.num(op_temp[7:4]), .bit_ascii(bit_bin2));
    hex_to_bit_ascii inst_bit_bin1(.num(op_temp[3:0]), .bit_ascii(bit_bin1));		  
		  
		  
	show_one_line #(.LINE_X_LOCATION(20), 
                   .LINE_Y_LOCATION(150), 
                   .MAX_CHARACTER_LINE(16), 
                   .ancho_pixel(10), 
                   .n(4))
                    
     prueba_conca( .clk(clk_vga), 
                   .rst(rst), 
                   .hc_visible(hc_visible), 
                   .vc_visible(vc_visible), 
                   .the_line({bit4 , bit3 , bit2 , bit1}), 
                   .in_square(generic_bg[37]), 
                   .in_character(generic_fg[37]));
                   
                   
                   
    logic [7:0] bit4_op1,bit3_op1,bit2_op1,bit1_op1;
    
    logic [31:0] show_op1;
    
    logic [15:0] op1_dec;
    
    double_dabble dab_op1(.clk(clk_vga), .in(op1), .trigger(mode),.bcd(op1_dec));   
    assign  show_op1 = (mode)? op1_dec: op1;
       
    
    hex_to_ascii inst_bit4_Q1(.hex_num(show_op1[15:12]), .ascii_conv(bit4_op1));
    hex_to_ascii inst_bit3_Q1(.hex_num(show_op1[11:8]), .ascii_conv(bit3_op1));
    hex_to_ascii inst_bit2_Q1(.hex_num(show_op1[7:4]), .ascii_conv(bit2_op1));
    hex_to_ascii inst_bit1_Q1(.hex_num(show_op1[3:0]), .ascii_conv(bit1_op1));
                             
                                 


     
    
	

	
	logic draw_cursor = (pos_x == matrix_x) && (pos_y == matrix_y);
	
	localparam COLOR_BLUE 		= 12'h00F;
	localparam COLOR_FONDO 		= 12'hFC0;
	localparam COLOR_YELLOW 	= 12'hFF0;
	localparam COLOR_RED		= 12'hF00;
	localparam COLOR_BLACK		= 12'h000;
	localparam COLOR_WHITE		= 12'hFFF;
	localparam COLOR_CYAN		= 12'h0FF;
	localparam COLOR_PURPLE		= 12'hD0F;
	
	
	always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
			
			if(text_sqrt_fg)
				VGA_COLOR = COLOR_RED;
			else if (text_sqrt_bg)
				VGA_COLOR = COLOR_YELLOW;
			else if(generic_fg)
				VGA_COLOR = COLOR_BLACK;
			else if(generic_bg)
				VGA_COLOR = COLOR_WHITE;
			
			//si esta dentro de la grilla.
			else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
				if(lines)//lineas negras de la grilla
					VGA_COLOR = COLOR_WHITE;
				else if (draw_cursor) //el cursor
					VGA_COLOR = COLOR_WHITE;
				else
					VGA_COLOR = {3'h7, {2'b0, matrix_x} + {3'b00, matrix_y}, 4'h3};// el fondo de la grilla.
			else
				VGA_COLOR = COLOR_FONDO;//el fondo de la pantalla
		end
		else
			VGA_COLOR = COLOR_BLACK;//esto es necesario para no poner en riesgo la pantalla.

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;
endmodule








/**
 * @brief Este modulo cambia los ceros a la izquierda de un numero, por espacios
 * @param value			:Corresponde al valor (en hexa o decimal) al que se le desea hacer el padding.
 * @param no_pading		:Corresponde al equivalente ascii del value includos los ceros a la izquierda
 * @param padding		:Corresponde al equivalente ascii del value, pero sin los ceros a la izquierda.
 */

module space_padding(
	input [19:0] value,
	input [8*6 -1:0]no_pading,
	
	output logic [8*6 -1:0]padding);
	
	
endmodule














 