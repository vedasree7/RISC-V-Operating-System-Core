.section .text
.global main
.align 4
main:
    # Enable interrupts
    # configure timer interrupt 
    li t0,0xFFFFE7FF
    li t1,0
    csrr t1,mstatus
    and t1,t1,t0
    csrw mstatus,t1
    
    csrr t1,mie
    ori t1,t1,0x80
    csrw mie,t1

    li t0,0x2004000
    li t1,100
    sw t1,0(t0)

    li s0,0x0fffffff
    li s1,0x03ffffff

    la t0,initial_switch_to_B
    csrw mtvec,t0

    la t0,Task_A
    csrw mepc,t0

    li t3,1
    mret
.align 4
context_switch:
		# save the context of the interrupted task by looking at the task id (jump to relavent label)
        la t0,current
        lwu t0,0(t0)
        li t1,0
        beq t0,t1,switch_to_B
        li t1,1
        beq t0,t1,switch_to_A
.align 4

save_context_A:
		# save all the registers and PC value in stack_a
		# mepc stores the value of PC at the time of interrupt
        la t0,stack_a
        lwu t0,0(t0)
        mv sp,t0
        addi sp,sp,-8
        sw t3,0(sp)
        csrr t1,mepc
        sw t1,4(sp)
        ret
.align 4
save_context_B:
		# save all the registers and PC value in stack_b
        la t0,stack_b
        lwu t0,0(t0)
        mv sp,t0
        addi sp,sp,-8
        sw t3,0(sp)
        csrr t1,mepc
        sw t1,4(sp)
        ret
.align 4
switch_to_A:
        jal save_context_B

        la t0,stack_a
        lwu t0,0(t0)
        mv sp,t0
        addi sp,sp,-8
        lwu t3,0(sp)
        lwu t1,4(sp)
        csrw mepc,t1
        
        la t0,current
        li t1,0
        sw t1,0(t0)

        j switch
		# restore the values of registers and PC from stack_a
.align 4
switch_to_B:
        jal save_context_A

        la t0,stack_b
        lwu t0,0(t0)
        mv sp,t0
        addi sp,sp,-8
        lwu t3,0(sp)
        lwu t1,4(sp)
        csrw mepc,t1

        la t0,current
        li t1,1
        sw t1,0(t0)
        j switch
		# restore the values of registers and PC from stack_b
.align 4
initial_switch_to_B:
        jal save_context_A

        li t3,0x03ffffff
        la t0,current
        li t1,1 # 1 for current task is B , 0 for A
        sw t1,0(t0)

        la t0,Task_B
        csrw mepc,t0

        la t0,context_switch
        csrw mtvec,t0
		# switching to Task B for the first time
.align 4
switch:
	# set the value of mtimecmp 80000120and switch to your preferred task
    li t0,0x2004000
    lwu t1,0(t0)
    li t2,100
    add t1,t1,t2
    sw t1,0(t0)

    mret
.align 4
Task_A:
	# increment your reg value
    addi t3,t3,1
    bne t3,s0,Task_A
.align 4
finish_a:
    j finish_a
.align 4
Task_B:
	# decrement the reg value
    addi t3,t3,-1
    bne t3,s1,Task_B
.align 4
finish_b:
    j finish_b
.align 4
.data
.align 4
stack_a:  .word  0xF0008200 # initialize stack for task A (You can choose a random address) 
stack_b:  .word  0xF0008700 # initialize stack for task B
current:  .word  0x0 # variable to identify the task 