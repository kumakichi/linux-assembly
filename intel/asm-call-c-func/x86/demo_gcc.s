    segment .text
    global main                     ; should not be any other name
    extern c_function, printf

    before db 'Before call: %d', 10, 0
    after db 'After call: %d', 10, 0

main:
    push  ebp                       ; save ebp
    mov   ebp,esp                   ; new ebp(for 'main' procedure stack frame)

    push  ebx                       ; esp,ebp,ebx,esi,edi should not be changed after calling a procedure
    push  esi
    push  edi

    push  eax
    push  before
    call  printf
    add   esp, 8

    call  c_function

    push  eax
    push  after
    call  printf
    add   esp, 8

    pop   edi
    pop   esi
    pop   ebx

    mov   esp,ebp                   ; restore esp,ebp before calling 'main' procedure
    pop   ebp
    ret                             ; ret to the caller
