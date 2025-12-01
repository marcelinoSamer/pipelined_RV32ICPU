`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 04:54:23 AM
// Design Name: 
// Module Name: ALUControlUnit
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

module ALUControlUnit(
input [3:0] instruction, [1:0]ALUop, input clk, output reg [3:0]ALUSELECT ,input [31:0] fullinstruction
    );
    
wire [2:0] funct3 = instruction[2:0];
wire funct7 = instruction[3];

	always @ (*) begin

		case (ALUop) 
			2'b00 : begin 
				ALUSELECT = `ALU_ADD; 
			end 
			2'b01 : begin //change logic to always add PC + imm (offset)
				ALUSELECT = `ALU_SUB;  
			end
			2'b10 : begin // r-type i-type will need compairason between funct3 and funct7 
				case (funct3) 
					`F3_ADD : begin 
						if (funct7 && (fullinstruction[6:0]!=7'b0010011)) ALUSELECT = `ALU_SUB;
						else ALUSELECT= `ALU_ADD; 
					 end 
					 `F3_AND: ALUSELECT = `ALU_AND; 
					 `F3_OR: ALUSELECT=`ALU_OR; 
					 `F3_XOR: ALUSELECT=`ALU_XOR; 
					 `F3_SLL : ALUSELECT =`ALU_SLL; 
					 `F3_SRL : begin 
					 if (funct7) ALUSELECT= `ALU_SRA; 
					 else ALUSELECT=`ALU_SRL; 
					 end 
					`F3_SLT : ALUSELECT = `ALU_SLT; 
					`F3_SLTU: ALUSELECT =`ALU_SLTU;
 				endcase 
 			end
 		endcase
 	end
 endmodule

 
