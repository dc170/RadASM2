Dll Project
CustTut
RadASM custom control
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
3=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$7",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
7=0,0,"$E\OllyDbg",5
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
13=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$7",3
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
17=0,0,"$E\OllyDbg",5
[MakeFiles]
0=CustTut.rap
1=CustTut.rc
2=CustTut.asm
3=CustTut.obj
4=CustTut.res
5=CustTut.exe
6=CustTut.def
7=CustTut.dll
8=CustTut.txt
9=CustTut.lib
10=CustTut.mak
11=CustTut.hla
12=CustTut.com
[Resource]
1=IDB_BMP,100,0,Res\ToolBox.bmp
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
CustTut.Asm
.386
.model flat,stdcall
option casemap:none

include CustTut.inc

.code

DllEntry proc hInst:HINSTANCE, reason:DWORD, reserved1:DWORD

    push    hInst
    pop     hInstance
	invoke CreateClass
    mov     eax,TRUE
    ret

DllEntry Endp

;NOTE: RadASM 1.2.0.5 uses GetDef method.
;In RadASM.ini section [CustCtrl], x=CustCtrl.dll,y
;x is next free number.
;y is number of controls in the dll. In this case there is only one control.
;
;x=CustTut.dll,1
;Copy CustTut.dll to c:\radasm or to c:\windows\system
;
GetDef proc nInx:DWORD

	mov		eax,nInx
	.if !eax
		;Get the toolbox bitmap
		invoke LoadBitmap,hInstance,IDB_BMP
		mov		ccdef.hbmp,eax
		;Return pointer to inited struct
		mov		eax,offset ccdef
	.else
		xor		eax,eax
	.endif
	ret

GetDef endp

CreateClass proc
	LOCAL	wc:WNDCLASSEX

	;Create a windowclass for the user control
	mov		wc.cbSize,sizeof WNDCLASSEX
	mov		wc.style,CS_HREDRAW or CS_VREDRAW or CS_GLOBALCLASS or CS_PARENTDC or CS_DBLCLKS
	mov		wc.lpfnWndProc,offset ControlProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,0
	push	hInstance
	pop		wc.hInstance
	mov		wc.hbrBackground,NULL
	mov		wc.lpszMenuName,NULL
	mov		wc.lpszClassName,offset szClassName
	mov		eax,NULL
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc
	ret

CreateClass endp

;--------------------------------------------------------------------------------

ControlProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	ps:PAINTSTRUCT
	LOCAL	hMem:DWORD

	mov		eax,uMsg
	.if eax==WM_PAINT
		invoke BeginPaint,hWin,addr ps
		invoke CreateSolidBrush,0FF0000h
		push	eax
		invoke FillRect,ps.hdc,addr ps.rcPaint,eax
		pop		eax
		invoke DeleteObject,eax
		;Draw the caption
		invoke GetWindowTextLength,hWin
		.if eax
			inc		eax
			push	eax
			invoke GlobalAlloc,GMEM_FIXED,eax
			mov		hMem,eax
			invoke SetBkColor,ps.hdc,0FF0000h
			invoke SetTextColor,ps.hdc,0FFFFh
			pop		eax
			invoke GetWindowText,hWin,hMem,eax
			invoke SelectObject,ps.hdc,hFont
			push	eax
			invoke lstrlen,hMem
			invoke TextOut,ps.hdc,0,0,hMem,eax
			invoke GlobalFree,hMem
			pop		eax
			invoke SelectObject,ps.hdc,eax
		.endif
		invoke EndPaint,hWin,addr ps
		jmp		Ex
	.elseif eax==WM_SETFONT
		mov		eax,wParam
		mov		hFont,eax
	.endif
	invoke DefWindowProc,hWin,uMsg,wParam,lParam
  Ex:
	ret

ControlProc endp

End DllEntry
[*ENDTXT*]
[*BEGINTXT*]
CustTut.Inc
include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib

