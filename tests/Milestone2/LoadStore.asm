# ---------- LOAD / STORE ----------
addi x1, x0, 100      # base address (example)
addi x2, x0, 25      # data to store

sw   x2, 0(x1)        # store word: MEM[x1 + 0] = x2
lw   x3, 0(x1)        # load word:  x3 = MEM[x1 + 0]

ecall
