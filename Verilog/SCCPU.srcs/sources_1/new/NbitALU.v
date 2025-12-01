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

`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20

`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
`define     OPCODE_SYSTEM   5'b11_100 
`define     OPCODE_Custom   5'b10_001

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

//funct3 values for branch
`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     OPCODE          IR[`IR_opcode]

`define     ALU_ADD         4'b00_00
`define     ALU_SUB         4'b00_01
`define     ALU_PASS        4'b00_11
`define     ALU_OR          4'b01_00
`define     ALU_AND         4'b01_01
`define     ALU_XOR         4'b01_11
`define     ALU_SRL         4'b10_00
`define     ALU_SRA         4'b10_10
`define     ALU_SLL         4'b10_01
`define     ALU_SLT         4'b11_01
`define     ALU_SLTU        4'b11_11

`define     SYS_EC_EB       3'b000



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
    shifter shifter0(.a(Reg1), .shamt(shamt), .type(ALUSELECT[1:0]),  .r(shift_result));
    

    always @(*) begin
    case(ALUSELECT)
            `ALU_ADD: ALU = add;
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
