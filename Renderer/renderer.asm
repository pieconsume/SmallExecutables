defs:
 [BITS 64]
 [DEFAULT REL]
 [ORG 0]
 ; Since the file headers are loaded into memory their space can be reused
 ; rbp+x is used for slightly smaller encoding, (see x86-64 ModRM encoding) although this may very slightly decrease efficiency, and is a bit ugly.
 %define off(x) [rbp+(x-middle)]
 %define glfwInit                  0x0000
 %define glfwWindowHint            0x0008
 %define glfwCreateWindow          0x0010
 %define glfwMakeContextCurrent    0x0018
 %define glfwSetWindowSizeCallback 0x0020
 %define glfwSetKeyCallback        0x0028
 %define glfwSwapBuffers           0x0030
 %define glfwPollEvents            0x0038
 %define glfwWindowShouldClose     0x0040
 %define glfwTerminate             0x0048
 %define glGenVertexArrays         0x0050
 %define glGenBuffers              0x0058
 %define glBindVertexArray         0x0060
 %define glBufferData              0x0068
 %define glEnableVertexAttribArray 0x0070
 %define glVertexAttribPointer     0x0078
 %define glCreateShader            0x0080
 %define glShaderSource            0x0088
 %define glCompileShader           0x0090
 %define glBindBuffer              0x0098
 %define glCreateProgram           0x00A0
 %define glAttachShader            0x00A8
 %define glLinkProgram             0x00B0
 %define glUseProgram              0x00B8
 %define glDetachShader            0x00C0
 %define glDeleteShader            0x00C8
 %define glGetUniformLocation      0x00D0
 %define glViewport                0x00D8
 %define glClear                   0x00E0
 %define glDrawElements            0x00E8
 %define glfwGetKey                0x00F0
 %define glUniform2fv              0x00F8
 %define glUniform3fv              0x0100
 %define window                    $$+0x0108 ; 8 bytes
 %define vao                       $$+0x0110 ; 4
 %define vbo                       $$+0x0114 ; 4 
 %define ebo                       $$+0x0118 ; 4
 %define shader                    $$+0x011C ; 4
 %define uni.res                   $$+0x0120 ; 4
 %define uni.loc                   $$+0x0124 ; 4
 %define uni.cam                   $$+0x0128 ; 4
 %define res                       $$+0x012C ; 8
 %define loc                       $$+0x0134 ; 12
 %define cam                       $$+0x0140 ; 8
 %define vertices                  $$+0x0148 ; 96
 %define vertices.size             96
elf:
 dd 0x464C457F
 db 0x02, 0x01, 0x01, 0x00, 0x00
 times 0x07 db 0
 dw 0x0003, 0x003E, 0x0001, 0x0000
 dq vertgen, proghead, 0
 dw 0, 0, 0x0040, 0x0038, 0x0004, 0, 0, 0
 proghead:
 dd 0x06, 0x04
 dq proghead, proghead, proghead, proghead.end-proghead, proghead.end-proghead, 0x08
 dd 0x01, 0x07
 dq 0, 0, 0, progend, progend, 0x1000
 dd 0x02, 0x06
 dq dynamic, dynamic, dynamic, dynamic.end-dynamic, dynamic.end-dynamic, 0x08
 dd 0x03, 0x04
 dq interp, interp, interp.end-interp, interp.end-interp, interp.end-interp, 0x01
 proghead.end:
