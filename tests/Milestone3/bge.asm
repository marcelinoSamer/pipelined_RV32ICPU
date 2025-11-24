addi x1, x0, 10       # x1 = 10
    addi x2, x0, 5        # x2 = 5
    bge x1, x2, taken4    # Should branch (10 >= 5)
    addi x3, x0, 1        # Should be skipped
taken4:
    addi x4, x0, 15       # x4 = 15
    bge x2, x1, nottaken4 # Should not branch (5 not >= 10)
    addi x5, x0, 20       # x5 = 20
nottaken4:
    ecall                 # Halt