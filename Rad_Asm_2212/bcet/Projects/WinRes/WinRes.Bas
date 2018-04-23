DEFLNG A-Z ' best to use this for all 32-bit programs

' This sample is written in a 'Mixed Source Mode'.  I use QBX as an editor,
'  and some of the odd things are just so that QBX doesn't complain.

' Because QBX doesn't like underlines, a lot of the GUI constants have been
'  changed to get rid of them.  BCET doesn't care.

REM $Option: Explicit
REM $Option: WinGUI

REM $INCLUDE: 'WinRes.Dec'

REM $INCLUDE: 'WinRes.Bi'

REM $INCLUDE: 'MessBox.Con'
REM $INCLUDE: 'FrmtMess.Con'



' global data

DIM SHARED szClassName     AS STRING
DIM SHARED szDisplayName   AS STRING
DIM SHARED szClassEdit     AS STRING
DIM SHARED hwnd            AS LONG
DIM SHARED hedt            AS LONG
DIM SHARED hInstance       AS LONG

' init global strings

szClassName = "Generic_Class"
szDisplayName = "Generic"
szClassEdit = "Edit"

' local stuff

CONST SwSHOWDEFAULT = 10

DIM Rc, rct AS RECT

' this code mimics what the C startup code does prior to calling WinMain

	hInstance = GetModuleHandle("") ' provides the instance handle
	IF hInstance = 0 THEN Zap GetLastError, "GetModuleHandle"

	Rc = WinMain(hInstance, 0, COMMAND$, SwSHOWDEFAULT)

	SYSTEM Rc           ' cleanup & return to operating system

FUNCTION WinMain (BYVAL hInstance AS LONG, BYVAL hPrevInst AS LONG, CmdLine AS STRING, BYVAL CmdShow AS LONG)

CONST csVREDRAW = 1
CONST csHREDRAW = 2
CONST csBYTEALIGNWINDOW = 8192

CONST ColorBTNSHADOW = 16

CONST SmCXSCREEN = 0
CONST SmCYSCREEN = 1

CONST SwSHOWNORMAL = 1

CONST WsExOVERLAPPEDWINDOW = &H300
CONST WsOVERLAPPEDWINDOW = &HCF0000

DIM Wwd, Wht, Wtx, Wty, Rc, ClassAtom

'  ==================================================
'  Fill WNDCLASSEX structure with required variables
'  ==================================================

DIM wc AS WNDCLASSEX

	wc.cbSize = LEN(wc)
	wc.style = csHREDRAW OR csVREDRAW OR csBYTEALIGNWINDOW
REM $Process: wc.lpfnWndProc = SEG(WndProc)        ' address of WndProc
	wc.cbClsExtra = 0
	wc.cbWndExtra = 0
	wc.hInstance = hInstance                        ' instance handle
	wc.hbrBackground = 0'ColorBTNSHADOW               ' system color
	wc.lpszMenuName = 0
	wc.lpszClassName = SSEGADD(szClassName)         ' window class name
	wc.hIcon = LoadIcon(hInstance, 500)             ' icon ID   ; resource icon
	IF wc.hIcon = 0 THEN Zap GetLastError, "LoadIcon"

	wc.hCursor = LoadCursor(0, IdcArrow)            ' system cursor
	IF wc.hCursor = 0 THEN Zap GetLastError, "LoadCursor"

	wc.hIconSm = 0

	ClassAtom = RegisterClassEx(wc)                        ' register the window class
	IF ClassAtom = 0 THEN Zap GetLastError, "RegisterClassEx"

'  ===============================
'  Centre window at following size
'  ===============================

	Wwd = 500
	Wht = 350

	Rc = GetSystemMetrics(SmCXSCREEN)   ' get screen width in pixels
	IF Rc = 0 THEN Zap GetLastError, "GetSystemMetrics"
	Wtx = (Rc \ 2) - (Wwd \ 2)

	Rc = GetSystemMetrics(SmCYSCREEN)   ' get screen height in pixels
	IF Rc = 0 THEN Zap GetLastError, "GetSystemMetrics"
	Wty = (Rc \ 2) - (Wht \ 2)

'  ==================================
'  Create the main application window
'  ==================================

' this form works also
'' hwnd = CreateWindowEx(WsExOVERLAPPEDWINDOW, ClassAtom, szDisplayName, WsOVERLAPPEDWINDOW, Wtx, Wty, Wwd, Wht, 0, 0, hInstance, 0)

	hwnd = CreateWindowEx(WsExOVERLAPPEDWINDOW, szClassName, szDisplayName, WsOVERLAPPEDWINDOW, Wtx, Wty, Wwd, Wht, 0, 0, hInstance, 0)
	IF hwnd = 0 THEN Zap GetLastError, "CreateWindowEx"


	Rc = LoadMenu(hInstance, 600)                   ' load resource menu
	IF Rc = 0 THEN Zap GetLastError, "LoadMenu"

	Rc = SetMenu(hwnd, Rc)                          ' set it to main window
	IF Rc = 0 THEN Zap GetLastError, "SetMenu"

	Rc = ShowWindow(hwnd, SwSHOWNORMAL)             ' display the window
	Rc = UpdateWindow(hwnd)                         ' update the display
	IF Rc = 0 THEN Zap GetLastError, "UpdateWindow"

'  ==================================
'  Loop until PostQuitMessage is sent
'  ==================================

DIM mesg AS MSG

	DO
		Rc = GetMessage(mesg, 0, 0, 0)               ' get each message
		IF Rc = 0 THEN EXIT DO                       ' the CORRECT exit code
		IF Rc = -1 THEN Zap GetLastError, "GetMessage"

		Rc = TranslateMessage(mesg)                  ' translate it
		Rc = DispatchMessage(mesg)                   ' send it to message proc
	LOOP

	WinMain = mesg.wParam

