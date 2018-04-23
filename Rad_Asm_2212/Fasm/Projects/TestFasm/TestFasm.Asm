; Beer - example of Win32 program
; be sure to compile your RC before assembling
format PE GUI 4.0

include 'TestFasm.Inc'
include '%fasminc%\win32a.inc'

entry MyEntry

section '.code' code readable executable

	MyEntry:
	
	invoke	GetModuleHandle,0
	invoke	DialogBoxParam,eax,1000,HWND_DESKTOP,DialogProc,0
	invoke	ExitProcess,0

proc DialogProc,hwnddlg,msg,wparam,lparam
	enter
	push	ebx esi edi
	cmp	[msg],WM_INITDIALOG
	je	wminitdialog
	cmp	[msg],WM_COMMAND
	je	wmcommand
	cmp	[msg],WM_CLOSE
	je	wmclose
	xor	eax,eax
	jmp	finish
  wminitdialog:
	jmp	processed
  wmcommand:
	cmp	[wparam],BN_CLICKED shl 16 + ID_CANCEL
	je	wmclose
	invoke	mciSendString,_cmd_open,0,0,0
	invoke	mciSendString,_cmd_eject,0,0,0
	invoke	mciSendString,_cmd_close,0,0,0
	jmp	wmclose
  wmclose:
	invoke	EndDialog,[hwnddlg],0
  processed:
	mov	eax,1
  finish:
	pop	edi esi ebx
	return
endp

section '.data' data readable writeable

_cmd_open db 'open cdaudio',0
_cmd_eject db 'set cdaudio door open',0
_cmd_close db 'close cdaudio',0

section '.idata' import data readable writeable

  library kernel, 'KERNEL32.DLL',\
		  user,   'USER32.DLL',\
		  winmm,  'WINMM.DLL'

  import  kernel,\
	  GetModuleHandle,'GetModuleHandleA',\
	  ExitProcess,	  'ExitProcess'

  import  user,\
	  DialogBoxParam, 'DialogBoxParamA',\
	  EndDialog,	  'EndDialog',\
	  SendMessage,	  'SendMessageA'

  import  winmm,\
	  mciSendString,  'mciSendStringA'

section '.rsrc' resource from 'testfasm.res' data readable
