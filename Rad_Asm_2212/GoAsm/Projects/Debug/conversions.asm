.data
	cmp_09	dq	0909090909090909h	; do 8 compares in parallel
	add_30	dq	3030303030303030h	;'0'
	add_37	dq	3737373737373737h	;'A'
	mask_0f	dq	0f0f0f0f0f0f0f0fh 

.code

dbgdq2ascii FRAME pqwValue,lpBuffer
	uses ebx, esi, edi
	LOCAL qtemp		:Q
	LOCAL qstore	:Q

	; The Svin

	movq [qstore],mm7
	emms
	
	mov esi,[pqwValue]
	mov edi,[lpBuffer]
	mov edx,[esi]
	mov eax,[esi+4]

	cmp eax,0DE0B6B3h
	jc  >C1
	jne >C2
	cmp edx,0A7640000h
	jc  >C1 
C2:
	cmp eax,8AC72304h
	jc  >D1
	jne >D2
	cmp edx,89E80000h
	jc  >D1
D2:
	mov B[edi],'1'
	sub edx,89E80000h
	lea edi,[edi+1]
	sbb eax,8AC72304h

D1:
	mov B[edi],'/'
	:	
	inc B[edi]
	sub edx,0A7640000h
	sbb eax,0DE0B6B3h
	jnc <
	add edx,0A7640000h
	adc eax,0DE0B6B3h
	inc edi

C1:
	mov [qtemp],edx
	mov [qtemp+4],eax

	sub esp,10
	fild Q[qtemp]
	fbstp T[esp]
	xor esi,esi
	:
	pop eax
	bswap eax
	mov ebx,eax	  	

	mov ecx,eax	
	mov bl,bh

	shr ecx,16	
	mov ah,al

	shr bl,4		
	shr al,4

	and bh,0fh	
	and ah,0fh

	shl ebx,16	
	and eax,0FFFFh

	mov edx,ecx	
	mov cl,ch

	mov dh,dl	
	shr cl,4	

	shr dl,4		
	and ch,0fh

	and dh,0fh	
	shl ecx,16

	lea eax,[eax+ebx+30303030h]	
	lea edx,[edx+ecx+30303030h]

	mov [edi+10],eax
	mov [edi+14],edx
	xor esi,1
	lea edi,[edi-8]
	jne <

	mov ah,[esp]
	add edi,16
	mov al,ah
	add esp,2
	shr  al,4
	mov esi,[lpBuffer]
	and eax,0f0fh
	or eax,3030h
	mov [edi],ax
	cmp edi,esi
	mov B[edi+18],0
	jne >P1
	mov ecx,-20
	add edi,19
	:
	inc ecx
	cmp B[edi+ecx],30h
	je <
	mov eax,ecx
	js >Z0
	neg eax
	add esi,eax
	:	
	mov al,[edi+ecx]
	mov [esi+ecx],al
	inc ecx
	jne <

P1:
	movq mm7,[qstore]
	emms
	ret
Z0:  
	mov B[esi+1],0
	jmp P1
endf

dbgqwordtohex FRAME pdqValue,lpBuffer
	
	mov ecx,[pdqValue]
	push ecx
	invoke dbgdwordtohex,[ecx+4],[lpBuffer]
	mov eax,[lpBuffer]
	add eax,8
	pop ecx
	invoke dbgdwordtohex,[ecx],eax
	RET
ENDF

dbgdwordtohex FRAME dwValue,lpBuffer
	push esi
	mov edx,[lpBuffer]
	mov esi,[dwValue]

	xor eax, eax
	xor ecx, ecx

	mov [edx+8], al
	mov cl, 7

	:
	mov eax, esi
	and al, 0Fh ; 00001111b

	cmp al,10
	sbb al,69h
	das

	mov [edx + ecx], al
	shr esi, 4
	dec ecx
	jns < 

	pop esi

	RET
ENDF

dbgdwordtoascii FRAME dwValue, lpBuffer

    invoke wsprintfA,[lpBuffer],ADDR szDbgDecFormat,[dwValue]
    add esp,12
    cmp eax, 3
    jge >
		xor eax, eax
  	:
	RET
ENDF

DbgPrintDouble FRAME dwLine,DoubleLow,DoubleHi,pArgName
	LOCAL pMem		:D

	invoke GlobalAlloc,040h,256
	mov [pMem],eax
	invoke DbgFormatLine,[pMem],[dwLine],[pArgName]
	push eax
	push [DoubleHi]
	push [DoubleLow]
	call FloatToAscii.lib:DbgFloatToStr
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]

	RET
ENDF

DbgPrintQWORD FRAME dwLine,pQWORD,pArgName
	LOCAL pMem		:D

	invoke GlobalAlloc,040h,256
	mov [pMem],eax
	invoke DbgFormatLine,[pMem],[dwLine],[pArgName]
	push eax
	push [pQWORD]
	call dbgdq2ascii
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]

	RET
ENDF

DbgPrintQWORDHex FRAME dwLine,pQWORD,pArgName
	LOCAL pMem		:D

	invoke GlobalAlloc,040h,256
	mov [pMem],eax
	invoke DbgFormatLine,[pMem],[dwLine],[pArgName]

	push eax
	push [pQWORD]
	call dbgqwordtohex

	mov edi,[pMem]
	mov ecx,255
	mov al,0
	repne scasb
	mov W[edi-1],68h
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]

	RET
ENDF

ZeroMem FRAME lpBuffer,nBytes
	uses ecx,edi,eax

	mov ecx,[nBytes]
	; Do the evenly divisible ones
	shr ecx,2
	mov eax,0
	mov edi,[lpBuffer]
	rep stosd
	; do the remainder
	mov ecx,[nBytes]
	and ecx,3
	rep stosb

	RET
ENDF

StrLen FRAME lpString
	uses ebx,edx,ecx

		mov		eax,[lpString]         ; get pointer to string]
		lea		edx,[eax+3]            ; pointer+3 used in the end
	:  
		mov		ebx,[eax]              ; read first 4 bytes
		add		eax,4                  ; increment pointer
		lea		ecx,[ebx-01010101h]    ; subtract 1 from each byte
		not		ebx                    ; invert all bytes
		and		ecx,ebx                ; and these two
		and		ecx,80808080h    
		jz		<	               ; no zero bytes, continue loop
		test	ecx,00008080h          ; test first two bytes
		jnz		>
		shr		ecx,16                 ; not in the first 2 bytes
		add		eax,2
	:
		shl		cl,1                   ; use carry flag to avoid branch
		sbb		eax,edx                ; compute length

    ret
ENDF

CopyString FRAME Dest,Source
	uses esi,edi,ecx
	invoke StrLen,[Source]
	push eax		;save String length
	shr  eax,2		;eax = eax / 4
	inc eax
	mov ecx,eax
	mov esi,[Source]
	mov edi,[Dest]
	
	:
		mov eax, [esi]
		add esi, 4
		mov [edi], eax
		add edi, 4
		dec ecx
	jnz <

	pop eax			;load String length
	add eax,[Dest]
	ret
ENDF

CatString FRAME Dest,Source
	
	invoke StrLen,[Dest]
	add eax,[Dest]
	invoke CopyString,eax,[Source]
	RET
ENDF