END FUNCTION

			  ' These have to be back asswards because BCET can't (Yet) create a StdCall routine
REM $Ignore: 1
FUNCTION WndProc (BYVAL lParam AS LONG, BYVAL wParam AS LONG, BYVAL uMsg AS LONG, BYVAL hWin AS LONG)
REM $Process: FUNCTION WndProc StdCall (BYVAL hWin AS LONG, BYVAL uMsg AS LONG, BYVAL wParam AS LONG, BYVAL lParam AS LONG)

CONST WmSYSCOMMAND = 274
CONST ScCLOSE = 61536
CONST WsCHILD = &H40000000
CONST WsVISIBLE = &H10000000
CONST WmSIZE = 5

' -------------------------------------------------------------------------
' Message are sent by the operating system to an application through the
' WndProc proc. Each message can have additional values associated with it
' in the two parameters, wParam & lParam. The range of additional data that
' can be passed to an application is determined by the message.
' -------------------------------------------------------------------------

DIM Rc, rect AS RECT

	SELECT CASE uMsg

'  ----------------------------------------------------------------------
'  The WM_COMMAND message is sent by menus, buttons and toolbar buttons.
'  Processing the wParam parameter of it is the method of obtaining the
'  control's ID number so that the code for each operation can be
'  processed. NOTE that the ID number is in the LOWORD of the wParam
'  passed with the WM_COMMAND message. There may be some instances where
'  an application needs to seperate the high and low words of wParam.
'  ---------------------------------------------------------------------
	CASE WmCommand                '    .if uMsg == WM_COMMAND

'  ======== menu commands ========

		SELECT CASE wParam
		CASE 1000                  '        .if wParam == 1000
			Rc = SendMessage(hWin, WmSYSCOMMAND, ScCLOSE, 0)
			Rc = 0

		CASE 1900                  '        .elseif wParam == 1900
			Rc = MessageBox(hWin, "GUI from BCET Basic", szDisplayName, MbOK)
			IF Rc = 0 THEN Zap GetLastError, "MessageBox"
			Rc = 0

		CASE ELSE
			GOTO WndProcCaseElse
		END SELECT                 '        .endif
'  ====== end menu commands ======

'  --------------------------------------------------------------------
'  This message is sent to WndProc during the CreateWindowEx function
'  call and is processed before it returns. This is used as a position
'  to start other items such as controls. IMPORTANT, the handle for the
'  CreateWindowEx call in the WinMain does not yet exist so the HANDLE
'  passed to the WndProc [ hWin ] must be used here for any controls
'  or child windows.
'  --------------------------------------------------------------------
	CASE WmCreate                 '    .elseif uMsg == WM_CREATE
		hedt = CreateWindowEx(0,szClassEdit,szDisplayName,WsCHILD + WsVISIBLE,0,0,0,0,hWin,0,hInstance,0)

		Rc = 0 ' create the window


'  -------------------------------------------------------------------
'  This is the place where various requirements are performed before
'  the application exits to the operating system such as deleting
'  resources and testing if files have been saved. You have the option
'  of returning ZERO if you don't wish the application to close which
'  exits the WndProc procedure without passing this message to the
'  default window processing done by the operating system.
'  -------------------------------------------------------------------
	CASE WmSIZE                 '    .elseif uMsg == WM_SIZE
		Rc = GetClientRect(hWin,rect)
		Rc = MoveWindow(hedt,0,0,rect.right,rect.bottom,TRUE)

	CASE WmClose                  '    .elseif uMsg == WM_CLOSE
		Rc = MessageBox(hWin, "Please Confirm Exit", szDisplayName, MbYesNo)
		IF Rc = 0 THEN Zap GetLastError, "MessageBox"
		IF Rc <> IdNo GOTO WndProcCaseElse
		Rc = 0 ' close the window
		
'  ----------------------------------------------------------------
'  This message MUST be processed to cleanly exit the application.
'  Calling the PostQuitMessage() function makes the GetMessage()
'  function in the WinMain() main loop return ZERO which exits the
'  application correctly. If this message is not processed properly
'  the window disappears but the code is left in memory.
'  ----------------------------------------------------------------
	CASE WmDestroy                '    .elseif uMsg == WM_DESTROY
		PostQuitMessage(0)
		Rc = 0 ' destroy the window
		  
'  --------------------------------------------------------------------
'  Default window processing is done by the operating system for any
'  message that is not processed by the application in the WndProc
'  procedure. If the application requires other than default processing
'  it executes the code when the message is trapped and returns ZERO
'  to exit the WndProc procedure before the default window processing
'  occurs with the call to DefWindowProc().
'  --------------------------------------------------------------------
	CASE ELSE                     '    .endif
WndProcCaseElse:
		Rc = DefWindowProc(hWin, uMsg, wParam, lParam)

		GOTO WndProcExit
	
	END SELECT

WndProcExit:
	WndProc = Rc

END FUNCTION

SUB Zap (BYVAL Ec AS LONG, API AS STRING)

DIM Mb AS STRING, Lp, I, Rc

	Mb = SPACE$(513)
	Lp = FormatMessage(FormatMessageFromSystem, 0, Ec, 0, Mb, 512, 0)
	IF Lp = 0 THEN STOP 255

	Mb = LEFT$(Mb, Lp)

	Mb = "windowsAPI: " + API + CHR$(13) + CHR$(10) + Mb + CHR$(13) + CHR$(10)

	Rc = MessageBox(0, Mb, "Ouch!", MbOK)
	SYSTEM 999


END SUB

