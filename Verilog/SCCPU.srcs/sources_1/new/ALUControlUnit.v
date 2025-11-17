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

`include "defines.v" 

module ALUControlUnit(
input [3:0] instruction, [1:0]ALUop, input clk, output reg [3:0]ALUSELECT  , output reg halt
    );
    
wire [2:0] funct3 = instruction[2:0];
wire funct7 = instruction[3];

	always @ (*) begin
		halt=1'b0;
		case (ALUop) 
			2'b00 : begin 
				ALUSELECT = `ALU_ADD; 
			end 
			2'b01 : begin //change logic to always add PC + imm (offset)
				case (funct3)  
					`BR_BEQ, `BR_BNE: ALUSELECT = `ALU_SUB;  
					`BR_BLT, `BR_BGE: ALUSELECT = `ALU_SLT;  
					`BR_BLTU, `BR_BGEU: ALUSELECT = `ALU_SLTU; 
					default: ALUSELECT = `ALU_SUB;
				endcase
			end
			2'b10 : begin // r-type i-type will need compairason between funct3 and funct7 
				case (funct3) 
					`F3_ADD : begin 
						if (funct7 == 7'b0100000) ALUSELECT = `ALU_SUB;
						else ALUSELECT= `ALU_ADD; 

					 end 
					 `F3_AND: ALUSELECT = `ALU_AND; 
					 `F3_OR: ALUSELECT=`ALU_OR; 
					 `F3_XOR: ALUSELECT=`ALU_XOR; 
					 `F3_SLL : ALUSELECT =`ALU_SLL; 
					 `F3_SRL : begin 
					 if (funct7==7'b0100000) ALUSELECT= `ALU_SRA; 
					 else ALUSELECT=`ALU_SRL; 
					 end 
					`F3_SLT : ALUSELECT = `ALU_SLT; 
					`F3_SLTU: ALUSELECT =`ALU_SLTU;
 				endcase 
 			end
			2'b11: begin
				if (opcode == `OPCODE_SYSTEM && funct3 == `SYS_EC_EB) begin
					halt = 1'b1;
 					ALUSELECT = `ALU_PASS; 
				end 
			end 
			default: begin
            			ALUSELECT = `ALU_ADD;
            			halt = 1'b0;
        		end
 		endcase
 	end
 endmodule

 
