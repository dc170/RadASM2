'
' RAEdit control definitions
'
' Private edit messages
#define REM_BASE								WM_USER+1000
#define REM_SETHILITEWORDS					REM_BASE+0		' wParam=Color, lParam=lpszWords
#define REM_SETFONT							REM_BASE+1		' wParam=nLineSpacing, lParam=lpRAFONT
#define REM_GETFONT							REM_BASE+2		' wParam=0, lParam=lpRAFONT
#define REM_SETCOLOR							REM_BASE+3		' wParam=0, lParam=lpRACOLOR
#define REM_GETCOLOR							REM_BASE+4		' wParam=0, lParam=lpRACOLOR
#define REM_SETHILITELINE					REM_BASE+5		' wParam=Line, lParam=Color
#define REM_GETHILITELINE					REM_BASE+6		' wParam=Line, lParam=0
#define REM_SETBOOKMARK						REM_BASE+7		' wParam=Line, lParam=Type
#define REM_GETBOOKMARK						REM_BASE+8		' wParam=Line, lParam=0
#define REM_CLRBOOKMARKS					REM_BASE+9		' wParam=0, lParam=Type
#define REM_NXTBOOKMARK						REM_BASE+10		' wParam=Line, lParam=Type
#define REM_PRVBOOKMARK						REM_BASE+11		' wParam=Line, lParam=Type
#define REM_FINDBOOKMARK					REM_BASE+12		' wParam=BmID, lParam=0
#define REM_SETBLOCKS						REM_BASE+13		' wParam=[lpLINERANGE], lParam=0
#define REM_ISLINE							REM_BASE+14		' wParam=Line, lParam=lpszDef
#define REM_GETWORD							REM_BASE+15		' wParam=BuffSize, lParam=lpBuff
#define REM_COLLAPSE							REM_BASE+16		' wParam=Line, lParam=0
#define REM_COLLAPSEALL						REM_BASE+17		' wParam=0, lParam=0
#define REM_EXPAND							REM_BASE+18		' wParam=Line, lParam=0
#define REM_EXPANDALL						REM_BASE+19		' wParam=0, lParam=0
#define REM_LOCKLINE							REM_BASE+20		' wParam=Line, lParam=TRUE/FALSE
#define REM_ISLINELOCKED					REM_BASE+21		' wParam=Line, lParam=0
#define REM_HIDELINE							REM_BASE+22		' wParam=Line, lParam=TRUE/FALSE
#define REM_ISLINEHIDDEN					REM_BASE+23		' wParam=Line, lParam=0
#define REM_AUTOINDENT						REM_BASE+24		' wParam=0, lParam=TRUE/FALSE
#define REM_TABWIDTH							REM_BASE+25		' wParam=nChars, lParam=TRUE/FALSE (Expand tabs)
#define REM_SELBARWIDTH						REM_BASE+26		' wParam=nWidth, lParam=0
#define REM_LINENUMBERWIDTH				REM_BASE+27		' wParam=nWidth, lParam=0
#define REM_MOUSEWHEEL						REM_BASE+28		' wParam=nLines, lParam=0
#define REM_SUBCLASS							REM_BASE+29		' wParam=0, lParam=lpWndProc
#define REM_SETSPLIT							REM_BASE+30		' wParam=nSplit, lParam=0
#define REM_GETSPLIT							REM_BASE+31		' wParam=0, lParam=0
#define REM_VCENTER							REM_BASE+32		' wParam=0, lParam=0
#define REM_REPAINT							REM_BASE+33		' wParam=0, lParam=TRUE/FALSE (Paint Now)
#define REM_BMCALLBACK						REM_BASE+34		' wParam=0, lParam=lpBmProc
#define REM_READONLY							REM_BASE+35		' wParam=0, lParam=TRUE/FALSE
#define REM_INVALIDATELINE					REM_BASE+36		' wParam=Line, lParam=0
#define REM_SETPAGESIZE						REM_BASE+37		' wParam=nLines, lParam=0
#define REM_GETPAGESIZE						REM_BASE+38		' wParam=0, lParam=0
#define REM_GETCHARTAB						REM_BASE+39		' wParam=nChar, lParam=0
#define REM_SETCHARTAB						REM_BASE+40		' wParam=nChar, lParam=nValue
#define REM_SETCOMMENTBLOCKS				REM_BASE+41		' wParam=lpStart, lParam=lpEnd
#define REM_SETWORDGROUP					REM_BASE+42		' wParam=0, lParam=nGroup (0-15)
#define REM_GETWORDGROUP					REM_BASE+43		' wParam=0, lParam=0
#define REM_SETBMID							REM_BASE+44		' wParam=nLine, lParam=nBmID
#define REM_GETBMID							REM_BASE+45		' wParam=nLine, lParam=0
#define REM_ISCHARPOS						REM_BASE+46		' wParam=CP, lParam=0, returns 1 if comment block, 2 if comment, 3 if string
#define REM_HIDELINES						REM_BASE+47		' wParam=nLine, lParam=nLines
#define REM_SETDIVIDERLINE					REM_BASE+48		' wParam=nLine, lParam=TRUE/FALSE
#define REM_ISINBLOCK						REM_BASE+49		' wParam=nLine, lParam=lpRABLOCKDEF
#define REM_TRIMSPACE						REM_BASE+50		' wParam=nLine, lParam=fLeft
#define REM_SAVESEL							REM_BASE+51		' wParam=0, lParam=0
#define REM_RESTORESEL						REM_BASE+52		' wParam=0, lParam=0
#define REM_GETCURSORWORD					REM_BASE+53		' wParam=BuffSize, lParam=lpBuff
#define REM_SETSEGMENTBLOCK				REM_BASE+54		' wParam=nLine, lParam=TRUE/FALSE
#define REM_GETMODE							REM_BASE+55		' wParam=0, lParam=0
#define REM_SETMODE							REM_BASE+56		' wParam=nMode, lParam=0
#define REM_GETBLOCK							REM_BASE+57		' wParam=0, lParam=lpBLOCKRANGE
#define REM_SETBLOCK							REM_BASE+58		' wParam=0, lParam=lpBLOCKRANGE
#define REM_BLOCKINSERT						REM_BASE+59		' wParam=0, lParam=lpText
#define REM_LOCKUNDOID						REM_BASE+60		' wParam=TRUE/FALSE, lParam=0
#define REM_ADDBLOCKDEF						REM_BASE+61		' wParam=0, lParam=lpRABLOCKDEF

