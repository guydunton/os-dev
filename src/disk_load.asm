;
; Function:
;   disk_load
;
; Load DH sectors to ES:BX from drive DL
;
; Arguments:
;   DH - The number of sectors
;   EX - The sector offset
;   BX - The address within the sector to load the data to
;   DL - The number of the drive
disk_load:
    ; Store DX on stack so later we can recall
    ; how many sectors were request to be read,
    ; even if it is altered in the meantime
    push dx

    mov ah, 0x02    ; BIOS read sector function
    mov al, dh      ; Read DH sectors
    mov ch, 0x00    ; Select cylinder 0
    mov dh, 0x00    ; Select head 0
    mov cl, 0x02    ; Start reading from second sector (i.e.
                    ; after the boot sector)
    int 0x13        ; BIOS interrupt

    jc disk_error   ; Jump of error (i.e. carry flag set)
    pop dx          ; Restore dx from the stack
    cmp dh, al      ; if AL (sectors read) != DH (sectors expected)
    jne disk_size_error  ; Display error message
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

disk_size_error:
    mov bx, DISK_READ_SIZE_ERROR_MSG
    call print_string
    jmp $

DISK_READ_SIZE_ERROR_MSG:
    db "Read wrong amount from disk", 0

DISK_ERROR_MSG:
    db "Disk read error!", 0
