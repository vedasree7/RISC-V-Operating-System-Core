
.section .text
.global main



main:
    # Prepare jump to super mode
    li t1, 1
    slli t1, t1, 11   #mpp_mask
    csrs mstatus, t1
    
    la t4, supervisor       #load address of user-space code
    csrrw zero, mepc, t4    #set mepc to user code
    
    la t5, page_fault_handler
    csrw mtvec, t5
   
    mret

supervisor:
################## Set up page tables ##################
    # Set value in PTE2 (Initial Mapping)
    li a0,0x81000000
    li a1, 0x82000
    slli a1, a1, 0xa
    ori a1, a1, 0x01 # | - | - | - |V
    sd a1, 16(a0)

    # To set V.A 0x0 -> P.A 0x0
    li a1, 0x82001
    slli a1, a1, 0xa
    ori a1, a1, 0x01 # | - | - | - |V
    sd a1, 0(a0)

    # Set value in PTE1 (Initial Mapping)
    li a0,0x82000000
    li a1, 0x83000
    slli a1, a1, 0xa
    ori a1, a1, 0x01 # | - | - | - |V
    sd a1, 0(a0)

    # Set Frame number in PTE0 (Initial Mapping)
    li a0,0x83000000
    li a1, 0x80000
    slli a1, a1, 0xa
    ori a1, a1, 0xef # D | A | G | - | X | W | R |V
    sd a1, 0(a0)

    li a1, 0x80001
    slli a1, a1, 0xa
    ori a1, a1, 0xef # D | A | G | - | X | W | R |V
    sd a1, 8(a0)

    # Set value in PTE1 (Code Mapping)
    li a0,0x82001000
    li a1, 0x83001
    slli a1, a1, 0xa
    ori a1, a1, 0x01 # | - | - | - |V
    sd a1, 0(a0)

    # Set value in PTE0 (Code Mapping)
    li a0,0x83001000
    li a1, 0x80001
    slli a1, a1, 0xa
    ori a1, a1, 0xfb # D | A | G | U | X | - | R |V
    sd a1, 0(a0)

    # Data Mapping
    li a1, 0x80002
    slli a1, a1, 0xa
    ori a1, a1, 0xf7 # D | A | G | U | - | W | R |V
    sd a1, 8(a0)
    

####################################################################

    # Prepare jump to user mode
    li t1, 0
    slli t1, t1, 8   #spp_mask
    csrs sstatus, t1

    # Configure satp
    la t1, satp_config 
    ld t2, 0(t1)
    sfence.vma zero, zero
    csrrw zero, satp, t2
    sfence.vma zero, zero

    li t4, 0       # load VA address of user-space code
    csrrw zero, sepc, t4    # set sepc to user code
    
    sret



###################################################################
##################### HANDLE PAGE FAULT ###########################
###################################################################
.align 4
page_fault_handler:
    csrr t0, mtval
    
    srli t0,t0,12
    andi t0,t0,0x1ff

    li a0,0x83001000
    slli t0,t0,3   
    add a0, a0,t0      
    
    csrr a3, mcause
    li t2, 0xc
    bne a3, t2, data_fault_handler
    instruction_fault_handler:
    li t2, 0x400
    li t3, 0x80001000
    li t4, 0x80002


    lw t5, var_count  
    add t4,t4,t5

    mv a1, t4
    slli t4,t4,12

    load_page:
    lw t5, 0(t3)
    sw t5, 0(t4)

    addi t3,t3,4
    addi t4,t4,4

    addi t2,t2,-1
    bnez t2, load_page

    slli a1, a1, 0xa
    ori a1, a1, 0xfb # D | A | G | U | X | - | R |V
    sd a1, 0(a0)

    mret

    data_fault_handler:
    
    li a1, 0x80002
    slli a1, a1, 0xa
    ori a1, a1, 0xf7 # D | A | G | U | - | W | R |V
    sd a1, 0(a0)
    mret

###################################################################
###################################################################

# User Code
.align 12
user_code:
    la t1,var_count
    lw t2, 0(t1)
    addi t2, t2, 1
    sw t2, 0(t1)

    la t5, code_jump_position
    lw t3, 0(t5)
    li t4, 0x2000
    add t3, t3, t4
    sw t3, 0(t5)
    jalr x0, t3


.data
.align 12
var_count:  .word  0
code_jump_position: .word 0x0000


.align 8
# Value to set in satp
satp_config: .dword 0x8000000000081000
