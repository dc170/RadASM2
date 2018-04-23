; DLL creation example

format MS COFF
public DllEntryPoint
public ShowErrorMessage
public ShowLastError

include '%include%/win32ax.inc'

; Link include export&import&if include files + those with alink

section '.code' code readable executable

proc DllEntryPoint,hinstDLL,fdwReason,lpvReserved
	enter
	mov	eax,TRUE
	return
endp

; VOID ShowErrorMessage(HWND hWnd,DWORD dwError);

proc ShowErrorMessage,hWnd,dwError
  .lpBuffer dd ?
	enter
	lea	eax,[.lpBuffer]
	invoke	FormatMessage,FORMAT_MESSAGE_ALLOCATE_BUFFER+FORMAT_MESSAGE_FROM_SYSTEM,0,[dwError],LANG_NEUTRAL,eax,0,0
	invoke	MessageBox,[hWnd],[.lpBuffer],NULL,MB_ICONERROR+MB_OK
	invoke	LocalFree,[.lpBuffer]
	return
endp

; VOID ShowLastError(HWND hWnd);

proc ShowLastError,hWnd
	enter
	invoke	GetLastError
	stdcall ShowErrorMessage,[hWnd],eax
	return
endp
