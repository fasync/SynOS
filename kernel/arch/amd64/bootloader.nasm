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
;;
;; The Power of Minimalism
	
;; SynOS multiboot header

;; CONST ==++
	MBALIGN equ 1 << 0 	    ; aligning loaded modules
	MEMINFO equ 1 << 1	    ; memory mapping
	FLAGS equ MBALIGN | MEMINFO ; Multiboot Flagfield
	MAGIC equ 0x1BADB002	    ; Multiboot magic number
	CRC equ -(MAGIC + FLAGS)    ; Multiboot Checksum
;; CONST ==++

;; HEADER ==++
	; This is our Multiboot header.
section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CRC
;; HEADER ==++

;; BSS ==++
	; Align our stack.
section .bss
align 16
stack_bottom:
	resb 4096 * 4 		; 16 KiB
stack_top:
;; BSS ==++

;; TEXT ==++
section .text
global _start:function (_start.end - _start)
_start:
	mov esp, [rel stack_top] ; Prepare Stackpointer
extern _kmain
	call _kmain wrt ..plt    ; Switch to Kernel
	cli			 ; Disable interrupts, preparing to go down.
.hang:
	hlt			 ; Infinite loop
	jmp .hang
.end:				 ; Bye
;; TEXT ==++
