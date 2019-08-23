`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2019 16:54:09
// Design Name: 
// Module Name: estados
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


module estados(
    input logic rst, trans,clk,
    output logic [1:0] estado,
    output logic [3:0] hold
);

    enum logic [1:0] {wait_op1 , wait_op2, wait_op, show_result} next_state, state;
    
    always_ff@(posedge clk) begin
    
        if (rst) state <= wait_op1;
        else if (clk) state <= next_state;
        
        end    
    
    assign estado = state; 
    always_comb begin
        next_state = state;
        hold = 4'b0000;
        
        case (state) 
        wait_op1:   if (trans)begin
                         next_state = wait_op2;
                         hold = 4'b0001; end
                
        wait_op2:   if (trans) begin
                        next_state = wait_op;
                        hold = 4'b0011; end
    
        wait_op:  if (trans) begin
                        next_state = show_result;
                        hold = 4'b0111; end
                      
        show_result: if (trans) begin 
                        next_state = wait_op1;
                        hold = 4'b0000; end
                    
        
        endcase
            
    
    end
endmodule
