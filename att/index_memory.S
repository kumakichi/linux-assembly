# build: as -o index_memory.o index_memory.S && ld -o index_memory index_memory.o -I /lib/ld-linux.so.2 -lc

    .section .data
output:
    .asciz "values[%d] = %d\n"
values:
    .int  10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60

    .section .text
    .globl _start
_start:
    nop
    xor   %edi, %edi

loop:
    movl  values(, %edi, 4), %eax

    pushl %eax
    pushl %edi
    pushl $output
    call  printf
    addl  $12, %esp

    inc   %edi
    cmpl  $11, %edi                 # size of array values is 11
    jne   loop

    movl  $0, %ebx
    movl  $1, %eax
    int   $0x80
