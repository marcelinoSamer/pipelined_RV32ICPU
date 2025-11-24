 addi x1, x0, 1        # x1 = 1
    addi x2, x0, 2        # x2 = 2
    fence 15, 15          # Should halt execution (15 = iorw)
    addi x3, x0, 3        # Should not execute
