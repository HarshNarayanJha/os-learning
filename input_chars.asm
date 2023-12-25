[org 0x7c00]		; the "offset"


mov ah, 0x0e
mov al, '>'
int 0x10
mov al, ' '
int 0x10

buffer:
    times 256 db 0

mov bx, buffer
jmp input

input:
    mov ah, 0           ; keyboard input mode
    int 0x16            ; waits for one char

    mov [bx], al
    inc bx

    mov ah, 0x0e
    int 0x010

    cmp al, 0DH
    je before_print
    jmp input

before_print:

    mov ah, 0x0e
    mov al, 0x0A
    int 0x10

    mov al, 0x0D
    int 0x10

    mov bx, buffer

    jmp print

print:
    mov ah, 0x0e
    mov al, [bx]
    inc bx

    cmp al, 0DH
    je exit

    int 0x10

    jmp print

exit:

jmp $
times 510-($-$$) db 0
dw 0xaa55