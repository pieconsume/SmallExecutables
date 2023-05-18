defs:
 [BITS 64]
 [DEFAULT REL]
 [ORG 0]
elf:
 dd 0x464C457F
 db 0x02, 0x01, 0x01, 0x00, 0x00, 0, 0, 0, 0, 0, 0, 0
 dw 0x0003, 0x003E, 0x0001, 0x000
 dq entry, proghead, 0
 dw 0x0000, 0x0000, 0x0040, 0x0038, 0x0001, 0, 0, 0
 proghead:
 dd 0x01, 0x07
 dq 0, 0, 0, progend, progend, 0
entry:
 mov edi, 1
 lea rsi, [hello]
 mov edx, 7
 mov eax, 1
 syscall
 mov eax, 60
 syscall
 hello db 'hello!', 10
progend:
