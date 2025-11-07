`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 08:32:30 AM
// Design Name: 
// Module Name: SCCPU
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
module SCCPU(
input clk,
input reset,
input [1:0] ledsel,
input [3:0] ssdSel,
output reg [15:0] LEDs,
output reg [12:0] BCD
    );
    reg [31:0] PC;
    wire [31:0] inst;


    always @* begin
    case(ledsel)
            2'b00: LEDs = PC[15:0];
            2'b01: LEDs = PC[31:16];
            2'b10: LEDs = {2'b00, Branch, MemRead, MemtoReg, ALUop, MemtoWrite, ALUsrc, RegWrite, ALUS, zero, Branch&zero};
        endcase
        
        case(ssdSel)
            4'b0000: BCD = PC[12:0];
            4'b0001: BCD = PC[12:0] + 32'd4;
            4'b0010: BCD = PC+(immediate<<1);
            4'b0011: BCD = (Branch & zero)? PC+(immediate<<1) : PC+32'd4;
            4'b0100: BCD = data1;
            4'b0101: BCD = data2;
            4'b0110: BCD = MemtoReg? memout : alures;
            4'b0111: BCD = immediate;
            4'b1000: BCD = immediate<<1;
            4'b1001: BCD = alusrc2;
            4'b1010: BCD = alures;
            4'b1011: BCD = memout;
        endcase
    
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'd0;
        else begin
            PC <= (Branch & zero)? PC+(immediate<<1) : PC+32'd4;
        end
            
    end
       
    InstMem instmem (.addr(PC[7:2]), .data_out(inst));
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUop;
    wire MemtoWrite;
    wire ALUsrc;
    wire RegWrite;
    TheControlUnit CU (.instruction(inst), 
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUop(ALUop),
    .MemtoWrite(MemtoWrite),
    .ALUsrc(ALUsrc),
    .RegWrite(RegWrite));
    
    wire [31:0] data1;
    wire [31:0] data2;
    regFile rf (.reg1(inst[19:15]), .reg2(inst[24:20]), .writeReg(inst[11:7]), .write(RegWrite), .writeData(MemtoReg? memout : alures), .data1(data1), .data2(data2),
    .rst(reset), .clk(clk));
    
    wire [31:0] immediate;
    Immediategenerator ig (.instruction(inst), .imm(immediate));
    
    wire [3:0] ALUS;
    ALUControlUnit alucu (.instruction({inst[14:12], inst[30]}), .ALUop(ALUop), .clk(clk), .ALUS(ALUS));
    
    wire [31:0] alusrc2;
    assign alusrc2 = ALUsrc? immediate : data2;
    
    wire zero;
    wire [31:0] alures;
    NbitALU alu (.clk(clk), .Reg1(data1), .Reg2(alusrc2), .Zero(zero), .ALUSELECT(ALUS), .ALU(alures));
    
    wire[31:0] memout;
    DataMem datamemory (.clk(clk), .MemRead(MemRead), .MemWrite(MemtoWrite), .addr(alures[7:2]), .data_in(data2), .data_out(memout));
    
    
    
endmodule
