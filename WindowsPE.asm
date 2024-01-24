[BITS 64]
[DEFAULT REL]
headers:
 stub:
  dw 0x5A4D             ;Magic "MZ"
  times 0x3A db 0       ;Unused values
  dd pe                 ;PE Offset
 pe:
  dw 0x4550,0,0x8664,1  ;Magic, machine, sections
  dd 0,0,0              ;Timestamp, symbol table pointer
  dw rva.end-optional,2 ;Size of optional header, characteristics
  optional:
  db 0x0B,0x02,0x0E,0x1D;Magic, link versions
  dd 0,0,0,0x1000,0x1000;Sizes, entry point, base of code
  dq 0x0000000000400000 ;Base of image
  dd 0x1000,0x200       ;Section alignment, file alignment
  dw 6,0,0,0,6,0,0,0    ;Versions
  dd 0x2000,0x200       ;Size of image, size of headers
  dw 0,0,3,0x8140       ;Checksum, subsystem, DLL characteristics
  dq 0x10000,0x1000     ;Stack reserve/commit
  dq 0x10000,0x1000     ;Heap reserve/commit
  dd 0,13               ;Loader flags, RVA count
 rva:
  dq 0
  dd 0x1000+import-text     ;Import table
  dd import.end-import
  times 0x0A dq 0
  dd 0x1000+importaddr-text ;Import address table
  dd importaddr.end-importaddr
  rva.end:
 sections:
  db '.text', 0, 0, 0   ;Name
  dd text.end-text      ;Virtual size
  dd 0x1000,0x200,text  ;Virtal address, size of raw data, pointer to raw data
  dd 0,0,0              ;Line numbers, relocations
  dd 0xE0000020         ;Characteristics (executable code, read/exec)
  pe.end:
  times 0x200-(pe.end-stub) db 0
text:
 sub rsp,56
 mov ecx,-11
 call [importaddr+0x10]
 mov [stdin],eax
 mov ecx,[stdin]
 lea rdx,[hello]
 mov r8d,8
 xor r9d,r9d
 mov qword [rsp-0x56],0
 call [importaddr+0x00]
 call [importaddr+0x08]
data:
 stdin dd 0
 hello db 'hello!!', 10
 importaddr:
  dq 0x1000+writeconsolea-text ;0x600 WriteConsoleA
  dq 0x1000+exitprocess-text   ;0x608 ExitProcess
  dq 0x1000+getstdhandle-text  ;0x610 GetStdHandle
  dq 0x0000000000000000        ;0x618 Padding / terminator
  importaddr.end:
 import:
  dd 0x1000+importlookup-text ;0x730 Import lookup table RVA
  dd 0x00000000               ;0x734 Timestamp
  dd 0x00000000               ;0x738 Forwarder chain
  dd 0x1000+kernel32-text     ;0x73C Name RVA
  dd 0x1000+importaddr-text   ;0x740 Import address table rva
  times 0x14 db 0             ;0x744 Terminator
  import.end:
 importlookup:
  dq 0x1000+writeconsolea-text ;0x758 WriteConsoleA
  dq 0x1000+exitprocess-text   ;0x760 ExitProcess
  dq 0x1000+getstdhandle-text  ;0x768 GetStdHandle
  dq 0x0000000000000000        ;0x770 Terminator
 names:
  getstdhandle:  db 0, 0, 'GetStdHandle', 0, 0
  writeconsolea: db 0, 0, 'WriteConsoleA', 0
  exitprocess:   db 0, 0, 'ExitProcess', 0
  kernel32       db 'Kernel32.dll', 0
 text.end:
 times 0x200-(text.end-text) db 0