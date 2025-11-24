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
 input wire is_instruction_fetch) ; 



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
                reg [7:0] b = memory[addr0];
                reg [31:0] b_ext = mem_unsigned ? {24'b0, b} : {{24{b[7]}}, b};
                read_data <= {32'b0, b_ext};
            end
               
            
            2'b10: begin  // LH / LHU 
                reg [15:0] h = {memory[addr1], memory[addr0]};
                reg [31:0] h_ext = mem_unsigned ? {16'b0, h} : {{16{h[15]}}, h};
                read_data <= {32'b0, h_ext};
               end

            
           2'b11: begin  // LW or Instruction Fetch
                if (is_instruction_fetch) begin
                    // Fetch 96 bits = 12 bytes = 3 instructions
                    read_data <= {
                        memory[addr11], memory[addr10], memory[addr9],  memory[addr8], 
                        memory[addr7],  memory[addr6],  memory[addr5],  memory[addr4],                          			
                        memory[addr3],  memory[addr2],  memory[addr1],  memory[addr0]};
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