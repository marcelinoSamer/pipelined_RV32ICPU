# ---------- R-TYPE ----------
addi x1, x0, 10       # x1 = 10
addi x2, x0, 5        # x2 = 5

add  x3, x1, x2       # x3 = x1 + x2 = 15
sub  x4, x1, x2       # x4 = x1 - x2 = 5
and  x5, x1, x2       # x5 = x1 & x2
or   x6, x1, x2       # x6 = x1 | x2
xor  x7, x1, x2       # x7 = x1 ^ x2
sll  x8, x2, x1       # x8 = x2 << (x1 & 0x1F)
slt  x9, x2, x1       # x9 = (x2 < x1) ? 1 : 0
ecall 