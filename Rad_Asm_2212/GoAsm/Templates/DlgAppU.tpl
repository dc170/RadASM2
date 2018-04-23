Win9x Unicode
TestInc
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,0
1=4,O,$B\GORC.EXE /r,1
2=3,O,$B\GoAsm.EXE,2
3=5,O,$B\GoLink.EXE @$B\GFL.txt /mslu /d UNICODE /entry Start ,3,4
4=0,0,,5
5=
6=
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
TestInc.Asm
;##################################################################
; DIALOGAPP UNICODE
;##################################################################
STRINGS UNICODE
#include "TestInc.Inc"

CONST SECTION
	IDD_DLG1	equ		1000

DATA SECTION
	hInstance	DD		?

CODE SECTION

Start:
	invoke GetModuleHandle, 0
	mov [hInstance],eax
	invoke InitCommonControls
	invoke DialogBoxParam,[hInstance],IDD_DLG1,0,ADDR DlgProc,0
	invoke ExitProcess,0

DlgProc FRAME hwnd,uMsg,wParam,lParam

	mov eax,[uMsg]
	cmp eax,WM_INITDIALOG
	jne >.WMCOMMAND

		jmp >.EXIT

	.WMCOMMAND
	cmp eax,WM_COMMAND
	jne >.WMCLOSE

		jmp >.EXIT

	.WMCLOSE
	cmp eax,WM_CLOSE
	jne >.DEFPROC
		INVOKE EndDialog,[hwnd],0

	.DEFPROC
		mov eax,FALSE
		ret

	.EXIT

	mov eax, TRUE
	ret
ENDF
[*ENDTXT*]
[*BEGINTXT*]
TestInc.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
TestInc.Rc
#include <Res\MainDlg.rc>
[*ENDTXT*]
[*BEGINBIN*]
Main.dlg
6500000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F5FFFFFF00000000E90300000000000000000000
0000000000000000E4090A6700000000FA03D40001000000B27641009C038E00
000000000000CF10000000000A0000000A0000002C010000C80000004944445F
444C470000000000000000000000000000000000000000000000000000000000
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
CAPTION "IDD_DLG"
FONT 8,"MS Sans Serif"
STYLE 0x10CF0000
EXSTYLE 0x00000000
BEGIN
END
[*ENDTXT*]