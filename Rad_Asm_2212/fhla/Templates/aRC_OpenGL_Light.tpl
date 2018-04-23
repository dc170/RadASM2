Windows App
aRC_PROJECT
Template using winmain, low resources (by Furious Logic [aRC])
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,0,0,1,1,1,0
1=4,O,porc,1
2=
3=5,O,$B\fhla -w -@ -p:temp -obj:temp "$11" winmain.hla "$1" $R\fhla\Lib\*.lib
4=0,0,,5
5=
6=
7=0,0,$E\OllyDbg,5
[MakeFiles]
0=aRC_PROJECT.rap
1=aRC_PROJECT.rc
2=aRC_PROJECT.asm
3=aRC_PROJECT.obj
4=aRC_PROJECT.res
5=aRC_PROJECT.exe
6=aRC_PROJECT.def
7=aRC_PROJECT.dll
8=aRC_PROJECT.txt
9=aRC_PROJECT.lib
10=aRC_PROJECT.mak
11=aRC_PROJECT.hla
12=aRC_PROJECT
[Resource]
[StringTable]
[VerInf]
[AutoLoad]
1=1
[*ENDDEF*]
[*BEGINTXT*]
WinMain.hla
//	Adapted by Furious Logic [aRC]
//	furiouslogic@eml.cc
//
unit WinMain;
#includeonce ( "winmain.hhf" );

?@NoDisplay		:=	true;
?@NoStackAlign	:=	true;

static
	hInstance	:	dword;
	wc			:	w.WNDCLASSEX;
	msg			:	w.MSG;
	hwnd		:	dword;

procedure W_Main; @external ( "_HLAMain" );

procedure WndProc(	hwnd	: dword;
					uMsg	: uns32;
					wParam	: dword;
					lParam	: dword ); @stdcall;
	begin WndProc;
		mov( uMsg, eax );
		mov( &Dispatch, edx );
		forever
			mov( (type MsgProcPtr_t [edx]).MessageHndlr, ecx );
			if ( ecx = 0 ) then
				w.DefWindowProc( hwnd, uMsg, wParam, lParam );
				exit WndProc;
			elseif( eax = (type MsgProcPtr_t [edx]).MessageValue ) then
				push( hwnd );
				push( wParam );
				push( lParam );
				call( ecx );
				//sub( eax, eax );
				break;
			endif;
			add( @size(MsgProcPtr_t), edx );
		endfor;
	end WndProc;

procedure W_Main;
	begin W_Main;
		w.GetModuleHandle( NULL );
		mov( eax, hInstance );
		w.RtlZeroMemory( &wc, @size(w.WNDCLASSEX) );
		mov( @size(w.WNDCLASSEX), wc.cbSize );
		mov( w.CS_HREDRAW | w.CS_VREDRAW, wc.style );
		mov( &WndProc, wc.lpfnWndProc );
		mov( w.COLOR_BTNFACE+1, wc.hbrBackground );
		mov( ClassName, wc.lpszClassName );
		mov( hInstance, wc.hInstance );
		w.LoadIcon( NULL, val w.IDI_APPLICATION );
		mov( eax, wc.hIcon );
		mov( eax, wc.hIconSm );
		w.LoadCursor( NULL, val w.IDC_ARROW );
		mov( eax, wc.hCursor );
		initWC();
		w.RegisterClassEx( wc );
		appCreateWindow();
		forever
			w.GetMessage( msg, NULL, 0, 0 );
			breakif( eax = 0 );
			w.TranslateMessage( msg );
			w.DispatchMessage( msg );
		endfor;
		mov( msg.wParam, eax );
		w.ExitProcess( 0 );
	end W_Main;
	
end WinMain;
[*ENDTXT*]
[*BEGINTXT*]
aRC_PROJECT.hla
//	RadAsm template:  aRC-Winmain Normal 1.1
//	Created by Furious Logic [aRC]
//	furiouslogic@eml.cc
//
//	It works using only 1 KiB memory !!
//	If it is necessary, increase the heap and stack size.
//	in aRC_PROJECT.link file
//
unit aRC_PROJECT;
#include ( "winmain.hhf" );
#include ( "my_opengl32.hhf" );
//#include ( "opengl32.hhf" );
//#include ( "glu32.hhf" );

?@NoDisplay		:=	true;
?@NoStackAlign	:=	true;

