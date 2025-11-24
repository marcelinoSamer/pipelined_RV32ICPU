`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 05:02:41 PM
// Design Name: 
// Module Name: RCA
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


module RCA #(parameter n = 32)(
input [n-1:0] x, y,
input cin,
output [n-1:0] S,
output Cout
    );
    wire [n:0] C;
    assign C[0] = cin;
    genvar i;
    generate
    for(i = 0; i<n; i=i+1)begin: myloop
        fullAdder An (.A(x[i]), .B(y[i]), .Cin(C[i]), .S(S[i]), .Cout(C[i+1]));
    end
    endgenerate
    
    assign Cout = C[n];
    
endmodule

