add x0, x0 , x0   
 addi x1, x1, 100       # Point to storage area
    addi x2, x2, 20    # x2 has value
    sh x2, 0(x1)          # Store halfword
    sh x2, 2(x1)          # Store at offset 2
    lh x3, 0(x1)          # Read back
    ecall                 # Halt