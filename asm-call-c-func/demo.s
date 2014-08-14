    segment .text
    global _main
    extern c_function, printf

    before db 'Before call: %lld', 10, 0
    after db 'After call: %lld', 10, 0
; r9   ; 6th param
; r8   ; 5th param
; rcx   ; 4th param
; rdx   ; 3rd param
; rsi   ; 2nd param
; rdi   ; 1st param
; call library

_main:
    mov rdi,before
    push  rsi
    push  rdi
    call  printf
    add   rsp, 16

    call  c_function

    mov rdi,after
    push  rsi
    push  rdi
    call  printf
    add   rsp, 16

exit:
mov rbx,rax
    mov   rax,1
    ;mov   rbx,0
    int   80h
