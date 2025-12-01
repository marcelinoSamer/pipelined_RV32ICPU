    add x0 , x0 , x0
    addi x1, x0, 1        # x1 = 1
    slli x2, x1, 5        # x2 = 32
    addi x3, x0, 0xFF
    slli x4, x3, 4        # x4 = 0xFF0
    slli x5, x1, 31       # x5 = 0x80000000
    ecall                 # Halt
