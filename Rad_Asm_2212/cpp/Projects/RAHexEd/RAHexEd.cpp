
/*
	RadHexEditor For Visual C++ 6.0 - Converted By Wizzra
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	This Conversion uses KetilO's RadHexEditor Add-in
	Hex Custom Control for the 'RadASM' IDE Inside Visual Studio IDE.

									- CopyRights by KetilO (R) 2003 -
									http://radasm.visualassembler.com/

	Enjoy the Conversion,
						  Wizzra 2003

*/

#include "windows.h"
#include "commctrl.h"
#include "richedit.h"

#include "rahexed.h"

#define WIN32_LEAN_AND_MEAN


//RAHexEd.dlg
#define IDD_DLG1						1000
#define IDC_RAH1						1001
#define IDC_SBR1						1002

//RAHexEd.mnu
#define IDR_MENU						10000
#define IDM_FILE						10001
#define IDM_FILE_OPEN					10003
#define IDM_FILE_SAVE					10004
#define IDM_FILE_SAVE_AS				10005
#define IDM_FILE_EXIT					10002
#define IDM_OPTIONS						10006
#define IDM_OPTION_ADDRESS				10007
#define IDM_OPTION_ASCII				10008
#define IDM_OPTION_UPPER				10009

// Global Variables

HINSTANCE hInst;
HMODULE hRadHex;
char szFileName[MAX_PATH]="";
char szLine[]="Ln: %d Char: %d";
char szBuff[512]="";
HEFONT hef;

int WantToSave(HWND hWnd);
void LoadFileToRAHexEd(HWND hWnd);
void SaveFileFromRAHexEd(HWND hWnd);
void SaveFileAsFromRaHexEd(HWND hWnd);
void SaveFile(HWND RadWin,char *FileName);
void Hide_UnHide_RadHexAddress(HWND hWnd);
void Hide_UnHide_RadHexAscii(HWND hWnd);
void UpperLower_caseRadHex(HWND hWnd);

DWORD CALLBACK StreamInProc(DWORD dwCookie, LPBYTE lpbBuff, LONG cb, LONG FAR *pcb);
DWORD CALLBACK StreamOutProc(DWORD dwCookie, LPBYTE lpbBuff, LONG cb, LONG FAR *pcb);

BOOL CALLBACK DialogProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	// This Window Message is the heart of the dialog //
	//================================================//
	UINT lnr;
	UINT cpl;
	LOGFONT lf;
	switch (message) // what are we doing ?
	{
		case WM_INITDIALOG:
		{
			RtlZeroMemory(&lf, sizeof(LOGFONT));
			lf.lfHeight = -12;
			lstrcpy( lf.lfFaceName, TEXT("Courier New"));
			hef.hFont = CreateFontIndirect(&lf);
			lf.lfHeight = -8;
			lstrcpy(lf.lfFaceName, TEXT("Terminal"));
			hef.hLnrFont = CreateFontIndirect(&lf);
			SendDlgItemMessage(hWnd,IDC_RAH1,HEM_SETFONT,0,(LPARAM)&hef);
		}
		break;
		case WM_LBUTTONDOWN:
		{
			ReleaseCapture();
			SendMessage(hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0);
		}
		break;
		case WM_PAINT: // constantly painting the window
		{
			return 0;
		}
		break;
		case WM_CLOSE: // We colsing the Dialog
		{
			if(WantToSave(hWnd)==TRUE)
			{
				return 0;
			}
			DeleteObject(hef.hFont);
			DeleteObject(hef.hLnrFont);
			EndDialog(hWnd,0);
		}
		break;
		case WM_COMMAND: // Controling the Buttons
		{
			switch (LOWORD(wParam)) // what we pressed on?
			{
				case IDM_FILE_OPEN:
				{
					if(WantToSave(hWnd)==FALSE)
					{
						LoadFileToRAHexEd(hWnd);
					}
				}
				break;
				case IDM_FILE_SAVE:
				{
					SaveFileFromRAHexEd(hWnd);
				}
				break;
				case IDM_FILE_SAVE_AS:
				{
					SaveFileAsFromRaHexEd(hWnd);
				}
				break;
				case IDM_FILE_EXIT:
				{
					SendMessage(hWnd,WM_CLOSE,0,0);
				}
				break;
				case IDM_OPTION_ADDRESS:
				{
					Hide_UnHide_RadHexAddress(hWnd);
				}
				break;
				case IDM_OPTION_ASCII:
				{
					Hide_UnHide_RadHexAscii(hWnd);
				}
				break;
				case IDM_OPTION_UPPER:
				{
					UpperLower_caseRadHex(hWnd);
				}
				break;
			}
			break;
		}
		break;
		case WM_NOTIFY: // Notification
		{
			if ((((HESELCHANGE *)lParam)->nmhdr.code) == EN_SELCHANGE)
			{
				cpl=((HESELCHANGE *)lParam)->chrg.cpMin;
				lnr=((HESELCHANGE *)lParam)->line;
				cpl=cpl-lnr*32+1;
				lnr=lnr+1;
				wsprintf(szBuff,szLine,lnr,cpl);
				SetDlgItemText(hWnd,IDC_SBR1,szBuff);
			}
		}
		break;
	}
	return 0;
}

