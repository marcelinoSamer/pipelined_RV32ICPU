# ---------- BRANCHES ----------
addi x1, x0, 10
addi x2, x0, 20

blt  x1, x2, less     # if x1 < x2 -> jump
bge  x1, x2, greater_equal
beq  x1, x2, equal
bne  x1, x2, not_equal
bltu x1, x2, less_unsigned
bgeu x1, x2, greater_equal_unsigned

less:
    addi x3, x0, 1
    j   done

greater_equal:
    addi x3, x0, 2
    j   done

equal:
    addi x3, x0, 3
    j   done

not_equal:
    addi x3, x0, 4
    j   done

less_unsigned:
    addi x3, x0, 5
    j   done

greater_equal_unsigned:
    addi x3, x0, 6

done:
    ecall
