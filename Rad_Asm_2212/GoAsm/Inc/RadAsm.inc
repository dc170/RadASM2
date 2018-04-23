;include file for building RadASM 2.2.0.2 plugins

;Messages to RadASM's mdi frame
AIM_GETHANDLES			equ 400h+50	;returns a poiner to a struct containing all useful handles:see structures below
AIM_GETPROCS			equ 400h+51	;returns a poiner to a struct containing some procs in RadASM:see structures below
AIM_GETDATA				equ 400h+52	;returns a poiner to a struct comtaining data pointers:see structures below
AIM_GETMENUID			equ 400h+53	;Returns a free menu id. If you need more than one just send the message again.

;Messages from RadASM to DllProc procedure
;Hook flag in eax
AIM_COMMAND				equ 111h		;hWnd=Handle of mdi frame, wParam & lParam=as for WM_COMMAND
AIM_MAKEBEGIN			equ 400h+100	;hWnd=Handle of mdi frame, wParam=0, lParam=pointer to string containing commands
AIM_MAKEDONE			equ 400h+101	;hWnd=Handle of mdi frame, wParam=0, lParam=exit code
AIM_CLOSE				equ 10h			;hWnd=Handle of mdi frame, wParam & lParam=as for WM_CLOSE
AIM_INITMENUPOPUP		equ 117h		;hWnd=Handle of mdi frame, wParam & lParam=as for WM_INITMENUPOPUP
AIM_COMMANDDONE			equ 400h+102	;hWnd=Handle of mdi frame, wParam & lParam=as for WM_COMMAND
AIM_PROJECTCLOSE		equ 400h+103	;hWnd=Handle of mdi frame, wParam=0, lParam=0
AIM_PROJECTCLOSED		equ 400h+104	;hWnd=Handle of mdi frame, wParam=0, lParam=0
AIM_CLIENTMOUSEMOVE		equ 400h+105	;hWnd=handle of client, wParam & lParam=as for WM_MOUSEMOVE
AIM_TIMER				equ 400h+106	;as for a TimerProc
AIM_CTLDBLCLK			equ 400h+107	;hWnd=handle of mdi child, wParam=handle of control, lParam=pointer to DIALOG structure
AIM_CREATENEWDLG		equ 400h+108	;hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to filename
AIM_CONTEXTMENU			equ 400h+109	;hWnd=Handle of mdi frame, wParam & lParam=as for WM_CONTEXTMENU
AIM_PROJECTOPENED		equ 400h+110	;hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
AIM_MENUREBUILD			equ 400h+111	;hWnd=handle of menu, wParam=0, lParam=0
AIM_EDITOPEN			equ 400h+112	;hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
AIM_EDITCLOSE			equ 400h+113	;hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
AIM_EDITCLOSED			equ 400h+114	;hWnd=handle of mdi child, wParam=handle of edit, lParam=ID_EDIT or ID_EDITTXT
AIM_EDITSAVE			equ 400h+115	;hWnd=handle of mdi child, wParam=handle of edit, lParam=pointer to filename
AIM_EDITSAVED			equ 400h+116	;hWnd=handle of mdi child, wParam=handle of edit, lParam=pointer to filename
AIM_TBRTOOLTIP			equ 400h+117	;hWnd=handle of mdi frame, wParam=ID, lParam=0
AIM_MDIACTIVATE			equ 400h+118	;hWnd=handle of mdi child, wParam & lParam=same as for WM_MDIACTIVATE
AIM_EDITSELCHANGE		equ 400h+119	;hWnd=handle of mdi child, wParam=handle of edit, lParam=ID
AIM_PROJECTADDNEW		equ 400h+120	;hWnd=handle of mdi frame, wParam=type, lParam=pointer to filename
AIM_PROJECTREMOVE		equ 400h+121	;hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
AIM_DLGMNUSELECT		equ 400h+122	;hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to MENUITEM structure
AIM_RCUPDATE			equ 400h+123	;hWnd=handle of dialog,wParam=type,lParam=pointer to memory
AIM_CREATENEWCTL		equ 400h+124	;hWnd=handle of mdi child, wParam=handle of dialog, lParam=pointer to DIALOG structure
AIM_TOOLSHOW			equ 400h+125	;hWnd=handle of tool,wParam=visible,lParam=ID
AIM_SETSTYLE			equ 400h+126	;hWnd=handle of property listbox, wParam=Pointer to DIALOG struct. lParam=TRUE if ExStyle
AIM_OUTPUTDBLCLK		equ 400h+127	;hWnd=handle of output, wParam & lParam=same as for WM_LBUTTONDBLCLK
AIM_CODEINFO			equ 400h+128	;hWnd=handle of mdi child, wParam=ID, lParam=pointer to word
;Hook flag in ecx
AIM_MODULEBUILD			equ 400h+129	;hWnd=handle of mdi frame,wParam=lpFileName(no ext), lParam=0
AIM_DIALOGOPEN			equ 400h+130	;hWnd=handle of mdi child,wParam=lpDlgMem, lParam=0
AIM_DIALOGSAVE			equ 400h+131	;hWnd=handle of mdi child,wParam=hFile, lParam=0
AIM_UNHOOK				equ 400h+132	;hWnd=handle of window to unhook,wParam=proc to unhook, lParam=previous proc
AIM_ADDINSLOADED		equ 400h+133	;hWnd=handle of mdi frame,wParam=0, lParam=0
AIM_LANGUAGECHANGE		equ 400h+134	;hWnd=handle of mdi frame,wParam=0, lParam=0
AIM_PROJECTOPEN			equ 400h+135	;hWnd=handle of mdi frame, wParam=0, lParam=pointer to filename
AIM_PROJECTRENAME		equ 400h+136	;hWnd=handle of mdi frame, wParam=pointer to old filename, lParam=pointer to new filename

