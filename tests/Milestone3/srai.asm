 addi x1, x0, 0x80     # x1 = 128
    srai x2, x1, 4        # x2 = 8
    addi x3, x0, -1       # x3 = 0xFFFFFFFF
    srai x4, x3, 8        # x4 = 0xFFFFFFFF (sign extended)
    lui x5, 0x80000       # x5 = 0x80000000
    srai x6, x5, 4        # x6 = 0xF8000000 (sign extended)
    ecall                 # Halt
