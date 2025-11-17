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
input [31:0] instruction ,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop, //00=add, 01=sub, 10= arithmetic
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUsrc1, // 0 = reg, 1 = PC
    output reg ALUsrc2, // 0 = reg, 1 = imm
    output reg branch
    );
    
assign F3 = instruction[`IR_funct3];
always @(*) begin
    	case(instruction[`IR_opcode])
    		(`OPCODE_Arith_R)  : begin
     			MemRead = 0 ;  
     			MemtoReg= 0 ;   
     			ALUop=2'b10;  
     			MemWrite=0; 
     			RegWrite=1; 
     			ALUsrc1=0; 
     			ALUsrc2=0; 
     			branch = 0; 
 		end  
 		(`OPCODE_Load)  : begin
  		        MemRead = 1 ;  
	                MemtoReg= 1 ;   
     			ALUop=2'b00;  
     			MemWrite=0; 
     			RegWrite=1; 
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
  		end 
  		(`OPCODE_Store)  : begin
     			MemRead = 0 ;  
     			MemtoReg= 0 ;   
     			ALUop=2'b00;  
     			MemWrite=1; 
     			RegWrite=0; 
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
 		end  
 		(`OPCODE_Branch)  : begin
			case (F3)
     				(`BR_BEQ): begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
    				        ALUop=2'b01;  
     					MemWrite=0; 
     					RegWrite=0;  
     					ALUsrc1=0 ; 
     					ALUsrc2 = 0;    
     					branch = 1; 
     				end      
     				(`BR_BNE) : begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop=2'b01;  
     					MemWrite=0; 
     					RegWrite=0;  
     					ALUsrc1=0 ; 
     					ALUsrc2 = 0; 
     					branch = 1; 
     				end
     				(`BR_BLT): begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop=2'b01;  
     					MemWrite=0; 
     					RegWrite=0;  
     					ALUsrc1 =0 ; 
     					ALUsrc2 = 0;
     					branch = 1;  
     				end  
     				(`BR_BGE) : begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop= 2'b01;  
     					MemWrite=0; 
     					RegWrite=0;  
     					ALUsrc1 = 0; 
     					ALUsrc2 = 0; 
     					branch = 1; 
     				end
     				(`BR_BLTU): begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;  
     					ALUop=2'b01; 
     					MemWrite=0;
     					RegWrite=0; 
     					ALUsrc1=0 ; 
     					ALUsrc2 = 0; 
     					branch = 1; 
     				end   
     				(`BR_BGEU): begin 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;  
     					ALUop=2'b01; 
     					MemWrite=0;
     					RegWrite=0; 
     					ALUsrc1 = 0 ;
     					ALUsrc2 = 0;
     					branch = 1; 
     				end
			endcase
		end
		(`OPCODE_JALR)  : begin
     			MemRead = 0 ; 
     			MemtoReg= 0 ;  
     			ALUop=2'b00; 
     			MemWrite=0; 
     			RegWrite=1;
     			ALUsrc1 =1 ;
     			ALUsrc2 = 0;
     			branch = 1; 
		end  
		(`OPCODE_JAL)  : begin
    			MemRead = 0 ; 
    			MemtoReg= 0 ; 
    			ALUop=2'b00;  
    			MemWrite=0; 
    			RegWrite=1;
    			ALUsrc1 =1 ;
    			ALUsrc2 = 1;
    			branch = 1; 
		end  
		(`OPCODE_Arith_I)  : begin
     			MemRead = 0 ;
     			MemtoReg= 0 ;  
     			ALUop=2'b10; 
     			MemWrite=0;
     			RegWrite=1;
     			ALUsrc1 =1 ; 
     			ALUsrc2 = 0;
     			branch = 0; 
		end  
		(`OPCODE_AUIPC)  : begin
     			MemRead = 0 ;  
     			MemtoReg= 0 ; 
     			ALUop=2'b00;
     			MemWrite=0;
     			RegWrite=1;
     			ALUsrc1 =0 ;
     			ALUsrc2 = 1;
     			branch = 0; 
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
  		end 
  	endcase
end

endmodule
