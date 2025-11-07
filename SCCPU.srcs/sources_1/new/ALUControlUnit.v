`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 04:54:23 AM
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(
input [3:0] instruction, [1:0]ALUop, input clk, output reg [3:0]ALUS
    );
    
    always @ (*) begin
    if (ALUop == 2'b00) ALUS = 4'b0010;
    else if (ALUop == 2'b01) ALUS = 4'b0110;
    else if (ALUop == 2'b10) begin
        case (instruction)
            4'b0000: ALUS = 4'b0010;
            4'b0001: ALUS = 4'b0110;
            4'b1110: ALUS = 4'b0000;
            4'b1100: ALUS = 4'b0001;
            default: ALUS = 4'b1111;
        endcase
    end
    
    end
endmodule
