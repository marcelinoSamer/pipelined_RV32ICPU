# ---------- LOOP ----------
addi x1, x0, 0        # i = 0
addi x2, x0, 5        # limit = 5

loop:
    addi x1, x1, 1    # i = i + 1
    blt  x1, x2, loop # if (i < limit) branch to loop

ecall 