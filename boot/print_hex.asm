;
; Function:
;   print_hex - Print out a 16 bit value in hex
;
; Arguments:
;   dx - Value we want to print as hex
print_hex:
    pusha

    ; Set up the output pointer
    mov bx, HEX_OUT
    add bx, 0x5         ; Set bx to end of template string

print_hex_loop_start:
    mov di, HEX_CHARS   ; Set di to start of char strings
    mov ax, dx          ; copy dx into ax
    and ax, 0xf         ; only look at first 4 bits

    add di, ax          ; move hex char onto correct character
    mov al, [di]        ; copy character into temp register
    mov [bx], al        ; copy into template

    sub bx, 1           ; move the template to next character
    shr dx, 4           ; shift dx down 4 bits

    cmp dx, 0           ; restart loop if nothing left to copy
    jne print_hex_loop_start

    ; Call print_string
    mov bx, HEX_OUT
    call print_string

    popa
    ret

HEX_OUT:
    db "0x0000", 0

HEX_CHARS:
    db "0123456789abcdef", 0
