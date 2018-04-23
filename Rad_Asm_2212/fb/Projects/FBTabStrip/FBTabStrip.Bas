''
'' Dialog Example, by fsw
''
'' compile with:	fbc -s gui FBTabStrip.rc FBTabStrip.bas
''
''
option explicit

#include once "windows.bi"
#include once "win/commctrl.bi"

#include "FBTabStrip.bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

dim SHARED hInstance as HINSTANCE
dim SHARED hTab as HWND
dim SHARED hTabDlg1 as HWND
dim SHARED hTabDlg2 as HWND

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	InitCommonControls
	DialogBoxParam(hInstance, IDD_DLG0, NULL, @DlgProc, NULL)
	''
	'' Program has ended
	''
	ExitProcess(0)
	end

'''
''' Program end
'''

function Tab1Proc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

	return FALSE

end function

function Tab2Proc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

	return FALSE

end function


function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event, x, y
	dim hBtn as HWND
	dim rect as RECT
	dim ts as TCITEM
	dim lpNMHDR as NMHDR PTR

	select case uMsg
		case WM_INITDIALOG
			hTab=GetDlgItem(hDlg,IDC_TAB1)
			ts.mask=TCIF_TEXT
			ts.pszText=StrPtr("Tab1")
			SendMessage(hTab,TCM_INSERTITEM,0,@ts)
			ts.pszText=StrPtr("Tab2")
			SendMessage(hTab,TCM_INSERTITEM,1,@ts)
			'Create the tab dialogs
			hTabDlg1=CreateDialogParam(hInstance,IDD_TAB1,hTab,@Tab1Proc,0)
		 	hTabDlg2=CreateDialogParam(hInstance,IDD_TAB2,hTab,@Tab2Proc,0)
			'
		case WM_NOTIFY
			lpNMHDR=lParam
			if lpNMHDR->code=TCN_SELCHANGE then
				'A tab selection is made
				id=SendMessage(hTab,TCM_GETCURSEL,0,0)
				select case id
					case 0
						ShowWindow(hTabDlg2,SW_HIDE)
						ShowWindow(hTabDlg1,SW_SHOWDEFAULT)
					case 1
						ShowWindow(hTabDlg1,SW_HIDE)
						ShowWindow(hTabDlg2,SW_SHOWDEFAULT)
				end select
			endif
			'
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					EndDialog(hDlg, 0)
					'
			end select
		case WM_SIZE
			GetClientRect(hDlg,@rect)
			hBtn=GetDlgItem(hDlg,IDC_BTN1)
			x=rect.right-100
			y=rect.bottom-35
			MoveWindow(hBtn,x,y,97,31,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
