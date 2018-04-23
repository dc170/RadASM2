' include file for building RadASM plugins

#define RadASM_Version		2208

' Assemblers
#define nMASM						1
#define nTASM						2
#define nFASM						3
#define nGOASM						4
#define nNASM						5
#define nHLA						6
#define nCPP						7						' C/C++
#define nBCET						8						' BCET and FreeBASIC
#define nOTHER						99

' Messages to RadASM's mdi frame
#define AIM_GETHANDLES			WM_USER+50			' returns a poiner to a struct containing all useful handles:see structures below
#define AIM_GETPROCS				WM_USER+51			' returns a poiner to a struct containing some procs in RadASM:see structures below
#define AIM_GETDATA				WM_USER+52			' returns a poiner to a struct comtaining data pointers:see structures below
#define AIM_GETMENUID			WM_USER+53			' Returns a free menu id. If you need more than one just send the message again.

' Messages from RadASM to DllProc procedure
' Hook flag in eax
#define AIM_COMMAND				WM_COMMAND			' hWnd=Handle of mdi frame, wParam & lParam=as for WM_COMMAND
#define AIM_MAKEBEGIN			WM_USER+100			' hWnd=Handle of mdi frame, wParam=0, lParam=pointer to string containing commands
#define AIM_MAKEDONE				WM_USER+101			' hWnd=Handle of mdi frame, wParam=0, lParam=exit code
#define AIM_CLOSE					WM_CLOSE				' hWnd=Handle of mdi frame, wParam & lParam=as for WM_CLOSE
#define AIM_INITMENUPOPUP		WM_INITMENUPOPUP	' hWnd=Handle of mdi frame, wParam & lParam=as for WM_INITMENUPOPUP
#define AIM_COMMANDDONE			WM_USER+102			' hWnd=Handle of mdi frame, wParam & lParam=as for WM_COMMAND
#define AIM_PROJECTCLOSE		WM_USER+103			' hWnd=Handle of mdi frame, wParam=0, lParam=0
#define AIM_PROJECTCLOSED		WM_USER+104			' hWnd=Handle of mdi frame, wParam=0, lParam=0
#define AIM_CLIENTMOUSEMOVE	WM_USER+105			' hWnd=handle of client, wParam & lParam=as for WM_MOUSEMOVE
#define AIM_TIMER					WM_USER+106			' as for a TimerProc
#define AIM_CTLDBLCLK			WM_USER+107			' hWnd=handle of mdi child, wParam=handle of control, lParam=pointer to DIALOG structure
#define AIM_CREATENEWDLG		WM_USER+108			' hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to filename
#define AIM_CONTEXTMENU			WM_USER+109			' hWnd=Handle of mdi frame, wParam & lParam=as for WM_CONTEXTMENU
#define AIM_PROJECTOPENED		WM_USER+110			' hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
#define AIM_MENUREBUILD			WM_USER+111			' hWnd=handle of menu, wParam=0, lParam=0
#define AIM_EDITOPEN				WM_USER+112			' hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
#define AIM_EDITCLOSE			WM_USER+113			' hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
#define AIM_EDITCLOSED			WM_USER+114			' hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
#define AIM_EDITSAVE				WM_USER+115			' hWnd=handle of mdi child, wParam=handle of edit, lParam=pointer to filename
#define AIM_EDITSAVED			WM_USER+116			' hWnd=handle of mdi child, wParam=handle of edit, lParam=pointer to filename
#define AIM_TBRTOOLTIP			WM_USER+117			' hWnd=handle of mdi frame, wParam=ID, lParam=0
#define AIM_MDIACTIVATE			WM_USER+118			' hWnd=handle of mdi child, wParam & lParam=same as for WM_MDIACTIVATE
#define AIM_EDITSELCHANGE		WM_USER+119			' hWnd=handle of mdi child, wParam=handle of edit, lParam=ID
#define AIM_PROJECTADDNEW		WM_USER+120			' hWnd=handle of mdi frame, wParam=type, lParam=pointer to filename
#define AIM_PROJECTREMOVE		WM_USER+121			' hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
#define AIM_DLGMNUSELECT		WM_USER+122			' hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to MENUITEM structure
#define AIM_RCUPDATE				WM_USER+123			' hWnd=handle of dialog,wParam=type,lParam=pointer to memory
#define AIM_CREATENEWCTL		WM_USER+124			' hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to DIALOG structure
#define AIM_TOOLSHOW				WM_USER+125			' hWnd=handle of tool,wParam=visible,lParam=ID
#define AIM_SETSTYLE				WM_USER+126			' hWnd=handle of property listbox, wParam=Pointer to DIALOG struct. lParam=TRUE if ExStyle
#define AIM_OUTPUTDBLCLK		WM_USER+127			' hWnd=handle of output, wParam & lParam=same as for WM_LBUTTONDBLCLK
#define AIM_CODEINFO				WM_USER+128			' hWnd=handle of mdi child, wParam=ID, lParam=pointer to word
' Hook flag in ecx
#define AIM_MODULEBUILD			WM_USER+129			' hWnd=handle of mdi frame,wParam=lpFileName(no ext), lParam=0
#define AIM_DIALOGOPEN			WM_USER+130			' hWnd=handle of mdi child,wParam=lpDlgMem, lParam=0
#define AIM_DIALOGSAVE			WM_USER+131			' hWnd=handle of mdi child,wParam=hFile, lParam=0
#define AIM_UNHOOK				WM_USER+132			' hWnd=handle of window to unhook,wParam=proc to unhook, lParam=previous proc
#define AIM_ADDINSLOADED		WM_USER+133			' hWnd=handle of mdi frame,wParam=0, lParam=0
#define AIM_LANGUAGECHANGE		WM_USER+134			' hWnd=handle of mdi frame,wParam=0, lParam=0
#define AIM_PROJECTOPEN			WM_USER+135			' hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
#define AIM_PROJECTRENAME		WM_USER+136			' hWnd=handle of mdi frame, wParam=pointer to old filename, lParam=pointer to new filename
#define AIM_EDITKEYDOWN			WM_USER+137			' hWnd=handle of edit window, wParam and lParam as WM_KEYDOWN
#define AIM_EDITCHAR				WM_USER+138			' hWnd=handle of edit window, wParam and lParam as WM_CHAR
#define AIM_PREPARSE				WM_USER+139			' hWnd=handle of mdi frame, wParam=project file number,lParam=pointer to file content
#define AIM_PARSEDONE			WM_USER+140			' hWnd=handle of mdi frame, wParam=project file number,lParam=pointer to file content

