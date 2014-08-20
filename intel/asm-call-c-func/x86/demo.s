    segment .text
    global _main
    extern c_function, printf, sleep

    before db 'Before call: %d', 10, 0
    after db 'After call: %d', 10, 0

_main:
    push  eax
    push  before
    call  printf
    add   esp, 8

    call  c_function

    push  eax
    push  after
    call  printf
    add   esp, 8

exit:
    mov   eax,1
    mov   ebx,0
    int   80h
