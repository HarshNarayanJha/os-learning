; Reading from the disk (int 0x13)

[org 0x7c00]		; the "offset"


; Which disk = dl
; CHS (cylinder, head, sector) address = (0, 0, 2) (=next sector)
; NOTE: CHS starts from (0, 0, 1)
; How many sectors (=1)
; Where to load ( = 0x7e00 = 0x7c00 + 512(boot sector size))

mov [BOOT_DISK], dl

xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov ah, 2
mov al, 1           ; num sectors
mov ch, 0           ; cylinder number
mov cl, 2           ; sector number
mov dh, 0           ; head number
mov dl, [BOOT_DISK]   ; disk number

push ax
mov ax, 0
mov es, ax           ; offset
pop ax

mov bx, 0x7e00      ; where to put that read
int 0x13            ; read

; print the thing at [0x7e00]

jmp print

print:
    mov ah, 0x0e
    mov al, [bx]

    cmp al, 0
    je exit

    int 0x10
    inc bx

    jmp print


exit:

BOOT_DISK: db 0

jmp $

times 510-($-$$) db 0
db 0x55, 0xaa

db "This is Harsh's Operating System (aka OS) !!!! (Read from 2nd sector of the boot disk loaded at address 0x7e00)", 0