/*`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 09:31:08 AM
// Design Name: 
// Module Name: TopMod
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


module TopMod(
input clock,
input clk,
input reset,
input [1:0] ledsel,
input [3:0] ssdSel,
output [15:0] LEDs,
output reg [3:0] Anode,
output [3:0] CAnode,
output reg [6:0] LED_out
    );
    wire [12:0] BCD;
    SCCPU cpu(clock, reset, ledsel, ssdSel, LEDs, BCD);
    
    
    
    assign CAnode = 4'b0000;

reg [3:0] LED_BCD;
reg [19:0] refresh_counter = 0; // 20-bit counter
wire [1:0] LED_activating_counter;

wire Cout;
wire [3:0] thousands;
wire [3:0] hundred;
wire [3:0] tens;
wire [3:0] ones;



always @(posedge clk)
begin
refresh_counter <= refresh_counter + 1;
end

assign LED_activating_counter = refresh_counter[19:18];


BCD A0(.num(BCD), .Thousands(thousands), .Hundreds(hundred), .Tens(tens), .Ones(ones));



always @(posedge clk)
begin

case(LED_activating_counter)
2'b00: begin
Anode = 4'b0111;
LED_BCD = BCD[12]? 4'b1111 : thousands;
end
2'b01: begin
Anode = 4'b1011;
LED_BCD = hundred;
end
2'b10: begin
Anode = 4'b1101;
LED_BCD = tens;
end
2'b11: begin
Anode = 4'b1110;
LED_BCD = ones;
end
endcase
end



always @(*)
begin
case(LED_BCD)
4'b0000: LED_out = 7'b0000001; // "0"
4'b0001: LED_out = 7'b1001111; // "1"
4'b0010: LED_out = 7'b0010010; // "2"
4'b0011: LED_out = 7'b0000110; // "3"
4'b0100: LED_out = 7'b1001100; // "4"
4'b0101: LED_out = 7'b0100100; // "5"
4'b0110: LED_out = 7'b0100000; // "6"
4'b0111: LED_out = 7'b0001111; // "7"
4'b1000: LED_out = 7'b0000000; // "8"
4'b1001: LED_out = 7'b0000100; // "9"
4'b1111: LED_out = 7'b1111110; // "-"
default: LED_out = 7'b0000001; // "0"
endcase
end
    
    
endmodule*/
