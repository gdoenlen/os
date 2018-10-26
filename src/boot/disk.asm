; loads dh sectors to es:bx from drive dl
[bits 16]
disk_load:
    push dx
    push bx
    mov bx, MSG_DISK_LOAD
    call print_string
    pop bx
    mov ah, 0x02      ; BIOS read sector function
    mov al, dh        ; read dx sectors
    mov ch, 0x00      ; select cylinder 0
    mov dh, 0x00      ; select the first track
    mov cl, 0x02      ; select the 2nd sector (after the bootloader)

    int 0x13
    jc disk_error

    pop dx
    cmp dh, al
    jne disk_error
    ret

disk_error:
    mov bx, MSG_DISK_ERR
    call print_string
    ret
