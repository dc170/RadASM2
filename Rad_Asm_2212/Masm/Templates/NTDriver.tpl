Driver (.sys)
Driver
Bare bone nt driver
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /nologo /c /coff /I"$I",2
3=16,O,$B\LINK.EXE /nologo /driver /base:0x10000 /align:32 /subsystem:native /out:"$16",3
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\ML.EXE /c /coff /nologo /I"$I",*.asm
7=0,0,"$E\OllyDbg",5
[MakeFiles]
0=Driver.rap
1=Driver.rc
2=Driver.asm
3=Driver.obj
4=Driver.res
5=Driver.exe
6=Driver.def
7=Driver.dll
8=Driver.txt
9=Driver.lib
10=Driver.mak
11=Driver.hla
12=Driver.com
13=Driver.ocx
14=Driver.idl
15=Driver.tlb
16=Driver.sys
[Resource]
[StringTable]
[Accel]
[VerInf]
[Group]
Group=Added files,Assembly,Resources,Misc,Modules
1=2
2=2
[*ENDDEF*]
[*BEGINTXT*]
Driver.Asm
.386
.model flat, stdcall
option casemap:none

include driver.inc

.code

DriverEntry proc pDriverObject:PDRIVER_OBJECT,pusRegistryPath:PUNICODE_STRING

    ;your code goes here
    ret

DriverEntry endp

end DriverEntry
[*ENDTXT*]
[*BEGINTXT*]
Driver.Inc

include w2k\ntstatus.inc
include w2k\ntddk.inc

[*ENDTXT*]
[*ENDPRO*]
