@SaveRegs MACRO regs:VARARG
	LOCAL myEnd, num, flag, reg

	num=0
	flag=0
	WHILE flag EQ 0
%		IFDEF @CatStr(<RealEnd>,<%num> )
			num = num + 1
		ELSE
			flag = 1
		ENDIF
	ENDM

%	FOR reg, <regs>
		push reg
	ENDM