' Return values in fHook1 (0 to 31) from InstallDll procedure which tell RadASM which messages to send to your DllProc procedure,can be OR'ed
#define RAM_COMMAND				&H00000001			' AIM_COOMAND equ WM_COMMAND
#define RAM_COMMANDDONE			&H00000002			' AIM_COMMANDDONE
#define RAM_CLOSE					&H00000004			' AIM_CLOSE equ WM_CLOSE			
#define RAM_INITMENUPOPUP		&H00000008			' AIM_INITMENUPOPUP equ WM_INITMENUPOPUP	
#define RAM_MAKEBEGIN			&H00000010			' AIM_MAKEBEGIN		
#define RAM_MAKEDONE				&H00000020			' AIM_MAKEDONE		
#define RAM_PROJECTCLOSE		&H00000040			' AIM_PROJECTCLOSE	
#define RAM_PROJECTCLOSED		&H00000080			' AIM_PROJECTCLOSED
#define RAM_CLIENTMOUSEMOVE	&H00000100			' AIM_CLIENTMOUSEMOVE 
#define RAM_TIMER					&H00000200			' AIM_TIMER			
#define RAM_CTLDBLCLK			&H00000400			' AIM_CTLDBLCLK		
#define RAM_CREATENEWDLG		&H00000800			' AIM_CREATENEWDLG	
#define RAM_CONTEXTMENU			&H00001000			' AIM_CONTEXTMENU	    
#define RAM_PROJECTOPENED		&H00002000			' AIM_PROJECTOPENED
#define RAM_MENUREBUILD			&H00004000			' AIM_MENUREBUILD
#define RAM_EDITOPEN				&H00008000			' AIM_EDITOPEN
#define RAM_EDITCLOSE			&H00010000			' AIM_EDITCLOSE
#define RAM_EDITCLOSED			&H00020000			' AIM_EDITCLOSED
#define RAM_EDITSAVE				&H00040000			' AIM_EDITSAVE
#define RAM_EDITSAVED			&H00080000			' AIM_EDITSAVED
#define RAM_TBRTOOLTIP			&H00100000			' AIM_TBRTOOLTIP
#define RAM_MDIACTIVATE			&H00200000			' AIM_MDIACTIVATE
#define RAM_EDITSELCHANGE		&H00400000			' AIM_EDITSELCHANGE
#define RAM_PROJECTADDNEW		&H00800000			' AIM_PROJECTADDNEW
#define RAM_PROJECTREMOVE		&H01000000			' AIM_PROJECTREMOVE
#define RAM_DLGMNUSELECT		&H02000000			' AIM_DLGMNUSELECT
#define RAM_RCUPDATE				&H04000000			' AIM_RCUPDATE
#define RAM_CREATENEWCTL		&H08000000			' AIM_CREATENEWCTL
#define RAM_TOOLSHOW				&H10000000			' AIM_TOOLSHOW
#define RAM_SETSTYLE				&H20000000			' AIM_SETSTYLE
#define RAM_OUTPUTDBLCLK		&H40000000			' AIM_OUTPUTDBLCLK
#define RAM_CODEINFO				&H80000000			' AIM_CODEINFO

