;Basic Version
section .data 
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A ;input buffers
    len equ $ - inputBuf ;to calculate the length of the input buff
    newline db 0x0A, 0x00 ;newline char
section .bss
    outputBuf resb 80 ;reserve 80 bits for the output buff
section .text
    global _start ;our code start point
_start:
    mov esi, inputBuf    ; points to input data
    mov edi, outputBuf   ; points to output buff
    mov ecx, len         ; counter
convert_loop:
    ; get current byte
    mov bl, byte [esi]   ; use bl to store the byte
    inc esi ;;move to the next in c++ it'd be i++

    ; convert high nibble
    mov al, bl           ; copy to al for conversion
    shr al, 4            ; high 4 bits
    call nibble_to_ascii
    mov [edi], al        ; store result
    inc edi

    ; convert low nibble
    mov al, bl           ; start with original byte again
    and al, 0x0F         ; low 4 bits
    call nibble_to_ascii
    mov [edi], al        ; store result
    inc edi

    ; for adding space
    mov byte [edi], ' '
    inc edi

    ; continue until done
    loop convert_loop

    ; replace last space with newline
    dec edi
    mov byte [edi], 0x0A
    inc edi              ; now edi points beyond the newline

    ; print output
    mov edx, edi
    sub edx, outputBuf   ; calculate length
    mov ecx, outputBuf ;pointer to the buff
    mov ebx, 1           
    mov eax, 4         ;replaces the trailing white space 
    int 0x80

    ; Exit
    mov eax, 1 ;exiting
    xor ebx, ebx ;0 means succcess
    int 0x80
; convert nibble to ASCII char
nibble_to_ascii:
    cmp al, 10
    jl digit
    add al, 'A' - 10     ; for A-F
    ret
digit:
    add al, '0'          ; for 0-9
    ret 
