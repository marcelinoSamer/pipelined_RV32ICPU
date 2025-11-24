   auipc x1, 0           # Get current PC
    addi x1, x1, 32       # Point to storage area
    lui x2, 0x12345
    addi x2, x2, 0x678    # x2 has value
    sh x2, 0(x1)          # Store halfword
    sh x2, 2(x1)          # Store at offset 2
    lh x3, 0(x1)          # Read back
    ecall                 # Halt