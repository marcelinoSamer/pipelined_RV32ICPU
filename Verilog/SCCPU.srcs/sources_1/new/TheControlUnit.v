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
input [2:0] F3,
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
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=1; ALUsrc=1 ; RegWrite=0; AUIPC = 0;
 end  (`OPCODE_Branch)  : begin
	
     if(F3 = 0) PCsrc = zf;                 //BEQ
     else if (F3 = 1) PCsrc = ~zf;          //BNE
     else if (F3 = 4) PCsrc = (sf != vf)?;  //BLT
     else if (F3 = 5) PCsrc = !(sf != vf)?; //BGE
     else if (F3 = 6) PCsrc = ~cf;          //BLTU
     else if (F3 = 7) PCsrc = cf;           //BGEU
     MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; AUIPC = 0;
end  
(`OPCODE_JALR)  : begin
     PCsrc =2 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=1 ; RegWrite=1; AUIPC = 0;
end  

(`OPCODE_JAL)  : begin
     PCsrc =2 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=1 ; RegWrite=1; AUIPC = 1;
end  

(`OPCODE_Arith_I)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b10;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; AUIPC = 0;
end  

(`OPCODE_AUIPC)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; AUIPC = 1;
end  

(`OPCODE_LUI)  : begin
     PCsrc =0 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=1 ; RegWrite=1; AUIPC = 0;
end  

(`OPCODE_SYSTEM)  : begin
     PCsrc =3 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; AUIPC = 0;
end  

(`OPCODE_Custom)  : begin
     PCsrc =1 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b01;  MemtoWrite=0; ALUsrc=0 ; RegWrite=0; AUIPC = 0;
end  

default : begin PCsrc =3 ; MemRead = 0 ;  MemtoReg= 0 ;   ALUop=2'b00;  MemtoWrite=0; ALUsrc=0; RegWrite=0; //depicts error, program freezes
  end 
    endcase
   end
endmodule
