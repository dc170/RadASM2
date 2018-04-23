;; ######################################################################
;;                            Support Macros
;; ######################################################################
;;  @ArgCount - Count of VARARG list
;;  @ArgI - item of VARARG list
;;  @ArgRev - Reverse items of a VARARG list
;;  echof - Echo formated assemble-time variables
;;  @SaveRegs / @RestoreRegs - Simplified push/pop of registers
;;  CTEXT - Inline constant null string address
;;
;; ######################################################################
;; Revisions:
;;    2001.09.05 - Initial compilation
;;    2001.09.21 - @ArgRev updated for consistancy: VARARG doesn't have <>
;;    2001.10.29 - Nestable @Save/RestoreRegs
;;    2001.10.29 - MASM version @Save/RestoreRegs removed: obsolete


@ArgCount MACRO args:VARARG
;; Macro function returns the number of arguments in a VARARG list.
;; Params:  args - arguments to be counted
	LOCAL arg,y
	y = 0
	FOR arg,<&args>
		y = y + 1
	ENDM
	EXITM %y
ENDM



@ArgI MACRO index:REQ, args:VARARG
;; Macro function returns an argument specified by number from a VARARG list.
;; Params: index - one-based number of the argument to be returned
;;          args - argument list
	LOCAL arg,y,yStr
	y = 0
	FOR arg,<&args>
		y = y + 1
		IF y EQ index
			yStr TEXTEQU <arg>
			EXITM ;; Exit FOR loop
		ENDIF
	ENDM
	EXITM yStr
ENDM



@ArgRev MACRO args:VARARG
;; @ArgRev - Macro function returns a reversed order version of a VARARG list.
;; Params:  arglist - arguments to be reversed
	LOCAL arg,y
	y TEXTEQU <>
	FOR arg,<&args>
		y CATSTR <arg>,<!,>,y
	ENDM
	y SUBSTR y,1,@SizeStr(%y) - 1
;; MASM doesn't need <> on VARARG, and it will remove them.  I have removed
;; them for consistancy - this eliminates many errors in macro coding.
;; Assume VARARG is CSV list for greater control.
;;	y CATSTR <!<>,y,<!>> ;; Uncomment this line to add <>
	EXITM y
ENDM



echof   MACRO   format:REQ, args:VARARG
;; echof - Macro to display assembly-time value of expressions. The
;; syntax is similar to the C printf function. Useful for debugging
;; macros. For example, the following line displays the SIZE of an
;; array:   echof  <The value of $ is $>, (SIZE array), %(SIZE array)
;;
;; Params:  format - Text to be displayed with a $ placeholder for
;;                   each expression to be evaluated and inserted.
;;          args -   List of expressions to be evaluated. Text of
;;                   each value will be inserted into the format.
	LOCAL   string, pos, lastpos
	;; Initialize variables
	pos = 1
	string TEXTEQU <>
	;; Loop through, finding $ and building output string
	FOR val, args
		;; If beyond end of format string, exit FOR loop
		IF pos GE @SizeStr( format )
			pos = 0
			EXITM
		ENDIF
		;; Save last position and find the next $
		lastpos = pos
		pos     = @InStr( pos, format, <$> )
		;; If $ not found, exit FOR loop
		IF pos EQ 0
			EXITM
		ENDIF
		;; Append text up the next $
		string  CATSTR string, @SubStr( format, lastpos, pos - lastpos )
		;; Append matching value and skip past $
		string  CATSTR string, <val>
		pos     = pos + 1
	ENDM
	IF pos
		;; Attach any trailing characters
		IF pos LE @SizeStr( format )
			string CATSTR string, @SubStr( format, pos )
		ENDIF
		;; Display the finished string
%		ECHO string
	ELSE
		ECHO echof error: $ count does not match argument count
	ENDIF
ENDM



@SaveRegs MACRO regs:VARARG
;; @SaveRegs and @RestoreRegs - Macros to save and restore a list
;; of macros. @SaveRegs pushes each register in the argument list.
;; and saves each register name in a text macro. @RestoreRegs uses
;; the saved register list to pop each register.
;;
;; Params:  For @SaveRegs, the registers to be pushed
;;          For @RestoreRegs, none
	LOCAL myEnd, num, flag, reg

	num=0
	flag=0
	WHILE flag EQ 0
%		IFDEF @CatStr(<RealEnd>,<%num>)
			num = num + 1
		ELSE
			flag = 1
		ENDIF
	ENDM

%	FOR reg, <regs>
		push reg ;; Push each register
	ENDM

	@RestoreRegs MACRO
		@CatStr(<RealEnd>,<%num>) %num
	ENDM

	@CatStr(<RealEnd>,<%num>) MACRO depth:REQ
		LOCAL reg
		IF (OPATTR (myEnd)) AND 0100000y
			@CatStr(<RealEnd>,%(depth-1)) %(depth-1)
		ELSE
			myEnd LABEL BYTE ;; dummy
%			FOR reg, < @ArgRev( &regs ) >
				pop reg
			ENDM
		ENDIF
	ENDM
ENDM



CTEXT MACRO y:VARARG
;; Inline creation of a null terminating string in the CONST segment
;; Returns the address of the string
	LOCAL sym
	CONST segment dword PRIVATE 'DATA'
		IFIDNI <y>,<>
			sym db 0
		ELSE
			sym db y,0
		ENDIF
	CONST ends
	EXITM <OFFSET sym>
ENDM



return MACRO arg
	mov eax, arg
	ret
ENDM
