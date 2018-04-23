
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

