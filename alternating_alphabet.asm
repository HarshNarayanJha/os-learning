mov ah, 0x0e        ; Enter TTY Mode
mov al, 65          ; Print Capital A
int 0x10

mov bx, 1
jmp small

capital:
    inc al
    sub al, 32
    int 0x10
    cmp al, 'z' - 1
    jle small
    jmp loop

small:
    inc al
    add al, 32
    int 0x10
    cmp al, 'z' - 1
    jle capital
    jmp loop

loop:
    jmp $

times 510-($-$$) db 0

db 0x55, 0xaa