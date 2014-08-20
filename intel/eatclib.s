;;; build : nasm -f elf32 -o eatclib.o eatclib.s && gcc -o eatclib eatclib.o
    section .data
    msg   db 'Hello World!',0

    section .text
    extern puts
    global main
main:
    push  ebp
    mov   ebp,esp

    push  ebx
    push  esi
    push  edi

    push  msg
    call  puts
    add   esp,4

    pop   edi
    pop   esi
    pop   ebx

    mov   esp,ebp
    pop   ebp
    ret
