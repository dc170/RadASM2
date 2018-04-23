; Assembly code emitted by HLA compiler
; Version 1.81 build 10443 (prototype)
; HLA compiler written by Randall Hyde
; FASM compatible output

		format	MS COFF


offset32	equ	 
ptr	equ	 

macro global [symbol]
{
 local isextrn
 if defined symbol & ~ defined isextrn
   public symbol
 else if used symbol
   extrn symbol
   isextrn = 1
 end if
}

macro global2 [symbol,type]
{
 local isextrn
 if defined symbol & ~ defined isextrn
   public symbol
 else if used symbol
   extrn symbol:type
   isextrn = 1
 end if
}


ExceptionPtr__hla_	equ	fs:0

		include	'R_001a.extpub.inc'




		section	'.data' data readable writeable align 16
		include	'R_001a.data.inc'

		dd	0	;dummy to keep linker happy
		section	'.bss' readable writeable align 16
		include	'R_001a.bss.inc'

		rb	4	;dummy to keep linker happy
		section	'.text' code readable executable align 16
		include	'R_001a.consts.inc'

		include	'R_001a.ro.inc'

; Code begins here:



HWexcept__hla_ :
		jmp	shorthwExcept__hla_
;HWexcept__hla_  endp

DfltExHndlr__hla_:
		jmp	shortDfltExcept__hla_
;DfltExHndlr__hla_ endp



_HLAMain       :


;/* Set up the Structured Exception Handler record */
;/* for this program. */

		call	BuildExcepts__hla_
		pushd	0		;/* No Dynamic Link. */
		mov	ebp, esp	;/* Pointer to Main's locals */
		push	ebp		;/* Main's display. */


		push	dword 040h
		push	L1392_str__hla_


		push	L1391_str__hla_


		push	dword 00h


		call	dword ptr [__imp__MessageBoxA@16+0]	; MessageBox
QuitMain__hla_:
		push	dword 00h
		call	dword ptr [__imp__ExitProcess@4]
;_HLAMain        endp


