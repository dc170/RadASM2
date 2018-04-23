Dos App
DosExe
DOS .exe file template
-
Eviloid, 2oo2
e-mail: eviloid@mail.ru
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,1,1,1,0,0
1=
2=3,O,$B\ML.EXE /DMASM /DDOS /Zm /c /nologo /I"$I",2
3=0,O,$B\doslnk.exe /NOLOGO,3,"|||||"
4=0,0,,5
5=
6=*.obj,O,$B\ML.EXE /DMASM /DDOS /Zm /c /nologo /I"$I",*.asm
7=0,0,$B\CV.EXE,5
11=
12=3,O,$B\ML.EXE /Zm /Zi /Zd /DMASM /DDOS /DDEBUG /c /nologo /I"$I",2
13=0,O,$B\doslnk.exe /NOLOGO /CODEVIEW /DEBUG,3,"|||||"
14=0,0,,5
15=
16=*.obj,O,$B\ML.EXE /Zm /Zi /Zd /DMASM /DDOS /DDEBUG /c /nologo /I"$I",*.asm
17=0,0,$B\CV.EXE,5
[AutoLoad]
1=1
[*ENDDEF*]
[*BEGINTXT*]
DosExe.Asm
; Template for DOS .exe file


        assume  cs:cseg, ds:dseg, ss:sseg

        ; code
cseg    segment
start:
        ; ... put your code here ...


        ; exit to DOS
        mov     ax, 4C00h
        int     21h

cseg    ends


        ; data
dseg    segment byte

        ; ...

dseg    ends


        ; stack
sseg    segment stack

        db      100h    dup(?)

sseg    ends
end start
[*ENDTXT*]
[*ENDPRO*]