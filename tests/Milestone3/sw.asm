
    addi x1, x1, 32       # Point to storage area
    addi x2, x2, 10    # Create value
    sw x2, 0(x1)          # Store word
    sw x2, 4(x1)          # Store at offset 4
    lw x3, 0(x1)          # Read back
    ecall                 # Halt