   addi x1, x1, 20       # Point to data area
    lw x2, 0(x1)          # Load word
    lw x3, 4(x1)          # Load another word
    lw x4, 8(x1)          # Load third word
    ecall                 # Halt