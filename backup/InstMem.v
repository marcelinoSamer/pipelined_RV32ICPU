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
mem[0]=32'b00000000010100000000000010010011; //addi x1, x0, 5
//mem[1]=32'b00000000010100000000000100010011; //addi x2, x0, 5
//mem[2]=32'b00000000001000001000010001100011; //beq x1, x2, 8
//mem[3]=32'b00000000001000001000010001100011; //addi x3, x0, 1
//mem[4]=32'b00000000001000001000010001100011; //addi x4, x0, 10
//mem[5]=32'b00000000001000001000010001100011; //addi x5, x0, 20
//mem[6]=32'b00000000001000001000010001100011; //beq x4, x5, 8
//mem[7]=32'b00000001111000000000001100010011; //addi x6, x0, 30
//mem[8]=32'b00000000000000000000000001110011; //ecall










        end  
// initial begin
//      $readmemh("C:\\Users\\mennatallahzaid\\Desktop\\pipelined_RV32ICPU\\tests\\Rtype.hex", mem);
// end

assign data_out = mem[addr];
endmodule
