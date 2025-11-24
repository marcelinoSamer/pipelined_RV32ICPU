  addi x10, x0, 1       # x10 = 1
    add  x11, x10, x10    # x11 = x10 + x10   (depends on x10)
    add  x12, x11, x10    # x12 = x11 + x10   (depends on x11, x10)
    sub  x13, x12, x11    # x13 = x12 - x11   (depends on x12, x11)
    slli x14, x13, 2      # x14 depends on x13
    add  x15, x14, x13    # chain continues — creates hazards
    ecall                 # Halt for this test
