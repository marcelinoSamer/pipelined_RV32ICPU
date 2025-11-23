`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 10:00:22 PM
// Design Name: 
// Module Name: HDU
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


module HDU(
input [4:0] IF_ID_Rs1, ID_EX_Rd, IF_ID_Rs2, input ID_EX_MemRead, match, output reg stall
    );
    reg stall;
    always @* begin
        if((((IF_ID_Rs1 == ID_EX_Rd) || (IF_ID_Rs2 == ID_EX_Rd))
            && (ID_EX_MemRead && ID_EX_Rd != 0)) || match == 0)
                stall = 1'b1;
        else stall = 1'b0;
    end
    
    
endmodule
