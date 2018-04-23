#Define SIZE_OF_80387_REGISTERS 80
#Define MAXIMUM_SUPPORTED_EXTENSION 512
#Define EXCEPTION_MAXIMUM_PARAMETERS 15

EXCEPTION_RECORD STRUCT
  ExceptionCode         DD
  ExceptionFlags        DD
  pExceptionRecord      DD
  ExceptionAddress      DD
  NumberParameters      DD
  ExceptionInformation  DD EXCEPTION_MAXIMUM_PARAMETERS dup (?)
EXCEPTION_RECORD ENDS

FLOATING_SAVE_AREA STRUCT
  ControlWord   DD ; 0
  StatusWord    DD ; 4
  TagWord       DD ; 8
  ErrorOffset   DD ; 12
  ErrorSelector DD ; 16
  DataOffset    DD ; 20
  DataSelector  DD ; 24
  RegisterArea  DB  SIZE_OF_80387_REGISTERS dup (?) ; 28
  Cr0NpxState   DD ; 108
FLOATING_SAVE_AREA ENDS ; 112 Bytes

CONTEXT STRUCT
  ContextFlags  DD ; 0
  iDr0          DD ; 4
  iDr1          DD ; 8
  iDr2          DD ; 12
  iDr3          DD ; 16
  iDr6          DD ; 20
  iDr7          DD ; 24
  FloatSave     FLOATING_SAVE_AREA         <0> ; 28
  regGs         DD ; 140
  regFs         DD ; 144
  regEs         DD ; 148
  regDs         DD ; 152
  regEdi        DD ; 156
  regEsi        DD ; 160
  regEbx        DD ; 164
  regEdx        DD ; 168
  regEcx        DD ; 172
  regEax        DD ; 176
  regEbp        DD ; 180
  regEip        DD ; 184
  regCs         DD ; 188
  regFlag       DD ; 192
  regEsp        DD ; 196
  regSs         DD ; 200
  ExtendedRegisters DB MAXIMUM_SUPPORTED_EXTENSION dup (?) ; 204
CONTEXT ENDS ; 716 Bytes 

IMAGEHLP_LINE STRUCT
    SizeOfStruct    DD
    Key             DD
    LineNumber      DD
    FileName        DD
    Address         DD
IMAGEHLP_LINE ENDS

.CONST
	SRC1_FPU    EQU   1
	SRC1_REAL   EQU   2
	SRC1_DMEM   EQU   4
	SRC1_DIMM   EQU   8
	SRC1_CONST  EQU   16

	ANG_DEG     EQU   0
	ANG_RAD     EQU   32

	DEST_MEM    EQU   0
	DEST_IMEM   EQU   64
	DEST_FPU    EQU   128

	SRC2_FPU    EQU   256
	SRC2_REAL   EQU   512
	SRC2_DMEM   EQU   1024
	SRC2_DIMM   EQU   2048
	SRC2_CONST  EQU   4096

	STR_REG     EQU   0
	STR_SCI     EQU   32768

	AIM_DEBUGGETWIN	EQU 400h + 997	;Gets the handle of RadASM output window #1. WM_USER+997

