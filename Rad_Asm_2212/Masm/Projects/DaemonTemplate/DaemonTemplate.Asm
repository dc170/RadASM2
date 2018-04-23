.386
.model flat,stdcall
option casemap:none

	include windows.inc
	include user32.inc
	include kernel32.inc
	include masm32.inc
	include comctl32.inc
	include shell32.inc
   
	include DaemonTemplate.inc   
   
	includelib user32.lib
	includelib kernel32.lib
	includelib masm32.lib
	includelib comctl32.lib
	includelib shell32.lib

	;project related f-ions

	WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
	LogServiceMsg PROTO :DWORD
	LogToFile PROTO str_p:DWORD
	SetStatusPanelText PROTO panelId:DWORD, text:DWORD

	Do_Notify PROTO hParent: DWORD
	Destroy_Notify PROTO hParent: DWORD

	;protected thread function

	Test_WinSock_Interface PROTO
	
.const

	MAIN_MENU_ID equ 600
	MAIN_APP_ICO equ 500
	APP_ICON_32  equ 199
	APP_ICON_16  equ 200
	NotifyIconID EQU 556

	WM_SHOW_UP_FROM_TRAY EQU WM_USER+1
	WM_THREAD_TERMINATE equ WM_USER+2

	THREAD_CLOSE_WATCH  equ 555
	SYSTEM_TIME_WATCH   equ 556
	
    CR_char equ 0Dh
    LF_char equ 0Ah

.data

	ClassName db "DaemonTemplateClass",0
	AppName  db "Win32 Daemon Project",0
	DaemonLogFile db "daemon", ".log", 0
				   
    CR_LF db CR_char, LF_char, 0    

.data?

   hInstance HINSTANCE ?	;application instance
   CommandLine LPSTR ?		;command line ptr

   hListBox dd ?		;handle to Service ListBox
   hStatus dd ?			;handle to Status Window
   hHeap dd ?			;handle to Process Heap
   hThread dd ?			;handle to Thread Function
   hDaemonLogFile dd ?	;handle to Daemon Log File
   hIcon dd ?			;handle of Main Application Icon
   
   ThreadParams dd ?	;thread params - can be anything from var to struct

   app_must_close dd ?	;application signal to final termination 
   
   thread_function_must_terminate  dd ?	;var which must be checked in thread
   thread_terminate_event dd ?			;process event to signal thread function termination

.code

; ---------------------------------------------------------------------------

