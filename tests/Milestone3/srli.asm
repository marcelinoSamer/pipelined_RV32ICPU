addi x1, x0, 0x80     # x1 = 128
    srli x2, x1, 4        # x2 = 8
    addi x3, x0, -1       # x3 = 0xFFFFFFFF
    srli x4, x3, 8        # x4 = 0x00FFFFFF
    srli x5, x3, 31       # x5 = 1
    ecall                 # Halt
