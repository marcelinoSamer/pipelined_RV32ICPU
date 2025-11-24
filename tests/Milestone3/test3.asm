addi x30, x0, 8        # x30 = loop counter N = 8
    addi x31, x0, 0        # x31 = accumulator = 0

loop_with_hazard_top:
    addi x31, x31, 1       # x31 depends on previous x31 (RAW)
    addi x30, x30, -1      # x30 = x30 - 1
    bne  x30, x0, loop_with_hazard_top
    ecall                  # Halt for this test