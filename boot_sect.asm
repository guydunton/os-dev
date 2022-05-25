;
; boot sector that boots a C kernal in 32-bit protected mode
;
[org 0x7c00]      ; Set the location for data pointer
KERNAL_OFFSET equ 0x1000    ; Where we will load our kernal

    ; BIOS stores our boot drive in DL, so it's best to remember
    ; this for later
    mov [BOOT_DRIVE], dl

    mov bp, 0x9000  ; Setup the stack
    mov sp, bp

    mov bx, MSG_REAL_MODE   ; Announce that we are starting
    call print_string       ; booting from 16-bit real mode

    call load_kernal        ; Load the kernal

    call switch_to_pm       ; switch to protected mode. We don't return

    jmp $           ; Loop forever

%include "src/print_string.asm"
%include "src/print_string_pm.asm"
%include "src/disk_load.asm"
%include "src/gdt.asm"
%include "src/switch_to_pm.asm"

[bits 16]
load_kernal:
    mov bx, MSG_LOAD_KERNAL
    call print_string

    ; Setup disk loading routine so that we load the first 15 sectors
    ; (excluding the boot sector) from the boot disk (i.e. kernal code)
    ; to address KERNAL_OFFSET
    mov bx, KERNAL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]
BEGIN_PM:
    ; Announce we are in protected mode
    mov ebx, MSG_PROT_MODE 
    call print_string_pm

    ; Now jump to the address of our loaded kernal code,
    ; assume the brace position, and cross your fingers
    call KERNAL_OFFSET

    jmp $   ; Hang

BOOT_DRIVE:
    db 0
MSG_REAL_MODE:
    db "Started in 16-bit Real mode", 0
MSG_PROT_MODE:
    db "Successfully landed in 32-bit Protected mode", 0
MSG_LOAD_KERNAL:
    db "Loading the kernal into memory", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
