DEFLNG A-Z

REM $Option: WinCON

REM $INCLUDE: 'CommDlg.Dec'

DIM cc AS ChooseColor
DIM ca(0 TO 15) AS LONG
DIM Rc

   COLOR 11: CLS
   PRINT "Common Dialog Sample Program - ChooseColor"
   PRINT

' initialize structure

   cc.lStructSize = LEN(cc)   ' length of this structure
   cc.hwndOwner = 0           ' Handle of owner - set to 0
   cc.hInstance = 0           '
   cc.rgbResult = 0           ' COLORREF = 0x00bbggrr
   cc.lpCustColors = VARPTR(ca(0))' COLORREF*  set to VarPtr of a "dim ca(0 to 15) as long"
   cc.Flags = CcANYCOLOR      '
   cc.lCustData = 0           ' set to 0
   cc.lpfnHook = 0            ' set to 0
   cc.lpTemplateName = 0      ' set to 0

' initialize Custom Color array

   FOR Rc = 0 TO 15
      ca(Rc) = &HFFFFFF       ' white
   NEXT Rc

' do the call

   Rc = ChooseColor(cc)
   PRINT "Return Code:"; Rc
   PRINT
   IF Rc = 0 THEN
      PRINT "Need to Check for error code, here"
   ELSE
      PRINT "You Choose: "; HEX$(cc.rgbResult)
   END IF
   PRINT
   SYSTEM