;Return values (eax) from InstallDll procedure which tell RadASM which messages to send to your DllProc procedure,can be OR'ed
RAM_COMMAND				equ 00000001h	;AIM_COOMAND equ WM_COMMAND
RAM_COMMANDDONE			equ 00000002h	;AIM_COMMANDDONE
RAM_CLOSE				equ 00000004h	;AIM_CLOSE equ WM_CLOSE			
RAM_INITMENUPOPUP		equ 00000008h	;AIM_INITMENUPOPUP equ WM_INITMENUPOPUP	
RAM_MAKEBEGIN			equ 00000010h	;AIM_MAKEBEGIN		
RAM_MAKEDONE			equ 00000020h	;AIM_MAKEDONE		
RAM_PROJECTCLOSE		equ 00000040h	;AIM_PROJECTCLOSE	
RAM_PROJECTCLOSED		equ 00000080h	;AIM_PROJECTCLOSED
RAM_CLIENTMOUSEMOVE		equ 00000100h	;AIM_CLIENTMOUSEMOVE 
RAM_TIMER				equ 00000200h	;AIM_TIMER			
RAM_CTLDBLCLK			equ 00000400h	;AIM_CTLDBLCLK		
RAM_CREATENEWDLG		equ 00000800h	;AIM_CREATENEWDLG	
RAM_CONTEXTMENU			equ 00001000h	;AIM_CONTEXTMENU	    
RAM_PROJECTOPENED		equ 00002000h	;AIM_PROJECTOPENED
RAM_MENUREBUILD			equ 00004000h	;AIM_MENUREBUILD
RAM_EDITOPEN			equ 00008000h	;AIM_EDITOPEN
RAM_EDITCLOSE			equ 00010000h	;AIM_EDITCLOSE
RAM_EDITCLOSED			equ 00020000h	;AIM_EDITCLOSED
RAM_EDITSAVE			equ 00040000h	;AIM_EDITSAVE
RAM_EDITSAVED			equ 00080000h	;AIM_EDITSAVED
RAM_TBRTOOLTIP			equ 00100000h	;AIM_TBRTOOLTIP
RAM_MDIACTIVATE			equ 00200000h	;AIM_MDIACTIVATE
RAM_EDITSELCHANGE		equ 00400000h	;AIM_EDITSELCHANGE
RAM_PROJECTADDNEW		equ 00800000h	;AIM_PROJECTADDNEW
RAM_PROJECTREMOVE		equ 01000000h	;AIM_PROJECTREMOVE
RAM_DLGMNUSELECT		equ 02000000h	;AIM_DLGMNUSELECT
RAM_RCUPDATE			equ 04000000h	;AIM_RCUPDATE
RAM_CREATENEWCTL		equ 08000000h	;AIM_CREATENEWCTL
RAM_TOOLSHOW			equ 10000000h	;AIM_TOOLSHOW
RAM_SETSTYLE			equ 20000000h	;AIM_SETSTYLE
RAM_OUTPUTDBLCLK		equ 40000000h	;AIM_OUTPUTDBLCLK
RAM_CODEINFO			equ 80000000h	;AIM_CODEINFO

;Return values (ecx) from InstallDll procedure which tell RadASM which messages to send to your DllProc procedure,can be OR'ed
RAM_MODULEBUILD			equ 00000001h	;AIM_MODULEBUILD
RAM_DIALOGOPEN			equ 00000002h	;AIM_DIALOGOPEN
RAM_DIALOGSAVE			equ 00000004h	;AIM_DIALOGSAVE
RAM_UNHOOK				equ 00000008h	;AIM_UNHOOK
RAM_ADDINSLOADED		equ 00000010h	;AIM_ADDINSLOADED
RAM_LANGUAGECHANGE		equ 00000020h	;AIM_LANGUAGECHANGE
RAM_PROJECTOPEN			equ 00000040h	;AIM_PROJECTOPEN
RAM_PROJECTRENAME		equ 00000080h	;AIM_PROJECTRENAME

