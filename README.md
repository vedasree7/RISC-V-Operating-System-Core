# RISC-V Systems Programming Project

This repository showcases a bare-metal systems programming project targeting the RISC-V architecture. It involves implementing foundational components of an operating system from scratch using RISC-V assembly and C. The goal of the project is to build a working prototype of core OS mechanisms, emphasizing direct interaction with hardware-level features and the RISC-V privilege architecture.

Key features include privilege mode transitions, timer-based multitasking, Sv39-based virtual memory management, and trap handling for instruction/data page faults.

---

## Table of Contents

- [Overview](#overview)  
- [Project Components](#project-components)  
- [Technologies Used](#technologies-used)  
- [Setup and Usage](#setup-and-usage)

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