start:

	mov app_must_close, FALSE
	mov hThread, NULL

	invoke CreateEvent, NULL, FALSE, FALSE, NULL
	mov thread_terminate_event, eax		

	invoke GetProcessHeap
	mov hHeap, eax

	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	
	invoke GetCommandLine
	mov    CommandLine,eax
	
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	LOCAL hm: HMENU
	
	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_BTNFACE+1
	mov   wc.lpszMenuName,NULL
	mov   wc.lpszClassName,OFFSET ClassName
	
    invoke LoadIcon,hInstance, APP_ICON_32
	mov	wc.hIcon,eax
	mov hIcon, eax
    invoke LoadIcon,hInstance, APP_ICON_16
	mov	wc.hIconSm,eax
	
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	
	invoke RegisterClassEx, addr wc
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	
    invoke LoadMenu,hInst, MAIN_MENU_ID
    mov hm, eax
    invoke SetMenu,hwnd,hm
	
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	.WHILE TRUE
		invoke GetMessage, ADDR msg,NULL,0,0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW
	
	mov     eax,msg.wParam
	ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
    LOCAL caW     :DWORD
    LOCAL caH     :DWORD
    LOCAL sbH	  :DWORD
    LOCAL sbParts[ 4] :DWORD
    LOCAL Rct     :RECT
    LOCAL TimeStr[16]: BYTE
    LOCAL systime: SYSTEMTIME
	
	.IF uMsg==WM_DESTROY
		invoke KillTimer, hWnd, THREAD_CLOSE_WATCH
		invoke KillTimer, hWnd, SYSTEM_TIME_WATCH
		invoke Destroy_Notify, hWnd
		invoke CloseHandle, thread_terminate_event			         	          	 	
		invoke CloseHandle, hDaemonLogFile	
		invoke PostQuitMessage,NULL
	
    .elseif uMsg == WM_SHOW_UP_FROM_TRAY
    
      .if lParam == WM_LBUTTONDBLCLK
        invoke ShowWindow, hWnd, SW_SHOW
        invoke ShowWindow, hWnd, SW_RESTORE
      .endif  	    
 
    .elseif uMsg == WM_SYSCOMMAND
	  		  
      .if (wParam == SC_MINIMIZE || (wParam == SC_CLOSE && lParam != 1000 )) ;need to know what caused termination
        invoke ShowWindow, hWnd, SW_HIDE
        return 0
      .else      	  
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
      .endif  	    

	.elseif uMsg == WM_TIMER
	
		.if ( wParam == THREAD_CLOSE_WATCH )
			.if ( thread_function_must_terminate )
			
				invoke PostMessage,hWnd, WM_THREAD_TERMINATE, 0, 0
				   				
			.endif			
		.elseif ( wParam == SYSTEM_TIME_WATCH )
			
		    invoke GetLocalTime, addr systime
			movzx eax, systime.wSecond
			push eax
			movzx eax, systime.wMinute
			push eax
			movzx eax, systime.wHour
			push eax
			movzx eax, systime.wDay
			push eax
			movzx eax, systime.wMonth
			push eax
			movzx eax, systime.wYear
			push eax
	
			szText daemonTimeLogFormat, "%04d-%02d-%02d %02d:%02d:%02d"
	
			push offset daemonTimeLogFormat
			lea eax, TimeStr
			push eax

			call wsprintf
			
			invoke SetStatusPanelText, 0, addr TimeStr
				
		.endif
	
	.elseif uMsg == WM_THREAD_TERMINATE	
		
		invoke WaitForSingleObject, thread_terminate_event, 0
		
		.if ( eax == WAIT_OBJECT_0 )
		
			mov thread_function_must_terminate, FALSE
			invoke LogServiceMsg, StrAddr ( "Thread Function Terminated" )
		
			.if ( app_must_close )
				invoke DestroyWindow, hWnd
			.endif
				
;		.else
			
