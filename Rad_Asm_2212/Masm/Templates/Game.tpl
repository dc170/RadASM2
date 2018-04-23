Win32 App
Alien
Alien invaders game
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
3=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"$L",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
7=0,0,"$E\OllyDbg",5
[MakeFiles]
0=Alien.rap
1=Alien.rc
2=Alien.asm
3=Alien.obj
4=Alien.res
5=Alien.exe
6=Alien.def
7=Alien.dll
8=Alien.txt
9=Alien.lib
10=Alien.mak
11=Alien.hla
12=Alien.com
[Resource]
1=IDB_ALIEN,100,0,Res\ALIEN.bmp
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
Alien.Asm
.386
.model flat,stdcall
option casemap:none

include Alien.inc

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
	mov		wc.hbrBackground,NULL
	mov		wc.lpszMenuName,IDR_MENU
	mov		wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc
	invoke LoadAccelerators,hInst,IDR_ACCEL
	mov		hAccel,eax
	invoke CreateDialogParam,hInstance,IDD_ALIEN,NULL,addr WndProc,NULL
	invoke ShowWindow,hWnd,SW_SHOWNORMAL
	invoke UpdateWindow,hWnd
	.while TRUE
		invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
		invoke TranslateAccelerator,hWnd,hAccel,addr msg
		.if !eax
			invoke TranslateMessage,addr msg
			invoke DispatchMessage,addr msg
		.endif
	.endw
	mov		eax,msg.wParam
	ret

WinMain endp

Random proc uses ecx edx,range:DWORD

	mov eax, rseed
	mov ecx, 23
	mul ecx
	add eax, 7
	and eax, 0FFFFFFFFh
	ror eax, 1
	xor eax, rseed
	mov rseed, eax
	mov ecx, range
	xor edx, edx
	div ecx
	mov eax, edx
	ret

Random endp

SetupAliens proc

	;Aliens
	mov		naliens,MALIENSX*MALIENSY
	mov		caliens,6
	mov		aliensdirx,3
	mov		aliensdiry,0
	xor		ecx,ecx
	mov		ebx,offset aliens
	mov		edx,16
	.while ecx<MALIENSY
		push	ecx
		xor		ecx,ecx
		mov		eax,0
		.while ecx<MALIENSX
			mov		[ebx].OBJECT.x,eax
			mov		[ebx].OBJECT.y,edx
			push	ecx
			and		ecx,1
			inc		ecx
			mov		[ebx].OBJECT.state,ecx
			pop		ecx
			add		eax,20
			add		ebx,sizeof OBJECT
			inc		ecx
		.endw
		pop		ecx
		add		edx,16
		inc		ecx
	.endw
	ret

SetupAliens endp

