    section .bss
    BUFFLEN equ 10
    Buff  resb BUFFLEN

    section .data

    DumpLin db "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 "
    DUMPLEN EQU $-DumpLin

    ASCLin db "|................|",10
    ASCLEN EQU $-ASCLin
    FULLLEN EQU $-DumpLin

    HexDigits db "0123456789ABCDEF"

DotXlat:
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    20h,21h,22h,23h,24h,25h,26h,27h,28h,29h,2Ah,2Bh,2Ch,2Dh,2Eh,2Fh
    db    30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,3Ah,3Bh,3Ch,3Dh,3Eh,3Fh
    db    40h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh
    db    50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah,5Bh,5Ch,5Dh,5Eh,5Fh
    db    60h,61h,62h,63h,64h,65h,66h,67h,68h,69h,6Ah,6Bh,6Ch,6Dh,6Eh,6Fh
    db    70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
    db    2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh

    section .text

ClearLine:                          ; make ascii part all be '.'
    pushad
    mov   edx,0FH
    mov   eax,0

.loop_clear:
    call  DumpChar
    sub   edx,1
    jge   .loop_clear
    popad
    ret

DumpChar:                           ; input: edx-> count number , eax -> charactor to be processed
    push  ebx
    push  edi

    mov   bl,byte [DotXlat+eax]     ; ascii part process
    mov   byte [ASCLin+edx+1],bl

    mov   ebx,eax                   ; backup, because we will process both the lower 4 bits and the higher 4 bits
    lea   edi,[edx+edx*2]

    and   eax,0Fh                   ; the lower 4 bits
    mov   al,byte [HexDigits+eax]
    mov   byte [DumpLin+edi+1],al

    and   ebx,0F0h                  ; the higher 4 bits
    shr   ebx,4
    mov   bl,byte [HexDigits+ebx]
    mov   byte [DumpLin+edi],bl

    pop   edi
    pop   ebx
    ret                             ;return to the caller

PrintLine:
    pushad
    mov   eax,4
    mov   ebx,1
    mov   ecx,DumpLin
    mov   edx,FULLLEN
    int   80h
    popad
    ret

LoadBuff:
    push  eax
    push  ebx
    push  edx

    mov   eax,3                     ; sys_read
    mov   ebx,0
    mov   ecx,Buff
    mov   edx,BUFFLEN
    int   80h

    mov   ebp,eax                   ; ebp = read_length
    xor   ecx,ecx
    pop   edx
    pop   ebx
    pop   eax
    ret

    global _start
_start:
    nop
    xor   esi,esi                   ; esi -> total byte counter
    call  LoadBuff
    cmp   ebp,0                     ; eof
    jbe   Exit

Scan:
    xor   eax,eax
    mov   al,byte[Buff+ecx]         ; Get a byte from the buffer into AL

    mov   edx,esi                   ; Copy total counter into EDX
    and   edx,0Fh                   ; edx %= 16
    call  DumpChar

    inc   esi
    inc   ecx
    cmp   ecx,ebp
    jb    .modTest                  ; ecx < read_length

    call  LoadBuff                  ; readlength is less than 16 bytes, then read again
    cmp   ebp,0                     ; If ebp=0, sys_read reached EOF on stdin
    jbe   Done                      ; If we got EOF, we’re done
    jmp   Scan

.modTest:
    test  esi,0Fh                   ; check if another 16 bytes is ok now
    jnz   Scan
    call  PrintLine                 ; ok
    call  ClearLine
    jmp   Scan

Done:
    call  PrintLine

Exit:
    mov   eax,1                     ; sys_exit
    mov   ebx,0
    int   80H
