; Assembly code emitted by HLA compiler
; Version 1.61 build 8535 (prototype)
; HLA compiler written by Randall Hyde
; MASM compatible output

		if	@Version lt 612
		.586p
		else
		.686p
		.mmx
		.xmm
		endif
		.model	flat, syscall
		option	noscoped


offset32	equ	<offset flat:>

		assume	fs:nothing
ExceptionPtr__hla_	equ	<(dword ptr fs:[0])>

		include	Dialog.extpub.inc





;$ignore
;(for test purposes)

		.data
		include	Dialog.data.inc

		.data?
		include	Dialog.bss.inc

		.code
		include	Dialog.consts.inc

		.code
		include	Dialog.ro.inc



		.code

L1384_RADebug__hla_ proc	near32
		pushfd
		pushad
		call	dword ptr [__imp__GetLastError@0+0]	; GetLastError
		push	eax
		mov	ebx, [esp+52]	;/* [esp+52] */
		push	esp
		pushd	52
		pushd	0
		push	esp
		pushd	0ffffffffh


		pushd	04ah


		push	ebx


		call	dword ptr [__imp__SendMessageA@16+0]	; SendMessage
		add	esp, 12
		test	eax,eax
		jne	L1385_false__hla_
		pushd	00h
		call	dword ptr [__imp__ExitProcess@4+0]	; ExitProcess
L1385_false__hla_:
		pop	eax
		popad
		popfd
		ret	12
xL1384_RADebug__hla___hla_:
L1384_RADebug__hla_ endp


;/*#asm*/


	includelib \masm32\lib\comctl32.lib
;/*#endasm*/

L1388_DialogProc__hla_ proc	near32
		push	ebp
		mov	ebp, esp
		and	esp, 0fffffffch
		cmp	dword ptr [ebp+12], 010h	;/* uMsg,$10 */
		jne	L1389_false__hla_
		pushd	00h
		push	dword ptr [ebp+8]	; hwnd


		call	dword ptr [__imp__EndDialog@8+0]	; EndDialog
		jmp	L1389_endif__hla_
L1389_false__hla_:
		cmp	dword ptr [ebp+12], 0111h	;/* uMsg,$111 */
		jne	L1390_false__hla_
		cmp	dword ptr [ebp+16], 07d1h	;/* wParam,2001 */
		jne	L1391_false__hla_
		pushd	7013274
		pushd	0
		push	dword ptr [ebp+16]	;/* wParam */
		call	L1384_RADebug__hla_	; RADebug
		pushd	00h
		pushd	00h



		pushd	010h


		push	dword ptr [ebp+8]	; hwnd


		call	dword ptr [__imp__SendMessageA@16+0]	; SendMessage
L1391_false__hla_:
		jmp	L1389_endif__hla_
L1390_false__hla_:
		mov	eax, 0
		jmp	xL1388_DialogProc__hla___hla_	;/* DialogProc*/
L1389_endif__hla_:
		mov	eax, 1
xL1388_DialogProc__hla___hla_:
		mov	esp, ebp
		pop	ebp
		ret	16
L1388_DialogProc__hla_ endp




HWexcept__hla_  proc	near32
		jmp	shorthwExcept__hla_
HWexcept__hla_  endp

DfltExHndlr__hla_ proc	near32
		jmp	shortDfltExcept__hla_
DfltExHndlr__hla_ endp



_HLAMain        proc	near32


;/* Set up the Structured Exception Handler record */
;/* for this program. */

		call	BuildExcepts__hla_
		pushd	0		;/* No Dynamic Link. */
		mov	ebp, esp	;/* Pointer to Main's locals */
		push	ebp		;/* Main's display. */


		call	dword ptr [__imp__InitCommonControls@0+0]	; InitCommonControls
		pushd	00h
		call	dword ptr [__imp__GetModuleHandleA@4+0]	; GetModuleHandle
		mov	dword ptr [L1386_hInstance__hla_+0], eax	;/* hInstance */
		pushd	00h
		push	offset32 L1392_DialogProc__hla_


		pushd	00h



		pushd	07d0h


		push	eax


		call	dword ptr [__imp__DialogBoxParamA@20+0]	; DialogBoxParam
		pushd	00h
		call	dword ptr [__imp__ExitProcess@4+0]	; ExitProcess
QuitMain__hla_::
		pushd	00h
		call	dword ptr [__imp__ExitProcess@4]
_HLAMain        endp

		end
