.section .text
.global main
main:
    li t0,0xFFFFE7FF
    li t1,0
    csrr t1,mstatus
    and t1,t1,t0
    csrw mstatus,t1
    
    csrr t1,mie
    ori t1,t1,0x80
    csrw mie,t1

    li t0,0x2004000
    li t1,10000
    sw t1,0(t0)

    la t0,mtrap
    csrw mtvec,t0

    la t0,user
    csrw mepc,t0
    #set the csrs and initialize mtimecmp
    mret
mtrap:
    li t0,0x2004000
    lw t1,0(t0)
    li t2,10000
    add t1,t1,t2
    sw t1,0(t0)

    la t0,user
    csrw mepc,t0

    mret
#handle the timer interrupt and return to user−space
user:
    li t0,1
    li t1,1
    add t1,t0,t1
    j user
#implement a continuous loop