' Return values in fHook2 (32 to 63) from InstallDll procedure which tell RadASM which messages to send to your DllProc procedure,can be OR'ed
#define RAM_MODULEBUILD			&H00000001			' AIM_MODULEBUILD
#define RAM_DIALOGOPEN			&H00000002			' AIM_DIALOGOPEN
#define RAM_DIALOGSAVE			&H00000004			' AIM_DIALOGSAVE
#define RAM_UNHOOK				&H00000008			' AIM_UNHOOK
#define RAM_ADDINSLOADED		&H00000010			' AIM_ADDINSLOADED
#define RAM_LANGUAGECHANGE		&H00000020			' AIM_LANGUAGECHANGE
#define RAM_PROJECTOPEN			&H00000040			' AIM_PROJECTOPEN
#define RAM_PROJECTRENAME		&H00000080			' AIM_PROJECTRENAME
#define RAM_EDITKEYDOWN			&H00000100			' AIM_EDITKEYDOWN
#define RAM_EDITCHAR				&H00000200			' AIM_EDITCHAR
#define RAM_PREPARSE				&H00000400			' AIM_PREPARSE
#define RAM_PARSEDONE			&H00000800			' AIM_PARSEDONE

' Structure pointed to on return from AIM_GETHANDLES 
type ADDINHANDLES field=1
	hWnd								as HWND				' Handle of mdi Frame
	hMenu								as HMENU				' Handle of mdi Frame Menu
	hToolBar							as HWND				' Handle of mdi Frame ToolBar
	hStatus							as HWND				' Handle of mdi Frame StatusBar
	hClient							as HWND				' Handle of mdi client
	hMdiCld							as HWND				' Handle of topmost mdi Child window
	hEdit								as HWND				' Handle of topmost mdi Child RAEdit window
	hDialog							as HWND				' Handle of topmost mdi Child DialogBox window
	hSearch							as HWND				' Handle of search / replace dialog
	hGoTo								as HWND				' Handle of goto dialog
	hOut								as HWND				' Handle of output Static container
	hPbr								as HWND				' Handle of project Static container
	hTlb								as HWND				' Handle of toolbox Static container
	hPrp								as HWND				' Handle of properties Static container
	hPrpCbo							as HWND				' Handle of properties ComboBox
	hPrpLst							as HWND				' Handle of properties ListBox
	hPrpTxt							as HWND				' Handle of properties item Edit control
	hTxtLst							as HWND				' Handle of properties item ListBox
	hTxtBtn							as HWND				' Handle of properties item Button
	hLB								as HWND				' Handle of Api ListBox (CodeComplete). Same as hLBU or hLBS
	hTlt								as HWND				' Handle of Api Static (ToolTip)
	hInst								as HINSTANCE		' RadASM instance
	hToolMenu						as HMENU				' Handle of RightClick Menu in project, properties and output window
	hTab								as HWND				' Handle of tab window
	hPbrTrv							as HWND				' Handle of project browser TreeView
	hPrpTbr							as HWND				' Handle of properties ToolBar
	hPbrTbr							as HWND				' Handle of project / file browser ToolBar
	hFileTrv							as HWND				' Handle of file browser TreeView
	hOutREd							as HWND				' Handle of active output RAEdit window
	hOut1								as HWND				' Handle of output#1 RAEdit window
	hOut2								as HWND				' Handle of output#2 RAEdit window
	hOut3								as HWND				' Handle of output#3 RAEdit window
	hOutBtn1							as HWND				' Handle of output button #1
	hOutBtn2							as HWND				' Handle of output button #2
	hOutBtn3							as HWND				' Handle of output button #3
	hDivider							as HWND				' Handle of divider line
	hSniplet							as HWND				' Handle of sniplet dialog
	hToolTip							as HWND				' Handle of toolbox button tooltip
	hLBU								as HWND				' Handle of unsorted listbox
	hLBS								as HWND				' Handle of sorted listbox
	hInf								as HWND				' Handle of infotool static container
	hInfEdt							as HWND				' Handle of infotool edit control
	hTl1								as HWND				' Handle of tool#1 static container
	hTl2								as HWND				' Handle of tool#2 static container
	hHexEd							as HWND				' Handle of topmost mdi Child RAHexEd window
	hAccel							as HACCEL			' RadASM Accelerators
	hTbrIml							as HIMAGELIST		' Imagelist for the toolbars
	hTypeIml							as HIMAGELIST		' Imagelist for the intellisense listboxes
	hPrpTxtMulti					as HWND				' Handle of properties item multiline Edit control
	hLBFont							as HFONT				' Api listboxes
	hTTFont							as HFONT				' Api tooltip
	hFont(3)				 			as HFONT				' Code edit Normal, Italic, Linenumber
	hFontTxt							as HFONT				' Text edit
	hFontHex							as HFONT				' Hex edit
	hFullScreen						as HWND				' Handle of fullscreen editing popup
