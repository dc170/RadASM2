
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101

tbrbtns				TBBUTTON <7,10000,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0>
					TBBUTTON <8,10001,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0>
					TBBUTTON <0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0>
					TBBUTTON <0,10002,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0>
					TBBUTTON <1,10003,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0>
					TBBUTTON <2,10004,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0>
ntbrbtns			equ 6

.code

;#########################################################################

.data?

hInstance			dd ?
icex				INITCOMMONCONTROLSEX <>

;#########################################################################
