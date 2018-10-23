; global descriptor table
gdt_start:

; mandatory null descriptor segment  
gdt_null:         
    dd 0x0        ; dd means declare double word 4 bytes
    dd 0x0

; code segment 
gdt_code:
    ; base = 0x0, limit = 0xfffff
    ; 1st flags: (present)1 (priviledge)00 (descriptor type)1 -> 1001b
    ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
    ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
    dw 0xfffff     ; limit (bits 0 - 15)
    dw 0x0         ; base (bits 0 - 15)
    db 0x0         ; base (bits 16 - 23)
    db 10011010b   ; 1st flags && type flags
    db 11001111b   ; 2nd flags and limit
    db 0x0         ; base (bits 24 - 31)

; data segment
gdt_data:
    ; same as the code segment except for the following type flags
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xfffff     ; limit (bits 0 - 15)
    dw 0x0         ; base (bits 0 - 15)
    db 0x0         ; base (bits 16 - 23)
    db 10010010b   ; 1st flags && type flags
    db 11001111b   ; 2nd flags and limit
    db 0x0         ; base (bits 24 - 31)

; end of the gdt to help with calculating the size of the gdt
gdt_end:

; gdt descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; size of the table, always 1 less
    dd gdt_start                 ; start address

; constants for th gdt offsets for the segment registers
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
