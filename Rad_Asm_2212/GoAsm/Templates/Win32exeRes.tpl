Win32 App
Win32EXE
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
1=4,O,$B\GORC.EXE /r,1
2=3,O,$B\GoAsm.EXE,2
3=5,O,$B\GoLink.EXE @$B\GFL.txt /entry Start ,3,4
4=0,0,,5
5=
7=0,0,\GoAsm\GoBug\GoBug,5
[MakeFiles]
0=Win32EXE.rap
1=Win32EXE.rc
2=Win32EXE.asm
3=Win32EXE.obj
4=Win32EXE.res
5=Win32EXE.exe
6=Win32EXE.def
7=Win32EXE.dll
8=Win32EXE.txt
9=Win32EXE.lib
10=Win32EXE.mak
11=Win32EXE.hla
12=Win32EXE.ocx
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
TestTemplates.Asm

#include TestTemplates.Inc

DATA SECTION
	ClassName			DB "MainWinClass",0
	AppName				DB "Main Window",0
	ALIGN 4
	hInstance			DD ?
	CommandLine			DD ?

CODE SECTION

Start:

	invoke GetModuleHandle, NULL
	mov [hInstance],eax
	invoke GetCommandLine
	mov [CommandLine],eax
	invoke InitCommonControls
	invoke WinMain,[hInstance],NULL,[CommandLine],SW_SHOWNORMAL
	invoke ExitProcess,eax

WinMain FRAME hInst,hPrevInst,CmdLine,CmdShow
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:D

	mov D[wc.cbSize],SIZEOF WNDCLASSEX
	mov D[wc.style], CS_HREDRAW + CS_VREDRAW
	mov [wc.lpfnWndProc], OFFSET WndProc
	mov D[wc.cbClsExtra],NULL
	mov D[wc.cbWndExtra],NULL
	push [hInstance]
	pop [wc.hInstance]
	mov D[wc.hbrBackground],COLOR_BTNFACE+1
	mov D[wc.lpszMenuName],NULL
	mov [wc.lpszClassName],OFFSET ClassName
	
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov [wc.hIcon],eax
	mov [wc.hIconSm],eax
	
	invoke LoadCursor,NULL,IDC_ARROW
	mov [wc.hCursor],eax
	
	invoke RegisterClassEx, addr wc
	invoke CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
			WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
			CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
			[hInst],NULL

	mov [hwnd],eax

	invoke ShowWindow, [hwnd],[CmdShow]
	invoke UpdateWindow, [hwnd]

	.messloop
		invoke GetMessage, ADDR msg,0,0,0
		or eax,eax
		JZ >.quit
			invoke TranslateMessage, ADDR msg
			invoke DispatchMessage, ADDR msg
	JMP .messloop
	.quit

	mov eax,[msg.wParam]
	ret
ENDF

WndProc FRAME hWnd, uMsg, wParam, lParam
	mov eax,[uMsg]

	cmp eax,WM_CREATE
	jne >.WMCOMMAND
		jmp >>.EXIT

	.WMCOMMAND
	cmp eax,WM_COMMAND
	jne >.WMCLOSE
		jmp >>.EXIT

	.WMCLOSE
	cmp eax,WM_CLOSE
	jne >.WMDESTROY
		invoke DestroyWindow,[hWnd]
		jmp >>.EXIT

	.WMDESTROY
	cmp eax,WM_DESTROY
	jne >.DEFPROC
		invoke PostQuitMessage,NULL
		jmp >>.DEFPROC

	.DEFPROC
		invoke DefWindowProc,[hWnd],[uMsg],[wParam],[lParam]		
		ret

	.EXIT

	xor eax,eax
	ret
ENDF

[*ENDTXT*]
[*BEGINTXT*]
TestTemplates.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
TestTemplates.Rc
[*ENDTXT*]
[*ENDPRO*]
