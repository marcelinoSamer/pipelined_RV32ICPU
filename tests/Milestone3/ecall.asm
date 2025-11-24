 addi x1, x0, 100      # x1 = 100
    addi x2, x0, 200      # x2 = 200
    ecall                 # Should halt execution
    addi x3, x0, 300      # Should not execute
