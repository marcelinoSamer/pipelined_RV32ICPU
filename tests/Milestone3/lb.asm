auipc x1, 0           # Get current PC
    addi x1, x1, 20       # Point to data area
    lb x2, 0(x1)          # Load byte (sign extended)
    lb x3, 1(x1)          # Load negative byte
    lb x4, 2(x1)          # Load another byte
    ecall                 # Halt