.DATA
	;Debug.asm
	szRadWinClass		db "RadASMClass", 0
	szDbgWinClass		db "DbgWinClass", 0
	szDbgCRLF          	db 13, 10, 0
	szDbgEdit			db "Edit", 0

	ALIGN 16
	; Other.asm
	DbgError			db "ERROR > ",0
	DbgShowLine			db "(Show line)",0
	DbgMeasureFmt		db "Measured %d bytes from line %d to line %d",0
	DbgErrorFmt			db "Line %u: Error %u > %s",0
	DbgErrBuf			db 128 DUP (0)

	ALIGN 16
	;HexDump.asm
	DbgszDBGDump		db "### DbgDump",0
	DbgDumpFmt			db "%s %d bytes (%08X to %08X)",0

	ALIGN 16
	;FPUDump.asm
	DbgszFPUDump		db "### DumpFPU",0
	szDbgFPU1			db "Conditional: ST > Source",0
	szDbgFPU2			db "Conditional: ST < Source",0
	szDbgFPU3			db "Conditional: ST = Source",0
	szDbgFPU4			db "Conditional: Undefined",0
	szDbgFPU5			db "FPU Levels : %d ",0
	szDbgFPU6			db "Exception  : e s p u o z d i",0
	szDbgFPU7			db "St(%d)      : %.16s",0

	DbgZeroPad			db "0000000000000000000",0


	DbgszMMXDump		db "### DumpMMX",0
	
	ALIGN 16
	;Spy.asm
	szDbgSpyLabel		db "Spied variable = "
	szDbgSpyBuffer		db 32 DUP (0)
	szDbgDecFormat		db "%li",0
	ALIGN 4
	___fTrap			dd 0
	___pVar				dd 0

	ALIGN 16
	;TrapEx.asm
	___esp				dd 0
	___hLib				dd 0
	___hInst			dd 0
	___pSymInit			dd 0
	___pGetLine			dd 0
	___pSymOpt			dd 0
	___eh				dd 0
	dwTrapLine			dd 0
	pTrapFile			dd 0
	dwTrapDisp			dd 0
	szTrapExcHead		db "=====================[EXCEPTION INFORMATION]====================", 0
	szTrapExcBottom		db 64 dup ("-"), 0
	szTrapExcCode		db 128 dup (0)
	szTrapExcCodeFmt	db "Exception code: %s", 13, 10, "Instruction pointer: %0.8Xh", 13, 10, 0
	szTrapRegsFmt		db "eax=%0.8X ebx=%0.8X ecx=%0.8X edx=%0.8X esi=%0.8X", 13, 10, \
	                     "edi=%0.8X ebp=%0.8X esp=%0.8X eip=%0.8X", 0
	szTrapSegFmt		db "CS=%0.4X DS=%0.4X SS=%0.4X ES=%0.4X FS=%0.4X GS=%0.4X  %s", 0
	szTrapSeg			db 65 dup (0)
	szTrapFlagsFmt		db "%s %s %s %s %s %s %s %s", 0
	szTrapFlags			db 16 dup (0)
	szSymReturn			db "SymReturn",0
	ALIGN 4
	szTrapRegs			db 128 dup (?)
	expt0C0000005h		db "EXCEPTION_ACCESS_VIOLATION",0
	expt0C000008Ch		db "EXCEPTION_ARRAY_BOUNDS_EXCEEDED",0
	expt080000003h		db "EXCEPTION_BREAKPOINT",0
	expt080000002h		db "EXCEPTION_DATATYPE_MISALIGNMENT",0
	expt0C000008Dh		db "EXCEPTION_FLT_DENORMAL_OPERAND",0
	expt0C000008Eh		db "EXCEPTION_FLT_DIVIDE_BY_ZERO",0
	expt0C000008Fh		db "EXCEPTION_FLT_INEXACT_RESULT",0
	expt0C0000090h		db "EXCEPTION_FLT_INVALID_OPERATION",0
	expt0C0000091h		db "EXCEPTION_FLT_OVERFLOW",0
	expt0C0000092h		db "EXCEPTION_FLT_STACK_CHECK",0
	expt0C0000093h		db "EXCEPTION_FLT_UNDERFLOW",0
	expt0C000001Dh		db "EXCEPTION_ILLEGAL_INSTRUCTION",0
	expt0C0000006h		db "EXCEPTION_IN_PAGE_ERROR",0
	expt0C0000094h		db "EXCEPTION_INT_DIVIDE_BY_ZERO",0
	expt0C0000095h		db "EXCEPTION_INT_OVERFLOW",0
	expt080000004h		db "EXCEPTION_SINGLE_STEP",0
	exptOTHER			db "UNKNOWN_EXCEPTION",0
	ALIGN 4
	_vkimloaderr		db	"Can't load dbghelp.dll. Please copy it to the system directory.",0
	_vkimdll			db	"dbghelp.dll",0
	_vkiminit			db	"SymInitialize",0
	_vkimsetopt			db	"SymSetOptions",0
	_vkimgetline		db	"SymGetLineFromAddr",0
	ALIGN 4
	DbgIHL				IMAGEHLP_LINE <>

	ALIGN 16
	;FlagDump
	szDbgEFlagLabel		db "EFLAGS =",0

	ALIGN 16
	; General
	szDefAssetFmt		db "ASSERT > "
	szAssertFmt			db "(%s = 0)",0
	szDbgLineFmt1		db "Line %u: %s",0
	szDbgLineFmt2		db "Line %u: ",0

