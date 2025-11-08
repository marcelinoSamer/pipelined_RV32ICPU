`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 05:12:04 PM
// Design Name: 
// Module Name: DFlipflop
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


module DFlipflop(
    input clk, input rst, input D, output reg Q
    );
    
    always @ (posedge clk or posedge rst)
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
endmodule
