# 1. AT&T mnemonics and register names are invariably lowercase. (unix is case sensitive)
# 2. Register names are always preceded by the percent symbol, %. (%ax,%ebx)
# 3. Every AT&T machine instruction mnemonic that has operands has a single-character suffix indicating how large its operands are.(b,w,l -> 8bits,16bits,32bits), but:
#     When an instruction does not take operands (call, leave, ret), it does not have an operand-size suffix.
# 4. In the AT&T syntax, source and destination operands are placed in the opposite order from Intel syntax. (mov ax,bx => movw %bx,%ax)
# 5. In the AT&T syntax, immediate operands are always preceded by the dollar sign ($). (push 32 => pushl $32),also:
#     When referenced, the name of a message string is prefixed by a dollar sign ($)
# 6. the comment delimiter in the AT&T scheme is the pound sign (#), rather than the semicolon used in nearly all Intel-style assemblers
# 7. effective address
#    intel => BASE + (INDEX × SCALE) + DISP
#    at&t => ±disp(base,index,scale)
#    mov dword eax,[ebx-4] => movl -4(%ebx),%eax   mov byte eax,[ebx+edi+28] => 28(%ebx,%edi),%eax

# build : as -o att.o att.s && ld -s -o att att.o 

    .section .data
output: .ascii "Hello World.\n"
output_end: .equ len, output_end - output

    .section .text
    .globl _start
_start:
    movl  $4, %eax
    movl  $1, %ebx
    movl  $output, %ecx
    movl  $len, %edx
    int   $0x80
    
    movl  $1, %eax
    movl  $0, %ebx
    int   $0x80