dynamic:
 dq 0x01, lglfw-dynstr
 dq 0x01, lgl-dynstr
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
 sglfwinit dd fglfwinit-dynstr, 0x12, 0, 0, 0, 0
 sglfwwinh dd fglfwwinh-dynstr, 0x12, 0, 0, 0, 0
 sglfwcwin dd fglfwcwin-dynstr, 0x12, 0, 0, 0, 0
 sglfwmkcc dd fglfwmkcc-dynstr, 0x12, 0, 0, 0, 0
 sglfwskcb dd fglfwskcb-dynstr, 0x12, 0, 0, 0, 0
 sglfwwnsc dd fglfwwnsc-dynstr, 0x12, 0, 0, 0, 0
 sglfwwscb dd fglfwwscb-dynstr, 0x12, 0, 0, 0, 0
 sglfwgetk dd fglfwgetk-dynstr, 0x12, 0, 0, 0, 0
 sglfwswpb dd fglfwswpb-dynstr, 0x12, 0, 0, 0, 0
 sglfwplev dd fglfwplev-dynstr, 0x12, 0, 0, 0, 0
 sglfwterm dd fglfwterm-dynstr, 0x12, 0, 0, 0, 0
 sglgenvao dd fglgenvao-dynstr, 0x12, 0, 0, 0, 0
 sglgenvbo dd fglgenvbo-dynstr, 0x12, 0, 0, 0, 0
 sglbndvao dd fglbndvao-dynstr, 0x12, 0, 0, 0, 0
 sglbndvbo dd fglbndvbo-dynstr, 0x12, 0, 0, 0, 0
 sglbfrdat dd fglbfrdat-dynstr, 0x12, 0, 0, 0, 0
 sglenbatt dd fglenbatt-dynstr, 0x12, 0, 0, 0, 0
 sglvafptr dd fglvafptr-dynstr, 0x12, 0, 0, 0, 0
 sglmkshdr dd fglmkshdr-dynstr, 0x12, 0, 0, 0, 0
 sglshdsrc dd fglshdsrc-dynstr, 0x12, 0, 0, 0, 0
 sglcmpshd dd fglcmpshd-dynstr, 0x12, 0, 0, 0, 0
 sglmkprog dd fglmkprog-dynstr, 0x12, 0, 0, 0, 0
 sglatshdr dd fglatshdr-dynstr, 0x12, 0, 0, 0, 0
 sgllnkprg dd fgllnkprg-dynstr, 0x12, 0, 0, 0, 0
 sgluseprg dd fgluseprg-dynstr, 0x12, 0, 0, 0, 0
 sgldtshdr dd fgldtshdr-dynstr, 0x12, 0, 0, 0, 0
 sgldlshdr dd fgldlshdr-dynstr, 0x12, 0, 0, 0, 0
 sgluniloc dd fgluniloc-dynstr, 0x12, 0, 0, 0, 0
 sglviewpt dd fglviewpt-dynstr, 0x12, 0, 0, 0, 0
 sglclearf dd fglclearf-dynstr, 0x12, 0, 0, 0, 0
 sgldrwarr dd fgldrwarr-dynstr, 0x12, 0, 0, 0, 0
 sglunivc2 dd fglunivc2-dynstr, 0x12, 0, 0, 0, 0
 sglunivc3 dd fglunivc3-dynstr, 0x12, 0, 0, 0, 0
 dynsym.end:
reloc:
 dd glfwInit,                  0, 0x06, (sglfwinit-dynsym)/0x18, 0, 0
 dd glfwWindowHint,            0, 0x06, (sglfwwinh-dynsym)/0x18, 0, 0
 dd glfwCreateWindow,          0, 0x06, (sglfwcwin-dynsym)/0x18, 0, 0
 dd glfwMakeContextCurrent,    0, 0x06, (sglfwmkcc-dynsym)/0x18, 0, 0
 dd glfwWindowShouldClose,     0, 0x06, (sglfwwnsc-dynsym)/0x18, 0, 0
 dd glfwSetWindowSizeCallback, 0, 0x06, (sglfwwscb-dynsym)/0x18, 0, 0
 dd glfwSetKeyCallback,        0, 0x06, (sglfwskcb-dynsym)/0x18, 0, 0
 dd glfwGetKey,                0, 0x06, (sglfwgetk-dynsym)/0x18, 0, 0
 dd glfwSwapBuffers,           0, 0x06, (sglfwswpb-dynsym)/0x18, 0, 0
 dd glfwPollEvents,            0, 0x06, (sglfwplev-dynsym)/0x18, 0, 0
 dd glfwTerminate,             0, 0x06, (sglfwterm-dynsym)/0x18, 0, 0
 dd glGenVertexArrays,         0, 0x06, (sglgenvao-dynsym)/0x18, 0, 0
 dd glGenBuffers,              0, 0x06, (sglgenvbo-dynsym)/0x18, 0, 0
 dd glBindVertexArray,         0, 0x06, (sglbndvao-dynsym)/0x18, 0, 0
 dd glBindBuffer,              0, 0x06, (sglbndvbo-dynsym)/0x18, 0, 0
 dd glBufferData,              0, 0x06, (sglbfrdat-dynsym)/0x18, 0, 0
 dd glEnableVertexAttribArray, 0, 0x06, (sglenbatt-dynsym)/0x18, 0, 0
 dd glVertexAttribPointer,     0, 0x06, (sglvafptr-dynsym)/0x18, 0, 0
 dd glCreateShader,            0, 0x06, (sglmkshdr-dynsym)/0x18, 0, 0
 dd glShaderSource,            0, 0x06, (sglshdsrc-dynsym)/0x18, 0, 0
 dd glCompileShader,           0, 0x06, (sglcmpshd-dynsym)/0x18, 0, 0
 dd glCreateProgram,           0, 0x06, (sglmkprog-dynsym)/0x18, 0, 0
 dd glAttachShader,            0, 0x06, (sglatshdr-dynsym)/0x18, 0, 0
 dd glLinkProgram,             0, 0x06, (sgllnkprg-dynsym)/0x18, 0, 0
 dd glUseProgram,              0, 0x06, (sgluseprg-dynsym)/0x18, 0, 0
 dd glDetachShader,            0, 0x06, (sgldtshdr-dynsym)/0x18, 0, 0
 dd glDeleteShader,            0, 0x06, (sgldlshdr-dynsym)/0x18, 0, 0
 dd glGetUniformLocation,      0, 0x06, (sgluniloc-dynsym)/0x18, 0, 0
 dd glViewport,                0, 0x06, (sglviewpt-dynsym)/0x18, 0, 0
 dd glClear,                   0, 0x06, (sglclearf-dynsym)/0x18, 0, 0
 dd glDrawElements,            0, 0x06, (sgldrwarr-dynsym)/0x18, 0, 0
 dd glUniform2fv,              0, 0x06, (sglunivc2-dynsym)/0x18, 0, 0
 dd glUniform3fv,              0, 0x06, (sglunivc3-dynsym)/0x18, 0, 0
 reloc.end:
