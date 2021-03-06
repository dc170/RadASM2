
						COMMENT " written by drizz <1of00@gmx.net> "

;;
;;						CONVERT 
;;

ByteToHex				PROTO	STDCALL	:DWORD
DwToBin					PROTO	STDCALL	:DWORD,:DWORD
DwToHex					PROTO	STDCALL	:DWORD,:DWORD
QwToHex					PROTO	STDCALL	:DWORD,:DWORD
DwToStr					PROTO	STDCALL	:DWORD,:DWORD
DwToStrl				PROTO	STDCALL	:DWORD,:DWORD
HexToDw					PROTO	STDCALL	:DWORD
IntToStr				PROTO	STDCALL	:SDWORD,:DWORD
StrToDw					PROTO	STDCALL	:DWORD
StrToInt				PROTO	STDCALL	:DWORD
GetDlgItemHex			PROTO	STDCALL	:DWORD,:DWORD
SetDlgItemHex			PROTO	STDCALL	:DWORD,:DWORD,:DWORD

;;
;;						STRING
;;

StrStr					PROTO	STDCALL	:DWORD,:DWORD
StrCat					PROTO	STDCALL	:DWORD,:DWORD
StrChr					PROTO	STDCALL	:DWORD,:DWORD
StrConCat				PROTO	C		:DWORD,:VARARG
StrCmp					PROTO	STDCALL	:DWORD,:DWORD
StrCmpi					PROTO	STDCALL	:DWORD,:DWORD
StrCpy					PROTO	STDCALL	:DWORD,:DWORD
StrEnd					PROTO	STDCALL	:DWORD
StrLen					PROTO	STDCALL	:DWORD
StrRev					PROTO	STDCALL	:DWORD
StrTrim					PROTO	STDCALL	:DWORD
StrLower				PROTO	STDCALL	:DWORD
StrUpper				PROTO	STDCALL	:DWORD
ChrTest					PROTO	STDCALL	:DWORD,:DWORD

;;
;;						MEMORY
;;

CompareMem				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
CopyMemory				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
FillMemory				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
FreeMem					PROTO	STDCALL	:DWORD
GetMem					PROTO	STDCALL	:DWORD
FreeVMem				PROTO	STDCALL	:DWORD
GetVMem					PROTO	STDCALL	:DWORD
ResizeMem				PROTO	STDCALL	:DWORD,:DWORD
ZeroMemory				PROTO	STDCALL	:DWORD,:DWORD

;;
;;						REGISTRY
;;

RegKeyClose				PROTO	STDCALL	
RegKeyOpen				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
RegKeyDelete			EQU		<RegDeleteKey>
RegReadDw				PROTO	STDCALL	:DWORD
RegReadStr				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
RegWriteDw				PROTO	STDCALL	:DWORD,:DWORD
RegWriteStr				PROTO	STDCALL	:DWORD,:DWORD

;;	
;;						FILES
;;

FileClose               PROTO	STDCALL	:DWORD
FileCreate              PROTO	STDCALL	:DWORD
FileDelete				PROTO	STDCALL	:DWORD
FileExists              PROTO	STDCALL	:DWORD
FileOpen                PROTO	STDCALL	:DWORD,:DWORD
FileRead                PROTO	STDCALL	:DWORD,:DWORD,:DWORD
FileSeek                PROTO	STDCALL	:DWORD,:DWORD,:DWORD
FileSize                PROTO	STDCALL	:DWORD
FileWrite               PROTO	STDCALL	:DWORD,:DWORD,:DWORD

;;
;;						INI FILES
;;

IniReadDword			PROTO	STDCALL	:DWORD,:DWORD
IniReadInt				PROTO	STDCALL	:DWORD,:DWORD
IniReadStr				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
IniReadStruct			PROTO	STDCALL	:DWORD,:DWORD,:DWORD
IniSetFileName			PROTO	STDCALL	:DWORD
IniSetSection			PROTO	STDCALL	:DWORD
IniWriteDword			PROTO	STDCALL	:DWORD,:DWORD
IniWriteInt				PROTO	STDCALL	:DWORD,:DWORD
IniWriteStr				PROTO	STDCALL	:DWORD,:DWORD
IniWriteStruct			PROTO	STDCALL	:DWORD,:DWORD,:DWORD

;;
;;						STREAM FILE
;;

