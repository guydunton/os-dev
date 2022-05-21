[bits 16]
; Switch to protected mode
switch_to_pm:
    ; We must switch off interrupts while entering protected mode
    ; otherwise strange things could happen halfway through
    cli 

    ; Load our global descriptor table, which defines the protected
    ; mode segments (e.g. for code and data)
    lgdt [gdt_descriptor]

    mov eax, cr0    ; To make the switch to protected mode, we set
    or eax, 0x1     ; the first bit of CR0, a control register
    mov cr0, eax

    ; Mode a far jump (i.e. to a new segment) to our 32-bit code.
    ; This also forces the CPU  to flush the pre-fetch cache
    jmp CODE_SEG:init_pm

[bits 32]
; Initialize registers and the stack once in protected mode
init_pm:
    mov ax, DATA_SEG    ; Now in PM, our old segments are meaningless
    mov ds, ax          ; so we point our segment registers to the
    mov ss, ax          ; data selector we defined in our GDT
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000    ; Update the stack position so it is right
    mov esp, ebp        ; at the top of the free space

    call BEGIN_PM
