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


`timescale 1ns / 1ps

module tb;
    // Inputs
    reg clk;
    reg reset;
    reg [1:0] ledsel;
    reg [3:0] ssdSel;

    // Outputs
    wire [15:0] LEDs;
    wire [12:0] BCD;

    // Instantiate the Unit Under Test (UUT)
    SCCPU uut (
        .clk(clk),
        .reset(reset),
        .ledsel(ledsel),
        .ssdSel(ssdSel),
        .LEDs(LEDs),
        .BCD(BCD)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 40ns period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;

        #60;  // Wait some time
        reset = 0;

        // Run for a while
        #100;
        reset = 1;

        #60;  // Wait some time
        reset = 0;
        #100;

        $stop;  // Stop simulation
    end

endmodule

