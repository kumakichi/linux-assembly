    section .data
    EOL   equ 10
    FILLCHR equ 32
    HBARCHR equ 88                  ; 'X'
    StartRow equ 2

    CharNums db 9,71,17,52,55,18,29,36,18,68,77,63,58,44,0
    Message db "Data current as of 08/11/2014"
    MSGLEN equ $-Message

    ClrHome db 27,"[2J",27,"[01;01H"
    CLRLEN equ $-ClrHome

    section .bss
    COLS  equ 81
    ROWS  equ 25
    VidBuff resb COLS*ROWS

    section .text
    global _start

    %macro SysWrite 2
    mov   eax,4
    mov   ebx,1
    mov   ecx,%1
    mov   edx,%2
    int   80H
    %endmacro

    %macro ClearTerminal 0
    pushad
    SysWrite ClrHome,CLRLEN
    popad
    %endmacro

    %macro CalculateOffset 0        ; offset = Y*line_length + X
    mov   edi, VidBuff
    dec   eax                       ; Y coordinate counting from [1,1] to [25,80]
    dec   ebx                       ; X coordinate counting from [1,1] to [25,80]
    mov   ah,COLS
    mul   ah                        ; Do 8-bit multiply AL*AH to AX
    add   edi,eax                   ; edi = Y * line_length
    add   edi,ebx                   ; edi = Y * line_length + X
    %endmacro

ShowBuffer:
    pushad
    SysWrite VidBuff,COLS*ROWS
    popad
    ret

ClrVid:
    push  eax
    push  ecx
    push  edi

    cld                             ; cld -> DF=0 ; std -> DF=1; 控制stosb的方向的，向高地址还是向低地址(0->uphill   1->downhill)
    mov   al,FILLCHR
    mov   edi,VidBuff
    mov   ecx,COLS*ROWS
    rep   stosb                     ; stosb -> STOre String by Byte[seems like memset(edi,al,ecx)]

    mov   edi,VidBuff
    dec   edi
    mov   ecx,ROWS
FillEOL:
    add   edi,COLS
    mov   byte [edi],EOL
    loop  FillEOL

    pop   edi
    pop   ecx
    pop   eax
    ret

CopyToBuffer:
    push  eax
    push  ebx
    push  ecx
    push  edi

    cld
    CalculateOffset
    rep   movsb                     ; a block of memory data at the address stored in ESI is copied to the address stored in EDI

    pop   edi
    pop   ecx
    pop   ebx
    pop   eax
    ret

WriteSpecialChar:
    push  eax
    push  ebx
    push  ecx
    push  edi

    cld
    CalculateOffset
    mov   al,HBARCHR
    rep   stosb

    pop   edi
    pop   ecx
    pop   ebx
    pop   eax
    ret

Ruler:
    push  eax
    push  ebx
    push  ecx
    push  edi

    CalculateOffset
    mov   al,'0'

NumChar:
    stosb                           ; stosw, stosd
    add   al,'1'
    aaa                             ; Adjust AL after BCD Addition
    add   al,'0'
    loop  NumChar

    pop   edi
    pop   ecx
    pop   ebx
    pop   eax
    ret

_start:
    nop
    ClearTerminal
    call  ClrVid

    mov   eax,1                     ; y position
    mov   ebx,1                     ; x position
    mov   ecx,COLS-1                ; ruler length
    call  Ruler

    mov   esi,CharNums
    mov   ebx,1                     ; x position
    mov   ebp,0                     ; CharNums index

WriteLines:
    mov   eax,ebp
    add   eax,StartRow
    mov   cl,byte [esi+ebp]
    cmp   ecx,0                     ; the last element of CharNums(0)
    je    BottomRuler

    call  WriteSpecialChar
    inc   ebp                       ; index increase
    jmp   WriteLines

BottomRuler:
    mov   eax,ebp
    add   eax,StartRow              ; y
    mov   ebx,1                     ; x
    mov   ecx,COLS-1
    call  Ruler

    mov   esi,Message
    mov   ecx,MSGLEN
    mov   ebx,COLS
    sub   ebx,ecx                   ; the number of blank chars
    shr   ebx,1                     ; now, x position (ebx) is centra
    mov   eax,25                    ; y position
    call  CopyToBuffer
    call  ShowBuffer

Exit:
    mov   eax,1
    mov   ebx,0
    int   80H
