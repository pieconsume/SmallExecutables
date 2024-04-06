;Defs
 [BITS 64]
 [DEFAULT REL]
 %assign libcount 0
 %ifidn platform, win64
  %macro addlib 1
   %define lib%[libcount] %1   ;Define the library as the string
   %assign funcs%[libcount] 0  ;Define the function count for the library
   %assign libcount libcount+1 ;Increment the library count
   %endmacro
  %macro import 2
   %define lib%[%2]_func%[funcs%[%2]] %1 ;Assign libx_funcx as the string
   %assign funcs%[%2] funcs%[%2]+1      ;Increment the function count for the library
   %endmacro
  %macro fnent 0
   call util_push
   sub rsp,0x20
   %endmacro
  %macro fnret 0
   add rsp,0x20
   jmp util_pop
   %endmacro
  ;Registers
   %define p0 rcx
   %define p1 rdx
   %define p2 r8
   %define p3 r9
   %define p4 qword [rsp+0x20]
   %define p5 qword [rsp+0x28]
   %define r0 rax
   %define p0d ecx
   %define p1d edx
   %define p2d r8d
   %define p3d r9d
   %define r0d eax
   %define p0w cx
   %define p1w dx
   %define p2w r8
   %define p3w r9
   %define r0w ax
   %define p0b cl
   %define p1b dl
   %define p2b r8b
   %define p3b r9b
   %define r0b al
  %endif
 %ifidn platform, linux
  %assign libcount 0
  %assign funccount 0
  %macro addlib 1
   %define lib%[libcount] %1
   %assign libcount libcount+1
   %endmacro
  %macro import 2
   %define func%[funccount] %1
   %assign funccount funccount+1
   %endmacro
  ;Registers
   %define p0 rdi
   %define p1 rsi
   %define p2 rdx
   %define p3 rcx
   %define p4 r8
   %define p5 r9
   %define r0 rax
   %define p0d edi
   %define p1d esi
   %define p2d edx
   %define p3d ecx
   %define r0d eax
   %define p0w di
   %define p1w si
   %define p2w dx
   %define p3w cx
   %define r0w ax
   %define p0b dil
   %define p1b sil
   %define p2b dl
   %define p3b cl
   %define r0b al
  %macro fnent 0
   call util_push
   sub rsp,0x08
   %endmacro
  %macro fnret 0
   add rsp,0x08
   jmp util_pop
   %endmacro
  %endif
;Imports
 %ifidn platform, win64
  addlib "msvcr120.dll" ;0x00
  %endif
 %ifidn platform, linux
  addlib "libc.so.6"    ;0x00
  %endif
 import printf,0
 import exit,0
headers:
 %ifidn platform, win64
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
   dd 0,0,0              ;Sizes (Irrelevant)
   dd 0x1000,0x1000      ;Entry point, base of code
   dq 0x0000000000400000 ;Base of image
   dd 0x1000,0x200       ;Section alignment, file alignment
   dw 6,0,0,0,6,0,0,0    ;Versions
   dd 0x1000+(end-main)  ;Size of image
   dd 0x200              ;Size of headers
   dw 0,0,3,0x8140       ;Checksum, subsystem, DLL characteristics
   dq 0x10000,0x1000     ;Stack reserve/commit
   dq 0x10000,0x1000     ;Heap reserve/commit
   dd 0,(rva.end-rva)/8  ;Loader flags, RVA count
  rva:
   dq 0
   dd 0x1000+importtable-main ;Import table
   dd importtable.end-importtable
   times 0x0A dq 0
   dd 0x1000+importaddr-main ;Import address table
   dd importaddr.end-importaddr
   rva.end:
  sections:
   db '.text', 0, 0, 0     ;Name
   dd end-main             ;Virtual size
   dd 0x1000,end-main,main ;Virtal address, size of raw data, pointer to raw data
   dd 0,0,0                ;Line numbers, relocations
   dd 0xE0000020           ;Characteristics (executable code, read/exec)
   pe.end:
   times 0x200-(pe.end-stub) db 0
  %endif
 %ifidn platform, linux
  %assign funcidx 0
  %rep funccount
   %defstr funcname%[funcidx] %[func%[funcidx]]
   %define %[func%[funcidx]] $$+%[funcidx]*8
   %assign funcidx funcidx+1
   %endrep
  elf:
   dd 0x464C457F
   db 0x02,0x01,0x01,0x00,0x00,0,0,0,0,0,0,0
   dw 0x0003,0x003E,0x0001,0x0000
   dq main,proghead,0
   dw 0,0,0x0040,0x0038,0x0004,0,0,0
  proghead:
   dd 0x06,0x04
   dq proghead,proghead,proghead,proghead.end-proghead,proghead.end-proghead,0x08
   dd 0x01,0x07
   dq 0,0,0,end,end,0x1000
   dd 0x02,0x06
   dq dynamic,dynamic,dynamic,dynamic.end-dynamic,dynamic.end-dynamic,0x08
   dd 0x03,0x04
   dq interp,interp,interp,interp.end-interp,interp.end-interp,0x01
   proghead.end:
  dynamic:
   %assign libidx 0
   %rep libcount
    dq 0x01,libstr%[libidx]-dynstr
    %assign libidx libidx+1
    %endrep
   dq 0x05,dynstr
   dq 0x06,dynsym
   dq 0x07,reloc
   dq 0x08,reloc.end-reloc
   dq 0x09,0x18
   dq 0x0A,dynstr.end-dynstr
   dq 0x0B,0x18
   dq 0,0
   dynamic.end:
  interp:
   db '/lib64/ld-linux-x86-64.so.2',0
   interp.end:
  dynstr:
   %assign libidx 0
   %rep libcount
    libstr%[libidx]:
    db lib%[libidx],0
    %assign libidx libidx+1
    %endrep
   %assign funcidx 0
   %rep funccount
    %assign funcstr%[funcidx] $-$$-(dynstr-$$)
    db funcname%[funcidx],0
    %assign funcidx funcidx+1
    %endrep
  dynstr.end:
  dynsym:
   %assign funcidx 0
   %rep funccount
   %assign funcsym%[funcidx] $-$$
   dd funcstr%[funcidx],0x12,0,0,0,0
   %assign funcidx funcidx+1
   %endrep  
   dynsym.end:
  reloc:
   %assign funcidx 0
   %rep funccount
   dd func%[funcidx],0,0x06,(funcsym%[funcidx]-(dynsym-$$))/0x18,0,0
   ;%warning funcname%[funcidx] func%[funcidx] funcstr%[funcidx] funcsym%[funcidx]
   %assign funcidx funcidx+1
   %endrep
   reloc.end:
   %endif