interp:
 db '/lib64/ld-linux-x86-64.so.2', 0
 interp.end:
dynstr:
 lglfw     db 'libglfw.so', 0
 lgl       db 'libGL.so', 0
 fglfwinit db 'glfwInit', 0
 fglfwwinh db 'glfwWindowHint', 0
 fglfwcwin db 'glfwCreateWindow', 0
 fglfwmkcc db 'glfwMakeContextCurrent', 0
 fglfwwnsc db 'glfwWindowShouldClose', 0
 fglfwskcb db 'glfwSetKeyCallback', 0
 fglfwwscb db 'glfwSetWindowSizeCallback', 0
 fglfwgetk db 'glfwGetKey', 0
 fglfwswpb db 'glfwSwapBuffers', 0
 fglfwplev db 'glfwPollEvents', 0
 fglfwterm db 'glfwTerminate', 0
 fglgenvao db 'glGenVertexArrays', 0
 fglgenvbo db 'glGenBuffers', 0
 fglbndvao db 'glBindVertexArray', 0
 fglbndvbo db 'glBindBuffer', 0
 fglbfrdat db 'glBufferData', 0
 fglenbatt db 'glEnableVertexAttribArray', 0
 fglvafptr db 'glVertexAttribPointer', 0
 fglmkshdr db 'glCreateShader', 0
 fglshdsrc db 'glShaderSource', 0
 fglmkprog db 'glCreateProgram', 0
 fglcmpshd db 'glCompileShader', 0
 fglatshdr db 'glAttachShader', 0
 fgllnkprg db 'glLinkProgram', 0
 fgluseprg db 'glUseProgram', 0
 fgldtshdr db 'glDetachShader', 0
 fgldlshdr db 'glDeleteShader', 0
 fgluniloc db 'glGetUniformLocation', 0
 fglviewpt db 'glViewport', 0
 fglclearf db 'glClear', 0
 fgldrwarr db 'glDrawElements', 0
 fglunivc2 db 'glUniform2fv', 0
 fglunivc3 db 'glUniform3fv', 0
 dynstr.end:

vertgen:
 mov eax, 0b011111110010001101100000 << 1
 mov ecx, 24
 lea rdi, [vertices-4]
 mov ebx, [ndot5]
 mov edx, [dot5]
 vertgenloop:
  add rdi, 4
  mov [rdi], ebx
  shr eax, 1
  test al, 1
  jnz pos
  mov [rdi], edx
  pos: loop vertgenloop
