;This little stub makes it possible to use a 16 bit linker (or a batch file)
;with output to RadASM's output window on Win95, Win98 and Me.
;Copy LnkStub.exe to \masm32\bin
;Example link command:
;5,O,$B\LnkStub.exe $B\DOSLNK.EXE,3
.386
.model flat,stdcall
option casemap:none

include windows.inc

include kernel32.inc
include shlwapi.inc
include \masm32\m32lib\masm32.inc

includelib kernel32.lib
includelib shlwapi.lib
includelib \masm32\m32lib\masm32.lib

.data?

buffer	db MAX_PATH dup(?)
sinf	STARTUPINFO <>
pinf	PROCESS_INFORMATION <>

.code

start:

	invoke GetCommandLine
	invoke PathGetArgs,eax
	.if byte ptr [eax]
		invoke lstrcpy,addr buffer,eax
		invoke lstrlen,addr buffer
		mov		word ptr buffer[eax],';'
		mov		sinf.cb,sizeof STARTUPINFO
		invoke GetStartupInfo,addr sinf
		invoke CreateProcess,NULL,addr buffer,NULL,NULL,TRUE,NULL,NULL,NULL,addr sinf,addr pinf
		.if eax
			invoke WaitForSingleObject,pinf.hProcess,-1
			invoke CloseHandle,pinf.hProcess
			invoke CloseHandle,pinf.hThread
		.endif
	.endif
	invoke ExitProcess,0

end start
