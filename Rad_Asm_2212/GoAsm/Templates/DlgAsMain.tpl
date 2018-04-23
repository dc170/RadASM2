Win32 App
TestDlgM
Dialog as main window
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,0,0,0
1=4,O,$B\GORC.EXE /r,1
2=3,O,$B\GoAsm.EXE,2
3=5,O,$B\GoLink.EXE @$B\GFL.txt /entry Start ,3,4
4=0,0,,5
5=
6=
7=0,0,\GoAsm\GoBug\GoBug,5
[MakeFiles]
0=TestDlgM.rap
1=TestDlgM.rc
2=TestDlgM.asm
3=TestDlgM.obj
4=TestDlgM.res
5=TestDlgM.exe
6=TestDlgM.def
7=TestDlgM.dll
8=TestDlgM.txt
9=TestDlgM.lib
10=TestDlgM.mak
11=TestDlgM.hla
12=TestDlgM.ocx
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
TestDlgM.Asm
;##################################################################
; DIALOG AS MAIN
;##################################################################

#include "TestDlgM.Inc"

CONST SECTION
	IDD_DLG1			equ		1000

DATA SECTION
	hInstance			DD 		?
	hDlg				DD		?

	ClassName			DB		"DialogClass",0

CODE SECTION

Start:
	invoke GetModuleHandle, 0
	mov [hInstance],eax
	invoke InitCommonControls
	invoke WinMain,[hInstance],NULL,NULL,SW_SHOW
	invoke ExitProcess,0

WinMain FRAME hInst,hPrevInstance,lpCmdLine,nCmdShow
	LOCAL	wc				:WNDCLASSEX
	LOCAL	msg				:MSG
	LOCAL	hdc				:D

	; Define our main window class and register it
	mov		D[wc.cbSize], SIZEOF WNDCLASSEX
	mov		D[wc.style], CS_HREDRAW + CS_VREDRAW
	mov		D[wc.lpfnWndProc], OFFSET DlgProc
	mov		D[wc.cbClsExtra], NULL
	mov		D[wc.cbWndExtra], DLGWINDOWEXTRA
	mov		eax, [hInstance]
	mov		D[wc.hInstance], eax
	mov		D[wc.hbrBackground], COLOR_BTNFACE + 1
	mov		D[wc.lpszMenuName], NULL
	mov		D[wc.lpszClassName], OFFSET ClassName
	invoke	LoadIcon, NULL, IDI_APPLICATION
	mov		D[wc.hIcon], eax
	mov		D[wc.hIconSm], eax
	invoke	LoadCursor,NULL,IDC_ARROW
	mov		D[wc.hCursor], eax

	invoke	RegisterClassEx, addr wc
	or eax,eax
	jnz >
		; If we were unable to register the class shut down
		invoke	ExitProcess, -1
	:

	invoke	CreateDialogParam, [hInstance],IDD_DLG1, NULL, NULL, NULL
	or eax,eax
	jnz >
		; If we were unable to create the dialog shut down
		invoke	ExitProcess, -1
	:
	mov [hDlg],eax

	invoke ShowWindow,[hDlg],[nCmdShow]

	:
		invoke GetMessage, ADDR msg,NULL,0,0
		or eax,eax
		jz >
			invoke IsDialogMessage, [hDlg], ADDR msg
			or eax,eax
			jnz <
				invoke TranslateMessage, ADDR msg
				invoke DispatchMessage, ADDR msg
				jmp <
	:

	mov eax,[msg.wParam]

	ret
ENDF

DlgProc FRAME hwnd,uMsg,wParam,lParam

	mov eax,[uMsg]

	cmp eax,WM_CREATE
	jne >.WMCOMMAND
		jmp >.EXIT

	.WMCOMMAND
	cmp eax,WM_COMMAND
	jne >.WMDESTROY
		jmp >.EXIT

	.WMDESTROY
	cmp eax,WM_DESTROY
	jne >.DEFPROC
		invoke PostQuitMessage,0

	.DEFPROC
		invoke DefWindowProc,[hwnd],[uMsg],[wParam],[lParam]
		ret

	.EXIT

	xor eax,eax
	ret

ENDF
[*ENDTXT*]
[*BEGINTXT*]
TestDlgM.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
TestDlgM.Rc
#include <Res\MainDlg.rc>
[*ENDTXT*]
[*BEGINBIN*]
Main.dlg
65000000010000004469616C6F67436C61737300000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F5FFFFFF00000000E90300000000000000000000
0000000000000000A0040A190000000058011D000100000056964100A4011900
000000000000CF10000000000A0000000A0000002C010000C80000004449414C
4F47204153204D41494E00000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F444C4731000000000000000000000000000000000000000000000000000000
0000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
Res\MainDlg.Rc
#define IDD_DLG1 1000
IDD_DLG1 DIALOGEX 6,6,194,106
CAPTION "DIALOG AS MAIN"
FONT 8,"MS Sans Serif"
CLASS "DialogClass"
STYLE 0x10CF0000
EXSTYLE 0x00000000
BEGIN
END
[*ENDTXT*]
