.code
DbgMMXDump FRAME dwLine
	LOCAL pMem		:D
	LOCAL tempq		:Q

	mov D[tempq],0
	mov D[tempq+4],0

	invoke GlobalAlloc,040h,256
	mov [pMem],eax

	invoke DbgFormatLine,[pMem],[dwLine],OFFSET DbgszMMXDump
	invoke DbgDebugPrint,[pMem]

	mov eax,[pMem]
	mov D[eax],A"MM0 "
	mov D[eax+4],A"= "

	movq [tempq],mm0
	mov eax,[pMem]
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm1
	mov eax,[pMem]
	mov B[eax+2],"1"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm2
	mov eax,[pMem]
	mov B[eax+2],"2"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm3
	mov eax,[pMem]
	mov B[eax+2],"3"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm4
	mov eax,[pMem]
	mov B[eax+2],"4"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm5
	mov eax,[pMem]
	mov B[eax+2],"5"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm6
	mov eax,[pMem]
	mov B[eax+2],"6"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	movq [tempq],mm7
	mov eax,[pMem]
	mov B[eax+2],"7"
	add eax,6
	invoke dbgqwordtohex,offset tempq,eax
	invoke DbgDebugPrint,[pMem]
	
	invoke GlobalFree,[pMem]
	emms
	
	RET
ENDF