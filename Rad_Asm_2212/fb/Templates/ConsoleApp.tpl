Console App
ConsoleApp
Console Application
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0
1=4,O,GoRC /r,1
2=5,O,fbc -s console -x,5,2
3=
4=0,0,,5
5=
6=*.o,O,fbc -c,*.bas
7=0,0,"$E\Insight",5
11=4,O,GoRC /r,1
12=5,O,fbc -s console -g -x,5,2
13=
14=0,0,,5
15=
16=*.o,O,fbc -g -c,*.bas
17=0,0,"$E\Insight",5
[MakeFiles]
0=ConsoleApp.rap
1=ConsoleApp.rc
2=ConsoleApp.bas
3=ConsoleApp.obj
4=ConsoleApp.res
5=ConsoleApp.exe
6=ConsoleApp.def
7=ConsoleApp.dll
8=ConsoleApp.txt
10=ConsoleApp.o
[Resource]
[StringTable]
[Accel]
[VerInf]
[Group]
Group=Added files,Basic Source,Resources,Include
1=2
[*ENDDEF*]
[*BEGINTXT*]
ConsoleApp.Bas
''
'' hello world example
''

	oldcolor = color
	oldwidth = width

	width 80, 25
	
	view print 1 to 8
	color 0, 7
	cls

	view print 17 to 25
	color , 7
	cls

	locate 25,57
	print "press any key to exit...";
	

	view print 9 to 16
	color 7, 1
	cls
	
	locate 13, 40 - (len( "Welcome to freeBASIC!" ) \ 2)
	
	print "Welcome to ";
	color 15
	print "freeBASIC";
	color 7
	print "!"
	

	sleep
	clearkey$ = inkey
	
	width oldwidth and &HFFFF, oldwidth shr 16
	color oldcolor and &HFFFF, oldcolor shr 16
	view print 1 to oldwidth shr 16
	cls
[*ENDTXT*]
[*ENDPRO*]
