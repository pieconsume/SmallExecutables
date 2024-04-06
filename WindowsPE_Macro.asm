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
  dd 0,0,0              ;Sizes (Irrelevant)
  dd 0x1000,0x1000      ;Entry point, base of code
  dq 0x0000000000400000 ;Base of image
  dd 0x1000,0x200       ;Section alignment, file alignment
  dw 6,0,0,0,6,0,0,0    ;Versions
  dd 0x2000             ;Size of image
  dd 0x200              ;Size of headers
  dw 0,0,3,0x8140       ;Checksum, subsystem, DLL characteristics
  dq 0x10000,0x1000     ;Stack reserve/commit
  dq 0x10000,0x1000     ;Heap reserve/commit
  dd 0,(rva.end-rva)/8  ;Loader flags, RVA count
 rva:
  dq 0
  dd 0x1000+importtable-text ;Import table
  dd importtable.end-importtable
  times 0x0A dq 0
  dd 0x1000+importaddr-text ;Import address table
  dd importaddr.end-importaddr
  rva.end:
 sections:
  db '.text', 0, 0, 0   ;Name
  dd end-text           ;Virtual size
  dd 0x1000,0x200,text  ;Virtal address, size of raw data, pointer to raw data
  dd 0,0,0              ;Line numbers, relocations
  dd 0xE0000020         ;Characteristics (executable code, read/exec)
  pe.end:
  times 0x200-(pe.end-stub) db 0
text:
 sub rsp,56
 mov ecx,-11
 call [GetStdHandle] ;GetStdHandle
 mov [stdin],eax
 mov ecx,[stdin]
 lea rdx,[hello]
 mov r8d,8
 xor r9d,r9d
 mov qword [rsp-0x56],0
 call [WriteConsoleA] ;WriteConsoleA
 call [ExitProcess] ;ExitProcess
data:
 stdin dd 0
 hello db 'hello!!', 10
 imports:
  %assign libcount 0
  %macro addlib 1
   %define lib%[libcount] %1   ;Define the library as the string
   %assign funcs%[libcount] 0  ;Define the function count for the library
   %assign libcount libcount+1 ;Increment the library count
   %endmacro
  %macro import 2
   %define lib%[%2]_func%[funcs%[%2]] %1 ;Assign libx_funcx as the string
   %assign funcs%[%2] funcs%[%2]+1      ;Increment the function count for the library
   %endmacro
  addlib "Kernel32.dll" ;0x00
  import GetStdHandle, 0
  import WriteConsoleA,0
  import ExitProcess,  0
  names:
   %assign libidx 0
   %rep libcount
    %assign libstr%[libidx] 0x1000+$-text              ;Assign the address of the library string
    db lib%[libidx],0                                  ;Store the library string
    %assign funcidx 0                                  ;Reset the function index
    %rep funcs%[libidx]
     %assign funcstr%[libidx]_%[funcidx] 0x1000+$-text ;Assign the address of the function string
     %defstr store lib%[libidx]_func%[funcidx]
     db 0,0,store,0                                    ;Store the function string
     %assign funcidx funcidx+1                         ;Advance to the next function
     %endrep
    %assign libidx libidx+1                            ;Advance to the next library
    %endrep
   names.end:
  importaddr:
   %assign libidx 0
   %rep libcount
    %assign importaddr%[libidx] 0x1000+$-text ;Assign the address of the import table
    %assign funcidx 0                      ;Reset the function index
    %rep funcs%[libidx]
     %[lib%[libidx]_func%[funcidx]]:       ;Create the label for the function
     dq funcstr%[libidx]_%[funcidx]        ;Store the address of the function string
     %assign funcidx funcidx+1             ;Advance to the next function
     %endrep
    dq 0                                   ;Store the zero terminater
    %assign libidx libidx+1                ;Advance to the next library
    %endrep
   importaddr.end:
  importlook:
   %assign libidx 0
   %rep libcount
    %assign importlook%[libidx] 0x1000+$-text ;Assign the address of the import table
    %assign funcidx 0                      ;Reset the function index
    %rep funcs%[libidx]
     dq funcstr%[libidx]_%[funcidx]        ;Store the address of the function string
     %assign funcidx funcidx+1             ;Advance to the next function
     %endrep
    dq 0                                   ;Store the zero terminater
    %assign libidx libidx+1                ;Advance to the next library
    %endrep
   importlook.end:
  importtable:
   %assign libidx 0
   %rep libcount
    dd importlook%[libidx] ;Store the address of the import lookup table
    dd 0,0                 ;Store the timestamp and forwarder chain
    dd libstr%[libidx]     ;Store the address of the library string
    dd importaddr%[libidx] ;Store the address of the import address table
    %endrep
   times 0x14 db 0         ;Store the zero terminator
   importtable.end:
end:
 times 0x200-(end-text) db 0