; code to switch into 32-bit protected mode
[bits 16]

switch_to_pm:
    cli                     ; switch off interrupts until we can setup
                            ; the protected mode interrupt vector
    
    lgdt [gdt_descriptor]   ; load the global descriptor table

    mov eax, cr0            ; enable protected mode by setting the control register
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; make a far jump into a new segemnt to flush
                            ; any cpu jobs

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; update the segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; update the stack position
    mov esp, ebp

    call begin_pm