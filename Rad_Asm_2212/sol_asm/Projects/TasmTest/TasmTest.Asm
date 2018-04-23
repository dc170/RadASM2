;                    Project Created: 16:19 27/10/99

;                                  By


;                              IdeasM v1.0
;                              
;                              Written By
;                              
;                          ShADe & CodeFumbler
;                          
;                                Oct, 1999



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;             This file should be compiled in the following manner

; Compiler  :TASM
;                     Parameters: 
;                                  Release: Default
;                                  Debug  : Default

; Linker    :TLINK32

;                     Parameters:
;                                  Release:Default
;                                  Debug  :Default

; Resource  :BRCC32
;                     Parameters:          Default

; .Asm Files:
;              Sample.asm


; .Lib Files:
;              Import32.lib

; .Res Files:
;              Sample.res

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                





.486p                                             
.MODEL FLAT,STDCALL
locals
jumps
UNICODE=0
include TasmTest.inc

;--------------------------------------------------------------------------------
;If you are doing source code breakpoints, this file must be included.
;You don't need it with int 3 breakpoints.
include \radasm\tasm\inc\radbg.inc
;--------------------------------------------------------------------------------

.DATA
WINTITLE     db          "IdeasM v1.0",0          ;Window Title
INTRO        db          "IdeasM v1.0",13,10,13,10;Start Intro
			 db          "Written By",13,10,13,10
			 db          "ShADe & CodeFumbler",13,10
			 db          "10/99",13,10
			 db          0                       ;End Intro

IdeasM_ICON  equ         201
DLG_MAIN     equ         202
TEXT_OUT     equ         203
BTN_EXIT     equ         204
BTN_OK		 equ         205

hicon        dd          0
hinst_       dd          0

.CODE


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;	                        Start of program
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Start:
	call	GetModuleHandleA,0
	test	eax,eax
	jne		gmhok	
	call	ExitProcess,0
	
gmhok:  
	mov		hinst_, eax
	call	DialogBoxParamA, hinst_, DLG_MAIN, 0, offset DlgProcedure, 0
	call	ExitProcess,0

;***********************************************************************
;                           	Start DLGProcedure
;***********************************************************************
PUBLIC DlgProcedure
DlgProcedure PROC STDCALL,hwnd_:DWORD,wmsg:DWORD,wparam_:DWORD,lparam_:DWORD
	USES ebx, edi, esi

	cmp	    wmsg, WM_DESTROY
	je	    wmdestroy
	cmp	    wmsg, WM_CLOSE
	je	    wmdestroy
	cmp	    wmsg, WM_COMMAND	
	je	    wmcommand
	cmp	    wmsg, WM_INITDIALOG	
	je	    dlginit
	xor	    eax, eax
	RET
	
wmdestroy:
	call	EndDialog, hwnd_, 0
	call	ExitProcess,0

wmcommand:
	cmp     word ptr [wparam_], BTN_EXIT 
	je   	wmdestroy
	cmp     word ptr [wparam_], BTN_OK
	je   	wmdestroy
	RET
	
dlginit:
	call	LoadIconA, hinst_, IdeasM_ICON
	test	eax, eax
	je		@@ierr
	mov	    hicon, eax
	call	SendMessageA, hwnd_, WM_SETICON, IdeasM_ICON, hicon
	
@@ierr:
	call	SetWindowTextA, hwnd_, offset wintitle
	call	SetDlgItemTextA, hwnd_, TEXT_OUT, offset intro
	test	eax, eax
	je	    wmdestroy
	RET

DlgProcedure ENDP
;***********************************************************************
;		                  End DLGProcedure
;***********************************************************************
ends
end Start
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;	                         End Program
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
