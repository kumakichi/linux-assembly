    section .bss
    BUFFLEN EQU 10
    Buff  resb BUFFLEN

    section .data
    section .text
    EXTERN ClearLine, DumpChar, PrintLine

    GLOBAL _start
_start:
    nop
    nop
    xor   esi,esi

Read:
    mov   eax,3
    mov   ebx,0
    mov   ecx,Buff
    mov   edx,BUFFLEN
    int   80h
    mov   ebp,eax
    cmp   eax,0
    je    Done

    xor   ecx,ecx

Scan:
    xor   eax,eax
    mov   al,byte[Buff+ecx]
    mov   edx,esi
    and   edx,0000000Fh
    call  DumpChar

    inc   ecx
    inc   esi
    cmp   ecx,ebp
    jae   Read

    test  esi,0000000Fh
    jnz   Scan
    call  PrintLine
    call  ClearLine
    jmp   Scan

Done:
    call  PrintLine
    mov   eax,1
    mov   ebx,0
    int   80H
