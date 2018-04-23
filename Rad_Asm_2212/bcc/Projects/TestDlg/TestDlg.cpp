#include <windows.h>
BOOL DlgProc(HWND, UINT, WPARAM, LPARAM) ;

HINSTANCE hInst;
HICON hIcon;

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
		hIcon=LoadIcon( hInst , MAKEINTRESOURCE(10));
		SendMessage(hWnd,WM_SETICON,ICON_SMALL,(LPARAM) (HICON) hIcon);
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
