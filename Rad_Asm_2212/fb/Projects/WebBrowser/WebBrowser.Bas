''
'' compile with:	fbc -s gui WebBrowser.rc WebBrowser.bas
''

option explicit

#INCLUDE ONCE "windows.bi"

#define IDD_DLG1 1000
#define IDC_WBR1 1001
'### SEE - NOTE1: ###

'Browser messages:
#define WBM_NAVIGATE		WM_USER+100	'wParam=0, lParam=pointer to null terminated string
#define WBM_GOBACK		WM_USER+101	'wParam=0, lParam=0
#define WBM_GOFORWARD	WM_USER+102	'wParam=0, lParam=0

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	dim hLib as long
	dim msg as MSG
	''
	'' Load the custom control dll
	''
	hLib=LoadLibrary(StrPtr("WBDll.dll"))
	''
	'' Create the Dialog
	''
	CreateDialogParam(GetModuleHandle(NULL), IDD_DLG1, NULL, @DlgProc, NULL)
	do while GetMessage(@msg,NULL,0,0)
		TranslateMessage(@msg)
		DispatchMessage(@msg)
	loop
	''
	'' Program has ended
	''
	FreeLibrary(hLib)
	ExitProcess(0)
	end

'''
''' Program end
'''



function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim hWB as HWND
	dim rect as RECT

	select case uMsg
		case WM_INITDIALOG
			hWB=GetDlgItem(hDlg,IDC_WBR1)
			SendMessage(hWB,WBM_NAVIGATE,0,StrPtr("http://www.freebasic.net/forum/"))
			'
		case WM_SIZE
			GetClientRect(hDlg,@rect)
			hWB=GetDlgItem(hDlg,IDC_WBR1)
			MoveWindow(hWB,0,0,rect.right,rect.bottom,TRUE)
			'
		case WM_CLOSE
			DestroyWindow(hDlg)
			'
		case WM_DESTROY
			PostQuitMessage(0)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
