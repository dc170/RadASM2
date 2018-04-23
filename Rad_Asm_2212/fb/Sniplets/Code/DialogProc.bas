function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case IDCANCEL
					EndDialog(hDlg, 0)
					'
			end select
		case WM_SIZE
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
