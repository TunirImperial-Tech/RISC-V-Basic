# RISC-V Basic CPU

A basic RISC-V CPU implemented in SystemVerilog from scratch as a hardware design project.

## Project Overview

This project implements the core components of a simple RISC-V processor using SystemVerilog. The aim is to understand how a CPU executes instructions at the hardware level, from instruction decoding through to arithmetic and logical operations.

The project is being developed incrementally, starting with the ALU and expanding towards a complete basic CPU.

## Current Progress

* [x] ALU
* [x] ALU testbench
* [ ] Register file
* [ ] Control unit
* [ ] Instruction memory
* [ ] Program counter
* [ ] CPU datapath
* [ ] CPU integration
* [ ] Full CPU testbench

## ALU

The Arithmetic Logic Unit currently supports:

| Operation | Description        |
| --------- | ------------------ |
| ADD       | 32-bit addition    |
| SUB       | 32-bit subtraction |
| AND       | Bitwise AND        |

The ALU accepts two 32-bit inputs and an ALU control signal, and produces a 32-bit result.

## RISC-V Instruction Decoding

For R-type RISC-V instructions, the `opcode`, `funct3`, and `funct7` fields are used by the decoder to determine which ALU operation should be performed.

The relevant fields are:

| Instruction | funct7    | funct3 |
| ----------- | --------- | ------ |
| ADD         | `0000000` | `000`  |
| SUB         | `0100000` | `000`  |
| XOR         | `0000000` | `100`  |
| OR          | `0000000` | `110`  |
| AND         | `0000000` | `111`  |

`funct3` is a 3-bit field located at bits `[14:12]` of the 32-bit instruction. `funct7` is a 7-bit field located at bits `[31:25]`.

For example, ADD and SUB both have `funct3 = 000`, so the decoder uses `funct7` to distinguish between them. AND, OR, and XOR have different `funct3` values, allowing the decoder to identify the operation directly.

The decoder then converts these instruction fields into an ALU control signal, which tells the ALU which operation to perform.

## Project Structure

```text
RISC-V-Basic/ 
├── src/ 
│   └── alu.sv 
├── tb/ 
│   └── alu_tb.sv 
├── test_results/ 
└── README.md 
```
