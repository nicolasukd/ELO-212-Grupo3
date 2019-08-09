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


module rx_control(
    input logic clk,reset,rx_ready,
    input logic [7:0]rx_in_data,
    output logic [15:0]rx_out1_data,rx_out2_data,   
    output logic [1:0] alu_ctrl,
    output logic [7:0]estado 
    );
    logic [15:0]op1,op2;
    logic [1:0]cmd;
    logic guardar1,guardar2,guardar3;
    //logic PB;
    
    enum logic [4:0]{Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result}state,next_state;
    
    //PBdebouncer rxready(.clk(clk),.rst(reset),.PB(rx_ready),.PB_pressed_pulse(PB));
    
    bancoregistros #(16) U0(.guardar(guardar1),.clock(clk),.reset(reset),.entrada(op1),.salida(rx_out1_data),.enable(1'b1));
    bancoregistros #(16) U1(.guardar(guardar2),.clock(clk),.reset(reset),.entrada(op2),.salida(rx_out2_data),.enable(1'b1));
    bancoregistros #(2) U2(.guardar(guardar3),.clock(clk),.reset(reset),.entrada(cmd),.salida(alu_ctrl),.enable(1'b1));
    
    
    
    
    
    
    always_ff @(posedge clk )begin
    	if(reset)
    		state <= Wait_OP1_LSB;
    	else
    		state <= next_state;
    end
    
    
    
    always_comb begin
        next_state = state;
        
        
        case(state)
            Wait_OP1_LSB:begin
                estado = 8'd1;
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;
                if(rx_ready)begin
                    next_state = Store_OP1_LSB; 
   
                end
                else begin
                    next_state = Wait_OP1_LSB;
                end
            end
            Store_OP1_LSB: begin
                estado = 8'd2;
                
                guardar1 = 1;
                guardar2 = 0;
                guardar3 = 0;
                
                next_state = Wait_OP1_MSB; 
                
                op1[7:0] = rx_in_data;                       
            end
            Wait_OP1_MSB: begin
                estado = 8'd3;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP1_MSB;    
                end 
                else begin
                    next_state = Wait_OP1_MSB;
                end         
            end
            Store_OP1_MSB: begin
                estado = 8'd4;
                
                guardar1 = 1;
                guardar2 = 0;
                guardar3 = 0;
                
                next_state = Wait_OP2_LSB;
                op1[15:8] = rx_in_data;             
            end
            Wait_OP2_LSB: begin
                estado = 8'd5;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP2_LSB;    
                end    
                else begin
                    next_state = Wait_OP2_LSB;
                end
            end
            Store_OP2_LSB: begin
                estado = 8'd6;
                
                guardar1 = 0;
                guardar2 = 1;
                guardar3 = 0;
                
                next_state = Wait_OP2_MSB;
                op2[7:0] = rx_in_data;             
            end
            Wait_OP2_MSB: begin
                estado = 8'd7;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;
                
                if(rx_ready)begin
                    next_state = Store_OP2_MSB;    
                end 
                else begin
                    next_state = Wait_OP2_MSB;
                end   
            end
            Store_OP2_MSB: begin
                estado = 8'd8;
                
                guardar1 = 0;
                guardar2 = 1;
                guardar3 = 0;
                
                next_state = Wait_CMD;
                op2[15:8] = rx_in_data; 
            end
            Wait_CMD: begin
                estado = 8'd9;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 0;
                
                if(rx_ready)begin
                    next_state = Store_CMD;    
                end                        
            end
            Store_CMD:begin
                estado = 8'd10;
                
                guardar1 = 0;
                guardar2 = 0;
                guardar3 = 1;
                
                next_state = Delay_1_cycle;
                cmd = rx_in_data[1:0];    
            end
            Delay_1_cycle:begin
                estado = 8'd11;
                next_state = Trigger_TX_result;    
            end
            Trigger_TX_result:begin
                estado = 8'd12;
                next_state = Wait_OP1_LSB;
                
            end
                     
            
        endcase
    end
endmodule
