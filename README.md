# GuessingGame
A simple guess the number game in assembly


# Information about the assembler i used

`Assembler: Yasm`  
`Syntax: Intel syntax`  
`Arch: x64_86`


# How to compile

`yasm -f elf64 guessingGame.asm`  
`ld -o guessingGame guessingGame.o`

# How to get some fancy 0 and 1

If you want to see this machine code in binary you can do this:

`ld -O binary -o guessingGame.bin guessingGame.o`  

To view the binary: 
`xxd -b guessingGame.bin`
