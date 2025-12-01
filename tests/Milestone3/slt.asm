add x0 , x0 , x0
addi x1, x0, 10       # x1 = 10
    addi x2, x0, 20       # x2 = 20
    slt x3, x1, x2        # x3 = 1 (10 < 20)
    slt x4, x2, x1        # x4 = 0
    addi x5, x0, -5
    slt x6, x5, x1        # x6 = 1 (-5 < 10)
    ecall                 # Halt
