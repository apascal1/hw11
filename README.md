# hw11

How to compile: 

nasm -f elf32 -g -F dwarf -o hw11.o hw11.asm
ld -m elf_i386 -o hw11 hw11.o
./hw11

for extra credit version samething but 

nasm -f elf32 -g -F dwarf -o hw11extra.o hw11extra.asm
ld -m elf_i386 -o hw11extra hw11extra.o
./hw11extra
