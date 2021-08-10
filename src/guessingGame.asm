%macro print 2
    mov rsi, %1
    mov rdx, %2
    mov rax, 1
    mov rdi, 1
    syscall
%endmacro

%macro exit 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro

section .data
    SYS_read    equ 0
    STDIN       equ 0
    LF          equ 10
    welcome db "Guessing game in Assembly - By Lewin Sorg",LF,LF,0
    enterLine db "Enter a number between 1-99: ",0
    equalLine db "You won the game",LF,0
    smallLine db "Too small",LF,0
    bigLine db "Too big",LF,0
    errLine db "Only numbers between 1-99 accepted",LF,0
    secretNumber db 56
    usrInput db 0

section .bss
    chr resb 1
    inLine resb 3
    next resd 1

section .text
global _start

_start:
    call _srand
    call _rand
    mov ebx, 100
    mov edx, 0
    div ebx
    mov dword[secretNumber], edx

    mov rdi, welcome
    call getSize
    print welcome, rax

gameLoop:
    mov qword[inLine], 0
    mov qword[usrInput], 0

    mov rdi, enterLine
    call getSize
    print enterLine, rax

    ; Get Input
    mov rbx, inLine
    mov r12, 0

readCharacters:
    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, byte[chr]
    mov rdx, 1
    syscall

    mov al, byte[chr]
    cmp al, LF
    je readDone

    inc r12
    cmp r12, 3
    jae readCharacters

    mov byte[rbx], al
    inc rbx

    jmp readCharacters

readDone:
    cmp r12, 2
    ja numErr

toNumber:
    mov al, [inLine]
    cmp al, 0
    je gameLoop
    sub al, 48

    cmp al, 9
    ja numErr

    mov ah, [inLine+1]
    cmp ah, 0
    je singleNum

    mov bl, 10

    mul bl
    mov word[usrInput], ax

    mov al, [inLine+1]
    sub al, 48

    cmp al, 9
    ja numErr

    add byte[usrInput], al
    jmp compare

singleNum:
    mov byte[usrInput], al
    jmp compare

numErr:
    mov rdi, errLine
    call getSize
    print errLine, rax
    jmp gameLoop

compare:
    mov al, byte[usrInput]
    cmp al, byte[secretNumber]
    je cEqual
    jb cSmall
    ja cBig

cSmall:
    mov rdi, smallLine
    call getSize
    print smallLine, rax
    jmp gameLoop

cBig:
    mov rdi, bigLine
    call getSize
    print bigLine, rax
    jmp gameLoop

cEqual:
    mov rdi, equalLine
    call getSize
    print equalLine, rax

finish:
    exit 0

getSize:
    push rbp
    mov rbp, rsp
    push rbx

    mov rbx, rdi
    mov rcx, 0

counter:
    cmp byte[rbx], 0
    je done
    inc rbx
    inc rcx
    jmp counter

done:
    mov rax, rcx
    pop rbx
    pop rbp
    ret


; prng
_rand:
    mov eax, [next]
    mov ebx, 1103515245
    mul ebx
    add eax, 12345
    mov dword [next], eax
    mov ebx, 32768
    xor edx, edx
    div ebx
    ret

_srand:
    mov eax, 201
    mov ebx, 0x0
    syscall
    mov dword [next], eax
    ret