PaintBoard proc uses ebx esi,hWin:HWND,hDC:HDC
	LOCAL	mDC:HDC
	LOCAL	hBmp:DWORD
	LOCAL	hOld:DWORD
	LOCAL	rect:RECT
	LOCAL	xmax:DWORD
	LOCAL	buffer[32]:BYTE

	invoke CreateCompatibleDC,hDC
	mov		mDC,eax
	invoke CreateCompatibleBitmap,hDC,256,256
	invoke SelectObject,mDC,eax
	push	eax
	mov		rect.left,0
	mov		rect.top,0
	mov		rect.right,256
	mov		rect.bottom,256
	invoke GetStockObject,BLACK_BRUSH
	invoke FillRect,mDC,addr rect,eax
	mov		ebx,2
	mov		ecx,nguns
	.while ecx
		push	ecx
		invoke ImageList_Draw,hIml,0,mDC,ebx,0,ILD_TRANSPARENT
		add		ebx,14
		pop		ecx
		dec		ecx
	.endw
	invoke ImageList_Draw,hIml,0,mDC,gunx,256-12,ILD_TRANSPARENT
	mov		ebx,offset shields
	mov		ecx,MSHIELDS
	.while ecx
		push	ecx
		call	DrawShield
		pop		ecx
		dec		ecx
	.endw
	.if !halt
		;Aliens speed
		dec		caliens
		.if !caliens
			;Move the aliens
			.if naliens>5
				mov		caliens,4
			.else
				mov		caliens,1
			.endif
			mov		xmax,0
			mov		ebx,offset aliens
			mov		ecx,MALIENSX*MALIENSY
			.while ecx
				push	ecx
				call	MoveAlien
				pop		ecx
				dec		ecx
			.endw
			.if aliensdirxs
				mov		eax,aliensdirxs
				neg		eax
				mov		aliensdirx,eax
				mov		aliensdirxs,0
				mov		aliensdiry,0
			.elseif xmax
				mov		aliensdiry,8
				mov		eax,aliensdirx
				mov		aliensdirxs,eax
				mov		aliensdirx,0
			.endif
		.endif
	.endif
	mov		ebx,offset aliens
	mov		ecx,MALIENSX*MALIENSY
	.while ecx
		push	ecx
		call	DrawAlien
		pop		ecx
		dec		ecx
	.endw
	.if !halt
		mov		esi,offset shots
		mov		ecx,MSHOTS
		.while ecx
			push	ecx
			call	MoveShot
			add		esi,sizeof OBJECT
			pop		ecx
			dec		ecx
		.endw
		mov		esi,offset bombs
		mov		ecx,MBOMBS
		.while ecx
			push	ecx
			call	MoveBomb
			add		esi,sizeof OBJECT
			pop		ecx
			dec		ecx
		.endw
	.endif
	invoke wsprintfA,addr buffer,offset fmtStr,points
	invoke SetBkMode,mDC,TRANSPARENT
	invoke SetTextColor,mDC,0FFFFFFh
	invoke DrawText,mDC,addr buffer,-1,addr rect,DT_RIGHT
	mov		eax,goy
	.if eax
		sub		eax,70
		mov		rect.top,eax
		invoke DrawText,mDC,offset gameover1,-1,addr rect,DT_CENTER
		add		rect.top,20
		invoke DrawText,mDC,offset gameover2,-1,addr rect,DT_CENTER
		add		rect.top,30
		invoke DrawText,mDC,offset gameover3,-1,addr rect,DT_CENTER
		dec		goy
	.endif
	invoke GetClientRect,hWin,addr rect
	invoke StretchBlt,hDC,0,0,rect.right,rect.bottom,mDC,0,0,256,256,SRCCOPY
	pop		eax
	invoke SelectObject,mDC,eax
	invoke DeleteObject,eax
	invoke DeleteDC,mDC
	ret

DrawShield:
	.if [ebx].OBJECT.state
		invoke ImageList_Draw,hIml,1,mDC,[ebx].OBJECT.x,[ebx].OBJECT.y,ILD_TRANSPARENT
	.endif
	add		ebx,sizeof OBJECT
	.if [ebx].OBJECT.state
		invoke ImageList_Draw,hIml,2,mDC,[ebx].OBJECT.x,[ebx].OBJECT.y,ILD_TRANSPARENT
	.endif
	add		ebx,sizeof OBJECT
	retn

MoveAlien:
	.if [ebx].OBJECT.state
		mov		eax,aliensdirx
		add		[ebx].OBJECT.x,eax
		mov		eax,aliensdiry
		add		[ebx].OBJECT.y,eax
		.if dword ptr [ebx].OBJECT.state==1
			mov		[ebx].OBJECT.state,2
		.else
			mov		[ebx].OBJECT.state,1
		.endif
		mov		eax,[ebx].OBJECT.x
		add		eax,aliensdirx
		.if eax>243
			mov		xmax,eax
		.endif
	.endif
	add		ebx,sizeof OBJECT
	retn

DrawAlien:
	mov		eax,[ebx].OBJECT.state
	.if eax
		add		eax,2
		invoke ImageList_Draw,hIml,eax,mDC,[ebx].OBJECT.x,[ebx].OBJECT.y,ILD_TRANSPARENT
		.if [ebx].OBJECT.y>235 && !halt
			mov		goy,350
			mov		halt,TRUE
		.elseif !halt
			invoke Random,64
			.if eax<5
				;If possible, drop a bomb
				push	esi
				mov		esi,offset bombs
				mov		ecx,MBOMBS
				.while ecx
					.if ![esi].OBJECT.state
						mov		eax,[ebx].OBJECT.x
						add		eax,6
						mov		[esi].OBJECT.x,eax
						mov		eax,[ebx].OBJECT.y
						add		eax,12
						mov		[esi].OBJECT.y,eax
						mov		[esi].OBJECT.state,1
						.break
					.endif
					add		esi,sizeof OBJECT
					dec		ecx
				.endw
				pop		esi
			.endif
		.endif
	.endif
	add		ebx,sizeof OBJECT
	retn

MoveShot:
	.if [esi].OBJECT.state
		invoke GetPixel,mDC,[esi].OBJECT.x,[esi].OBJECT.y
		.if eax
			;Hit somthing
			.if eax==0FFFFh		;yellow
				;Hit a shield
				mov		eax,[esi].OBJECT.x
				push	esi
				mov		esi,offset shields
				mov		ecx,MSHIELDS*2
				.while eax>=[esi].OBJECT.x && ecx
					add		esi,sizeof OBJECT
					dec		ecx
				.endw
				sub		esi,sizeof OBJECT
				dec		[esi].OBJECT.state
				pop		esi
			.elseif eax==0FFFFFFh	;white
				;Hit a bomb
			.else
				;Hit an alien
				mov		ebx,offset aliens
				mov		ecx,MALIENSX*MALIENSY
				.while ecx
					.if [ebx].OBJECT.state
						mov		eax,[ebx].OBJECT.x
						mov		edx,eax
						add		edx,12
						.if eax<=[esi].OBJECT.x && edx>=[esi].OBJECT.x
							mov		eax,[ebx].OBJECT.y
							mov		edx,eax
							add		edx,12
							.if eax<=[esi].OBJECT.y && edx>=[esi].OBJECT.y
								mov		dword ptr [ebx].OBJECT.state,0
								dec		naliens
								add		points,5
								.if !naliens
									pushad
									invoke SetupAliens
									popad
								.endif
							.endif
						.endif
					.endif
					add		ebx,sizeof OBJECT
					dec		ecx
				.endw
			.endif
			mov		[esi].OBJECT.state,0
		.else
			sub		[esi].OBJECT.y,3
			mov		ebx,[esi].OBJECT.y
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			dec		ebx
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			dec		ebx
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			.if CARRY?
				;Outside boarder
				mov		[esi].OBJECT.state,0
			.endif
		.endif
	.endif
	retn

MoveBomb:
	.if [esi].OBJECT.state
		invoke GetPixel,mDC,[esi].OBJECT.x,[esi].OBJECT.y
		.if eax==0FFFFh || eax==0FFFFFFh || eax==0FF0000h
			;Hit somthing
			.if eax==0FFFFh			;yellow
				;Hit shield
				mov		eax,[esi].OBJECT.x
				push	esi
				mov		esi,offset shields
				mov		ecx,MSHIELDS*2
				.while eax>=[esi].OBJECT.x && ecx
					add		esi,sizeof OBJECT
					dec		ecx
				.endw
				sub		esi,sizeof OBJECT
				dec		[esi].OBJECT.state
				pop		esi
			.elseif eax==0FF0000h	;blue
				;Hit gun
				invoke MessageBeep,0FFFFFFFFh
				dec		nguns
				.if nguns
					mov		gunx,0
				.else
					mov		goy,350
					mov		halt,TRUE
				.endif
			.elseif eax==0FFFFFFh	;white
				;Hit a shot
			.endif
			mov		[esi].OBJECT.state,0
		.else
			add		[esi].OBJECT.y,3
			mov		ebx,[esi].OBJECT.y
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			inc		ebx
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			inc		ebx
			invoke SetPixel,mDC,[esi].OBJECT.x,ebx,0FFFFFFh
			.if [esi].OBJECT.y>256
				;Outside boarder
				mov		[esi].OBJECT.state,0
			.endif
		.endif
	.endif
	retn

