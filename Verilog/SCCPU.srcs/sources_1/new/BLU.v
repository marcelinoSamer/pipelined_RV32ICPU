`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 11:08:09 PM
// Design Name: 
// Module Name: BLU
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
`include "defines.v"

module BLU(
    input branch,
    input [2:0]  F3,

    input z,
    input s,   
    input c,
    input v,

    output reg branchTaken
    );
    always @* begin
        case(F3)
            `BR_BEQ:begin
                if (z) branchTaken = 1;
                else branchTaken = 0;
            end
            `BR_BNE:begin
                if (!z) branchTaken = 1;
                else branchTaken = 0;
            end
            `BR_BLT:begin
                if (s!=v) branchTaken = 1;
                else branchTaken = 0;
            end
            `BR_BGE:begin
                if (s==v) branchTaken = 1;
                else branchTaken = 0;
            end
            `BR_BLTU:begin
                if (!c) branchTaken = 1;
                else branchTaken = 0;
            end
            `BR_BGEU:begin
                if (c) branchTaken = 1;
                else branchTaken = 0;
            end
        endcase
    end
    
endmodule
