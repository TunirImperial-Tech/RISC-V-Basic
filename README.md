# RISC-V Basic CPU

A simple **32-bit RISC-V CPU implemented from scratch in SystemVerilog**.

This project was built to understand how a processor works at the hardware level, from instruction decoding and register operations through to program execution. The CPU is simulated using **Icarus Verilog** and can execute programs supplied as hexadecimal machine-code files.

## Overview

The processor implements a subset of the **RISC-V RV32I instruction set**, including arithmetic, logical, comparison, control-flow, memory, and immediate instructions.

The CPU follows a simple single-cycle-style datapath:

```text
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Memory          │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Decoder         │
                    └────────┬────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
       ┌──────────────┐              ┌──────────────┐
       │ Register     │              │ Immediate    │
       │ File         │              │ Generator    │
       └──────┬───────┘              └──────┬───────┘
              │                             │
              └──────────────┬──────────────┘
                             ▼
                       ┌───────────┐
                       │   ALU     │
                       └─────┬─────┘
                             │
                             ▼
                       ┌───────────┐
                       │ Register  │
                       │   File    │
                       └───────────┘
```

The program counter controls instruction execution, while the control unit determines how each instruction should move through the datapath.

---

## Features

* 32-bit RISC-V architecture
* 32 general-purpose registers (`x0`–`x31`)
* `x0` hardwired to zero
* 32-bit program counter
* Instruction memory
* Register file with synchronous writes
* Combinational ALU
* Immediate generator
* Instruction decoder/control unit
* Conditional branches
* Unconditional jumps
* Memory load/store instructions
* Machine-code programs loaded using `$readmemh`
* Custom Python assembler translating `.asm` source into `prog.hex`
* SystemVerilog implementation
* Simulation using Icarus Verilog
* Output verification through a CPU testbench

---

## Instruction Set

The following instructions are currently implemented and tested.

### Arithmetic and Logical Instructions

| Instruction | Syntax             | Description                                                                        |
| ----------- | ------------------ | ----------------------------------------------------------------------------------- |
| `ADD`       | `ADD rd, rs1, rs2` | Adds `rs1` and `rs2` and stores the result in `rd`.                                |
| `SUB`       | `SUB rd, rs1, rs2` | Subtracts `rs2` from `rs1` and stores the result in `rd`.                          |
| `AND`       | `AND rd, rs1, rs2` | Performs a bitwise AND between `rs1` and `rs2`.                                    |
| `OR`        | `OR rd, rs1, rs2`  | Performs a bitwise OR between `rs1` and `rs2`.                                     |
| `XOR`       | `XOR rd, rs1, rs2` | Performs a bitwise XOR between `rs1` and `rs2`.                                    |
| `SLT`       | `SLT rd, rs1, rs2` | Sets `rd` to `1` if `rs1 < rs2` using signed comparison; otherwise sets it to `0`. |

### Immediate Instructions

| Instruction | Syntax              | Description                                                                        |
| ----------- | ------------------- | ----------------------------------------------------------------------------------- |
| `ADDI`      | `ADDI rd, rs1, imm` | Adds a sign-extended immediate value to `rs1`.                                     |
| `ANDI`      | `ANDI rd, rs1, imm` | Performs a bitwise AND between `rs1` and an immediate value.                       |
| `ORI`       | `ORI rd, rs1, imm`  | Performs a bitwise OR between `rs1` and an immediate value.                        |
| `XORI`      | `XORI rd, rs1, imm` | Performs a bitwise XOR between `rs1` and an immediate value.                       |
| `SLTI`      | `SLTI rd, rs1, imm` | Sets `rd` to `1` if `rs1` is less than the sign-extended immediate; otherwise `0`. |

### Load and Store Instructions

| Instruction | Syntax                | Description                                                              |
| ----------- | --------------------- | -------------------------------------------------------------------------- |
| `LW`        | `LW rd, rs1, offset`  | Loads a 32-bit word from memory at address `rs1 + offset` into `rd`.      |
| `SW`        | `SW rs1, rs2, offset` | Stores the value in `rs2` to memory at address `rs1 + offset`.            |

### Upper Immediate Instructions

| Instruction | Syntax          | Description                                                                                  |
| ----------- | --------------- | ---------------------------------------------------------------------------------------------- |
| `LUI`       | `LUI rd, imm`   | Loads a 20-bit immediate into the upper 20 bits of `rd`, with the lower 12 bits set to zero. |
| `AUIPC`     | `AUIPC rd, imm` | Adds the upper-immediate value to the current program counter and stores the result in `rd`. |

