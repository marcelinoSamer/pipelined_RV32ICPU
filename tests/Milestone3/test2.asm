 addi x20, x0, 8        # x20 = loop counter N = 8
    addi x21, x0, 0        # x21 = accumulator = 0

loop_no_hazard_top:
    addi x21, x21, 1       # x21 = x21 + 1   (writes x21)
    addi x0, x0, 0         # nop (bubble)
    addi x0, x0, 0         # nop (another bubble)
    addi x20, x20, -1      # x20 = x20 - 1
    bne  x20, x0, loop_no_hazard_top
    ecall                  # Halt for this test