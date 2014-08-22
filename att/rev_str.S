    .section .data
value1:
    .asciz "This is a test string.\n"
value1_end:
    .equ  str_len, value1_end - value1

    .section .bss
    .lcomm output, 24

    .section .text
    .globl _start
_start:
    nop
    leal  value1+22, %esi
    leal  output+22, %edi

    movl  $22, %ecx
    std
    rep   movsb

    cld
    movl  $4,%eax
    movl  $1,%ebx
    movl  $value1,%ecx
    movl  $str_len,%edx
    int   $0x80

    movl  $1, %eax
    movl  $0, %ebx
    int   $0x80
