;
; Read some sectors from the boot disk using our disk_read function
;

[org 0x7c00]      ; Set the location for data pointer

    mov bp, 0x9000      ; Set the stack
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string

    call switch_to_pm   ; Never return from here

    jmp $           ; Loop forever

%include "src/print_string.asm"
%include "src/print_string_pm.asm"
%include "src/gdt.asm"
%include "src/switch_to_pm.asm"

[bits 32]

BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    jmp $

MSG_REAL_MODE:
    db "Started in 16-bit Real mode", 0
MSG_PROT_MODE:
    db "Successfully landed in 32-bit Protected mode", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
