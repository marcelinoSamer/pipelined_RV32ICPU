`timescale 1ns / 1ps
`include "defines.v"

module branchLogicUnit(
input Jump,
input cf, vf, zf, sf, //input flags to select new pc
output reg [1:0] PCsrc, //instead of making a branch flag specifically
output Jump
);

assign F3 = instruction[`IR_funct3];
always @(*) begin
    	case(instruction[`IR_opcode])     
 		(`OPCODE_Branch)  : begin
			case (F3)
     				(`BR_BEQ): begin 
     					PCsrc = zf? 2'b01 : 2'b00 ;  
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
    				        ALUop=2'b01;  
     					MemtoWrite=0; 
     					ALUsrc=0 ; 
     					RegWrite=0;  
     					Jump = 0; 
     					AUIPC = 0;    
     				end      
     				(`BR_BNE) : begin 
     					PCsrc = ~zf ? 2'b01 : 2'b00  ; 
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop=2'b01;  
     					MemtoWrite=0; 
     					ALUsrc=0 ; 
     					RegWrite=0;  
     					Jump = 0; 
     					AUIPC = 0; 
     				end
     				(`BR_BLT): begin 
     					PCsrc = (sf != vf) ? 2'b01 : 2'b00;  
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop=2'b01;  
     					MemtoWrite=0; 
     					ALUsrc=0 ; 
     					RegWrite=0;  
     					Jump = 0;  
     					AUIPC = 0;
     				end  
     				(`BR_BGE) : begin 
     					PCsrc = !(sf != vf) ? 2'b01 : 2'b00;  
     					MemRead = 0 ;  
     					MemtoReg= 0 ;   
     					ALUop=2'b01;  
     					MemtoWrite=0; 
     					ALUsrc=0 ; 
     					RegWrite=0;  
     					Jump = 0; 
     					AUIPC = 0; 
     				end
     				(`BR_BLTU): begin 
     					PCsrc = ~cf ? 2'b01 : 2'b00;      
     					MemRead = 0 ;  
     					MemtoReg= 0 ;  
     					ALUop=2'b01; 
     					MemtoWrite=0;
     					ALUsrc=0 ; 
     					RegWrite=0; 
     					Jump = 0; 
     					AUIPC = 0; 
     				end   
     				(`BR_BGEU): begin 
     					PCsrc = cf ? 2'b01 : 2'b00;         
     					MemRead = 0 ;  
     					MemtoReg= 0 ;  
     					ALUop=2'b01; 
     					MemtoWrite=0;
     					ALUsrc=0 ;
     					RegWrite=0; 
     					Jump = 0; 
     					AUIPC = 0;
     				end
			endcase
		end
		(`OPCODE_JALR)  : begin
     			PCsrc =2'b10 ; 
     			MemRead = 0 ; 
     			MemtoReg= 0 ;  
     			ALUop=2'b00; 
     			MemtoWrite=0; 
     			ALUsrc=1 ;
     			RegWrite=1;
     			Jump = 1; 
     			AUIPC = 0;
		end  
		(`OPCODE_JAL)  : begin
    			PCsrc =2'b01 ; 
    			MemRead = 0 ; 
    			MemtoReg= 0 ; 
    			ALUop=2'b00;  
    			MemtoWrite=0; 
    			ALUsrc=1 ;
    			RegWrite=1;
    			Jump = 1; 
    			AUIPC = 1;
		end  
		(`OPCODE_Arith_I)  : begin
     			PCsrc =2'b00 ;
     			MemRead = 0 ;
     			MemtoReg= 0 ;  
     			ALUop=2'b10; 
     			MemtoWrite=0;
     			ALUsrc=1 ; 
     			RegWrite=1;
     			Jump = 0; 
     			AUIPC = 0;
		end  
		(`OPCODE_AUIPC)  : begin
     			PCsrc =2'b00 ; 
     			MemRead = 0 ;  
     			MemtoReg= 0 ; 
     			ALUop=2'b01;
     			MemtoWrite=0;
     			ALUsrc=0 ;
     			RegWrite=1;
     			Jump = 0; 
     			AUIPC = 1;
		end  
		(`OPCODE_LUI)  : begin
     			PCsrc =2'b00 ;
     			MemRead = 0 ; 
     			MemtoReg= 0 ; 
     			ALUop=2'b00;  
     			MemtoWrite=0; 
     			ALUsrc=1 ; 
     			RegWrite=1;
     			Jump = 0; 
     			AUIPC = 0;
		end  
		(`OPCODE_SYSTEM)  : begin
  			PCsrc =2'b11;
  			MemRead = 0 ;
  			MemtoReg= 0 ;
  			ALUop=2'b01; 
  			MemtoWrite=0; 
  			ALUsrc=0 ; 
  			RegWrite=0; 
  			Jump = 0; 
  			AUIPC = 0;
		end   
		default : begin 
		PCsrc =2'b11 ; 
		MemRead = 0 ;
		MemtoReg= 0 ; 
		ALUop=2'b00; 
		MemtoWrite=0;
		ALUsrc=0;
		RegWrite=0;
		Jump = 0;
		AUIPC = 0;//depicts error, program freezes
  		end 
  	endcase
end
