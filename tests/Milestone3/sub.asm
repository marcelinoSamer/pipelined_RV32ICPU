 addi x1, x0, 50       # x1 = 50
    addi x2, x0, 20       # x2 = 20
    sub x3, x1, x2        # x3 = 30
    sub x4, x2, x1        # x4 = -30
    sub x5, x1, x0        # x5 = 50
    ecall                 # Halt