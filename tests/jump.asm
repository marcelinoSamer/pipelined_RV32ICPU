# ---------- JAL / JALR ----------
addi x1, x0, 100      # x1 = address base (example)
jal  x5, target       # jump to target, save return addr in x5

addi x2, x0, 999      # skipped due to jump

target:
    addi x3, x0, 123
    jalr x0, 0(x5)    # jump back to return address (like "ret")

ecall