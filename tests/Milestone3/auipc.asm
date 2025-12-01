add x0 , x0 , x0 
   addi x1, x0, 0     # x1 = PC + 0
    auipc x2, 0x00001     # x2 = PC + 0x1000
    auipc x3, 0xFFFFF     # x3 = PC + 0xFFFFF000
    auipc x4, 0x12345     # x4 = PC + 0x12345000
    ecall                 # Halt
