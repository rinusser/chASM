; Helper macros for decoding CPUID flags.
;
; \author Richard Nusser
; \copyright 2017-2018 Richard Nusser
; \license GPLv3 (see http://www.gnu.org/licenses/)
; \link https://github.com/rinusser/chASM
;

%macro chasm_cpuid_checkflags 3-*
  %define _src %1
  %rep %0/2
    %ifnid %2
      %exitrep
    %endif
    mov rdi,r15
    mov rcx,_src
    mov rax,1<<%3
    and rcx,rax
    mov rsi,chasm_cpuid.%2
    mov rdx,chasm_cpuid.%2.len
    ;ZEND_API int add_assoc_bool_ex(zval *arg, const char *key, size_t key_len, int b);
    call add_assoc_bool_ex
    ;TODO: check for success
    %rotate 2
  %endrep
%endmacro

%macro chasm_cpuflags_checkflags_basic 0
  chasm_cpuflags_dobasic chasm_cpuid_checkflags
%endmacro


%macro chasm_cpuflags_define 1-*
  %rep %0/2
    %defstr _cpuflag_val %2
    chasm_cpuid.%2 db _cpuflag_val
    chasm_cpuid.%2.len equ $-chasm_cpuid.%2
    %rotate 2
  %endrep
%endmacro

%macro chasm_cpuflags_adddata 0
  chasm_cpuflags_dobasic chasm_cpuflags_define
%endmacro


%macro chasm_cpuflags_dobasic 1
  %1 r14, fpu,0, vme,1, de,2, pse,3, tsc,4, msr,5, pae,6, mce,7, cx8,8, apic,9 ; edx:10 is reserved
  %1 r14, sep,11, mtrr,12, pge,13, mca,14, cmov,15, pat,16, pse36,17, psn,18, clfsh,19 ; edx:20 is reserved
  %1 r14, ds,21, acpi,22, mmx,23, fxsr,24, sse,25, sse2,26, ss,27, htt,28, tm,29, ia64,30, pbe,31

  %1 r13, sse3,0, pclmulqdq,1, dtes64,2, monitor,3, dscpl,4, vmx,5, smx,6, est,7, tm2,8, ssse3,9
  %1 r13, cnxtid,10, sdbg,11, fma,12, cx16,13, xtpr,14, pdcm,15 ;ecx:16 is reserved
  %1 r13, pcid,17, dca,18, sse41,19, sse42,20, x2apic,21, movbe,22, popcnt,23, tscdeadline,24
  %1 r13, aes,25, xsave,26, osxsave,27, avx,28, f16c,29, rdrnd,30, hypervisor,31
%endmacro
