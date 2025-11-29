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
    );
    
    wire [31:0] data1;
    wire [31:0] data2;
    wire [31:0] immediate;
    wire [3:0] ALUSELECT;
    wire [31:0] alures;
    wire [31:0] memout;
    wire zero;
    wire cf, vf, sf;
    wire [4:0] shamt;
    wire [31:0] writedata;
    wire [4:0] opcode = ID_EX_Inst[`IR_opcode];      
    wire [2:0] funct3 = ID_EX_Inst[`IR_funct3];
    wire [6:0] funct7 = ID_EX_Inst[`IR_funct7];
    

    //initializing the program counter and fetch stage
    reg [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] inst;
    nextPC pcgen(.PC((branching || jump || stallCU)? IF_ID_PC :PC), .imm(immediate), .EX_MEM_Imm(EX_MEM_Imm), .EX_MEM_PC(EX_MEM_PC), .rs1(data1), .stall(stall | stallCU), .branching(branching), .match(match), .branchF(branch), .jumpF(jump), .JALR(JALR), .nextPC(nextPC));
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'd0;
        else
            PC <= nextPC;
    end

    
    wire branching;
    wire match;        
    BPU branchPrediction(.branch2(EX_MEM_Ctrl_MEM[1]), .result(branchTaken), .Reset(reset), .clk(clk), .prediction(branching), .match(match));
       
//flushing needs to be tested , stalling needs to be tested , the unified memory parameters are changed to smaller values to test the loads and stores 
    wire [95:0] read_data;
    wire buffer_empty;
    wire [31:0] instruction_out;

    wire fetch_enable = buffer_empty && !(stall | stallCU);
    
    Buffer buffer_inst(
        .clk(clk),
        .reset(reset),
        .mem_data(read_data),
        .fetch_enable(fetch_enable),
        .instruction_out(instruction_out),
        .buffer_empty(buffer_empty)
    );

  
    wire [31:0] EX_MEM_RegR2; //There is no value such as EX MEM REG R2 ,i am supposed to connect it to the writeback value that //will come from the alu to be written in the memory 
    
    UnifiedMem Memory(
        .clk(clk),
        .address(fetch_enable ? PC[7:2] : EX_MEM_ALU_out[7:2]), //The CTRLs need to be revised for this line and the two following //lines 
        .MemRead(fetch_enable ? 2'b11 : EX_MEM_Ctrl_MEM[5:4]),
        .MemWrite(fetch_enable ? 2'b00 :MEM_WB_Ctrl),
        .writedata(32'b1), //This is a hardwire value for testibf
        .read_data(read_data),
        .mem_unsigned(EX_MEM_Ctrl_MEM[0]),
        .fetch_enable(fetch_enable),
        .PC(PC)
    );

   
    wire [31:0] next_IF_inst = instruction_out;

   
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    wire IF_ID_enable = !(stall | stallCU) && !buffer_empty;
    
    nBitReg #(64) IF_ID (
        .clk(clk),
        .rst(reset),
        .load(1'b1), //hardwired value , needs to be changes to IF/ID enable or the fetch enable from above (under testing) 
        .D({PC, next_IF_inst}),    
        .Q({IF_ID_PC, IF_ID_Inst})
    ); 
//    //IF_ID
//    wire [31:0] IF_ID_PC;
//    wire [31:0] IF_ID_Inst;
//    nBitReg #(64) IF_ID (clk,reset,1'b1,
//                             (stall? 64'b0 : {PC, inst}),
//                             {IF_ID_PC,IF_ID_Inst} );
                             
    wire stall;
    HDU hazardDetection(.IF_ID_Rs1(IF_ID_Inst[19:15]), .IF_ID_Rs2(IF_ID_Inst[24:20]), .ID_EX_Rd(ID_EX_Rd), .stall(stall));                    
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
    .instruction(IF_ID_Inst),  
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
    
    assign writedata = MEM_WB_Ctrl[1]?  MEM_WB_Mem_out : (MEM_WB_Ctrl[2]? MEM_WB_PC + 4 : MEM_WB_ALU_out); // in WB
    regFile rf (.reg1(IF_ID_Inst[19:15]), .reg2(IF_ID_Inst[24:20]), .writeReg(MEM_WB_Rd), .write(MEM_WB_Ctrl[0]), .writeData(writedata), .data1(data1), .data2(data2),
    .rst(reset), .clk(clk));
 
 
     Immediategenerator ig (.IR(IF_ID_Inst), .Imm(immediate));
 
     //Decode stage end
     
     //ID_EX
     wire [31:0] ID_EX_PC, ID_EX_data1, ID_EX_data2, ID_EX_Imm;
     wire [3:0] ID_EX_Func;
     wire [2:0] ID_EX_BF3;
     wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
     wire [2:0] ctrl_WB;
     wire [5:0] ctrl_MEM;
     wire [4:0] ctrl_EX;
     wire [5:0] ID_EX_Ctrl_MEM;
     wire [2:0] ID_EX_Ctrl_WB;
     wire [4:0] ID_EX_Ctrl_EX;
     wire [31:0] ID_EX_Inst;
     
     //Hazard flush
     assign ctrl_WB = (stall || jump)? 3'b0 : {jump, MemtoReg, RegWrite};
     assign ctrl_MEM = (stall || jump)? 5'b0 : {MemRead, MemWrite, branch, memSign};
     assign ctrl_EX = (stall || jump)? 5'b0 : {branch, ALUsrc1, ALUsrc2, ALUop};
     nBitReg #(198) ID_EX (clk,reset,1'b1,
                           ((stall || ~match)? 198'b0 : {ctrl_EX, ctrl_MEM, ctrl_WB,
                           IF_ID_PC, IF_ID_Inst, data1, data2, 
                           immediate, {IF_ID_Inst[30], IF_ID_Inst[14:12]}, 
                           IF_ID_Inst[19:15],IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_Inst[14:12]}),
                           
                           {ID_EX_Ctrl_EX, ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, 
                           ID_EX_PC, ID_EX_Inst, ID_EX_data1, ID_EX_data2,
                           ID_EX_Imm, ID_EX_Func, 
                           ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_BF3} );

 
    //Excute stage
    ALUControlUnit alucu (.instruction(ID_EX_Func), .ALUop(ID_EX_Ctrl_EX[1:0]), .clk(clk), .ALUSELECT(ALUSELECT) );
    

    assign shamt =
        ((opcode == `OPCODE_Arith_I) && ((funct3 == `F3_SLL) || (funct3 == `F3_SRL))) ? ID_EX_Inst[`IR_shamt] :
        ((opcode == `OPCODE_Arith_R) && ((funct3 == `F3_SLL) || (funct3 == `F3_SRL))) ? ID_EX_data2[4:0] :
        5'b00000;

    //ALU with forwarding
    wire [31:0] alu1, alu2;
    wire [31:0] midmux;
    n4x1MUX ALU1 (.a(ID_EX_data1), .b(ID_EX_Ctrl_WB[1]? MEM_WB_Mem_out : MEM_WB_ALU_out), .c(EX_MEM_ALU_out), .d(ID_EX_PC), .s(ID_EX_Ctrl_EX[2]? 2'b11 : forA), .out(alu1));
    n4x1MUX ALU2 (.a(ID_EX_data2), .b(MEM_WB_Mem_out), .c(EX_MEM_ALU_out), .s(forB), .out(midmux));
    assign alu2 = ID_EX_Ctrl_EX[3]? ID_EX_Imm : midmux;
    //assign alusrc1 = ID_EX_Ctrl_EX[1]? PC : alu1;

    NbitALU alu (.clk(clk), .Reg1(alu1), .Reg2(alu2), .Zero(zero), .ALUSELECT(ALUSELECT), .AUIPC(ID_EX_Ctrl_EX[1] & ~ID_EX_Ctrl_WB[2]), .ALU(alures), .cf(cf), .vf(vf) , .sf(sf) , .shamt(shamt) );
     


    wire [1:0] forA, forB;
    
    ForwardingUnit forward(.ID_rs1(ID_EX_Rs1) , .ID_rs2(ID_EX_Rs2) , .EX_rd(EX_MEM_Rd) , 
                            .MEM_rd(MEM_WB_Rd), .EX_regWrite(EX_MEM_Ctrl_WB[0]) , .MEM_regWrite(MEM_WB_Ctrl[0]), 
                                .fowA(forA), .fowB(forB));
    wire [31:0] EX_MEM_ALU_out, EX_MEM_PC, EX_MEM_Imm;
    wire [4:0] EX_MEM_Ctrl_MEM;
    wire [2:0] EX_MEM_Ctrl_WB;
    wire [4:0] EX_MEM_Rd;
    wire [2:0] EX_MEM_BF3;
    wire [3:0] EX_MEM_ALUF;
    nBitReg #(117) EX_MEM (
    clk, reset, 1'b1,
    (~match? 117'b0 : {ID_EX_Ctrl_MEM, ID_EX_Ctrl_WB, ID_EX_PC, ID_EX_Imm, alures, ID_EX_Rd, ID_EX_BF3, {zero, cf, vf, sf}}),
    
    {EX_MEM_Ctrl_MEM, EX_MEM_Ctrl_WB,  EX_MEM_PC, EX_MEM_Imm, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_BF3, EX_MEM_ALUF}
    );
    
    wire branchTaken;
    BLU branchLogic(.branch(EX_MEM_Ctrl_MEM[1]), .F3(EX_MEM_BF3), .c(EX_MEM_ALUF[2]), .z(EX_MEM_ALUF[3]), .v(EX_MEM_ALUF[1]), .s(EX_MEM_ALUF[0]), .branchTaken(branchTaken));
//    DataMem datamemory (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(alures[7:2]), .data_in(data2), .data_out(memout));
     
     
    wire [31:0] MEM_WB_Mem_out;
    wire [31:0] MEM_WB_ALU_out;
    wire [31:0] MEM_WB_PC;
    wire [2:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;

    nBitReg #(104) MEM_WB (clk,reset,1'b1,
                            {EX_MEM_Ctrl_WB, memout, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_PC},
                            {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
                             MEM_WB_Rd, MEM_WB_PC} );
    
    
endmodule