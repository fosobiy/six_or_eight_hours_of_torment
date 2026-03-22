[org 0x7c00]
[bits 16]

mov [BOOT_DRIVE], dl
jmp 0x0000:start
start:

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov ah, 0x02
mov al, 4
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, [BOOT_DRIVE]

mov bx, 0x7c00 + 0x200
int 0x13

mov dx, ax
mov ah, 0x0e

mov al, dh
add al, '0'
int 0x10

mov al, dl
add al, '0'
int 0x10


cli                     ; 1. Выключаем прерывания
lgdt [gdt_descriptor]    ; 3. Загружаем GDT
    
mov eax, cr0
or eax, 0x1             ; 4. Переходим в PM
mov cr0, eax
    
jmp CODE_SEG:init_pm  
[bits 32]
init_pm:


mov ax, DATA_SEG
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax


mov ebp, 0x90000  
mov esp, ebp

call 0x00007e00

jmp $

BOOT_DRIVE db 0

align 16
gdt_start:
    dq 0x0          ; Null descriptor

gdt_code:           ; 0x08
    dw 0xffff       ; Limit 0:15
    dw 0x0000       ; Base 0:15
    db 0x00         ; Base 16:23
    db 10011010b    ; Access: P=1, DPL=0, S=1, Type=Code(RX)
    db 11001111b    ; Flags: G=1, D=1 (32-bit), Limit 16:19
    db 0x00         ; Base 24:31

gdt_data:           ; 0x10
    dw 0xffff       ; Limit 0:15
    dw 0x0000       ; Base 0:15
    db 0x00         ; Base 16:23
    db 10010010b    ; Access: P=1, DPL=0, S=1, Type=Data(RW)
    db 11001111b    ; Flags: G=1, D=1, Limit 16:19
    db 0x00         ; Base 24:31
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start


CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510-($-$$) db 0
dw 0xaa55



