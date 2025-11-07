`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 05:57:12 PM
// Design Name: 
// Module Name: regFile
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


module regFile #(parameter n=32)(
input [4:0] reg1, input [4:0] reg2,input [4:0] writeReg, input write, input [n-1:0] writeData, output [n-1:0] data1,output [n-1:0] data2,
  input rst  ,input clk );
reg [31:0] regFile [31:0];
integer i;

initial begin
    for(i=0; i<32;i=i+1)begin
        regFile[i]=0;
    end
end

always @(posedge clk or posedge rst)begin

    if (rst == 1)begin
        for(i=0; i<32;i=i+1)begin
            regFile[i]=0;
        end
    end
  
    
    else begin
        if (write == 1'b1 && writeReg!=5'b00000) begin
            regFile[writeReg] = writeData;
        end
    end
end

assign data1 = regFile[reg1];
assign data2 = regFile[reg2];
endmodule