PaintBoard endp

SetupGame proc uses ebx,hWin:DWORD

	mov		halt,TRUE
	mov		points,0
	mov		goy,0
	;Shields
	mov		ebx,offset shields
	mov		eax,6
	mov		ecx,MSHIELDS
	.while ecx
		mov		[ebx].OBJECT.x,eax
		mov		[ebx].OBJECT.y,256-32
		mov		[ebx].OBJECT.state,4
		add		eax,12
		add		ebx,sizeof OBJECT
		mov		[ebx].OBJECT.x,eax
		mov		[ebx].OBJECT.y,256-32
		mov		[ebx].OBJECT.state,4
		add		eax,42
		add		ebx,sizeof OBJECT
		dec		ecx
	.endw
	invoke SetupAliens
	mov		gunx,0
	mov		nguns,3
	mov		ebx,offset shots
	mov		ecx,MSHOTS
	.while ecx
		mov		[ebx].OBJECT.state,0
		add		ebx,sizeof OBJECT
		dec		ecx
	.endw
	mov		ebx,offset bombs
	mov		ecx,MBOMBS
	.while ecx
		mov		[ebx].OBJECT.state,0
		add		ebx,sizeof OBJECT
		dec		ecx
	.endw
	invoke InvalidateRect,hWin,NULL,TRUE
	ret

SetupGame endp

BoardProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	ps:PAINTSTRUCT

	.if uMsg==WM_PAINT
		invoke BeginPaint,hWin,addr ps
		invoke PaintBoard,hWin,ps.hdc
		invoke EndPaint,hWin,addr ps
		xor		eax,eax
		ret
	.endif
	invoke CallWindowProc,OldBoardProc,hWin,uMsg,wParam,lParam
	ret

BoardProc endp

TimerProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	.if !halt
		invoke GetKeyState,VK_LEFT
		and		al,80h
		.if al && gunx
			sub		gunx,2
		.endif
		invoke GetKeyState,VK_RIGHT
		and		al,80h
		.if al && gunx<256-12
			add		gunx,2
		.endif
	.endif
	.if !halt || goy
		invoke InvalidateRect,hBoard,NULL,TRUE
	.else
		inc		rseed
	.endif
	ret

TimerProc endp

WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	hBmp:DWORD
	LOCAL	rect:RECT

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		push	hWin
		pop		hWnd
		invoke ImageList_Create,12,12,ILC_COLOR4 or ILC_MASK,5,5
		mov		hIml,eax
		invoke LoadBitmap,hInstance,IDB_ALIEN
		mov		hBmp,eax
		invoke ImageList_AddMasked,hIml,hBmp,0
		invoke DeleteObject,hBmp
		invoke GetDlgItem,hWin,IDC_BOARD
		mov		hBoard,eax
		invoke SetWindowLong,hBoard,GWL_WNDPROC,offset BoardProc
		mov		OldBoardProc,eax
		invoke SetupGame,hBoard
		invoke SetTimer,hWin,200,MTIMER,offset TimerProc
	.elseif eax==WM_SIZE
		invoke GetClientRect,hWin,addr rect
		invoke MoveWindow,hBoard,0,0,rect.right,rect.bottom,TRUE
	.elseif eax==WM_KEYDOWN
		mov		eax,wParam
		.if eax==VK_SPACE
			push	ebx
			mov		ebx,offset shots
			mov		ecx,MSHOTS
			.while ecx
				.if ![ebx].OBJECT.state
					mov		eax,gunx
					add		eax,6
					mov		[ebx].OBJECT.x,eax
					mov		[ebx].OBJECT.y,256-16
					mov		[ebx].OBJECT.state,1
					.break
				.endif
				add		ebx,sizeof OBJECT
				dec		ecx
			.endw
			pop		ebx
		.endif
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		.if eax==IDM_FILE_EXIT
			invoke SendMessage,hWin,WM_CLOSE,0,0
		.elseif eax==IDM_NEW_GAME
			invoke SetupGame,hBoard
			mov		halt,FALSE
		.elseif eax==IDM_HELP_ABOUT
			invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
		.endif
	.elseif eax==WM_CLOSE
		invoke KillTimer,hWin,200
		invoke DestroyWindow,hWin
	.elseif uMsg==WM_DESTROY
		invoke ImageList_Destroy,hIml
		invoke PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWin,uMsg,wParam,lParam
		ret
	.endif
	xor    eax,eax
	ret

