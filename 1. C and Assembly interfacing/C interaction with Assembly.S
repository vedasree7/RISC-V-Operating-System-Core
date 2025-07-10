.globl reverse_string
.section .data
reverse_string : .space 50

.section .text
.globl reverse

reverse:
    # a0 contains input_string
    addi a1,a0,0 # a1 = a0 
    li a0,0 # a0 contains size of the string
    loop:
        add a2,a1,a0 # a2 = str+i
        lb a3,0(a2)
        beqz a3,end_loop
        addi a0,a0,1 # INCREMENTING a0(size) of string by one
        j loop

    end_loop:
        add a1,a0,a1
        addi a1,a1,-1
        addi t0,a0,0 # t0 = size
        la t3,reverse_string
    for_loop:
        beqz t0,end
        lb t2,0(a1)
        sb t2,0(t3)
        addi t3,t3,1
        addi a1,a1,-1
        addi t0,t0,-1
        j for_loop
    end:
        ret