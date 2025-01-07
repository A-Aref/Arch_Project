# 5-Stage Pipelined RISC Processor

## Project Overview

This project involves the design and implementation of a **5-stage pipelined RISC processor** with Harvard architecture. The processor is designed to support a specified ISA, handle exceptions, and address pipeline hazards efficiently. It is implemented in VHDL.

## Features

- **16-bit RISC Architecture** with 8 general-purpose and 3 special-purpose registers.
- Separate 4Kx16 instruction and data memory.
- Supports a comprehensive set of instructions for arithmetic, logic, memory, and control operations.
- Exception handling for empty stack and invalid memory addresses.
- Condition flags for zero, negative, and carry states.
- Pipeline hazard management with data forwarding and branch prediction.


### Design
- **Instruction Set Architecture (ISA)**:
  - Detailed instruction format, opcode assignments, and pipeline stages.
- **Pipeline Design**:
  - 5-stage pipeline with hazard resolution techniques.

### Implementation
- **VHDL Implementation**:
  - Modular design for each component (ALU, registers, memory).
  - Integrated system for pipeline operation.
- **Simulation and Testing**:
  - Assembler to convert assembly to machine code.
  - Waveform generation to validate operations.

## Assisting Components

- **Assembler**:
  - Converts assembly code to memory files for testing.
- **Simulation Files**:
  - Testbench and waveform files.

**Team Members:** 
Each team consists of up to four members. Individual contributions may affect grading.

**Timeline:**
- **Phase 1 Due Date**: Week 10.
- **Final Submission**: Week 13.

---
