    section .data
    EditBuff db 'abcdefghijklm$',10
    bufflen equ $-EditBuff
    ENDPOS equ 12
    INSRTPOS equ 5

    section .text

    %macro WriteStr 2
    mov   eax,4
    mov   ebx,1
    mov   ecx,%1
    mov   edx,%2
    int   80h
    %endmacro

    global _start
_start:
    nop

    WriteStr EditBuff,bufflen

    mov   al, byte [EditBuff+ENDPOS+1] ; save the last char -> '$'

    std                             ; downhill
    mov   esi,EditBuff+ENDPOS       ; endpos -> 'm'
    mov   edi,EditBuff+ENDPOS+1
    mov   ecx,ENDPOS-INSRTPOS+1
    rep   movsb
    
    mov   byte [EditBuff+INSRTPOS], al ; restore
    WriteStr EditBuff,bufflen

    mov   eax,1
    mov   ebx,0
    int   80h
