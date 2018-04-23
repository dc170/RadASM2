Dll Project
AddinTpl
RadASM Addin template
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
3=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$7",3
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
7=0,0,"$E\OllyDbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",2
13=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$7",3
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm
17=0,0,"$E\OllyDbg",5
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
AddinTpl.Asm
;#########################################################################
;		Assembler directives

.486
.model flat,stdcall
option casemap:none

;#########################################################################
;		Include file

include AddinTpl.inc

.code

;#########################################################################
;		Common AddIn Procedures

DllEntry proc hInst:HINSTANCE, reason:DWORD, reserved1:DWORD
	mov eax, hInst
	mov hInstance, eax
	mov eax, TRUE
	ret
DllEntry Endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
InstallDll proc uses ebx hWin:DWORD, fOpt:DWORD
	mov	ebx,hWin

	;Get pointer to handles struct
	invoke SendMessage,ebx,AIM_GETHANDLES,0,0;	
	mov	lpHandles,eax

	;Get pointer to proc struct
	invoke SendMessage,ebx,AIM_GETPROCS,0,0
	mov	lpProc,eax

	;Get pointer to data struct
	invoke SendMessage,ebx,AIM_GETDATA,0,0	
	mov	lpData,eax

	; If Option (fOpt) = 0 then exit
	mov eax,fOpt
	test eax,eax
	je @F
		; Allocate a new menu id
		invoke SendMessage,ebx,AIM_GETMENUID,0,0
		mov IDAddIn,eax
		; Messages to hook into
		mov	eax, RAM_COMMAND OR RAM_CLOSE OR RAM_MENUREBUILD OR RAM_TBRTOOLTIP OR RAM_PROJECTOPENED OR RAM_PROJECTCLOSE

	@@:
	; ECX and EDX must be null before we return
	xor ecx, ecx
	xor edx, edx
	ret 

InstallDll Endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
DllProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; This proc handles messages sent from RadASM to our dll
	; Return TRUE to prevent RadASM and other DLL's from

	mov	eax, uMsg
	.if eax == AIM_COMMAND
		mov eax,wParam
		movzx edx,ax
		shr eax, 16
		.IF edx == IDAddIn && eax == BN_CLICKED
			; Your addin has been selected
		.ENDIF

	.ELSEIF eax==AIM_CLOSE
		;
	.ELSEIF eax==AIM_MENUREBUILD
		;
	.ELSEIF eax==AIM_TBRTOOLTIP
		;
	.ELSEIF eax==AIM_PROJECTCLOSE
		;
	.ELSEIF eax==AIM_PROJECTOPENED
		;
	.endif

	mov eax,FALSE
	ret
DllProc Endp

;#########################################################################

End DllEntry
[*ENDTXT*]
[*BEGINTXT*]
AddinTpl.Inc

;#########################################################################
;		Include files

	include windows.inc
	include kernel32.inc
	include user32.inc
;	include Comctl32.inc
;	include shell32.inc
;	include ComDlg32.inc
;	include Gdi32.inc

;#########################################################################
;		Libraries

	includelib kernel32.lib
	includelib user32.lib
;	includelib Comctl32.lib
;	includelib shell32.lib
;	includelib ComDlg32.lib
;	includelib Gdi32.lib

;#########################################################################
;		RadASM Add In Include

	include \RadASM\Masm\Inc\radasm.inc

;#########################################################################
;		VKim's Debug

	include \RadASM\masm\inc\debug.inc
	includelib \RadASM\masm\lib\debug.lib

	DBGWIN_DEBUG_ON = 1		; include debug info into the program
	DBGWIN_EXT_INFO = 0		; include extra debug info into the program

;#########################################################################
;		Prototypes

	DLLProc					PROTO :DWORD, :DWORD, :DWORD, :DWORD
	InstallDLL				PROTO :DWORD, :DWORD
	
	TextOutput				PROTO :DWORD
	clrOutput				PROTO 
	HexOutput				PROTO :DWORD

.data


.data?

	hInstance			dd ?	;Dll's module handle
	lpHandles			dd ?	;Pointer to handles struct
	lpProc				dd ?	;Pointer to proc struct
	lpData				dd ?	;Pointer to data struct
	hOut				dd ?	;Handle of output window
	IDAddIn				dd ?	;Unique ID for this AddIn

.code

;#########################################################################
;		Output Window procs

TextOutput proc lpszStr

   pushad
   
   push  lpszStr
   mov   eax,lpProc
   call  [eax].ADDINPROCS.lpTextOut
   
   popad	
   ret

TextOutput endp

;#########################################################################

clrOutput proc

   pushad
   
   mov   eax,lpProc
   call  [eax].ADDINPROCS.lpClearOut
   
   popad	
   ret

clrOutput endp

;#########################################################################

HexOutput proc val:DWORD
	
	pushad
	
	push  val
	mov   eax,lpProc
	call  [eax].ADDINPROCS.lpHexOut
	
	popad
	ret
	
HexOutput endp
[*ENDTXT*]
[*BEGINTXT*]
AddinTpl.Def
[*ENDTXT*]
[*BEGINTXT*]
AddinTpl.Txt

This project template for RadASM AddIns is a get-you-starter to make the grunt work easier to manage.
[*ENDTXT*]
[*ENDPRO*]
