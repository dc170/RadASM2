#ifndef GetLastError
declare function GetLastError alias "GetLastError" () as LRESULT
#endif
#ifndef ExitProcess
declare sub ExitProcess alias "ExitProcess" (byval as UINT)
#endif
#ifndef SendMessage
declare function SendMessage alias "SendMessageA" (byval as HWND,byval as UINT,byval as WPARAM,byval as LPARAM) as LRESULT
#endif
#ifndef WM_COPYDATA
#define WM_COPYDATA 74
#endif

dim shared hwndradbg as HWND
dim shared bpidradbg as HWND
dim shared varradbg as HWND

'type RADBG
'	_err	as dword
'	_edi	as dword
'	_esi	as dword
'	_ebp	as dword
'	_esp	as dword
'	_ebx	as dword
'	_edx	as dword
'	_ecx	as dword
'	_eax	as dword
'	_efl	as dword
'	_eip	as dword
'	_var	as dword
'	nid	as dword
'end type

sub RADbg(byval rabpid as dword,byval rahwnd as dword,byval ravar as dword)

	hwndradbg=rahwnd
	bpidradbg=rabpid
	varradbg=ravar
	asm
	pushd	hwndradbg
	pushd	bpidradbg
	pushd	varradbg
	call	RADbg1
	end asm
	exit sub

	asm
RADbg1:
	pushfd
	pushad
	call GetLastError
	pushd	eax
	pushd	esp
	pushd	13*4
	pushd	0

	pushd	esp
	pushd	-1
	pushd	WM_COPYDATA
	pushd hwndradbg
	call SendMessage
	add	esp,12
	or		eax,eax
	jne	@@
		pushd	0
		call ExitProcess
  @@:
	popd	eax
	popad
	popfd
	ret 12
	end asm

end sub
