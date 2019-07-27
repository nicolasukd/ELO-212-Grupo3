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

/*display  U1(.digitos(digitos),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(SW[15:12]),.d2(SW[11:8]),.d3(4'd0),.d4(respuesta[7:4]),.d5(respuesta[3:0]),.d6(4'd0),.d7(SW[7:4]),.d8(SW[3:0]));*/

module display (
    input logic [7:0]digitos,
    input logic clk,reset,
    input logic [3:0]d1,d2,d3,d4,d5,d6,d7,d8,
    output logic [7:0]an,
    output logic [6:0]sevenSeg
                );
    logic [3:0] BCD;
    logic [3:0] count = 4'b0000;
    always_comb begin
        case(BCD)
            4'd0: sevenSeg = ~7'b1111110;
            4'd1: sevenSeg = ~7'b0110000;
            4'd2: sevenSeg = ~7'b1101101;
            4'd3: sevenSeg = ~7'b1111001;
            4'd4: sevenSeg = ~7'b0110011;
            4'd5: sevenSeg = ~7'b1011011;
            4'd6: sevenSeg = ~7'b1011111;
            4'd7: sevenSeg = ~7'b1110000;
            4'd8: sevenSeg = ~7'b1111111;
            4'd9: sevenSeg = ~7'b1111011;
            4'd10: sevenSeg = ~7'b1110111;
            4'd11: sevenSeg = ~7'b0011111;
            4'd12: sevenSeg = ~7'b1001110;
            4'd13: sevenSeg = ~7'b0111101;
            4'd14: sevenSeg = ~7'b1001111;
            4'd15: sevenSeg = ~7'b1000111;
            default: sevenSeg = 8'd0;
        endcase
    end
    
    
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
