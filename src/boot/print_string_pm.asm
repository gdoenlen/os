; prints a string in protected mode without bios
[bits 32]
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints the string pointed to by EBX
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx]                 ; store the first character of the string in al
    mov ah, WHITE_ON_BLACK        ; set the colors we want to print
    cmp al, 0                     ; end of the string return from the function
    je print_string_pm_done
    mov [edx], ax                 ; put the char + color at the current video memory slot
    inc ebx                       ; increment to the next char of the string
    add edx, 2                    ; go to the next video memory slot (2 because char + color)
    jmp print_string_pm_loop      

print_string_pm_done:
    popa
    ret
