Win32 App
CstmCtrl
Custom Control
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
0=CstmCtrl.rap
1=CstmCtrl.rc
2=CstmCtrl.asm
3=CstmCtrl.obj
4=CstmCtrl.res
5=CstmCtrl.exe
6=CstmCtrl.def
7=CstmCtrl.dll
8=CstmCtrl.txt
9=CstmCtrl.lib
10=CstmCtrl.mak
11=CstmCtrl.hla
12=CstmCtrl.ocx
[Resource]
[StringTable]
[VerInf]
FV=0.0.0.8
FileVersion=0.0.0.8
PV=0.0.0.8
ProductVersion=0.0.0.8
[*ENDDEF*]
[*BEGINTXT*]
CstmCtrl.Asm
;##################################################################
; DIALOGAPP
;##################################################################

#include "CstmCtrl.Inc"

;#include "\RadASM\GoAsm\inc\debug.a"
;DBGWIN_DEBUG_ON = 1 ; use this to enable Spy/StopSpy/DbgDump and TrapException
;DBGWIN_SHOWONLYERRORS = 1 ; setting this to 1 will suppress PrintError if no error exists 

CONST SECTION
	IDD_DLG1	equ		1000

DATA SECTION
	hInstance	DD 		?
	icc	 		DQ		3FFF00000008h

CODE SECTION

Start:
	call BuildMessageTable
	invoke GetModuleHandle, 0
	mov [hInstance],eax
	invoke InitCommonControlsEx,OFFSET icc
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

InitClass FRAME
	LOCAL cc_wcx			:WNDCLASSEX

	mov D[cc_wcx.cbSize],SIZEOF WNDCLASSEX
	mov D[cc_wcx.style], CS_HREDRAW + CS_VREDRAW
	mov eax,[hInstance]
	mov D[cc_wcx.hInstance],eax
	mov D[cc_wcx.lpszClassName],OFFSET UDC_Class
	mov D[cc_wcx.cbClsExtra],0
	mov D[cc_wcx.cbWndExtra],32
	mov D[cc_wcx.lpfnWndProc],OFFSET _CCProc
	mov D[cc_wcx.hIcon],NULL
	mov D[cc_wcx.hIconSm],NULL
	mov D[cc_wcx.hbrBackground],COLOR_WINDOW+1
	mov D[cc_wcx.lpszMenuName],NULL

	invoke LoadCursor,NULL,IDC_ARROW
	mov [cc_wcx.hCursor],eax

	invoke RegisterClassEx,ADDR cc_wcx

	ret

	UDC_Class:	db		"UDC_ControlClass",0
ENDF

_CCProc FRAME hwnd,uMsg,wParam,lParam

	cmp D[uMsg],WM_CREATE
	jne >.WM_DESTROY
		
		jmp >.EXIT

	.WM_DESTROY
	cmp D[uMsg],WM_DESTROY
	jne >.DEFPROC
		
		jmp >.EXIT

	.DEFPROC
		invoke DefWindowProc,[hwnd],[uMsg],[wParam],[lParam]
		ret

	.EXIT
	xor eax,eax
	RET
ENDF
[*ENDTXT*]
[*BEGINTXT*]
CstmCtrl.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
CstmCtrl.Rc
#include <Res\MainDlg.rc>
#include "Res/CstmCtrlVer.rc"
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
