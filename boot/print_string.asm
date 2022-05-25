; function:
;   print_string
;
; description:
;   Prints a string to the teletype console
;
; Parameters:
;   bx - The address of the string to print
print_string:
    pusha

    mov ah, 0x0e    ; Set the teletype prompt

loop_start:
    ; get the value pointed to by bx
    mov al, [bx]

    cmp al, 0       ; if the value is 0
    je loop_end     ; jump to the end

    int 0x10        ; print the value

    ; Move the pointer to the next character
    add bx, 0x1

    jmp loop_start  ; restart the loop

loop_end:
    popa
    ret
