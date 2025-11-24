 addi x1, x0, 10       # x1 = 10
    addi x2, x0, 20       # x2 = 20
    add x3, x1, x2        # x3 = 30
    add x4, x3, x1        # x4 = 40
    add x5, x0, x1        # x5 = 10
    ecall                 # Halt
