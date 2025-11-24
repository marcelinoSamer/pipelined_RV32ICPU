jal x1, target1       # Jump to target1, x1 = return address
target1:
    jal x2, target2       # Jump to target2, x2 = return address
target2:
    jal x0, target3       # Jump without saving return address
target3:
    jal x3, end_jal       # Jump to end
end_jal:
    ecall                 # Halt