Win32 App
ServiceApp
Simple Template for creating Service
-
Based on sample by Cynical Pinnacle
Eviloid, 2oo2
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,0,1,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\ML.EXE /c /coff /DMASM /Cp /nologo /I"$I",2
3=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /LIBPATH:"$L",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\ML.EXE /c /coff /DMASM /Cp /nologo /I"$I",*.asm
7=0,0,"$E\OllyDbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\ML.EXE /c /coff /Zi /Zd /DMASM /DDEBUG /Cp /nologo /I"$I",2
13=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /INCREMENTAL:NO /PDB:NONE /DEBUG /LIBPATH:"$L",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\ML.EXE /c /coff /Zi /Zd /DMASM /DDEBUG /Cp /nologo /I"$I",*.asm
17=0,0,"$E\OllyDbg",5
[VerInf]
[Resource]
[*ENDDEF*]
[*BEGINTXT*]
ServiceApp.Asm
; This is a sample of how to make a service
; in NT.  Being a service means you are
; automatically started by the system,
; cannot be terminated through kill or the
; taskmanager, and survives logons and logoffs.
; All this service does is beep but anything
; could be done.

; ******************  Win95 note ************************
; * Under 95 (as always) the situation is different,    *
; * The whole of the 95 Service API consists of         *
; * one function RegisterServiceProcess and one         *
; * registry entry                                      *
; *                                                     *
; * HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\      *
; *    CurrentVersion\RunServices                       *
; *                                                     *
; * in which you make a string value name="path to exe".*
; * 95 will autostart your service and allow it to      *
; * survive logons and logoffs but it is just a         *
; * normal process and can be killed through            *
; * a decent taskmanager (which 95 does not have)       *
; * or tlist and Kill.                                  *
; *******************************************************

Include ServiceApp.Inc

; Implementation ========================================
.Code
Start:
; Register with the SCM
  mov sTable.lpServiceProc, offset ServiceMain
  mov sTable.lpServiceName, offset SERVICE_NAME
  invoke StartServiceCtrlDispatcher, addr sTable

  .if !( eax )
    invoke ErrorHandler, addr ERROR_MESSAGE
  .endif

  xor eax, eax
  invoke ExitProcess, eax


; =======================================================
; This is the function that does all of the
; work.
;
Thread Proc param:DWORD
;{
  .while (1)    ; Infinite Loop
  ;{

; ... put your code here ...
;    invoke Beep, 100, 200
    invoke Sleep, DELAY
  ;}
  .endw
  xor eax, eax
  ret
;}
Thread EndP

;========================================================
; Initializes the service by starting its thread
;
InitService Proc
;{
  LOCAL id:DWORD

  invoke CreateThread, 0, 0, Thread, 0, 0, addr id
  mov hThread, eax
  .if ( eax )
  ;{
    mov fRunning, TRUE
    mov eax, 1
  ;}
  .endif
  ret
;}
InitService EndP

;========================================================
; Resumes a paused service
;
ResumeService Proc
;{
  mov fPaused, FALSE
  invoke ResumeThread, hThread
  ret
;}
ResumeService EndP

;========================================================
; Pauses the service
;
PauseService Proc
;{
  mov fPaused, TRUE
  invoke SuspendThread, hThread
  ret
;}
PauseService EndP

;========================================================
; Stops the service by allowing ServiceMain to complete
;
StopService Proc
;{
  mov fRunning, FALSE
  ; This will release ServiceMain
  ;
  invoke SetEvent, evTerminate
  ret
;}
StopService EndP

;========================================================
ErrorHandler Proc szMessage:DWORD
;{
  invoke MessageBox, NULL, szMessage, addr SERVICE_NAME, MB_OK or MB_ICONERROR
;  invoke ExitProcess, 0
  ret
;}
ErrorHandler EndP

;========================================================
; This function consolidates the activities of
; updating the service status with SetsStatus.
; More overhead for the programmer because Micro$oft
; doesn't make quality code.
;
SendStatus Proc dwCurrentState:DWORD, dwWin32ExitCode:DWORD, dwServiceSpecificExitCode:DWORD,
                dwCheckPoint:DWORD, dwWaitHint:DWORD
