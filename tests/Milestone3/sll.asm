    addi x1, x0, 1        # x1 = 1
    addi x2, x0, 5        # Shift amount
    sll x3, x1, x2        # x3 = 32
    addi x4, x0, 0xFF
    addi x5, x0, 4
    sll x6, x4, x5        # x6 = 0xFF0
    ecall                 # Halt
