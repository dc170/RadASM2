.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include MakeFont.inc

.code

start:
	invoke	GetModuleHandle,NULL
	mov	hInstance,eax
	invoke	InitCommonControls
	invoke	DialogBoxParam,hInstance,IDD_MAIN,NULL,addr DlgProc,NULL
	invoke	ExitProcess,0

;########################################################################

GetFontByte proc uses ebx esi edi,x:DWORD,y:DWORD,chr:DWORD

	xor		ebx,ebx
	xor		edi,edi
	.while edi<8
		invoke GetPixel,hDC,x,y
		shl		ebx,1
		.if !eax
			or		ebx,1
		.endif
		inc		x
		inc		edi
	.endw
	.if chr>=128
		xor		ebx,0FFh
	.endif
	mov		eax,ebx
	ret

GetFontByte endp

GetFontChar proc uses ebx esi edi,chr:DWORD

	mov		ebx,chr
	and		ebx,7Fh
	shl		ebx,3
	mov		edi,offset chrBuff
	xor		esi,esi
	.while esi<10
		invoke GetFontByte,ebx,esi,chr
		mov		[edi+esi],al
		inc		esi
	.endw
	ret

GetFontChar endp

MakeBinByte proc uses ebx esi edi,bByte:DWORD,lpBinBuff:DWORD

	mov		edi,lpBinBuff
	mov		eax,bByte
	xor		ebx,ebx
	.while ebx<8
		test	eax,80h
		.if !ZERO?
			mov		byte ptr [edi+ebx],'1'
		.else
			mov		byte ptr [edi+ebx],'0'
		.endif
		shl		eax,1
		inc		ebx
	.endw
	ret

MakeBinByte endp

MakeBinChr proc uses ebx esi edi,hWin:HWND
	LOCAL	buffer[64]:BYTE

	xor		ebx,ebx
	mov		word ptr buffer,'b0'
	mov		dword ptr buffer[10],0A0D2Ch
	.while ebx<9
		movzx	edx,chrBuff[ebx]
		invoke MakeBinByte,edx,addr buffer[2]
		invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr buffer
		inc		ebx
	.endw
	mov		dword ptr buffer[10],0A0Dh
	movzx	edx,chrBuff[ebx]
	invoke MakeBinByte,edx,addr buffer[2]
	invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr buffer
	ret

MakeBinChr endp

DlgProc	proc uses ebx,hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	rect:RECT
	LOCAL	buffer[64]:BYTE

	mov		eax,uMsg
	.if	eax==WM_INITDIALOG
		invoke GetWindowRect,hWin,addr rect
		invoke MoveWindow,hWin,0,0,1024+8,250,FALSE
		invoke GetDlgItem,hWin,IDC_IMG1
		invoke MoveWindow,eax,0,0,128*8,10,FALSE
		invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_LIMITTEXT,0,0
	.elseif	eax==WM_COMMAND
		mov edx,wParam
		movzx eax,dx
		shr edx,16
		.if edx==BN_CLICKED
			.if eax==IDOK
				invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr szStart
				invoke GetDlgItem,hWin,IDC_IMG1
				invoke GetDC,eax
				mov		hDC,eax
				xor		ebx,ebx
				.while ebx<256
					invoke wsprintf,addr buffer,addr szChrStart,ebx
					invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr buffer
					invoke GetFontChar,ebx
					invoke MakeBinChr,hWin
					.if ebx==255
						invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr szChrEnd1
					.else
						invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr szChrEnd
					.endif
					inc		ebx
				.endw
				invoke SendDlgItemMessage,hWin,IDC_EDT1,EM_REPLACESEL,FALSE,addr szEnd
			.elseif eax==IDCANCEL
				invoke	SendMessage,hWin,WM_CLOSE,NULL,NULL
			.endif
		.endif
	.elseif	eax==WM_CLOSE
		invoke	EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