### Conditional Branches

| Instruction | Syntax                 | Description                                                                  |
| ----------- | ---------------------- | ----------------------------------------------------------------------------- |
| `BEQ`       | `BEQ rs1, rs2, offset` | Branches if `rs1` equals `rs2`.                                              |
| `BNE`       | `BNE rs1, rs2, offset` | Branches if `rs1` does not equal `rs2`.                                      |
| `BLT`       | `BLT rs1, rs2, offset` | Branches if `rs1` is less than `rs2` using signed comparison.                |
| `BGE`       | `BGE rs1, rs2, offset` | Branches if `rs1` is greater than or equal to `rs2` using signed comparison. |

### Jump Instructions

| Instruction | Syntax              | Description                                                                   |
| ----------- | ------------------- | ------------------------------------------------------------------------------ |
| `JAL`       | `JAL rd, offset`    | Stores the return address (`PC + 4`) in `rd` and jumps to the target address. |
| `JALR`      | `JALR rd, rs1, imm` | Stores `PC + 4` in `rd` and jumps to an address calculated from `rs1 + imm`.  |

> **Note:** The project currently contains 21 confirmed implemented instructions across R, I, S, B, U, and J formats, all of which are documented above.

---

## Instruction Formats

The CPU uses the standard RISC-V instruction formats.

### R-Type

Used for register-to-register operations such as `ADD`, `SUB`, `AND`, `OR`, `XOR`, and `SLT`.

```text
31        25 24    20 19    15 14  12 11     7 6       0
+-----------+--------+--------+------+---------+---------+
|  funct7   |  rs2   |  rs1   |funct3|   rd    | opcode  |
+-----------+--------+--------+------+---------+---------+
```

Example:

```text
ADD x3, x1, x2
```

---

### I-Type

Used for immediate operations, loads, and `JALR`.

```text
31                  20 19    15 14  12 11     7 6       0
+---------------------+--------+------+---------+---------+
|      immediate      |  rs1   |funct3|   rd    | opcode  |
+---------------------+--------+------+---------+---------+
```

Example:

```text
ADDI x1, x0, 5
```

---

### S-Type

Used by the store instruction `SW`.

```text
31        25 24    20 19    15 14  12 11     7 6       0
+-----------+--------+--------+------+---------+---------+
| imm[11:5] |  rs2   |  rs1   |funct3| imm[4:0]| opcode  |
+-----------+--------+--------+------+---------+---------+
```

The immediate is split across the `funct7` and `rd` bit positions used by R-type, since S-type instructions have no destination register. `rs1` supplies the base address and `rs2` supplies the value being stored; the two immediate halves are recombined and sign-extended to form the store offset.

Example:

```text
SW x2, x5, 8
```

---

### U-Type

Used by `LUI` and `AUIPC`.

```text
31                         12 11     7 6       0
+----------------------------+---------+---------+
|         immediate          |   rd    | opcode  |
+----------------------------+---------+---------+
```

---

### B-Type

Used by conditional branches.

```text
31   30        25 24    20 19    15 14  12 11       8 7 6       0
+----+-----------+--------+--------+------+----------+-+---------+
|imm |   imm     |  rs2   |  rs1   |funct3|   imm    | | opcode  |
+----+-----------+--------+--------+------+----------+-+---------+
```

The branch immediate is reconstructed from several instruction fields and is sign extended before being added to the PC.

---

### J-Type

Used by `JAL`.

```text
31 30                   21 20 19                    12 11     7 6      0
+--+----------------------+--+------------------------+---------+--------+
|  |       immediate      |  |       immediate        |   rd    | opcode |
+--+----------------------+--+------------------------+---------+--------+
```

---

## Main Components

### ALU

The Arithmetic Logic Unit performs the arithmetic, logical, and comparison operations required by the processor.

Examples include:

```text
ADD
SUB
AND
OR
XOR
SLT
```

The operation performed by the ALU is selected using an `alu_control` signal generated by the control unit.

---

### Register File

The register file contains 32 × 32-bit registers:

```text
x0 - x31
```

Register `x0` is permanently zero, as required by the RISC-V architecture.

The register file provides two read ports and one write port, allowing instructions such as:

```text
ADD x3, x1, x2
```

to simultaneously read `x1` and `x2` and write the result to `x3`.

---

### Immediate Generator

Different RISC-V instruction formats store immediate values in different positions.

