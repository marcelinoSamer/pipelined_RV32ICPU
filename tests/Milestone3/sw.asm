auipc x1, 0           # Get current PC
    addi x1, x1, 32       # Point to storage area
    lui x2, 0xDEADB
    addi x2, x2, 0x7EF    # Create value
    sw x2, 0(x1)          # Store word
    sw x2, 4(x1)          # Store at offset 4
    lw x3, 0(x1)          # Read back
    ecall                 # Halt