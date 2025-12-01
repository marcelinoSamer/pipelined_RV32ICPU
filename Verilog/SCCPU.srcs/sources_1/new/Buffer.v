

//The buffer's arhitecture depends on two input signals , the fetch enable and the consume signals , fetch enable is used in enabling
// the whole pipeline register and it is set it is set through the expression  buffer_empty && !(stall | stallCU) && !halted 
//teh other consume input is throughh th enable port of the pipeline register IF_ID_enable 
// The output is a signal of buffer_empty that sets the fetch enable 


module Buffer(
    input  clk,
    input  reset,
    input  [95:0] mem_data,      
    input  fetch_enable,
    input  consume,          
    output reg [31:0] instruction_out,
    output reg buffer_empty  
);
    reg [31:0] instr1, instr2;   
    reg [1:0] valid_count;         
    
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            instr1 <= 32'b0;
            instr2 <= 32'b0;
            valid_count <= 2'b00;
            instruction_out <= 32'b0;
            buffer_empty <= 1'b1;
        end else begin
            
          
            if (buffer_empty && fetch_enable) begin
                instruction_out <= mem_data[31:0];
                instr1 <= mem_data[63:32];
                instr2 <= mem_data[95:64];
                valid_count <= 2'b10;  
                buffer_empty <= 1'b0;
                
           
            end else if (!buffer_empty && consume) begin  
                case(valid_count)
                    2'b10: begin  
                        instruction_out <= instr1;
                        valid_count <= 2'b01;
                    end
                    2'b01: begin  
                        instruction_out <= instr2;
                        valid_count <= 2'b00;
                        buffer_empty <= 1'b1; 
                    end
                    default: begin
                        instruction_out <= 32'b0;
                        buffer_empty <= 1'b1;
                    end
                endcase
            end
        
        end
    end
endmodule