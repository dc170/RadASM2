''
'' RaGrid example with: Accelerator, Resource, Menu,  
''
option explicit
option escape

#INCLUDE ONCE "windows.bi"

#include "spr.bi"
#include "..\..\Inc\SpreadSheet.bi"

Dim Shared hInst AS LONG
Dim Shared hWnd as HWND
Dim Shared Grid1 AS LONG
Dim hlib as long
Dim msg as MSG


Sub Grid_Setup(byval hDlg as long)
	Dim gfmt AS GLOBAL
	Dim spri AS SPR_ITEM
	dim nnum as integer 
	
	Grid1=GetDlgItem(hDlg,IDC_SPR1)
	
	SendMessage(Grid1,SPRM_SETROWCOUNT,2,0)
	SendMessage(Grid1,SPRM_SETCOLCOUNT,2,0)
	
	spri.flag=  SPRIF_TEXTALIGN or SPRIF_DATA or SPRIF_WIDTH or SPRIF_HEIGHT
	spri.col=1
	spri.row=0
	spri.fmt.txtal=FMTA_CENTER or FMTA_MIDDLE
	spri.wt=200
	spri.ht=25
	spri.lpdta=strptr(" Col1 ")
	SendMessage(Grid1,SPRM_SETCELLDATA,0,@spri)

	nnum=-12
	spri.flag=  SPRIF_TEXTALIGN or SPRIF_DATA or SPRIF_TYPE
	spri.col=1
	spri.row=1
	spri.fmt.txtal=FMTA_RIGHT or FMTA_MIDDLE
	spri.fmt.tpe=TPE_INTEGER
	spri.lpdta=@nnum
	SendMessage(Grid1,SPRM_SETCELLDATA,0,@spri)

	spri.col=1
	spri.row=2
	spri.fmt.txtal=FMTA_LEFT or FMTA_MIDDLE
	spri.fmt.tpe=TPE_TEXT
	spri.lpdta=strptr("Hello")
	SendMessage(Grid1,SPRM_SETCELLDATA,0,@spri)

End Sub

''' Start DlgProc
function DlgProc(byval hDlg as long, byval uMsg as long, byval wParam as long, byval lParam as long) as integer
	dim as long id, event, x, y
	dim rect as RECT
	dim temp as string
	
	select case uMsg
		case WM_INITDIALOG
			Grid_Setup(hDlg)
			'
		case WM_CLOSE
			DestroyWindow(hDlg)
			'
		case WM_DESTROY
			PostQuitMessage(0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			'select case id
					'
					'
			'end select
		case WM_SIZE
			GetClientRect(hDlg,@rect)
			x=rect.left
			y=rect.top
			MoveWindow(grid1,x,y,rect.Right,rect.Bottom-25,TRUE)
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function

''' end DlgProc


'''
''' Program start
'''

	hInst=GetModuleHandle(NULL)
	
	hLib=LoadLibrary("SprSht.dll")
	
	if hLib Then 
		'' Create the Dialog
		hWnd=CreateDialogParam(hInst,byval IDD_DLG1, NULL, @DlgProc, NULL)
			do while GetMessage(@msg,NULL,0,0)
				TranslateMessage(@msg)
				DispatchMessage(@msg)
			loop
	else 
		MessageBox(NULL,StrPtr("Could not find sprsht.dll"),StrPtr("SpreadSheet control"),MB_OK or MB_ICONERROR)
	endif


	''
	'' Program has ended
	''
	ExitProcess(0)
	end

'''
''' Program end
'''