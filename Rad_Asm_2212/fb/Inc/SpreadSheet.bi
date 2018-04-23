'Messages
CONST SPRM_SPLITTHOR			= WM_USER+100		'Create horizontal splitt in current splitt at current row. wParam=0, lParam=0
CONST SPRM_SPLITTVER			= WM_USER+101		'Create vertical splitt in current splitt at current col. wParam=0, lParam=0
CONST SPRM_SPLITTCLOSE			= WM_USER+102		'Close the current splitt. wParam=0, lParam=0
CONST SPRM_SPLITTSYNC			= WM_USER+103		'Syncronizez a splitt window witit's parent. wParam=0, lParam=TRUE/FALSE
CONST SPRM_GETSPLITTSTATE		= WM_USER+104		'*Get splitt state. wParam=nWin(0-7), if nWin=-1 active split window, lParam=0
CONST SPRM_GETCELLRECT			= WM_USER+105		'Get the current cells rect in active splitt. wParam=0, lParam=pointer to RECT struct. Returns handle of active splitt window.
CONST SPRM_GETLOCKCOL			= WM_USER+106		'Get lock cols in active splitt. wParam=0, lParam=0
CONST SPRM_SETLOCKCOL			= WM_USER+107		'Lock cols in active splitt. wParam=0, lParam=cols
CONST SPRM_GETLOCKROW			= WM_USER+108		'Get lock rows in active splitt. wParam=0, lParam=0
CONST SPRM_SETLOCKROW			= WM_USER+109		'Lock rows in active splitt. wParam=0, lParam=rows
CONST SPRM_DELETECOL			= WM_USER+110		'Delete col. wParam=col, lParam=0
CONST SPRM_INSERTCOL			= WM_USER+111		'Insert col. wParam=col, lParam=0
CONST SPRM_DELETEROW			= WM_USER+112		'Delete row. wParam=row, lParam=0
CONST SPRM_INSERTROW			= WM_USER+113		'Insert row. wParam=row, lParam=0
CONST SPRM_GETCOLCOUNT			= WM_USER+114		'Get number of columns. wParam=0, lParam=0
CONST SPRM_SETCOLCOUNT			= WM_USER+115		'Set number of columns. wParam=nCols, lParam=0
CONST SPRM_GETROWCOUNT			= WM_USER+116		'Get number of rows. wParam=0, lParam=0
CONST SPRM_SETROWCOUNT			= WM_USER+117		'Set number of rows. wParam=nRows, lParam=0
CONST SPRM_RECALC				= WM_USER+118		'Recalculates the sheet
CONST SPRM_BLANKCELL			= WM_USER+119		'Blank a cell. wParam=col, lParam=row
CONST SPRM_GETCURRENTWIN		= WM_USER+120		'Get active splitt window. wParam=0, lParam=0
CONST SPRM_SETCURRENTWIN		= WM_USER+121		'Set active splitt window. wParam=0, lParam=nWin (0-7)
CONST SPRM_GETCURRENTCELL		= WM_USER+122		'Get current col/row in active window. wParam=0, lParam=0. Returns Hiword=row, Loword=col
CONST SPRM_SETCURRENTCELL		= WM_USER+123		'Set current col/row in active window. wParam=col, lParam=row
CONST SPRM_GETCELLSTRING		= WM_USER+124		'*Get content of current cell. wParam=0, lParam=0. Returns a pointer to a null terminated string.
CONST SPRM_SETCELLSTRING		= WM_USER+125		'Set content of current cell. wParam=type, lParam=pointer to string.
CONST SPRM_GETCOLWIDT		  	= WM_USER+126		'Get column width. wParam=col, lParam=0. Returns column width.
CONST SPRM_SETCOLWIDT		  	= WM_USER+127		'Set column width. wParam=col, lParam=width.
CONST SPRM_GETROWHEIGHT		  	= WM_USER+128		'Get row height. wParam=row, lParam=0. Returns row height.
CONST SPRM_SETROWHEIGHT		  	= WM_USER+129		'Set row height. wParam=row, lParam=height.
CONST SPRM_GETCELLDATA			= WM_USER+130		'Get cell data. wParam=0, lParam=Pointer to SPR_ITEM struct
CONST SPRM_SETCELLDATA			= WM_USER+131		'Set cell data. wParam=0, lParam=Pointer to SPR_ITEM struct
CONST SPRM_GETMULTISEL			= WM_USER+132		'Get multiselection. wParam=0, lParam=pointer to a RECT struct. Returns handle of active split window
CONST SPRM_SETMULTISEL			= WM_USER+133		'Set multiselection. wParam=0, lParam=pointer to a RECT struct. Returns handle of active split window
CONST SPRM_GETFONT				= WM_USER+134		'Get font. wParam=index(0-15), lParam=pointer to FONT struct. Returns font handle
CONST SPRM_SETFONT				= WM_USER+135		'Set font. wParam=index(0-15), lParam=pointer to FONT struct. Returns font handle
CONST SPRM_GETGLOBAL			= WM_USER+136		'Get global. wParam=0, lParam=pointer to GLOBAL struct.
CONST SPRM_SETGLOBAL			= WM_USER+137		'Set global. wParam=0, lParam=pointer to GLOBAL struct.
CONST SPRM_IMPORTLINE			= WM_USER+138		'Import a line of data. wParam=SepChar, lParam=pointer to data line.
CONST SPRM_LOADFILE				= WM_USER+139		'Load a file. wParam=0, lParam=pointer to filename
CONST SPRM_SAVEFILE				= WM_USER+140		'Save a file. wParam=0, lParam=pointer to filename
CONST SPRM_NEWSHEET			  	= WM_USER+141		'Clears the sheet. wParam=0, lParam=0
CONST SPRM_EXPANDCELL			= WM_USER+142		'Expand a cell to cover more than one cell. wParam=0, lParam=pointer to RECT struct
CONST SPRM_GETCELLTYPE			= WM_USER+143		'Get cell data type. wParam=col, lParam=row. Returns cell type.
CONST SPRM_ADJUSTCELLREF		= WM_USER+144		'Adjust cell refs in formula. wParam=pointer to cell, lParam=pointer to RECT.
CONST SPRM_CREATECOMBO			= WM_USER+145		'Creates a ComboBox. wPatam=0, lParam=0
CONST SPRM_SCROLLCELL			= WM_USER+146		'Scrolls current cell into view

