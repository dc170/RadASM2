DEFLNG A-Z

REM $INCLUDE: 'Helper.Dec'

' return only mouse info
' GetMouseFlag& (FlagPtr AS LONG)
' GetMouse& ()

' return only keyboard info
' GetKeyFlag& (FlagPtr AS LONG)
' GetKey& ()

' return everything
' GetInput& ()
' GetInputFlag& (FlagPtr AS LONG)


DIM K, F, x, y

	COLOR 11: CLS
	PRINT "GETIN - press control-c to end program"
	PRINT
	
lh:
	K = GetInputFlag(F)
	
	PRINT "K: " + RIGHT$("0000000" + HEX$(K), 8) + "  ";
	PRINT "F: " + RIGHT$("0000000" + HEX$(F), 8) + "  ";

	SELECT CASE K \ &H1000000 ' can't mask here - have to divide

	CASE 0:  ' keyboard - only key down events are returned
				' H/O byte of Flags contains Windows vk code
				' H/O byte of Flags contains Shift states

		IF K >= 32 AND K <= 126 THEN
			PRINT "Key:  '" + CHR$(K) + "'"
		ELSE
			PRINT "Key: "; K
		END IF

	CASE 1: PRINT "Mouse Click"

	CASE 2: PRINT "Mouse Double Click"

	CASE 3: ' mouse movement
		y = K AND &HFFF
		x = (K AND &HFFF000) \ 4096
		PRINT "Mouse Move   Row:"; x; "  Col:"; y

	CASE ELSE: PRINT "This Should never happen!"
	END SELECT
	GOTO lh

