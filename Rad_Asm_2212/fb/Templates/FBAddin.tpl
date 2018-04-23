Win32 Dll
FBAddin
RadASM addin
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
1=4,O,GoRC /r,1
2=7,O,fbc -s gui -dll -export -x,7,2,4
3=
4=0,0,,5
5=
6=*.o,O,fbc -c,*.bas
7=0,0,"$E\Insight",5
11=4,O,GoRC /r,1
12=7,O,fbc -s gui -dll -export -g -x,7,2,4
13=
14=0,0,,5
15=
16=*.o,O,fbc -g -c,*.bas
17=0,0,"$E\Insight",5
[MakeFiles]
0=FBAddin.rap
1=FBAddin.rc
2=FBAddin.bas
3=FBAddin.obj
4=FBAddin.res
5=FBAddin.exe
6=FBAddin.def
7=FBAddin.dll
8=FBAddin.txt
9=FBAddin.lib
10=FBAddin.o
[Resource]
[StringTable]
[Accel]
[VerInf]
Nme=VERINF1
ID=1
FV=1.0.0.0
PV=1.0.0.0
VerOS=0x00000004
VerFT=0x00000002
VerLNG=0x00000409
VerCHS=0x000004E4
ProductVersion=1.0.0.0
ProductName=
OriginalFilename=
LegalTrademarks=
LegalCopyright=
InternalName=
FileDescription=RadASM addin
FileVersion=1.0.0.0
CompanyName=
[Group]
Group=Added files,Basic Source,Resources,Include
1=2
2=2
3=3
4=3
5=4
6=
[*ENDDEF*]
[*BEGINTXT*]
FBAddin.Bas

#include "FBAddin.bi"

function AddMenu
	dim nMnu as long
	dim hMnu as HMENU

	' Options menu
	nMnu=8
	' Adjust topmost popup if mdi child is maximized
	if lpData->fMaximized then
		nMnu=nMnu+1
	endif
	' Get handle of Option popup
	hMnu=GetSubMenu(lpHandles->hMenu,nMnu)
	' Add our menuitem
	AppendMenu(hMnu,MF_STRING,idaddin,@szFBAddin)

end function

' Returns info on what messages the addin hooks into (in an ADDINHOOKS structure).
function InstallDllEx CDECL alias "InstallDllEx" (byval hWin as HWND, byval fOptions as long,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT

	hInstance=hInst
	fopt=fOptions
	lpHandles=SendMessage(hWin,AIM_GETHANDLES,0,0)
	lpProcs=SendMessage(hWin,AIM_GETPROCS,0,0)
	lpData=SendMessage(hWin,AIM_GETDATA,0,0)
	idaddin=SendMessage(hWin,AIM_GETMENUID,0,0)
	call AddMenu
	hooks.fHook1=RAM_COMMAND or RAM_CLOSE
	hooks.fHook2=0
	hooks.fHook3=0
	return @hooks

end function

' Returns a pointer to 2 or more ADDINOPT structures
function GetOptions CDECL alias "GetOptions" () as ADDINOPT ptr EXPORT

	return @opt

end function

function DialogProc(byval hDlg as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as long

	select case uMsg
		case WM_INITDIALOG
			If fopt and 1 then
				' Show the OK button
				ShowWindow(GetDlgItem(hDlg,1),SW_SHOW)
			endif
		case WM_CLOSE
			EndDialog(hDlg,0)
		case else
			return FALSE
	end select
	return TRUE

end function

' RadASM calls this function for every addin message that this addin is hooked into.
function DllProc CDECL alias "DllProc" (byval hWin as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as long EXPORT

	select case uMsg
		case AIM_COMMAND
			If wParam=idaddin then
				' Show dialog
				DialogBoxParam(hInstance,1000,hWin,@DialogProc,0)
			endif
		case AIM_CLOSE
			' Remove the menu item
			DeleteMenu(lpHandles->hMenu,idaddin,MF_BYCOMMAND)
	end select
	return 0

end function

[*ENDTXT*]
[*BEGINTXT*]
FBAddin.Bi

#include once "windows.bi"
#include once "win/commctrl.bi"

#include "..\..\Inc\RadASM.bi"

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpProcs as ADDINPROCS ptr
dim SHARED lpData as ADDINDATA ptr
dim SHARED idaddin as long
CONST szFBAddin as string="FBAddin"
CONST szOpt1 as string="Show OK button"
dim SHARED opt as ADDINOPT=(@szOpt1,1,1)
dim SHARED opt1 as ADDINOPT=(0,0,0)
dim SHARED fopt as long
[*ENDTXT*]
[*BEGINTXT*]
FBAddin.Rc
#include "Res/FBAddinDlg.rc"
#include "Res/FBAddinVer.rc"
[*ENDTXT*]
[*BEGINBIN*]
FBAddin.dlg
6500000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F5FFFFFF00000000E90300000000000000000000
0000000000000000CA080AC90000900158044600000000005BE2410032044F00
000000000008C810000000000A0000000A0000002C010000C800000046424164
64696E0000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F444C4731000000000000000000000000000000000000000000000000000000
0000000000A2044600000000004B04FFFF580446000000000000000140000000
00C30000008D0000005E0000001F0000004F4B005F42544E0000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000400000004000000000000000100000049444F4B00544E31000000000000
0000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
Res\FBAddinDlg.Rc
#define IDD_DLG1 1000
#define IDOK 1
IDD_DLG1 DIALOGEX 6,6,196,107
CAPTION "FBAddin"
FONT 8,"MS Sans Serif",400,0
STYLE 0x10C80800
EXSTYLE 0x00000000
BEGIN
  CONTROL "OK",IDOK,"Button",NOT 0x10000000|0x40010000,130,86,62,19,0x00000000
END
[*ENDTXT*]
[*BEGINTXT*]
Res\FBAddinVer.rc
#define VERINF1 1
VERINF1 VERSIONINFO
FILEVERSION 1,0,0,0
PRODUCTVERSION 1,0,0,0
FILEOS 0x00000004
FILETYPE 0x00000002
BEGIN
  BLOCK "StringFileInfo"
  BEGIN
    BLOCK "040904E4"
    BEGIN
      VALUE "FileVersion", "1.0.0.0\0"
      VALUE "FileDescription", "RadASM addin\0"
      VALUE "ProductVersion", "1.0.0.0\0"
    END
  END
  BLOCK "VarFileInfo"
  BEGIN
    VALUE "Translation", 0x0409, 0x04E4
  END
END
[*ENDTXT*]
