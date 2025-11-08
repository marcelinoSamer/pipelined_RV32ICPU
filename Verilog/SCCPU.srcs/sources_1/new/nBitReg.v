`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 05:13:14 PM
// Design Name: 
// Module Name: nBitReg
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


module nBitReg #(parameter n = 8) (
    input clk, input rst, input load, input [n-1:0] D, output [n-1:0] Q
    );
   
    
    wire [n-1:0] Mo;
     
    genvar i;
    generate
    for (i = 0; i<n; i=i+1) begin: myloop
    MUX2x1 m (.a(Q[i]), .b(D[i]), .s(load), .c(Mo[i]));
    DFlipflop d1 (.clk(clk), .rst(rst), .D(Mo[i]), .Q(Q[i]));
    end
    endgenerate
    
endmodule
