    .text
    addi x1, x0, 10
    addi x2, x0, 20

    # fence.tso encoding
    .insn r 0x0F, 0x3, 0x0, x0, x0, x0   # encodes 0x8330000f

    addi x3, x0, 30   # should not execute
