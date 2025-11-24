    addi x1, x0, 7        # x1 = 7
    addi x2, x0, 14       # x2 = 14

    .4byte 0x0100000F     # pause instruction (fence 0,0)

    addi x3, x0, 21       # Should not execute
