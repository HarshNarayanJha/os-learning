mov ah, 0x0e        ; Enter the TTY mode
mov al, 65          ; Print 'A' (=65)
int 0x10            ; interupt the CPU to actually print it

jmp loop

loop:
    inc al
    int 0x010
    cmp al, 'Z' - 1
    jle loop

jmp $

times 510-($-$$) db 0

db 0x55, 0xaa