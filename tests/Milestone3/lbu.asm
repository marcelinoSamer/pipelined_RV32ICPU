  add x0, x0 , x0 
    addi x1, x1, 20       # Point to data area
    lbu x2, 0(x1)         # Load unsigned byte
    lbu x3, 1(x1)         # 0x80 -> 0x00000080 (no sign extend)
    lbu x4, 2(x1)         # 0xFF -> 0x000000FF
    ecall                 # Halt