readonly
	ClassName	:	string := "CLASS_NAME";
	AppCaption	:	string := "WINDOW_TITLE";
	Dispatch	:	MsgProcPtr_t; @nostorage;
	MsgProcPtr_t
		// ...
		// Put here your other messages
		// ...
		MsgProcPtr_t : [ w.WM_KEYDOWN,    &proc_Destroy    ],
		MsgProcPtr_t : [ w.WM_ERASEBKGND, &proc_EraseBkgnd ],
		MsgProcPtr_t : [ w.WM_SIZE,       &proc_Size       ],
		MsgProcPtr_t : [ w.WM_PAINT,      &proc_Paint      ],
		MsgProcPtr_t : [ w.WM_DESTROY,    &proc_Destroy    ],
		MsgProcPtr_t : [ 0, NULL ];

static
	pfd			:	w.PIXELFORMATDESCRIPTOR;
	hDC			:	dword;
	hRC			:	dword;

procedure initWC; @noframe;
	begin initWC;
		w.LoadIcon( hInstance, "Icon_App" );
		mov( eax, wc.hIcon );
		mov( eax, wc.hIconSm );
		ret();
	end initWC;

procedure InitOpenGL32; @noframe;
	begin InitOpenGL32;
		w.GetDC( hwnd );
		mov( eax, hDC);
		w.RtlZeroMemory( &pfd, @size(w.PIXELFORMATDESCRIPTOR) );
		mov( @size(w.PIXELFORMATDESCRIPTOR), pfd.nSize );
		mov( 1, pfd.nVersion );
		mov( PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER, pfd.dwFlags );
		mov( PFD_TYPE_RGBA, pfd.iPixelType );
		mov( 8, pfd.cColorBits );
		mov( 8, pfd.cDepthBits );
		mov( PFD_MAIN_PLANE, pfd.iLayerType );
		w.ChoosePixelFormat( hDC, &pfd );
		w.SetPixelFormat( hDC, eax, &pfd );
		wglCreateContext( hDC );
		mov( eax, hRC );
		wglMakeCurrent( hDC, hRC );
		// OpenGL window background color
		glClearColor( 0, 0, 0, 0 );
		ret();
	end InitOpenGL32;

procedure DeInitOpenGL32; @noframe;
	begin DeInitOpenGL32;
		wglMakeCurrent( 0, 0 );
		wglDeleteContext( hRC );
		w.ReleaseDC( hwnd, hDC );
		ret();
	end DeInitOpenGL32;

procedure appCreateWindow; @noframe;
	begin appCreateWindow;
		w.CreateWindowEx(	NULL, ClassName, AppCaption,
							w.WS_SYSMENU | w.WS_VISIBLE,
							150, 210, 400, 300,
							NULL, NULL, hInstance, NULL );
		mov( eax, hwnd );
		InitOpenGL32();
		ret();
	end appCreateWindow;

procedure proc_EraseBkgnd( hwnd: dword; wParam: dword; lParam: dword );
	begin proc_EraseBkgnd;
		mov ( 1, eax );
	end proc_EraseBkgnd;

procedure proc_Size( hwnd: dword; wParam: dword; lParam: dword );
	static
		width  : dword;
		height : dword;
		args   : real32[6] := [ 0, 45.0, 0, 0.1, 0, 100.0 ];
		aspect : real32;
	begin proc_Size;
		mov( lParam, eax );
		mov( eax, ebx );
		and( $FFFF, eax );
		shr( 16, ebx );
		mov( eax, width );
		mov( ebx, height );
		glViewport( 0, 0, width, height );
		finit();
		fild( width );
		fild( height );
		fdivp( st0, st1 );
		fstp( aspect );

		// We don't need status word
		//fwait();

		// Don't use direct values with this function.  Use array or some vars
		gluPerspective( args[0], args[1], 0, aspect, args[2], args[3], args[4], args[5] );
	end proc_Size;

procedure proc_Paint( hwnd: dword; wParam: dword; lParam: dword );
	begin proc_Paint;
		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
		glColor3ub( 0, 255, 0 );
		glBegin( GL_TRIANGLES );
		glVertex3f(  0.5, -0.5, 0.0 );
		glVertex3f(  0.0,  0.5, 0.0 );
		glVertex3f( -0.5, -0.5, 0.0 );
		glEnd();
		w.SwapBuffers( hDC );
	end proc_Paint;

procedure proc_Destroy( hwnd: dword; wParam: dword; lParam: dword );
	begin proc_Destroy;
		DeInitOpenGL32();
		w.PostQuitMessage( 0 );
	end proc_Destroy;

