
TYPE POINTAPI
x AS LONG
y AS LONG
END TYPE

TYPE MSG
hwnd     AS LONG
message  AS LONG
wParam   AS LONG
lParam   AS LONG
time     AS LONG
pt       AS POINTAPI
END TYPE

TYPE WNDCLASSEX
cbSize         AS LONG
style          AS LONG
lpfnwndproc    AS LONG
cbClsExtra     AS LONG
cbWndExtra     AS LONG
hInstance      AS LONG
hIcon          AS LONG
hCursor        AS LONG
hbrBackground  AS LONG
lpszMenuName   AS LONG
lpszClassName  AS LONG
hIconSm        AS LONG
END TYPE

TYPE RECT
	left		AS LONG
	top		AS LONG
	right		AS LONG
	bottom	AS LONG
END TYPE


REM $Ignore:1
DECLARE FUNCTION GetLastError& ()
REM $Process: Declare Function GetLastError StdCall Lib "kernel32" Alias "GetLastError" () As Long

REM $Ignore:1
DECLARE FUNCTION GetModuleHandle& (lpModuleName AS STRING)
REM $Process: Declare Function GetModuleHandle StdCall Lib "kernel32" Alias "GetModuleHandleA" (ByVal lpModuleName As String) As Long

REM $Ignore:1
DECLARE FUNCTION RegisterClassEx& (lpWndClass AS WNDCLASSEX)
REM $Process: Declare Function RegisterClassEx StdCall Lib "user32" Alias "RegisterClassExA" (lpWndClass As WNDCLASSEX) As Long

REM $Ignore:1
DECLARE FUNCTION LoadIcon& (BYVAL hInstance AS LONG, BYVAL lpIconName AS LONG)
REM $Process: Declare Function LoadIcon StdCall Lib "user32" Alias "LoadIconA" (ByVal hInstance As Long, ByVal lpIconName As Any) As Long

REM $Ignore:1
DECLARE FUNCTION LoadCursor& (BYVAL hInstance AS LONG, lpCursorName AS LONG)
REM $Process: Declare Function LoadCursor StdCall Lib "user32" Alias "LoadCursorA" (ByVal hInstance As Long, ByVal lpCursorName As Any) As Long

REM $Ignore:1
DECLARE FUNCTION GetStockObject& (BYVAL nObject AS LONG)
REM $Process: Declare Function GetStockObject StdCall Lib "gdi32" Alias "GetStockObject" (ByVal nIndex As Long) As Long

REM $Ignore:1
DECLARE FUNCTION CreateWindowEx& (BYVAL dwExStyle AS LONG, lpClassName AS STRING, lpWindowName AS STRING, dwStyle AS LONG, x AS LONG, y AS LONG, nWidth AS LONG, nHeight AS LONG, hWndParent AS LONG, hMenu AS LONG, hInstance AS LONG, BYVAL lpParam AS  _
LONG)
REM $Process: Declare Function CreateWindowEx StdCall Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As Any, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, byval lpParam AS LONG) As Long

REM $Ignore:1
DECLARE FUNCTION RegisterWindowMessage& (lpString AS STRING)
REM $Process: Declare Function RegisterWindowMessage StdCall Lib "user32" Alias "RegisterWindowMessageA" (ByVal lpString As String) As Long

REM $Ignore:1
DECLARE FUNCTION ShowWindow& (BYVAL hwnd AS LONG, BYVAL nCmdShow AS LONG)
REM $Process: Declare Function ShowWindow StdCall Lib "user32" Alias "ShowWindow" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long

REM $Ignore:1
DECLARE FUNCTION UpdateWindow& (BYVAL hwnd AS LONG)
REM $Process: Declare Function UpdateWindow StdCall Lib "user32" Alias "UpdateWindow" (ByVal hwnd As Long) As Long

REM $Ignore:1
DECLARE FUNCTION GetMessage& (lpMsg AS MSG, BYVAL hwnd AS LONG, BYVAL wMsgFilterMin AS LONG, BYVAL wMsgFilterMax AS LONG)
REM $Process: Declare Function GetMessage StdCall Lib "user32" Alias "GetMessageA" (lpMsg As MSG, ByVal hwnd As Long, ByVal wMsgFilterMin As Long, ByVal wMsgFilterMax As Long) As Long

REM $Ignore:1
DECLARE FUNCTION TranslateMessage& (lpMsg AS MSG)
REM $Process: Declare Function TranslateMessage StdCall Lib "user32" Alias "TranslateMessage" (lpMsg As MSG) As Long

REM $Ignore:1
DECLARE FUNCTION DispatchMessage& (lpMsg AS MSG)
REM $Process: Declare Function DispatchMessage StdCall Lib "user32" Alias "DispatchMessageA" (lpMsg As MSG) As Long

REM $Ignore:1
DECLARE FUNCTION GetWindowLong& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG)
REM $Process: Declare Function GetWindowLong StdCall Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long

