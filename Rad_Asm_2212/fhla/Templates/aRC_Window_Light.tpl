Windows App
aRC_PROJECT
Window template, low resources (by Furious Logic [aRC])
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=0,0,0,1,1,1,0
1=4,O,porc,1
2=
3=5,O,$B\fhla -w -@ -p:temp -obj:temp "$11" "$1" $R\fhla\Lib\*.lib
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
aRC_PROJECT.hla
//	RadAsm template:  aRC-Window Light 1.1
//	Created by Furious Logic [aRC]
//	furiouslogic@eml.cc
//
//	It works using only 1 KiB memory !!
//	If it is necessary, increase the heap and stack size.
//	in aRC_PROJECT.link file
//
unit aRC_PROJECT;
?@NoDisplay		:=	true;
?@NoStackAlign	:=	true;
#include ( "w.hhf" );

static
	hInstance	:	dword;
	wc			:	w.WNDCLASSEX;
	msg			:	w.MSG;
	hwnd		:	dword;
	ClassName	:	string := "CLASS_NAME";
	AppCaption	:	string := "WINDOWS_TITLE";

procedure WinMain; @external ( "_HLAMain" );

procedure WndProc(	hwnd	: dword;
					uMsg	: uns32;
					wParam	: dword;
					lParam	: dword ); @stdcall; @NoDisplay;
	begin WndProc;
		if ( uMsg = w.WM_DESTROY ) then
			w.PostQuitMessage( 0 );
			sub( eax, eax );
		else
			w.DefWindowProc( hwnd, uMsg, wParam, lParam );
		endif;
	end WndProc;

procedure WinMain;
	begin WinMain;
		w.GetModuleHandle( NULL );
		mov( eax, hInstance );
		w.RtlZeroMemory( &wc, @size( w.WNDCLASSEX ) );
		mov( @size( w.WNDCLASSEX ), wc.cbSize );
		mov( w.CS_HREDRAW | w.CS_VREDRAW, wc.style );
		mov( &WndProc, wc.lpfnWndProc );
		mov( w.COLOR_BTNFACE+1, wc.hbrBackground );
		mov( ClassName, wc.lpszClassName );
		mov( hInstance, wc.hInstance );
		w.LoadIcon( hInstance, "Icon_App" );
		mov( eax, wc.hIcon );
		mov( eax, wc.hIconSm );
		w.LoadCursor( NULL, val w.IDC_ARROW );
		mov( eax, wc.hCursor );
		w.RegisterClassEx( wc );
		w.CreateWindowEx(	NULL, ClassName, AppCaption,
							w.WS_SYSMENU | w.WS_VISIBLE,
							250,150,400,300,
							0,0,hInstance,NULL );
		mov( eax, hwnd );
		forever
			w.GetMessage( msg, NULL, 0, 0 );
			breakif( eax = 0 );
			w.TranslateMessage( msg );
			w.DispatchMessage( msg );
		endfor;
		mov( msg.wParam, eax );
		w.ExitProcess( 0 );
	end WinMain;

end aRC_PROJECT;
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
