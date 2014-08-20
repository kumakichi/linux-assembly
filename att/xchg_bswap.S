    .section .data
a:
    .int  0x12345678
b:
    .int  0x9abcdef1
outstr:
    .asciz "%0x\n"

    .section .text
    .global _start
_start:
    nop

    movl  a,%eax
    xchg  %eax,b                    # Exchanges the values of two registers, or a register and a memory location

    bswap %eax                      # Reverses the byte order in a 32-bit register

    pushl %eax
    pushl $outstr
    call  printf
    addl  $8,%esp

    movl  $1,%eax
    movl  $0,%ebx
    int   $0x80

### XADD       Exchanges two values and stores the sum in the destination operand
### CMPXCHG    Compares a value with an external value and exchanges it with another
### CMPXCHG8B  Compares two 64-bit values and exchanges it with another
