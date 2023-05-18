# SmallExecutables
Minimally sized executable files written in nasm assembler syntax

ELF64 is a x86-64 ELF file which does not specify an interpreter and uses syscalls to print a string

ELF64Link is a x86-64 ELF file which interprets with ld-linux-x86-64.so.2, links with libc.so.6, calls \_\_libc_start_main, then uses printf to print a string

Windows PE format will be added when I get around to it

Assemble with **nasm file.asm -f bin -o file**
