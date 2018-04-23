
.386                                                     ; minimum processor
.model flat,stdcall                                      ; win32 application
option casemap:none                                      ; case sensitive

include windows.inc                                      ; win32 structures etc.

incboth macro incl                                       ; macro for lazy coders
  include    incl.inc
  includelib incl.lib
endm

incboth kernel32                                         ; functions from kernel32
incboth user32                                           ; functions from user32
incboth comctl32                                         ; functions from comctl32
incboth gdi32                                            ; functions from gdi32
incboth opengl32                                         ; functions from opengl32
incboth glu32                                            ; functions from glu32


; ** function prototypes
DlgProc           PROTO :HWND,:UINT,:WPARAM,:LPARAM      ; main dialog procedure
myOGL_InitGL      PROTO :DWORD                           ; setup openGL
myOGL_DrawScene   PROTO                                  ; update the openGL scene
myOGL_KillGL      PROTO                                  ; cleanup openGL


; ** uninitialized data
.data?
hInstance            HINSTANCE  ?                        ; application instance
hIcon                HICON      ?                        ; application icon 
hDC                  HDC        ?                        ; device context
hRC                  dd         ?                        ; openGL rendering context
hOGLWindow           HWND       ?                        ; openGL window handle
staticRect           RECT       <?>                      ; dimensions of static openGL "window"


; ** initialized data
.data
szAppName            db "OpenGL in a Box (NeHe Lesson02)- by Pegasus",0 ; dialog caption

;-- Floating point values
n0                   dd  0.0f
n1                   dd  1.0f
n1_5                 dd  1.5f
nm1_5                dd  -1.5f
nm1                  dd  -1.0f
n3                   dd  3.0f
nm6                  dd  -6.0f
; ** constants
.const
IDI_ICON             equ 100                             ; application icon
IDD_DIALOG           equ 1000                            ; dialog resource
IDI_OPENGL           equ 1001                            ; openGL static area
