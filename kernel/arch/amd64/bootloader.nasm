;; Copyright (c) 2020, Florian Buestgens
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;     1. Redistributions of source code must retain the above copyright
;;        notice, this list of conditions and the following disclaimer.
;;
;;     2. Redistributions in binary form must reproduce the above copyright notice,
;;        this list of conditions and the following disclaimer in the
;;        documentation and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED BY Florian Buestgens ''AS IS'' AND ANY
;; EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL Florian Buestgens BE LIABLE FOR ANY
;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;  ____               ___  ____
;; / ___| _   _ _ __  / _ \/ ___|
;; \___ \| | | | '_ \| | | \___ \
;;  ___) | |_| | | | | |_| |___) |
;; |____/ \__, |_| |_|\___/|____/
;;        |___/


;; SynOS multiboot header
;; For now a simple multiboot header is enough.

	BASE equ 0xFFFFFFFF80000000 ; Relocate at -2GB

;; MULTIBOOT ==++
	MBALIGN equ 1 << 0 	    ; aligning loaded modules
	MEMINFO equ 1 << 1	    ; memory mapping
	REQV    equ 1 << 2
	FLAGS   equ MBALIGN | MEMINFO | REQV ; Multiboot Flagfield
	MAGIC   equ 0x1BADB002	    ; Multiboot magic number
	CRC     equ -(MAGIC + FLAGS)    ; Multiboot Checksum
;; MULTIBOOT ==++

%macro DBG 1
	mov al, %1
	out 0x3F8, al
%endmacro
	
;; HEADER ==++
	; This is our Multiboot header.
default rel	
segment .multiboot alloc
global mboot
mboot:
	dd MAGIC
	dd FLAGS
	dd CRC
	dd $ - $$
	dd 0, 0, 0, 0
	dd 0
	dd 0
	dd 0
	dd 32
;; HEADER ==++

;; TEXT ==++
segment .itext exec
[bits 32]
global _start
_start:
	; mov [rel multiboot_sig - BASE], eax
	; mov [rel multiboot_ptr - BASE], ebx
	DBG 0x01
	mov eax, 0x80000000	; Prepare protected mode
	cpuid
	cmp eax, 0x80000001	; Check for CPUID
	jbe .error		; Our CPU doesn't support 64 Bit. uxOS does not support anything else yet.

	mov eax, 0x80000001	; Check for CPUID IA-32e.
	cpuid
	test edx, 0x20000000
	jz .error

	mov eax, cr4		; Setting PGE, PAE, PSE state
	or eax, (0x80|0x20|0x10)
	mov cr4, eax

	mov eax, (ipml4 - BASE)	; init page tables
	mov cr3, eax

	mov ecx, 0xC0000080	; Enable IA-32e (+ Syscall, NX)
	rdmsr
	or eax, ((1 << 11)|(1 << 8)|(1 << 0))
	wrmsr
	

	mov eax, cr0 		; Enable Paging
	and eax, 01111111111111111111111111111111b
	mov cr0, eax

	lgdt [rel GDT_bottom - BASE]
	jmp _init_long_start
	
.error:
	jmp .error

[bits 64]
global _init_long_start
_init_long_start:
;; Prepare 64 bit
	lgdt [rel GDT_high]
	jmp _long_start

segment .text
extern _kmain
global _long_start
_long_start:
	mov rax, 0
	mov [rel ipml4], rax

	mov ax, 0x10
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	lea rsp, [rel init_stack]
	DBG 0x02

	call _kmain wrt ..plt
	
	cli			 ; Disable interrupts, preparing to go down.
.hang:
	hlt			 ; Infinite loop
	jmp .hang
.end:				 ; Bye
;; TEXT ==++

;; PADATA ==++
segment .padata write
;; Here we'll init paging.
ipml4:
	dq pdpt_bottom - BASE + 3
%rep 512 - 3
	dq 0
%endrep
	dq 0
	dq ipdpt - BASE + 3
	
pdpt_bottom:
	dq ipd - BASE + 3
%rep 512 - 1
	dq 0
%endrep

ipdpt:
%rep 512 - 2
	dq 0
%endrep
	dq ipd - BASE + 3
	dq 0

ipd:
	dq 0x000000 + 0x80 + 3
	dq 0x200000 + 0x80 + 3
%rep 521 - 2
	dq 0
%endrep

init_stack_b:
%rep 0x1000 * 2
	db 0
%endrep
init_stack:
;; PADATA ==++

;; DATA ==++
	; Align our stack.
segment .data 
global multiboot_sig
global multiboot_ptr
multiboot_sig: dd 0
multiboot_ptr: dd 0

GDT_bottom:			; Global Descriptor Table
	dw GDTEnd - GDT - 1
	dq GDT - BASE
GDT_high:
	dw GDTEnd - GDT - 1
	dq GDT
global GDT
GDT:
	dd 0, 0
        dd 0x00000000, 0x00209A00 ; 64 Bit Code
        dd 0x00000000, 0x00009200 ; 64 Bit Data
        dd 0x00000000, 0x0040FA00 ; 32 Bit Userspace
        dd 0x00000000, 0x0040F200 ; Userspace
        dd 0x00000000, 0x0020FA00 ; 64 Bit Userspace
        dd 0x00000000, 0x0000F200
GDTEnd:
	
;; DATA ==++
