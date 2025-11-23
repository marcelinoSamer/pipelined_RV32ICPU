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

`include "defines.v"


module SCCPU(
input clk,
input reset,
input [1:0] ledsel,
input [3:0] ssdSel,
output reg [15:0] LEDs,
output reg [12:0] BCD
    );
    
    wire [31:0] data1;
    wire [31:0] data2;
    wire [31:0] immediate;
    wire [3:0] ALUSELECT;
    wire [31:0] alusrc2;
    wire [31:0] alusrc1;  
    wire [31:0] alures;
    wire [31:0] memout;
    wire zero;
    wire cf, vf, sf;
    wire Jump;
    wire [4:0] shamt;
    wire [31:0] writedata;
    wire [4:0] opcode = inst[`IR_opcode];      
    wire [2:0] funct3 = inst[`IR_funct3];
    wire [6:0] funct7 = inst[`IR_funct7];
    
    //hardware testing block
      always @* begin
    case(ledsel)
            2'b00: LEDs = PC[15:0];
            2'b01: LEDs = PC[31:16];
            2'b10: LEDs = {2'b00, branch, MemRead, MemtoReg, ALUop, MemWrite, ALUsrc2, RegWrite, ALUSELECT, zero, branch&zero};
        endcase
        
        case(ssdSel)
            4'b0000: BCD = PC[12:0];
            4'b0001: BCD = PC[12:0] + 32'd4;
            4'b0010: BCD = PC+(immediate<<1);
            4'b0011: BCD = (branch & zero)? PC+(immediate<<1) : PC+32'd4;
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
    //hardware testing block end

    //initializing the program counter and fetch stage
    reg [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] inst;
    nextPC pcgen(.PC(PC), .imm(immediate), .rs1(data1), .stall(stall | stallCU), .branching(branching), .branchF(branch), .jumpF(jump), .nextPC(nextPC));
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'd0;
        else
        PC <= nextPC;
    end

    
    wire branching;
    wire match;        
    BPU branchPrediction(.branch1(branch), .branch2(EX_MEM_Ctrl_MEM[3]), .jump(jump), .result(branchTaken), .Reset(reset), .clk(clk), .prediction(branching), .match(match));
       
       
    InstMem instmem (.addr(PC[7:2]), .data_out(inst));
    
    //IF_ID
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    nBitReg #(64) IF_ID (clk,reset,1'b1,
                             {PC, inst},
                             {IF_ID_PC,IF_ID_Inst} );
                             
    wire stall;
    HDU hazardDetection(.IF_ID_Rs1(IF_ID_Inst[19:15]), .IF_ID_Rs2(IF_ID_Inst[24:20]), .ID_EX_Rd(ID_EX_Rd), .match(match), .stall(stall));                    
    //Decode stage begin                    
    wire [1:0] MemRead;
    wire MemtoReg;
    wire [1:0] ALUop;
    wire [1:0] MemWrite;
    wire ALUsrc1;
    wire RegWrite;
    wire ALUsrc2;  
    wire branch;
    wire jump;
    wire JALR;
    wire memSign;
    wire stallCU;
    TheControlUnit CU (
    .instruction(IF_ID_INST),  
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .ALUop(ALUop),
    .RegWrite(RegWrite),
    .ALUsrc2(ALUsrc2),
    .ALUsrc1(ALUsrc1),
    .branch(branch),
    .jump(jump),
    .JALR(JALR),
    .memSign(memSign),
    .stall(stallCU));
    
    assign writedata = MemtoReg? memout : (Jump? PC + 4 : alures); // in WB
    regFile rf (.reg1(inst[19:15]), .reg2(inst[24:20]), .writeReg(inst[11:7]), .write(RegWrite), .writeData(writedata), .data1(data1), .data2(data2),
    .rst(reset), .clk(clk));
 
 
     Immediategenerator ig (.IR(inst), .Imm(immediate));
 
     //Decode stage end
     
     //ID_EX
     wire [31:0] ID_EX_PC, ID_EX_data1, ID_EX_data2, ID_EX_Imm;
     wire [3:0] ID_EX_Func;
     wire [2:0] ID_EX_BF3;
     wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
     wire [1:0] ctrl_WB;
     wire [5:0] ctrl_MEM;
     wire [4:0] ctrl_EX;
     wire [3:0] ID_EX_Ctrl_MEM;
     wire [1:0] ID_EX_Ctrl_WB;
     wire [4:0] ID_EX_Ctrl_EX;
     assign ctrl_WB = stall? 2'b0 : {MemtoReg, RegWrite};
     assign ctrl_MEM = stall? 6'b0 : {MemRead, MemWrite, branch, memSign};
     assign ctrl_EX = stall? 5'b0 : {branch, ALUsrc1, ALUsrc2, ALUop};
     nBitReg #(156) ID_EX (clk,reset,1'b1,
                           {ctrl_EX, ctrl_MEM, ctrl_WB,
                           IF_ID_PC, data1, data2, 
                           immediate, {IF_ID_Inst[30], IF_ID_Inst[14:12]}, 
                           IF_ID_Inst[19:15],IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_Inst[14:12]},
                           
                           {ID_EX_Ctrl_EX, ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, 
                           ID_EX_PC, ID_EX_data1, ID_EX_data2,
                           ID_EX_Imm, ID_EX_Func, 
                           ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_BF3} );
 
 
    //Excute stage
    ALUControlUnit alucu (.instruction(ID_EX_Func), .ALUop(ALUop), .clk(clk), .ALUSELECT(ALUSELECT));
    

    assign shamt =
        ((opcode == `OPCODE_Arith_I) && ((funct3 == `F3_SLL) || (funct3 == `F3_SRL))) ? inst[`IR_shamt] :
        ((opcode == `OPCODE_Arith_R) && ((funct3 == `F3_SLL) || (funct3 == `F3_SRL))) ? data2[4:0] :
        5'b00000;

    //ALU with forwarding
    wire [31:0] alu1, alu2;
    wire [31:0] midmux;
    n4x1MUX ALU1 (.a(ID_EX_RegR1), .b(MEM_WB_Mem_out), .c(EX_MEM_ALU_out), .s(fowA), .out(alu1));
    n4x1MUX ALU2 (.a(ID_EX_RegR2), .b(MEM_WB_Mem_out), .c(EX_MEM_ALU_out), .s(fowB), .out(midmux));
    assign alu2 = ID_EX_Ctrl_EX[2]? ID_EX_Imm : midmux;
    assign alusrc1 = ID_EX_Ctrl_EX[1]? PC : alu1;

    NbitALU alu (.clk(clk), .Reg1(alusrc1), .Reg2(alu2), .Zero(zero), .ALUSELECT(ALUSELECT), .ALU(alures), .cf(cf), .vf(vf) , .sf(sf) , .shamt(shamt) );
     


    wire [1:0] forA, forB;
    
    ForwardingUnit forward(.ID_rs1(ID_EX_Rs1) , .ID_rs2(ID_EX_Rs2) , .EX_rd(EX_MEM_Rd) , 
                            .MEM_rd(MEM_WB_Rd), .EX_regWrite(EX_MEM_Ctrl_WB[0]) , .MEM_regWrite(MEM_WB_Ctrl[0]), 
                                .fowA(forA), .fowB(forB));
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [5:0] EX_MEM_Ctrl_MEM;
    wire [1:0] EX_MEM_Ctrl_WB;
    wire [4:0] EX_MEM_Rd;
    wire [2:0] EX_MEM_BF3;
    wire EX_MEM_Zero;
    wire [31:0] value = (ID_EX_PC + (ID_EX_Imm << 1)); // BPU
    nBitReg #(110) EX_MEM (
    clk, reset, 1'b1,
    {ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, value, zero, alures, ID_EX_RegR2, ID_EX_Rd, ID_EX_BF3},
    {EX_MEM_Ctrl_MEM, EX_MEM_Ctrl_WB,  EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_BF3}
    );
    
    wire branchTaken;
    BLU branchLogic(.branch(EX_MEM_Ctrl_MEM[1]), .F3(EX_MEM_BF3), .c(cf), .z(zf), .v(vf), .s(sf), .branchTaken(branchTaken));
    DataMem datamemory (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(alures[7:2]), .data_in(data2), .data_out(memout));
     
     
    wire [31:0] MEM_WB_Mem_out;
    wire [31:0] MEM_WB_ALU_out;
    wire [1:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;

    nBitReg #(77) MEM_WB (clk,reset,1'b1,
                            {EX_MEM_Ctrl_WB, memout, EX_MEM_ALU_out, EX_MEM_Rd},
                            {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
                             MEM_WB_Rd} );
    
    
endmodule
