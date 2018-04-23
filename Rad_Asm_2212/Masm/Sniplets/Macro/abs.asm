;@ABS eax 
;@ABS MyFunkyValue 
;@ABS BYTE PTR [ecx*3 + 17]

	@ABS macro val:REQ
		local negsign
	  negsign:
		neg val
		js negsign
	ENDM



