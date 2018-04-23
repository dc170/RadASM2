;##################################################################
; DIALOGAPP
;##################################################################

#include "DialogBox.Inc"

;##################################################################
; BREAKPOINT INCLUDE

#include "\RadASM\GoAsm\inc\RadDbg.a"

;##################################################################
; VKIM INCLUDE

#include "\RadASM\GoAsm\inc\debug.a"

.DATA
	hInst				DD 	0

;##################################################################

.CONST

;##################################################################

.CODE

Start:
	INVOKE GetModuleHandle, 0
	MOV [hInst],EAX
	INVOKE DialogBoxParam,[hInst],1000,0,ADDR DlgProc,0
	INVOKE ExitProcess,0

DlgProc FRAME hwnd,uMsg,wParam,lParam
	MOV EAX,[uMsg]

	.WMINITDIALOG
		CMP EAX,WM_INITDIALOG
		JNE >.WMCOMMAND
		JMP >.EXIT

	.WMCOMMAND
		CMP EAX,WM_COMMAND
		JNE >.WMCLOSE
		JMP >.EXIT

	.WMCLOSE
		CMP EAX,WM_CLOSE
		JNE >.DEFPROC
		INVOKE EndDialog,[hwnd],0

	.DEFPROC
		mov EAX,FALSE
		RET

	.EXIT

	MOV EAX, TRUE
	RET
ENDF
