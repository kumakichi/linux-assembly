    .section .data
value:
    .int  21, 15, 34, 11, 6, 50, 32, 80, 10, 2
output:
    .asciz "output[%d]=%d\n"

    .section .text
    .globl _start
_start:
    movl  $9, %edi

loop:
    pushl value(, %edi, 4)
    pushl %edi
    pushl $output
    call  printf
    addl  $8, %esp

    dec   %edi
    jns   loop

    movl  $1, %eax
    movl  $0, %ebx
    int   $0x80
