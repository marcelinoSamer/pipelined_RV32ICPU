 addi x1, x0, 0xF0     # x1 = 0xF0
    addi x2, x0, 0x0F     # x2 = 0x0F
    or x3, x1, x2         # x3 = 0xFF
    addi x4, x0, 0x55
    addi x5, x0, 0xAA
    or x6, x4, x5         # x6 = 0xFF
    ecall                 # Halt