;VKim Debug
include masm32.inc
include \RadASM\masm\inc\debug.inc
includelib masm32.lib
includelib \RadASM\masm\lib\debug.lib

CreateClass			PROTO

;property1 starting with bit 31
;
;(Name)			*
;(ID)			*
;Left			*
;Top			*
;Width			*
;Height			*
;Caption		*
;Border			*
;SysMenu
;MaxButton
;MinButton
;Enabled		*
;Visible		*
;Clipping		*
;ScrollBar		*
;Default
;Auto
;Alignment
;Mnemonic
;WordWrap
;MultiLine
;Type
;Locked
;Child			*
;SizeBorder
;TabStop		*
;Font
;Menu
;Class
;Notify
;AutoScroll
;WantCr
;
;property2 starting with bit 31
;
;Sort
;Flat
;(StartID)
;TabIndex		*
;Format
;SizeGrip
;Group			*
;Icon
;UseTabs
;StartupPos
;Orientation
;SetBuddy
;MultiSelect
;HideSel
;TopMost
;xExStyle		*
;xStyle			*
;IntegralHgt
;Image
;Buttons
;PopUp
;OwnerDraw
;Transp
;Timer
;AutoPlay
;WeekNum
;AviClip
;AutoSize
;ToolTip
;Wrap
;Divider
;
;Note:
;Only some of the properties are general and can be used by the custom control.
;These properties are marked with *
;
;
;Used by RadASM 1.2.0.5. See RadASMini.rtf for more info
CCDEF struct
	ID			dd ?						;Controls uniqe ID
	lptooltip	dd ?						;Pointer to tooltip text
	hbmp		dd ?						;Handle of bitmap
	lpcaption	dd ?						;Pointer to default caption text
	lpname		dd ?						;Pointer to default id-name text
	lpclass		dd ?						;Pointer to class text
	style		dd ?						;Default style
	exstyle		dd ?						;Default ex-style
	property1	dd ?						;Property listbox 1 (bitflags on what properties are enabled)
	property2	dd ?						;Property listbox 2 (bitflags on what properties are enabled)
	disable		dd ?						;Disable controls child windows. 0=No, 1=Use method 1, 2=Use method 2
CCDEF ends

STYLE				equ WS_CHILD or WS_VISIBLE
EXSTYLE				equ 200h
IDB_BMP				equ 100

.const

szToolTip			db 'Custom Control Tutorial',0
szCap				db 'IDC_TUT',0
szName				db 'IDC_TUT',0
szClassName			db 'CUSTOM_TUTORIAL',0

.data

ccdef				CCDEF <12345,offset szToolTip,0,offset szCap,offset szName,offset szClassName,STYLE,EXSTYLE,11111111000110000000000000000000b,00010000000000011000000000000000b,0>

.data?

hInstance			dd ?
hFont				dd ?
[*ENDTXT*]
[*BEGINTXT*]
CustTut.Def
LIBRARY CustTut.dll
EXPORTS
	GetDef
[*ENDTXT*]
[*BEGINTXT*]
CustTut.rc
#include "Res/CustTutRes.rc"
[*ENDTXT*]
[*BEGINBIN*]
Res\ToolBox.bmp
424D660100000000000076000000280000001400000014000000010004000000
0000F00000000000000000000000000000000000000000000000000080000080
00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0088888888888888888888
000088888888888888888888000088000000000000000088000088F777777777
77777088000088F8CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088000088F8
CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088
000088F8CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088000088F8CCCCCCCC
CCCC7088000088F8CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088000088F8
CCCCCCCCCCCC7088000088F8CCCCCCCCCCCC7088000088F88888888888888088
000088FFFFFFFFFFFFFFFF880000888888888888888888880000888888888888
888888880000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
Res\CustTutRes.rc
#define IDB_BMP							100
IDB_BMP					BITMAP   DISCARDABLE "Res/ToolBox.bmp"
[*ENDTXT*]
