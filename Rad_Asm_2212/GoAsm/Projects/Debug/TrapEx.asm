
.code
TrapEx_seh:
	PUSH EBP
	MOV EBP,ESP
	;;** [EBP+8]=pointer to EXCEPTION_RECORD 
	;;** [EBP+0Ch]=pointer to ERR structure 
	;;** [EBP+10h]=pointer to CONTEXT record 
	PUSH EBX,EDI,ESI
	mov edx, [EBP+8]
	mov ebx,[EBP+10h]
	cmp D[edx+EXCEPTION_RECORD.ExceptionCode],80000003h ;EXCEPTION_BREAKPOINT
	je >L2
	cmp D[edx+EXCEPTION_RECORD.ExceptionCode],80000004h ;EXCEPTION_SINGLE_STEP
	je >L2
	jmp >>L1
	L2:
		cmp D[___hLib],0
		jz >>.exit
			mov edx,[EBP+8]
			mov D[DbgIHL.SizeOfStruct], 20 ;sizeof IMAGEHLP_LINE
			pushad
			push OFFSET DbgIHL
			push OFFSET dwTrapDisp
			push [edx+EXCEPTION_RECORD.ExceptionAddress]
			push [___hInst]
			call [___pGetLine]
			mov [esp+28], eax
			popad
			or eax,eax
			jz >>.exit
			;	push [DbgIHL.LineNumber]
			;	pop [dwTrapLine]
			;	push [DbgIHL.FileName]
			;	pop [pTrapFile]
				mov ebx, [EBP+10h] ; pContext
				mov edx, [EBP+08h]	; pExcept
				mov eax, [edx+EXCEPTION_RECORD.ExceptionAddress]
				mov eax, [eax]
				cmp al,0C3h
				jne >L3
					mov D[ebx+CONTEXT.regEip], OFFSET TrapExEnd_seh
					jmp >>.exit
				L3:
				pushfd
				pop eax
				or eax, 100h
				push eax
				pop [ebx+CONTEXT.regFlag]
				jmp >>.exit

	L1:
		invoke DbgDebugPrint, OFFSET szTrapExcHead
		mov edx,[EBP+8] ; 
		invoke DbgGetExName, [edx+EXCEPTION_RECORD.ExceptionCode] ; 
		mov ebx, [EBP+10h]
		invoke wsprintfA, OFFSET szTrapExcCode, OFFSET szTrapExcCodeFmt, eax, [ebx+CONTEXT.regEip]
		add esp,16
		invoke DbgDebugPrint, OFFSET szTrapExcCode
		invoke wsprintfA, OFFSET szTrapRegs, OFFSET szTrapRegsFmt, [ebx+CONTEXT.regEax],\
			[ebx+CONTEXT.regEbx], [ebx+CONTEXT.regEcx], [ebx+CONTEXT.regEdx],\
			[ebx+CONTEXT.regEsi], [ebx+CONTEXT.regEdi], [ebx+CONTEXT.regEbp],\
			[ebx+CONTEXT.regEsp], [ebx+CONTEXT.regEip]
		add esp,44
		invoke DbgDebugPrint, OFFSET szTrapRegs
		mov D[ebx+184], OFFSET TrapExEnd_seh ;CONTEXT.regEip
		invoke DbgFormatFlags, [ebx+CONTEXT.regFlag], OFFSET szTrapFlags, OFFSET szTrapFlagsFmt 
		invoke wsprintfA, OFFSET szTrapSeg, OFFSET szTrapSegFmt, [ebx+CONTEXT.regCs], \
			[ebx+CONTEXT.regDs], [ebx+CONTEXT.regSs], [ebx+CONTEXT.regEs], \
			[ebx+CONTEXT.regFs], [ebx+CONTEXT.regGs], eax
		add esp,36
		invoke DbgDebugPrint, OFFSET szTrapSeg
		invoke DbgDebugPrint, OFFSET szTrapExcBottom
	.exit

	xor eax, eax ; 0 = ExceptionContinueExecution
	POP ESI,EDI,EBX
	MOV ESP,EBP
	POP EBP
	RET

TrapExEnd_seh:
    push eax
    mov eax, [esp]
    FS mov [0], eax
    pop eax
    mov esp, [___esp]
    jmp [___eh]

