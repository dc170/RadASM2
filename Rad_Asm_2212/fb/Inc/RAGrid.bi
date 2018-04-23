CONST GN_HEADERCLICK =1 'User clicked header 
CONST GN_BUTTONCLICK =2 'Sendt when user clicks the button in a button cell 
CONST GN_CHECKCLICK =3 'Sendt when user double clicks the checkbox in a checkbox cell 
CONST GN_IMAGECLICK =4 'Sendt when user double clicks the image in an image cell 
CONST GN_BEFORESELCHANGE =5 'Sendt when user request a selection change 
CONST GN_AFTERSELCHANGE =6 'Sendt after a selection change 
CONST GN_BEFOREEDIT =7 'Sendt before the cell edit control shows 
CONST GN_AFTEREDIT =8 'Sendt when the cell edit control is about to close 
CONST GN_BEFOREUPDATE =9 'Sendt before a cell updates grid data 
CONST GN_AFTERUPDATE =10 'Sendt after grid data has been updated 
CONST GN_USERCONVERT =11 'Sendt when user cell needs to be converted. 

'Messages 
CONST GM_ADDCOL =WM_USER+1 'wParam=0, lParam=lpCOLUMN 
CONST GM_ADDROW =WM_USER+2 'wParam=0, lParam=lpROWDATA (can be NULL) 
CONST GM_INSROW =WM_USER+3 'wParam=nRow, lParam=lpROWDATA (can be NULL) 
CONST GM_DELROW =WM_USER+4 'wParam=nRow, lParam=0 
CONST GM_MOVEROW =WM_USER+5 'wParam=nFromRow, lParam=nToRow 
CONST GM_COMBOADDSTRING =WM_USER+6 'wParam=nCol, lParam=lpszString 
CONST GM_COMBOCLEAR =WM_USER+7 'wParam=nCol, lParam=0 
CONST GM_GETCURSEL =WM_USER+8 'wParam=0, lParam=0 
CONST GM_SETCURSEL =WM_USER+9 'wParam=nCol, lParam=nRow 
CONST GM_GETCURCOL =WM_USER+10 'wParam=0, lParam=0 
CONST GM_SETCURCOL =WM_USER+11 'wParam=nCol, lParam=0 
CONST GM_GETCURROW =WM_USER+12 'wParam=0, lParam=0 
CONST GM_SETCURROW =WM_USER+13 'wParam=nRow, lParam=0 
CONST GM_GETCOLCOUNT =WM_USER+14 'wParam=0, lParam=0 
CONST GM_GETROWCOUNT =WM_USER+15 'wParam=0, lParam=0 
CONST GM_GETCELLDATA =WM_USER+16 'wParam=nRowCol, lParam=lpData 
CONST GM_SETCELLDATA =WM_USER+17 'wParam=nRowCol, lParam=lpData 
CONST GM_GETCELLRECT =WM_USER+18 'wParam=nRowCol, lParam=lpRECT 
CONST GM_SCROLLCELL =WM_USER+19 'wParam=0, lParam=0 
CONST GM_GETBACKCOLOR =WM_USER+20 'wParam=0, lParam=0 
CONST GM_SETBACKCOLOR =WM_USER+21 'wParam=nColor, lParam=0 
CONST GM_GETGRIDCOLOR =WM_USER+22 'wParam=0, lParam=0 
CONST GM_SETGRIDCOLOR =WM_USER+23 'wParam=nColor, lParam=0 
CONST GM_GETTEXTCOLOR =WM_USER+24 'wParam=0, lParam=0 
CONST GM_SETTEXTCOLOR =WM_USER+25 'wParam=nColor, lParam=0 
CONST GM_ENTEREDIT =WM_USER+26 'wParam=nCol, lParam=nRow 
CONST GM_ENDEDIT =WM_USER+27 'wParam=nRowCol, lParam=fCancel 
CONST GM_GETCOLWIDTH =WM_USER+28 'wParam=nCol, lParam=0 
CONST GM_SETCOLWIDTH =WM_USER+29 'wParam=nCol, lParam=nWidth 
CONST GM_GETHDRHEIGHT =WM_USER+30 'wParam=0, lParam=0 
CONST GM_SETHDRHEIGHT =WM_USER+31 'wParam=0, lParam=nHeight 
CONST GM_GETROWHEIGHT =WM_USER+32 'wParam=0, lParam=0 
CONST GM_SETROWHEIGHT =WM_USER+33 'wParam=0, lParam=nHeight 
CONST GM_RESETCONTENT =WM_USER+34 'wParam=0, lParam=0 
CONST GM_COLUMNSORT =WM_USER+35 'wParam=nCol, lParam=0=Ascending, 1=Descending, 2=Invert 
CONST GM_GETHDRTEXT =WM_USER+36 'wParam=nCol, lParam=lpBuffer 
CONST GM_SETHDRTEXT =WM_USER+37 'wParam=nCol, lParam=lpszText 
CONST GM_GETCOLFORMAT =WM_USER+38 'wParam=nCol, lParam=lpBuffer 
CONST GM_SETCOLFORMAT =WM_USER+39 'wParam=nCol, lParam=lpszText 
CONST GM_CELLCONVERT =WM_USER+40 'wParam=nRowCol, lParam=lpBuffer 
CONST GM_RESETCOLUMNS =WM_USER+41 'wParam=0, lParam=0 
CONST GM_GETROWCOLOR =WM_USER+42 'wParam=nRow, lParam=lpROWCOLOR 
CONST GM_SETROWCOLOR =WM_USER+43 'wParam=nRow, lParam=lpROWCOLOR 

