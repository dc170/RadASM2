;Use with version 1.0.0.2 of RADbg.dll
struc RADBGS
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
	nid	dd ?
ends

macro RADbg
	marg	rabpid, rahwnd, ravar
	push	rahwnd
	push	rabpid
	push	ravar
	call	RADebug
endm


.code

RADebug:
	pushfd
	pushad
	call	GetLastError
	push	eax
	
	mov	ebx,[esp+RADBGS]	; in fact esp + size RADBGS
	push	esp
	push	size RADBGS
	push	0
	invoke	SendMessageA,ebx,WM_COPYDATA,-1,esp
	add	esp,12
	.if eax == 0
		invoke	ExitProcess,0
	.endif
	
	pop	eax
	popad
	popfd
	reti	12

