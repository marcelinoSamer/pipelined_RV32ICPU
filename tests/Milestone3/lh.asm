 auipc x1, 0           # Get current PC
    addi x1, x1, 20       # Point to data area
    lh x2, 0(x1)          # Load halfword
    lh x3, 2(x1)          # Load negative halfword
    lh x4, 4(x1)          # Load another halfword
    ecall                 # Halt