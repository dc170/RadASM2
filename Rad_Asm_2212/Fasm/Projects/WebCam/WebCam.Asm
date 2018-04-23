; +-------------------------------------------+
; | Program ...... FASMCam                    |
; | Author ....... Marcus Araujo              |
; | Description .. this application shows how |
; |                to access webcam via FASM. |
; +-------------------------------------------+


format PE GUI 4.0
entry codestart

include '%fasminc%\win32a.inc'

  IDD_MAIN		       =  100
  WM_CAP_DRIVER_CONNECT        =  WM_USER + 10
  WM_CAP_DRIVER_DISCONNECT     =  WM_USER + 11
  WM_CAP_FILE_SAVEDIB	       =  WM_USER + 25
  WM_CAP_SET_PREVIEW	       =  WM_USER + 50
  WM_CAP_SET_PREVIEWRATE       =  WM_USER + 52
  WM_CAP_SET_SCALE	       =  WM_USER + 53
  ID_START		       =  201
  ID_STOP		       =  202
  ID_CLICK		       =  203
  _camtitle		       db 'FASMWEBCAM'

  _filename  db 'IMAGE.BMP'    ; Filename
  nDevice    dd   0	       ; Device Number -> It can range from 0 through 9
  nFPS	     dd 100	       ; Frames per second. Must be 1000/FPS. E.g. 20 FPS = 50

section '.data' data readable writeable
  hInstance	dd ?
  hWebcam	dd ?

section '.code' code readable executable
  codestart:
    invoke  GetModuleHandle, 0
    mov     [hInstance], eax
    invoke  DialogBoxParam, eax, IDD_MAIN, HWND_DESKTOP, MainDlg, 0
    invoke  ExitProcess, 0

  proc MainDlg, hdlg, msg, wparam, lparam
    push    ebx esi edi
    cmp     [msg], WM_INITDIALOG
    je	    .wminitdlg
    cmp     [msg], WM_COMMAND
    je	    .wmcommand
    cmp     [msg], WM_CLOSE
    je	    .wmclose
    xor     eax, eax
    jmp     .finish
    .wminitdlg:
      invoke  capCreateCaptureWindow, _camtitle, WS_VISIBLE + WS_CHILD, 10, 10,\
					266, 252, [hdlg], 0
      mov     [hWebcam], eax
      jmp     .finish
    .wmcommand:
      cmp     [wparam], BN_CLICKED shl 16 + ID_START
      je      .startbutton
      cmp     [wparam], BN_CLICKED shl 16 + ID_STOP
      je      .stopbutton
      cmp     [wparam], BN_CLICKED shl 16 + ID_CLICK
      je      .clickbutton
      xor     eax, eax
      jmp     .finish
    .wmclose:
      invoke  SendMessage, [hWebcam], WM_CAP_DRIVER_DISCONNECT, _camtitle, 0
      invoke  EndDialog, [hdlg], 0
    .finish:
      pop     edi esi ebx
      return
    .startbutton:
      invoke  SendMessage,  [hWebcam], WM_CAP_DRIVER_CONNECT, [nDevice], 0
      invoke  SendMessage,  [hWebcam], WM_CAP_SET_SCALE, TRUE, 0
      invoke  SendMessage,  [hWebcam], WM_CAP_SET_PREVIEWRATE, [nFPS], 0
      invoke  SendMessage,  [hWebcam], WM_CAP_SET_PREVIEW, TRUE, 0
      jmp     .finish
    .stopbutton:
      invoke  SendMessage, [hWebcam], WM_CAP_DRIVER_DISCONNECT, _camtitle, 0
      jmp     .finish
    .clickbutton:
      invoke  SendMessage, [hWebcam], WM_CAP_FILE_SAVEDIB, 0, _filename
      jmp     .finish
    endp

section '.idata' import data readable writeable

  library kernel, 'KERNEL32.DLL',\
	  user,   'USER32.DLL',\
	  avicap, 'AVICAP32.DLL'

  import  kernel,\
	  GetModuleHandle,'GetModuleHandleA',\
	  ExitProcess,	  'ExitProcess'

  import  user,\
	  DialogBoxParam, 'DialogBoxParamA',\
	  EndDialog,	  'EndDialog',\
	  SendMessage,	  'SendMessageA'

  import  avicap,\
	  capCreateCaptureWindow, 'capCreateCaptureWindowA'

section '.rsrc' resource from 'webcam.res' data readable
