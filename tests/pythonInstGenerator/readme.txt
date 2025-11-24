RV32I Quantum Instruction Generator
==================================

Description:
------------
This Code is written using the guidance of ChatGPT 5.
This Python script generates random RV32I instructions using a quantum circuit as a random seed.
It produces two output files:
1. instructions.hex  - 32-bit instruction words in hexadecimal (for testbench memory)
2. instructions.txt  - 32-bit binary instruction + human-readable assembly

Prerequisites:
--------------
1. Python 3 installed
2. Qiskit Aer installed in your environment
   (qiskit-aer>=0.20 recommended)
3. Optional: A virtual environment (venv) to isolate dependencies

Installation / Setup:
--------------------
1. Create a virtual environment:
   $ python3 -m venv genVenv
2. Activate the virtual environment:
   $ source genVenv/bin/activate   (Linux/macOS)
   $ genVenv\Scripts\activate     (Windows)
3. Install Qiskit Aer and Qiskit:
   $ pip install qiskit-aer
   $ pip install qiskit

Running the Script:
------------------
1. Ensure you are in the folder containing `rv32i_quantum_gen.py`
2. Run the script:
   $ python3 rv32i_quantum_gen.py
   (or make it executable and use the shebang)
3. Output files will be saved in the same folder:
   - instructions.hex
   - instructions.txt

Configuration:
--------------
- NUM_INSTRUCTIONS: number of random instructions to generate
- N_QUBITS_SEED: number of qubits used for quantum random seed (max 15 recommended)
- Files are saved next to the script, independent of current working directory.

Notes:
------
- Instructions include all RV32I types (R, I, S, B, U, J) and cover 42 base instructions.
- The quantum seed ensures true randomness if running on a simulator backend.

Author:
-------
Marcelino Samer

