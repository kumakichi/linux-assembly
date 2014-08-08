    section .data

    SCRWIDTH equ 80

    PosTerm db 27,"[01;01H"         ; 27(ESC, normally \033)
    POSLEN equ $-PosTerm

    ColorTerm db 27,"[32;40m"       ; green on black background
    ColorLen equ $-ColorTerm

    ClearTerm db    27,"[2J"
    CLEARLEN equ $-ClearTerm

    AdMsg db "Eat At Joe's!"
    ADLEN equ $-AdMsg

    Prompt db "Press Enter: "
    PROMPTLEN equ $-Prompt

Digits:
    db    "0001020304050607080910111213141516171819"
    db    "2021222324252627282930313233343536373839"
    db    "4041424344454647484950515253545556575859"
    db    "606162636465666768697071727374757677787980"

    SECTION .bss                    ; Section containing uninitialized data
    SECTION .text

    %macro ExitProg 0
    mov   eax,1
    mov   ebx,0
    int   80H
    %endmacro

    %macro WaitEnter 0
    mov   eax,3
    mov   ebx,0
    int   80H
    %endmacro

    %macro WriteStr 2
    push  eax
    push  ebx
    mov   ecx,%1
    mov   edx,%2
    mov   eax,4
    mov   ebx,1
    int   80H
    pop   ebx
    pop   eax
    %endmacro

    %macro ClrScr 0
    push  eax
    push  ebx
    push  ecx
    push  edx

    WriteStr ClearTerm,CLEARLEN

    pop   edx
    pop   ecx
    pop   ebx
    pop   eax
    %endmacro

    %macro GotoXY 2                 ; %1 is X value; %2 id Y value
    pushad
    xor   edx,edx
    xor   ecx,ecx

    mov   dl,%2
    mov   cx,word [Digits+edx*2]    ; Fetch decimal digits to CX
    mov   word [PosTerm+2],cx

    mov   dl,%1
    mov   cx,word [Digits+edx*2]
    mov   word [PosTerm+5],cx

    WriteStr PosTerm,POSLEN

    popad
    %endmacro

    %macro SetColor 0
    WriteStr ColorTerm,ColorLen
    %endmacro

    %macro WriteCtr 3

    push  ebx
    push  edx
    mov   edx,%3
    xor   ebx,ebx
    mov   bl,SCRWIDTH
    sub   bl,dl
    shr   bl,1
    GotoXY bl,%1
    WriteStr %2,%3
    pop   edx
    pop   ebx

    %endmacro

    global _start

_start:
    nop
    ClrScr
    SetColor
    WriteCtr 12,AdMsg,ADLEN
    GotoXY 1,18
    WriteStr Prompt,PROMPTLEN
    WaitEnter
    ExitProg

;;;     labels in macro
    
;;;     %macro UpCase 2                 ; %1 = Address of buffer; %2 = Chars in buffer
;;;     mov   edx,%1                    ; Place the offset of the buffer into edx
;;;     mov   ecx,%2                    ; Place the number of bytes in the buffer into ecx
;;; %%IsLC: cmp byte [edx+ecx-1],’a’  ; Below 'a’?
;;;     jb    %%Bump                    ; Not lowercase. Skip
;;;     cmp   byte [edx+ecx-1],’z’    ; Above 'z’?
;;;     ja    %%Bump                    ; Not lowercase. Skip
;;;     sub   byte [edx+ecx-1],20h      ; Force byte in buffer to uppercase
;;; %%Bump: dec ecx                     ; Decrement character count
;;;     jnz   %%IsLC                    ; If there are more chars in the buffer, repeat
;;; %endmacro
