;;; while true
;;;     read
;;;     proc_buff(high 4 bits,low 4 bits)
;;;     print_buff
;;; done
    section .bss
    buff_len equ 16
    buff  resb buff_len

    section .data
    dispstr db '0123456789ABCDEF'
    hexstr db '00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 '
    hexlen equ $-hexstr

    section .text
    global _start

_start:
    nop
read:
    mov   eax,3                     ; sys_read
    mov   ebx,0                     ; stdin
    mov   ecx,buff
    mov   edx,buff_len
    int   80h

    mov   ebp,eax                   ; save read bytes length
    cmp   eax,0
    je    done

    mov   esi,buff
    mov   edi,hexstr
    xor   ecx,ecx                   ; counter

procbuff:
    lea   edx,[ecx*2+ecx]

    mov   eax,0
    mov   al,byte [esi+ecx]         ; retrive one byte
    mov   ebx,eax                   ; save this byte (we need process 2 times: 1 for the higher 4 bits, 1 for the lower 4 bits)

    and   al,0fh
    mov   al,byte [dispstr+eax]
    mov   byte [edi+edx+1],al       ; transform the lower 4 bits to a char

    shr   bl,4
    mov   bl,byte [dispstr+ebx]
    mov   byte [edi+edx],bl         ; transform the higher 4 bits to char

    inc   ecx
    cmp   ecx,ebp
    jl    procbuff                  ; loop process

    mov   byte [edi+edx+2],0x0a
    mov   eax,4
    mov   ebx,1
    mov   ecx,hexstr
    add   edx,3
    int   80h

    jmp   read

done:
    mov   eax,1
    mov   ebx,0
    int   80h