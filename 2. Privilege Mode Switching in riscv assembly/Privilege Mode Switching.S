.section .text
.global main
main:
    #modify necessary csrs : mstatus , mepc , mtvec , medeleg
    csrr t0,mstatus
    li t1,1
    slli t1,t1,12
    not t1,t1
    and t0,t0,t1
    li t1,1
    slli t1,t1,11
    or t0,t0,t1
    csrw mstatus,t0 # modified mstatus
    
    la t0,mtraphandler
    csrw mtvec,t0  # modified mtvec
    
    la t0,scode
    csrw mepc,t0 # modified mepc

    csrr t0,medeleg
    li t1,1
    slli t1,t1,8
    or t0,t0,t1 
    csrw medeleg,t0 # modified medelog
    
    mret

mtraphandler:
    #read registers like mepc , mcause
    csrr t0,mepc
    csrr t1,mcause
    csrr t2,mtvec
    csrr t3,mstatus
    #update the value of mepc
    addi t0,t0,4
    csrw mepc,t0
    #return
    mret
scode:
    #modify necessart csrs : sepc,stvec
    csrr t0,sstatus
    li t1,1
    slli t1,t1,8
    not t1,t1
    csrw sstatus,t0 # status set

    la t0,ucode
    csrw sepc,t0 # sepc set

    # ensure control returns to usercode
    la t0,straphandler
    csrw stvec,t0

    sret
straphandler:
    # read registers like sepc,scause
    csrr t0,sepc
    csrr t1,scause
    csrr t2,stvec
    csrr t3,sstatus
    #update the value of sepc
    addi t0,t0,4
    csrw sepc,t0
    ecall
    #return
    sret 
ucode:
    #do some user space operations
    ecall
    j ucode