.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include AviPlay.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
    invoke InitCommonControls
	mov		iccex.dwSize,sizeof INITCOMMONCONTROLSEX    ;prepare common control structure
	mov		iccex.dwICC,ICC_ANIMATE_CLASS or ICC_INTERNET_CLASSES
	invoke InitCommonControlsEx,addr iccex
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
;		;Play a file
;		invoke SendDlgItemMessage,hWin,IDC_ANI1,ACM_OPEN,0,offset szAvi
;		;Play a resource
;		invoke SendDlgItemMessage,hWin,IDC_ANI1,ACM_OPEN,0,IDR_AVI
	.elseif eax==WM_CTLCOLORSTATIC
		invoke GetWindowLong,lParam,GWL_ID
		.if eax==IDC_ANI1
			invoke GetStockObject,BLACK_BRUSH
		.else
			xor		eax,eax
		.endif
		ret
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		mov		edx,eax
		shr		edx,16
		and		eax,0FFFFh
		.if edx==BN_CLICKED
			.if eax==IDCANCEL
				invoke SendMessage,hWin,WM_CLOSE,NULL,NULL
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
