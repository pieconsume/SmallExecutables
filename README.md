# SmallExecutables
Minimally sized executable files written in nasm assembler syntax

Assemble with **nasm file.asm -f bin -o file**

ELF64 is a x86-64 ELF file which does not specify an interpreter and uses syscalls to print a string

ELF64Link is a x86-64 ELF file which uses ld-linux-x86-64.so.2 to link with libc.so.6, then calls \_\_libc_start_main and uses printf to print a string

TCPServer_ELF and TCPClient_ELF are built off of ELF64 and use syscalls to set up a basic TCP server

Windows PE format will be added when I get around to it
