defs:
 [BITS 64]
 [DEFAULT REL]
 [ORG 0]
elf:
 dd 0x464C457F
 db 0x02, 0x01, 0x01, 0x00, 0x00, 0, 0, 0, 0, 0, 0, 0
 dw 0x0003, 0x003E, 0x0001, 0x0000
 dq init, proghead, 0
 dw 0, 0, 0x0040, 0x0038, 0x0001, 0, 0, 0
 proghead:
 dd 0x01, 0x07
 dq 0, 0, 0, progend, progend, 0
init:
 mov edi, 2 ; IPV4
 mov esi, 1 ; TCP
 xor edx, edx
 mov eax, 41 ; sys_socket
 syscall
 mov ebx, eax
 mov edi, eax
 mov esi, 1  ; SOL_SOCKET
 mov edx, 15 ; SO_REUSEPORT
 lea r10, [true]
 mov r8d, 4
 mov eax, 54 ; sys_setsockopt
 syscall
 mov edi, ebx
 lea rsi, [addr]
 mov edx, 0x10
 mov eax, 49 ; sys_bind
 syscall
 mov edi, ebx
 mov esi, 5
 mov eax, 50 ; sys_listen
 syscall
listen:
 mov edi, ebx
 lea rsi, [rel addr]
 lea rdx, [rel size]
 mov eax, 43 ; sys_accept
 syscall
 mov ebp, eax
 mov edi, eax
 lea rsi, [buffer]
 mov edx, 0xFF
 xor eax, eax ; sys_read
 syscall
 lea r8, [buffer]
 add r8, rax
 mov byte [r8], 0
 mov edi, 1
 lea rsi, [buffer]
 mov edx, eax
 mov eax, 1
 syscall
 mov edi, ebp
 lea rsi, [reply]
 mov edx, 17
 mov eax, 1
 syscall ; sys_write
exit:
 mov edi, ebp
 mov esi, 1  ; SHUT_WR
 mov eax, 48 ; sys_shutdown
 syscall
 mov edi, ebp
 mov esi, 0  ; SHUT_RD
 mov eax, 48 ; sys_shutdown
 syscall
 mov edi, ebp
 mov eax, 3  ; sys_close
 syscall
 jmp listen

data:
 align 0x04, db 0
 buffer times 0x100 db 0
 true dd 1
 size dd 0x10
 addr:
  dw 0x02 ; IPV4
  db 3721 >> 8, 3721 & 0xFF
  dd 0, 0, 0
 reply db 'Message received', 10
progend:
