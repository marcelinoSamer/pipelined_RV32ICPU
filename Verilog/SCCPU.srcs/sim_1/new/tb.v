`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 08:59:49 AM
// Design Name: 
// Module Name: tb
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


module tb;
reg reset;
 reg clk;
    reg [7:0] addr;
   
     SCCPU uut (
        .clk(clk),
        .addr(addr),
        .reset(reset)
    );
    initial begin
    reset = 0;
    addr = 0;
    #20
    reset = 1;
    #20 
    reset = 0;
      
    end
  
  initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end 
  
    
    

endmodule
