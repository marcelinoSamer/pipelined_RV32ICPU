  module UnifiedMem #(parameter Size = 4096,
    parameter Address_width = 6,
    parameter INSTR_END = 2048  , 
    parameter DATA_SIZE = Size - INSTR_END) 
 (input wire clk,
 input wire [Address_width-1:0] address , 
 input wire [1:0] MemRead ,
 input wire [1:0] MemWrite ,
 input wire [31:0] writedata ,
 output reg [95:0] read_data ,
 input wire mem_unsigned , 
 input wire is_instruction_fetch , input [31:0] PC, input flush  )  ; 



    reg [7:0] memory [0:Size-1];
    wire instr_region = (address < INSTR_END);
    
    //function to calcuate the wrapped address due to memory being split into inst and data
    function [Address_width-1:0] wrap_data_addr;
        input [Address_width-1:0] addr;
        begin
            wrap_data_addr = (addr - INSTR_END) % DATA_SIZE;
        end
    endfunction

    wire [Address_width-1:0] addr0 = instr_region ? address : (wrap_data_addr(address) + INSTR_END);
    wire [Address_width-1:0] addr1 = instr_region ? address + 1 : (wrap_data_addr(address + 1) + INSTR_END);
    wire [Address_width-1:0] addr2 = instr_region ? address + 2 : (wrap_data_addr(address + 2) + INSTR_END);
    wire [Address_width-1:0] addr3 = instr_region ? address + 3 : (wrap_data_addr(address + 3) + INSTR_END);
    wire [Address_width-1:0] addr4  = instr_region ? (address + 4) : (wrap_data_addr(address + 4) + INSTR_END);
    wire [Address_width-1:0] addr5  = instr_region ? (address + 5) : (wrap_data_addr(address + 5) + INSTR_END);
    wire [Address_width-1:0] addr6  = instr_region ? (address + 6) : (wrap_data_addr(address + 6) + INSTR_END);
    wire [Address_width-1:0] addr7  = instr_region ? (address + 7) : (wrap_data_addr(address + 7) + INSTR_END);
    wire [Address_width-1:0] addr8  = instr_region ? (address + 8) : (wrap_data_addr(address + 8) + INSTR_END);
    wire [Address_width-1:0] addr9  = instr_region ? (address + 9) : (wrap_data_addr(address + 9) + INSTR_END);
    wire [Address_width-1:0] addr10 = instr_region ? (address + 10) : (wrap_data_addr(address + 10) + INSTR_END);
    wire [Address_width-1:0] addr11 = instr_region ? (address + 11) : (wrap_data_addr(address + 11) + INSTR_END);


    /*initial begin
        $readmemh("program.mem", memory); //to be tested
    end*/   //test bench file
    
    
//initial begin
       
        
//        // Load test program
//        // Instruction 0: ADDI x1, x0, 10 (0x00a00093)
//        memory[0]  = 8'h93;
//        memory[1]  = 8'h00;
//        memory[2]  = 8'ha0;
//        memory[3]  = 8'h00;

//        // Instruction 1: ADDI x2, x0, 20 (0x01400113)
//        memory[4]  = 8'h13;
//        memory[5]  = 8'h01;
//        memory[6]  = 8'h40;
//        memory[7]  = 8'h01;

//        // Instruction 2: ADD x3, x1, x2 (0x002081b3)
//        memory[8]  = 8'hb3;
//        memory[9]  = 8'h81;
//        memory[10] = 8'h20;
//        memory[11] = 8'h00;

//        // Instruction 3: ADD x4, x3, x1 (0x00118233)
//        memory[12] = 8'h33;
//        memory[13] = 8'h82;
//        memory[14] = 8'h11;
//        memory[15] = 8'h00;

//        // Instruction 4: ADD x5, x0, x1 (0x001002b3)
//        memory[16] = 8'hb3;
//        memory[17] = 8'h02;
//        memory[18] = 8'h10;
//        memory[19] = 8'h00;

//        // Instruction 5: ECALL (0x00000073)
//        memory[20] = 8'h73;
//        memory[21] = 8'h00;
//        memory[22] = 8'h00;
//        memory[23] = 8'h00;
        
//        // Initialize data memory with test values
//        memory[2048] = 8'h11;  // Data at address 0 (word 0)
//        memory[2049] = 8'h00;
//        memory[2050] = 8'h00;
//        memory[2051] = 8'h00;
        
//        memory[2052] = 8'h09;  // Data at address 4 (word 1)
//        memory[2053] = 8'h00;
//        memory[2054] = 8'h00;
//        memory[2055] = 8'h00;
//    end
    
 
   reg [7:0] b; 
                reg [31:0] b_ext;
 reg [15:0] h; 
                reg [31:0] h_ext; 
 always @(posedge clk) begin
    if (!instr_region) begin
        case (MemWrite)
            2'b01: begin  // SB
                memory[addr0] <= writedata[7:0];
            end
      
            2'b10: begin  // SH 
                memory[addr0]   <= writedata[7:0];
                memory[addr1+1] <= writedata[15:8];
            end
            
            2'b11: begin  // SW 
                memory[addr0]   <= writedata[7:0];
                memory[addr1] <= writedata[15:8];
                memory[addr2] <= writedata[23:16];
                memory[addr3] <= writedata[31:24];
            end
            
            endcase
  end       
      case (MemRead)
            2'b01: begin  // LB / LBU 
                 b = memory[addr0];
                 b_ext = mem_unsigned ? {24'b0, b} : {{24{b[7]}}, b};
                read_data <= {32'b0, b_ext};
            end
               
            
            2'b10: begin  // LH / LHU 
                 h = {memory[addr1], memory[addr0]};
                h_ext = mem_unsigned ? {16'b0, h} : {{16{h[15]}}, h};
                read_data <= {32'b0, h_ext};
               end

            
           2'b11: begin  // LW or Instruction Fetch
                if (is_instruction_fetch) begin
                    // Fetch 96 bits = 12 bytes = 3 instructions
                    read_data <= {
                        memory[PC+11], memory[PC+10], memory[PC+9],  memory[PC+8], 
                        memory[PC+7],  memory[PC+6],  memory[PC+5],  memory[PC+4],                          			
                        memory[PC+3],  memory[PC+2],  memory[PC+1],  memory[PC]};
                end
                else begin
                    // LW - Load Word (32 bits), pad to 96 bits
                    read_data <= {64'b0, memory[addr3], memory[addr2], memory[addr1], memory[addr0]};
                end
            end
            default: begin
                read_data <= 96'b0;
            end
        endcase
    end
endmodule 
        