DbgGetExName FRAME ExCode
	mov eax, [ExCode]
	:
	cmp eax,0C0000005h ; EXCEPTION_ACCESS_VIOLATION
	jne >
		mov eax,OFFSET expt0C0000005h
		jmp >>.exit
	:
	cmp eax,0C000008Ch ;EXCEPTION_ARRAY_BOUNDS_EXCEEDED
	jne >
		mov eax,OFFSET expt0C000008Ch
		jmp >>.exit
	:
	cmp eax,080000003h ;EXCEPTION_BREAKPOINT
	jne >
		mov eax,OFFSET expt080000003h
		jmp >>.exit
	:
	cmp eax,080000002h ;EXCEPTION_DATATYPE_MISALIGNMENT
	jne >
		mov eax,OFFSET expt080000002h
		jmp >>.exit
	:
	cmp eax,0C000008Dh ;EXCEPTION_FLT_DENORMAL_OPERAND
	jne >
		mov eax,OFFSET expt0C000008Dh
		jmp >>.exit
	:
	cmp eax,0C000008Eh ;EXCEPTION_FLT_DIVIDE_BY_ZERO
	jne >
		mov eax,OFFSET expt0C000008Eh
		jmp >>.exit
	:
	cmp eax,0C000008Fh ;EXCEPTION_FLT_INEXACT_RESULT
	jne >
		mov eax,OFFSET expt0C000008Fh
		jmp >>.exit
	:
	cmp eax,0C0000090h ;EXCEPTION_FLT_INVALID_OPERATION
	jne >
		mov eax,OFFSET expt0C0000090h
		jmp >.exit
	:
	cmp eax,0C0000091h ;EXCEPTION_FLT_OVERFLOW
	jne >
		mov eax,OFFSET expt0C0000091h
		jmp >.exit
	:
	cmp eax,0C0000092h ;EXCEPTION_FLT_STACK_CHECK
	jne >
		mov eax,OFFSET expt0C0000092h
		jmp >.exit
	:
	cmp eax,0C0000093h ;EXCEPTION_FLT_UNDERFLOW
	jne >
		mov eax,OFFSET expt0C0000093h
		jmp >.exit
	:
	cmp eax,0C000001Dh ;EXCEPTION_ILLEGAL_INSTRUCTION
	jne >
		mov eax,OFFSET expt0C000001Dh
		jmp >.exit
	:
	cmp eax,0C0000006h ;EXCEPTION_IN_PAGE_ERROR
	jne >
		mov eax,OFFSET expt0C0000006h
		jmp >.exit
	:
	cmp eax,0C0000094h ;EXCEPTION_INT_DIVIDE_BY_ZERO
	jne >
		mov eax,OFFSET expt0C0000094h
		jmp >.exit
	:
	cmp eax,0C0000095h ;EXCEPTION_INT_OVERFLOW
	jne >
		mov eax,OFFSET expt0C0000095h
		jmp >.exit
	:
	cmp eax,080000004h ;EXCEPTION_SINGLE_STEP
	jne >
		mov eax,OFFSET expt080000004h
		jmp >.exit
	:
		mov eax,OFFSET exptOTHER
	.exit
	ret
endf

DbgFormatFlags FRAME fl,szFlag,szFmt
    local szFl[16]:B

	mov B[szFl], "o"
	mov B[szFl+1], 0
	mov B[szFl+2], "d"
	mov B[szFl+3], 0
	mov B[szFl+4], "i"
	mov B[szFl+5], 0
	mov B[szFl+6], "s"
	mov B[szFl+7], 0
	mov B[szFl+8], "z"
	mov B[szFl+9], 0
	mov B[szFl+10], "a" 
	mov B[szFl+11], 0
	mov B[szFl+12], "p"
	mov B[szFl+13], 0
	mov B[szFl+14], "c"
	mov B[szFl+15], 0
	mov eax, [fl]
	test eax, 800h
	jnz >
		sub B[szFl+0], 20h
	:
	test eax, 400h
	jnz >
		sub B[szFl+2], 20h
	:
	test eax, 200h
	jnz >
		sub B[szFl+4], 20h
	:
	test eax, 80h
	jnz >
		sub B[szFl+6], 20h
	:
	test eax, 40h
	jnz >
		sub B[szFl+8], 20h
	:
	test eax, 10h
	jnz >
		sub B[szFl+10], 20h
	:
	test eax, 4h
	jnz >
		sub B[szFl+12], 20h
	:
	test eax, 1h
	jnz >
		sub B[szFl+14], 20h
	:
	invoke wsprintfA, [szFlag], [szFmt], OFFSET szFl, OFFSET szFl + 2, \
		OFFSET szFl + 4, OFFSET szFl + 6, OFFSET szFl + 8, OFFSET szFl + 10, \
		OFFSET szFl + 12, OFFSET szFl + 14
	add esp,40
	mov eax, [szFlag]
    ret
endf
