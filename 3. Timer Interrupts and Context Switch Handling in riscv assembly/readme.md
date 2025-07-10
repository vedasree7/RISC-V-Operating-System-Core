### Privilege Mode Switching and Trap Delegation in RISC-V

This component implements a full privilege mode cycle (Machine → Supervisor → User → Supervisor → Machine...) in RISC-V using assembly, with custom trap handling logic and proper CSR configuration. It serves as a foundational module to understand privilege separation, control transfer, and interrupt delegation in RISC-V architecture.

**Highlights:**

- **Multi-Level Privilege Mode Transitions**  
  Programmatically transitions from Machine mode to Supervisor, then to User mode, and loops indefinitely using `mret` and `sret`.

- **Custom Trap Handlers for `ecall` Exceptions**  
  - In **User Mode**, an `ecall` instruction traps to Supervisor mode.
  - Supervisor’s trap handler logs CSR values, then triggers another `ecall` that is delegated to Machine mode.
  - Machine's trap handler logs CSR values and returns execution to the Supervisor handler, which resumes User mode execution.

- **CSR Manipulation and Trap Delegation**  
  Configures critical CSRs such as:
  - `mepc`, `sepc` – program counters at each privilege level
  - `mcause`, `scause` – to detect the cause of traps
  - `mtvec`, `stvec` – base addresses for trap vectors
  - `mstatus`, `medeleg` – to control mode transitions and delegate exceptions

- **Looping Execution Model**  
  The program loops indefinitely, repeatedly executing in User mode, raising traps via `ecall`, and cycling through the Supervisor and Machine handlers.

**Execution Flow:**

1. **Start in Machine Mode**  
   → Configure `medeleg`, `mepc`, `mtvec`, and transfer control to Supervisor using `mret`

2. **In Supervisor Mode**  
   → Set `stvec`, `sepc`, and switch to User using `sret`

3. **In User Mode**  
   → Perform operations and trigger `ecall`

4. **Supervisor Trap Handler**  
   → Log `scause`, `sepc`; issue `ecall` to trap to Machine

5. **Machine Trap Handler**  
   → Log `mcause`, `mepc`; return to updated `mepc`, continue Supervisor handler

6. **Resume User Mode**  
   → Loop continues

**System Requirements:**

- **Bare-metal execution only** (no operating system)
- Testable both **with Proxy Kernel (`pk`)** (User mode only) and **without `pk`** (full Machine mode support)

**Compilation & Execution:**

![context_switching](https://github.com/user-attachments/assets/5005b0bb-36d8-4010-8adb-6d942b95298c)
```bash
riscv64-unknown-elf-gcc -nostartfiles -T link.ld privilege_cycle.s -o privilege_cycle.out
spike -d privilege_cycle.out

