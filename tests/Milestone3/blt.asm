 addi x1, x0, 5        # x1 = 5
    addi x2, x0, 10       # x2 = 10
    blt x1, x2, taken3    # Should branch (5 < 10)
    addi x3, x0, 1        # Should be skipped
taken3:
    addi x4, x0, 20       # x4 = 20
    blt x2, x1, nottaken3 # Should not branch (10 not < 5)
    addi x5, x0, 25       # x5 = 25
nottaken3:
    ecall                 # Halt
