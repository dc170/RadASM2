;-----------------------------------------------------------------------
;	This EXE program displays "Hello!" to screen.
;	This source code is written using simplified segment directive.
;-----------------------------------------------------------------------
	.model	small
	dosseg

	.code
	.startup
	mov	dx, offset msg
	mov	ah, 09h
	int	21h
	.exit	0

	.data
msg	db	'Hello!',0Dh,0Ah,'$'

	.stack	256

	end
