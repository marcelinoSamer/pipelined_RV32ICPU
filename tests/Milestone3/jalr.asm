 auipc x1, 0           # Get current PC
    addi x1, x1, 16       # Calculate target address
    jalr x2, x1, 0        # Jump to x1 + 0
    addi x3, x0, 1        # This should be skipped
    addi x4, x0, 2        # Target: x4 = 2
    jalr x0, x2, 0        # Return (jump to x2)
    ecall       