'Styles
CONST SPS_VSCROLL			  = &h0001			'Vertical scrollbar
CONST SPS_HSCROLL			  = &h0002			'Horizontal scrollbar
CONST SPS_STATUS			  = &h0004			'Show status window
CONST SPS_GRIDLINES			  = &h0008			'Show grid lines
CONST SPS_ROWSELECT			  = &h0010			'Selection by row
CONST SPS_CELLEDIT			  = &h0020			'Cell editing
CONST SPS_GRIDMODE			  = &h0040			'Inserting and deleting row/col adjusts max row/col
CONST SPS_COLSIZE			  = &h0080			'Allow col widt sizeing by mouse
CONST SPS_ROWSIZE		      = &h0100			'Allow row height sizeing by mouse
CONST SPS_WINSIZE			  = &h0200			'Allow splitt window sizeing by mouse
CONST SPS_MULTISELECT		  = &h0400			'Allow multiselect

'Cell data types
CONST TPE_EMPTY					= &h000			'The cell contains formatting only
CONST TPE_COLHDR				= &h001			'Column header
CONST TPE_ROWHDR				= &h002			'Row header
CONST TPE_WINHDR				= &h003			'Window (splitt) header
CONST TPE_TEXT					= &h004			'Text cell
CONST TPE_TEXTMULTILINE			= &h005			'Text cell, text is multiline
CONST TPE_INTEGER				= &h006			'Double word integer
CONST TPE_FLOAT					= &h007			'80 bit float
CONST TPE_FORMULA				= &h008			'Formula
CONST TPE_GRAP					= &h009			'Graph
CONST TPE_HYPERLINK				= &h00A			'Hyperlink
CONST TPE_CHECKBOX				= &h00B			'Checkbox
CONST TPE_COMBOBOX				= &h00C			'Combobox

CONST TPE_EXPANDED				= &h00F			'Part of expanded cell, internally used

CONST TPE_BUTTON				= &h010			'Small button
CONST TPE_WIDEBUTTON			= &h020			'Button, covers the cell
CONST TPE_FORCETEXT				= &h044			'Forced text type

'Format Alignment & Decimals
CONST FMTA_AUTO					= &h000			'Text left middle, numbers right middle
CONST FMTA_LEFT					= &h010
CONST FMTA_CENTER				= &h020
CONST FMTA_RIGHT				= &h030
CONST FMTA_TOP					= &h000
CONST FMTA_MIDDLE				= &h040
CONST FMTA_BOTTOM				= &h080
CONST FMTA_GLOBAL				= &h0F0
CONST FMTA_MASK					= &h0F0			'Alignment mask
CONST FMTA_XMASK				= &h030			'Alignment x-mask
CONST FMTA_YMASK				= &h0C0			'Alignment y-mask

CONST FMTD_0					= &h00
CONST FMTD_1					= &h01
CONST FMTD_2					= &h02
CONST FMTD_3					= &h03
CONST FMTD_4					= &h04
CONST FMTD_5					= &h05
CONST FMTD_6					= &h06
CONST FMTD_7					= &h07
CONST FMTD_8					= &h08
CONST FMTD_9					= &h09
CONST FMTD_10					= &h0A
CONST FMTD_11					= &h0B
CONST FMTD_12					= &h0C
CONST FMTD_ALL					= &h0D
CONST FMTD_SCI					= &h0E
CONST FMTD_GLOBAL				= &h0F
CONST FMTD_MASK					= &h0F

