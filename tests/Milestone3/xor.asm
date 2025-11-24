 addi x1, x0, 0xFF     # x1 = 0xFF
    addi x2, x0, 0x0F     # x2 = 0x0F
    xor x3, x1, x2        # x3 = 0xF0
    addi x4, x0, 0x55
    addi x5, x0, 0xAA
    xor x6, x4, x5        # x6 = 0xFF
    ecall                 # Halt
