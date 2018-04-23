Win32 App
DialogApp
Dialog application
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
3=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
7=0,0,"$E\OllyDbg",5
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\ML.EXE /c /coff /Cp /Zi /nologo /I"$I",2
13=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
17=0,0,"$E\OllyDbg",5
[MakeFiles]
0=DialogApp.rap
1=DialogApp.rc
2=DialogApp.asm
3=DialogApp.obj
4=DialogApp.res
5=DialogApp.exe
6=DialogApp.def
7=DialogApp.dll
8=DialogApp.txt
9=DialogApp.lib
10=DialogApp.mak
11=DialogApp.hla
12=DialogApp.com
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
DialogApp.Asm
.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include DialogApp.inc

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
[*ENDTXT*]
[*BEGINTXT*]
DialogApp.Inc

include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101

;#########################################################################

.data?

hInstance			dd ?

;#########################################################################
[*ENDTXT*]
[*BEGINTXT*]
DialogApp.Rc
#include "Res/DialogAppDlg.rc"
[*ENDTXT*]
[*BEGINBIN*]
DialogApp.dlg
6400000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F6FFFFFF00000000E90300000000000000000000
000000000000000000000000000000003C0E00000100000021A44000380E0000
000000000008CF10000000000A0000000A0000002C010000C80000004469616C
6F67417070000000000000000000000000000000000000000000000000000000
0000000000000000650000004944445F4449414C4F4731000000000000000000
0000000000000000000000000000000000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
Res\DialogAppDlg.Rc
#define IDD_DIALOG1 101
IDD_DIALOG1 DIALOGEX 6,6,194,106
CAPTION "DialogApp"
FONT 8,"MS Sans Serif"
STYLE 0x10CF0800
EXSTYLE 0x00000000
BEGIN
END
[*ENDTXT*]
