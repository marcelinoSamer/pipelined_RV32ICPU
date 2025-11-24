`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2025 12:08:28 AM
// Design Name: 
// Module Name: nextPC
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


module nextPC(
input [31:0] PC, imm, rs1, EX_MEM_PC, input stall, branching,  branchF, jumpF, match, output reg [31:0] nextPC
    );
     always @* begin
        if (stall) begin
            nextPC = PC;
        end
        
        else if (jumpF) begin
            nextPC = (rs1 + imm<<1) & 32'hFFFFFFFE; //anding with ...11110 so the last bit is cleared for byte alignment
        end
        
        else if (branching && branchF) begin
            nextPC = PC + imm<<1;
        end
        
        else if (~match && branching)
            nextPC = EX_MEM_PC + 4;
        else if (~match && ~branching)
            nextPC = EX_MEM_PC + imm<<1;
        else begin
            nextPC = PC + 4;
        end
    end
endmodule
