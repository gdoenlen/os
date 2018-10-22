; prints the string stored in bx
print_string:
    pusha
    mov ah, 0x0e
    .ps_loop:
        cmp byte [bx], 0
        je .ps_exit
        mov al, [bx]
        int 0x10
        inc bx
        jmp .ps_loop
    .ps_exit: 
        popa
        ret