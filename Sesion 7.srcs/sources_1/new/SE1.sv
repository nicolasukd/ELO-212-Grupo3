`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2019 12:22:10
// Design Name: 
// Module Name: SE1
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


module SE1(
    input logic CLK100MHZ,
    input logic CPU_RESETN,UART_TXD_IN,UART_RXD_OUT,
    output logic [7:0]AN,
    output logic CA,CB,CC,CD,CE,CF,CG,  
    output logic [11:0]LED,
    output logic LED16_B,LED16_G,LED16_R
    );
    logic [7:0]rx_data,digitos;
    logic rx_ready,clkout,trigger,muestra_resultado;
    logic tx_start,tx_data;
    
    logic [15:0]op1,op2,op1_d,op2_d,cp1,cp2;
    logic [1:0]cmd;
    logic [3:0]botones;
    logic [15:0]alu_hexa,alu_d;
     
    clockdivider #(10000) diez(.clkin(CLK100MHZ),.reset(CPU_RESETN),.clkout(clkout));
    
    uart_basic U0(.clk(CLK100MHZ),.rx(UART_TXD_IN),.reset(~CPU_RESETN),.rx_data(rx_data),.rx_ready(rx_ready));
    
    
    rx_control U1(.clk(CLK100MHZ),.reset(~CPU_RESETN),.rx_ready(rx_ready)
    ,.rx_in_data(rx_data),.rx_out1_data(op1),.rx_out2_data(op2),.alu_ctrl(cmd),.leds(LED[11:0]),.trigger(trigger),.muestra_resultado(muestra_resultado));
    
    display  U2(.digitos(digitos),.an(AN),.sevenSeg({CA,CB,CC,CD,CE,CF,CG}),.clk(clkout),.reset(CPU_RESETN),
    .d1(cp1[15:12]),.d2(cp1[11:8]),.d3(cp1[7:4]),.d4(cp1[3:0]),.d5(cp2[15:12]),.d6(cp2[11:8]),.d7(cp2[7:4]),.d8(cp2[3:0]));
    
    alubits #(16)U3(.botones(botones),.A(op1),.B(op2),.salida(alu_hexa));
    
    unsigned_to_bcd U4(.clk(CLK100MHZ),.trigger(1),.in(op1),.bcd(op1_d));
    unsigned_to_bcd U5(.clk(CLK100MHZ),.trigger(1),.in(op2),.bcd(op2_d));
    unsigned_to_bcd U6(.clk(CLK100MHZ),.trigger(1),.in(alu_hexa),.bcd(alu_d));
    
    tx_control U7(.tx_start(tx_start),.tx_data(tx_data),.dataIn16(alu_hexa),.PB(trigger));
    
    
    uart_basic U8(.clk(CLK100MHZ),.tx(UART_RXD_OUT),.reset(~CPU_RESETN),.tx_data(tx_data),.tx_start(tx_start));
    
   /* always_ff @(posedge CLK100MHZ)begin
         case(muestra_resultado)
            1:begin
                digitos = 8'b11110000;
                cp1 = alu_d;    
            end
            0:begin
                digitos = 8'b11111111;
                cp1 = op1_d;
                cp2 = op2_d;
            end
        endcase
    end*/
    
    always_comb begin  
        case(muestra_resultado)
            1:begin
                digitos = 8'b11110000;
                cp1 = alu_d;   
                cp2 = 'd0; 
            end
            0:begin
                digitos = 8'b11111111;
                cp1 = op1_d;
                cp2 = op2_d;
            end
            default:begin
                digitos = 8'b11111111; 
                cp1 = 'd0;
                cp2 = 'd0;      
            end
        endcase 
       
       
        case(cmd)
            2'b00:begin
                LED16_B = 1;
                LED16_G = 0;
                LED16_R = 0;
                botones = 4'b1000;
            end
            2'b01:begin
                LED16_B = 0;
                LED16_G = 1;
                LED16_R = 0;
                botones = 4'b0100;
            end
            2'b10:begin
                LED16_B = 0;
                LED16_G = 0;
                LED16_R = 1;
                botones = 4'b0001;
            end
            2'b11:begin
                LED16_B = 1;
                LED16_G = 1;
                LED16_R = 1;
                botones = 4'b0010;
                
            end
            default:begin
                LED16_B = 0;
                LED16_G = 0;
                LED16_R = 0;
                botones = 4'b0000;
                
            end
        endcase
            
        
    end


endmodule