int WantToSave(HWND hWnd)
{
	if(SendDlgItemMessage(hWnd,IDC_RAH1,EM_GETMODIFY,0,0)==TRUE)
	{
		switch (MessageBox(hWnd,"There Has Been Changes, Do You Want To Save Them?","Save Changes",MB_YESNOCANCEL|MB_ICONQUESTION))
		{
			case IDYES:
			{
				if(szFileName=="")
				{
					SaveFileAsFromRaHexEd(hWnd);
				}
				else
				{
					SaveFileFromRAHexEd(hWnd);
				}
			}
			break;
			case IDNO:
			{
			}
			break;
			case IDCANCEL:
			{
				return TRUE;
			}
		}
	}
	return FALSE;
}

void LoadFileToRAHexEd(HWND hWnd)
{
	// File Select dialog struct
	OPENFILENAME ofn;
	EDITSTREAM editstream;
	CHARRANGE chrg;
	HANDLE hFile;
	HWND RadHexhWnd=GetDlgItem(hWnd,IDC_RAH1);
	HMENU Menu = GetMenu(hWnd);

	// Intialize struct
	ZeroMemory(&ofn, sizeof(OPENFILENAME));
	ZeroMemory(&editstream, sizeof(EDITSTREAM));
	ZeroMemory(&chrg, sizeof(CHARRANGE));

	ofn.lStructSize = sizeof(OPENFILENAME); // SEE NOTE BELOW
	ofn.hwndOwner = hWnd;
	ofn.lpstrFilter = "Executable files (*.exe, *.dll)\0*.exe;*.dll\0ROM Files (*.gb,*.gbc)\0*.gb;*.gbc\0All Files (*.*)\0*.*\0";
	ofn.lpstrFile = szFileName;
	ofn.nMaxFile = MAX_PATH;
	ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
	ofn.lpstrDefExt = "exe";

	if(GetOpenFileName(&ofn)!=NULL)
	{
		hFile=CreateFile(szFileName,
			GENERIC_READ|GENERIC_WRITE,
			FILE_SHARE_READ,
			NULL,
			OPEN_ALWAYS,
			FILE_ATTRIBUTE_NORMAL,
			NULL );
	}
	else return;

	if(hFile==INVALID_HANDLE_VALUE)
	{
		MessageBox(hWnd,"Open file failed!","Open file",MB_OK|MB_ICONERROR);
		return;
	}

	editstream.dwCookie = (DWORD)hFile;
	editstream.pfnCallback=StreamInProc;

	SendMessage(RadHexhWnd,EM_STREAMIN,(WPARAM)SF_TEXT,(LPARAM)&editstream);
	CloseHandle(hFile);
	SendMessage(RadHexhWnd,EM_SETMODIFY,FALSE,0);
	chrg.cpMin=0;
	chrg.cpMax=0;
	SendMessage(RadHexhWnd,EM_EXSETSEL,0,(LPARAM)&chrg);

	EnableMenuItem(Menu,IDM_FILE_SAVE,MF_ENABLED);

}

void SaveFileFromRAHexEd(HWND hWnd)
{
	HWND RadHexhWnd=GetDlgItem(hWnd,IDC_RAH1);

	// content of edit control has been modified?
	if(SendMessage(RadHexhWnd,EM_GETMODIFY,0,0)==TRUE)
	{
		SaveFile(RadHexhWnd,szFileName);
	}
}


void SaveFileAsFromRaHexEd(HWND hWnd)
{
	HWND RadHexhWnd=GetDlgItem(hWnd,IDC_RAH1);
	OPENFILENAME ofn;
	char szFileNameSave[MAX_PATH]="";

	ZeroMemory(&ofn, sizeof(OPENFILENAME)); // Init the struct to Zero
	ofn.lStructSize = sizeof(OPENFILENAME); // SEE NOTE BELOW
	ofn.hwndOwner = hWnd;
	ofn.lpstrFilter = "Executable files (*.exe, *.dll)\0*.exe;*.dll\0ROM Files (*.gb,*.gbc)\0*.gb;*.gbc\0All Files (*.*)\0*.*\0";
	ofn.lpstrFile = szFileNameSave;
	ofn.nMaxFile = MAX_PATH;
	ofn.Flags = OFN_OVERWRITEPROMPT | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY | OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt = "exe";

	if(GetSaveFileName(&ofn)!=NULL)
	{
		SaveFile(RadHexhWnd,szFileNameSave);
		EnableMenuItem(GetMenu(hWnd),IDM_FILE_SAVE,MF_ENABLED);
	}
}

