    section .data
    ArgMsg db 'Arg index %d is %s',10,0

    section .text
    extern printf
    global asm_show_arg
asm_show_arg:
    mov   edi,[ebp+8]               ; arg counter
    mov   ebx,[ebp+12]
    xor   esi,esi
.showit:
    push  dword [ebx+esi*4]
    push  esi
    push  ArgMsg
    call  printf
    add   esp,12
    inc   esi
    dec   edi
    jnz   .showit
    ret