FSCreate				PROTO	STDCALL	:DWORD,:DWORD
FSDuplicate				PROTO	STDCALL	:DWORD,:DWORD
FSFlush					PROTO	STDCALL	:DWORD
FSDump					PROTO	STDCALL	:DWORD,:DWORD,:DWORD,:DWORD
FSFree					PROTO	STDCALL	:DWORD

;;
;;						CONSOLE MODE
;;

InitConsole				PROTO	STDCALL	
ClrScr					PROTO	STDCALL	
FullScreen				PROTO	STDCALL	
Getch					PROTO	STDCALL	
Putch					PROTO	STDCALL	:DWORD
Gotoxy					PROTO	STDCALL	:DWORD,:DWORD
Readln					PROTO	STDCALL	:DWORD,:DWORD,:DWORD
TextBackground			PROTO	STDCALL	:DWORD
TextColor				PROTO	STDCALL	:DWORD
Write					PROTO	STDCALL	:DWORD
Writeln					PROTO	STDCALL	:DWORD
Writelnf				PROTO	C		:DWORD,:VARARG
Writexy					PROTO	STDCALL	:DWORD,:DWORD,:DWORD

;;
;;						OTHER
;;

IsNT					PROTO	STDCALL
ExtractFileName			PROTO	STDCALL	:DWORD,:DWORD
ExtractFilePath			PROTO	STDCALL	:DWORD,:DWORD
ParamCount				PROTO	STDCALL	
ParamStr				PROTO	STDCALL	:DWORD,:DWORD,:DWORD
Random					PROTO	STDCALL	:DWORD
Randomize				PROTO	STDCALL	

;;
;;						INT64 SUPPORT
;;

QwAdd					PROTO	STDCALL	:DWORD,:DWORD
QwDec					PROTO	STDCALL	:DWORD
QwDiv					PROTO	STDCALL	:DWORD,:DWORD,:DWORD
QwInc					PROTO	STDCALL	:DWORD
QwMod					PROTO	STDCALL	:DWORD,:DWORD,:DWORD
QwMul					PROTO	STDCALL	:DWORD,:DWORD,:DWORD
QwRol					PROTO	STDCALL	:DWORD,:DWORD
QwRor					PROTO	STDCALL	:DWORD,:DWORD
QwShl					PROTO	STDCALL	:DWORD,:DWORD
QwShr					PROTO	STDCALL	:DWORD,:DWORD
QwSub					PROTO	STDCALL	:DWORD,:DWORD

;;
;;						STDLIB CONSTANTS
;;

ccBlack         equ 0
ccBlue          equ 1
ccGreen         equ 2
ccCyan          equ 3
ccRed           equ 4
ccMagenta       equ 5
ccBrown         equ 6
ccLightGray     equ 7
ccDarkGray      equ 8
ccLightBlue     equ 9
ccLightGreen    equ 10
ccLightCyan     equ 11
ccLightRed      equ 12
ccLightMagenta  equ 13
ccYellow        equ 14
ccWhite         equ 15

CHR_UPPER equ 00000001b
CHR_LOWER equ 00000010b
CHR_DIGIT equ 00000100b
CHR_DELIM equ 00001000b
CHR_PUNCT equ 00010000b
CHR_CNTRL equ 00100000b
CHR_SPACE equ 01000000b
CHR_HEX   equ 10000000b
CHR_ALPHA equ CHR_LOWER or CHR_UPPER
CHR_ALNUM equ CHR_LOWER or CHR_UPPER or CHR_DIGIT
CHR_PRINT equ CHR_LOWER or CHR_UPPER or CHR_DIGIT or CHR_PUNCT or CHR_SPACE

u64 struct
	Lo dd ?
	Hi dd ?
u64 ends

FILESTREAM struct
	hFile dd ?
	dwFsize dd ?
	pMem dd ?
FILESTREAM ends

;;
;;						STANDARD CONSTANTS
;;

pushad_size equ 8*4
pushad_eax  equ 7*4
pushad_ecx  equ 6*4
pushad_edx  equ 5*4
pushad_ebx  equ 4*4
pushad_esp  equ 3*4
pushad_ebp  equ 2*4
pushad_esi  equ 1*4
pushad_edi  equ 0*4

CR   textequ <13>
LF   textequ <10>
CRLF textequ <CR,LF>

;;
;;						STANDARD-STDLIB MACROS
;;

include Stdlib.mac
