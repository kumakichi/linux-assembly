    .section .text
    .globl _start
_start:
    nop
    movl  $0x12345678,%ebx
    movl  $-69, %ecx
    movsx %cl, %ebx                 # This instruction moves a smaller-sized unsigned integer value (in either a register or a memory location) to a larger-sized unsigned integer value (only in a register).
    movl  $1, %eax
    int   $0x80

# movzx -> Zero eXtend (unsigned)
# movsx -> Signed eXtend