' Modes
#define MODE_NORMAL							0					' Normal
#define MODE_BLOCK							1					' Block select

' Line hiliting
#define STATE_HILITEOFF						0
#define STATE_HILITE1						1
#define STATE_HILITE2						2
#define STATE_HILITE3						3
#define STATE_HILITEMASK					3

' Bookmarks
#define STATE_BMOFF							&H00
#define STATE_BM1								&H10
#define STATE_BM2								&H20
#define STATE_BM3								&H30
#define STATE_BM4								&H40
#define STATE_BM5								&H50
#define STATE_BM6								&H60
#define STATE_BM7								&H70
#define STATE_BM8								&H80
#define STATE_BMMASK							&HF0

' Line states
#define STATE_LOCKED							&H0100
#define STATE_HIDDEN							&H0200
#define STATE_COMMENT						&H0400
#define STATE_DIVIDERLINE					&H0800
#define STATE_SEGMENTBLOCK					&H1000
#define STATE_GARBAGE						&H80000000

' Character table types
#define CT_NONE								0
#define CT_CHAR								1
#define CT_OPER								2
#define CT_HICHAR								3
#define CT_CMNTCHAR							4
#define CT_STRING								5
#define CT_CMNTDBLCHAR						6
#define CT_CMNTINITCHAR						7

type RAFONT field=1
	hFont			as long											' Code edit normal
	hIFont		as long											' Code edit italics
	hLnrFont		as long											' Line numbers
end type

type RACOLOR field=1
	bckcol		as long											' Back color
	txtcol		as long											' Text color
	selbckcol	as long											' Sel back color
	seltxtcol	as long											' Sel text color
	cmntcol		as long											' Comment color
	strcol		as long											' String color
	oprcol		as long											' Operator color
	hicol1		as long											' Line hilite 1
	hicol2		as long											' Line hilite 2
	hicol3		as long											' Line hilite 3
	selbarbck	as long											' Selection bar
	selbarpen	as long											' Selection bar pen
	lnrcol		as long											' Line numbers color
	numcol		as long											' Numbers & hex color
end type

type RASELCHANGE field=1
	nmhdr			as NMHDR
	chrg			as CHARRANGE									' Current selection
	seltyp		as word											' SEL_TEXT or SEL_OBJECT
	line			as long											' Line number
	cpLine		as long											' Character position of first character
	lpLine		as long											' Pointer to line
	nlines		as long											' Total number of lines
	nhidden		as long											' Total number of hidden lines
	fchanged		as long											' TRUE if changed since last
	npage			as long											' Page number
	nWordGroup	as long											' Hilite word group(0-15)
end type

#define BD_NONESTING							&H01				' Set to true for non nested blocks
#define BD_DIVIDERLINE						&H02				' Draws a divider line
#define BD_INCLUDELAST						&H04				' lpszEnd line is also collapsed
#define BD_LOOKAHEAD							&H08				' Look 500 lines ahead for the ending
#define BD_SEGMENTBLOCK						&H10				' Segment block, collapse till next segmentblock

type RABLOCKDEF field=1
	lpszStart	as long											' Block start
	lpszEnd		as long											' Block end
	lpszNot1		as long											' Dont hide line containing this or set to NULL
	lpszNot2		as long											' Dont hide line containing this or set to NULL
	flag			as long											' High word is WordGroup(0-15)
end type

type LINERANGE field=1
	lnMin		as long												' Starting line
	lnMax		as long												' Ending line
end type

type BLOCKRANGE field=1
	lnMin		as long												' Starting line
	clMin		as long												' Starting column
	lnMax		as long												' Ending line
	clMax		as long												' Ending column
end type

