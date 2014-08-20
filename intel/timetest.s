;;; build : nasm -f elf32 -o timetest.o timetest.s && gcc -o t timetest.o

    [section .data]
    TimeMsg db "Hey, what time is it? It’s %s",10,0
    YearMsg db "The year is %d.",10,0
    Elapsed db "A total of %d seconds has elapsed since program began running.", 10,0

    [section .bss]
    OldTime resd 1
    NewTime resd 1
    TimeDiff resd 1                 ; 32-bit time_t value
    TimeStr resb 40                 ; Reserve 40 bytes for time string
    TmCopy resd 9                   ; see struct tm below
;;;              struct tm {
;;;              int tm_sec;         /* seconds */
;;;              int tm_min;         /* minutes */
;;;              int tm_hour;        /* hours */
;;;              int tm_mday;        /* day of the month */
;;;              int tm_mon;         /* month */
;;;              int tm_year;        /* year */
;;;              int tm_wday;        /* day of the week */
;;;              int tm_yday;        /* day in the year */
;;;              int tm_isdst;       /* daylight saving time */
;;;          };

    [section .text]                 ; Section containing code
    extern ctime,difftime,getchar,printf,localtime,strftime,time
    global main
                                    ; Required so linker can find entry point
main:
    push  ebp
    mov   ebp,esp

    push  ebx
    push  esi
    push  edi

    push  0
    call  time                      ; time_t time(time_t *t);
    add   esp,4

    mov   [OldTime],eax             ; ret val of time(NULL)
    push  OldTime
    call  ctime                     ; char *ctime(const time_t *timep);
    add   esp,4

    push  eax                       ; ret of ctime -> char *
    push  TimeMsg
    call  printf
    add   esp,8

    push  dword OldTime
    call  localtime                 ; struct tm *localtime(const time_t *timep);
    add   esp,4

    mov   esi,eax                   ; struct tm * in eax
    mov   edi,TmCopy
    mov   ecx,9
    cld
    rep   movsd                     ; TmCopy = Tm_val_from_localtime

    mov   edx,dword [TmCopy+20]     ; offset of tm_year in 'struct tm' is 20
    add   edx,1900                  ; Year field is # of years since 1900
    push  edx
    push  YearMsg
    call  printf
    add   esp,8

    call  getchar                   ; wait user input

    push  dword 0
    call  time                      ; ret val is time_t
    add   esp,4

    mov   [NewTime],eax
    sub   eax,[OldTime]             ; Calculate time difference value
    mov   [TimeDiff],eax            ; Save time difference value
    push  dword [TimeDiff]
    push  Elapsed
    call  printf
    add   esp,8

    pop   edi                       ; Restore saved registers
    pop   esi
    pop   ebx

    mov   esp,ebp                   ; Destroy stack frame before returning
    pop   ebp
    ret
