
include		windows.inc
include		kernel32.inc
include		user32.inc
include		Comctl32.inc
include		gdi32.inc

includelib	kernel32.lib
includelib	user32.lib
includelib	Comctl32.lib
includelib	gdi32.lib

;Debug
include masm32.inc
include Debug.Inc
includelib masm32.lib
includelib Debug.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_MAIN		equ 101
IDC_IMG1		equ 102
IDC_EDT1		equ 103
IDB_FONT		equ 100

szStart			db 'uc8 Font8x10[256][10] = {',0Dh,0Ah,0
szEnd			db '};',0Dh,0Ah,0
szChrStart		db '{ // %d',0Dh,0Ah,0
szChrEnd		db '},',0Dh,0Ah,0
szChrEnd1		db '}',0Dh,0Ah,0

;#########################################################################

.data?

hInstance		DWORD ?
hDC				HDC ?
chrBuff			BYTE 10 dup(?)

;#########################################################################
