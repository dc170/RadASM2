; IMyCom2  Interface
;--------------------------------------------------------------------------
;

sIID_IMyCom2		TEXTEQU <{0F8CE5E41H, 01135H, 011D4H, {0A3H, 024H, 000H, 040H, 0F6H, 0D4H, 087H, 0D9H}}>
IID_IMyCom2			GUID sIID_IMyCom2
pIID_IMyCom2		EQU offset IID_IMyCom2

sCLSID_MyCom3		TEXTEQU <{0BBCE2B80H, 0FE99H, 011D5H, {0A3H, 024H, 000H, 050H, 0BAH, 05AH, 09FH, 026H}}>
CLSID_MyCom3		GUID sCLSID_MyCom3
pCLSID_MyCom3		EQU offset CLSID_MyCom3

sLIBID_MyCom3		TEXTEQU <{0BBCE2B81H, 0FE99H, 011D5H, {0A3H, 024H, 000H, 050H, 0BAH, 05AH, 09FH, 026H}}>
LIBID_MyCom3		GUID sLIBID_MyCom3
pLIBID_MyCom3		EQU offset LIBID_MyCom3

sIID_MyEventClass	TEXTEQU <{02C23CB08H, 0FA18H, 011D5H, {0A3H, 024H, 000H, 050H, 0BAH, 05AH, 09FH, 026H}}>
IID_MyEventClass	GUID sIID_MyEventClass
pIID_MyEventClass	EQU offset IID_MyEventClass

CONNECTDATA STRUCT
	pUnk		DWORD	0
	dwCookie	DWORD	0
CONNECTDATA ENDS

CONNECT_E_NOCONNECTION				EQU			80009E40h

STDMETHOD	MACRO	name, argl :VARARG
	LOCAL @tmp_a
	LOCAL @tmp_b
	@tmp_a	TYPEDEF PROTO this_:DWORD,argl
	@tmp_b	TYPEDEF PTR @tmp_a
	name	@tmp_b		?
ENDM

IUnknown STRUCT
	; IUnknown methods
	STDMETHOD QueryInterface,:DWORD,:DWORD
	STDMETHOD AddRef
	STDMETHOD Release
IUnknown ends

IDispatch STRUCT
	; IUnknown methods
	IU IUnknown <>
	; IDispatch methods
	STDMETHOD GetTypeInfoCount,:ptr DWORD
	STDMETHOD GetTypeInfo,:dword,:LCID,:ptr ptr ITypeInfo
	STDMETHOD GetIDsOfNames,:ptr IID,:ptr,:dword,:LCID,:ptr DISPID
	STDMETHOD Invoke_,:DISPID,:ptr IID,:LCID,:dword,:ptr DISPPARAMS,:ptr VARIANT,:ptr EXCEPINFO,:ptr DWORD
IDispatch ENDS

IMyCom2 STRUCT
	; IDispatch methods 
	IDS IDispatch <>
	; IMyCom2 methods
	STDMETHOD GetValue,:DWORD,:DWORD
	STDMETHOD SetValue,:DWORD,:DWORD
	STDMETHOD RaiseValue,:DWORD,:DWORD
IMyCom2 ENDS

MyEventClass STRUCT
	; IDispatch methods
	IDS IDispatch <>
	; MyEventClass methods
	STDMETHOD MyEventClass_XMax
MyEventClass ENDS

