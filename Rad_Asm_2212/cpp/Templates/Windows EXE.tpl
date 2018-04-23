Win32 App
test
Window app
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
1=4,O,C:\masm32\bin\RC /v,1
2=3,O,CL /c /O1 /GA /GB /w /TC /nologo /Fo /I"$I",2
3=5,O,LINK @libs.txt /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3
4=0,0,,5
5=rsrc.obj,O,CVTRES,rsrc.res
6=*.obj,O,CL /c /O1 /GA /GB /w /TC /nologo /Fo /I"$I",*.cpp
7=0,0,"$E\OllyDbg",5
11=4,O,C:\masm32\bin\RC /v,1
12=3,O,CL /c /O1 /GA /GB /w /TC /nologo /Zi /Fo /I"$I",2
13=5,O,LINK @libs.txt /SUBSYSTEM:WINDOWS /DEBUG /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
14=0,0,,5
15=rsrc.obj,O,CVTRES,rsrc.res
16=*.obj,O,CL /c /O1 /GA /GB /w /TC /nologo /Fo /I"$I",*.cpp
17=0,0,"$E\OllyDbg",5
[MakeFiles]
0=test.rap
1=test.rc
2=test.cpp
3=test.obj
4=test.res
5=test.exe
6=test.def
7=test.dll
8=test.txt
9=test.lib
10=test.mak
11=test.c
12=test.com
13=test.ocx
14=test.idl
15=test.tlb
[Resource]
[StringTable]
[Accel]
[VerInf]
[Group]
Group=Added files,Assembly,Resources,Misc,Modules
1=2
2=2
3=
[*ENDDEF*]
[*BEGINTXT*]
test.cpp
#include "windows.h"

#pragma comment(linker, "/ENTRY:EntryPoint")

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

void EntryPoint() 
{ 
	ExitProcess(WinMain(GetModuleHandle(NULL), NULL, GetCommandLine(), SW_SHOWNORMAL)); 
}
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
	static TCHAR szAppName[]=TEXT("Windows");
	HWND hwnd;
	MSG msg;
	WNDCLASS wndclass;
	wndclass.style=CS_HREDRAW|CS_VREDRAW;
	wndclass.lpfnWndProc=WndProc;
	wndclass.cbClsExtra=0;
	wndclass.cbWndExtra=0;
	wndclass.hInstance=hInstance;
	wndclass.hIcon=LoadIcon(NULL, IDI_APPLICATION);
	wndclass.hCursor=LoadCursor(NULL,IDC_ARROW);
	wndclass.hbrBackground=(HBRUSH)GetStockObject(WHITE_BRUSH);
	wndclass.lpszMenuName=NULL;
	wndclass.lpszClassName=szAppName;

	if(!RegisterClass(&wndclass))
	{
		MessageBox(NULL,TEXT("This program requires Windows NT!"),szAppName,MB_ICONERROR);
		return 0;
	}
	hwnd=CreateWindow(szAppName,						//window class name
					  TEXT("Windows Program"),		//window caption
					  WS_OVERLAPPEDWINDOW,			//window style
					  CW_USEDEFAULT,			//initial x position
					  CW_USEDEFAULT,			//initial y position
					  CW_USEDEFAULT,			//initial x size
					  CW_USEDEFAULT,			//initial y size
					  NULL,					//parent window handle
					  NULL,					//window menu handle
					  hInstance,				//program instance handle
					  NULL);				//creation parameters

	ShowWindow(hwnd,iCmdShow);
	UpdateWindow(hwnd);

	while (GetMessage(&msg,NULL,0,0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
//	MessageBox(NULL,TEXT("Test"),TEXT("CAPTION"),MB_OK);
	return msg.wParam;
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch(message)
	{
	case WM_CREATE:
		//Put your code here
		return 0;

	case WM_PAINT:
		//Put your code here
		return 0;

	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	}
	return DefWindowProc(hwnd,message,wParam,lParam);
}
[*ENDTXT*]
[*BEGINTXT*]
libs.txt
kernel32.lib
comctl32.lib
user32.lib
gdi32.lib
comdlg32.lib
shell32.lib
winmm.lib
[*ENDTXT*]
[*ENDPRO*]
