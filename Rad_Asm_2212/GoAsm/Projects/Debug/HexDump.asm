
.code

DbgDumpDbg FRAME lpData,nLen,dwLine
	LOCAL pdbbuf 		:D
	LOCAL newbuf[80]	:B

	cmp D[nLen],0
	jz >>.DONE
		push [lpData]
		push [nLen]
		invoke GlobalAlloc,040h,80
		mov [pdbbuf],eax

		mov eax,[lpData]
		add eax,[nLen]
		dec eax
		invoke wsprintfA,OFFSET newbuf,OFFSET DbgDumpFmt,OFFSET DbgszDBGDump,[nLen],[lpData], eax
		add esp,24
		invoke DbgFormatLine,[pdbbuf],[dwLine],OFFSET newbuf
		invoke DbgDebugPrint,[pdbbuf]
		invoke ZeroMem,[pdbbuf],80

		mov edx,[pdbbuf]
		pop ebx
		pop esi
		jmp >>L2
		L1:
			push edx
			mov edi,edx
			invoke dbgdwordtohex,esi,edi
			pop edx
			mov W[edi+8], ": "
			mov B[edi+10], " "
			add edi,11
			push esi
			push ebx
			xor ecx,ecx
			jmp >L4
				L3:
				or ebx,ebx
				jnz >L5
					mov D[edi], "    "
					add edi, 3
					jmp >L6
				L5:
					dec ebx
					xor eax, eax
					mov al, [esi]
					inc esi
					ror ax, 4
					shr ah, 4
					add ax, 3030h
					cmp ah, 39h
					jbe >
					add ah, (41h-3Ah)
					:
					cmp al, 39h
					jbe >
					add al, (41h-3Ah)
					:
					mov W[edi], ax
					mov B[edi+2], " "
					add edi, 3
				L6:
				inc ecx
			L4:
			cmp ecx,16
			jl <L3
			pop ebx
			pop esi
			mov W[edi], "  "
			add edi, 2
			xor ecx, ecx
			jmp >L8
			L7:
				mov al,[esi]
				or ebx,ebx
				jnz >L9
					mov al, "."
					jmp >L10
				L9:
					dec ebx
					inc esi
					cmp al, 20h
					jae >
					mov al, "."
					:
				L10:
				mov [edi], al
				inc edi
				inc ecx
			L8:
			cmp ecx,16
			jl <L7
			mov B[edi],0
			mov edi,edx
			mov B[edi+22], "-"
			mov B[edi+34], "-"
			mov B[edi+46], "-"
			push edx
			invoke DbgDebugPrint,edi
			pop edx
		L2:
		or ebx,ebx
		jnz <<L1
		invoke  GlobalFree,edx
		invoke DbgPrintSpacer
	.DONE
	RET
ENDF
