# RISC-V Systems Programming Project

This repository contains a bare-metal systems programming project on the RISC-V architecture. It focuses on building essential components of an operating system from the ground up using RISC-V assembly and C, with the aim of creating a working prototype that demonstrates core OS mechanisms through direct hardware-level interaction.

Key features of this project include:

- Privilege mode transitions
- Timer-based multitasking
- Virtual memory management using the Sv39 scheme
- Trap handling for instruction and data page faults

---

## Overview

This project explores core systems programming principles by leveraging the RISC-V ISA in a bare-metal environment. It involves working closely with:

- Control and Status Registers (CSRs)
- Memory-mapped I/O
- Privilege specifications and exception handling
- Low-level stack and interrupt handling

Major concepts implemented:

- Mode transitions between Machine, Supervisor, and User modes  
- Timer-driven cooperative multitasking via context switching  
- Virtual memory using Sv39 paging and hierarchical page tables  
- Page fault detection, resolution, and dynamic page mapping  
- Interoperability between RISC-V assembly and C functions

---

## Project Components

### C and Assembly Interfacing
- Enabled seamless function calls between C and RISC-V assembly
- Managed low-level memory access and data sharing between both languages

### Privilege Mode Management
- Handled safe transitions between Machine, Supervisor, and User modes
- Developed basic exception/trap handlers using CSRs

### Timer-Driven Multitasking
- Configured timer interrupts to simulate cooperative multitasking
- Implemented a context switch routine to preserve and restore CPU state

### Sv39-Based Virtual Memory
- Constructed multi-level page tables for virtual address translation using Sv39
- Executed code in User mode mapped to virtual addresses

### Page Fault Handling
- Wrote trap handlers for managing instruction and data page faults
- Dynamically loaded memory pages and updated page tables on-the-fly

---

## Technologies Used

- **RISC-V ISA (RV64)**  
- **RISC-V Assembly** and **C**  
- **Spike** – RISC-V ISA Simulator  
- **GNU Toolchain** – `riscv64-unknown-elf-gcc`, `objdump`  
- **Bare-metal Environment** – No operating system, no runtime dependencies

---

## Setup and Usage

### Prerequisites

Ensure the following tools are installed and available in your system `PATH`:

- RISC-V GCC Toolchain: [`riscv64-unknown-elf-gcc`](https://github.com/riscv-collab/riscv-gnu-toolchain)  
- Spike Simulator: [`spike`](https://github.com/riscv/riscv-isa-sim)  

### Compilation and Execution

```bash
# Compile the source file (e.g., main.S)
riscv64-unknown-elf-gcc -nostartfiles -T linker.ld main.S -o main.out

# Run using the Spike simulator with debugging enabled
spike -d main.out
