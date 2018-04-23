Dos App
DosCom
DOS .com file template
-
Eviloid, 2oo2
e-mail: eviloid@mail.ru
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,1,1,1,1,0
1=
2=3,O,$B\ML.EXE /Zm /AT /DMASM /DDOS /c /nologo /I"$I",2
3=0,O,$B\doslnk.exe /NOLOGO /TINY,3,"|||||"
4=0,0,,12
5=
6=*.obj,O,$B\ML.EXE /Zm /AT /c /DMASM /DDOS /nologo /I"$I",*.asm
7=0,0,$B\CV.EXE,12
11=
12=3,O,$B\ML.EXE /Zi /Zd /Zm /AT /DMASM /DDOS /DDEBUG /c /nologo /I"$I",2
13=0,O,$B\doslnk.exe /NOLOGO /CODEVIEW /DEBUG /TINY,3,"|||||"
14=0,0,,12
15=
16=*.obj,O,$B\ML.EXE /Zi /Zd /Zm /AT /c /DMASM /DDOS /DDEBUG /nologo /I"$I",*.asm
17=0,0,$B\CV.EXE,12
[AutoLoad]
1=1
[*ENDDEF*]
[*BEGINTXT*]
DosCom.Asm
; Template for DOS .com file

.model tiny

        code    segment

        org     100h

start:

; ...Put your code here...

; exit to DOS
        mov     ax, 4c00h
        int     21h

        code    ends

end start
[*ENDTXT*]
[*ENDPRO*]
