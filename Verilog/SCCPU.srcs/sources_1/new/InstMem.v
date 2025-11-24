`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 05:04:16 PM
// Design Name: 
// Module Name: InstMem
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
module InstMem (input [5:0] addr, output [31:0] data_out);
reg [31:0] mem [0:63];
integer i;
initial begin
mem[0]=32'b0000000_00010_00001_000_00001_0110011; //ADD  x1,x1,x2   (warm-up RAW)
mem[1]=32'b0000000_00000_00001_000_00000_1100011; //BEQ x0,x1,+0 (likely not taken)





        end  
// initial begin
//      $readmemh("C:\\Users\\mennatallahzaid\\Desktop\\pipelined_RV32ICPU\\tests\\Rtype.hex", mem);
// end

assign data_out = mem[addr];
endmodule
