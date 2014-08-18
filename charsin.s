;;; build : nasm -f elf32 charsin.s -o charsin.o && gcc -o charsin charsin.o
    [section .data]
    Sprompt db	'Enter string data, followed by Enter: ',0
    SShow db	'The string you entered was: %s',10,0

    IPrompt db	'Enter an integer value, followed by Enter: ',0
    IFormat db	'%d',0
    IShow db	'The integer value you entered was: %5d',10,0

    [section .bss]
    IntVal resd 1
    InString resb 128

    [section .text]
    extern stdin, fgets, printf, scanf
    global main

main:
    push  ebp
    mov   ebp,esp

    push  ebx
    push  esi
    push  edi

    push  Sprompt
    call  printf
    add   esp,4

    push  dword [stdin]
    push  72
    push  InString
    call  fgets                     ; char *fgets(char *s, int size, FILE *stream);
    add   esp,12

    push  InString
    push  SShow
    call  printf
    add   esp,8

    push  IPrompt
    call  printf
    add   esp,4

    push  IntVal
    push  IFormat
    call  scanf
    add   esp,8

    push  dword [IntVal]
    push  IShow
    call  printf
    add   esp,8

    pop   edi
    pop   esi
    pop   ebx

    mov   esp,ebp
    pop   ebp
    ret
