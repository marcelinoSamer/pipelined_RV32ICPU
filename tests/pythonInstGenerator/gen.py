#!/usr/bin/env python3
"""
Quantum-Random RV32I Instruction Generator
- Generates 32-bit RV32I instructions (42 base)
- Uses quantum circuit for random seed (<=15 qubits)
- Outputs:
    - .hex file: instruction words in hex
    - .txt file: binary instruction + assembly
"""

import random
import os
from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator

# -------------------------
# Config
# -------------------------
NUM_INSTRUCTIONS = 20
N_QUBITS_SEED = 15

script_dir = os.path.dirname(os.path.abspath(__file__))
HEX_FILE = os.path.join(script_dir, "instructions.hex")
TXT_FILE = os.path.join(script_dir, "instructions.txt")

REGS = [f"x{i}" for i in range(32)]

# -------------------------
# Quantum seed
# -------------------------
def quantum_random_seed(n_qubits=15):
    qc = QuantumCircuit(n_qubits, n_qubits)
    qc.h(range(n_qubits))
    qc.measure(range(n_qubits), range(n_qubits))
    simulator = AerSimulator()
    result = simulator.run(qc, shots=1).result()
    counts = result.get_counts()
    bits_str = list(counts.keys())[0]
    return int(bits_str, 2)

def generate_32bit_seed():
    seed = 0
    for _ in range(3):
        seed = (seed << 15) | quantum_random_seed(N_QUBITS_SEED)
    return seed & 0xFFFFFFFF

# -------------------------
# RV32I Instruction data
# -------------------------
INSTR_TYPES = {
    "ADD": "R", "SUB": "R", "AND": "R", "OR": "R", "XOR": "R",
    "SLL": "R", "SRL": "R", "SRA": "R", "SLT": "R", "SLTU": "R",
    "ADDI": "I", "ANDI": "I", "ORI": "I", "XORI": "I", "SLLI": "I",
    "SRLI": "I", "SRAI": "I", "SLTI": "I", "SLTIU": "I",
    "JALR": "I", "LB": "I", "LH": "I", "LW": "I", "LBU": "I", "LHU": "I",
    "SB": "S", "SH": "S", "SW": "S",
    "BEQ": "B", "BNE": "B", "BLT": "B", "BGE": "B", "BLTU": "B", "BGEU": "B",
    "LUI": "U", "AUIPC": "U",
    "JAL": "J",
    "FENCE": "I", "ECALL": "I", "EBREAK": "I"
}

OPCODES = {
    "ADD": 0b0110011, "SUB": 0b0110011, "AND": 0b0110011, "OR": 0b0110011, "XOR": 0b0110011,
    "SLL": 0b0110011, "SRL": 0b0110011, "SRA": 0b0110011, "SLT": 0b0110011, "SLTU": 0b0110011,
    "ADDI": 0b0010011, "ANDI": 0b0010011, "ORI": 0b0010011, "XORI": 0b0010011,
    "SLLI": 0b0010011, "SRLI": 0b0010011, "SRAI": 0b0010011, "SLTI": 0b0010011, "SLTIU": 0b0010011,
    "JALR": 0b1100111, "LB": 0b0000011, "LH": 0b0000011, "LW": 0b0000011, "LBU": 0b0000011, "LHU": 0b0000011,
    "SB": 0b0100011, "SH": 0b0100011, "SW": 0b0100011,
    "BEQ": 0b1100011, "BNE": 0b1100011, "BLT": 0b1100011, "BGE": 0b1100011, "BLTU": 0b1100011, "BGEU": 0b1100011,
    "LUI": 0b0110111, "AUIPC": 0b0010111,
    "JAL": 0b1101111,
    "FENCE":0b0001111, "ECALL":0b1110011, "EBREAK":0b1110011
}

FUNCT3 = {
    "ADD":0b000, "SUB":0b000, "AND":0b111, "OR":0b110, "XOR":0b100,
    "SLL":0b001, "SRL":0b101, "SRA":0b101, "SLT":0b010, "SLTU":0b011,
    "ADDI":0b000, "ANDI":0b111, "ORI":0b110, "XORI":0b100,
    "SLLI":0b001, "SRLI":0b101, "SRAI":0b101, "SLTI":0b010, "SLTIU":0b011,
    "JALR":0b000,
    "LB":0b000, "LH":0b001, "LW":0b010, "LBU":0b100, "LHU":0b101,
    "SB":0b000, "SH":0b001, "SW":0b010,
    "BEQ":0b000, "BNE":0b001, "BLT":0b100, "BGE":0b101, "BLTU":0b110, "BGEU":0b111,
    "LUI":0, "AUIPC":0,
    "JAL":0,
    "FENCE":0b000, "ECALL":0b000, "EBREAK":0b000
}

