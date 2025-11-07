timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/30/2025 04:19:40 PM
// Design Name:
// Module Name: Program_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Single-cycle processor LED + SSD output logger (writes to file)
//
//////////////////////////////////////////////////////////////////////////////////

module Program_tb();

reg clk, rst;
reg [1:0] ledSel;
reg [3:0] ssdSel;

wire [15:0] leds;
wire [12:0] ssd;

integer i;
integer f; // file handle

// Instantiate DUT
SCCPU uut (
.clk(clk),
.reset(rst),
.ledsel(ledSel),
.ssdSel(ssdSel),
.LEDs(leds),
.BCD(ssd)
);

// Main test sequence
initial begin
// Open log file for writing
f = $fopen("output_log.txt", "w");
if (f == 0) begin
$display("? ERROR: Could not open output_log.txt for writing!");
$finish;
end

$fdisplay(f, "-----------------------------------------------------------------");
$fdisplay(f, "? SINGLE-CYCLE PROCESSOR TESTBENCH: LED + SSD OUTPUT VIEWER (NO REDUNDANCY)");
$fdisplay(f, "-----------------------------------------------------------------");

clk = 0; rst = 1; ledSel = 0; ssdSel = 0;
#10 rst = 0; // release reset
#5; // settle

// Log cycle 0 (initial state)
$fdisplay(f, "\n Cycle 0 LED Output Combinations");
$fdisplay(f, "-----------------------------------");
$fdisplay(f, "| ledSel | leds |");
$fdisplay(f, "-----------------------------------");
for (ledSel = 0; ledSel < 3; ledSel = ledSel + 1) begin
#2;
$fdisplay(f, "| %b | %h |", ledSel, leds);
end
$fdisplay(f, "-----------------------------------");

$fdisplay(f, "\n Cycle 0 SSD Output Combinations");
$fdisplay(f, "-----------------------------------");
$fdisplay(f, "| ssdSel | ssd |");
$fdisplay(f, "-----------------------------------");
for (ssdSel = 0; ssdSel < 12; ssdSel = ssdSel + 1) begin
#2;
$fdisplay(f, "| %04b | %h |", ssdSel, ssd);
end
$fdisplay(f, "-----------------------------------\n");

// Loop through instructions 1-11
for (i = 0; i < 11; i = i + 1) begin
#5 clk = 1;
#5 clk = 0;

$fdisplay(f, "\n[Cycle %0d] LED Output Combinations", i + 1);
$fdisplay(f, "-----------------------------------");
$fdisplay(f, "| ledSel | leds |");
$fdisplay(f, "-----------------------------------");
for (ledSel = 0; ledSel < 3; ledSel = ledSel + 1) begin
#2;
$fdisplay(f, "| %b | %h |", ledSel, leds);
end
$fdisplay(f, "-----------------------------------");

$fdisplay(f, "[Cycle %0d] SSD Output Combinations", i + 1);
$fdisplay(f, "-----------------------------------");
$fdisplay(f, "| ssdSel | ssd |");
$fdisplay(f, "-----------------------------------");
for (ssdSel = 0; ssdSel < 12; ssdSel = ssdSel + 1) begin
#2;
$fdisplay(f, "| %04b | %h |", ssdSel, ssd);
end
$fdisplay(f, "-----------------------------------\n");
end

#10;
$fdisplay(f, "? Simulation finished successfully.");
$fclose(f);
$finish;
end

endmodule
