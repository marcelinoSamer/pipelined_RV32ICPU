module unified_mem #(parameter Size = 256,
    parameter Address_width = 8,
    parameter INSTR_END = 128  , 
    parameter DATA_SIZE = Size - INSTR_END) 
(input wire clk, input wire [Address_width-1:0] address , input wire [1:0] MemRead ,input wire [1:0] MemWrite ,input wire [63:0] writedata ,output reg [63:0] read_data , input wire mem_unsigned ,  input wire is_instruction_fetch) ; 



    reg [7:0] memory [0:Size-1];
    wire instr_region = (address < INSTR_END);
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
                wire [7:0] b = memory[addr0];
                wire [31:0] b_ext = mem_unsigned ? {24'b0, b} : {{24{b[7]}}, b};
                read_data <= {32'b0, b_ext};
            end
                else begin // LB 
                    read_data <= {32'b0, 24'b0, memory[address]};
                end
                end
            
            2'b10: begin  // LH / LHU 
                wire [15:0] h = {memory[addr1], memory[addr0]};
                wire [31:0] h_ext = mem_unsigned ? {16'b0, h} : {{16{h[15]}}, h};
                read_data <= {32'b0, h_ext};
               end

                else begin // LHU
               read_data <= {32'b0, 16'b0, memory[address+1], memory[address]};  
            end
end
            
            2'b11: begin  // LW  or we will fetch 2 instructions for the buffer and the fetching stage 
                if (is_instruction_fetch) begin
                    read_data <= {
                        memory[address+7], memory[address+6],
                        memory[address+5], memory[address+4],
                        memory[address+3], memory[address+2],
                        memory[address+1], memory[address]
                    };
                end
                else begin
                    // LW:
                   wire [31:0] w = {memory[addr3], memory[addr2], memory[addr1], memory[addr0]};
                    read_data <= {32'b0, w};
                end
            end
            default: begin
                read_data <= 32'b0;
            end
        endcase
    end
endmodule
