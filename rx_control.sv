`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2019 20:42:42
// Design Name: 
// Module Name: rx_control
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

//rx_control U0(.clk(CLK100MHZ),.reset(~CPU_RESETN),.rx_ready(BTNC),.rx_in_data(UART_TXD_IN),.rx_out1_data(),.rx_out2_data(),.alu_ctrl(),.leds(LED));
    

module rx_control(
    input logic clk,reset,rx_ready,
    input logic [7:0]rx_in_data,
    output logic [15:0]rx_out1_data,rx_out2_data,   
    output logic [1:0] alu_ctrl,
    output logic [11:0]leds,
    output logic trigger, muestra_resultado
    );
    logic [15:0]op1,op1_next,op2,op2_next;
    logic [1:0]cmd,cmd_next;
    logic guardar1,guardar2,guardar3;
    //logic PB;
    
    enum logic [4:0]{Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result}state,next_state;
    
    //PBdebouncer rxready(.clk(clk),.rst(reset),.PB(rx_ready),.PB_pressed_pulse(PB));
    
    bancoregistros_sin_clk #(16) U0(.guardar(guardar1),.entrada(op1),.salida(rx_out1_data));
    bancoregistros_sin_clk #(16) U1(.guardar(guardar2),.entrada(op2),.salida(rx_out2_data));
    bancoregistros_sin_clk #(2) U2(.guardar(guardar3) ,.entrada(cmd),.salida(alu_ctrl));
    
    /*bancoregistros #(16) U0(.guardar(guardar1),.clock(clk),.reset(reset),.entrada(op1),.salida(rx_out1_data),.enable(1'b1));
    bancoregistros #(16) U1(.guardar(guardar2),.clock(clk),.reset(reset),.entrada(op2),.salida(rx_out2_data),.enable(1'b1));
    bancoregistros #(2) U2(.guardar(guardar3),.clock(clk),.reset(reset),.entrada(cmd),.salida(alu_ctrl),.enable(1'b1));*/
    
    
    
    
    always_ff @(posedge clk, posedge reset)begin
    	if(reset)begin
    		state <= Wait_OP1_LSB;
    	end
    	else
    		state <= next_state;
    		op1<=op1_next;
    		op2<=op2_next;
    		cmd<=cmd_next;
    end
    
    
    
    always_comb begin
        next_state = state;
        op1_next = op1;
        op2_next = op2;
    	cmd_next = cmd;
        guardar1 = 0;
        guardar2 = 0;
       guardar3 = 0;
        
        
        case(state)
            Wait_OP1_LSB:begin
                leds = 12'd1;;
                trigger = 0;
                muestra_resultado = 1;
                
                if(rx_ready)begin
                    next_state = Store_OP1_LSB; 
   
                end
                else begin
                    next_state = Wait_OP1_LSB;
                end
            end
            Store_OP1_LSB: begin
                leds = 12'd2;
                
                trigger = 0;
                muestra_resultado = 0;
                
                guardar1 = 1;
                
                next_state = Wait_OP1_MSB; 
                
                muestra_resultado = 0;
                
                op1_next[7:0] = rx_in_data;                       
            end
            Wait_OP1_MSB: begin
                leds = 12'd4;
                

                trigger = 0;
                muestra_resultado = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP1_MSB;    
                end 
                else begin
                    next_state = Wait_OP1_MSB;
                end         
            end
            Store_OP1_MSB: begin
                leds = 12'd8;

                trigger = 0;
                muestra_resultado = 0;
                
                guardar1 = 1;
                
                next_state = Wait_OP2_LSB;
                op1_next[15:8] = rx_in_data;             
            end
            Wait_OP2_LSB: begin
                leds = 12'd16;
                
                trigger = 0;
                muestra_resultado = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP2_LSB;    
                end    
                else begin
                    next_state = Wait_OP2_LSB;
                end
            end
            Store_OP2_LSB: begin
                leds = 12'd32;
                

                trigger = 0;
                muestra_resultado = 0;
                
                guardar2 = 1;

                
                next_state = Wait_OP2_MSB;
                op2_next[7:0] = rx_in_data;             
            end
            Wait_OP2_MSB: begin
                leds = 12'd64;
                
                trigger = 0;
                muestra_resultado = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP2_MSB;    
                end 
                else begin
                    next_state = Wait_OP2_MSB;
                end   
            end
            Store_OP2_MSB: begin
                leds = 12'd128;
                

                trigger = 0;
                muestra_resultado = 0;
                
                guardar2 = 1;

                
                next_state = Wait_CMD;
                op2_next[15:8] = rx_in_data; 
            end
            Wait_CMD: begin
                leds = 12'd256;
                
                trigger = 0;
                muestra_resultado = 0;
                
                
                if(rx_ready)begin
                    next_state = Store_CMD;    
                end    
                else begin
                    next_state = Wait_CMD;
                end                     
            end
            Store_CMD:begin
                leds = 12'd512;
                

                trigger = 0;
                
                guardar3 = 1;
                
                muestra_resultado = 1;
                
                next_state = Delay_1_cycle;
                cmd_next = rx_in_data[1:0];    
            end
            Delay_1_cycle:begin
                leds = 12'd1024;

                trigger = 0;
                muestra_resultado = 1;
                next_state = Trigger_TX_result;    
            end
            Trigger_TX_result:begin
                leds = 12'd2048;
  
                muestra_resultado = 1;
                
                next_state = Wait_OP1_LSB;
                trigger = 1;
                
            end
            default:begin
                leds = 12'd0;
                
                next_state = Wait_OP1_LSB;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;

                trigger = 0;
                muestra_resultado = 0;
                
                
            end
                     
            
        endcase
    end
endmodule
