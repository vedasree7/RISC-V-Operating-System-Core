### Virtual Memory Management with Sv39 Paging in RISC-V

This component demonstrates the creation and configuration of virtual memory using the Sv39 paging scheme on the RISC-V architecture. The project walks through the process of setting up hierarchical page tables, enabling virtual address translation, and verifying the mapping from virtual to physical memory in a bare-metal environment.

**Objective:**  
Understand and implement virtual memory management by configuring SATP and Sv39-based page tables, and observe address translation effects while transitioning across privilege levels.

---

#### Key Implementation Steps

1. **Machine to Supervisor Mode Transition**  
   - Configure Control and Status Registers (CSRs) to safely switch execution from Machine mode to Supervisor mode.

2. **Page Table Initialization (Sv39)**  
   - Allocate and initialize multi-level Sv39 page tables.
   - Populate Page Table Entries (PTEs) at appropriate memory locations with valid physical frame numbers, access bits, and permission flags.
   - Ensure proper alignment and memory layout as per the Sv39 specification.

3. **SATP Configuration**  
   - Construct the SATP value by encoding:
     - Mode: Sv39 (`mode = 8`)
     - ASID: Address Space Identifier (typically 0 for basic setup)
     - PPN: Physical Page Number of the root page table
   - Write the final SATP value to the `satp` register to enable virtual memory translation.

4. **Supervisor to User Mode Transition**  
   - Safely transfer control to user mode using `sret`, ensuring the page tables are active and address translation is functional.


---

#### Compilation & Execution Example


![image](https://github.com/user-attachments/assets/088f121e-fc4c-4d2b-a35e-1486f5d5b5e6)

![image](https://github.com/user-attachments/assets/e8f7a50c-63c4-47af-b0f0-6036bb8f51e6)
```bash
riscv64-unknown-elf-gcc -nostartfiles -T link.ld vm_paging.s -o vm_paging.out
spike -d vm_paging.out



