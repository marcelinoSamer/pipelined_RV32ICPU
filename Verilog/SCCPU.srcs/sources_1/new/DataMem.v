`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 05:22:23 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem (input clk, input [1:0] MemRead, input [1:0] MemWrite,
input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out);
reg [31:0] mem [0:63];


initial begin
    mem[0] = 32'd17;
    mem[1] = 32'd9;
    mem[2] = 32'd25;
    mem[55] = 32'd56;
end
//initial begin
//    mem[0] = 32'd5;    // first operand
//    mem[1] = 32'd3;    // second operand
//    mem[2] = 32'd20;   // loop limit
//end

always @ (posedge clk)begin
if(MemWrite == 1'b1) mem [addr] <= data_in;
end

always @(*) begin
if(MemRead == 1'b1) data_out = mem[addr];
else data_out = 32'b0;
end

endmodule