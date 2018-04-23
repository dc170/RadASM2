
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include gdi32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib gdi32.lib

DlgProc				PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101
IDC_ANI1			equ 1001
IDR_AVI				equ 100

;#########################################################################

.data

szAvi				db 'res\goeye.avi',0

.data?

hInstance			dd ?
iccex				INITCOMMONCONTROLSEX <?>

;#########################################################################
