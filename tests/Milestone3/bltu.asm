 addi x1, x0, 5        # x1 = 5
    addi x2, x0, -1       # x2 = 0xFFFFFFFF
    bltu x1, x2, taken5   # Should branch (5 < 0xFFFFFFFF unsigned)
    addi x3, x0, 1        # Should be skipped
taken5:
    bltu x2, x1, nottaken5 # Should not branch
    addi x4, x0, 10       # x4 = 10
nottaken5:
    ecall                 # Halt