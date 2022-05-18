;
; A simple boot sector program that loops forever
;

org 0x7c00      ; Set the location for data pointer

start:

    mov dx, 0x1fb6
    call print_hex

end:
    jmp $           ; Loop forever

%include "src/print_string.asm"
%include "src/print_hex.asm"

;
; Padding and magic BIOS number
;

; This fills the next 510 bytes with 0s
; $ = address of current instruction
; $$ = address of start of section
times 510-($-$$) db 0

dw 0xaa55 ; Tells the BIOS that this is a boot sector
