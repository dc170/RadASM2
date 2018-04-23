
ResEdInstall		PROTO	:DWORD
ResEdUninstall		PROTO
GridInstall			PROTO	:DWORD

;Dialog memory size
MaxMem				equ 128*1024*3
MaxCap				equ 256
MaxName				equ 64

;Dialog structures
DLGHEAD struct
	changed			dd ?				;Set to FALSE
	class			db 32 dup(?)		;Set to Null string
	menuid			db MaxName dup(?)	;Set to Null string
	font			db 32 dup(?)		;Set to "MS Sans Serif"
	fontsize		dd ?				;Set to 8
	fontht			dd ?				;Set to -10
	lang			dd ?				;Set to NULL
	sublang			dd ?				;Set to NULL
	undo			dd ?				;Set to NULL
	ctlid			dd ?				;Set to 1001
	hmnu			dd ?				;Set to NULL
	lpmnu			dd ?				;Set to NULL
	htlb			dd ?				;Set to NULL
	hstb			dd ?				;Set to NULL
	locked			dd ?				;Set to TRUE or FALSE
	hfont			dd ?				;Set to NULL
	charset			db ?				;Set to NULL
	italic			db ?				;Set to NULL
	weight			dw ?				;Set to NULL
DLGHEAD ends

DIALOG struct
	hwnd			dd ?				;Set to TRUE
	hdmy			dd ?				;Handle of transparent window
	oldproc			dd ?				;Set to NULL
	hpar			dd ?				;Set to NULL
	hcld			dd ?				;Set to NULL
	style			dd ?				;Set to desired style
	exstyle			dd ?				;Set to desired ex style
	dux				dd ?				;X position in dialog units
	duy				dd ?				;Y position in dialog units
	duccx			dd ?				;Width in dialog units
	duccy			dd ?				;Height in dialog units
	x				dd ?				;X position in pixels
	y				dd ?				;Y position in pixels
	ccx				dd ?				;Width in pixels
	ccy				dd ?				;Height in pixels
	caption			db MaxCap dup(?)	;Caption max 255+1 char
	ntype			dd ?				;Follows ToolBox buttons Dialog=0, Edit=1, Static=2, GroupBox=3
	ntypeid			dd ?				;Set to NULL
	tab				dd ?				;Tab index, Dialog=0, First index=0
	id				dd ?				;Dialog / Controls ID
	idname			db MaxName dup(?)	;ID Name, max 63+1 chars
	helpid			dd ?				;Help ID
	undo			dd ?				;Set to NULL
	himg			dd ?				;Set to NULL
DIALOG ends

;Control types
TYPES struct
	ID				dd ?
	lpclass			dd ?
	partype			dd ?
	style			dd ?
	typemask		dd ?
	exstyle			dd ?
	lpidname		dd ?
	lpcaption		dd ?
	lprc			dd ?
	xsize			dd ?
	ysize			dd ?
	nmethod			dd ?
	methods			dd ?
	flist			dd 4 dup(?)
TYPES ends

;Menu structures
MNUHEAD struct
	changed			dd ?
	menuname		db MaxName dup(?)
	menuid			dd ?
	startid			dd ?
	menuex			dd ?
	lang			dd ?
	sublang			dd ?
MNUHEAD ends

MNUITEM struct
	itemflag		dd ?
	itemname		db MaxName dup(?)
	itemid			dd ?
	itemcaption		db 64 dup(?)
	level			dd ?
	ntype			dd ?
	nstate			dd ?
	shortcut		dd ?
	helpid			dd ?
MNUITEM ends

COLOR struct
	back			dd ?
	text			dd ?
COLOR ends