TYPE FORMAT
	bckcol			AS INTEGER						'Back color
	txtcol			AS INTEGER						'Text color
	txtal			AS BYTE						'Text alignment and decimals
	imgal			AS BYTE						'Image alignment and imagelist/control index
	fnt				AS BYTE						'Font index (0-15)
	tpe		AS BYTE						'Cell type
END TYPE

TYPE GLOBAL
	colhdrbtn		AS INTEGER
	rowhdrbtn		AS INTEGER
	winhdrbtn		AS INTEGER
	lockcol			AS INTEGER						'Back color of locked cell
	hdrgrdcol		AS INTEGER						'Header grid color
	grdcol			AS INTEGER						'Cell grid color
	bcknfcol		AS INTEGER						'Back color of active cell, lost focus
	txtnfcol		AS INTEGER						'Text color of active cell, lost focus
	bckfocol		AS INTEGER						'Back color of active cell, has focus
	txtfocol		AS INTEGER						'Text color of active cell, has focus
	ncols			AS INTEGER
	nrows			AS INTEGER
	ghdrwt			AS INTEGER
	ghdrht			AS INTEGER
	gcellwt			AS INTEGER
	gcellht			AS INTEGER
	colhdr			AS FORMAT					'Column header formatting
	rowhdr			AS FORMAT 					'Row header formatting
	winhdr			AS FORMAT					'Window header formatting
	cell			AS FORMAT					'Cell formatting
END TYPE

TYPE FONT
	hfont			AS INTEGER						'Font handle
	face			AS PTSTR					'Face name
	fsize			AS INTEGER					'Point size
	ht				AS INTEGER					'Height
	bold			AS BYTE						'Bold
	italic			AS BYTE						'Italics
	underline		AS BYTE						'Underline
	strikeout		AS BYTE						'Strikeout
END TYPE

CONST STATE_LOCKED				= &h001				'Cell is locked for editing
CONST STATE_HIDDEN				= &h002				'Cell content is not displayed
CONST STATE_REDRAW				= &h008
CONST STATE_ERROR				= &h010
CONST STATE_DIV0				= &h020
CONST STATE_UNDERFLOW			= &h030
CONST STATE_OVERFLOW			= &h040
CONST STATE_RECALC				= &h080
CONST STATE_ERRMASK				= &h0F0

CONST SPRIF_BACKCOLOR			= &h00000001		'Back color is valid
CONST SPRIF_TEXTCOLOR			= &h00000002		'Text color is valid
CONST SPRIF_TEXTALIGN			= &h00000004
CONST SPRIF_IMAGEALIGN			= &h00000008
CONST SPRIF_FONT				= &h00000010
CONST SPRIF_STATE			= &h00000020
CONST SPRIF_TYPE				= &h00000040
CONST SPRIF_WIDTH				= &h00000080
CONST SPRIF_HEIGHT				= &h00000100
CONST SPRIF_DATA				= &h00000200
CONST SPRIF_COMPILE				= &h80000000		'Compile the formula

TYPE SPR_ITEM
	flag			AS INTEGER
	col				AS INTEGER
	row				AS INTEGER
	expx			AS BYTE						'Expanded columns
	expy			AS BYTE						'Expanded rows
	state			AS BYTE
	fmt				AS FORMAT
	wt				AS INTEGER
	ht				AS INTEGER
	lpdta			AS INTEGER
END TYPE

'Notification messages (WM_NOTIFY)
CONST SPRN_SELCHANGE			= 1				'Splitt, col or row changed.
CONST SPRN_BEFOREEDIT			= 2				'Before the editbox is shown
CONST SPRN_AFTEREDIT			= 3				'After the editbox is closed
CONST SPRN_BEFOREUPDATE			= 4				'Before cell is updated
CONST SPRN_AFTERUPDATE			= 5				'After cell is updated
CONST SPRN_HYPERLINKENTER		= 6				'Hyperlink entered
CONST SPRN_HYPERLINKLEAVE		= 7				'Hyperlink leaved
CONST SPRN_HYPERLINKCLICK		= 8				'Hyperlink clicked
CONST SPRN_BUTTONCLICK			= 9				'Button clicked

'on structs
TYPE SPR_SELCHANGE
	hdr				AS NMHDR
	nwin			AS INTEGER
	col				AS INTEGER
	row				AS INTEGER
	fcancel			AS INTEGER
END TYPE

TYPE SPR_EDIT
	hdr				AS NMHDR
	lpspri			AS INTEGER
	fcancel			AS INTEGER
END TYPE

TYPE SPR_HYPERLINK
	hdr				AS NMHDR
	lpspri			AS INTEGER
END TYPE

TYPE SPR_BUTTON
	hdr				AS NMHDR
	lpspri			AS INTEGER
END TYPE