;			invoke PostMessage,hWnd, WM_THREAD_TERMINATE, 0, 0   

		.endif
		
    .elseif uMsg == WM_CLOSE

   	    invoke MessageBox,hWnd,StrAddr( "Are you sure you want to exit?" ),ADDR AppName,MB_YESNO or MB_ICONQUESTION
       	  .if eax == IDNO
           	return 0			
          .else
          
          	mov app_must_close, TRUE     

          	.if ( hThread )
    	      	mov thread_function_must_terminate, TRUE    	
				invoke PostMessage,hWnd, WM_THREAD_TERMINATE, 0, 0          	
			.else
				invoke DestroyWindow, hWnd          		
          	.endif

			return 0          	
          .endif
   			
	.ELSEIF uMsg==WM_CREATE

	    invoke CreateWindowEx,WS_EX_CLIENTEDGE,StrAddr( "ListBox" ),0,
              WS_VSCROLL or WS_VISIBLE or \
              WS_CHILD or \
              LBS_HASSTRINGS or LBS_NOINTEGRALHEIGHT or LBS_NOTIFY or \
              WS_TABSTOP,
              1,1,100,100,hWnd,100,hInstance,NULL
		mov hListBox, eax              

    	invoke CreateStatusWindow,WS_CHILD or WS_VISIBLE or \
                              SBS_SIZEGRIP,NULL, hWnd, 200
	    mov hStatus, eax
      
	  ; -------------------------------------
	  ; sbParts is a DWORD array of 4 members
	  ; -------------------------------------
    	mov [sbParts +  0], 110
    	mov [sbParts +  4], 420
    	mov [sbParts +  8], -1

    	invoke SendMessage,hStatus,SB_SETPARTS, 3,ADDR sbParts
		
 		invoke CreateFile, addr DaemonLogFile, GENERIC_WRITE,FILE_SHARE_READ,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    	mov hDaemonLogFile, eax  		
		
		invoke SetTimer, hWnd, THREAD_CLOSE_WATCH, 20, NULL
		invoke SetTimer, hWnd, SYSTEM_TIME_WATCH, 200, NULL
		invoke Do_Notify, hWnd
		
		invoke LogServiceMsg, StrAddr ( "Service ready" )		
				
	.elseif uMsg==WM_SIZE
		
		mov eax, lParam
		and eax, 00000FFFFh
		mov caW, eax
		
		mov eax, lParam
		and eax, 0FFFF0000h
		shr eax, 16
		mov caH, eax
	  		
        invoke GetWindowRect,hStatus,ADDR Rct
        mov eax, Rct.bottom
        sub eax, Rct.top
        sub caH, eax

        invoke MoveWindow,hStatus,0,caH,caW,caH,TRUE			

    	invoke GetClientRect,hWnd,ADDR Rct
    	m2m caW, Rct.right
    	m2m caH, Rct.bottom

    	invoke GetWindowRect,hStatus,ADDR Rct
    	mov eax, Rct.bottom
    	sub eax, Rct.top
    	mov sbH, eax

    	mov eax, caH
    	sub eax, sbH
    	mov caH, eax

    	mov Rct.left, 0
    	m2m Rct.top, 0
    	m2m Rct.right, caW
    	m2m Rct.bottom, caH
   
    	invoke MoveWindow,hListBox,Rct.left,Rct.top,Rct.right,Rct.bottom,TRUE
		
	.elseif ( uMsg == WM_COMMAND )     	
		.if wParam == 1000
            invoke SendMessage,hWnd,WM_SYSCOMMAND,SC_CLOSE,1000
		.elseif wParam == 1200

			.if ( !hThread )	
			
				invoke Test_WinSock_Interface

			.endif
							            
		.elseif wParam == 1300

			.if ( hThread )		
				.if ( !thread_function_must_terminate ) 
          			mov thread_function_must_terminate, TRUE    	
					invoke PostMessage,hWnd, WM_THREAD_TERMINATE, 0, 0
				.else
					invoke MessageBox, hWnd, StrAddr ( "Already waiting for termination..." ), addr AppName, MB_OK or MB_ICONINFORMATION
				.endif	
			.endif
				
		.elseif wParam == 1900
            szText AboutMsg,"Daemon Application Template",13,10,\
            "Copyright ® Ulterior 2004"
            invoke ShellAbout,hWnd,ADDR AppName,ADDR AboutMsg,hIcon
		.endif            	
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	
	xor eax,eax
	ret
WndProc endp

LogServiceMsg proc logstr:DWORD 
	
    LOCAL ItemCount  :DWORD
    LOCAL systime:SYSTEMTIME   
    LOCAL tMsgStr [2048]: BYTE

    invoke SendMessage,hListBox,LB_GETCOUNT, 0, 0
    mov ItemCount, eax  
    dec ItemCount	    	

	.if ItemCount > 500
	    invoke SendMessage,hListBox,LB_DELETESTRING, 0, 0
	.endif

    invoke GetLocalTime, addr systime
	push logstr
	movzx eax, systime.wMilliseconds
	push eax
	movzx eax, systime.wSecond
	push eax
	movzx eax, systime.wMinute
	push eax
	movzx eax, systime.wHour
	push eax
	movzx eax, systime.wDay
	push eax
	movzx eax, systime.wMonth
	push eax
	movzx eax, systime.wYear
	push eax
	
	szText fileLogFormat, "%04d-%02d-%02d %02d:%02d:%02d %04d %s"
	
	push offset fileLogFormat
	lea eax, tMsgStr
	push eax

	call wsprintf

    invoke SendMessage,hListBox,LB_ADDSTRING, 0, addr tMsgStr
    invoke SendMessage,hListBox,LB_GETCOUNT, 0, 0
    mov ItemCount, eax  
    dec ItemCount	    	

    invoke SendMessage,hListBox,LB_SETCURSEL,ItemCount,0
    invoke SendMessage,hListBox,LB_SETCARETINDEX,ItemCount,1

	invoke LogToFile, addr tMsgStr

	ret

