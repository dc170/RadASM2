	szText MACRO Name, Text:VARARG
		LOCAL lbl
		jmp lbl
			Name db Text,0
		lbl:
	ENDM

