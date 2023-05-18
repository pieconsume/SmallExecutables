defs:
 [BITS 64]
 [DEFAULT REL]
 [ORG 0]
elf:
 dd 0x464C457F
 db 0x02, 0x01, 0x01, 0x00, 0x00, 0, 0, 0, 0, 0, 0, 0
 dw 0x0003, 0x003E, 0x0001, 0x0000
 dq _start, proghead, 0
 dw 0, 0, 0x0040, 0x0038, 0x0004, 0, 0, 0
proghead:
 dd 0x06, 0x04
 dq proghead, proghead, proghead, proghead.end-proghead, proghead.end-proghead, 0x08
 dd 0x01, 0x07
 dq 0, 0, 0, progend, progend, 0x1000
 dd 0x02, 0x06
 dq dynamic, dynamic, dynamic, dynamic.end-dynamic, dynamic.end-dynamic, 0x08
 dd 0x03, 0x04
 dq interp, interp, interp, interp.end-interp, interp.end-interp, 0x01
 proghead.end:
dynamic:
 dq 0x01, libcstr-dynstr
 dq 0x05, dynstr
 dq 0x06, dynsym
 dq 0x07, reloc
 dq 0x08, reloc.end-reloc
 dq 0x09, 0x18
 dq 0x0A, dynstr.end-dynstr
 dq 0x0B, 0x18
 dq 0, 0
 dynamic.end:
dynsym:
 startsym  dd startstr-dynstr, 0x12, 0, 0, 0, 0
 printfsym dd printfstr-dynstr, 0x12, 0, 0, 0, 0
 dynsym.end:
reloc:
 dd __libc_start_main, 0, 0x06, (startsym-dynsym)/0x18, 0, 0
 dd printf, 0, 0x06, (printfsym-dynsym)/0x18, 0, 0
 reloc.end:
interp:
 db '/lib64/ld-linux-x86-64.so.2', 0
 interp.end:
dynstr:
 db 0
 startstr  db '__libc_start_main', 0
 printfstr db 'printf', 0
 libcstr   db 'libc.so.6', 0
 dynstr.end:

_start:
 xor ebp, ebp
 mov r9, rdx
 pop rsi
 mov rdx, rsp
 and rsp, 0xFFFFFFFFFFFFFFF0
 push rax
 push rsp
 lea r8, [stub]
 lea rcx, [stub]
 lea rdi, [main]
 call [__libc_start_main]
stub:
 ret
main:
 sub rsp, 8
 lea rdi, [hello]
 call [printf]
 mov eax, 60
 syscall
 hello db 'hello!', 10, 0

rels:
 __libc_start_main dq 0
 printf dq 0
progend: