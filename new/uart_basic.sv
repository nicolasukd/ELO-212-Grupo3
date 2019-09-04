`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 11:22:29
// Design Name: 
// Module Name: uart_basic
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


module uart_basic
#(
	parameter CLK_FREQUENCY = 100000000,
	parameter BAUD_RATE = 115200
)(
	input clk,
	input reset,
	input rx,
	output [7:0] rx_data,
	output reg rx_ready,
	output tx,
	input tx_start,
	input [7:0] tx_data,
	output tx_busy
);

	wire baud8_tick;
	wire baud_tick;

	reg rx_ready_sync;
	wire rx_ready_pre;

	uart_baud_tick_gen #(
		.CLK_FREQUENCY(CLK_FREQUENCY),
		.BAUD_RATE(BAUD_RATE),
		.OVERSAMPLING(8)
	) baud8_tick_blk (
		.clk(clk),
		.enable(1'b1),
		.tick(baud8_tick)
	);

	uart_rx uart_rx_blk (
		.clk(clk),
		.reset(reset),
		.baud8_tick(baud8_tick),
		.rx(rx),
		.rx_data(rx_data),
		.rx_ready(rx_ready_pre)
	);

	always @(posedge clk) begin
		rx_ready_sync <= rx_ready_pre;
		rx_ready <= ~rx_ready_sync & rx_ready_pre;
	end


	uart_baud_tick_gen #(
		.CLK_FREQUENCY(CLK_FREQUENCY),
		.BAUD_RATE(BAUD_RATE),
		.OVERSAMPLING(1)
	) baud_tick_blk (
		.clk(clk),
		.enable(tx_busy),
		.tick(baud_tick)
	);

	uart_tx uart_tx_blk (
		.clk(clk),
		.reset(reset),
		.baud_tick(baud_tick),
		.tx(tx),
		.tx_start(tx_start),
		.tx_data(tx_data),
		.tx_busy(tx_busy)
	);

endmodule

module uart_baud_tick_gen
#(
	parameter CLK_FREQUENCY = 25000000,
	parameter BAUD_RATE = 115200,
	parameter OVERSAMPLING = 1
)(
	input clk,
	input enable,
	output tick
);

	function integer clog2;
		input integer value;
		begin
			value = value - 1;
			for (clog2 = 0; value > 0; clog2 = clog2 + 1)
				value = value >> 1;
		end
	endfunction

	localparam ACC_WIDTH = clog2(CLK_FREQUENCY / BAUD_RATE) + 8;
	localparam SHIFT_LIMITER = clog2(BAUD_RATE * OVERSAMPLING >> (31 - ACC_WIDTH));
	localparam INCREMENT =
			((BAUD_RATE * OVERSAMPLING << (ACC_WIDTH - SHIFT_LIMITER)) +
			(CLK_FREQUENCY >> (SHIFT_LIMITER + 1))) / (CLK_FREQUENCY >> SHIFT_LIMITER);

	(* keep = "true" *)
	reg [ACC_WIDTH:0] acc = 0;

	always @(posedge clk)
		if (enable)
			acc <= acc[ACC_WIDTH-1:0] + INCREMENT[ACC_WIDTH:0];
		else
			acc <= INCREMENT[ACC_WIDTH:0];

	assign tick = acc[ACC_WIDTH];

endmodule


module uart_rx
(
	input clk,
	input reset,
	input baud8_tick,
	input rx,
	output reg [7:0] rx_data,
	output reg rx_ready
);

	localparam RX_IDLE  = 'b000;
	localparam RX_START = 'b001;
	localparam RX_RECV  = 'b010;
	localparam RX_STOP  = 'b011;
	localparam RX_READY = 'b100;

	/* Clock synchronized rx input */
	wire rx_bit;
	data_sync rx_sync_inst (
		.clk(clk),
		.in(rx),
		.stable_out(rx_bit)
	);

	/* Bit spacing counter (oversampling) */
	reg [2:0] spacing_counter = 'd0, spacing_counter_next;
	wire next_bit;
	assign next_bit = (spacing_counter == 'd4);

	/* Finite-state machine */
	reg [2:0] state = RX_IDLE, state_next;
	reg [2:0] bit_counter = 'd0, bit_counter_next;
	reg [7:0] rx_data_next;

	always @(*) begin
		state_next = state;

		case (state)
		RX_IDLE:
			if (rx_bit == 1'b0)
				state_next = RX_START;
		RX_START: begin
			if (next_bit) begin
				if (rx_bit == 1'b0) // Start bit must be a 0
					state_next = RX_RECV;
				else
					state_next = RX_IDLE;
			end
		end
		RX_RECV:
			if (next_bit && bit_counter == 'd7)
				state_next = RX_STOP;
		RX_STOP:
			if (next_bit)
				state_next = RX_READY;
		RX_READY:
			state_next = RX_IDLE;
		default:
			state_next = RX_IDLE;
		endcase
	end

	always @(*) begin
		bit_counter_next = bit_counter;
		spacing_counter_next = spacing_counter + 'd1;
		rx_ready = 1'b0;
		rx_data_next = rx_data;

		case (state)
		RX_IDLE: begin
			bit_counter_next = 'd0;
			spacing_counter_next = 'd0;
		end
		RX_RECV: begin
			if (next_bit) begin
				bit_counter_next = bit_counter + 'd1;
				rx_data_next = {rx_bit, rx_data[7:1]};
			end
		end
		RX_READY:
			rx_ready = 1'b1;
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			spacing_counter <= 'd0;
			bit_counter <= 'd0;
			state <= RX_IDLE;
			rx_data <= 'd0;
		end else if (baud8_tick) begin
			spacing_counter <= spacing_counter_next;
			bit_counter <= bit_counter_next;
			state <= state_next;
			rx_data <= rx_data_next;
		end
	end

endmodule

module uart_tx
(
	input clk,
	input reset,
	input baud_tick,
	input tx_start,
	input [7:0] tx_data,
	output reg tx,
	output reg tx_busy
);

	localparam TX_IDLE  = 2'b00;
	localparam TX_START = 2'b01;
	localparam TX_SEND  = 2'b10;
	localparam TX_STOP  = 2'b11;

	reg [1:0] state = TX_IDLE, state_next;
	reg [2:0] counter = 3'd0, counter_next;
    reg [7:0] tx_data_reg;
    
    always @(posedge clk) begin
        if (reset)
            tx_data_reg <= 'd0;
        else if (state == TX_IDLE && tx_start)
            tx_data_reg <= tx_data;
    end

	always @(*) begin
		tx = 1'b1;
		tx_busy = 1'b1;
		state_next = state;
		counter_next = counter;

		case (state)
		TX_IDLE: begin
			tx_busy = 1'b0;
			state_next = (tx_start) ? TX_START : TX_IDLE;
		end
		TX_START: begin
			tx = 1'b0;
			state_next = (baud_tick) ? TX_SEND : TX_START;
			counter_next = 'd0;
		end
		TX_SEND: begin
			tx = tx_data_reg[counter];
			if (baud_tick) begin
				state_next = (counter == 'd7) ? TX_STOP : TX_SEND;
				counter_next = counter + 'd1;
			end
		end
		TX_STOP:
			state_next = (baud_tick) ? TX_IDLE : TX_STOP;
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			state <= TX_IDLE;
			counter <= 'd0;
		end else begin
			state <= state_next;
			counter <= counter_next;
		end
	end

endmodule


module data_sync
(
	input clk,
	input in,
	output reg stable_out
);

	/* Clock synchronized input */
	reg [1:0] in_sync_sr;
	wire in_sync = in_sync_sr[0];

	always @(posedge clk)
		in_sync_sr <= {in, in_sync_sr[1]};

	/* Filter out short spikes on the input line */
	reg [1:0] sync_counter = 'b11, sync_counter_next;
	reg stable_out_next;

	always @(*) begin
		if (in_sync == 1'b1 && sync_counter != 2'b11)
			sync_counter_next = sync_counter + 'd1;
		else if (in_sync == 1'b0 && sync_counter != 2'b00)
			sync_counter_next = sync_counter - 'd1;
		else
			sync_counter_next = sync_counter;
	end

	always @(*) begin
		case (sync_counter)
		2'b00:
			stable_out_next = 1'b0;
		2'b11:
			stable_out_next = 1'b1;
		default:
			/* Keep the previous value if the counter is not on its boundaries */
			stable_out_next = stable_out;
		endcase
	end

	always @(posedge clk) begin
		stable_out <= stable_out_next;
		sync_counter <= sync_counter_next;
	end

endmodule
