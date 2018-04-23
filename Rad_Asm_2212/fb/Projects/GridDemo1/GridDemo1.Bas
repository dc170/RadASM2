''
'' RAGrid demo
'' -----------
'' To be able to run this demo you must copy RAGrid.dll to the project folder or to C:\Windows\System
''
''
option explicit

#include once "windows.bi"

#include "GridDemo1.bi"
#include "..\..\Inc\RAGrid.bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hLib=LoadLibrary(StrPtr("RAGrid.dll"))
	if hLib then
		DialogBoxParam(GetModuleHandle(NULL), IDD_DLG1, NULL, @DlgProc, NULL)
		FreeLibrary(hLib)
	endif
	''
	'' Program has ended
	''
	ExitProcess(0)
	end

'''
''' Program end
'''
function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event, x, y
	dim hBtn as HWND
	dim rect as RECT
	dim col as COLUMN
	dim lpGRIDNOTIFY as GRIDNOTIFY PTR

	select case uMsg
		case WM_INITDIALOG
			hGrd=GetDlgItem(hDlg,IDC_GRD1)
			SendMessage(hGrd,GM_SETBACKCOLOR,&HC0FFFF,0)
			SendMessage(hGrd,GM_SETGRIDCOLOR,&H808080,0)
			SendMessage(hGrd,GM_SETTEXTCOLOR,&H800000,0)
			' Add Name column
			col.colwt=150
			col.lpszhdrtext=StrPtr("Name")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_EDITTEXT
			col.ctextmax=31
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,@col)
			' Add Address column
			col.colwt=150
			col.lpszhdrtext=StrPtr("Address")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_EDITTEXT
			col.ctextmax=31
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,@col)
			' Add Points column
			col.colwt=50
			col.lpszhdrtext=StrPtr("Points")
			col.halign=GA_ALIGN_RIGHT
			col.calign=GA_ALIGN_RIGHT
			col.ctype=TYPE_EDITLONG
			col.ctextmax=4
			col.lpszformat=0
			col.himl=0
			col.hdrflag=0
			SendMessage(hGrd,GM_ADDCOL,0,@col)
			' Button column
			col.colwt=60
			col.lpszhdrtext=StrPtr("Button")
			col.halign=GA_ALIGN_LEFT
			col.calign=GA_ALIGN_LEFT
			col.ctype=TYPE_BUTTON
			col.ctextmax=MAX_PATH
			col.lpszformat=0
			col.himl=0
			SendMessage(hGrd,GM_ADDCOL,0,@col)
			' Add some rowdata
			SendMessage(hGrd,GM_ADDROW,0,@rdta1)
			SendMessage(hGrd,GM_ADDROW,0,@rdta2)
			SendMessage(hGrd,GM_ADDROW,0,@rdta3)
			SendMessage(hGrd,GM_ADDROW,0,@rdta4)
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
			MoveWindow(hBtn,rect.right-100,rect.bottom-35,97,31,TRUE)
			MoveWindow(hGrd,0,0,rect.right,rect.bottom-40,TRUE)
			'
		case WM_NOTIFY
			lpGRIDNOTIFY=lParam
			if lpGRIDNOTIFY->nmhdr.hwndFrom=hGrd then
				if lpGRIDNOTIFY->nmhdr.code=GN_BUTTONCLICK then
					MessageBox(hDlg,"Button clicked","RAGrid Demo",MB_OK)
				endif
			endif
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
