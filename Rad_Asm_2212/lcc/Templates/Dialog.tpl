Win32 App
dialog
dialog app
-
cao_cong, 2005
e-mail: cao_cong_hx@yahoo.com.cn
[*BEGINPRO*]
[*BEGINDEF*]
[Resource]
1=IDI_ICON,10,2,Res\ICON.ICO
[StringTable]
[Accel]
[VerInf]
[Group]
Group=Added files,Assembly,Resources,Misc,Modules
1=2
2=2
3=3
4=3
[*ENDDEF*]
[*BEGINTXT*]
dialog.cpp
#include <windows.h>
BOOL DlgProc(HWND, UINT, WPARAM, LPARAM) ;

HINSTANCE hInst;

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,PSTR szCmdLine, int iCmdShow)
{
	hInst=hInstance;
	DialogBoxParam(hInstance,MAKEINTRESOURCE(1000),0,(DLGPROC)DlgProc,(1000));
	return TRUE;
}
BOOL DlgProc (HWND hWnd,UINT uMsg,WPARAM wParam,LPARAM lParam)
{
int lowID;
switch (uMsg){
	case WM_INITDIALOG:
		LoadIcon( hInst , MAKEINTRESOURCE(10));
		break;
	case WM_COMMAND:
		lowID=LOWORD(wParam);
		if (lowID==1001)
			SendMessage(hWnd,WM_CLOSE,0,0);
		break;
	case WM_CLOSE:
		EndDialog(hWnd,FALSE);
		break;
	default:
		return FALSE;
}
return TRUE;
}
[*ENDTXT*]
[*BEGINTXT*]
dialog.h
[*ENDTXT*]
[*BEGINTXT*]
dialog.Rc
#include "Res/dialogLng.rc"
#include "Res/dialogDlg.rc"
#include "Res/dialogRes.rc"
[*ENDTXT*]
[*BEGINBIN*]
dialog.dlg
6500000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000CBCECCE50000000000000000000000000000000000000000
000000000000000009000000F4FFFFFF00000000E90300000000000000000000
00000000000000009A0A0A9086009001B00410000000000027CC410098041500
000000000000CF10000000000A0000000A0000002C010000C80000004469616C
6F67000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F4449414C4F4700000000000000000000000000000000000000000000000000
00000000008A04180000000000AD03FFFFB00410000000000000000150000000
00630000005400000052000000220000004F4B005F42544E0000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000040000000400000000000000E903000049444F4B00544E31000000000000
0000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
dialog.Rc
#include "Res/dialogLng.rc"
#include "Res/dialogDlg.rc"
#include "Res/dialogRes.rc"
[*ENDTXT*]
[*BEGINTXT*]
Res\dialogDlg.Rc
#define IDD_DIALOG 1000
#define IDOK 1001
IDD_DIALOG DIALOGEX 6,6,194,110
CAPTION "Dialog"
FONT 8,"Tahoma",400,0
STYLE 0x10CF0000
EXSTYLE 0x00000000
BEGIN
  CONTROL "OK",IDOK,"Button",0x50010000,66,56,54,22,0x00000000
END
[*ENDTXT*]
[*BEGINTXT*]
Res\dialogLng.rc
LANGUAGE 4,2
[*ENDTXT*]
[*BEGINTXT*]
Res\dialogRes.rc
#define IDI_ICON			10
IDI_ICON		ICON      DISCARDABLE "Res/ICON.ICO"
[*ENDTXT*]
[*BEGINBIN*]
Res\ICON.ICO
0000010001002020100000000000E80200001600000028000000200000004000
0000010004000000000080020000000000000000000000000000000000000000
0000000080000080000000808000800000008000800080800000C0C0C0008080
80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000999999999999990000000000000000009
9999999999999990000000000000000999999999999999990000000000000009
9990000000099999000000000000000999900000000099999000000000000009
9990000000000999900000000000000999900000000009999000000000000009
9990000000000999900000000000000999900000000009999000000000000009
9990000000009999000000000000000999900000000999990000000000000009
9999999999999990000000000000000999999999999999000000000000000009
9999999999999990000000000000000999900000000999900000000000000009
9990000000009999000000000000000999900000000099990000000000000009
9990000000009999000000000000000999900000000099990000000000000009
9990000000099990000000000000000999999999999999900000000000000009
9999999999999900000000000000000999999999999900000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000FFFF
FFFFFFFFFFFFFFFFFFFFE0007FFFE0001FFFE0000FFFE1FE0FFFE1FF07FFE1FF
87FFE1FF87FFE1FF87FFE1FF87FFE1FF0FFFE1FE0FFFE0001FFFE0003FFFE000
1FFFE1FE1FFFE1FF0FFFE1FF0FFFE1FF0FFFE1FF0FFFE1FE1FFFE0001FFFE000
3FFFE000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
[*ENDBIN*]