WndProc endp

end start
[*ENDTXT*]
[*BEGINTXT*]
Alien.Inc
include windows.inc
include user32.inc
include kernel32.inc
include shell32.inc
include comctl32.inc
include gdi32.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib comctl32.lib
includelib gdi32.lib

WinMain				PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDB_ALIEN			equ 100
IDR_ACCEL			equ 150

IDD_ALIEN			equ 1000
IDC_BOARD			equ 1001

IDR_MENU			equ 10000
IDM_FILE_EXIT		equ 10001
IDM_NEW_GAME		equ 10002
IDM_HELP_ABOUT		equ 10101

MALIENSX			equ 8		;Number of aliens in x direction
MALIENSY			equ 6		;Number of aliens in y direction
MSHOTS				equ 3		;Number of shots
MBOMBS				equ 5		;Number of bombs
MSHIELDS			equ 5		;Number of shields
MTIMER				equ 30		;Speed

OBJECT	struct
	x		dd ?
	y		dd ?
	state	dd ?
OBJECT ends

.const

ClassName			db 'DLGCLASS',0
AppName				db 'Alien invaders',0
AboutMsg			db 'RadASM Alien invaders',13,10,'Copyright © KetilO 2002',0
gameover1			db 'And so ended life on',0
gameover2			db 'earth as we know it ...',0
gameover3			db 'KetilO © 2002',0

fmtStr				db '%lu',0

.data?

hInstance			dd ?
CommandLine			dd ?
hWnd				dd ?
hAccel				dd ?

hBoard				dd ?
OldBoardProc		dd ?
hIml				dd ?

