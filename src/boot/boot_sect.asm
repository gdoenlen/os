; simple boot sector that prints a message to bios 
[org 0x7c00]
    KERNEL_OFFSET equ 0x1000

    ; saving the boot drive for later
    mov [BOOT_DRIVE], dl

    ; move the stack
    mov bp, 0x9000        
    mov sp, bp
    
    call load_kernel
    call switch_to_pm
    jmp $ 

    %include "print_string.asm"
    %include "gdt.asm"
    %include "print_string_pm.asm"
    %include "switch_to_protected_mode.asm"
    %include "disk.asm"

    [bits 16]
    load_kernel:
        ; begin loading the kernel image into 
        ; where we specified the offset to be.
        ; we are only loading the first 15 sectors
        mov bx, MSG_LOAD_KERNEL
        call print_string
        mov bx, KERNEL_OFFSET
        mov dh, 15
        mov dl, [BOOT_DRIVE]
        call disk_load
        ret

    [bits 32]
    begin_pm:
        mov ebx, MSG_PROT_MODE
        call print_string_pm
        call KERNEL_OFFSET
        jmp $

    BOOT_DRIVE db 0
    MSG_LOAD_KERNEL db "Loading kernel image", 0
    MSG_PROT_MODE db "In protected mode", 0
    MSG_EXIT_DISK_LOAD db "exited disk load", 0
    MSG_DISK_ERR db "Error reading disk", 0
    MSG_DISK_LOAD db "Loading disk", 0
; padding and magic boot sector number
times 510-($-$$) db 0 
dw 0xaa55             