;{
  LOCAL success:BOOL

  mov sStatus.dwServiceType, SERVICE_WIN32_OWN_PROCESS
  m2m sStatus.dwCurrentState, dwCurrentState

  .if ( dwCurrentState == SERVICE_START_PENDING )
  ;{
    mov sStatus.dwControlsAccepted, 0
  ;}
  .else
  ;{
    mov sStatus.dwControlsAccepted, SERVICE_ACCEPT_STOP or SERVICE_ACCEPT_PAUSE_CONTINUE or \
                                    SERVICE_ACCEPT_SHUTDOWN
  ;}
  .endif

  .if ( dwServiceSpecificExitCode == 0 )
  ;{
    m2m sStatus.dwWin32ExitCode, dwWin32ExitCode
  .else
  ;{
    mov sStatus.dwWin32ExitCode, ERROR_SERVICE_SPECIFIC_ERROR
  ;}
  .endif

   m2m sStatus.dwServiceSpecificExitCode, dwServiceSpecificExitCode
   m2m sStatus.dwCheckPoint, dwCheckPoint
   m2m sStatus.dwWaitHint, dwWaitHint

   ; Pass the status record to the SCM
   ;
   invoke SetServiceStatus, hStatus, ADDR sStatus
;   mov eax, 1
   return 1
;}
SendStatus EndP


;========================================================
; Dispatches events received from the service
; control manager
;
CtrlHandler Proc controlCode:DWORD
;{
  LOCAL currentState:DWORD
  LOCAL success:BOOL

  mov currentState, 0
  mov eax, controlCode

  .if ( eax == SERVICE_CONTROL_STOP )
  ;{
    mov currentState, SERVICE_STOP_PENDING
    ; Tell the SCM what's happening
    ;
    invoke SendStatus, SERVICE_STOP_PENDING, NO_ERROR, 0, 1, 5000

    ; Not much to do if not successful
    ; Stop the service
    call StopService
    ret
  ;}

  ; Pause the service
  ;
  .elseif ( eax == SERVICE_CONTROL_PAUSE )
  ;{
    .if ( fRunning != FALSE && fPaused == FALSE )
    ;{
    ; Tell the SCM what's happening
    ;
      invoke SendStatus, SERVICE_PAUSE_PENDING, NO_ERROR, 0, 1, 1000
      call PauseService
      mov  currentState, SERVICE_PAUSED;
      jmp SCHandler
    ;}
    .endif
  ;}

  ;Resume from a pause
  ;
  .elseif ( eax == SERVICE_CONTROL_CONTINUE )
  ;{
    .if ( fRunning != FALSE && fPaused == TRUE )
    ;{
    ; Tell the SCM what's happening
    ;
      invoke SendStatus, SERVICE_CONTINUE_PENDING, NO_ERROR, 0, 1, 1000
      call ResumeService
      mov currentState, SERVICE_RUNNING
      jmp SCHandler
    ;}
    .endif
  ;}

  ;Update current status
  ;
  .elseif ( eax == SERVICE_CONTROL_INTERROGATE )
  ;{
    ; it will fall to bottom and send status
    ; Do nothing in a shutdown. Could do cleanup
    ; here but it must be very quick.
    ;

  ;}
  .elseif ( eax == SERVICE_CONTROL_SHUTDOWN )
  ;{
    ; Do nothing on shutdown
    ret
  ;}
  .endif

SCHandler:
  invoke SendStatus, currentState, NO_ERROR, 0, 0, 0
  ret
CtrlHandler EndP

;========================================================
; Handle an error from ServiceMain by cleaning up and
; telling SCM that the service didn't start.
Terminate proc error:DWORD
;{
  ; if evTerminate has been created, close it.
  ;
  .if ( evTerminate )
  ;{
    push evTerminate
    call CloseHandle
  .endif

  ; Send a message to the scm to tell about stopage
  ;
  .if ( hStatus )
  ;{
    invoke SendStatus, SERVICE_STOPPED, error, 0, 0, 0
  ;}
  .endif

  ; If the thread has started kill it off
  ;
  .if ( hThread )
  ;{
    push hThread
    call CloseHandle
  ;}
  .endif

  ; Do not need to close hStatus
  ret
Terminate EndP

;========================================================
; ServiceMain is called when the SCM wants to start
; the service. When it returns, the service has stopped.
; It therefore waits on an event just before the end of
; the function, and that event gets set when it is time
; to stop.
; It also returns on any error because the service cannot
; start if there is an eror.
;
ServiceMain Proc argc:DWORD, argv:DWORD
;{
  LOCAL success:BOOL
  LOCAL temp:DWORD

  ; immediately call Registration function
  ;
  invoke RegisterServiceCtrlHandler, addr SERVICE_NAME,  CtrlHandler
  mov hStatus, eax

  .if !( eax )
  ;{
    call GetLastError
    invoke Terminate, eax
    ret
  ;}
  .endif

  ; Notify SCM of progress
  ;
  invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 1, 5000

  ; create the termination event
  ;
  invoke CreateEvent, 0, TRUE, FALSE, 0
  mov evTerminate, eax

  .if !( eax )
  ;{
    call GetLastError
    invoke Terminate, eax
    ret
  ;}
  .endif

  ; Notify SCM of progress
  ;
  invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 2, 1000

  ; Notify SCM of progress
  ;
  invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 3, 5000

  ; Start the service itself
  ;
  call InitService
  mov success, eax
  .if !( eax )
  ;{
    call GetLastError
    invoke Terminate, eax
    ret
  ;}
  .endif

  ; Notify SCM of progress
  invoke SendStatus, SERVICE_RUNNING, NO_ERROR, 0, 0, 0

  ; Wait for stop signal, and then terminate
  ;
  invoke WaitForSingleObject, evTerminate, INFINITE
  invoke Terminate, 0
  ret
;}
ServiceMain EndP

;========================================================
End Start

[*ENDTXT*]
[*BEGINTXT*]
ServiceApp.Inc
.386
.Model Flat,StdCall   ; 32 bit memory model
Option Scoped         ; local labels are enabled, global labels inside
                      ; PROC should be defined with double colons (LABEL::)
Option CaseMap:None   ; case sensitive

Include windows.inc
Include kernel32.inc
Include user32.inc
Include advapi32.inc

IncludeLib kernel32.lib
IncludeLib user32.lib
IncludeLib advapi32.lib


; PROTOS  ===============================================

;VOID ServiceMain(DWORD argc, LPTSTR *argv)
ServiceMain Proto :DWORD,:DWORD

;VOID Terminate(DWORD error)
Terminate Proto :DWORD

;VOID ServiceCtrlHandler (DWORD controlCode)
ServiceCtrlHandler Proto :DWORD

;BOOL SendStatusToSCM (DWORD dwCurrentState,
;                      DWORD dwWin32ExitCode,
;                      DWORD dwServiceSpecificExitCode,
;                      DWORD dwCheckPoint,
;                      DWORD dwWaitHint)
SendStatusToSCM Proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD

;VOID StopService()
StopService Proto

;VOID PauseService()
PauseService Proto

;VOID ResumeService()
ResumeService Proto

;BOOL InitService()
InitService Proto

;void ErrorHandler(char *s, DWORD err)
ErrorHandler Proto :DWORD

;DWORD ServiceThread(LPDWORD param)
ServiceThread Proto :DWORD


; Read-only data ========================================
.Const

DELAY equ 2000

; Initialized data ======================================
.Data

; The name of the service
;
SERVICE_NAME BYTE "SimpleService", 0
ERROR_MESSAGE BYTE "In StartServiceCtrlDispatcher", 0

; Flags holding current state of service
;
fPaused BOOL FALSE
fRunning BOOL FALSE


; Non-initialized data ==================================
.Data?

; Thread for the actual work
;
hThread HANDLE ?

; Event used to hold ServiceMain from completing
;
evTerminate HANDLE ?

szBuffer db MAX_PATH dup(?)

; Handle used to communicate status info with
; the SCM. Created by RegisterServiceCtrlHandler
;
hStatus DWORD ?
sStatus SERVICE_STATUS <>
;
sTable SERVICE_TABLE_ENTRY <>

; This next one is unused but here for the zeros
; Because the table must be null terminated.
; Each exe can contain multiple services
; just add them here as tables.
;
sTable2 SERVICE_TABLE_ENTRY <>
[*ENDTXT*]
[*BEGINTXT*]
ReadMe.Txt

TUTORIAL FOR ASM WINDOWS NT SERVICE:

     Many people are familiar with device drivers and their
advantage at being autostarted by the system and getting
Ring 0 privilege.  But with that privilege comes complexity
in both the planning and development phase.  Microsoft's
tendency to be less than forthcoming with information makes
the task all the harder.  By contrast many of us are
familiar with programming at Ring 3 and the documentation of
the Win32 API is extensive.  Wouldn't it be nice to combine
the characteristics of a driver with the familiarity of
regular Ring 3 Apps.  Services are Microsoft's attempt to
create such a beast.  They gain the advantage of being
autostarted by the system while keeping the familiarity of
normal Ring 3 programming.

     NOTE: I am restricting this discussion to NT because
services under Win95/98 are an afterthought.  The support
consists of a registry entry under (
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersio
n\RunServices ) and one API function RegisterServiceProcess.
Creating a Win95 version of a service is left as an exercise
for the reader.

INSTALLING THE SERVICE:

I have included a program to install and remove a
service from the SCM Database.  A step which is necessary
before a service can be run.

To install the service:
   stool /i beepserv "ASM Beepservice" path\beepserv.exe
   Then goto the service applet of the Control panel and
find the ASM Beepservice click on it and it should start.

To remove the service:
   stool /r beepserv


INTRO:

     Services are simply normal programs with two threads.
One thread is the worker which performs whatever actions you
desire.  The second is there to communicate with the OS,
which will inform it when to Start, Stop, Pause,
Initialize, and Terminate.  Just like any other program a
Service has an entry point here named start but it could be
the infamous main.


;********************************************************
.code
start:
   ;Register with the SCM
   mov sTable.lpServiceProc, offset ServiceMain
   mov eax, offset SERVICE_NAME
   mov sTable.lpServiceName, eax
   invoke StartServiceCtrlDispatcher, ADDR sTable

   .if eax == 0
     invoke ErrorHandler, ADDR ERROR_MESSAGE
   .endif

   xor eax, eax
   invoke ExitProcess, eax

;********************************************************


This snippet of code does nothing but call
StartServiceCtrlDispatcher and Exit.  So where is the
Service?  Hidden behind StartServiceCtrlDispatcher.
Basically start calls this function and does not
return until the System tells the Service to terminate or
there is a fatal error within the Service and it is
terminated by the SCM.  When the SCM receives this call it
registers the Service with name SERVICE_NAME and associates
it with the function ServiceMain.  The SCM then calls the
ServiceMain function (the service's entry point).


SERVICEMAIN:

The ServiceMain function does a number of things and here it
is in stripped down form.

;********************************************************
ServiceMain proc argc:DWORD, argv:DWORD
   LOCAL success:BOOL
   LOCAL temp:DWORD

   ;immediately call Registration function
   invoke RegisterServiceCtrlHandler, ADDR SERVICE_NAME,  CtrlHandler

   ;Notify SCM of progress
   invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 1, 5000

   ;create the termination event
   invoke CreateEvent, 0, TRUE, FALSE, 0

   ;Notify SCM of progress
   invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 2, 1000

   ;Notify SCM of progress
   invoke SendStatus, SERVICE_START_PENDING, NO_ERROR, 0, 3, 5000

   ;Start the service itself
   call Init

   ;Notify SCM of progress
   invoke SendStatus, SERVICE_RUNNING, NO_ERROR, 0, 0, 0

   ;Wait for stop signal, and then terminate
   invoke WaitForSingleObject, evTerminate, INFINITE

   push 0
   call terminate
   ret
ServiceMain endp
;********************************************************

This function is responsible for registration and
initialization.  The first thing it does is register the
Service Control Handler.  This is essentially a dispatch
routine which receives and responds to request by the SCM to
start, stop, pause, terminate, and tell me a little about
yourself.  The next thing you see is a call to SendStatus
(many calls to it actually).  All this function does is tell
the SCM that the service is still running, is step n in its
initialization, informs the SCM of what the status of the
service is, and that it expects to send its status again
within so many milliseconds ( 2000-5000 in the example above
).  The next thing that is done is to create an Event.  The
purpose the Event is to prevent the ServiceMain from
terminating (Notice the WaitForSingleObject call ) until the
Event gets set.  The Event gets set in the Stop function
which is called by the CtrlHandler.


CTRLHANDLER:

The next function to examine is the CtrlHandler function.
The CtrlHandler function is the interface to the SCM and
behaves just like the familiar Message handling procedure in
Windows.  The CtrlHandler function is under some
restrictions as to how it can behave and how long it has to
respond to the SCM.  Here are the various notes and rules.

1) Must accept and process the SERVICE_CONTROL_INTERROGATE
control code.

2) Process messages in less than 30 seconds.

3) After receiving the SERVICE_CONTROL_SHUTDOWN control code
the service has 20 seconds ( see 5 below ) before the system
shuts down.

4) Services continue to run even after the Restart Dialog
box appears, but there is no system.  Hmmmm walk lightly
carry and exception at this point.

5) There is a registry key under
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control with a
value WaitToKillServiceTimeout which specifies how long a
service has after receiving the SERVICE_CONTROL_SHUTDOWN
control code the default is 20 sec.

