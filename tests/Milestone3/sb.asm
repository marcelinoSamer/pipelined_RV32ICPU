 auipc x1, 0           # Get current PC
    addi x1, x1, 32       # Point to storage area
    addi x2, x0, 0x78     # Value to store
    sb x2, 0(x1)          # Store byte
    addi x3, x0, -1       # 0xFF
    sb x3, 1(x1)          # Store at offset 1
    lb x4, 0(x1)          # Read back
    ecall                 # Halt