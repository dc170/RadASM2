''
'' Dialog Example, by fsw
''
'' compile with:	fbc -s gui dialog.rc dialog.bas
''
''
option explicit
option escape

#include once "windows.bi"
#include once "win/commdlg.bi"

#include "VideoPlayer.bi"
#include "..\..\Inc\RAVideo.Bi"

declare function DlgProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer

dim SHARED hInstance as HINSTANCE
dim hRAVideoDll as long

dim msg as MSG

'''
''' Program start
'''

	''
	'' Create the Dialog
	''
	hInstance=GetModuleHandle(NULL)
	hRAVideoDll=LoadLibrary("RAVideo.dll")
	if hRAVideoDll then
		CreateDialogParam(hInstance,IDD_MAIN,NULL,@DlgProc,NULL)
		do while GetMessage(@msg,NULL,0,0)
			TranslateMessage(@msg)
			DispatchMessage(@msg)
		loop
		FreeLibrary(hRAVideoDll)
	else
		MessageBox(NULL,StrPtr("Could not find RAVideo.dll"),StrPtr("FreeBASIC VideoPlayer"),MB_OK or MB_ICONERROR)
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
	dim ofn as OPENFILENAME
	dim rect as RECT
	dim FileName as zstring*260

	select case uMsg
		case WM_INITDIALOG
			'
		case WM_COMMAND
			select case wParam
				case IDM_FILE_OPEN
					ofn.lStructSize=sizeof(OPENFILENAME)
					ofn.hwndOwner=hDlg
					ofn.hInstance=hInstance
					ofn.lpstrFile=StrPtr(FileName)
					ofn.nMaxFile=260
					ofn.lpstrFilter=StrPtr("Video Files (*.avi, *.mpg, *.wmv)\0*.avi;*.mpg;*.wmv\0All Files (*.*)\0*.*\0\0")
					ofn.Flags=OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
					if GetOpenFileName(@ofn) then
						SendDlgItemMessage(hDlg,IDC_RAVID1,RAVID_PLAY,0,@FileName)
					endif
					'
				case IDM_FILE_CLOSE
					SendDlgItemMessage(hDlg,IDC_RAVID1,RAVID_STOP,0,0)
					'
				case IDM_FILE_EXIT
					SendMessage(hDlg,WM_CLOSE,0,0)
					'
			end select
		case WM_CLOSE
			DestroyWindow(hDlg)
			'
		case WM_DESTROY
			PostQuitMessage(0)
			'
		case WM_SIZE
			GetClientRect(hDlg,@rect)
			MoveWindow(GetDlgItem(hDlg,IDC_RAVID1),0,0,rect.right,rect.bottom,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function