wininit:
 %define middle (glfwWindowHint)
 lea rbp, [$$+glfwWindowHint]
 call off(glfwInit)
 mov edi, 0x22002 ; Context major
 mov esi, 4
 call off(glfwWindowHint)
 mov edi, 0x22003 ; Context minor
 mov esi, 5
 call off(glfwWindowHint)
 mov edi, 0x22006 ; Forward compat
 mov esi, 1
 call off(glfwWindowHint)
 mov edi, 0x22008 ; Profile
 mov esi, 0x32001 ; Core profile
 call off(glfwWindowHint)
 mov edi, 1600
 mov esi, 900
 lea rdx, [str.winname]
 xor ecx, ecx
 xor r8d, r8d
 call off(glfwCreateWindow)
 mov [window], rax
 mov rbx, rax
 mov rdi, rax
 call off(glfwMakeContextCurrent)
 mov rdi, rbx
 lea rsi, [resize]
 call off(glfwSetWindowSizeCallback)
 mov rdi, rbx
 lea rsi, [keypress]
 call off(glfwSetKeyCallback)
bufinit:
 %define middle glBindBuffer
 lea rbp, [$$+glBindBuffer]
 mov edi, 1
 lea rsi, [vao]
 call off(glGenVertexArrays)
 mov edi, 2
 lea rsi, [vbo]
 call off(glGenBuffers)
 mov edi, [vao]
 call off(glBindVertexArray)
 mov edi, 0x8892 ; Array buffer
 mov esi, [vbo]
 call off(glBindBuffer)
 mov edi, 0x8892
 mov esi, vertices.size
 lea rdx, [vertices]
 mov ecx, 0x88E4 ; Static draw
 call off(glBufferData)
 mov edi, 0x8893 ; GL_ELEMENT_ARRAY_BUFFER
 mov esi, [ebo]
 call off(glBindBuffer)
 mov edi, 0x8893
 mov esi, elements.end-elements
 lea rdx, [elements]
 mov ecx, 0x88E4 ; GL_STATIC_DRAW
 call off(glBufferData)
 xor edi, edi
 mov esi, 3
 mov edx, 0x1406 ; Float
 xor ecx, ecx
 mov r8d, 12
 xor r9d, r9d
 call off(glVertexAttribPointer)
 xor edi, edi
 call off(glEnableVertexAttribArray)
shdinit:
 mov edi, 0x8B31 ; Vertex shader
 call off(glCreateShader)
 mov ebx, eax
 mov edi, eax
 mov esi, 1
 lea rax, [vertshader]
 mov [rsp], rax
 mov rdx, rsp
 xor ecx, ecx
 call off(glShaderSource)
 mov edi, ebx
 call off(glCompileShader)
 mov edi, 0x8B30
 call off(glCreateShader)
 mov r12d, eax
 mov edi, eax
 mov esi, 1
 lea rax, [fragshader]
 mov [rsp], rax
 mov rdx, rsp
 xor ecx, ecx
 call off(glShaderSource)
 mov edi, r12d
 call off(glCompileShader)
 call off(glCreateProgram)
 mov [shader], eax
 mov r13d, eax
 mov edi, eax
 mov esi, ebx
 call off(glAttachShader)
 mov edi, r13d
 mov esi, r12d
 call off(glAttachShader)
 mov edi, r13d
 call off(glLinkProgram)
 mov edi, r13d
 call off(glUseProgram)
 mov edi, r13d
 mov esi, ebx
 call off(glDetachShader)
 mov edi, r13d
 mov esi, r12d
 call off(glDetachShader)
 mov edi, ebx
 call off(glDeleteShader)
 mov edi, r12d
 call off(glDeleteShader)
uniinit:
 mov edi, [shader]
 lea rsi, [str.res]
 call off(glGetUniformLocation)
 mov [uni.res], eax
 mov edi, [shader]
 lea rsi, [str.loc]
 call off(glGetUniformLocation)
 mov [uni.loc], eax
 mov edi, [shader]
 lea rsi, [str.cam]
 call off(glGetUniformLocation)
 mov [uni.cam], eax
preloop:
 mov rbx, [window]
