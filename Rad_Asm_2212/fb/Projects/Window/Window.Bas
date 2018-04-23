Option Explicit

#include "windows.bi"

Declare Function WndProc (ByVal hWnd As HWND, ByVal message As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As uInteger

Dim wMsg as MSG
Dim wCls as WNDCLASS
Dim hWnd as HWND
Dim hInstance As HINSTANCE

' This identifies this program
hInstance = GetModuleHandle(Null)

'----------------------------

' Register the class
With wcls
	 .style			 = CS_HREDRAW or CS_VREDRAW				  ' Style
	 .lpfnWndProc	 = @WndProc										  ' Wndproc (see below)
	 .cbClsExtra	 = 0												  ' Amount of extra info in here
	 .cbWndExtra	 = 0												  ' Amount of extra info in the "instance"
	 .hInstance		 = hInstance									  ' The "instance", our .exe id
	 .hIcon			 = LoadIcon(NULL, ByVal IDI_APPLICATION) ' The icon
	 .hCursor		 = LoadCursor(NULL, ByVal IDC_ARROW)	  ' The cursor
	 .hbrBackground = GetStockObject(WHITE_BRUSH)			  ' The background
	 .lpszMenuName  = NULL											  ' Menu resource name
	 .lpszClassName = StrPtr("HelloWorld")						  ' Identifying class name
End With

If RegisterClass(@wCls) = False Then
	 MessageBox(NULL, "This program requires Windows NT!", "Error!", MB_ICONERROR)
	 End

endif

'--------------------------------

' Create and show the window
hWnd = CreateWindowEx(				_
	 0,									_ ' Extra style info
	 StrPtr("HelloWorld"),			_ ' The "class name"
	 StrPtr("The Hello Program"), _ ' The window title
	 WS_OVERLAPPEDWINDOW,			_ ' The style
	 CW_USEDEFAULT,					_ ' x position
	 CW_USEDEFAULT,					_ ' y position
	 CW_USEDEFAULT,					_ ' Width
	 CW_USEDEFAULT,					_ ' Height
	 NULL,								_ ' Parent window
	 NULL,								_ ' Menu
	 hInstance,							_ ' Module (your .exe id)
	 NULL									_ ' A structure you can pass to WndProc
)

ShowWindow(hWnd, SW_NORMAL)
UpdateWindow(hWnd)

'--------------------------------

' Run the message loop
While GetMessage(@wMsg, NULL, NULL, NULL) <> False
	 TranslateMessage(@wMsg)
	 DispatchMessage(@wMsg)
Wend

'--------------------------------

' WndProc - Windows calls this whenever *anything* happens
Function WndProc (ByVal hWnd As HWND, ByVal message As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As uInteger
	 Dim rct as RECT
	 Dim pnt as PAINTSTRUCT
	 Dim hDC as HDC

	 Select Case As Const message
		  ' The window is loaded
		  Case WM_CREATE
				Return

		  ' The window is pained
		  Case WM_PAINT
				hDC = BeginPaint(hWnd, @pnt)
				GetClientRect(hWnd, @rct)

				DrawText(hDC,"Hello Windows from FreeBasic!", -1, _
							@rct, DT_SINGLELINE or DT_CENTER or DT_VCENTER)

				EndPaint(hWnd, @pnt)
				Return

		  ' There is a keypress
		  Case WM_KEYDOWN
			  If LoByte(wParam) = 27 Then
				PostMessage(hWnd, WM_CLOSE, 0, 0)
			endif
				Return

		  ' The window is closing
		  Case WM_DESTROY
				PostQuitMessage(0)
				Return
	 End Select

	 ' This defaults any messages we don't care about
	 Return DefWindowProc(hWnd, message, wParam, lParam)
End Function
