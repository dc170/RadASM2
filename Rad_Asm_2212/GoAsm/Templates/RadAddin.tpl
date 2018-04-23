DLL
RadAddIn
RasASM Addin DLL
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,0,0,0,0
1=4,O,$B\GORC.EXE /r,1
2=3,O,$B\GoAsm.EXE,2
3=7,OT,$B\GoLink @$B\GFL.txt @$6 /dll /entry DllEntryPoint,3
4=0,0,,5
5=
6=
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
RadAddIn.Asm
#Include "RadAddIn.Inc"
#Include "C:\RadASM\GoAsm\Inc\RadAsm.inc"

DATA SECTION
	hInstance		DD		0
	lpHandles		DD		0
	lpProcs			DD		0
	lpData			DD		0

	hSubMenu		DD		0
	AddInID			DD		0

	strMenuText		DB		"RadAddIn",0

CODE SECTION

DllEntryPoint	FRAME hInst, reason, reserved1
    mov eax,[hInst]
    mov [hInstance], eax
    xor eax, eax
    inc eax
    ret
ENDF

InstallDll	FRAME hWin, fOpt
	invoke SendMessage, [hWin], AIM_GETHANDLES, 0, 0
	mov	[lpHandles], eax
	invoke SendMessage, [hWin], AIM_GETPROCS, 0, 0
	mov [lpProcs], eax
	invoke SendMessage, [hWin], AIM_GETDATA, 0, 0
	mov [lpData], eax
	mov ecx, 4
	add ecx, [eax+ADDINDATA.fMaximized]
	push ecx
	invoke SendMessage, [hWin], AIM_GETMENUID, 0, 0
	mov [AddInID], eax
	invoke SendMessage, [hWin], AIM_GETHANDLES, 0, 0
	push [eax+ADDINHANDLES.hMenu]
	call GetSubMenu
	mov [hSubMenu], eax
	invoke AppendMenu, eax, MF_STRING, [AddInID], offset strMenuText

	mov eax, RAM_COMMAND | RAM_INITMENUPOPUP
	ret
ENDF

DllProc	FRAME hWin, uMsg, wParam, lParam

	cmp D[uMsg], AIM_COMMAND
	jnz >.INITMENUPOPUP
		mov eax, [wParam]
		cmp [AddInID], eax
		jnz >.ExitMsgLoop
			mov eax,[lpHandles]
			mov eax,[eax+ADDINHANDLES.hWnd]
			;
			; Call your code here
			; Be sure to add ,4 to the link command if you are using resources
			;
			mov eax,TRUE
			ret

	.INITMENUPOPUP
	cmp D[uMsg], AIM_INITMENUPOPUP
	jnz >.ExitMsgLoop
		mov eax, [lpData]
		mov eax, [eax+ADDINDATA.fProject]
		xor eax, 1
		or eax, MF_BYCOMMAND
		invoke EnableMenuItem, [hSubMenu], [AddInID], eax

	.ExitMsgLoop
	xor eax, eax
	ret
ENDF
[*ENDTXT*]
[*BEGINTXT*]
RadAddIn.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
RadAddIn.Def
/export InstallDll
/export DllProc
[*ENDTXT*]
[*ENDPRO*]
