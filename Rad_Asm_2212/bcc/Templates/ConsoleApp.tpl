Console App
TestCon
Console application
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
1=4,O,$D\RC /v,1
2=3,O,$B\BCC32 /c /I"$I" /L"$L",2
3=5,O,$B\ILINK32.EXE /ap /c /x /Gn /Tpe /L"$L" $3 $A\Lib\c0x32.obj|$5||import32.lib cw32.lib||
4=0,0,,5
5=
6=
7=0,0,"$E\OllyDbg",5
11=4,O,$D\RC /v,1
12=3,O,$B\BCC32 /c /I"$I" /L"$L",2
13=5,O,$B\ILINK32.EXE /ap /c /x /Gn /Tpe /L"$L" $3 $A\Lib\c0x32.obj|$5||import32.lib cw32.lib||
14=0,0,,5
15=
16=
17=0,0,"$E\OllyDbg",5
[MakeFiles]
0=TestCon.rap
1=TestCon.rc
2=TestCon.cpp
3=TestCon.obj
4=TestCon.res
5=TestCon.exe
6=TestCon.def
7=TestCon.dll
8=TestCon.txt
9=TestCon.lib
10=TestCon.mak
11=TestCon.c
12=TestCon.com
13=TestCon.ocx
14=TestCon.idl
15=TestCon.tlb
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
TestCon.cpp

#include <stdio.h>
#include "windows.h"
#include "TestCon.h"

int main(void)
{
static TCHAR szText[]=TEXT("HelloWin");

	printf("%s\n",szText);
	gets(szText);
	return 0;
}

[*ENDTXT*]
[*BEGINTXT*]
TestCon.h
[*ENDTXT*]
[*ENDPRO*]