;Structure pointed to on return from AIM_GETHANDLES 
ADDINHANDLES struct
	hWnd				dd	;Handle of mdi Frame
	hMenu				dd	;Handle of mdi Frame Menu
	hToolBar			dd	;Handle of mdi Frame ToolBar
	hStatus				dd	;Handle of mdi Frame StatusBar
	hClient				dd	;Handle of mdi client
	hMdiCld				dd	;Handle of topmost mdi Child window
	hEdit				dd	;Handle of topmost mdi Child RAEdit window
	hDialog				dd	;Handle of topmost mdi Child DialogBox window
	hSearch				dd	;Handle of search / replace dialog
	hGoTo				dd	;Handle of goto dialog
	hOut				dd	;Handle of output Static container
	hPbr				dd	;Handle of project Static container
	hTlb				dd	;Handle of toolbox Static container
	hPrp				dd	;Handle of properties Static container
	hPrpCbo				dd	;Handle of properties ComboBox
	hPrpLst				dd	;Handle of properties ListBox
	hPrpTxt				dd	;Handle of properties item Edit control
	hTxtLst				dd	;Handle of properties item ListBox
	hTxtBtn				dd	;Handle of properties item Button
	hLB					dd	;Handle of Api ListBox (CodeComplete). Same as hLBU or hLBS
	hTlt				dd	;Handle of Api Static (ToolTip)
	hInst				dd	;RadASM instance
	hToolMenu			dd	;Handle of RightClick Menu in project, properties and output window
	hTab				dd	;Handle of tab window
	hPbrTrv				dd	;Handle of project browser TreeView
	hPrpTbr				dd	;Handle of properties ToolBar
	hPbrTbr				dd	;Handle of project / file browser ToolBar
	hFileTrv			dd	;Handle of file browser TreeView
	hOutREd				dd	;Handle of active output RAEdit window
	hOut1				dd	;Handle of output#1 RAEdit window
	hOut2				dd	;Handle of output#2 RAEdit window
	hOut3				dd	;Handle of output#3 RAEdit window
	hOutBtn1			dd	;Handle of output button #1
	hOutBtn2			dd	;Handle of output button #2
	hOutBtn3			dd	;Handle of output button #3
	hDivider			dd	;Handle of divider line
	hSniplet			dd	;Handle of sniplet dialog
	hToolTip			dd	;Handle of toolbox button tooltip
	hLBU				dd	;Handle of unsorted listbox
	hLBS				dd	;Handle of sorted listbox
	hInf				dd	;Handle of infotool static container
	hInfEdt				dd	;Handle of infotool edit control
	hTl1				dd	;Handle of tool#1 static container
	hTl2				dd	;Handle of tool#2 static container
	hHexEd				dd	;Handle of topmost mdi Child RAHexEd window
	hAccel				dd	;RadASM Accelerators
	hTbrIml				dd	;Imagelist for the toolbars
ADDINHANDLES ends

