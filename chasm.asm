; Main module file. Registers the module with PHP.
;
; \author Richard Nusser
; \copyright 2017 Richard Nusser
; \license GPLv3 (see http://www.gnu.org/licenses/)
; \link https://github.com/rinusser/chASM
;

bits 64

extern php_info_print_table_end, php_info_print_table_header, php_info_print_table_start, zend_parse_parameters
extern strpprintf, _emalloc_16, _array_init, add_assoc_bool_ex

%include "cpuflags.asm"


section .text
  ;module startup function
  global zm_startup_chasm
zm_startup_chasm: ;(int type, int module_number)
  mov rax,0 ;return SUCCESS
  ret

  ;module shutdown function
  global zm_shutdown_chasm
zm_shutdown_chasm: ;(int type, int module_number)
  mov rax,0 ;return SUCCESS
  ret

  ;module info function, used in  php -i  and  phpinfo()
  global zm_info_chasm
zm_info_chasm: ;(zend_module_entry *zend_module)
  call php_info_print_table_start
  mov rdi,2
  mov rsi, qword table_text
  mov rdx, qword table_value
  call php_info_print_table_header
  call php_info_print_table_end
  ret

  ;chasm_cpuid() function, returns concatenated edx and ecx cpuid(rax=1) bitfields
  ; * ebx is missing, this function should probably return a complex type like an array or class with all 3 bitfields
  ; * the return value hasn't been checked, there might be issues with endianness
  global zif_chasm_cpuid
zif_chasm_cpuid: ;(void)
  push rdi
  push rsi
  mov rdi,rsi
  mov rsi,0
  call _array_init
  ; TODO: check for success
  pop rsi
  pop rdi
  mov rax,1
  push rdx
  push rcx
  cpuid

  push r13
  push r14
  push r15
  mov r13,rcx
  mov r14,rdx
  mov r15,rsi

  chasm_cpuflags_checkflags_basic
  ;TODO: add eax/ebx info?

  pop r15
  pop r14
  pop r13
  pop rcx
  pop rdx
  ret

  ;chasm_vendorid() function, returns the cpuids vendor id info as a 12-char string
  global zif_chasm_vendorid
zif_chasm_vendorid: ;(void)
  xor rax,rax
  push rbx
  push rcx
  push rdx
  push rsi
  push rdi
  push r13
  push r14
  cpuid
  mov r13,rdx
  sub rsp,8 ;align rsp to 128bit boundary, otherwise strpprintf's xmm stack moves will segfault

  call chasm_get_qword_str
  mov r14,rax ;r14 now contains part 3, e.g. "cAMD"
  mov rcx,rbx
  call chasm_get_qword_str
  mov rbx,rax ;rbx now contains part 1, e.g. "Auth"
  mov rcx,r13
  call chasm_get_qword_str ;rax now contains part 2, e.g. "enti"

  mov r8,r14
  add r8,24 ;zend_string's content starts at offset 24
  mov rdx,rbx
  add rdx,24
  mov rcx,rax
  add rcx,24
  mov rsi,chasm_vendorid_str
  call strpprintf

  add rsp,8 ;reset rsp alignment
  pop r14
  pop r13
  pop rdi
  pop rsi
  mov qword [rsi],rax
  mov qword [rsi+8],6 ;return type string
  pop rdx
  pop rcx
  pop rbx
  ret

  ;internal helper function: reads 4 packed 1-byte characters from ecx and returns them as a 4-character zend_string
chasm_get_qword_str: ;rcx contains value; modifies rdi, rsi, rdx, r8, r9; returns zend_string* in rax
  mov rdi,0
  mov rsi,chasm_vendorid_regstr
  mov rdx,rcx
  mov r8,rcx
  mov r9,rcx
  and rdx,0xff
  shr rcx,8
  and rcx,0xff
  shr r8,16
  and r8,0xff
  shr r9,24
  and r9,0xff
  call strpprintf
  ret

  ;test function: returns number of arguments passed
  global zif_chasm_partest
zif_chasm_partest: ;(...)
  mov eax,dword [rdi+40+4] ;rdi+44 is execute_data->This.u2.num_args
  mov qword [rsi],rax
  mov qword [rsi+8],4 ;return type int
  ret

  ;adding function: adds 2 floats
  global zif_chasm_addf
zif_chasm_addf: ;(float, float)
  ;check if exactly 2 arguments have been passed - return NULL if not
  mov eax,dword [rdi+44]
  cmp rax,2
  je chasm_addf_correct_argc
  mov qword [rsi+8],1 ;return NULL
  ret
  chasm_addf_correct_argc:
  push rsi

  ;reserve 2*8 bytes for 2 floats
  call _emalloc_16
  mov rdx,rax
  mov rcx,rax
  add rcx,8
  push rdx

  ;calling zend_parse_parameters(2, "dd", &float1, &float2)
  mov rdi,2
  mov rsi,chasm_addf_par_spec
  sub rsp,8
  call zend_parse_parameters
  add rsp,8

  ;return NULL if parameters couldn't be parsed
  or rax,rax
  jz chasm_addf_pars_ok
  pop rdx
  pop rsi
  mov qword [rsi+8],1 ;return NULL
  ret

  ;calculate sum of the parameters with SSE2 and return result
  chasm_addf_pars_ok:
  pop rdx
  pop rsi
  movlpd xmm0,qword [rdx]
  addsd xmm0,qword [rdx+8]
  movlpd qword [rsi],xmm0
  mov qword [rsi+8],5
  ret


%macro arginfo 7
  %1 dq %2  ;char *name, or  long req_args  when first arg
  %1.class_name dq %3 ;char *
  %1.type_hint dw %4 ;char
  %1.pass_by_reference dw %5 ;char
  %1.allow_null dw %6 ;bool
  %1.is_variadic dw %7 ;bool
%endmacro

%macro function 6
  chasm_functions.%1.name dq %2 ;char *
  chasm_functions.%1.handler dq %3 ;ptr
  chasm_functions.%1.arginfo dq %4 ;ptr
  chasm_functions.%1.numargs dd %5 ;uint
  chasm_functions.%1.flags dd %6 ;uint
%endmacro


section .data
  arginfo chasm_cpuid_arginfo,0,0,0,0,0,0
  arginfo chasm_vendorid_arginfo,0,0,0,0,0,0
  arginfo chasm_partest_arginfo,0,0,0,0,0,0
  arginfo chasm_addf_arginfo,2,0,0,0,0,0
  arginfo chasm_addf_arginfo.1,chasm_addf_arg1_name,0,5,0,0,0
  arginfo chasm_addf_arginfo.2,chasm_addf_arg2_name,0,5,0,0,0

  global chasm_functions
  chasm_functions:
  function cpuid,   chasm_cpuid_name,   zif_chasm_cpuid,   chasm_cpuid_arginfo,   0,0
  function vendorid,chasm_vendorid_name,zif_chasm_vendorid,chasm_vendorid_arginfo,0,0
  function partest, chasm_partest_name, zif_chasm_partest, chasm_partest_arginfo, 0,0
  function addf,    chasm_addf_name,    zif_chasm_addf,    chasm_addf_arginfo,    2,0
  function _end,    0,                  0,                 0,                     0,0

  global chasm_module_entry
  chasm_module_entry dd 168 ;(size) ushort + padding
  chasm_module_entry.zend_api dd 20151012 ;uint
  chasm_module_entry.zend_debug dd 0 ;uchar + padding
  chasm_module_entry.zts dd 0 ;uchar + padding
  chasm_module_entry.ini_entry dq 0 ;ptr
  chasm_module_entry.deps dq 0  ;ptr
  chasm_module_entry.name dq module_name ;char *
  chasm_module_entry.functions dq chasm_functions ;ptr
  chasm_module_entry.minit dq zm_startup_chasm ;ptr
  chasm_module_entry.mshutdown dq zm_shutdown_chasm ;ptr
  chasm_module_entry.rinit dq 0 ;ptr
  chasm_module_entry.rshutdown dq 0 ;ptr
  chasm_module_entry.minfo dq zm_info_chasm ;ptr
  chasm_module_entry.version dq module_version ;char *
  chasm_module_entry.globals_size dd 0 ;size_t
  chasm_module_entry.globals_ptr dq 0 ;(no-ZTS variant) ptr
  chasm_module_entry.globals_ctor dq 0 ;ptr
  chasm_module_entry.globals_dtor dq 0 ;ptr
  chasm_module_entry.post_deactivate_func dq 0 ;ptr
  chasm_module_entry.module_started dd 0 ;int
  chasm_module_entry.type dd 0 ;uchar + padding
  chasm_module_entry.handle dq 0 ;ptr
  chasm_module_entry.module_number dd 0 ;int
  chasm_module_entry.build_id dq build_id_text ;char *

  module_name db "chASM",0
  table_text db "source language active",0
  table_value db "NASM",0
  module_version db "0.06",0
  build_id_text db "0.06-SNAPSHOT",0
  chasm_cpuid_name db "chasm_cpuid",0
  chasm_vendorid_name db "chasm_vendorid",0
  chasm_vendorid_str db "%s%s%s",0
  chasm_vendorid_regstr db "%c%c%c%c",0
  chasm_partest_name db "chasm_partest",0
  chasm_addf_name db "chasm_addf",0
  chasm_addf_arg1_name db "a",0
  chasm_addf_arg2_name db "b",0
  chasm_addf_par_spec db "dd",0

  chasm_cpuflags_adddata
