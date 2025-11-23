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
 , input [31:0] PC, input clk ,input [4:0] shamt , input AUIPC , output  wire cf, vf, sf );
 
    wire [31:0] add, op_b;
    wire cfa, cfs;
    
      
    assign op_b = (~Reg2);
    
    assign {cf, add} = ALUSELECT[0] ? (Reg1 + op_b + 1'b1) : (Reg1 + Reg2);
    
    assign zf = (add == 0);
    assign sf = add[31];  // Sign flag: the most significant bit of the ALU result
    assign vf = (Reg1[31] ^ op_b[31]) && (Reg1[31] ^ add[31]);  // Signed overflow flag
 
    wire[31:0] shift_result;
    shifter shifter0(.a(a), .shamt(shamt), .type(ALUSELECT[1:0]),  .r(shift_result));
    

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
          default: begin
                if (AUIPC) begin
                    ALU = PC + (Reg2 << 12);  // AUIPC: Calculate PC + (immediate << 12)
                end else begin
                    ALU = 0;  // Default case (shouldn't happen, but good for safety)
                end
            end
        endcase 
    if (ALU == 0)begin
        Zero = 1;
    end
    else begin
        Zero = 0;
    end
    
    end
  
endmodule