;Dialog editor messages
DEM_BASE			equ WM_USER+2000
DEM_OPEN			equ DEM_BASE+1		;wParam=0, lParam=Handle of memory or NULL
DEM_DELETECONTROLS	equ DEM_BASE+2		;wParam=0, lParam=0
DEM_CANUNDO			equ DEM_BASE+3		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_UNDO			equ DEM_BASE+4		;wParam=0, lParam=0
DEM_CUT				equ DEM_BASE+5		;wParam=0, lParam=0
DEM_COPY			equ DEM_BASE+6		;wParam=0, lParam=0
DEM_CANPASTE		equ DEM_BASE+7		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_PASTE			equ DEM_BASE+8		;wParam=0, lParam=0
DEM_ISLOCKED		equ DEM_BASE+9		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_LOCKCONTROLS	equ DEM_BASE+10		;wParam=0, lParam=TRUE or FALSE
DEM_ISBACK			equ DEM_BASE+11		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_SENDTOBACK		equ DEM_BASE+12		;wParam=0, lParam=0
DEM_ISFRONT			equ DEM_BASE+13		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_BRINGTOFRONT	equ DEM_BASE+14		;wParam=0, lParam=0
DEM_ISSELECTION		equ DEM_BASE+15		;wParam=0, lParam=0, Returns 0=Non selected, 1=Singleselect, 2=Multiselect
DEM_ALIGNSIZE		equ DEM_BASE+16		;wParam=0, lParam=ALIGN_XX or SIZE_XX
DEM_GETMODIFY		equ DEM_BASE+17		;wParam=0, lParam=0, Returns TRUE or FALSE
DEM_SETMODIFY		equ DEM_BASE+18		;wParam=TRUE or FALSE, lParam=0
DEM_COMPACT			equ DEM_BASE+19		;wParam=0, lParam=0, Returns memory size of compacted
DEM_EXPORTTORC		equ DEM_BASE+20		;wParam=0, lParam=0, Returns memory handle
DEM_SETPOSSTATUS	equ DEM_BASE+21		;wParam=Handle of status window, lParam=Pane
DEM_SETGRIDSIZE		equ DEM_BASE+22		;wParam=y-size,x-size, lParam=color
DEM_ADDCONTROL		equ DEM_BASE+23		;wParam=handle of toolbox, lParam=lpCCDEF
DEM_GETCOLOR		equ DEM_BASE+24		;wParam=0, lParam=lpCOLOR
DEM_SETCOLOR		equ DEM_BASE+25		;wParam=0, lParam=lpCOLOR
DEM_SHOWDIALOG		equ DEM_BASE+26		;wParam=0, lParam=0
DEM_SHOWTABINDEX	equ DEM_BASE+27		;wParam=0, lParam=0

;DEM_ALIGNSIZE lParam
ALIGN_LEFT			equ 1
ALIGN_CENTER		equ 2
ALIGN_RIGHT			equ 3
ALIGN_TOP			equ 4
ALIGN_MIDDLE		equ 5
ALIGN_BOTTOM		equ 6
SIZE_WIDTH			equ 7
SIZE_HEIGHT			equ 8
SIZE_BOTH			equ 9
ALIGN_DLGVCENTER	equ 10
ALIGN_DLGHCENTER	equ 11

;Menu editor messages
MEM_BASE			equ DEM_BASE+1000
MEM_OPEN			equ MEM_BASE+1		;wParam=0, lParam=Handle of memory or NULL

;Project messages
PRO_BASE			equ DEM_BASE+2000
PRO_OPEN			equ PRO_BASE+1		;wParam=Pointer to project name, lParam=Handle of memory or NULL
PRO_CLOSE			equ PRO_BASE+2		;wParam=0, lParam=0
PRO_EXPORT			equ PRO_BASE+3		;wParam=0, lParam=Handle of memory
PRO_GETMODIFY		equ PRO_BASE+4		;wParam=0, lParam=0
PRO_SETMODIFY		equ PRO_BASE+5		;wParam=TRUE or FALSE, lParam=0
PRO_GETSELECTED		equ PRO_BASE+6		;wParam=0, lParam=0
PRO_ADDITEM			equ PRO_BASE+7		;wParam=nType, lParam=fOpen
PRO_DELITEM			equ PRO_BASE+8		;wParam=0, lParam=0
PRO_CANUNDO			equ PRO_BASE+9		;wParam=0, lParam=0
PRO_UNDODELETED		equ PRO_BASE+10		;wParam=0, lParam=0
PRO_SETNAME			equ PRO_BASE+11		;wParam=lpszName, lParam=lpszPath
PRO_SHOWNAMES		equ PRO_BASE+12		;wParam=0, lParam=Handle output window
PRO_SETEXPORT		equ PRO_BASE+13		;wParam=nType, lParam=lpszDefaultFileName
PRO_EXPORTNAMES		equ PRO_BASE+14		;wParam=0, lParam=Handle output window
PRO_GETSTYLEPOS		equ PRO_BASE+15		;wParam=0, lParam=lpPOINT
PRO_SETSTYLEPOS		equ PRO_BASE+16		;wParam=0, lParam=lpPOINT

