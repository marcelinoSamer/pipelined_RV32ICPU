 addi x1, x0, 10       # x1 = 10
    sltiu x2, x1, 20      # x2 = 1
    sltiu x3, x1, 5       # x3 = 0
    addi x4, x0, -1       # x4 = 0xFFFFFFFF
    sltiu x5, x4, 10      # x5 = 0 (0xFFFFFFFF not < 10 unsigned)
    sltiu x6, x1, -1      # x6 = 1 (10 < 0xFFFFFFFF unsigned)
    ecall                 # Halt