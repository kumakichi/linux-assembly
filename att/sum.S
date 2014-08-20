    .section .data
topval:
    .int  100
output:
    .asciz "Sum of 1 to %d is %d.\n"

    .section .text
    .globl _start
_start:
    movl  topval, %ecx
    movl  $0, %eax
loop1:
    addl  %ecx, %eax
    loop  loop1

    pushl %eax
    pushl topval
    pushl $output
    call  printf
    add   $12, %esp

    movl  $1, %eax
    movl  $0, %ebx
    int   $0x80
