;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    CodeTemplates Addin by drizz        ;;
;;    CodeComplete used as a reference    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.686
.model flat,stdcall
option casemap:none
assume fs:nothing
;-
WIN32_LEAN_AND_MEAN EQU <>;; *my* projects compile faster :P :P :P
include windows.inc
;-
include kernel32.inc
includelib kernel32.lib
include gdi32.inc
includelib gdi32.lib
include user32.inc
includelib user32.lib
;-
include stdlib.inc
includelib stdlib.lib
;-
include Rad\RadAsm.inc ; *slightly edited*
ID_EDIT equ 65501; from where is this?? 
include Rad\RAEdit.inc
;-

.data?
dd? hInstance,pAddinHandles,pAddinProcs,pAddinData,hEdt1,OldEditProc1,hEdt2,OldEditProc2,nAsm

include CodeTemplates.inc

.code

TextOutput proc lpszStr
   pushad
   mov eax,pAddinProcs
   invoke [eax].ADDINPROCS.lpTextOut,lpszStr
   popad
   ret
TextOutput endp

; The addin initalization proc
; Return hooks in eax:=<0>,edx:=<0>,ecx:=<0>
; fOpt is a value read from ini and passed to the dll
; Use for option settings
InstallDll proc EXPORT hWin:DWORD,fOpt:DWORD
	mov pAddinHandles,AddInMsg(hWin,AIM_GETHANDLES); Get handles
	mov pAddinProcs,AddInMsg(hWin,AIM_GETPROCS); Get procs
	mov pAddinData,AddInMsg(hWin,AIM_GETDATA); Get data
	;mov nEditsOpened,0
	; messages to hook into
	mov eax,AddInHook(AIM_PROJECTOPENED,AIM_PROJECTCLOSED)
	mov ecx,RAM_EDITKEYDOWN
	mov edx,RAM_NULL
	ret
InstallDll Endp

; This proc handles messages sent from RadASM to our dll
; Return TRUE to prevent RadASM and other dll's from
; processing command.
DllProc proc EXPORT hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; This proc handles messages sent from RadASM to our dll
	; Return TRUE to prevent RadASM and other dll's from
	; processing command.
	mov eax,uMsg
	.if eax==AIM_PROJECTOPENED
		;invoke TextOutput,T('AIM_PROJECTOPENED')
		invoke CtLbCreate
	.elseif eax==AIM_PROJECTCLOSED
		;invoke TextOutput,T('AIM_PROJECTCLOSED')
		invoke CtLbDestroy
	.elseif eax==AIM_EDITKEYDOWN
		.if wParam == VK_J
			invoke GetKeyState,VK_CONTROL
			and eax,80h
			.if !zero?
				invoke CtLbPopup
				return TRUE
			.endif
		.endif
	.endif
	return FALSE

DllProc Endp

DllEntry proc hinstDLL:DWORD,fdwReason:DWORD,pvReserved:DWORD
	.if fdwReason == DLL_PROCESS_ATTACH
		m2mr hInstance,hinstDLL
	.endif
	mov eax,TRUE
	ret
DllEntry Endp

End DllEntry
