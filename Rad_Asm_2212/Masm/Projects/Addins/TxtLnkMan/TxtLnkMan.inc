
;#########################################################################
;		Include files

	include windows.inc
	include kernel32.inc
	include user32.inc
	include Comctl32.inc
;	include shell32.inc
;	include ComDlg32.inc
;	include Gdi32.inc

;#########################################################################
;		Libraries

	includelib kernel32.lib
	includelib user32.lib
	includelib Comctl32.lib
;	includelib shell32.lib
;	includelib ComDlg32.lib
	includelib Gdi32.lib

;#########################################################################
;		RadASM Add In Include

	include \RadASM\Masm\Inc\radasm.inc
	include \RadASM\Masm\Inc\raedit.inc

;#########################################################################
;		VKim's Debug

	include \RadASM\masm\inc\debug.inc
	includelib \RadASM\masm\lib\debug.lib

	DBGWIN_DEBUG_ON = 1		; include debug info into the program
	DBGWIN_EXT_INFO = 0		; include extra debug info into the program

;#########################################################################
;		Prototypes

DLLProc				PROTO :DWORD, :DWORD, :DWORD, :DWORD
InstallDLL			PROTO :DWORD, :DWORD

TextOutput			PROTO :DWORD
clrOutput			PROTO 
HexOutput			PROTO :DWORD
DlgManageProc		PROTO :HWND,:UINT,:WPARAM,:LPARAM

PROFIND struct
	nFun		dd ?	;0=Find, 1=Free memory
	hMem		dd ?	;Memory handle. NULL if nFile is used.
	nFile		dd ?	;Project file ID.
	pMem		dd ?	;Returned pointer to found line in file
	pFile		dd ?	;Set / returned position in file.
	lpFind		dd ?	;Pointer to find what string.
	lpNot		dd ?	;Pointer to NOT string. Typical ;'"
	lpLine		dd ?	;Pointer to line buffer.
	pLine		dd ?	;Returned position into line buffer. -1 if not found.
	nMiss		dd ?	;Number of invalid Project file ID's.
PROFIND ends
	
.const

DLG_1				equ 1000
LSV_LINKS			equ 1001
BTN_REPLACE			equ 1007
BTN_CANCEL			equ 1008
RADIO_NOTE			equ 1003
RADIO_BUG			equ 1004
RADIO_TODO			equ 1005
EDT_OUT				equ 1006

.data

szMenuString		db "Text Links Manager",0	; for menu
szTxt				db 'txt',0					; get main txt
szAsm				db 'asm',0
szInc				db 'inc',0
szLink				db '### ',0					; the text to search in .txt		
szSee				db '### SEE - ',0
szNote				db 'NOTE',0
szBug				db 'BUG',0
szToDo				db 'TODO',0
lpszLinks			dd szNote,szBug,szToDo
lpszArrays			dd szNoteArr,szBugArr,szTodoArr
nN					dd 0
nB					dd 0
nT					dd 0
szNot				dd 0

lvi 				LV_ITEM <LVIF_TEXT,0,0,LVIS_FOCUSED,0,offset text,100,0,0>
lvc 				LV_COLUMN <>

hilitewords			db '###',0
hilitecolor			dd 0F00000FFh
rabdtxtlnk			RABLOCKDEF <offset hilitewords,0,0,0,BD_SEGMENTBLOCK or BD_DIVIDERLINE>

.data?

hInstance			dd ?	;Dll's module handle
lpHandles			dd ?	;Pointer to handles struct
lpProc				dd ?	;Pointer to proc struct
lpData				dd ?	;Pointer to data struct
hOut				dd ?	;Handle of output window
IDAddIn				dd ?	;Unique ID for this AddIn

hlist				dd ?
hREd				dd ?
searchLen			dd ?
lineBuff			db 512 dup(?)
text 				db 128  dup (?)
szNoteArr			db 512 dup (?)		; item number array
szBugArr			db 512 dup (?)		;   "   "      "
szTodoArr			db 512 dup (?)		;   "   "      "
nLastLine			dd ?

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
