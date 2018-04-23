
.code

debug_except_handler:
PUSH EBP
MOV EBP,ESP
PUSH EBX,EDI,ESI

;;** [EBP+8]=pointer to EXCEPTION_RECORD 
;;** [EBP+0Ch]=pointer to ERR structure 
;;** [EBP+10h]=pointer to CONTEXT record 

mov edx,D[EBP+10h]
cmp D[___fTrap], 0000004h ;EXCEPTION_SINGLE_STEP
jne >L1
	pushfd
	or D[esp], 100h
	pop [edx+0C0h] ;set TF ;pop [edx+CONTEXT.regFlag] ;set TF
	mov eax, [___pVar]
	invoke wsprintfA, OFFSET szDbgSpyBuffer, OFFSET szDbgDecFormat, [eax]
	add esp,12
	invoke DbgDebugPrint, OFFSET szDbgSpyLabel
	jmp >L2
L1:
cmp D[___fTrap], 1
jne >L2
	pushfd
	or D[esp], 100h
	pop [edx+0C0h] ;set TF
	mov eax,OFFSET ___fTrap
	mov D[eax], 0000004h ;EXCEPTION_SINGLE_STEP
L2:

xor eax, eax ; 0 = ExceptionContinueExecution
POP ESI,EDI,EBX
MOV ESP,EBP
POP EBP
RET




