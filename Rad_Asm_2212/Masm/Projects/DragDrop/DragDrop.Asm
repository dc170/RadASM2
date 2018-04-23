.386
.model flat,stdcall
option casemap:none

include DragDrop.inc
include DragDropObj.asm

.code

start:

	invoke GetModuleHandle,NULL
	mov    hInstance,eax
	invoke GetCommandLine
	invoke InitCommonControls
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL	wc:WNDCLASSEX
	LOCAL	msg:MSG

	mov		wc.cbSize,SIZEOF WNDCLASSEX
	mov		wc.style,CS_HREDRAW or CS_VREDRAW
	mov		wc.lpfnWndProc,OFFSET WndProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	mov		wc.hbrBackground,COLOR_BTNFACE+1
	mov		wc.lpszMenuName,10000
	mov		wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc

	invoke CreateDialogParam,hInstance,1000,NULL,addr WndProc,NULL
	invoke ShowWindow,hWnd,SW_SHOWNORMAL
	invoke UpdateWindow,hWnd
	.while TRUE
		invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
		invoke TranslateMessage,addr msg
		invoke DispatchMessage,addr msg
	.endw
	mov		eax,msg.wParam
	ret

WinMain endp

WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		push	hWin
		pop		hWnd
		invoke GetDlgItem,hWin,1001
		mov		hDrag,eax
		invoke GetDlgItem,hWin,1002
		mov		hDrop1,eax
		invoke GetDlgItem,hWin,1003
		mov		hDrop2,eax
		invoke OleInitialize,NULL
		invoke RegisterDragDrop,hDrop1,offset pvtIDropTarget
		invoke RegisterDragDrop,hDrop2,offset pvtIDropTarget
	.elseif eax==WM_COMMAND
		mov		edx,wParam
		movzx	eax,dx
		shr		edx,16
		.if edx==BN_CLICKED
			.if eax==IDM_FILE_EXIT
				invoke SendMessage,hWin,WM_CLOSE,0,0
			.elseif eax==IDM_HELP_ABOUT
				invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
			.elseif eax==1001
				invoke DoDragDrop,offset pvtIDataObject,offset pvtIDropSource,DROPEFFECT_COPY or DROPEFFECT_MOVE,offset peff
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke DestroyWindow,hWin
	.elseif eax==WM_DESTROY
		invoke RevokeDragDrop,hDrop1
		invoke RevokeDragDrop,hDrop2
		invoke OleUninitialize
		invoke PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWin,uMsg,wParam,lParam
		ret
	.endif
	xor    eax,eax
	ret

WndProc endp

end start
