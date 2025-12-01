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


module TheControlUnit(
input [31:0] instruction ,
    output reg [1:0] MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop, //00=add, 01=sub, 10= arithmetic
    output reg [1:0] MemWrite,
    output reg RegWrite,
    output reg ALUsrc1, // 0 = reg, 1 = PC
    output reg ALUsrc2, // 0 = reg, 1 = imm
    output reg branch,
    output reg jump,
    output reg JALR,
    output reg memSign,
    output reg stall,
    output reg AUIPC
    );
wire [2:0] F3;
assign F3 = instruction[`IR_funct3];
always @(*) begin
    	case(instruction[`IR_opcode])
    		(`OPCODE_Arith_R)  : begin
     			MemRead = 2'b00 ;  
     			MemtoReg= 0 ;   
     			ALUop=2'b10;  
     			MemWrite= 2'b00; 
     			RegWrite=1; 
     			ALUsrc1=0; 
     			ALUsrc2=0; 
     			branch = 0; 
     			jump = 0;
     			JALR = 0;
     			memSign = 0;
     			stall = 0;
 		end  
 		(`OPCODE_Load)  : begin
	            MemtoReg= 1 ;   
     			ALUop=2'b00;  
     			RegWrite=1; 
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
     			jump = 0;
     			JALR = 0;
     			stall = 0;
     			case(F3)
     			    3'b000: begin
     			        memSign = 1;
     			        MemRead = 2'b01;
     		            MemWrite= 2'b00; 
     			    end
     			    3'b001: begin
     			        memSign = 1;
     			        MemRead = 2'b10;
     		            MemWrite= 2'b00; 
     			    end
     			    3'b010: begin
     			        memSign = 1;
     			        MemRead = 2'b11;
     		            MemWrite= 2'b00; 
     			    end
     			    3'b100: begin
     			        memSign = 0;
     			        MemRead = 2'b01;
     		            MemWrite= 2'b00; 
     			    end
     			    3'b101: begin
     			        memSign = 0;
     			        MemRead = 2'b10;
     		            MemWrite= 2'b00; 
     			    end
     			endcase     
  		end 
  		(`OPCODE_Store)  : begin
     			MemtoReg= 0 ;   
     			ALUop=2'b00;  
     			RegWrite=0; 
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
     			jump = 0;
     			JALR = 0;
     			stall = 0;
     			case(F3)
     			    3'b000: begin
     			        memSign = 1;
     			        MemRead = 2'b00;
     		            MemWrite= 2'b01; 
     			    end
     			    3'b001: begin
     			        memSign = 1;
     			        MemRead = 2'b00;
     		            MemWrite= 2'b10; 
     			    end
     			    3'b010: begin
     			        memSign = 1;
     			        MemRead = 2'b00;
     		            MemWrite= 2'b11; 
     		        end
     			endcase     
 		end  
 		(`OPCODE_Branch)  : begin
 		        MemRead = 0 ;  
     	        MemtoReg= 0 ;
     	        ALUop=2'b01;  
     	        MemWrite=0; 
     		    RegWrite=0;  
   			    ALUsrc1=0 ; 
    		    ALUsrc2=0;    
     		    branch = 1;
     		    jump = 0;
     		    JALR = 0;
     		    stall = 0;
		end
		(`OPCODE_JALR)  : begin
     			MemRead = 0 ; 
     			MemtoReg= 0 ;  
     			ALUop=2'b00; 
     			MemWrite=0; 
     			RegWrite=1;
     			ALUsrc1 =1 ;
     			ALUsrc2 = 0;
     			branch = 0; 
     			jump = 1;
     			JALR = 1;
     			stall = 0;
		end  
		(`OPCODE_JAL)  : begin
    			MemRead = 0 ; 
    			MemtoReg= 0 ; 
    			ALUop=2'b00;  
    			MemWrite=0; 
    			RegWrite=1;
    			ALUsrc1 =1 ;
    			ALUsrc2 = 1;
    			branch = 0;
    			jump = 1; 
    			JALR = 0;
    			stall = 0;
		end  
		(`OPCODE_Arith_I)  : begin
     			MemRead = 0 ;
     			MemtoReg= 0 ;  
     			ALUop=2'b10; 
     			MemWrite=0;
     			RegWrite=1;
     			ALUsrc1 =1; 
     			ALUsrc2 = 0;
     			branch = 0; 
     			jump = 0; 
    			JALR = 0;
    			stall = 0;
		end  
		(`OPCODE_AUIPC)  : begin
     			MemRead = 0 ;  
     			MemtoReg= 0 ; 
     			ALUop=2'b00;
     			MemWrite=0;
     			RegWrite=1;
     			ALUsrc1 =1;
     			ALUsrc2 = 1;
     			branch = 0; 
     			jump = 0; 
    			JALR = 0;
    			stall = 0;
    			AUIPC = 1;
		end  
		(`OPCODE_LUI)  : begin
     			MemRead = 0 ; 
     			MemtoReg= 0 ; 
     			ALUop=2'b00;  
     			MemWrite=0; 
     			RegWrite=1;
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
     			jump = 0; 
    			JALR = 0;
    			stall = 0;
		end  
		(`OPCODE_SYSTEM)  : begin
  			    MemRead = 0;
  			    MemtoReg= 0;
  			    ALUop=2'b01; 
  			    MemWrite=0; 
  			    RegWrite=0; 
  			    ALUsrc1 =0 ; 
  			    ALUsrc2 = 0;
  			    branch = 0; 
  			    jump = 0; 
    			JALR = 0;
    			stall = 1;
		end   
		default : begin  //depicts error, program freezes
		        MemRead = 0 ;
		        MemtoReg= 0 ; 
		        ALUop=2'b00; 
		        MemWrite=0;
		        RegWrite=0;
		        ALUsrc1 =0;
		        ALUsrc2 = 0;
		        branch = 0;
		        jump = 0; 
    			JALR = 0;
    			stall = 0;
  		end 
  	endcase
end

endmodule
