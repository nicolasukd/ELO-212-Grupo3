`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2019 11:51:40
// Design Name: 
// Module Name: display
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


module display (
    input logic [7:0]digitos,
    input logic clk,reset,
    input logic [3:0]d1,d2,d3,d4,d5,d6,d7,d8,
    output logic [7:0]an,
    output logic [6:0]sevenSeg
                );
    logic [3:0] BCD;
    logic [3:0] count = 4'b0000;
    BCDto7 U2(.BCD(BCD),.sevenSeg(sevenSeg));
    
    always_ff @(posedge clk)begin
        if (~reset)
            count <= 4'b0000;
        else
            count <= count + 1;
        case(count) 
            4'b0001: begin 
                    if(digitos[7]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b10000000;
                        BCD <= d1;
                    end
            end
            4'b0010: begin
                    if(digitos[6]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b01000000;
                        BCD <= d2;
                    end
                    
            end
            4'b0011: begin
                    if(digitos[5]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00100000;
                        BCD <= d3;
                    end
                    
            end
            4'b0100: begin
                    if(digitos[4]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00010000;
                        BCD <= d4;
                    end
                    
            end
            4'b0101: begin
                    if(digitos[3]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00001000;
                        BCD <= d5;
                    end
                    
            end
            4'b0110: begin
                    if(digitos[2]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00000100;
                        BCD <= d6;
                    end
                    
            end
            4'b0111: begin
                    if(digitos[1]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00000010;
                        BCD <= d7;
                    end
                    
            end
            4'b1000: begin
                    if(digitos[0]==0)
                        an <= ~8'b00000000;
                    else begin
                        an <= ~8'b00000001;
                        BCD <= d8;
                    end  
                    count <= 4'b0000;
                    
            end
            default: begin
                    an <= ~8'b00000000;
                    BCD <= 0;
            end
        endcase
            
    end

endmodule
