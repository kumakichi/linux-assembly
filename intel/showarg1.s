    section .data
    ErrMsg db "Terminated with error.",10
    ERRLEN equ $-ErrMsg

    section .bss
    MAXARGS equ 10
    ArgLens resd MAXARGS            ; Table of arguments length

    section .text
    global _start
_start:
    nop

    mov   ebp,esp
    cmp   dword [ebp],MAXARGS       ; only support no more than MAXARGS arguments
    ja    Error

;;;     Direction flag
;;;     The address of the first byte of the string to be searched is placed in EDI
;;;     The value to be searched for is placed in AL
;;;     A maximum count is placed in ECX

    xor   eax,eax                   ; al=0, we search 'NUL'
    xor   ebx,ebx
ScanOne:
    mov   ecx,0000ffffh             ; support 65535 bytes
    mov   edi,dword [ebp+4+ebx*4]   ; Put address of string to search in EDI
    mov   edx,edi                   ; save the beginning addr of string to edx
    cld
    repne scasb                     ; edi aumatically increase 1 after each call of scasb
    jnz   Error                     ; check whether zf == 1 (founded NUL) or cx = 0 (65535 bytes?)
    mov   byte [edi-1],10           ; automatically increased after scasb came across NUL
    sub   edi,edx                   ; sizeof(str)
    mov   dword [ArgLens+ebx*4],edi ; save length
    inc   ebx
    cmp   ebx,[ebp]
    jb    ScanOne

    xor   esi,esi
Showem:
    mov   eax,4
    mov   ebx,1
    mov   ecx,[ebp+4+esi*4]         ; Pass offset of the message
    mov   edx,[ArgLens+esi*4]       ; Pass the length of the message
    int   80H

    inc   esi
    cmp   esi,[ebp]
    jb    Showem
    jmp   Exit

Error:
    mov   eax,4
    mov   ebx,1
    mov   ecx,ErrMsg
    mov   edx,ERRLEN
    int   80H

Exit:
    mov   eax,1
    mov   ebx,0
    int   80H
