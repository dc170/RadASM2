include windows.inc
include user32.inc
include kernel32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc
include ole32.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib ole32.lib

include masm32.inc
include \RadASM\Masm\Inc\Debug.Inc
includelib masm32.lib
includelib \RadASM\Masm\Lib\Debug.lib

WinMain				PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDM_FILE_EXIT		equ 10001
IDM_HELP_ABOUT		equ 10101

.data

ClassName			db 'DLGCLASS',0
AppName				db 'Dialog as main',0
AboutMsg			db 'MASM32 RadASM Dialog as main',13,10,'Copyright © MASM32 2004',0

.data?

hInstance			dd ?
CommandLine			dd ?
hWnd				dd ?
hDrag				dd ?
hDrop1				dd ?
hDrop2				dd ?
peff				dd ?
