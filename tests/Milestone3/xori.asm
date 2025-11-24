  addi x1, x0, 0xFF     # x1 = 0xFF
    xori x2, x1, 0x0F     # x2 = 0xF0
    xori x3, x1, -1       # x3 = NOT(x1)
    addi x4, x0, 0x55
    xori x5, x4, 0xAA     # x5 = 0xFF
    ecall                 # Halt