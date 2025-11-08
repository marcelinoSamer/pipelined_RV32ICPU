`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:56:41 PM
// Design Name: 
// Module Name: NbitALU
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
module NbitALU #(parameter N=32) ( input [(N-1):0] Reg1  , input [(N-1):0] Reg2 , input [3:0] ALUSELECT , output reg Zero, output reg [N-1:0] ALU 
 , input clk ,input [4:0] shamt , output  wire cf, vf, sf );
 
    wire [31:0] add, op_b;
    wire cfa, cfs;
    
      
    assign op_b = (~Reg2);
    
    assign {cf, add} = alufn[0] ? (Reg1 + op_b + 1'b1) : (Reg1 + Reg2);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (Reg1[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] shift_result;
    shifter shifter0(.Reg1(a), .shamt(shamt), .type(alufn[1:0]),  .r(shift_result));
    

   
    always @(*) begin
    case(ALUSELECT)
            `ALU_ADD: ALU = add;           // ADD
            `ALU_SUB: ALU = add;           // SUB
            `ALU_PASS: ALU = Reg2;         // PASS
            `ALU_OR: ALU = Reg1 | Reg2;    // OR
            `ALU_AND: ALU = Reg1 & Reg2;   // AND
            `ALU_XOR: ALU = Reg1 ^ Reg2;   // XOR
            `ALU_SRL: ALU = shift_result;  // Shift Right
            `ALU_SRA: ALU = shift_result;  // Shift Right Arithmetic
            `ALU_SLL: ALU = shift_result;  // Shift Left
            `ALU_SLT: ALU = {31'b0,(sf != vf)};  // Set Less Than
            `ALU_SLTU: ALU = {31'b0,(~cf)};   // Set Less Than Unsigned
            default: ALU = 0;
        endcase
    if (ALU == 0)begin
        Zero = 1;
    end
    else begin
        Zero = 0;
    end
    
    end
  
endmodule
