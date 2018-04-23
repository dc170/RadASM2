DLL
Win32DLL
DLL Skeleton
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,0,0,0,0,0,0
1=4,O,$B\GORC.EXE /r,1
2=3,OT,$B\GoAsm.EXE,2
3=7,OT,$B\GoLink @$B\GFL.txt @$6 /dll /entry DllEntryPoint,3
4=0,0,,5
5=
6=*.obj,O,$B\GoAsm.EXE,*.asm
7=0,0,\OllyDbg\OllyDbg,5
11=4,O,$B\GORC.EXE /r,1
12=3,O,$B\GoAsm.EXE,2
13=7,OT,$B\GoLink @$B\GFL.txt @$6 /dll /entry /debug coff DllEntryPoint,3
14=0,0,,5
15=
16=*.obj,O,$B\GoAsm.EXE,*.asm
17=0,0,\OllyDbg\OllyDbg,5
[MakeFiles]
0=Win32DLL.rap
1=Win32DLL.rc
2=Win32DLL.asm
3=Win32DLL.obj
4=Win32DLL.res
5=Win32DLL.exe
6=Win32DLL.def
7=Win32DLL.dll
8=Win32DLL.txt
9=Win32DLL.lib
10=Win32DLL.mak
11=Win32DLL.hla
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
Win32DLL.Asm
;##################################################################
; DLLAPP
;##################################################################

#Include "Win32DLL.Inc"

DATA SECTION
	hInstance		DD		0

;##################################################################

CODE SECTION

DllEntryPoint	FRAME hInst, reason, reserved1

	mov eax,[reason]
	.DLLPROCESSATTACH
	cmp eax,DLL_PROCESS_ATTACH
	JNE >.DLLPROCESSDETACH
		mov eax,[hInst]
		mov [hInstance], eax
		JMP >.LOAD
	
	.DLLPROCESSDETACH
	cmp eax,DLL_PROCESS_DETACH
	JNE >.DLLTHREADATTACH
		JMP >.LOAD
	
	.DLLTHREADATTACH
	cmp eax,DLL_THREAD_ATTACH
	JNE >.DLLTHREADDETACH
		JMP >.LOAD
	
	.DLLTHREADDETACH
	cmp eax,DLL_THREAD_DETACH
	JNE >.NOLOAD
		JMP >.LOAD
	
	.NOLOAD
		; The reson was not understood
		; Rather than take a chance we will refuse to load
		xor eax, eax
		ret
	
	.LOAD
		xor eax, eax
		inc eax

	ret
ENDF

[*ENDTXT*]
[*BEGINTXT*]
Win32DLL.Inc
#IF STRINGS UNICODE
   #include "C:\GoAsm\IncludeW\WINDOWS.inc"
   #include "C:\GoAsm\IncludeW\all_api.inc"
#ELSE
   #include "C:\GoAsm\IncludeA\WINDOWS.inc"
   #include "C:\GoAsm\IncludeA\all_api.inc"
#ENDIF
[*ENDTXT*]
[*BEGINTXT*]
Win32DLL.Def


[*ENDTXT*]
[*ENDPRO*]
