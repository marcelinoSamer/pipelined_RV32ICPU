`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 09:44:41 AM
// Design Name: 
// Module Name: shifter
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


module shifter(
input a, input shamt, input [1:0] type,  output reg r
    );
    always @* begin
    	case (type)begin
    		2'b00: begin
    			if (shamt) r = a << 1; 
    			else r = a << 20;
    		end
    		2'b01: begin
    			if (shamt) r = a >> 1;
    			else r = a >> 20;
    		end
    		2'b10: begin
    			if (shamt) r = a >>> 1; 
    			else r = a >>> 20;
    		end
    	endcase
    	
    end
endmodule
