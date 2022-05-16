;
; A simple boot sector program that loops forever
;

org 0x7c00      ; Set the location for data pointer

start:

    mov bx, HELLO_MSG
    call print_string

    mov bx, GOODBYE_MSG
    call print_string

end:
    jmp $           ; Loop forever

%include "src/print_string.asm"

HELLO_MSG:
    db "Hello, World!",0

GOODBYE_MSG:
    db "Goodbye", 0

;
; Padding and magic BIOS number
;

; This fills the next 510 bytes with 0s
; $ = address of current instruction
; $$ = address of start of section
times 510-($-$$) db 0

dw 0xaa55 ; Tells the BIOS that this is a boot sector
