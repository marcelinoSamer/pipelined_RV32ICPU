module UnifiedMem #(
    parameter Size = 150,
    parameter Address_width = 8,
    parameter INSTR_END = 100,  // Back to byte address
    parameter DATA_SIZE = Size - INSTR_END
) (
    input wire clk,
    input wire [Address_width-1:0] address,  // Full byte address now
    input wire [1:0] MemRead,
    input wire [1:0] MemWrite,
    input wire [31:0] writedata,
    output reg [95:0] read_data,
    input wire mem_unsigned,
    input wire fetch_enable,
    input wire [31:0] PC
);

    reg [7:0] memory [0:Size-1];
    
    // Use byte address for region detection
    wire is_fetch = fetch_enable && (MemRead == 2'b11);
       
       // For data accesses, map virtual address to physical
       // For instruction fetches, use address directly
       function [Address_width-1:0] get_physical_addr;
           input [Address_width-1:0] addr;
           input is_instr_fetch;
           begin
               if (is_instr_fetch)
                   get_physical_addr = addr;  // Instructions use direct addressing
               else
                   get_physical_addr = ((addr % DATA_SIZE) + INSTR_END);  // Data wraps in data region
           end
       endfunction
   
       // Calculate byte addresses
       wire [Address_width-1:0] base_addr = get_physical_addr(address, is_fetch);
       wire [Address_width-1:0] addr0  = base_addr;
       wire [Address_width-1:0] addr1  = base_addr + 1;
       wire [Address_width-1:0] addr2  = base_addr + 2;
       wire [Address_width-1:0] addr3  = base_addr + 3;
       wire [Address_width-1:0] addr4  = base_addr + 4;
       wire [Address_width-1:0] addr5  = base_addr + 5;
       wire [Address_width-1:0] addr6  = base_addr + 6;
       wire [Address_width-1:0] addr7  = base_addr + 7;
       wire [Address_width-1:0] addr8  = base_addr + 8;
       wire [Address_width-1:0] addr9  = base_addr + 9;
       wire [Address_width-1:0] addr10 = base_addr + 10;
       wire [Address_width-1:0] addr11 = base_addr + 11;

    reg [7:0] b; 
    reg [31:0] b_ext;
    reg [15:0] h; 
    reg [31:0] h_ext; 
    
//    integer i ;
    
//    initial begin 

//    for (i=100 ; i<150;i=i+1) begin 
//    memory[i] <=2;
//    end
//    end 
    // Memory writes - only allow in data region
    always @(posedge clk) begin
       
            case (MemWrite)
            
                2'b01: begin  // SB

                    memory[addr0] <= writedata[7:0];
                end
          
                2'b10: begin  // SH 
                
                    memory[addr0] <= writedata[7:0];
                    memory[addr1] <= writedata[15:8];
                end
                
                2'b11: begin  // SW 
                
                    memory[addr0] <= writedata[7:0];
                    memory[addr1] <= writedata[15:8];
                    memory[addr2] <= writedata[23:16];
                    memory[addr3] <= writedata[31:24];
                end
            endcase
        end 
    
     
    // reads
    always @(*) begin    
        case (MemRead)
            2'b01: begin  // LB / LBU 
            
                b = memory[addr0];
                b_ext = mem_unsigned ? {24'b0, b} : {{24{b[7]}}, b};
                read_data = {64'b0, b_ext};
            end
               
            2'b10: begin  // LH / LHU 
         
                h = {memory[addr1], memory[addr0]};
                h_ext = mem_unsigned ? {16'b0, h} : {{16{h[15]}}, h};
                read_data = {64'b0, h_ext};
            end

            2'b11: begin  
                if (fetch_enable) begin
                   
                    read_data = {
                        memory[PC+11], memory[PC+10], memory[PC+9],  memory[PC+8], 
                        memory[PC+7],  memory[PC+6],  memory[PC+5],  memory[PC+4],                          			
                        memory[PC+3],  memory[PC+2],  memory[PC+1],  memory[PC]
                    };
                end
                else begin
                    // LW - Load Word (32 bits), pad to 96 bits
             
                    read_data = {64'b0, memory[addr3], memory[addr2], memory[addr1], memory[addr0]};
                end
            end
            
            default: begin
                read_data = 96'b0;
            end
        endcase
    end
 
endmodule