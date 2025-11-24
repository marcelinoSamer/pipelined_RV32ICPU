 addi x1, x0, -1       # x1 = 0xFFFFFFFF
    addi x2, x0, 5        # x2 = 5
    bgeu x1, x2, taken6   # Should branch (0xFFFFFFFF >= 5 unsigned)
    addi x3, x0, 1        # Should be skipped
taken6:
    bgeu x2, x1, nottaken6 # Should not branch
    addi x4, x0, 10       # x4 = 10
nottaken6:
    ecall                 # Halt