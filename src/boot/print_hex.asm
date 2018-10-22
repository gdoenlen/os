; prints the hex value stored in ax
print_hex:
    pusha
    mov cl, 4
    .ph_rotate:
        rol ax, 4              ; rotate the value left 4 bits 0xAFEC
        push ax                ; save the value for the next loop
        and ax, 0x0f           ; isolate the char
        add ax, 0x30           ; convert to ascii
        cmp al, '9'            ; <= 9 means its a digit nothing to do
        jle .ph_print_char
        add al, 0x7                   
    .ph_print_char:
        mov ah, 0x0e
        int 0x10
        pop ax
        dec cl
        jnz .ph_rotate
    popa
    ret
