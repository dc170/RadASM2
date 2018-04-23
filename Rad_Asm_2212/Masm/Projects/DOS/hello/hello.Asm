;-----------------------------------------------------------------------
;	This EXE program displays "Hello!" to screen.
;-----------------------------------------------------------------------
	assume	cs:cseg,ds:dseg,ss:sseg

cseg	segment
start:
	mov	ax, dseg
	mov	ds, ax
	mov	dx, offset msg
	mov	ah, 09h
	int	21h
	mov	ax, 4C00h
	int	21h
cseg	ends

dseg	segment	byte
msg	db	'Hello!',0Dh,0Ah,'$'
dseg	ends

sseg	segment	stack
	db	100h dup(?)
sseg	ends

	end	start