FUNCT7 = {
    "ADD":0b0000000, "SUB":0b0100000, "AND":0b0000000, "OR":0b0000000, "XOR":0b0000000,
    "SLL":0b0000000, "SRL":0b0000000, "SRA":0b0100000, "SLT":0b0000000, "SLTU":0b0000000
}

# -------------------------
# Helpers
# -------------------------
def reg_index(r):
    return int(r[1:])

# -------------------------
# Instruction generators
# -------------------------
def rand_r_type(instr):
    rd = random.choice(REGS)
    rs1 = random.choice(REGS)
    rs2 = random.choice(REGS)
    word = (FUNCT7[instr]<<25) | (reg_index(rs2)<<20) | (reg_index(rs1)<<15) | (FUNCT3[instr]<<12) | (reg_index(rd)<<7) | OPCODES[instr]
    asm = f"{instr} {rd}, {rs1}, {rs2}"
    return word, asm

def rand_i_type(instr):
    rd = random.choice(REGS)
    rs1 = random.choice(REGS)
    imm = random.randint(0, 2**12-1)
    word = (imm<<20) | (reg_index(rs1)<<15) | (FUNCT3[instr]<<12) | (reg_index(rd)<<7) | OPCODES[instr]
    if instr == "JALR" or instr in ["LB","LH","LW","LBU","LHU"]:
        asm = f"{instr} {rd}, {imm}({rs1})"
    else:
        asm = f"{instr} {rd}, {rs1}, {imm}"
    return word, asm

def rand_s_type(instr):
    rs1 = random.choice(REGS)
    rs2 = random.choice(REGS)
    imm = random.randint(0, 2**12-1)
    imm11_5 = (imm >> 5) & 0x7F
    imm4_0 = imm & 0x1F
    word = (imm11_5<<25) | (reg_index(rs2)<<20) | (reg_index(rs1)<<15) | (FUNCT3[instr]<<12) | (imm4_0<<7) | OPCODES[instr]
    asm = f"{instr} {rs2}, {imm}({rs1})"
    return word, asm

def rand_b_type(instr):
    rs1 = random.choice(REGS)
    rs2 = random.choice(REGS)
    imm = random.randint(0, 2**13-1)
    imm12 = (imm>>12)&0x1
    imm11 = (imm>>11)&0x1
    imm10_5 = (imm>>5)&0x3F
    imm4_1 = (imm>>1)&0xF
    word = (imm12<<31)|(imm11<<7)|(imm10_5<<25)|(reg_index(rs2)<<20)|(reg_index(rs1)<<15)|(FUNCT3[instr]<<12)|(imm4_1<<8)|OPCODES[instr]
    asm = f"{instr} {rs1}, {rs2}, {imm}"
    return word, asm

def rand_u_type(instr):
    rd = random.choice(REGS)
    imm = random.randint(0, 2**20-1)
    word = (imm<<12)|(reg_index(rd)<<7)|OPCODES[instr]
    asm = f"{instr} {rd}, {imm}"
    return word, asm

def rand_j_type(instr):
    rd = random.choice(REGS)
    imm = random.randint(0, 2**21-1)
    imm20 = (imm>>20)&0x1
    imm10_1 = (imm>>1)&0x3FF
    imm11 = (imm>>11)&0x1
    imm19_12 = (imm>>12)&0xFF
    word = (imm20<<31)|(imm19_12<<12)|(imm11<<20)|(imm10_1<<21)|(reg_index(rd)<<7)|OPCODES[instr]
    asm = f"{instr} {rd}, {imm}"
    return word, asm

GENERATOR_MAP = {"R": rand_r_type, "I": rand_i_type, "S": rand_s_type, "B": rand_b_type, "U": rand_u_type, "J": rand_j_type}

# -------------------------
# Generate random instruction
# -------------------------
def generate_random_instruction():
    instr = random.choice(list(INSTR_TYPES.keys()))
    instr_type = INSTR_TYPES[instr]
    return GENERATOR_MAP[instr_type](instr)

# -------------------------
# Main
# -------------------------
def main():
    seed = generate_32bit_seed()
    random.seed(seed)
    print(f"Quantum random seed: {seed}\nGenerating {NUM_INSTRUCTIONS} instructions...\n")

    hex_lines = []
    txt_lines = []

    for _ in range(NUM_INSTRUCTIONS):
        word, asm = generate_random_instruction()
        hex_lines.append(f"{word:08X}\n")
        txt_lines.append(f"{word:032b} {asm}\n")

    with open(HEX_FILE, "w") as f:
        f.writelines(hex_lines)

    with open(TXT_FILE, "w") as f:
        f.writelines(txt_lines)

    print(f"Files written to:\n{HEX_FILE}\n{TXT_FILE}")

if __name__ == "__main__":
    main()
