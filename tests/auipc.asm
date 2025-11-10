# ---------- AUIPC ----------
auipc x1, 0x1         # x1 = PC + (0x1 << 12)
addi  x1, x1, 20      # adjust address
ecall 