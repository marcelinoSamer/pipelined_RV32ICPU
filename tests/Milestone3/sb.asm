add x0, x0 , x0     
addi x1, x1, 100       # Point to storage area
    addi x2, x0, 20     # Value to store
    sb x2, 0(x1)          # Store byte
    addi x3, x0, -1       # 0xFF
    sb x3, 1(x1)          # Store at offset 1
      ecall                 # Halt