end type

' Structure pointed to on return from AIM_GETPROCS
type ADDINPROCS field=1
	lpTextOut						as long				' Pointer to proc handeling text to output window. Push pointer to text before calling.
	lpHexOut							as long				' Pointer to proc handeling hex to output window. Use for debug. Push val before calling.
	lpClearOut						as long				' Pointer to proc clearing output
	lpAddProjectFile				as long				' lpFileName,fUpdateTree,fModule
	lpOpenProjectFile				as long				' Give error msg TRUE/FALSE, set lpFile to file to open
	lpToolMessage					as long				' Handle, message, lParam
	lpGetWordFromPos				as long				' Handle of RAEdit, returns pointer to word
	lpProFind						as long				' Pointer to a PROFIND struct
	lpGetWord						as long				' lpWord, returns pointer to word
	lpRemoveProjectPath			as long				' lpFileName, lpBuff, returns pointer to filename
	lpGetMainFile					as long				' lpFileExt
	lpSearchMem						as long				' hMem,lpFind,fMCase,fWWord
	lpProScan						as long				' lpFind,lpNot
	lpBackupEdit					as long				' lpFileName,1
	lpGetFileType					as long				' lpFileName
	lpOutputSelect					as long				' (1,2 or 3)
	lpUpdateCtl						as long				' Handle of control
	lpShowBreakPoint				as long				' Breakpoint ID (0-255)
	lpUpdateVerInf					as long				' TRUE to export to output, FALSE to update rc file
	lpCloseProject					as long				' No parameters
	lpOpenProject					as long				' Parameter TRUE/FALSE, FALSE=Show open file dialog, TRUE=lpFileName set to project file
	lpExportDialog					as long				' Handle of mdi child, Save to rc file TRUE/FALSE 
	lpDllProc						as long				' hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM,fHookFun:DWORD
	lpSetPropertyCbo				as long				' Index of selected
	lpAddTab							as long				' hMdiChild,lpFileName
	lpDelTab							as long				' hMdiChild
	lpSelTab							as long				' hMdiChild
	lpUpdateAll						as long				' Command (IDM_FILE_SAVEALLFILES, IDM_FILE_OPENFILE, IDM_FILE_CLOSEFILE, IDM_OPTION_COLORS, IDM_OPTION_FONT, IDM_OPTION_EDIT, WM_PAINT, IDM_FORMAT_SHOWGRID)
	lpGetFileNameFromID			as long				' nProjectFileID
	lpMenuRebuild					as long				' No parameters
	lpUpdateMRU						as long				' No parameters
	lpUpdateResource				as long				' TRUE to export to output, FALSE to update rc file
	lpUpdateStringTable			as long				' TRUE to export to output, FALSE to update rc file
	lpUpdateAccelerator			as long				' TRUE to export to output, FALSE to update rc file
	lpGetProjectFiles				as long				' Update project treeview, TRUE to auto open files
	lpToolBarStatus				as long				' Updates toolbar button status
	lpUpdateLanguage				as long				' TRUE to export to output, FALSE to update rc file
	lpGetLangString				as long				' lpApp,lpKey,lpStr,nCC
	lpSetLanguage					as long				' hWin,lpApp,fNoResize
	lpModalDialog					as long				' DialogBoxParam
	lpModelessDialog				as long				' CreateDialogParam
	lpUpdateSizeingRect			as long				' hWin, fReadOnly
	lpSaveEdit						as long				' hMdiCld
	lpSaveDialog					as long				' hMdiCld,FALSE
	lpSaveHexEdit					as long				' hMdiCld
	lpSetTextLink					as long				' nType (1-3)
	lpScanWord						as long				' lpWord, lpLine
	lpAddWordToWordList			as long				' nType,nOwner,pWords,nParts