;Structure pointed to on return from AIM_GETPROCS
ADDINPROCS struct
	lpTextOut			dd	;Pointer to proc handeling text to output window. Push pointer to text before calling.
	lpHexOut			dd	;Pointer to proc handeling hex to output window. Use for debug. Push val before calling.
	lpClearOut			dd	;Pointer to proc clearing output
	lpAddProjectFile	dd	;lpFileName,fUpdateTree,fModule
	lpOpenProjectFile	dd	;Give error msg TRUE/FALSE, set lpFile to file to open
	lpToolMessage		dd	;Handle, message, lParam
	lpGetWordFromPos	dd	;Handle of RAEdit, returns pointer to word
	lpProFind			dd	;Pointer to a PROFIND struct
	lpGetWord			dd	;lpWord, returns pointer to word
	lpRemoveProjectPath	dd	;lpFileName, lpBuff, returns pointer to filename
	lpGetMainFile		dd	;lpFileExt
	lpSearchMem			dd	;hMem,lpFind,fMCase,fWWord
	lpProScan			dd	;lpFind,lpNot
	lpBackupEdit		dd	;lpFileName,1
	lpGetFileType		dd	;lpFileName
	lpOutputSelect		dd	;(1,2 or 3)
	lpUpdateCtl			dd	;Handle of control
	lpShowBreakPoint	dd	;Breakpoint ID (0-255)
	lpUpdateVerInf		dd	;TRUE to export to output, FALSE to update rc file
	lpCloseProject		dd	;No parameters
	lpOpenProject		dd	;Parameter TRUE/FALSE, FALSE=Show open file dialog, TRUE=lpFileName set to project file
	lpExportDialog		dd	;Handle of mdi child, Save to rc file TRUE/FALSE 
	lpDllProc			dd	;hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM,fHookFun:DWORD
	lpSetPropertyCbo	dd	;Index of selected
	lpAddTab			dd	;hMdiChild,lpFileName
	lpDelTab			dd	;hMdiChild
	lpSelTab			dd	;hMdiChild
	lpUpdateAll			dd	;Command (IDM_FILE_SAVEALLFILES, IDM_FILE_OPENFILE, IDM_FILE_CLOSEFILE, IDM_OPTION_COLORS, IDM_OPTION_FONT, IDM_OPTION_EDIT, WM_PAINT, IDM_FORMAT_SHOWGRID)
	lpGetFileNameFromID	dd	;nProjectFileID
	lpMenuRebuild		dd	;No parameters
	lpUpdateMRU			dd	;No parameters
	lpUpdateResource	dd	;TRUE to export to output, FALSE to update rc file
	lpUpdateStringTable	dd	;TRUE to export to output, FALSE to update rc file
	lpUpdateAccelerator	dd	;TRUE to export to output, FALSE to update rc file
	lpGetProjectFiles	dd	;Update project treeview, TRUE to auto open files
	lpToolBarStatus		dd	;Updates toolbar button status
	lpUpdateLanguage	dd	;TRUE to export to output, FALSE to update rc file
	lpGetLangString		dd	;lpApp,lpKey,lpStr,nCC
	lpSetLanguage		dd	;hWin,lpApp,fNoResize
	lpModalDialog		dd	;DialogBoxParam
	lpModelessDialog	dd	;CreateDialogParam
	lpUpdateSizeingRect	dd	;hWin, fReadOnly
	lpSaveEdit			dd	;hMdiCld
	lpSaveDialog		dd	;hMdiCld,FALSE
	lpSaveHexEdit		dd	;hMdiCld
ADDINPROCS ends

;Structure pointed to on return from AIM_GETDATA
ADDINDATA struct
	nRadASMVer			dd	;Version
	fMaximized			dd	;If TRUE top menu popups+1
	lpIniFile			dd	;Pointer to radasm.ini file
	lpProject			dd	;Pointer to project file
	lpProjectPath		dd	;Pointer to project path. Includes ending '\'
	lpFile				dd	;Pointer to FileName buffer
	lpApp				dd	;Pointer to App path
	lpBin				dd	;Pointer to Binary path
	lpAddIn				dd	;Pointer to AddIn path
	lpHlp				dd	;Pointer to Help path
	lpIncl				dd	;Pointer to Include path
	lpLib				dd	;Pointer to Library path
	lpPro				dd	;Pointer to Projects path
	lpSnp				dd	;Pointer to Snipplets path
	lpTpl				dd	;Pointer to Templates path
	lpMac				dd	;Pointer to Keyboard Macro path
	lpIniAsmFile		dd	;Pointer to masm/fasm/tasm ini file
	fProject			dd	;If TRUE a project is loaded
	lpLoadPath			dd	;Pointer to path where radasm was loaded
	lpCtlTypes			dd	;Pointer to TYPES struct (dialog edit)
	fResChanged			dd	;If TRUE resources are changed since last compile
	lpBreakPoint		dd	;Pointer to 256 breakpoint structs
	fResProject			dd	;If TRUE project has resource file.
	lpBreakPointVar		dd	;Pointer to breakpoint variables
	AsmFlag				dd	;If TRUE dblclicks in output window opens file.
	lpCharTab			dd	;Pointer to RAEdit's character table
	szAssembler			db	;Assembler type
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
						db
	lpPrpCboItems		dd	;Comma separated string containing property combo items
	fEditMax			dd	;If TRUE open mdi child maximized
	lpProjectFiles		dd	;Pointer to memory block containing project files
	hWordList			dd	;Handle of wordlist memory
	lpWordList			dd	;Pointer to wordlist memory
	rpProjectWordList	dd	;Relative pointer into lpWordList, points to project code properties
	rpWordListPos		dd	;Relative pointer into lpWordList, points to free
	lpAddins			dd	;Pointer to addins structure
	rpStructList		dd	;Relative pointer into lpWordList, points to structures
	lpszAppName			dd	;Pointer to AppName string
	lpDbg				dd	;Pointer to Debug path
	lpCurPro			dd	;Pointer to Current Project path
	lpszAclKeys			dd	;Pointer to accelerator definitions
	UserBtnID			dd	;Pointer to first user button ID
	nAsm				dd	;Current assembler(nMASM, nTASM....)
	fNT					dd	;TRUE if on NT platform
	lpRABlockdef		dd	;Pointer to block defs
ADDINDATA ends

;Addin options
ADDINOPT struct
	lpStr				dd	;Pointer to description string
	nAnd				dd	;AND value
	nOr					dd	;OR value
ADDINOPT ends

