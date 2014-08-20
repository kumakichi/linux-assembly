    .section .data
value: .int 77

    .section .text
    .globl _start
_start:
    nop

    movl  $1, %eax               #sys_exit
    movl  value, %ebx
    int   $0x80                   #echo $?