DWORD CALLBACK StreamInProc(DWORD dwCookie, LPBYTE lpbBuff, LONG cb, LONG FAR *pcb)
{
	HANDLE hFile = (HANDLE)dwCookie;

	if (!ReadFile(hFile,(LPVOID)lpbBuff, cb, (LPDWORD)pcb, NULL))
		return((DWORD)-1);
	return(0);
}

DWORD CALLBACK StreamOutProc(DWORD dwCookie, LPBYTE lpbBuff, LONG cb, LONG FAR *pcb)
{
	HANDLE hFile = (HANDLE)dwCookie;

	if (!WriteFile(hFile,(LPVOID)lpbBuff, cb, (LPDWORD)pcb, NULL))
		return((DWORD)-1);
	return(0);
}

void SaveFile(HWND RadWin,char *FileName)
{
	EDITSTREAM editstream;
	HANDLE hFile;

	// Init the struct to Zero
	ZeroMemory(&editstream, sizeof(EDITSTREAM));

	hFile=CreateFile(FileName,
			GENERIC_WRITE,
			FILE_SHARE_READ,
			NULL,
			OPEN_ALWAYS,
			FILE_ATTRIBUTE_NORMAL,
			NULL );

	if(hFile==INVALID_HANDLE_VALUE)
		return;

	editstream.dwCookie = (DWORD)hFile;
	editstream.pfnCallback=StreamOutProc;
	SendMessage(RadWin,EM_STREAMOUT,(WPARAM)SF_TEXT,(LPARAM)&editstream);
	CloseHandle(hFile);
	SendMessage(RadWin,EM_SETMODIFY,FALSE,0);
	lstrcpy(szFileName,FileName);
}

void Hide_UnHide_RadHexAddress(HWND hWnd)
{
	HWND RadHWnd = GetDlgItem(hWnd,IDC_RAH1);
	HMENU Menu = GetMenu(hWnd);
	DWORD Style=0;

	Style = GetWindowLong(RadHWnd,GWL_STYLE);

	if((GetMenuState(Menu,IDM_OPTION_ADDRESS,MF_BYCOMMAND)==MF_CHECKED))
	{
		// Set Style Off
		Style |= STYLE_NOADDRESS;
		CheckMenuItem(Menu,IDM_OPTION_ADDRESS,MF_UNCHECKED);
	}
	else{
		// Set Style On
		Style &= (-1 ^ STYLE_NOADDRESS);
		CheckMenuItem(Menu,IDM_OPTION_ADDRESS,MF_CHECKED);
	}

	SetWindowLong(RadHWnd,GWL_STYLE,Style);
	SendMessage(RadHWnd,HEM_REPAINT,0,0);
}

void Hide_UnHide_RadHexAscii(HWND hWnd)
{
	HWND RadHWnd = GetDlgItem(hWnd,IDC_RAH1);
	HMENU Menu = GetMenu(hWnd);
	DWORD Style=0;

	Style = GetWindowLong(RadHWnd,GWL_STYLE);

	if((GetMenuState(Menu,IDM_OPTION_ASCII,MF_BYCOMMAND)==MF_CHECKED))
	{
		// Set Style Off
		Style |= STYLE_NOASCII;
		CheckMenuItem(Menu,IDM_OPTION_ASCII,MF_UNCHECKED);
	}
	else{
		// Set Style On
		Style &= (-1 ^ STYLE_NOASCII);
		CheckMenuItem(Menu,IDM_OPTION_ASCII,MF_CHECKED);
	}

	SetWindowLong(RadHWnd,GWL_STYLE,Style);
	SendMessage(RadHWnd,HEM_REPAINT,0,0);
}

void UpperLower_caseRadHex(HWND hWnd)
{
	HWND RadHWnd = GetDlgItem(hWnd,IDC_RAH1);
	HMENU Menu = GetMenu(hWnd);
	DWORD Style=0;

	Style = GetWindowLong(RadHWnd,GWL_STYLE);

	if((GetMenuState(Menu,IDM_OPTION_UPPER,MF_BYCOMMAND)==MF_CHECKED))
	{
		// Set Style Off
		Style |= STYLE_NOUPPERCASE;
		CheckMenuItem(Menu,IDM_OPTION_UPPER,MF_UNCHECKED);
	}
	else{
		// Set Style On
		Style &= (-1 ^ STYLE_NOUPPERCASE);
		CheckMenuItem(Menu,IDM_OPTION_UPPER,MF_CHECKED);
	}

	SetWindowLong(RadHWnd,GWL_STYLE,Style);
	SendMessage(RadHWnd,HEM_REPAINT,0,0);
}

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
	hInst=hInstance;
	// Lib function. Registers window class.
	RAHexEdInstall(hInst);
	DialogBoxParam(hInstance, MAKEINTRESOURCE(IDD_DLG1), NULL, (DLGPROC)DialogProc,0);
	return 0;
}