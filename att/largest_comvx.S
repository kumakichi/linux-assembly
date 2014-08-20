### build: as -o largest.o largest.S && ld -o largest largest.o -I /lib/ld-linux.so.2 -lc
    .section .data
output:
    .asciz "The largest value is %d\n"
values:
    .int  105, 235, 61, 315, 134, 221, 53, 145, 117, 5

    .section .text
    .globl _start
_start:
    nop

    movl  $values,%esi              # esi is addr of 'values'
    movl  values, %ebx              # ebx = values[0]
    movl  $1, %edi                  # edi is index of 'values'

loop:
    movl  (%esi,%edi,4),%eax        # eax is tmp val
    cmp   %ebx, %eax                # eax - ebx, remember, this is AT&T, not Intel
    cmova %eax, %ebx                # 'a' means cf/zf == 0,i.e., eax > ebx

    inc   %edi
    cmp   $10, %edi                 # size of 'values' is 10
    jne   loop

    pushl %ebx
    pushl $output
    call  printf
    addl  $8, %esp

    movl  $1,%eax                   # sys_exit
    movl  $0,%ebx
    int   $0x80

### Instruction Pair      Description             EFLAGS Condition
###
### CMOVA/CMOVNBE     Above/not below or equal     (CF or ZF) = 0
### CMOVAE/CMOVNB     Above or equal/not below     CF=0
### CMOVNC            Not carry                    CF=0
### CMOVB/CMOVNAE     Below/not above or equal     CF=1
### CMOVC             Carry                        CF=1
### CMOVBE/CMOVNA     Below or equal/not above     (CF or ZF) = 1
### CMOVE/CMOVZ       Equal/zero                   ZF=1
### CMOVNE/CMOVNZ     Not equal/not zero           ZF=0
### CMOVP/CMOVPE      Parity/parity even           PF=1
### CMOVNP/CMOVPO     Not parity/parity odd        PF=0
### CMOVGE/CMOVNL     Greater or equal/not less    (SF xor OF)=0
### CMOVL/CMOVNGE     Less/not greater or equal    (SF xor OF)=1
### CMOVLE/CMOVNG     Less or equal/not greater    ((SF xor OF) or ZF)=1
### CMOVO             Overflow                     OF=1
### CMOVNO            Not overflow                 OF=0
### CMOVS             Sign (negative)              SF=1
### CMOVNS            Not sign (non-negative)      SF=0
