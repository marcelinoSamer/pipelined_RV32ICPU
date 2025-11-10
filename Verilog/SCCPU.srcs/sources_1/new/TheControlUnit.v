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
`include "defines.v"

module TheControlUnit(
input [6:0] instruction ,
input cf, vf, zf, sf, //input flags to select new pc
   output reg [1:0] PCsrc, //instead of making a branch flag specifically
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop,
    output reg MemtoWrite,
    output reg ALUsrc,
    output reg RegWrite,
    output reg AUIPC
    );
    
    
     always @(*) begin
    case(instruction[6:2])
    (`OPCODE_Arith_R)  : begin
     PCsrc = 2'b00 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b10;  MemtoWrite=0; ALUsrc=0; RegWrite=1; AUIPC = 0; //This is the format we work with
 end  (`OPCODE_Load)  : begin
     PCsrc = 2'b00 ; MemRead = 1 ;  MemtoReg= 1 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=1 ; RegWrite=1; AUIPC = 0;
  end (`OPCODE_Store)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=1; ALUsrc=1 ; RegWrite=0; 
 end  (`OPCODE_Branch)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_JALR)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_JAL)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_Arith_I)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_AUIPC)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_LUI)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_SYSTEM)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

(`OPCODE_Custom)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; 
end  

default : begin PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=0; RegWrite=0; 
  end 
    endcase
   end
endmodule