The immediate generator extracts and sign-extends these values so that they can be used by the datapath.

It supports the immediate formats required by the implemented instructions:

```text
I-type
S-type
B-type
U-type
J-type
```

---

### Control Unit

The control unit decodes the instruction opcode and function fields.

It generates control signals including:

```text
ALU control
Register write
ALU source
Memory read
Memory write
Branch
Jump
```

For R-type instructions, the decoder uses both `funct3` and `funct7` to distinguish instructions such as:

```text
ADD
SUB
```

---

### Instruction Memory

Instructions are stored in a 32-bit memory array and loaded from:

```text
sim/prog.hex
```

The program counter is a byte address, so the instruction-memory index is calculated using:

```systemverilog
address >> 2
```

Therefore:

```text
PC = 0   → instruction 0
PC = 4   → instruction 1
PC = 8   → instruction 2
PC = 12  → instruction 3
```

Unused instruction-memory locations are initialized with the RISC-V NOP encoding:

```text
00000013
```

---

## Assembler

A custom Python assembler (`assembler.py`) translates `.asm` source files into `prog.hex` for use with `$readmemh`.

### Syntax

* **Comments**: everything after `//` on a line is ignored.
* **Labels**: written as `name:`, either on their own line or inline before an instruction (e.g. `loop: ADDI x1, x1, 1`).
* **Registers**: `x0`–`x31`.
* **Immediates**: decimal (`10`, `-3`) or hexadecimal (`0x1F`).
* **Load/Store operand order**: `LW rd, rs1, offset` and `SW rs1, rs2, offset` — no parentheses syntax.

Example program:

```text
loop:
    ADDI x1, x1, 1
    ADDI x2, x0, 10
    BNE x1, x2, loop
    JAL x0, end
end:
    ADD x0, x0, x0
```

### Running the Assembler

```bash
python assembler.py <input.asm> <output.hex>
```

For example, to assemble a program and place the output where the CPU testbench expects it:

```bash
python assembler.py programs/loop.asm sim/prog.hex
```

The resulting `prog.hex` can then be loaded directly by the CPU's instruction memory via `$readmemh`, and the simulation run as usual with Icarus Verilog.

---

# CPU Verification Test Suite

7 hand-written RV32I test programs, each targeting a specific instruction
group, run end-to-end on the CPU (assembler -> prog.hex -> Icarus Verilog
simulation -> register dump) and checked against manually pre-computed
expected register values.

| Program | Instructions covered | Registers checked | Result |
|---|---|---|---|
| t1_arith.asm | ADD, SUB, AND, OR, XOR, SLT | 8 | PASS |
| t2_imm.asm | ADDI, ANDI, ORI, XORI, SLTI | 6 | PASS |
| t3_loadstore.asm | SW, LW | 3 | PASS |
| t4_upperimm.asm | AUIPC, LUI | 2 | PASS |
| t5_branch.asm | BEQ, BNE | 6 | PASS |
| t6_jump.asm | JAL, JALR | 5 | PASS |
| t7_branch2.asm | BLT, BGE | 6 | PASS |

**Result: 7/7 programs pass, 36/36 register-level assertions correct —
covers all 22 implemented instructions.**

Combined with the existing self-checking `control_unit_tb.sv`
(6/6 assertions passing), that's **42/42 checks passing** across the
project.

Run with: `python3 run_tests.py` from a directory containing this repo
---

## Design Approach

The CPU was developed from the bottom up:

```text
1. ALU
      ↓
2. Register File
      ↓
3. Immediate Generator
      ↓
4. Control Unit
      ↓
5. Instruction Memory
      ↓
6. Program Counter
      ↓
7. CPU Datapath
      ↓
8. Full CPU Integration
      ↓
9. Program Execution & Verification
      ↓
10. Assembler Development
```

This approach made it possible to test each hardware block independently before connecting the complete datapath.

---

## Technologies

* **SystemVerilog**
* **RISC-V ISA**
* **Icarus Verilog**
* **GTKWave**
* **Python**
* **VS Code**
* **Git/GitHub**

## Project Goal

The primary goal of this project is to develop a practical understanding of **CPU architecture and digital hardware design** by implementing a RISC-V processor from the ground up.

Rather than treating a CPU as a black box, the project demonstrates how individual hardware components such as the ALU, register file, instruction decoder, immediate generator, program counter, and instruction memory interact to execute machine instructions — and how a custom assembler bridges human-readable assembly to the machine code the CPU actually runs.