module Buffer( 
    input  clk, 
    input  reset,
    input  [63:0] mem_data,
    output reg [31:0] instruction_out,
    output wire is_instruction_fetch
);

    reg [31:0] instr0, instr1;
    reg valid0, valid1;
    reg next_is_slot0;

    // high when empty , Works as an enable that 
    assign is_instruction_fetch = ~(valid0 | valid1);

    always @(posedge clk or posedge reset or instr0) begin
        if (reset) begin
            instr0 <= 32'b0;
            instr1 <= 32'b0;
            valid0 <= 0;
            valid1 <= 0;
            instruction_out <= 32'b0;
            next_is_slot0 <= 1'b1;
        
        end else begin
            
          
            if (is_instruction_fetch) begin
                instr0 <= mem_data[31:0];  
                instr1 <= mem_data[63:32];  
                valid0 <= 1;
                valid1 <= 1;
                instruction_out <= 32'b0;
                next_is_slot0 <= 1'b1;
            end
            
           
            else begin
                if (valid0 && next_is_slot0) begin
                    instruction_out <= instr0;
                    valid0 <= 0;
                    next_is_slot0 <= 1'b0;
                end 
                else if (valid1 && !next_is_slot0) begin
                    instruction_out <= instr1;
                    valid1 <= 0;
                    next_is_slot0 <= 1'b1;
                end
            end
        end
    end
endmodule
