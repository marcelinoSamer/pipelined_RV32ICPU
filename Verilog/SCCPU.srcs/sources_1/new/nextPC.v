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
input [31:0] PC, imm, rs1, input stall, branching,  branchF, jumpF, output reg [31:0] nextPC
    );
     always @* begin
        if (stall) begin
            nextPC = PC;
        end
        
        else if (branching && jumpF) begin
            nextPC = (rs1 + imm) & 32'hFFFFFFFE; //anding with ...11110 so the last bit is cleared for byte alignment
        end
        
        else if (branching && branchF) begin
            nextPC = PC + imm;
        end
        
        else begin
            nextPC = PC + 4;
        end
    end
endmodule
