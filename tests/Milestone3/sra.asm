add x0, xo0 , x0 
addi x1, x0, 0x80     # x1 = 128
    addi x2, x0, 4        # Shift amount
    sra x3, x1, x2        # x3 = 8
    addi x4, x0, -1       # x4 = 0xFFFFFFFF
    addi x5, x0, 8
    sra x6, x4, x5        # x6 = 0xFFFFFFFF (sign extended)
    ecall                 # Halt

