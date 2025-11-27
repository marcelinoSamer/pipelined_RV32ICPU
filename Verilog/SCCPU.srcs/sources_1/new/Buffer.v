module Buffer( 
    input  clk, 
    input  reset,
    input  [95:0] mem_data,
    output reg [31:0] instruction_out,
    output reg buffer_empty  
);

    reg [31:0] instr0, instr1;
    reg valid0, valid1;
    reg first_output;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr0 <= 32'b0;
            instr1 <= 32'b0;
            valid0 <= 0;
            valid1 <= 0;
            instruction_out <= 32'b0;
            first_output <= 1;
            buffer_empty <= 1'b1;  
        end else begin
          
            buffer_empty <= ~(valid0 | valid1);

            if (buffer_empty && ~valid0 && ~valid1 && ~first_output) begin
                instr0 <= mem_data[63:32];  
                instr1 <= mem_data[95:64];  
                valid0 <= 1;
                valid1 <= 1;
                first_output <= 0;  
                instruction_out <= mem_data[63:32];
            end else begin
                if (valid1 & ~first_output) begin
                    instruction_out <= instr1;
                    valid1 <= 0;
                    valid0<=0;
                    first_output<=1;
                    buffer_empty<=1'b1;
                    
                end
            end
        end
    end
endmodule
