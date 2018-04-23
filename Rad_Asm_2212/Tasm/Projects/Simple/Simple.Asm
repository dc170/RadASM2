.486p
.MODEL FLAT,STDCALL
locals
jumps
UNICODE=0

include windows.inc
includelib import32.lib

GetModuleHandleA	PROCDESC	WINAPI	:DWORD
MessageBoxA			PROCDESC	WINAPI	:DWORD, :DWORD, :DWORD, :DWORD
MessageBeep			PROCDESC	WINAPI	:DWORD
ExitProcess			PROCDESC	WINAPI	:DWORD

.DATA

szText		db 'Text',0
hInst		dd 0

.CODE

Start:
	call	GetModuleHandleA,0
	mov		hInst,eax
	call	MessageBeep,MB_OK
	call	MessageBoxA,0,offset szText,offset szText,MB_OK
	call	ExitProcess,0

end Start
