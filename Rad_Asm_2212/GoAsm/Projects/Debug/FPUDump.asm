
.CODE

DbgFPUDump FRAME dwLine
	uses esi,edi,ebx
	LOCAL sts		:W
	LOCAL pad		:W
	LOCAL lev		:D
	LOCAL stks[8]	:T
	LOCAL pdbbuf	:D
	LOCAL pdbbuf1	:D

	invoke GlobalAlloc,040h,256
	mov [pdbbuf],eax
	add eax,128
	mov [pdbbuf1],eax

	invoke DbgFormatLine,[pdbbuf],[dwLine],OFFSET DbgszFPUDump
	invoke DbgDebugPrint,[pdbbuf]
	invoke ZeroMem,[pdbbuf],256

	fstsw W[sts]

	xor eax, eax
	mov ax, [sts]
	shr eax, 11
	neg eax
	and eax, 7
	mov [lev], eax
	or eax,eax
	jnz >L1
		fst Q[stks]
		fstsw ax
		and ax,41h
		jz >
			mov D[lev], 0
			jmp >L13
		:
			mov D[lev], 8
		L13:
	L1:

	invoke wsprintfA, [pdbbuf], OFFSET szDbgFPU5, [lev]
	add esp,12
	invoke DbgDebugPrint, [pdbbuf]

	xor eax, eax
	mov ax, [sts]
	shr eax, 6
	shl al, 3
	shl ax, 1
	shl al, 1
	shr eax, 7
	and eax, 7
	or eax,eax
	jnz >
		push offset szDbgFPU1
		jmp >L2
	:
	cmp eax,1
	jne >
		push offset szDbgFPU2
		jmp >L2
	:
	cmp eax,4
	jne >
		push offset szDbgFPU3
		jmp >L2
	:
		push offset szDbgFPU4 
	L2:
	call DbgDebugPrint

	xor eax, eax
	xor ecx, ecx
	mov ax,[sts]
	mov edx, OFFSET szDbgFPU6
	add edx, 13
	jmp >L3
	L4:
		rol al,1
		jc >
			or B[edx],20h
			jmp >L5
		:
			and B[edx],0DFh
		L5:
		add edx,2
		inc ecx
	L3:
	cmp ecx,8
	jl <L4
	push offset szDbgFPU6
	call DbgDebugPrint

	xor esi, esi
	xor eax,eax
	lea edi, stks
	jmp >L6
     L7:
     	fstp Q[edi +esi*8]
     	inc esi
	L6:
	cmp esi,[lev]
	jl <L7

	xor esi, esi

	jmp >L8
	L9:
		push [pdbbuf1]
		push [edi +esi*8+4]
		push [edi +esi*8]
		call FloatToAscii.lib:DbgFloatToStr ;, [edi + esi*8], [pdbbuf1]
		invoke StrLen,[pdbbuf1]
		cmp eax,1
		jne >
			mov eax,[pdbbuf1]
			mov D[eax],"0.00"
			mov B[eax+4],0
		:
		invoke CatString,[pdbbuf1],OFFSET DbgZeroPad
		invoke wsprintfA, [pdbbuf], OFFSET szDbgFPU7,esi, [pdbbuf1]
		add esp,16
		invoke DbgDebugPrint, [pdbbuf]
		inc esi
	L8:
	cmp esi,[lev]
	jl <L9

	mov esi, [lev]
	dec esi

	cmp esi,0
	jle >L10
		jmp >L11
		L12:
			fld Q[edi +esi*8]
			dec esi
		L11:
		cmp esi,0
		jge <L12
	L10:

	invoke GlobalFree,[pdbbuf]

     ret
endf