renloop:
 mov edi, 0x4000
 call off(glClear)
 keydowns:
  lea r12, [keytab]
  xor r13d, r13d
  keyloop:
  xor esi, esi
  mov rdi, rbx
  mov si, [r12]
  call off(glfwGetKey)
  test al, 1
  jnz keydown
  keyloopr:
  add r12, 2
  inc r13d
  cmp r13d, 10 
  jne keyloop
 mov edi, 0x0001 ; GL_LINES
 mov esi, elements.end-elements
 mov edx, 0x1401
 xor r10d, r10d
 call off(glDrawElements)
 mov rdi, rbx
 call off(glfwSwapBuffers)
 mov rdi, rbx
 call off(glfwPollEvents)
 mov rdi, rbx
 call off(glfwWindowShouldClose)
 test al, 1
 jz renloop
 jmp exit
events:
 resize:
  push rbx
  lea rbx, [res]
  mov [rbx], esi
  mov [rbx+4], edx
  mov ecx, edx
  mov edx, esi
  xor edi, edi
  xor esi, esi
  call [$$+glViewport]
  cvtsi2ss xmm0, [rbx]
  movss [rbx], xmm0
  cvtsi2ss xmm1, [rbx+4]
  movss [rbx+4], xmm1
  mov edi, [uni.res]
  mov esi, 1
  mov rdx, rbx
  call [$$+glUniform2fv]
  pop rbx
  ret
 keypress:
  cmp si, 256
  je exit
  ret
 keydown:
  lea rax, [settab]
  add rax, r13
  mov al, [rax]
  test al, 0b11
  jz movexz
  test al, 0b10
  jz movey
  jmp rotate
  movexz:
   movss xmm0, [ndot001]
   movss xmm1, [ndot001]
   lea rcx, [loc]
   lea rdx, [loc+8]
   test al, 0b100
   jz movexzn0
   movss xmm0, [dot001]
   movexzn0:
   test al, 0b1000
   jz movexzn1
   movss xmm1, [dot001]
   movexzn1:
   test al, 0b10000
   jz movexzs
   xchg rcx, rdx
   movexzs:
   fld dword [cam+4]
   fsincos
   fstp dword [rsp-4]
   fstp dword [rsp-8]
   mulss xmm0, [rsp-4]
   addss xmm0, [rcx]
   movss [rcx], xmm0
   mulss xmm1, [rsp-8]
   addss xmm1, [rdx]
   movss [rdx], xmm1
   mov edi, [uni.loc]
   mov esi, 1
   lea rdx, [loc]
   call off(glUniform3fv)
   jmp keyloopr
  movey:
   movss xmm0, [ndot001]
   test al, 0b100
   jz moveyn
   movss xmm0, [dot001]
   moveyn:
   addss xmm0, [loc+4]
   movss [loc+4], xmm0
   mov edi, [uni.loc]
   mov esi, 1
   lea rdx, [loc]
   call off(glUniform3fv)
   jmp keyloopr
  rotate:
   movss xmm0, [ndot001]
   lea rcx, [cam]
   test al, 0b100
   jz rotaten
   movss xmm0, [dot001]
   rotaten:
   test al, 0b1000
   jz rotatex
   add rcx, 4
   rotatex:
   addss xmm0, [rcx]
   movss [rcx], xmm0
   mov edi, [uni.cam]
   mov esi, 1
   lea rdx, [cam]
   call off(glUniform2fv)
   jmp keyloopr
exit:
 pop rax ; Align stack before terminating
 call [$$+glfwTerminate]
 mov eax, 60 ; sys_exit
 syscall

data:
 dot001  dd +0.001
 ndot001 dd -0.001
 dot5    dd +0.5
 ndot5   dd -0.5
 ;         SP  A   D   S   W   Rgt  Lft  Dwn  Up   LSh
 keytab dw 32, 65, 68, 83, 87, 262, 263, 264, 265, 340
 settab db 0b101, 0b00000, 0b01100, 0b11000, 0b10100, 0b1010, 0b1110, 0b0010, 0b0110, 0b001
 elements:
  db 0, 1
  db 1, 2
  db 2, 3
  db 3, 0
  db 4, 5
  db 5, 6
  db 6, 7
  db 7, 4
  db 0, 4
  db 1, 5
  db 2, 6
  db 3, 7
  elements.end:
 str.winname   db 'Scumpert!!', 0
 str.res       db 'r', 0
 str.loc       db 'l', 0
 str.cam       db 'c', 0
 vertshader incbin "vertshader.txt"
 db 0
 fragshader incbin "fragshader.txt"
 db 0
progend: