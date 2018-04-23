Dialog App
tstdialog
Dialog application
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0
1=4,O,nmake compilerc,
2=5,O,nmake buildall,
3=3,O,nmake build,
4=0,0,,5
5=0,O,nmake syntax,
6=
11=4,O,nmake dbg_compilerc,
12=5,O,nmake dbg_buildall,
13=3,O,nmake dbg_build,
14=0,0,,5
15=0,O,nmake dbg_syntax,
16=
7=
[MakeFiles]
0=tstdialog.rap
1=tstdialog.rc
2=tstdialog.asm
3=tstdialog.obj
4=tstdialog.res
5=tstdialog.exe
6=tstdialog.def
7=tstdialog.dll
8=tstdialog.txt
9=tstdialog.lib
10=tstdialog.mak
11=tstdialog.hla
[Resource]
[StringTable]
[Accel]
[VerInf]
[Group]
Group=Added files,Assembly,Resources,Misc,Modules
1=2
2=3
3=3
4=4
[*ENDDEF*]
[*BEGINTXT*]
tstdialog.hla

program Dialog;

#include ("w.hhf")

const

	IDD_DLG01		:= 2000;
	IDC_BTNEXIT		:= 2001;

// Include this file to use source code breakpoints.
#include ("\RadASM\Hla\Inc\RADbg.inc")
// If you prefer using int 3 and a debugger, then open RadASM.ini and change:
// [Addins]
// XX=RADbg.dll,0
// to:
// XX=RADbg.dll,1
//
// Note: Breakpoints does not work if you build to console.
//
#asm
	includelib \masm32\lib\comctl32.lib
#endasm

//Just to test structure code complete
type

	POINT :record
		x:int32;
		y:int32;
	endrecord;

static 
	hInstance	: dword;
	//Just to test structure code complete
	pt			:POINT;

procedure DialogProc( lParam : dword ; wParam : dword; uMsg : dword; hwnd : dword );
	@nodisplay;

begin DialogProc;

	if ( uMsg = w.WM_CLOSE ) then

		w.EndDialog ( hwnd, 0 );

	elseif ( uMsg = w.WM_COMMAND ) then

		if ( wParam = IDC_BTNEXIT ) then

			w.SendMessage (hwnd, w.WM_CLOSE, 0, 0);

		endif;

	else

		mov ( 0 , eax );
		exit DialogProc;

	endif;

	mov ( 1, eax );

end DialogProc;

begin Dialog;

	w.InitCommonControls ();
	w.GetModuleHandle ( 0 );
	mov ( eax , hInstance );
	w.DialogBoxParam ( eax ,IDD_DLG01 , 0 , &DialogProc , 0 );
	w.ExitProcess ( 0 );

end Dialog;
[*ENDTXT*]
[*BEGINTXT*]
tstdialog.rc
#include "Res/tstdialogDlg.rc"
[*ENDTXT*]
[*BEGINBIN*]
tstdialog.dlg
6500000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F5FFFFFF00000000D10700000000000000000000
0000000000000000080F000000000000DC0800000100000037934100C4080000
000000008008CC10010000000A0000000A0000002C010000C8000000484C4120
5465737400000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000D0070000494444
5F444C4730310000000000000000000000000000000000000000000000000000
00000000008003000000000000F0904180DC0800000000000000000150000000
0090000000720000007C000000220000004578697400544E0000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000040000000400000000000000D10700004944435F42544E45584954000000
0000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*BEGINTXT*]
Makefile
build: tstdialog.obj

buildall: clean tstdialog.res tstdialog.exe

compilerc: tstdialog.res

syntax:
	hla -s tstdialog.hla

clean:
	del /F /Q tmp
	del *.exe
	del *.obj
	del *.res
	del *.link
	del *.asm
	del *.map

tstdialog.res: tstdialog.rc
	rc /v tstdialog.rc

tstdialog.obj: tstdialog.hla
	hla $(debug) -w -c tstdialog

tstdialog.exe: tstdialog.hla
	hla $(debug) -w -v tstdialog tstdialog.res
[*ENDTXT*]
[*ENDPRO*]
[*BEGINTXT*]
Res\tstdialogDlg.Rc
#define IDD_DLG01 2000
#define IDC_BTNEXIT 2001
IDD_DLG01 DIALOGEX 6,6,194,106
CAPTION "HLA Test"
FONT 8,"MS Sans Serif"
STYLE 0x10CC0880
EXSTYLE 0x00000001
BEGIN
  CONTROL "Exit",IDC_BTNEXIT,"Button",NOT 0x00820000|0x50010000,96,70,82,20,0x00000000
END
[*ENDTXT*]