end type

' Structure pointed to on return from AIM_GETDATA
type ADDINDATA field=1
	nRadASMVer						as long				' Version
	fMaximized						as long				' If TRUE top menu popups+1
	lpIniFile						as long				' Pointer to radasm.ini file
	lpProject						as long				' Pointer to project file
	lpProjectPath					as long				' Pointer to project path. Includes ending '\'
	lpFile							as long				' Pointer to FileName buffer
	lpApp								as long				' Pointer to App path
	lpBin								as long				' Pointer to Binary path
	lpAddIn							as long				' Pointer to AddIn path
	lpHlp								as long				' Pointer to Help path
	lpIncl							as long				' Pointer to Include path
	lpLib								as long				' Pointer to Library path
	lpPro								as long				' Pointer to Projects path
	lpSnp								as long				' Pointer to Snipplets path
	lpTpl								as long				' Pointer to Templates path
	lpMac								as long				' Pointer to Keyboard Macro path
	lpIniAsmFile					as long				' Pointer to masm/fasm/tasm ini file
	fProject							as long				' If TRUE a project is loaded
	lpLoadPath						as long				' Pointer to path where radasm was loaded
	lpCtlTypes						as long				' Pointer to TYPES struct (dialog edit)
	fResChanged						as long				' If TRUE resources are changed since last compile
	lpBreakPoint					as long				' Pointer to 256 breakpoint structs
	fResProject						as long				' If TRUE project has resource file.
	lpBreakPointVar				as long				' Pointer to breakpoint variables
	AsmFlag							as long				' If TRUE dblclicks in output window opens file.
	lpCharTab						as long				' Pointer to RAEdit's character table
	szAssembler(16)				as ubyte				' Fixed lenght string
	lpPrpCboItems					as long				' Comma separated string containing property combo items
	fEditMax							as long				' If TRUE open mdi child maximized
	lpProjectFiles					as long				' Pointer to memory block containing project files
	hWordList						as long				' Handle of wordlist memory
	lpWordList						as long				' Pointer to wordlist memory
	rpProjectWordList				as long				' Relative pointer into lpWordList, points to project code properties
	rpWordListPos					as long				' Relative pointer into lpWordList, points to free
	lpAddins							as long				' Pointer to addins structure
	rpStructList					as long				' Relative pointer into lpWordList, points to structures
	lpszAppName						as long				' Pointer to AppName string
	lpDbg								as long				' Pointer to Debug path
	lpCurPro							as long				' Pointer to Current Project path
	lpszAclKeys						as long				' Pointer to accelerator definitions
	UserBtnID						as long				' Pointer to first user button ID
	nAsm								as long				' Current assembler(nMASM, nTASM....)
	fNT								as long				' TRUE if on NT platform
	lpRABlockdef					as long				' Pointer to block defs
	TabSize							as long				' Number of space chars in a tab char
	ShowApiList						as long				' If TRUE RadASM will show listbox on api's and procs.
	ShowApiStruct					as long				' If TRUE RadASM will show listbox on structure items.
	ShowApiToolTip					as long				' If TRUE RadASM will show tooltip on api's and procs.
	fLB								as long				' RadASM is showing the listbox.
	fTlt								as long				' RadASM is showing the tooltip.
end type

' Addin options
type ADDINOPT field=1
	lpStr								as string ptr		' Pointer to description string
	nAnd								as long				' AND value
	nOr								as long				' OR value
end type

' Return a pointer to a struct like this from InstallDllEx
type ADDINHOOKS field=1
	fHook1 							as long				' Returned hooks 0 to 31
	fHook2 							as long				' Returned hooks 32 to 63
	fHook3 							as long				' Returned hooks 64 to 95
end type

