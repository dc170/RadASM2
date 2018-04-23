MASM DOS Projects
-----------------

RadASM 2.0.3.2 includes the support for MASM users that want to code DOS applications.

If you have a former version of masm.ini, the implementation is described here.

In the [Project] section of masm.ini add the "Dos App" Types:
----------------------------------------------------------------------------------
Type=Win32 App,Console App,Dll Project,LIB Project,NMAKE Project,Win32 App (no res),Dos App,Dos App (.com)
----------------------------------------------------------------------------------

In the [MakeFiles] section add:
----------------------------------------------------------------------------------
12=.com
----------------------------------------------------------------------------------

And after the [Win32 App (no res)] section add the following one:
----------------------------------------------------------------------------------
[Dos App]
Files=1,0,0,0,0
Folders=1,0,0
MenuMake=0,1,1,1,1,1,0,0,0,0
1=
2=3,O,$B\ML.EXE /c /Cp /nologo /I"$I",2
3=5,O,$B\DOSLNK.EXE,3
4=0,0,,5
5=
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm 
7=0,0,$B\CV.EXE,5
11=
12=3,O,$B\ML.EXE /c /Cp /Zi /Zd /Zm /Fl /nologo /I"$I",2
13=5,O,$B\DOSLNK.EXE /CODEVIEW,3
14=0,0,,5
15=
16=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm 
17=0,0,$B\CV.EXE,5

[Dos App (.com)]
Files=1,0,0,0,0
Folders=1,0,0
MenuMake=0,1,1,1,1,1,0,0,0,0
1=
2=3,O,$B\ML.EXE /c /Cp /nologo /I"$I",2
3=12,O,$B\DOSLNK.EXE /TINY,3
4=0,0,,12
5=
6=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm 
7=0,0,$B\CV.EXE,12
11=
12=3,O,$B\ML.EXE /c /Cp /Zi /Zd /Zm /Fl /nologo /I"$I",2
13=12,O,$B\DOSLNK.EXE /TINY /CODEVIEW,3
14=0,0,,12
15=
16=*.obj,O,$B\ML.EXE /c /coff /Cp /nologo /I"$I",*.asm 
17=0,0,$B\CV.EXE,12
----------------------------------------------------------------------------------

The DOSLNK.EXE file is the Microsoft Linker version 5.60.339.

To debug your DOS projects you can use Microsoft CodeView.
Linker and debugger can be downloaded from the following link:

http://www.nuvisionmiami.com/books/asm/cv/cv41patch.exe

Extract the files in a temporary location and copy the following files to your MASM32\bin folder.

Filename       Version     Description
--------       -------     -----------
LINK.EXE       5.60.339    Linker *** (rename it to DOSLNK.EXE) ***
CVPACK.EXE     4.26.01     DOS CV4 information optimization utility
CV.EXE         4.10        MS-DOS CodeView debugger for MS-DOS
EED1CXX.DLL    4.10        Expression evaluator for MS-DOS C/C++
EMD1D1.DLL     4.10        Execution model for MS-DOS to MS-DOS
SHD1.DLL       4.10        Symbol handler for MS-DOS
TLD1LOC.DLL    4.10        Local transport layer for MS-DOS

If you're not interested in the debugger, you can download Linker and
CVPACK only from http://spiff.tripnet.se/~iczelion/files/Lnk563.exe
(extract the files, rename LINK.EXE to DOSLNK.EXE and put them in MASM32\bin folder).

 Cip

NOTE:

Win95, Win98 and Me users will have problems running 16 bit code with output to RadASM.

To solve this problem see the LnkStub project.

KetilO