LogServiceMsg endp

LogToFile PROC str_p:DWORD

	LOCAL hFile: DWORD
	LOCAL fwritten: DWORD
	LOCAL neededLogFilePath[512]: BYTE
    LOCAL currClientPtr: DWORD

	m2m hFile, hDaemonLogFile
		
    invoke SetFilePointer,hFile,0,0,FILE_END

    invoke StrLen, str_p
    mov ebx, eax
    invoke WriteFile,hFile, str_p, ebx, ADDR fwritten,0
    invoke WriteFile,hFile, addr CR_LF, 2, ADDR fwritten,0

	return 0

LogToFile ENDP


SetStatusPanelText proc panelId:DWORD, text:DWORD
 invoke SendMessage,hStatus,SB_SETTEXT,panelId, text
 ret
SetStatusPanelText endp

Do_Notify proc hParent:DWORD

    LOCAL hModule :DWORD
    LOCAL tnid    :NOTIFYICONDATA

    ;----------------------
    ; Create notify icon
    ;----------------------

	m2m tnid.cbSize, SIZEOF NOTIFYICONDATA
    m2m tnid.hwnd, hParent
    m2m tnid.uID, NotifyIconID
    m2m tnid.uFlags, NIF_MESSAGE or NIF_ICON or NIF_TIP
    m2m tnid.uCallbackMessage, WM_SHOW_UP_FROM_TRAY
    invoke lstrcpy, addr tnid.szTip, addr AppName      
    invoke LoadIcon,hInstance,APP_ICON_16
    m2m tnid.hIcon, eax
    invoke Shell_NotifyIcon, NIM_ADD, addr tnid
    invoke DestroyIcon, tnid.hIcon

    ret

Do_Notify endp

Destroy_Notify proc hParent:DWORD

    LOCAL tnid    :NOTIFYICONDATA

    ;----------------------
    ; Create notify icon
    ;----------------------

	m2m tnid.cbSize, SIZEOF NOTIFYICONDATA
    m2m tnid.hwnd, hParent
    m2m tnid.uID, NotifyIconID
    invoke Shell_NotifyIcon, NIM_DELETE, addr tnid

    ret

Destroy_Notify endp

;--------------------------------------------------------------------------
;
; Here is your thread function implementation
;
;--------------------------------------------------------------------------

Test_WinSock_Interface_InThread PROC threadParams: DWORD

	invoke ResetEvent, thread_terminate_event
	invoke LogServiceMsg, StrAddr ( "Thread Function Starts..." )

	;perform any calculations here...

	.while ( !thread_function_must_terminate )
		invoke Sleep, 5000
		invoke LogServiceMsg, StrAddr ( "Tick!" )
	.endw
	
	;end

	invoke LogServiceMsg, StrAddr ( "Thread Function Ends..." )	
	invoke SetEvent, thread_terminate_event

	mov hThread, NULL
	
	ret

Test_WinSock_Interface_InThread endp

Test_WinSock_Interface PROC
	
	LOCAL ThreadId: DWORD
		
	.if ( !hThread )	
		
		invoke CreateThread,0,0, addr Test_WinSock_Interface_InThread, addr ThreadParams, 0, addr ThreadId
		mov hThread, eax
		invoke CloseHandle, eax

	.endif	  
	
	ret

Test_WinSock_Interface endp

end start
