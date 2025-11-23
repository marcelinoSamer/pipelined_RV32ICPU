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
    output reg stall
    );
    
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
    			jump = 0; 
    			JALR = 0;
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
     			jump = 0; 
    			JALR = 0;
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
     			jump = 0; 
    			JALR = 0;
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
  		end 
  	endcase
end

endmodule
