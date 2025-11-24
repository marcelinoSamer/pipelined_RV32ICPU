addi x1, x0, 10       # x1 = 10
    addi x2, x0, 20       # x2 = 20
    sltu x3, x1, x2       # x3 = 1
    sltu x4, x2, x1       # x4 = 0
    addi x5, x0, -1       # x5 = 0xFFFFFFFF
    sltu x6, x1, x5       # x6 = 1
    ecall                 # Halt
