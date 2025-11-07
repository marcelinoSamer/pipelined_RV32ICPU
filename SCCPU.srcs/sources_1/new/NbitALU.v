`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:56:41 PM
// Design Name: 
// Module Name: NbitALU
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


module NbitALU #(parameter N=32) ( input [(N-1):0] Reg1  , input [(N-1):0] Reg2 , input [3:0] ALUop , output reg Zero, output reg [N-1:0] ALU 
 , input clk  );
 
    wire [N-1:0] add;
    
    
    RCA r (.x(Reg1), .y(ALUop[2]? ~Reg2:Reg2), .cin(ALUop[2]), .S(add));

   
    always @(*) begin
    case(ALUop)
    (4'b0010): ALU = add;
    (4'b0110): ALU = add;
    (4'b0000): ALU = Reg1&Reg2;
    (4'b0001): ALU = Reg1 | Reg2;
    default: ALU = 0;
    endcase
    if (ALU == 0)begin
        Zero = 1;
    end
    else begin
        Zero = 0;
    end
    
    end
  
endmodule
