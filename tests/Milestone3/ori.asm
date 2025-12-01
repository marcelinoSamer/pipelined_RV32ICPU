add x0, x0 , x0  
addi x1, x0, 0xF0     # x1 = 0xF0
    ori x2, x1, 0x0F      # x2 = 0xFF
    ori x3, x0, 0x55      # x3 = 0x55
    ori x4, x3, 0xAA      # x4 = 0xFF
    ori x5, x0, -1        # x5 = 0xFFFFFFFF
    ecall                 # Halt
