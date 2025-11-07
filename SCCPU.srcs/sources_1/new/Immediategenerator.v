`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2025 04:28:09 PM
// Design Name: 
// Module Name: Immediategenerator
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


module Immediategenerator(
  output [31:0] imm, 
    input [31:0] instruction
);
    
    wire [11:0] imm_12bit;
    wire [1:0] type;
  
    assign type = instruction[6:5];
  
    assign imm_12bit = (type == 2'b00) ? instruction[31:20] :                    
                       (type == 2'b01) ? {instruction[31:25], instruction[11:7]} :     
                                               {instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; 
    
  
    assign imm= {{20{imm_12bit[11]}}, imm_12bit};
    
endmodule
   