;				invoke wsprintf,offset buf,offset fmat,eax
;				invoke MessageBox,0,offset buf,0,MB_OK

;#########################################################################
;		Include files

	include windows.inc
	include kernel32.inc
	include user32.inc
	include Comctl32.inc
;	include shell32.inc
;	include ComDlg32.inc
	include Gdi32.inc
	include Stdlib.Inc
	include masm32.inc				; InString()
	
	include \RadASM\Masm\Inc\RAEdit.inc
;#########################################################################
;		Libraries

	includelib kernel32.lib
	includelib user32.lib
	includelib Comctl32.lib
;	includelib shell32.lib
;	includelib ComDlg32.lib
	includelib Gdi32.lib
	includelib Stdlib.lib
	includelib masm32.lib

;#########################################################################
;		RadASM Add In Include

	include \RadASM\Masm\Inc\radasm.inc

;#########################################################################
;		VKim's Debug

	include \RadASM\masm\inc\debug.inc
	includelib \RadASM\masm\lib\debug.lib

	DBGWIN_DEBUG_ON = 1		; include debug info into the program
	DBGWIN_EXT_INFO = 0		; include extra debug info into the program

;#########################################################################
;		Prototypes

	DLLProc					PROTO :DWORD, :DWORD, :DWORD, :DWORD
	InstallDLL				PROTO :DWORD, :DWORD
	
	TextOutput				PROTO :DWORD
	clrOutput				PROTO 
	HexOutput				PROTO :DWORD

	AddMenu                 	PROTO
	AutoCorrectDlg          	PROTO	:HWND,:UINT,:WPARAM,:LPARAM
	DealWithBeforeSpace     	PROTO	:DWORD
	InsertColumn            	PROTO
	LoadListFromFile        	PROTO	:DWORD
	RAEditProc              	PROTO	:HWND,:UINT,:WPARAM,:LPARAM
	SaveProcedure           	PROTO
	LoadStringsToMem		PROTO	:DWORD,:DWORD
	MultilineDlg			PROTO	:HWND,:UINT,:WPARAM,:LPARAM


;#########################################################################
;		Macros


;#########################################################################

.const

ID_EDIT 						= 65501
MAX_STRING 						= 500
DIVSIGN 						= 255		; isim 01 description 01 yol+isim 01 gibi ayraç(.dat)

DLG_CORRECT						equ 1000
GRP_1							equ 1006
EDT_OLD							equ 1001
EDT_NEW							equ 1002
STC_1							equ 1003
STC_2							equ 1004
BTN_CHANGE						equ 1007
BTN_DELETE						equ 1008
BTN_OK							equ 1009
BTN_CANCEL						equ 1010
LSV_LIST						equ 1005
BTN_MULTI						equ 1011

DLG_MULT						equ 2000
EDT_MULTI						equ 2001
BTN_MULTOK						equ 2002
BTN_MULTCAN						equ 2003

.data

;fmat		db "string:%s_",0
;fmat		db "eax:%d",0
;fmat		db "sztmpMulti:%s, sztmpMulti_length:%d, countSPTB:%d",0
;fmat		db "AL=%c",0
;fmat		db "%d and %d",0

OldListWndProc        dd 0

bMult			dd 0					; if caret in first line 0
szMenuString 	db "Auto Correct List",0
BackSlash		db "\",0
DataFileName 	db "AutoCorrect.dat",0
emptystring  	db 0
divstring 		db 0FFh,0
ismulti			dd 0
listIndex 		dd 0
szTilde			db '~',0
cpos			dd 0
countSPTB		dd 0						; length of szSpacesnTabs
szCRLF			db 13,10,0
text 			db MAX_STRING dup(0)
sztmpMulti		db MAX_STRING dup(0)		; for indent

lvi 	LV_ITEM <LVIF_TEXT,0,0,LVIS_FOCUSED,0,offset text,MAX_STRING,0,0>
lvc 	LV_COLUMN <>
lvnmhdr	NMHDR <hList>

.data?

hInstance		dd ?	;Dll's module handle
lpHandles		dd ?	;Pointer to handles struct
lpProc			dd ?	;Pointer to proc struct
lpData			dd ?	;Pointer to data struct
hOut			dd ?	;Handle of output window
IDAddIn			dd ?	;Unique ID for this AddIn

startofw		dd ?
pszOlds			dd ?
pszNews			dd ?
pszMulti		dd ?

g_hDlgAuto		dd ?		
hFile			dd ?	; .dat
fileSize		dd ?
pMemory			dd ?
SizeRW 			dd ?	; writefile için
recure 			dd ?	; column sign
indice			dd ?
tmpIndice		dd ?
AddrTableOld	dd 100 dup(?)		; 100 items in listv.
AddrTableNew	dd 100 dup(?)		;  "   "    "   "
DataFullName 	db MAX_PATH  dup(?)
szSpacesnTabs	db 200 dup(?)
hList			dd ?
hEdt1			dd ?
OldEditProc1	dd ?
hEdt2			dd ?
OldEditProc2	dd ?
szLine			db 300 dup(?)
tempBuffer		db 500 dup(?)
;buf				db 300 dup(?)

.code

;#########################################################################
;		Output Window procs

TextOutput proc lpszStr

   pushad
   
   push  lpszStr
   mov   eax,lpProc
   call  [eax].ADDINPROCS.lpTextOut
   
   popad	
   ret

TextOutput endp

;#########################################################################

clrOutput proc

   pushad
   
   mov   eax,lpProc
   call  [eax].ADDINPROCS.lpClearOut
   
   popad	
   ret

clrOutput endp

;#########################################################################

HexOutput proc val:DWORD
	
	pushad
	
	push  val
	mov   eax,lpProc
	call  [eax].ADDINPROCS.lpHexOut
	
	popad
	ret
	
HexOutput endp
