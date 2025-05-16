; Extra Credit Version
section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A ;hex input data
    len equ $ - inputBuf ;length calculation
    newline db 0x0A, 0x00 ;end of line marker

section .bss
    outputBuf resb 80 ;output storage allocation

section .text
    global _start
_start:
    mov esi, inputBuf    ;setup source pointer
    mov edi, outputBuf   ;setup destination pointer
    mov ecx, len         ;initialize loop counter

convert_loop_ec:
    movzx eax, byte [esi]   ;capture byte for processing
    inc esi
    
    ; use dedicated routine for full byte translation
    push edi              ;preserve output position
    call byte_to_ascii    ;convert entire byte to two hex chars
    pop edi               ;restore output position
    
    ; separate bytes visually
    mov byte [edi+2], ' '
    add edi, 3            ;advance past both hex chars and space
    
    loop convert_loop_ec
    
    ; finalize output formatting
    dec edi
    mov byte [edi], 0x0A ;replace final space with newline
    inc edi              
    
    ; display translated hex values
    mov edx, edi
    sub edx, outputBuf    ;calculate output length
    mov ecx, outputBuf    
    mov ebx, 1            
    mov eax, 4            
    int 0x80
    
    ; terminate program
    mov eax, 1 
    xor ebx, ebx 
    int 0x80

; complete byte translation subroutine
byte_to_ascii:
    push ebx              ;preserve register state
    
    ; process first half of byte
    mov bl, al            ;store original value
    shr al, 4             ;isolate high 4 bits
    call nibble_to_ascii  ;translate first hex digit
    mov [edi], al         
    
    ; process second half of byte
    mov al, bl            
    and al, 0x0F          ;isolate low 4 bits
    call nibble_to_ascii  ;translate second hex digit
    mov [edi+1], al       
    
    pop ebx               ;restore register state
    ret

; convert 4-bit value to displayable character
nibble_to_ascii:
    cmp al, 10
    jl digit              ;branch for numeric vs alpha conversion
    add al, 'A' - 10      ;convert values 10-15 to A-F
    ret
digit:
    add al, '0'           ;convert values 0-9 to ascii digits
    ret
