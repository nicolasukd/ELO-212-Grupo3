`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:41:15
// Design Name: 
// Module Name: smart_counter
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


/*
**	El Objetivo de este modulo consiste en poder generar los segundos, minutos, hora del reloj.
**  output_counter vendria siendo el segundo/minuto/hora dependiendo de la senal de trigger,
**  es decir, output_counter aumenta a medida que que trigger_counter alcanza COUNTER_TRIGGER_MAX
**  y trigger_counter aumenta a medida que le llega una senal de triger.
**  Ademas, outpu_counter puede aumentar si se le apreta un boton.
*/

module smart_counter(
	input logic trigger, clk, rst, BTN, BTN_pos, BTN_neg,
	output logic trigger_out,
	output logic [7:0] output_counter
    );
    
parameter OUTPUT_COUNTER_MAX = 60;
parameter COUNTER_TRIGGER_MAX = 100000000; // Contador para que trigger se active
localparam COUNTER_HOLD_MAX = 50000000; // Cuando se llega a este numero, output_counter se le suma 1
localparam COUNTER_TRIGGER_BIT = $clog2(COUNTER_TRIGGER_MAX);
localparam COUNTER_BUTTON_PRESS_MAX = 300000000; // Cuando el boton se mantiene mas de 3 segundos, cambia de estado
localparam COUNTER_BUTTON_PRESS_BIT = $clog2(COUNTER_BUTTON_PRESS_MAX);

enum logic [1:0] {IDLE, BUTTON_PRESSED, COUNTER_RESET, BUTTON_HOLD} state, next_state; // Estados

// CONTADORES__________________________________________________________________
logic [COUNTER_TRIGGER_BIT:0] counter_trigger, next_counter_trigger;
logic [COUNTER_BUTTON_PRESS_BIT:0] button_counter, next_button_counter; 

logic [7:0] next_output_counter;


// MAQUINA DE ESTADOS_________________________________________________________
always_comb begin
	next_state = state;
	case(state)
		IDLE:	begin
			if (BTN_pos)
				next_state = BUTTON_PRESSED;
		end
		BUTTON_PRESSED: begin
			if (button_counter >= COUNTER_BUTTON_PRESS_MAX)
				next_state = COUNTER_RESET;
			else if (BTN_neg)
				next_state = IDLE;
		end
		COUNTER_RESET:
			next_state = BUTTON_HOLD;
		BUTTON_HOLD: begin
			if (button_counter >= COUNTER_HOLD_MAX)
				next_state = COUNTER_RESET;
			else if (BTN_neg)
				next_state = IDLE;
		end
	endcase
end
// FLIP FLOP MAQUINAS DE ESTADO
always_ff@(posedge clk) begin
	if (rst == 1'b1)
		state <= IDLE;
	else
		state <= next_state;
end

// VALORES DE SALIDA______________________________________________
always_comb begin
	next_output_counter = output_counter;
	trigger_out = 1'b0;
	case(state)
		IDLE: begin
			if(counter_trigger >= COUNTER_TRIGGER_MAX-1) begin // si sobrepasa COUNTER_TRIGGER, al contador de salida se le suma 1
				next_output_counter = output_counter + 'd1;
				trigger_out = 1'b1;
			end
			else if (BTN_pos) // Si se apreta una vez el boton, la salida aumenta
				next_output_counter = output_counter + 'd1;
		end
		BUTTON_PRESSED: begin
			if (button_counter >= COUNTER_BUTTON_PRESS_MAX) // si el boton se mantiene apretado, la salida aumenta
				next_output_counter = output_counter + 'd1;
		end
		BUTTON_HOLD: begin
			if (button_counter >= COUNTER_HOLD_MAX) 
				next_output_counter = output_counter + 'd1;	
		end
	endcase
end


// CONTADORES_____________________________________________________
always_comb begin
	next_counter_trigger = counter_trigger; // NOTESE QUE COUNTER_TRIGGER SOLO AUMENTA EN IDLE
	next_button_counter = 'd0;
	case(state)
		IDLE: begin
			next_counter_trigger = (trigger == 1'b1)? counter_trigger + 'd1: counter_trigger;
		end
		BUTTON_PRESSED: begin
			next_button_counter = button_counter + 'd1;
		end
		BUTTON_HOLD: begin
			next_button_counter = button_counter + 'd1;
		end
	endcase
end

// FLIP FLOP contadores
always_ff@(posedge clk) begin
	if (rst) begin
		output_counter <= 'd0;
		counter_trigger <= 'd0;
		button_counter <= 'd0;
	end
	else begin
		button_counter <= next_button_counter;
		if (output_counter == OUTPUT_COUNTER_MAX-1)
			output_counter <= 'd0;
		else
			output_counter <= next_output_counter;
			
		if (counter_trigger == COUNTER_TRIGGER_MAX-1)
			counter_trigger <= 'd0;
		else
			counter_trigger <= next_counter_trigger;
			
	end
end

endmodule
