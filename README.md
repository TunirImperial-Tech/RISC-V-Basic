# RISC-V Basic CPU

A basic RISC-V CPU implemented in SystemVerilog from scratch as a hardware design project.

## Project Overview

This project implements the core components of a simple RISC-V processor using SystemVerilog. The aim is to understand how a CPU executes instructions at the hardware level, from instruction decoding through to arithmetic and logical operations.

The project is being developed incrementally, starting with the ALU and expanding towards a complete basic CPU.

## Current Progress

- [x] ALU
- [x] ALU testbench
- [ ] Register file
- [ ] Control unit
- [ ] Instruction memory
- [ ] Program counter
- [ ] CPU datapath
- [ ] CPU integration
- [ ] Full CPU testbench

## ALU

The Arithmetic Logic Unit currently supports:

| Operation | Description |
|---|---|
| ADD | 32-bit addition |
| SUB | 32-bit subtraction |
| AND | Bitwise AND |

The ALU accepts two 32-bit inputs and an ALU control signal, and produces a 32-bit result.

## Project Structure

```text
RISC-V-Basic/
├── src/
│   └── alu.sv
├── tb/
│   └── alu_tb.sv
├── test_results/
└── README.md