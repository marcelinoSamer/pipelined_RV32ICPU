 addi x1, x0, 5        # x1 = 5
    addi x2, x0, 10       # x2 = 10
    addi x3, x0, 15       # x3 = 15
    add  x4, x1, x2       # x4 = 15 (independent)
    xor  x5, x2, x3       # x5 = 10 ^ 15
    or   x6, x1, x3       # x6 = 5 | 15
    andi x7, x6, 0x0F     # x7 = x6 & 0x0F
    slli x8, x1, 2        # x8 = x1 << 2
    srli x9, x3, 1        # x9 = x3 >> 1
    ecall                 # Halt for this test