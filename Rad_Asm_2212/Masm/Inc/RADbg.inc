;Use with version 1.0.0.2 or 1.0.0.3 of RADbg.dll
RADBG struct
	_err	dd ?
	_edi	dd ?
	_esi	dd ?
	_ebp	dd ?
	_esp	dd ?
	_ebx	dd ?
	_edx	dd ?
	_ecx	dd ?
	_eax	dd ?
	_efl	dd ?
	_eip	dd ?
	_var	dd ?
	nid		dd ?
RADBG ends

RADbg macro rabpid, rahwnd, ravar
	push	&rahwnd
	push	&rabpid
	push	&ravar
	call RADebug
endm

.code

RADebug:
	pushfd
	pushad
	invoke GetLastError
	push	eax
	mov		ebx,[esp+sizeof RADBG]
	push	esp
	push	sizeof RADBG
	push	0
	invoke SendMessage,ebx,WM_COPYDATA,-1,esp
	add		esp,12
	.if !eax
		invoke ExitProcess,0
	.endif
	pop		eax
	popad
	popfd
	ret 12

