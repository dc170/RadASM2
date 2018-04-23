''
'' This app demonstrates the use of breakpoints
'' WARNING:
'' Current RadASM window handle is compiled into the code.
'' Always recompile with breakpoints cleared before release.
''

option explicit

#include once "windows.bi"

#include "BreakPoint.bi"
' The following file must be included to make it possible to use breakpoints
#include "..\..\Inc\RADbg.bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	DialogBoxParam(GetModuleHandle(NULL), IDD_DLG1, NULL, @DlgProc, NULL)
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

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			' The following breakpoint has id as a variable to watch
			event=hiword(wParam)
			select case id
				case IDC_BTN1
					' Just to set an error
					GetWindowLong(-1,GWL_ID)
					' The following breakpoint will show last error
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