'Column alignment 
CONST GA_ALIGN_LEFT =0 
CONST GA_ALIGN_CENTER =1 
CONST GA_ALIGN_RIGHT =2 

'Column types 
CONST TYPE_EDITTEXT =0 'String 
CONST TYPE_EDITLONG =1 'Long 
CONST TYPE_CHECKBOX =2 'Long 
CONST TYPE_COMBOBOX =3 'Long 
CONST TYPE_HOTKEY =4 'Long 
CONST TYPE_BUTTON =5 'String 
CONST TYPE_IMAGE =6 'Long 
CONST TYPE_DATE =7 'Long 
CONST TYPE_TIME =8 'Long 
CONST TYPE_USER =9 '0=String, 1 to 512 bytes binary data 

'Column sorting 
CONST SORT_ASCENDING =0 
CONST SORT_DESCENDING =1 
CONST SORT_INVERT =2 

'Window styles 
CONST STYLE_NOSEL =01 
CONST STYLE_NOFOCUS =02 
CONST STYLE_HGRIDLINES =04 
CONST STYLE_VGRIDLINES =08 
CONST STYLE_GRIDFRAME =10 

CONST ODT_GRID =6 

TYPE COLUMN 
	colwt AS INTEGER 
	lpszhdrtext AS PTSTR 'pointer to header text. 
	halign AS INTEGER 'Header text alignment. 
	calign AS INTEGER 'Column text alignment. 
	ctype AS INTEGER 'Column data type. 
	ctextmax AS INTEGER 'Max text lenght for TYPE_EDITTEXT and TYPE_EDITLONG. 
	lpszformat AS INTEGER 'Format string for TYPE_EDITLONG. 
	himl AS INTEGER 'Handle of image list. For the image columns and combobox only. 
	hdrflag AS INTEGER 'Header flags. 
	colxp AS INTEGER 'Column position. Internally used. 
	edthwnd AS INTEGER 'Column control handle. Internally used. 
END TYPE 

TYPE ROWCOLOR 
	backcolor AS INTEGER 
	textcolor AS INTEGER 
END TYPE 

'Notifications 
TYPE GRIDNOTIFY 
	nmhdr AS NMHDR 
	col AS INTEGER 'Column 
	row AS INTEGER 'Row 
	hwnd AS INTEGER 'Handle of column edit control 
	lpdata AS INTEGER 'Pointer to data 
	fcancel AS INTEGER 'Set to TRUE to cancel operation 
END TYPE 


