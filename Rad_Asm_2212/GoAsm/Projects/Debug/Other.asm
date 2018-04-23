
.code

DbgErrorPrint FRAME dwLine,SkipNoError
	LOCAL pMem			:D

	invoke GetLastError
	mov edi,eax
	mov eax,[SkipNoError]
	or eax,eax
	jz >
		or edi,edi
		jz >.DONE
	:
		invoke GlobalAlloc,040h,128
		mov [pMem],eax
		invoke FormatMessageA,1000h,0,edi,0,OFFSET DbgErrBuf,127,0
		invoke wsprintfA,[pMem],OFFSET DbgErrorFmt,[dwLine],edi,OFFSET DbgErrBuf
		add esp,20
		invoke DbgDebugPrint,[pMem]
		invoke GlobalFree,[pMem]
	.DONE
	RET
ENDF

DbgDisplayLine FRAME dwLine
	LOCAL pMem		:D

	invoke GlobalAlloc,040h,128
	mov [pMem],eax
	invoke DbgFormatLine,eax,[dwLine],OFFSET DbgShowLine
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]

	RET
ENDF

DbgPrintNumber FRAME dwArg,dwLine,fOutType,pArgName ; 0 = dec 1 = hex
	LOCAL pMem		:D

	invoke GlobalAlloc,040h,128
	mov [pMem],eax
	invoke DbgFormatLine,eax,[dwLine],[pArgName]
	mov edi,eax
	mov eax,[fOutType]
	or eax,eax
	jnz >
		invoke dbgdwordtoascii,[dwArg],edi
		jmp >.DONE
	:
		invoke dbgdwordtohex,[dwArg],edi
	.DONE
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]
	RET
ENDF

DbgOutputString FRAME dwLine,pArg,pArgName,szType
	LOCAL pMem		:D
	LOCAL pString	:D

	cmp D[szType],1
	jne >
		invoke lstrlenW,[pArg]
		inc eax
		shl eax,2
		push eax
		invoke GlobalAlloc,040h,eax
		mov [pString],eax
		pop eax
		invoke WideCharToMultiByte,0,0,[pArg],-1,[pString],eax,0,0
		jmp >L1
	:
		invoke lstrlenA,[pArg]
		inc eax
		invoke GlobalAlloc,040h,eax
		mov [pString],eax
		invoke CopyString,[pString],[pArg]
	L1:
	invoke StrLen,[pString]
	add eax,32
	invoke GlobalAlloc,040h,eax
	mov [pMem],eax
	invoke DbgFormatLine,eax,[dwLine],[pArgName]
	invoke CatString,eax,[pString]
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]
	invoke GlobalFree,[pString]
	RET
ENDF

DbgPrintSpacer FRAME
	LOCAL pMem		:D

	pushad
	pushfd
	cld
	invoke GlobalAlloc,040h,64
	mov [pMem],eax
	mov edi,eax
	mov ecx,10
	mov eax,"----"
	rep stosd
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]
	popfd
	popad
	RET
ENDF

DbgEndMeasure FRAME StartPos,EndPos,StartLine,EndLine
	LOCAL dwBytes	:D
	LOCAL pMem		:D

	mov eax,[EndPos]
	sub eax,[StartPos]
	mov [dwBytes],eax
	invoke GlobalAlloc,040h,80
	mov [pMem],eax
	invoke wsprintfA,[pMem],OFFSET DbgMeasureFmt,[dwBytes],[StartLine],[EndLine]
	add esp,20
	invoke DbgDebugPrint,[pMem]
	invoke GlobalFree,[pMem]

	RET
ENDF