main:
 fnent
 lea r0, [hello]
 call [printf]
 xor p0,p0
 call [exit]
funcs:
 util_push:
  xchg rax,[rsp]
  push rbx
  push rcx
  push rdx
  push rdi
  push rsi
  push rbp
  push rax
  mov rax,[rsp+0x38]
  ret
 util_pop:
  pop rbp
  pop rsi
  pop rdi
  pop rdx
  pop rcx
  pop rbx
  pop rax
  ret
data:
 align 0x08, db 0
 hello db 'hello!!',10,0
 %ifidn platform, win64
  names:
   %assign libidx 0
   %rep libcount
    %assign libstr%[libidx] 0x1000+$-main              ;Assign the address of the library string
    db lib%[libidx],0                                  ;Store the library string
    %assign funcidx 0                                  ;Reset the function index
    %rep funcs%[libidx]
     %assign funcstr%[libidx]_%[funcidx] 0x1000+$-main ;Assign the address of the function string
     %defstr store lib%[libidx]_func%[funcidx]
     db 0,0,store,0                                    ;Store the function string
     %assign funcidx funcidx+1                         ;Advance to the next function
     %endrep
    %assign libidx libidx+1                            ;Advance to the next library
    %endrep
   names.end:
  align 0x08, db 0
  importaddr:
   %assign libidx 0
   %rep libcount
    %assign importaddr%[libidx] 0x1000+$-main ;Assign the address of the import table
    %assign funcidx 0                         ;Reset the function index
    %rep funcs%[libidx]
     %[lib%[libidx]_func%[funcidx]]:          ;Create the label for the function
     dq funcstr%[libidx]_%[funcidx]           ;Store the address of the function string
     %assign funcidx funcidx+1                ;Advance to the next function
     %endrep
    dq 0                                      ;Store the zero terminater
    %assign libidx libidx+1                   ;Advance to the next library
    %endrep
   importaddr.end:
  importlook:
   %assign libidx 0
   %rep libcount
    %assign importlook%[libidx] 0x1000+$-main ;Assign the address of the import table
    %assign funcidx 0                         ;Reset the function index
    %rep funcs%[libidx]
     dq funcstr%[libidx]_%[funcidx]           ;Store the address of the function string
     %assign funcidx funcidx+1                ;Advance to the next function
     %endrep
    dq 0                                      ;Store the zero terminater
    %assign libidx libidx+1                   ;Advance to the next library
    %endrep
   importlook.end:
  importtable:
   %assign libidx 0
   %rep libcount
    dd importlook%[libidx] ;Store the address of the import lookup table
    dd 0,0                 ;Store the timestamp and forwarder chain
    dd libstr%[libidx]     ;Store the address of the library string
    dd importaddr%[libidx] ;Store the address of the import address table
    %assign libidx libidx+1
    %endrep
   times 0x14 db 0         ;Store the zero terminator
   importtable.end:
  %endif
end:
 align 0x200, db 0