; Extra Credit Version
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

convert_loop_ec:
    movzx eax, byte [esi]   ; get current byte, zero-extend to eax
    inc esi ;move to the next in c++ it'd be i++
    
    ; call subroutine to convert full byte
    push edi              ; save destination pointer
    call byte_to_ascii    ; convert byte in AL to two ASCII chars
    pop edi               ; restore destination pointer
    
    ; for adding space
    mov byte [edi+2], ' '
    add edi, 3            ; move past the two hex chars and space
    
    loop convert_loop_ec
    
    ; replace last space with newline
    dec edi
    mov byte [edi], 0x0A
    inc edi               ; now edi points beyond the newline
    
    ; print output
    mov edx, edi
    sub edx, outputBuf    ; calculate length
    mov ecx, outputBuf    ; pointer to the buff
    mov ebx, 1            
    mov eax, 4            ; replaces the trailing white space
    int 0x80
    
    ; Exit
    mov eax, 1 ;exiting
    xor ebx, ebx ;0 means success
    int 0x80

; byte to ASCII subroutine - converts a full byte to two hex chars
; Input: AL = byte to convert
; Output: Two ASCII chars written to [EDI] and [EDI+1]
byte_to_ascii:
    push ebx              ; save registers we'll modify
    
    ; convert high nibble
    mov bl, al            ; save original byte
    shr al, 4             ; isolate high nibble (first 4 bits)
    call nibble_to_ascii  ; convert to ASCII
    mov [edi], al         ; store first hex char
    
    ; convert low nibble
    mov al, bl            ; restore original byte
    and al, 0x0F          ; isolate low nibble (last 4 bits)
    call nibble_to_ascii  ; convert to ASCII
    mov [edi+1], al       ; store second hex char
    
    pop ebx               ; restore registers
    ret

; convert nibble to ASCII char
; Input: AL = nibble (0-15)
; Output: AL = ASCII char ('0'-'9', 'A'-'F')
nibble_to_ascii:
    cmp al, 10
    jl digit
    add al, 'A' - 10      ; for A-F
    ret
digit:
    add al, '0'           ; for 0-9
    ret
