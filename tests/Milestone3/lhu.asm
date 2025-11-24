 auipc x1, 0           # Get current PC
    addi x1, x1, 20       # Point to data area
    lhu x2, 0(x1)         # Load unsigned halfword
    lhu x3, 2(x1)         # 0x8000 -> 0x00008000
    lhu x4, 4(x1)         # 0xFFFF -> 0x0000FFFF
    ecall                 # Halt