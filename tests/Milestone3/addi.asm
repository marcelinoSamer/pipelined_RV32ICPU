 addi x1, x0, 100      # x1 = 100
    addi x2, x1, 50       # x2 = 150
    addi x3, x2, -30      # x3 = 120
    addi x4, x0, -1       # x4 = -1 (0xFFFFFFFF)
    addi x5, x4, 1        # x5 = 0
    ecall                 # Halt
