add x0, x0, x0
 addi x1, x0, 10       # x1 = 10
    slti x2, x1, 20       # x2 = 1 (10 < 20)
    slti x3, x1, 5        # x3 = 0 (10 not < 5)
    slti x4, x1, 10       # x4 = 0 (10 not < 10)
    addi x5, x0, -5
    slti x6, x5, 0        # x6 = 1 (-5 < 0)