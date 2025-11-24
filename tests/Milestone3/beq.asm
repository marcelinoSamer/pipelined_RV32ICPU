  addi x1, x0, 5        # x1 = 5
    addi x2, x0, 5        # x2 = 5
    beq x1, x2, taken1    # Should branch (equal)
    addi x3, x0, 1        # Should be skipped
taken1:
    addi x4, x0, 10       # x4 = 10
    addi x5, x0, 20       # x5 = 20
    beq x4, x5, nottaken  # Should not branch
    addi x6, x0, 30       # x6 = 30
nottaken:
    ecall                 # Halt
