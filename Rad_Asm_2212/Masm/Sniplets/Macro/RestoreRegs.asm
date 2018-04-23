	@RestoreRegs MACRO
		@CatStr(<RealEnd>,<%num> ) %num
	ENDM

	@CatStr(<RealEnd>,<%num> ) MACRO depth:REQ
		LOCAL reg
		IF (OPATTR (myEnd)) AND 0100000y
			@CatStr(<RealEnd>,%(depth-1)) %(depth-1)
		ELSE
			myEnd LABEL BYTE ;; dummy
%			FOR reg, < @ArgRev( ®s ) >
				pop reg
			ENDM
		ENDIF
	ENDM
ENDM
