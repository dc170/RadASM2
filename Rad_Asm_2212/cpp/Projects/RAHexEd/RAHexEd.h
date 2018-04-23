// RadHexEdit Styles
#define STYLE_NOSPLITT			0x01  			// No splitt button
#define STYLE_NOLINENUMBER		0x02  			// No linenumber button
#define STYLE_NOHSCROLL			0x04  			// No horizontal scrollbar
#define STYLE_NOVSCROLL			0x08  			// No vertical scrollbar
#define STYLE_NOSIZEGRIP		0x10  			// No size grip
#define STYLE_NOSTATE			0x20  			// No state indicator
#define STYLE_NOADDRESS			0x40  			// No adress field
#define STYLE_NOASCII			0x80  			// No ascii field
#define STYLE_NOUPPERCASE		0x100 			// Hex numbers is lowercase letters
#define STYLE_READONLY			0x200 			// Text is locked

// Private messages
#define HEM_RAINIT				WM_USER+9999	// wParam=0, lParam=pointer to controls DIALOG struct
#define HEM_BASE				WM_USER+1000

#define HEM_SETFONT				HEM_BASE+1		// wParam=nLineSpacing, lParam=lpRAFONT
#define HEM_GETFONT				HEM_BASE+2		// wParam=0, lParam=lpRAFONT
#define HEM_SETCOLOR			HEM_BASE+3		// wParam=0, lParam=lpRACOLOR
#define HEM_GETCOLOR			HEM_BASE+4		// wParam=0, lParam=lpRACOLOR
#define HEM_VCENTER				HEM_BASE+5		// wParam=0, lParam=0
#define HEM_REPAINT				HEM_BASE+6		// wParam=0, lParam=0
#define HEM_ANYBOOKMARKS		HEM_BASE+7		// wParam=0, lParam=0
#define HEM_TOGGLEBOOKMARK		HEM_BASE+8		// wParam=nLine, lParam=0
#define HEM_CLEARBOOKMARKS		HEM_BASE+9		// wParam=0, lParam=0
#define HEM_NEXTBOOKMARK		HEM_BASE+10		// wParam=0, lParam=0
#define HEM_PREVIOUSBOOKMARK	HEM_BASE+11		// wParam=0, lParam=0
#define HEM_SELBARWIDTH			HEM_BASE+12		// wParam=nWidth, lParam=0
#define HEM_LINENUMBERWIDTH		HEM_BASE+13		// wParam=nWidth, lParam=0
#define HEM_SETSPLIT			HEM_BASE+14		// wParam=nSplitt, lParam=0
#define HEM_GETSPLIT			HEM_BASE+15		// wParam=0, lParam=0
#define HEM_GETBYTE				HEM_BASE+16		// wParam=cp, lParam=0
#define HEM_SETBYTE				HEM_BASE+17		// wParam=cp, lParam=ByteVal

// Default colors
#define DEFBCKCOLOR				0x00C0F0F0
#define DEFADRTXTCOLOR			0x00800000
#define DEFDTATXTCOLOR			0x00000000
#define DEFASCTXTCOLOR			0x00008000
#define DEFSELBCKCOLOR			0x00800000
#define DEFLFSELBCKCOLOR		0x00C0C0C0
#define DEFSELTXTCOLOR			0x00FFFFFF
#define DEFSELASCCOLOR			0x00C0C0C0
#define DEFSELBARCOLOR			0x00C0C0C0
#define DEFSELBARPEN			0x00808080
#define DEFLNRCOLOR				0x00800000

typedef struct tagHEFONT {
	HFONT hFont;								// Code edit normal
	HFONT hLnrFont;								// Line numbers
} HEFONT;

typedef struct tagHECOLOR {
	UINT bckcol;								// Back color
	UINT adrtxtcol;								// Text color
	UINT dtatxtcol;								// Text color
	UINT asctxtcol;								// Text color
	UINT selbckcol;								// Sel back color
	UINT sellfbckcol;							// Sel lost focus back color
	UINT seltxtcol;								// Sel text color
	UINT selascbckcol;							// Sel back color
	UINT selbarbck;								// Selection bar
	UINT selbarpen;								// Selection bar pen
	UINT lnrcol;								// Line numbers color
} HECOLOR;

typedef struct tagHESELCHANGE {
	NMHDR nmhdr;
	CHARRANGE chrg;
	WORD seltyp;								// SEL_TEXT or SEL_OBJECT
	UINT line;									// Line number
	UINT nlines;								// Total number of lines
	BOOL fchanged;								// TRUE if changed since last
} HESELCHANGE;

typedef struct tagHEBMK {
	HWND hWin;									// Handle of window having the bookmark
	UINT nLine;									// Bokkmarked line
} HEBMK;