REM $Ignore:1
DECLARE FUNCTION SetWindowLong& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG, BYVAL dwNewLong AS LONG)
REM $Process: Declare Function SetWindowLong StdCall Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long

REM $Ignore:1
DECLARE FUNCTION GetDlgItemText& (BYVAL hDlg AS LONG, BYVAL nIDDlgItem AS LONG, lpString AS STRING, BYVAL nMaxCount AS LONG)
REM $Process: Declare Function GetDlgItemText StdCall Lib "user32" Alias "GetDlgItemTextA" (ByVal hDlg As Long, ByVal nIDDlgItem As Long, ByVal lpString As String, ByVal nMaxCount As Long) As Long

REM $Ignore:1
DECLARE FUNCTION SetDlgItemText& (BYVAL hDlg AS LONG, BYVAL nIDDlgItem AS LONG, lpString AS STRING)
REM $Process: Declare Function SetDlgItemText StdCall Lib "user32" Alias "SetDlgItemTextA" (ByVal hDlg As Long, ByVal nIDDlgItem As Long, ByVal lpString As String) As Long

REM $Ignore:1
DECLARE FUNCTION EndDialog& (BYVAL hDlg AS LONG, BYVAL nResult AS LONG)
REM $Process: Declare Function EndDialog StdCall Lib "user32" Alias "EndDialog" (ByVal hDlg As Long, ByVal nResult As Long) As Long

REM $Ignore:1
DECLARE FUNCTION GetSystemMetrics& (BYVAL nIndex AS LONG)
REM $Process: Declare Function GetSystemMetrics StdCall Lib "user32" (BYVAL nIndex AS LONG) As Long

REM $Ignore:1
DECLARE FUNCTION LoadMenu& (BYVAL hInstance AS LONG, BYVAL lpString AS LONG)
REM $Process: Declare Function LoadMenu StdCall Lib "user32" Alias "LoadMenuA" (ByVal hInstance As Long, ByVal lpString As Any) As Long

REM $Ignore:1
DECLARE FUNCTION SetMenu& (BYVAL hwnd AS LONG, BYVAL hMenu AS LONG)
REM $Process: Declare Function SetMenu StdCall Lib "user32" Alias "SetMenu" (ByVal hwnd As Long, ByVal hMenu As Long) As Long

REM $Ignore:1
DECLARE FUNCTION ShowWindow& (BYVAL hwnd AS LONG, BYVAL nCmdShow AS LONG)
REM $Process: Declare Function ShowWindow StdCall Lib "user32" Alias "ShowWindow" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long

REM $Ignore:1
DECLARE FUNCTION UpdateWindow& (BYVAL hwnd AS LONG)
REM $Process: Declare Function UpdateWindow StdCall Lib "user32" Alias "UpdateWindow" (ByVal hwnd As Long) As Long

REM $Ignore:1
DECLARE FUNCTION SendMessage& (BYVAL hwnd AS LONG, BYVAL wMsg AS LONG, BYVAL wParam AS LONG, BYVAL lParam AS LONG)
REM $Process: Declare Function SendMessage StdCall Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, byval lParam As Long) As Long

REM $Ignore:1
DECLARE SUB PostQuitMessage (BYVAL nExitCode AS LONG)
REM $Process: Declare Sub PostQuitMessage StdCall Lib "user32" Alias "PostQuitMessage" (ByVal nExitCode As Long)

REM $Ignore:1
DECLARE FUNCTION DefWindowProc& (BYVAL hwnd AS LONG, BYVAL wMsg AS LONG, BYVAL wParam AS LONG, BYVAL lParam AS LONG)
REM $Process: Declare Function DefWindowProc StdCall Lib "user32" Alias "DefWindowProcA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

REM $Ignore:1
DECLARE FUNCTION GetClientRect& (BYVAL hwnd AS LONG, rect AS RECT)
REM $Process: Declare Function GetClientRect StdCall Lib "user32" Alias "GetClientRect" (ByVal hwnd As Long, rect As RECT) As Long

REM $Ignore:1
DECLARE FUNCTION MoveWindow& (BYVAL hwnd AS LONG, BYVAL lft AS LONG, BYVAL tp AS LONG, BYVAL wdt AS LONG, BYVAL hgt AS LONG, BYVAL redraw AS LONG)
REM $Process: Declare Function MoveWindow StdCall Lib "user32" Alias "MoveWindow" (ByVal hwnd As Long, BYVAL lft AS LONG, BYVAL tp AS LONG, BYVAL wdt AS LONG, BYVAL hgt AS LONG, BYVAL redraw AS LONG) As Long


CONST WmCreate = 1
CONST WmDestroy = 2
CONST WmSize = 5
CONST WmClose = 16
CONST WmNotify = 78
CONST WmInitdialog = 272
CONST WmCommand = 273

CONST IdiApplication = 32512&
CONST IdcArrow = 32512&
CONST WhiteBrush = 0

CONST DwlUser = 8

