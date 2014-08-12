    section .data
    msg   db 'Hello World from asm file!',10
    msglen equ $-msg
    
    section .text
    global asm_show_str, asm_exit

asm_show_str:
    mov   eax,4
    mov   ebx,1
    mov   ecx,msg
    mov   edx,msglen
    int   80h
    ret

asm_exit:
    mov eax,1
    mov ebx,0
    int 80h
    ret