Other than the above rules the CtrlHandler is also
responsible for performing any actions necessary to respond
to the control codes sent to it.


NOTES:

     Strangely by default services run under their own desktop.
This is controled through the SERVICE_INTERACTIVE_PROCESS
flag to the dwServiceType parameter of the CreateService
function.  Unless this flag is set the service cannot
interact with the users desktop.  This means no GUI no
dialog boxes.  Only the MessageBox function will work and
only with the MB_SERVICE_NOTIFICATION flag set.  This can be
a source of great frustration (personal experience here).

     That about sums it up.  Enjoy having this useful
technique at your disposal.


                         Cynical Pinnacle

[*ENDTXT*]
[*ENDPRO*]
[*BEGINBIN*]
stool.exe
4D5A90000300000004000000FFFF0000B8000000000000004000000000000000
0000000000000000000000000000000000000000000000000000000060000000
0E1FBA0E00B409CD21B8014CCD2157696E646F77732050726F6772616D0D0A24
504500004C010300000000000000000000000000E0000F010B01000000040000
0006000000000000005000000010000000200000000040000010000000020000
0400000004000000040000000000000000600000000400000000000003000000
0000100000100000000010000010000000000000100000000000000000000000
F45000006B000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000074000000
00300000001000000000000000000000000000000000000000000000E00000C0
00000000746100000010000000400000D5030000000400000000000000000000
00000000E00000C0000000006100000000100000005000000002000000020000
000000000000000000000000E00000C004040100842240000200000000000000
0000000000000000000000000000000000000000000000002E64617461000000
BBD0014000BF00104000BE0040400053E80A00000002D275058A164612D2C3FC
B280A46A025BFF142473F733C9FF1424731833C0FF14247321B30241B010FF14
2412C073F9753FAAEBDCE8430000002BCB7510E838000000EB28ACD1E8744113
C9EB1C9148C1E008ACE8220000003D007D0000730A80FC05730683F87F770241
41958BC5B301568BF72BF0F3A45EEB9633C941FF54240413C9FF54240472F4C3
5F5B0FB73B4F74084F7413C1E70CEB078B7B025783C3044343E951FFFFFF5FBB
28514000478B37AF57FF139533C0AE75FDFE0F74EFFE0F750647FF37AFEB09FE
0F0F8430C1FFFF5755FF53040906AD75DB8BECC31C5100000000000000000000
3451000028510000000000000000000000000000000000000000000040510000
4E51000000000000405100004E510000000000004B45524E454C33322E646C6C
00004C6F61644C69627261727941000047657450726F634164647265737300EB
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
55078BECE8E4020E0E5020FF750868DD38204075E030C60AE8DC290583C4106A
0C220FFD2EADB00BB1612EF86A9156C31BE8E625E74FDB082216C9008945F80B
C0750A6850F51CA26DFF02341902B3BC9801FB03FF6768AEEC0F1D0CD8DF06F8
E8548637FC8B11D40621336B6FEBE36A288A170E6C853F4EFCF053AB08225E4B
C8FBD1446942C9C20CB193DC0A2153C4363C2BA14E0FA3B980A27D421BD9423C
08EE40FE8D1445DC50732204891A4B08D488837D00E00174326A0E6861A112EA
F341402C04D70F2EB8D1C87744A65E9BF427D38EAD62C1A4A220740EA4D98923
AC3221EB189B1178A05D242B6E01E51E6621C784C84404241BD019BBF0C87D08
AC0E3C2074FB8E228A0B090C110AAE493DEBF5E6210617423E421F3C173F0DB0
2F272B478B28DFAA1561151B11EBF4A01F2E44080363AA1E4E32C7608BC72BC3
248843791BC41949DF05CA87988A803D0B3803747D8D3501001333D28B0625FF
5FC3223D2F52322D080E49007560423300C98A4EFF03F1803EC0285346893504
6031560BD2750D54FF0AE85459E2EB576B22223145081C1120890C17FA066408
34443B8BFD4930227550202775083E3E0F265E00680C32309C115D18A9844451
333CC050300111CCFF256C2C290C248643287B86434821089014C80C6E10C818
64103204291965E020EDF555E8F72535EE41FBEA3527DFFB3D8709B3CF21163E
9E0815422213E46A5D1F7749999B6E223E250A0FB745F237911224586A1408A2
88346438323C19300DEB600C0000A501F600546F20696E737461716C1C3A0D0A
1E097FF1F420392F498022736572766963EBF06E617A6DFB4A0F3E64FAEDEBC9
7074F06F6EDE2D1E615D68B76693657868487C4C1E72DF6DDF76E94B64527D99
3553DC72BF821B672E023C1D45AB640C8C25730A457172736FC358756D623C6E
3A0C256C643149FFE44F70FFD45363334D618A6740301143DBD6FCDA53935C85
340829CCFA9F3622118634C61F5175185379104597CBFA73A39E6F708C4A20B7
E89AC87120F350749B6CAF7223F221709F4474F62D95800001712070400E4B45
524E604C33322E64716CE056E865E270E04AEA741C436F6D41616E644C69D3E2
418F103F5D730E45722E6F7C07487869E650121C636573783F5AEF180E469A6A
10336E73E7861653637288F442387566FBF249F1D96F431B53916448B29D5156
167D547B787D41FD8D84627588C16FBDBE66286ED82A014894285553958E9218
7A7370466E746E663511773D44561450491CC6476566CC7853D07651698FC054
75CA12790D6CE261E5FE83A0466C46B020478128469EF35D348DAA5270EA1C0D
46A29A08869B2351221C37434D70266724CC3C03000000000000000000000000
[*ENDBIN*]
[*BEGINTXT*]
InstallService.cmd
@echo.
@echo Please, correct this file !!!
@echo.
::stool /i ServiceName "Service Description" X:\FULL\PATH\ServiceFile.exe
[*ENDTXT*]
[*BEGINTXT*]
RemoveService.cmd
@echo.
@echo Please, correct this file !!!
@echo.
::stool /r ServiceName
[*ENDTXT*]
