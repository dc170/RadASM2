
#include once "windows.bi"
#include once "win/commctrl.bi"

#include "..\..\Inc\RadASM.bi"

dim SHARED hInstance as HINSTANCE
dim SHARED hooks as ADDINHOOKS
dim SHARED lpHandles as ADDINHANDLES ptr
dim SHARED lpProcs as ADDINPROCS ptr
dim SHARED lpData as ADDINDATA ptr
dim SHARED idaddin as long
CONST szFBAddin as string="FBAddin"
CONST szOpt1 as string="Show OK button"
dim SHARED opt as ADDINOPT=(@szOpt1,1,1)
dim SHARED opt1 as ADDINOPT=(0,0,0)
dim SHARED fopt as long
