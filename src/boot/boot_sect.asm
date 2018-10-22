;
; simple boot sector that prints a message to bios 
;
    [org 0x7c00]          ; where we expect the boot sector to be loaded

    xor bx, bx
    mov bx, START_MSG
    call print_string

    mov [BOOT_DRIVE], dl  ; remember boot drive for later
    mov bp, 0x8000        ; move the stack far away
    mov sp, bp
    mov bx, 0x9000        ; bytes will be read to this location
    mov dh, 5             ; we want 5 sectors
    mov dl, [BOOT_DRIVE]
    call disk_load
    mov ax, [0x9000]      ; print what we loaded
    call print_hex

    jmp $ 

    START_MSG:
        db 'Starting bootloader...', 0

    ERR_MSG:
        db 'Disk read error', 0

    BOOT_DRIVE: db 0

    disk_load:
        push dx           ; save dx for later so we can check the bytes requested
        mov ah, 0x02      ; bios read sector function
        mov al, dh        ; read dh sectors
        mov ch, 0x00      ; cylinder 0
        mov dh, 0x00      ; head 0
        mov cl, 0x02      ; start reading from sector 2 (after the boot sector)
        int 0x13
        jc disk_error     ; carry flag error
        pop dx;
        cmp dh, al        ; check to see if we read the amount we requested
        jne disk_error
        ret
    
    disk_error:
        mov bx, ERR_MSG
        call print_string
        ret

    %include "print_string.asm"
    %include "print_hex.asm"

;
; padding and magic boot sector number
; 

    times 510-($-$$) db 0 ; pad the first 510 bytes with zeros

    dw 0xaa55             ; mark the last two bytes so the bios knows
                          ; we are a boot sector

; data padding so we have something to read
; creates a second sector
times 256 dw 0xdada
times 256 dw 0xface