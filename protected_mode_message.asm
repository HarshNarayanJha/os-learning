[org 0x7c00]    

mov [BOOT_DISK], dl

CODE_SEG equ GDT_code - GDT_Start
DATA_SEG equ GDT_data - GDT_Start
        ; equ is used to set constants

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax    ; yay, 32-bit mode!!
; far jump (jmp to other segment)
jmp CODE_SEG:start_protected_mode

jmp $

GDT_Start:          ; must be at the end of the real mode
    GDT_null:
        ; eight zero bytes
        dd 0x0      ; four times 00000000
        dd 0x0      ; four times 00000000
    
    GDT_code:
        dw 0xffff     ; first 16 bits of the limit        ; base 0 (32 bit)
        dw 0x0        ; 16                                ; limit 0xfffff
        db 0x0        ; + 4 = 24 bits of base             ; pres, priv, type = 1001
        db 0b10011010 ; pres, priv, type, type Flags      ; Type flags = 1010
        db 0b11001111 ; Other + Limit (last four bits)    ; Other Flags = 1100, limit = 1111
        db 0x0        ; Last 8 bits of the base

    GDT_data:
        dw 0xffff       ; first 16 bits of the limit        ; base 0 (32 bit)
        dw 0x0          ; 16                                ; limit 0xfffff
        db 0x0          ; + 4 = 24 bits of base             ; pres, priv, type = 1001
        db 0b10010010   ; pres, priv, type, type Flags      ; Type flags = 0010
        db 0b11001111   ; Other + Limit (last four bits)    ; Other Flags = 1100, limit = 1111
        db 0x0          ; Last 8 bits of the base

GDT_End:


GDT_Descriptor:
    dw GDT_End - GDT_Start - 1  ; size
    dd GDT_Start                ; start

[bits 32]
start_protected_mode:
    ; write protected mode code here
    ; Video memory start at 0xb8000
    ; mov al, 'A'
    ; mov ah, 0xf6    ; color code
    ; mov [0xb8000], ax
    mov ebx, MESSAGE
    mov ecx, 0
    mov ah, 0xf0
    jmp print
    jmp $

print:
    pusha
    mov al, [bx]
    mov ah, 0xf0
    cmp al, 0
    je exit
    mov [0xb8000+ecx], ax
    inc ebx
    add ecx, 2
    jmp print


BOOT_DISK: db 0
MESSAGE:
    db "           I'm in 32-bit protected mode and printing this message !!            "
    times 80 db " "
    times 80 db " "
    db "                    This bootloader is by Harsh Narayan Jha                     ", 0

exit:
    popa
    jmp $

times 510-($-$$) db 0
dw 0xaa55