;Project item types
TPE_NAME			equ 1
TPE_INCLUDE			equ 2
TPE_RESOURCE		equ 3
TPE_DIALOG			equ 4
TPE_MENU			equ 5
TPE_ACCEL			equ 6
TPE_VERSION			equ 7
TPE_STRING			equ 8
TPE_LANGUAGE		equ 9

PROJECT struct
	hmem			dd ?
	ntype			dd ?
	delete			dd ?
	changed			dd ?
	lnstart			dd ?
	lnend			dd ?
PROJECT ends

NAMEMEM struct
	szname			db MaxName dup(?)
	value			dd ?
	delete			dd ?
NAMEMEM ends

INCLUDEMEM struct
	szfile			db MAX_PATH dup(?)
INCLUDEMEM ends

RESOURCEMEM struct
	ntype			dd ?
	szname			db MaxName dup(?)
	value			dd ?
	szfile			db MAX_PATH dup(?)
RESOURCEMEM ends

STRINGMEM struct
	szname			db MaxName dup(?)
	value			dd ?
	szstring		db 512 dup(?)
	lang			dd ?
	sublang			dd ?
STRINGMEM ends

ACCELMEM struct
	szname			db MaxName dup(?)
	value			dd ?
	nkey			dd ?
	nascii			dd ?
	flag			dd ?
	lang			dd ?
	sublang			dd ?
ACCELMEM ends

VERSIONMEM struct
	szname			db MaxName dup(?)
	value			dd ?
	fv				dd ?
	fv1				dd ?
	fv2				dd ?
	fv3				dd ?
	pv				dd ?
	pv1				dd ?
	pv2				dd ?
	pv3				dd ?
	os				dd ?
	ft				dd ?
	ff				dd ?
	fts				dd ?
	lng				dd ?
	chs				dd ?
VERSIONMEM ends

VERSIONITEM struct
	szname			db MaxName dup(?)
	szvalue			db 256 dup(?)
VERSIONITEM ends

LANGUAGEMEM struct
	lang			dd ?
	sublang			dd ?
LANGUAGEMEM ends

;Dialog Edit Window Styles
DES_GRID			equ 1
DES_SNAPTOGRID		equ 2
DES_TOOLTIP			equ 4
DES_STYLEHEX		equ 8

;Dialog edit window memory
DEWM_DIALOG			equ 0
DEWM_MEMORY			equ 4
DEWM_READONLY		equ 8
DEWM_SCROLLX		equ 12
DEWM_SCROLLY		equ 16
DEWM_PROJECT		equ 20

.const

IFDEF DLL
	;Window classes global
	szDlgEditClass		db 'DLGEDITCLASS',0
	szToolBoxClass		db 'TOOLBOXCLASS',0
	szPropertyClass		db 'PROPERTYCLASS',0
	szProjectClass		db 'PROJECTCLASS',0
	szDlgEditDummyClass	db 'DlgEditDummy',0
ELSE
	;Window classes local
	szDlgEditClass		db 'MYDLGEDITCLASS',0
	szToolBoxClass		db 'MYTOOLBOXCLASS',0
	szPropertyClass		db 'MYPROPERTYCLASS',0
	szProjectClass		db 'MYPROJECTCLASS',0
	szDlgEditDummyClass	db 'DlgEditDummy',0
ENDIF
