Console App
hw
Hello World
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,1,1,1,0
1=4,O,nmake compilerc,
2=5,O,nmake buildall,
3=3,O,nmake build,
4=0,0,,5
5=0,O,nmake syntax,
6=
[MakeFiles]
0=hw.rap
1=hw.rc
2=hw.asm
3=hw.obj
4=hw.res
5=hw.exe
6=hw.def
7=hw.dll
8=hw.txt
9=hw.lib
10=hw.mak
11=hw.hla
12=hw
[Resource]
[StringTable]
[VerInf]
[*ENDDEF*]
[*BEGINTXT*]
hw.hla
program HelloWorld;

#include( "stdlib.hhf" )

begin HelloWorld;

	stdout.put( "Hello, World of Assembly Language", nl, nl );
	stdout.put( "Press enter to continue: " );
	stdin.readLn();

end HelloWorld;

[*ENDTXT*]
[*BEGINTXT*]
Makefile
build: [*PROJECTNAME*].obj

buildall: clean [*PROJECTNAME*].exe

compilerc: [*PROJECTNAME*].res

syntax:
	hla -s [*PROJECTNAME*].hla

clean:
	del *.exe
	del *.obj
	del *.res
	del *.link
	del *.asm
	del *.map

[*PROJECTNAME*].res: [*PROJECTNAME*].rc
	rc /v [*PROJECTNAME*].rc

[*PROJECTNAME*].obj: [*PROJECTNAME*].hla
	hla $(debug) -c [*PROJECTNAME*]

[*PROJECTNAME*].exe: [*PROJECTNAME*].hla
	hla $(debug) [*PROJECTNAME*]
[*ENDTXT*]
[*ENDPRO*]
