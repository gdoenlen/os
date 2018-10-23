; simple boot sector that prints a message to bios 
[org 0x7c00]              

    xor bx, bx
    mov bx, START_MSG
    call print_string
    
    ; move the stack
    mov bp, 0x8000        
    mov sp, bp

    call switch_to_pm
    jmp $ 

    %include "print_string.asm"
    %include "gdt.asm"
    %include "print_string_pm.asm"
    %include "switch_to_protected_mode.asm"

    [bits 32]
    begin_pm:
        mov ebx, MSG_PROT_MODE
        call print_string_pm
        jmp $

    START_MSG:
        db 'Starting bootloader...', 0

    MSG_PROT_MODE:
        db 'Switched to protected mode.', 0

; padding and magic boot sector number
times 510-($-$$) db 0 
dw 0xaa55             
