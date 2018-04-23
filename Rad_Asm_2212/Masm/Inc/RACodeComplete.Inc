
;CodeCompleteListBox Messages
CCM_ADDITEM			equ WM_USER+0			;wParam=0, lParam=lpString, Returns nothing
CCM_DELITEM			equ WM_USER+1			;wParam=Index, lParam=0, Returns nothing
CCM_GETITEM			equ WM_USER+2			;wParam=Index, lParam=0, Returns pointer to string or NULL
CCM_GETCOUNT		equ WM_USER+3			;wParam=0, lParam=0, Returns count
CCM_CLEAR			equ WM_USER+4			;wParam=0, lParam=0, Returns nothing
CCM_SETCURSEL		equ WM_USER+5			;wParam=Index, lParam=0, Returns nothing
CCM_GETCURSEL		equ WM_USER+6			;wParam=0, lParam=0, Returns Index
CCM_GETTOPINDEX		equ WM_USER+7			;wParam=0, lParam=0, Returns TopIndex
CCM_SETTOPINDEX		equ WM_USER+8			;wParam=TopIndex, lParam=0, Returns nothing
CCM_GETITEMRECT		equ WM_USER+9			;wParam=Index, lParam=lpRECT, Returns nothing
CCM_SETVISIBLE		equ WM_USER+10			;wParam=0, lParam=0, Returns nothing
CCM_FINDSTRING		equ WM_USER+11			;wParam=Start Index, lParam=lpString, Returns Index or -1
CCM_SORT			equ WM_USER+12			;wParam=Descending (TRUE/FALSE), lParam=0, Returns nothing
CCM_GETCOLOR		equ WM_USER+13			;wParam=0, lParam=lpCC_COLOR, Returns nothing
CCM_SETCOLOR		equ WM_USER+14			;wParam=0, lParam=lpCC_COLOR, Returns nothing

CC_COLOR struct
	back	dd ?
	text	dd ?
CC_COLOR ends

;CodeCompleteToolTip Messages
TTM_SETITEM			equ WM_USER+0			;wParam=0, lParam=lpTTITEM, Returns x-offset
TTM_GETCOLOR		equ WM_USER+1			;wParam=0, lParam=lpTT_COLOR, Returns nothing
TTM_SETCOLOR		equ WM_USER+2			;wParam=0, lParam=lpTT_COLOR, Returns nothing

TT_COLOR struct
	back	dd ?
	text	dd ?
	api		dd ?
	hilite	dd ?
TT_COLOR ends

TTITEM struct
	lpszApi		dd ?						;Pointer to api string
	lpszParam	dd ?						;Pointer to comma separated parameters string
	nitem		dd ?						;Item to hilite
TTITEM ends

.const

IFDEF DLL
	szCCLBClassName	db 'RACodeComplete',0
	szCCTTClassName	db 'RAToolTip',0
ELSE
	szCCLBClassName	db 'MyRACodeComplete',0
	szCCTTClassName	db 'MyRAToolTip',0
ENDIF
