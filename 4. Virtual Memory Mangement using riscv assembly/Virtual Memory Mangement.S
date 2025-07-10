.section .text
.global main


main:
    li t0,0x800
    csrs mstatus,t0
    li t0,0x1000
    csrc mstatus,t0

    la t0,supervisor
    csrw mepc,t0

    mret
    # Jump to supervisor mode


supervisor:

################ Initialize page tables ################
    

    li t0, 0x81000000
    li t1, 0x82001
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0,0x82001000
    li t1, 0x83001
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)


    li t0, 0x81000010
    li t1, 0x82000
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0, 0x82000000
    li t1, 0x83000
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0, 0x83001000 # leaf pte ucode
    li t1,0x80001
    slli t1, t1, 10
    ori t1, t1, 0x7F
    sd  t1, 0(t0)

    li t0, 0x83001000 # leaf pte data
    li t1,0x80002
    slli t1, t1, 10
    ori t1, t1, 0x7F
    # nop
    sd  t1, 8(t0)
    # nop

    li t0, 0x82000000
    li t1,0x80000
    slli t1,t1, 10
    ori t1,t1,0x6F
    sd t1,0(t0)

####################################################################


    li t0,0xFFFFFEFF
    csrr t1,sstatus
    and t1,t0,t1
    csrw sstatus,t1

    # Prepare jump to user mode






####################################################################
    la t1, satp_config # load satp val
    ld t2, 0(t1)
    sfence.vma zero, zero
    csrrw zero, satp, t2
    sfence.vma zero, zero

    li t4, 0
    csrrw zero, sepc, t4 
    sret
####################################################################


.align 12
user_code:
    la t1,var1
    la t2,var2
    la t3,var3
    la t4,var4
    j user_code


.data
.align 12
var1:  .word  1
var2:  .word  2
var3:  .word  3
var4:  .word  4

.align 12
satp_config: .dword  0x8000000000081000 # Value to set in satp