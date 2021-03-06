[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by edx
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY ; Set edx to the start of vid mem

print_string_pm_loop:
    mov al, [ebx]       ; Store the char at EBX in AL
    mov ah, WHITE_ON_BLACK  ; Store attributes in AH

    cmp al, 0           ; if al == 0 at end of string
    je print_string_pm_done ; jump to done

    mov [edx], ax       ; Store char and attributes at current
                        ; character cell
    add ebx, 1          ; Increase ebx to the next char in string
    add edx, 2          ; Move to next char cell in vid mem

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
