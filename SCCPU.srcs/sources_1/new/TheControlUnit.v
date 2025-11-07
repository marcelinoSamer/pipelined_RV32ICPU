`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 06:41:30 PM
// Design Name: 
// Module Name: TheControlUnit
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


module TheControlUnit(
input [6:0] instruction ,  output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop,
    output reg MemtoWrite,
    output reg ALUsrc,
    output reg RegWrite );
    
    
     always @(*) begin
    case(instruction[6:2])
    (5'b01100)  : begin
     Branch =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b10;  MemtoWrite=0; ALUsrc=0; RegWrite=1; 
 
 end  (5'b00000)  : begin
     Branch =0 ; MemRead = 1 ;  MemtoReg= 1 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=1 ; RegWrite=1; 
  end (5'b01000)  : begin
     Branch =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=1; ALUsrc=1 ; RegWrite=0; 
 end  (5'b11000)  : begin
     Branch =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  
default : begin Branch =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=0; RegWrite=0; 
  end 
    endcase
   end
    
    
endmodule
