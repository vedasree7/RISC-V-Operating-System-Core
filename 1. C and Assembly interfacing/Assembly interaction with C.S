.section .data
.globl course_name

first_name: .asciz "VEDASREE"
last_name: .asciz "KANIKICHARLA"
new_course: .asciz "newcourse"

.section .text
.globl main
.globl getcourse
.globl displayStudentProfile
main:
    la a0,first_name
    la a1,last_name
    la a2,course_name
    jal ra, displayStudentProfile

    la a0,first_name
    la a1,last_name
    la a2,course_name
    la a3,new_course
    sd a3,0(a2)
    ld a2,course_name
    jal ra, displayStudentProfile

    li a7,93
    ecall

    
    
