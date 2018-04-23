
include DlgOGLNehe02.inc                                    ; needed header

.code
start:                                                   ; entry point
  invoke  GetModuleHandle,NULL                           ; get a module handle
  mov     hInstance,eax                                  ; and store it
  invoke  InitCommonControls                             ; init treeview usage
  invoke  DialogBoxParam,hInstance,IDD_DIALOG,NULL,offset DlgProc,NULL
  invoke  ExitProcess,NULL                               ; cleanup and kill process
DlgProc      proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
  .if     uMsg==WM_INITDIALOG                            ; WM_INITDIALOG
    invoke  ShowWindow,hWin,SW_MINIMIZE                  ; pop up effect
    invoke  LoadIcon,hInstance,IDI_ICON                  ; set application icon
    mov     hIcon,eax                                    ; and store it's handle
    invoke  SendMessage,hWin,WM_SETICON,1,hIcon          ; show the icon
    invoke  SendMessage,hWin,WM_SETTEXT,0,offset szAppName ; show application name
    invoke  ShowWindow,hWin,SW_SHOWNORMAL                ; show the final dialog 
    invoke  myOGL_InitGL,hWin
    invoke  SetTimer,hWin,1,10,NULL                      ; setup a timer

  .elseif uMsg==WM_TIMER                                 ; WM_TIMER
    invoke  myOGL_DrawScene                              ; redraw openGL scene

  .elseif uMsg==WM_CLOSE                                 ; WM_CLOSE
    invoke  ShowWindow,hWin,SW_MINIMIZE                  ; minimize the window to taskbar
    invoke  KillTimer,hWin,1                             ; delete timer
    invoke  myOGL_KillGL                                 ; delete openGL crap
    invoke  ReleaseDC,hWin,hDC                           ; release device context
    invoke  EndDialog,hWin,0                             ; end the dialog

  .elseif uMsg==WM_COMMAND                               ; WM_COMMAND
    nop                                                  ; do nothing

  .else
    mov     eax,FALSE                                    ; delete unhandeled message
    ret                                                  ; and continue
  .endif
  mov    eax,TRUE                                        ; message handled with success
  ret                                                    ; and continue
DlgProc      endp			

myOGL_InitGL proc theWindowHandle:DWORD
  LOCAL    pfd:PIXELFORMATDESCRIPTOR                     ; ...
  LOCAL    PixelFormat:DWORD                             ; correct pixelformat for static window
  pushad                                                 ; store all registers
  mov     pfd.nSize,sizeof PIXELFORMATDESCRIPTOR         ; setup pixelformatdescriptor struct
  mov     pfd.nVersion,1
  mov     pfd.dwFlags, PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER
  mov     pfd.iPixelType, PFD_TYPE_RGBA
  mov     pfd.cColorBits, 16
  mov     pfd.cDepthBits, 16
  mov     pfd.dwLayerMask, PFD_MAIN_PLANE
  invoke  GetDlgItem,theWindowHandle,IDI_OPENGL          ; the static item which shows openGL
  mov     hOGLWindow,eax                                 ; store it's handle
  invoke  GetDC,hOGLWindow                               ; get the device context
  mov     hDC,eax                                        ; and store it
  invoke  GetClientRect,hOGLWindow,addr staticRect       ; we need the dimensions of the static
  invoke  ChoosePixelFormat, hDC, ADDR pfd               ; and the correct pixelformat
  mov     PixelFormat,eax                                ; thats the correct one
  invoke  SetPixelFormat, hDC, PixelFormat, ADDR pfd     ; so set it!
  invoke  wglCreateContext, hDC                          ; create rendering context
  mov     hRC, eax                                       ; store the handle
  invoke  wglMakeCurrent, hDC, hRC                       ; it's our OpenGL context
  invoke  glViewport, 0, 0, staticRect.right, staticRect.bottom  ;reset viewport
  invoke  glMatrixMode, GL_PROJECTION                    ; select projection matrix
  invoke  glLoadIdentity                                 ; reset it
  push    40590000h                                      ; 100.0f
  push    0                                              ; double
  push    3FB99999h                                      ; 0.1f
  push    9999999Ah                                      ; double
  fild    staticRect.right
  fidiv   staticRect.bottom                              ; dividing width by height and
  sub     esp,8                                          ; pushing it on the
  fstp    qword ptr [esp]                                ; stack as a double
  push    40468000h                                      ; 45.0f
  push    0                                              ; double
  call    gluPerspective
  invoke  glMatrixMode, GL_MODELVIEW                     ; select modelview matrix
  invoke  glLoadIdentity                                 ; reset it
  invoke  glShadeModel,GL_SMOOTH                         ; Enable Smooth Shading
  invoke  glClearColor,0,0,0,0                           ; Black Background
  invoke  glClearDepth,0,3FF00000h                       ; Depth Buffer Setup
  invoke  glEnable,GL_DEPTH_TEST                         ; Enables Depth Testing
  invoke  glDepthFunc,GL_LEQUAL                          ; The Type Of Depth Testing To Do
  invoke  glHint,GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST; Really Nice Perspective Calculations
  popad                                                  ; retore all registers
  ret                                                    ; return to caller
myOGL_InitGL endp

myOGL_DrawScene proc
  pushad                                                 ; store all registers
  invoke  glClear,GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT ; Clear Screen And Depth Buffer
  invoke  glLoadIdentity                                 ; Reset The Current Modelview Matrix
  ; -- draw the triangle
  invoke  glTranslatef,dword ptr [nm1_5],dword ptr [n0],dword ptr [nm6]
  invoke  glBegin, GL_TRIANGLES                          ; start
  invoke  glVertex3f, dword ptr [n0],dword ptr [n1],dword ptr [n0]
  invoke  glVertex3f, dword ptr [nm1],dword ptr [nm1],dword ptr [n0]
  invoke  glVertex3f, dword ptr [n1],dword ptr [nm1],dword ptr [n0]
  invoke  glEnd                                          ; end

  ; -- draw the quad
  invoke  glTranslatef,dword ptr [n3],dword ptr [n0],dword ptr [n0]
  invoke  glBegin, GL_QUADS                              ; start
  invoke  glVertex3f, dword ptr [nm1],dword ptr [n1],dword ptr [n0]
  invoke  glVertex3f, dword ptr [n1],dword ptr [n1],dword ptr [n0]
  invoke  glVertex3f, dword ptr [n1],dword ptr [nm1],dword ptr [n0]
  invoke  glVertex3f, dword ptr [nm1],dword ptr [nm1],dword ptr [n0]
  invoke  glEnd                                          ; end 
  invoke  SwapBuffers, hDC                               ; show the result
  popad                                                  ; restore all registers
  ret                                                    ; return to caller
myOGL_DrawScene endp

myOGL_KillGL proc
  pushad
  invoke  wglMakeCurrent,NULL,NULL
  invoke  wglDeleteContext,hRC
  popad
  ret
myOGL_KillGL endp
end start                                                ; end of application
