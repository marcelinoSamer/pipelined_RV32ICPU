`timescale 1ns / 1ps
module tb;
    // Testbench signals
    reg clk;
    reg reset;
  
    // Instantiate the CPU
    SCCPU uut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Load program into memory
    initial begin
        // Wait for memory to be initialized
        #1;
        
        // Load hex file into memory
        $readmemh("C:/Users/ASUS/Desktop/pipelined_RV32ICPU/tests/Milestone3/jalr.hex", uut.Memory.memory);
        

end    
    // Test control
    initial begin
        // Initialize inputs
        reset = 1;
        
        // Hold reset for a few cycles
        #20;
        reset = 0;
        
 
        
        // Run for sufficient time
        #5000;
        

end
    
endmodule