rseed				dd ?
halt				dd ?
points				dd ?
nguns				dd ?
gunx				dd ?
naliens				dd ?
caliens				dd ?
aliensdirx			dd ?
aliensdirxs			dd ?
aliensdiry			dd ?
goy					dd ?
shots				OBJECT MSHOTS dup(<>)
bombs				OBJECT MBOMBS dup(<>)
shields				OBJECT MSHIELDS*2 dup(<>)
aliens				OBJECT MALIENSX*MALIENSY dup(<>)
[*ENDTXT*]
[*BEGINTXT*]
Alien.Rc
#include "Res/AlienMnu.rc"
#include "Res/AlienDlg.rc"
#include "Res/AlienAcl.rc"
#include "Res/AlienRes.rc"
[*ENDTXT*]
[*BEGINBIN*]
Alien.dlg
6500000001000000444C47434C41535300000000000000000000000000000000
0000000000000000416C69656E2E6D6E75000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F6FFFFFF00000000E90300000000000000000000
0000000000000000AE080ABB00000000D60528000100000087A54100C6051100
000000008008CF10010000000A0000000A00000087010000AE010000416C6965
6E20696E76616465727300000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F414C49454E0000000000000000000000000000000000000000000000000000
0000000000CA05100000000000E104FFFFD6052800CC05120004000050000200
0000000000000000008001000080010000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000190000001900000000000000E90300004944435F424F4152440000000000
0000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*BEGINBIN*]
Alien.mnu
4944525F4D454E55000000000000000000000000000000000000000000000000
10270000112700000100000000444D5F00000000000000000000000000000000
000000000000000000000000000000002646696C650000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0100000049444D5F4E45575F47414D4500000000000000000000000000000000
0000000012270000264E65772047616D655C744E000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000010000000000000000000000000000000100000000444D5F
0000000000000000000000000000000000000000000000000000000000000000
2D00000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
010000000000000000000000000000000100000049444D5F46494C455F455849
5400000000000000000000000000000000000000112700004526786974000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000100000000000000
000000004E0000000100000000444D5F00000000000000000000000000000000
000000000000000000000000000000002648656C700000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0100000049444D5F48454C505F41424F55540000000000000000000000000000
00000000752700002641626F7574000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
000000000000000001000000000000000000000000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINBIN*]
Res\Alien.bmp
424DF60100000000000076000000280000003C0000000C000000010004000000
00008001000000000000000000000000000000000000000000000000BF0000BF
000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000FF0000FF
000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
00000000000000002200000000220022000022000000CCCCCCCCCCCCBBB00000
00BBBB0000000BBB0020000002000020000002000000CCCCCCCCCCCCBBB00000
00BBBB0000000BBB0002000020000002000020000000CCCCCCCCCCCCBBB00000
00BBBB0000000BBB0222222222200222222222200000CCCCCCCCCCCCBBB00000
00BBBB0000000BBB2200022000222202000020220000CCCCCCCCCCCCBBB00000
00BBBB0000000BBB220200002022220002200022000000CCCCCCCC00BBBB0000
0BBBBBB00000BBBB222222222222222222222222000000CCCCCCCC00BBBBBBBB
BBBBBBBBBBBBBBBB22292222922222222222222200000000CCCC00000BBBBBBB
BBBBBBBBBBBBBBB022999229992222999229992200000000CCCC000000BBBBBB
BBBBBBBBBBBBBB002229222292222222222222220000000000000000000BBBBB
BBBBBBBBBBBBB00002222222222002222222222000000000000000000000BBBB
BBBBBBBBBBB000000022222222000022222222000000
[*ENDBIN*]
[*BEGINTXT*]
Res\AlienAcl.rc
#define IDR_ACCEL 150
IDR_ACCEL ACCELERATORS DISCARDABLE
BEGIN
  78,IDM_NEW_GAME,VIRTKEY,NOINVERT
END
[*ENDTXT*]
[*BEGINTXT*]
Res\AlienDlg.rc
#define IDD_ALIEN 1000
#define IDC_BOARD 1001
IDD_ALIEN DIALOGEX 6,6,255,248
CAPTION "Alien invaders"
FONT 8,"MS Sans Serif"
CLASS "DLGCLASS"
STYLE 0x10CF0880
EXSTYLE 0x00000001
BEGIN
  CONTROL "",IDC_BOARD,"Static",0x50000004,0,0,256,236,0x00000200
END
[*ENDTXT*]
[*BEGINTXT*]
Res\AlienMnu.rc
#define IDR_MENU 10000
#define IDM_NEW_GAME 10002
#define IDM_FILE_EXIT 10001
#define IDM_HELP_ABOUT 10101
IDR_MENU MENUEX
BEGIN
  POPUP "&File",,,
  BEGIN
    MENUITEM "&New Game\tN",IDM_NEW_GAME,,
    MENUITEM "",,0x00000800,
    MENUITEM "E&xit\tAlt+F4",IDM_FILE_EXIT,,
  END
  POPUP "&Help",,,
  BEGIN
    MENUITEM "&About",IDM_HELP_ABOUT,,
  END
END
[*ENDTXT*]
[*BEGINTXT*]
Res\AlienRes.rc
#define IDB_ALIEN						100
IDB_ALIEN				BITMAP   DISCARDABLE "Res/ALIEN.bmp"
[*ENDTXT*]
