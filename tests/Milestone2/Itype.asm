# ---------- I-TYPE ----------
addi x10, x0, 12      # x10 = 12
andi x11, x10, 0xF    # x11 = x10 & 0xF = 12 & 15 = 12
ori  x12, x10, 0x3    # x12 = x10 | 3 = 15
xori x13, x10, 5      # x13 = x10 ^ 5
slti x14, x10, 20     # x14 = 1 (since 12 < 20)
sltiu x15, x10, 5     # x15 = 0 (unsigned compare)
ebreak