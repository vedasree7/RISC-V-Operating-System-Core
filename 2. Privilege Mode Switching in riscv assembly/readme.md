### Privilege Mode Switching and Timer Interrupt Handling

This component implements controlled transitions between RISC-V privilege levels—Machine, Supervisor, and User modes—while handling traps and exceptions using Control and Status Registers (CSRs). It simulates real-world OS privilege management, including trap delegation and returning across modes using `mret` and `sret`.

**Key Features:**

- **Privilege Mode Transitions**  
  Orchestrated transitions from Machine → Supervisor → User modes using proper CSR configuration (`mstatus`, `medeleg`, `mepc`, `sepc`), and executed returns using `mret` and `sret`.

- **Trap Delegation and Propagation**  
  Designed a mechanism where `ecall` from User mode triggers a Supervisor-mode trap, which is conditionally delegated to Machine mode for final handling—demonstrating a layered trap resolution flow.

- **Custom Trap Handlers**  
  Implemented separate trap handlers in Machine and Supervisor modes to inspect cause registers (`mcause`, `scause`) and program counters (`mepc`, `sepc`), allowing controlled redirection of control flow.

- **CSR Logging**  
  Captured and displayed key CSR values at each privilege level, such as:
  - `mepc`, `mcause`, `mtvec`, `mstatus`
  - `sepc`, `scause`, `stvec`

- **Bare-Metal and Proxy Kernel Execution**  
  Supported execution both with and without the Proxy Kernel (`pk`):
  - **With `pk`**: Focused on user-level trap behavior
  - **Without `pk`**: Full control in Machine mode, useful for direct hardware-level debugging

**Execution Flow Summary:**

1. Enter Machine mode → configure and delegate exceptions
2. Switch to Supervisor mode via `mret`
3. Supervisor mode sets up environment → switches to User mode
4. User mode raises an `ecall` → enters Supervisor trap handler
5. Supervisor trap delegates further handling to Machine mode if needed
6. Machine trap resolves, updates `mepc`, and returns to Supervisor
7. Loop continues with repeated privilege transitions

**Sample Build and Run Commands:**

```bash
riscv64-unknown-elf-gcc -nostartfiles -T link.ld privilege_switch.s -o privilege_switch.out
spike -d privilege_switch.out

