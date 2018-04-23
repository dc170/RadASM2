
.code

DbgEFlagDump FRAME dwLine,eflagdata
	LOCAL pdbbuf	:D

	pushad
	invoke GlobalAlloc,040h,128
	mov [pdbbuf],eax

	invoke DbgFormatLine,[pdbbuf],[dwLine],OFFSET szDbgEFlagLabel
	mov edi,eax

	mov B[edi],0
	mov eax,[eflagdata]
	bt eax,0
	jnc >
	mov D[edi]," CF"
	add edi,3
	:
	bt eax,2
	jnc >
	mov D[edi]," PF"
	add edi,3
	:
	bt eax,4
	jnc >
	mov D[edi]," AF"
	add edi,3
	:
	bt eax,6
	jnc >
	mov D[edi]," ZF"
	add edi,3
	:
	bt eax,7
	jnc >
	mov D[edi]," SF"
	add edi,3
	:
	bt eax,8
	jnc >
	mov D[edi]," TF"
	add edi,3
	:
	bt eax,9
	jnc >
	mov D[edi]," IF"
	add edi,3
	:
	bt eax,10
	jnc >
	mov D[edi]," DF"
	add edi,3
	:
	bt eax,11
	jnc >
	mov D[edi]," OF"
	add edi,3
	:
	mov B[edi],0

	invoke DbgDebugPrint,[pdbbuf]
	invoke GlobalFree,[pdbbuf]
	popad

	RET
ENDF