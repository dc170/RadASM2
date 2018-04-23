;Use with version 1.0.0.2 of RADbg.dll
RADBGS struct
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
RADBGS ends

RADbg macro rabpid, rahwnd, ravar
	push	&rahwnd
	push	&rabpid
	push	&ravar
	call	RADebug
endm

.code

RADebug:
	pushfd
	pushad
	call GetLastError
	push	eax
	mov		ebx,[esp+size RADBGS]
	push	esp
	push	size RADBGS
	push	0
	call SendMessageA,ebx,WM_COPYDATA,-1,esp
	add		esp,12
	.if (eax==0)
		call ExitProcess,0
	.endif
	pop		eax
	popad
	popfd
	ret 12

