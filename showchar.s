    section .data

    COLS  equ 81
    ROWS  equ 25
    EOL   equ 10
    SpaceChar equ 32
    StartRow equ 2
    LineChars equ 32

    ClrHome db 27,"[2J",27,"[01;01H"
    CLRLEN equ $-ClrHome

    section .bss

    VidBuff resb COLS*ROWS

    section .text

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
    mov   al,SpaceChar
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

    global _start
_start:
    nop
    ClearTerminal
    call  ClrVid

    mov   eax,1
    mov   ebx,1
    mov   ecx,LineChars
    call  Ruler

    mov   edi,VidBuff
    add   edi,COLS*StartRow         ; now, edi is row 3(counting from 1)
    mov   ecx,94                    ; Show 127(0-127) chars minus first 33
    mov   al,33                     ; Start with char 33('!'); others(0->32) won't show

DoLine:
    mov   bl,LineChars              ; Each line will consist of 32 chars(line_counter)

.DoChar:
    stosb
    inc   al                        ; next char
    dec   bl                        ; line_counter++
    loopnz .DoChar
    jcxz  AllDone

    add   edi,(COLS-LineChars)      ; move to next line
    jmp   DoLine

AllDone:
    call  ShowBuffer
    mov   eax,1
    mov   ebx,0
    int   80H
