[org 0x7c00]            ; the "offset"
mov ah, 0x0e            ; TTY mode
mov bx, the_text
jmp loop

loop:
    mov al, [bx]

    cmp al, 0
    je end

    int 0x10
    inc bx
    
    jmp loop

end:

the_text:
    db "This is the only string in this program!", 0

times 510-($-$$) db 0
dw 0xaa55