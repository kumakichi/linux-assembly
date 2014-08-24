    .section .text
    .type asm_square, @function
    .global asm_square
asm_square:
    pushl %ebp
    movl  %esp,%ebp

    movl  8(%ebp),%eax
    imull %eax,%eax

    movl  %ebp,%esp
    popl  %ebp
    ret
