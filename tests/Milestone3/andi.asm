add x0, x0 , x0
  addi x1, x0, 0xFF     # x1 = 0xFF
    andi x2, x1, 0xF0     # x2 = 0xF0
    andi x3, x1, 0x0F     # x3 = 0x0F
    addi x4, x0, -1       # x4 = 0xFFFFFFFF
    andi x5, x4, 0x55     # x5 = 0x55
    ecall                 # Halt