.CODE

DbgDebugPrint FRAME DebugData
	LOCAL hwnd	:D

	invoke FindWindowA,OFFSET szRadWinClass,0
	or eax,eax
	jnz >
		invoke DbgWinDebugPrint,[DebugData]
		ret
	:
	jz >L2
		invoke SendMessageA,eax,AIM_DEBUGGETWIN,0,1
		mov [hwnd],eax
		invoke SendMessageA,[hwnd],0B1h ,-1,-1 ;EM_SETSEL
		invoke SendMessageA,[hwnd],0Eh ,0,0 ;WM_GETTEXTLENGTH
		or eax,eax
		jz >L1
			invoke SendMessageA,[hwnd],0C2h,0,OFFSET szDbgCRLF ;EM_REPLACESEL
		L1:
		invoke SendMessageA,[hwnd],0C2h,0,[DebugData]
		invoke SendMessageA,[hwnd],0B7h ,0,0 ;EM_SCROLLCARET
	L2:
	ret
ENDF

DbgFormatLine FRAME pAddress,sourceline,poptionarg

	mov eax,[poptionarg]
	or eax,eax
	jz >
	invoke wsprintfA,[pAddress],OFFSET szDbgLineFmt1,[sourceline],[poptionarg]
	add esp,16
	jmp >L1
	:
	invoke wsprintfA,[pAddress],OFFSET szDbgLineFmt2,[sourceline]
	add esp,12
	L1:
	invoke StrLen,[pAddress]
	add eax,[pAddress]

	RET
ENDF

DbgWinDebugPrint FRAME DebugData
	local hwnddbg: d
	invoke FindWindowA, offset szDbgWinClass, 0
	or eax,eax
	jnz >
		invoke WinExec, offset _szDbgCommandLine, 1
		invoke FindWindowA, offset szDbgWinClass, 0
	:

	or eax,eax
	jz >L1
		mov [hwnddbg], eax
		invoke FindWindowExA, [hwnddbg], 0, offset szDbgEdit, 0
		mov [hwnddbg], eax
		invoke SendMessageA, [hwnddbg], 0Eh, 0, 0
		push eax
		invoke SendMessageA, [hwnddbg], 0B1h, -1, -1
		pop eax
		or eax,eax
		jz >
			invoke SendMessageA, [hwnddbg], 0C2h, 0, offset szDbgCRLF
		:
		invoke SendMessageA, [hwnddbg], 0C2h, 0, [DebugData]
		invoke SendMessageA, [hwnddbg], 0B7h, 0, 0
	L1:
	ret
endf

DbgAssert FRAME dwVar,dwLine,pVarName,pText
	LOCAL pData		:D
	LOCAL pAppend	:D

	mov eax,[dwVar]
	or eax,eax
	jnz >.DONE
		invoke GlobalAlloc,040h,128
		mov [pData],eax
		invoke StrLen,[pText]
		or eax,eax
		jz >.DEFTEXT
			invoke DbgFormatLine,[pData],[dwLine],[pText]
			mov B[eax]," "
			inc eax
			invoke wsprintfA,eax,OFFSET szAssertFmt,[pVarName]
			jmp >.DBGPRINT
		.DEFTEXT
			invoke DbgFormatLine,[pData],[dwLine],0
			mov B[eax]," "
			inc eax
			invoke wsprintfA,eax,OFFSET szDefAssetFmt,[pVarName]
		.DBGPRINT
		invoke DbgDebugPrint,[pData]
		invoke GlobalFree,[pData]
	.DONE
	RET
ENDF

#include "Spy.asm"
#include "Other.asm"
#include "FlagDump.asm"
#include "conversions.asm"
#include "FPUDump.asm"
#include "TrapEx.asm"
#include "HexDump.asm"
#include "MMXDump.asm"
