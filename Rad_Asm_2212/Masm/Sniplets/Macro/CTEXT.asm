	CTEXT MACRO y:VARARG
		LOCAL sym

	CONST segment dword private 'DATA'
		IFIDNI <y>,<>
			sym db 0
		ELSE
			sym db y,0
		ENDIF
	CONST ends

		EXITM <OFFSET sym>
	ENDM

