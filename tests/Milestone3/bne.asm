 addi x1, x0, 5        # x1 = 5
    addi x2, x0, 10       # x2 = 10
    bne x1, x2, taken2    # Should branch (not equal)
    addi x3, x0, 1        # Should be skipped
taken2:
    addi x4, x0, 15       # x4 = 15
    bne x4, x4, nottaken2 # Should not branch (equal)
    addi x5, x0, 20       # x5 = 20
nottaken2:
    ecall                 # Halt