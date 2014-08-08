    section .bss
    BUFFLEN EQU 10
    Buff  resb BUFFLEN

    section .data

    GLOBAL DumpLin, HexDigits, BinDigits

DumpLin:
    db    " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 "
    DUMPLEN EQU   $-DumpLin
ASCLin:
    db    "|................|",10
    ASCLEN EQU   $-ASCLin
    FULLLEN EQU   $-DumpLin

HexDigits:
    db    "0123456789ABCDEF"

BinDigits: db "0000","0001","0010","0011"
    db    "0100","0101","0110","0111"
    db    "1000","1001","1010","1011"
    db    "1100","1101","1110","1111"

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

    GLOBAL ClearLine, DumpChar, Newlines, PrintLine

ClearLine:
    push  edx
    mov   edx,15
.Poke: mov eax,0
    call  DumpChar
    sub   edx,1
    jae   .Poke
    pop   edx
    ret

DumpChar:
    push  ebx
    push  edi

    mov   bl,byte [DotXlat+eax]
    mov   byte [ASCLin+edx+1],bl

    mov   ebx,eax
    lea   edi,[edx*2+edx]

    and   eax,0000000Fh
    mov   al,byte [HexDigits+eax]

    mov   byte [DumpLin+edi+2],al

    and   ebx,000000F0h
    shr   ebx,4
    mov   bl,byte [HexDigits+ebx]   ; Look up char equivalent of nybble
    mov   byte [DumpLin+edi+1],bl

    pop   ebx
    pop   edi
    ret

Newlines:
    pushad
    cmp   edx,15
    ja    .exit
    mov   ecx,EOLs
    mov   eax,4
    mov   ebx,1
    int   80h
    .exit popad
    ret

EOLs: db  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10

PrintLine:
    pushad
    mov   eax,4
    mov   ebx,1
    mov   ecx,DumpLin
    mov   edx,FULLLEN
    int   80h
    popad
    ret
