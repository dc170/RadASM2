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
