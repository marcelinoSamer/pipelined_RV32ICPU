`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 05:26:01 PM
// Design Name: 
// Module Name: nBitMUX
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


module nBitMUX #(parameter n = 8)(
input [n-1:0] a, b, input s, output [n-1:0] c
    ); 
    
    genvar i;
    generate 
    for(i=0; i<n; i=i+1) begin:myloop
        MUX2x1 m(.a(a[i]), .b(b[i]), .s(s), .c(c[i]));
    end
    endgenerate
endmodule
