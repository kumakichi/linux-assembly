    section .data
    ErrMsg db "Terminated with error.",10
    ERRLEN equ $-ErrMsg

    section .bss
    MAXARGS equ 10
    Argc  resd 1
    ArgPtrs resd MAXARGS            ; Table of pointers to arguments
    ArgLens resd MAXARGS            ; Table of arguments length

    section .text
    global _start
_start:
    nop
    pop   ecx                       ; argument count
    cmp   ecx,MAXARGS               ; only support no more than MAXARGS arguments
    ja    Error
    mov   dword [Argc],ecx          ; Save arg count in memory variable

    xor   edx,edx
SaveArgsAddr:
    pop   dword [ArgPtrs + edx*4]   ; Pop an arg addr into the memory table
    inc   edx
    cmp   edx,ecx
    jb    SaveArgsAddr

;;;     Direction flag
;;;     The address of the first byte of the string to be searched is placed in EDI
;;;     The value to be searched for is placed in AL
;;;     A maximum count is placed in ECX

    xor   eax,eax                   ; al=0, we search 'NUL'
    xor   ebx,ebx
ScanOne:
    mov   ecx,0000ffffh             ; support 65535 bytes
    mov   edi,dword [ArgPtrs+ebx*4] ; Put address of string to search in EDI
    mov   edx,edi                   ; save the beginning addr of string to edx
    cld
    repne scasb                     ; edi aumatically increase 1 after each call of scasb
    jnz   Error                     ; check whether zf == 1 (founded NUL) or cx = 0 (65535 bytes?)
    mov   byte [edi-1],10           ; automatically increased after scasb came across NUL
    sub   edi,edx                   ; sizeof(str)
    mov   dword [ArgLens+ebx*4],edi ; save length
    inc   ebx
    cmp   ebx,[Argc]
    jb    ScanOne
    xor   esi,esi

Showem:
    mov   eax,4
    mov   ebx,1
    mov   ecx,[ArgPtrs+esi*4]       ; Pass offset of the message
    mov   edx,[ArgLens+esi*4]       ; Pass the length of the message
    int   80H

    inc   esi
    cmp   esi,[Argc]
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
