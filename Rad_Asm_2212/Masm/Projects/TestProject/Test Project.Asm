.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include Test Project.inc

;--------------------------------------------------------------------------------
;If you are doing source code breakpoints, this file must be included.
;You don't need it with int 3 breakpoints.
include \radasm\masm\inc\radbg.inc
;--------------------------------------------------------------------------------

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG

	.elseif eax==WM_COMMAND
		pushad
		invoke GetParent,0
		mov		eax,1
		invoke SetLastError,0
		mov		ebx,2
		mov		ecx,3
		xor		ebx,ebx
		popad
	.elseif eax==WM_CLOSE
		pushad
		xor		eax,eax
		dec		eax
		add		eax,2
		mov		ebx,2
		mov		ecx,3
		mov		edx,4
		mov		esi,5
		mov		edi,6
		mov		ebp,7
		popad
		invoke EndDialog,hWin,0
	.elseif eax==WM_SIZING
		mov		edx,lParam
		mov		eax,[edx].RECT.top
		add		eax,204
		mov		[edx].RECT.bottom,eax
		mov		eax,[edx].RECT.right
		sub		eax,[edx].RECT.left
		.if eax>400
			mov		eax,[edx].RECT.left
			add		eax,400
			mov		[edx].RECT.right,eax
;			mov		eax,TRUE
;			ret
		.endif
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