end aRC_PROJECT;
[*ENDTXT*]
[*BEGINTXT*]
my_opengl32.hhf
// My own declarations because I need parameters directly
const
	PFD_TYPE_RGBA		:=	$0000;
	PFD_MAIN_PLANE		:=	$0000;
	PFD_DOUBLEBUFFER	:=	$0001;
	PFD_DRAW_TO_WINDOW	:=	$0004;
	GL_TRIANGLES		:=	$0004;
	PFD_SUPPORT_OPENGL	:=	$0020;
	GL_DEPTH_BUFFER_BIT	:=	$0100;
	GL_COLOR_BUFFER_BIT	:=	$4000;

static
	wglCreateContext	:	procedure( hdc: dword );
							@stdcall; returns( "eax" );
							@external( "__imp__wglCreateContext@4" );
	wglMakeCurrent		:	procedure( hdc: dword; hglrc: dword );
							@stdcall; returns( "eax" );
							@external( "__imp__wglMakeCurrent@8" );
	wglDeleteContext	:	procedure( hdc: dword );
							@stdcall; returns( "eax" );
							@external( "__imp__wglDeleteContext@4" );
	glClearColor		:	procedure( red: dword; green: dword; blue: dword; alpha: dword );
							@stdcall;
							@external( "__imp__glClearColor@16" );
	glClear				:	procedure( mask: dword );
							@stdcall;
							@external( "__imp__glClear@4" );
	glColor3ub			:	procedure( red: byte; green: byte; blue: byte );
							@stdcall;
							@external( "__imp__glColor3ub@12" );
	glViewport			:	procedure( x: int32; y: int32; width: uns32; height: uns32 );
							@stdcall;
							@external( "__imp__glViewport@16" );
	gluPerspective		:	procedure( zero1: real32; fovy : real32; zero2: real32; aspect: real32;
									   zero3: real32; zNear: real32; zero4: real32; zFar  : real32 );
							@stdcall;
							@external( "__imp__gluPerspective@32" );
	glBegin				:	procedure( mode: dword );
							@stdcall;
							@external( "__imp__glBegin@4" );
	glEnd				:	procedure;
							@stdcall;
							@external( "__imp__glEnd@0" );
	glVertex3f			:	procedure( x: real32; y: real32; z: real32 );
							@stdcall;
							@external( "__imp__glVertex3f@12" );
[*ENDTXT*]
[*BEGINTXT*]
aRC_PROJECT.rc
Icon_App	ICON	DISCARDABLE	"./icons/aRCicon2.ico"

[*ENDTXT*]
[*BEGINTXT*]
temp\aRC_PROJECT.link
-heap:0x400,0x400
-stack:0x400,0x400
-base:0x4000000
-entry:HLAMain
-machine:ix86
-section:.text,ER
-section:.data,RW
-merge:.text=.data
-release
-fixed
kernel32.lib
user32.lib
gdi32.lib
[*ENDTXT*]
[*BEGINBIN*]
icons\aRCicon2.ico
0000010001002020100001000400E80200001600000028000000200000004000
0000010004000000000000000000FC010000FC01000010000000000000000202
020002020400020E0400020E060002190800022A0C00022F1000023B10000246
1200025D1800027E230002A02B0002A62F0002B7330002D33A0002EA40000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000002000020002000000020000000200002577
55775446854000467520246877428ABBAAABA77ABA60048AA95479ABBA98BDEE
DDEEB88BEB8205ADD977ACEEEEDBEEEECDEFB99CEB8238BEC969CEEDDEEEFFCA
9ADEC99BEC7349DEB88AEEB99AEFFFD969DEC97CEB845ADDA77BED9539CEFFDA
9ADEC79CEC848BEC958CEC7136ABDEEDDDEFC97CEB759DEB747CEC830458ABDE
EEFFC89CEC97AEDA518CEB73002179ABCDEFC98CEDAACEC9438CEB8200008999
9ADEC89BFEDDEED9338CEC730000BBA969DEC79CFFFEFFEA747CEB830000DEDB
AADEB78CFEDDDEED958CEC810000ADEEDEEDA78CEDA99BEEA78CEB8200008ADE
EECA748BEC7449DEB89CEC730002469BBBA7437CEC8337CEB99BEB8204580356
7653138CEB7318CEB97CEC8127AB00133110118CEC8449DEB77BED9549CE0000
0000038CEDA89BEEA78AEEB99BEF00000000028CFEDDDEEC9659CEEDDDEE0000
0000008BEFEEEECA6116ACEEEEDB00000000026ABCCBBA97411169ABBA980000
0000004578777743100133667633000000000003133331100000013133000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*ENDPRO*]
