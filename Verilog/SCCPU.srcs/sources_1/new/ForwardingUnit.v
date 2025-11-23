`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 08:05:55 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(output reg [1:0] fowA, fowB, input EX_regWrite, MEM_regWrite,
                    input [4:0] ID_rs1, ID_rs2, EX_rd, MEM_rd);

      always@(*) begin
        if(EX_regWrite == 1 && EX_rd != 0 && EX_rd == ID_rs1)
            fowA = 2;
        else if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs1)
            fowA = 1;
        else
            fowA = 0;
      end
     
      always@(*) begin
        if(EX_regWrite == 1 && EX_rd != 0 && EX_rd == ID_rs2)
            fowB = 2;
        else if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs2)
            fowB = 1;
        else
            fowB = 0;        
      end
     
endmodule