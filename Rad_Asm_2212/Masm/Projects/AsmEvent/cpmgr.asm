;-------------------------------------------------------------------------------
;
; Standard Implimentations for an IConnectionPoint Manager object
;
; Copyright (c) 12/28/01  Ernest Murphy
; For educational use only. Any commercial re-use only by written license
;
; 12/28/01 begin writing file
;
;
;-------------------------------------------------------------------------------
;.586
;.model flat,stdcall
;option casemap:none
;-------------------------------------------------------------------------------

;include \masm32\include\windows.inc
;include \masm32\include\user32.inc
;include \masm32\include\kernel32.inc
;include \masm32\include\comctl32.inc
;include \masm32\include\gdi32.inc
;include \masm32\include\ole32.inc
;include \masm32\include\oleaut32.inc
;include \masm32\include\masm32.inc
;include \masm32\COM\include\oaidl.inc
;include \masm32\COM\include\colib.inc
;include \masm32\COM\include\component.inc	  
;include \masm32\COM\include\olectl.inc
include cpmgr.inc

;PUBLIC IID_IConnectionPointContainer
;PUBLIC IID_IConnectionPoint
;;PUBLIC vtIConnectionPoint
;PUBLIC vtIConnectionPointContainer
;PUBLIC gConCount_FireEvents
;PUBLIC gpList_FireEvents
;
;EXTERNDEF	 EventMap:DWORD

;-------------------------------------------------------------------------------
.data

;CLSID_CPManager {E904DBC0-FBC0-11D5-A324-0050BA5A9F26}
sCLSID_CPManager TEXTEQU	 <{0E904DBC0H, 0FBC0H, 011D5H, {0A3H, 024H, 000H, 050H, 0BAH, 05AH, 09FH, 026H}}>

;IID_CPManager	 {E904DBC2-FBC0-11D5-A324-0050BA5A9F26}
sIID_ICPManager   TEXTEQU	  <{0E904DBC1H, 0FBC0H, 011D5H, {0A3H, 024H, 000H, 050H, 0BAH, 05AH, 09FH, 026H}}>

gConCount_FireEvents	DWORD	?
gpList_FireEvents		DWORD	?

sIID_IConnectionPoint		TEXTEQU	<{0B196B286H,0BAB4H,0101AH,{0B6H,09CH,000H,0AAH,000H,034H,01DH,007H}}>
IID_IConnectionPoint		GUID	sIID_IConnectionPoint
pIID_IConnectionPoint		EQU		OFFSET IID_IConnectionPoint

;sIID_IEnumConnectionPoints	TEXTEQU   <{0B196B285H,0BAB4H,0101AH,{0B6H,09CH,000H,0AAH,000H,034H,01DH,007H}}>
;IID_IEnumConnectionPoints	GUID	sIID_IEnumConnectionPoints
;pIID_IEnumConnectionPoints	EQU		OFFSET IEnumConnectionPoints
;
sIID_IConnectionPointContainer	TEXTEQU <{0B196B284H,0BAB4H,0101AH,{0B6H,09CH,000H,0AAH,000H,034H,01DH,007H}}>
IID_IConnectionPointContainer	GUID	sIID_IConnectionPointContainer
pIID_IConnectionPointContainer	EQU		OFFSET IID_IConnectionPointContainer

CPManagerCreationInfo  STRUCT
	m_refiid		DWORD	0	; outgoing interface reference
	m_pParent		DWORD	0	; our parent object
CPManagerCreationInfo  ENDS

CPManagerClass	ClassItem { NULL, NULL, \
				NULL, OFFSET CPManagerIMap, IConnectionPoint_Create, \
				IConnectionPoint_Destroy, NULL, SIZEOF CPManagerObjData}

; describe the Document object's interfaces
CPManagerIMap  InterfaceItem { pIID_IConnectionPoint,  OFFSET vtIConnectionPoint }
			END_INTERFACE_MAP

IConnectionPointContainer struct
	; IUnknown methods
	IU	IUnknown <>
	; IConnectionPointContainer methods
	STDMETHOD	EnumConnectionPoints,:ptr ptr
	STDMETHOD	FindConnectionPoint	,:ptr IID,:ptr ptr IConnectionPoint
IConnectionPointContainer ends

;vtable for IConnectionPointContainer
vtIConnectionPointContainer IConnectionPointContainer <<QueryInterface,AddRef,Release>,IConnectionPointContainer_EnumConnectionPoints,IConnectionPointContainer_FindConnectionPoint>

IConnectionPoint struct
	; IUnknown methods
	IU	IUnknown <>
	; IConnectionPoint methods
	STDMETHOD	GetConnectionInterface,:ptr IID
	STDMETHOD	GetConnectionPointContainer,:ptr ptr
	STDMETHOD	Advise,:ptr IUnknown,:ptr dword
	STDMETHOD	Unadvise,:dword
	STDMETHOD	EnumConnections,:ptr ptr
IConnectionPoint ends

;vtable for IConnectionPoint
vtIConnectionPoint	IConnectionPoint <<QueryInterface,AddRef,Release>,IConnectionPoint_GetConnectionInterface,IConnectionPoint_GetConnectionPointContainer,IConnectionPoint_Advise,IConnectionPoint_Unadvise,IConnectionPoint_EnumConnections>

.code

;--------------------------------------------------------------------------
; IConnectionPointContainer implimentation
;--------------------------------------------------------------------------
IConnectionPointContainer_EnumConnectionPoints PROC this_:DWORD, ppEnum:DWORD
PrintText 'IConnectionPointContainer_EnumConnectionPoints'
	; Returns an object to enumerate all the connection points 
	;  supported in the connectable object.
	; we don't support this
	mov eax, E_NOTIMPL
	ret
IConnectionPointContainer_EnumConnectionPoints ENDP
;--------------------------------------------------------------------------
IConnectionPointContainer_FindConnectionPoint  PROC this_:DWORD, riid:DWORD, ppCP:DWORD 
	LOCAL  cCount:DWORD, pList:DWORD, pCPO:DWORD, CreationInfo:CPManagerCreationInfo
PrintText 'IConnectionPointContainer_FindConnectionPoint'
	; Returns a pointer to the IConnectionPoint interface 
	;  for a specified connection point.
	; This method supports the standard return values E_OUTOFMEMORY and E_UNEXPECTED, 
	; as well as the following: 
	; S_OK		The ppCP pointer has a valid interface pointer. 
	; E_POINTER The address in ppCP is not valid. For example, it may be NULL. 
	; CONNECT_E_NOCONNECTION	This connectable object does not support the 
	;							outgoing interface specified by riid. 
   .IF ppCP == NULL
		mov eax, E_POINTER
		ret
	.ENDIF
	mov ecx, OFFSET EventMap
	mov pList, ecx
	mov eax, [ecx]
PrintHex eax
	.WHILE eax != NULL
		invoke IsEqualGUID, eax, riid
		.IF TRUE
PrintHex 1
			; we found our matching Connection Point
			mov ecx, pList
			mov eax, [ecx].EventItem.pObjIEventMgr
			.IF !eax 
PrintHex 2
				; we need to create this CP object
				mov eax, [ecx]						; IID info
				mov CreationInfo.m_refiid, eax
				mov eax, this_						; parent info
				mov CreationInfo.m_pParent, eax
				invoke AllocObject, ADDR pCPO, ADDR CPManagerClass, NULL, ADDR CreationInfo
				.IF SDWORD ptr eax<0
PrintHex 3
					mov eax, E_UNEXPECTED
					ret
				.ENDIF
				mov edx, pList
				mov [edx].EventItem.pObjIEventMgr, eax
			.ENDIF
			; we have an interface to pass back
			mov edx, ppCP
			mov [edx], eax	; assign the CP object
;			 coinvoke eax, IUnknown, AddRef
PrintHex 4
;mov		eax,[eax]
mov		edx,[eax]
invoke [edx].IUnknown.AddRef,eax
PrintHex eax
			ret
		.ELSE
			add pList, SIZEOF EventItem
		.ENDIF
		mov		eax,pList
		mov		eax,[eax]
PrintHex eax
	.ENDW
	; if we got here then there was no matching GUID
	mov eax, CONNECT_E_NOCONNECTION
	ret
IConnectionPointContainer_FindConnectionPoint ENDP

;--------------------------------------------------------------------------
; IConnectionPoint implimentation
;--------------------------------------------------------------------------
IConnectionPoint_Create PROC PUBLIC this_:DWORD, pCPManagerCreationInfo:DWORD
	LOCAL  pBase:DWORD
PrintText 'IConnectionPoint_Create'
	; get ConnectionMap reference
	pObjectData this_, ecx	
	mov pBase, ecx
	; extract our base data
	mov edx, pCPManagerCreationInfo
	mov eax, [edx].CPManagerCreationInfo.m_refiid
	mov [ecx].CPManagerObjData.m_refiid, eax	; the outgoing interface we manage
	mov eax, [edx].CPManagerCreationInfo.m_pParent
	mov [ecx].CPManagerObjData.m_pParent, eax	; our parent object
	xor eax, eax			; return S_OK	
	mov [ecx].CPManagerObjData.m_pList0, eax	; no list members
	mov [ecx].CPManagerObjData.m_ListCount, eax ; null list
	mov [ecx].CPManagerObjData.m_Cookie, eax
	inc [ecx].CPManagerObjData.m_Cookie			; Starting cookie is 1
	ret						; return S_OK
IConnectionPoint_Create ENDP

;--------------------------------------------------------------------------
IConnectionPoint_Destroy PROC PUBLIC this_:DWORD
	LOCAL  pBase:DWORD
PrintText 'IConnectionPoint_Destroy'
	; get CPManagerObjData reference
	pObjectData this_, ecx	
	mov pBase, ecx
	; extract our base data
	mov eax, [ecx].CPManagerObjData.m_pList0
	.IF eax
		; we have a list here, let us delete it
		; and DAMN BE those clients who did not Unadvise us!
		invoke CoTaskMemFree, eax
	.ENDIF
	xor eax, eax			; return S_OK
	ret
IConnectionPoint_Destroy ENDP

;--------------------------------------------------------------------------
IConnectionPoint_GetConnectionInterface PROC PUBLIC this_:DWORD, ppIIDEvent:DWORD 
	LOCAL  pBase:DWORD
	LOCAL ppv:DWORD
PrintText 'IConnectionPoint_GetConnectionInterface'
	; get CPManagerObjData reference
	pObjectData this_, ecx	
	mov eax, [ecx].CPManagerObjData.m_refiid	; outgoing interface ref we support
	mov ecx, ppIIDEvent
	mov [ecx], eax	; copy it for the client
	xor eax, eax			; return S_OK
	ret
IConnectionPoint_GetConnectionInterface ENDP

;--------------------------------------------------------------------------
IConnectionPoint_GetConnectionPointContainer PROC PUBLIC this_:DWORD, ppCPC:DWORD  
	LOCAL  pBase:DWORD
	LOCAL ppv:DWORD
PrintText 'IConnectionPoint_GetConnectionPointContainer'
	; get CPManagerObjData reference
	pObjectData this_, ecx	
	; get our parent object
	mov eax, [ecx].CPManagerObjData.m_pParent
	mov ecx, ppCPC
	mov [ecx], eax
;	 coinvoke [ecx], IUnknown, AddRef
mov		eax,[ecx]
mov		edx,[eax]
invoke [edx].IUnknown.AddRef,eax
	xor eax, eax			; return S_OK
	ret
IConnectionPoint_GetConnectionPointContainer ENDP

;--------------------------------------------------------------------------
IConnectionPoint_Advise PROC PUBLIC this_:DWORD, pUnk, pdwCookie:DWORD 
	LOCAL pBase:DWORD, OldCount:DWORD, NewCount:DWORD, pNewList:DWORD
	LOCAL pIEvent
PrintText 'IConnectionPoint_Advise'
	; check we have valid pointer and cookie ref
	.IF (! pUnk)
		mov eax, E_POINTER
		ret
	.ENDIF
	.IF (! pdwCookie)
		mov eax, E_POINTER
		ret
	.ENDIF
	; get CPManagerObjData reference
	pObjectData this_, ecx	
	mov pBase, ecx
	; see if this passed in interface supports the outgoing one
;	 coinvoke pUnk, IUnknown, QueryInterface, [ecx].CPManagerObjData.m_refiid, ADDR pIEvent
mov		edx,pUnk
mov		edx,[edx]
invoke [edx].IUnknown.QueryInterface,pUnk,[ecx].CPManagerObjData.m_refiid, ADDR pIEvent
	.IF SDWORD ptr eax<0
		mov eax, E_NOINTERFACE
		ret
	.ENDIF
	; this is looking very promising
	; compute how much room we'll need for our expanding list
	mov ecx, pBase
	mov eax, [ecx].CPManagerObjData.m_ListCount
	imul eax, SIZEOF CONNECTDATA
	mov OldCount, eax
	add eax, SIZEOF CONNECTDATA
	mov NewCount, eax
	invoke CoTaskMemAlloc, eax
	mov pNewList, eax
	.IF OldCount
		; copy old list to new list (if old has any data)
		mov ecx, pBase
		invoke MemCopy, [ecx].CPManagerObjData.m_pList0, pNewList, OldCount
	.ENDIF
	; now insert new member at end of expanded list
	mov edx, pNewList
	add edx, OldCount	; now points to new members
	mov eax, pIEvent
	mov [edx].CONNECTDATA.pUnk, eax
	; now give them a Cookie
	mov eax, pdwCookie
	mov ecx, pBase
	mov eax, [ecx].CPManagerObjData.m_Cookie
	inc [ecx].CPManagerObjData.m_Cookie
	mov [edx].CONNECTDATA.dwCookie, eax
	; finally, inc our connections count and updated list
	inc [ecx].CPManagerObjData.m_ListCount
	mov eax, pNewList
	mov [ecx].CPManagerObjData.m_pList0, eax
	xor eax, eax		; return S_OK
	ret
IConnectionPoint_Advise ENDP

;--------------------------------------------------------------------------
IConnectionPoint_Unadvise PROC PUBLIC this_:DWORD, dwCookie:DWORD
	LOCAL pBase:DWORD, Count:DWORD, pList:DWORD
PrintText 'IConnectionPoint_Unadvise'
	; get CPManagerObjData reference
	pObjectData this_, ecx	
	mov pBase, ecx
	mov eax, [ecx].CPManagerObjData.m_pList0
	mov Count, eax
	mov edx, [ecx].CPManagerObjData.m_ListCount
	.WHILE Count > 0
		mov eax, [edx].CONNECTDATA.dwCookie
		.IF eax == dwCookie
			; we found our connection to release
			mov pList, ecx
;			 coinvoke [ecx].CONNECTDATA.pUnk, IUnknown, Release
mov		eax,[ecx].CONNECTDATA.pUnk
mov		edx,[eax]
invoke [edx].IUnknown.Release,eax
			mov ecx, pList
			dec [ecx].CPManagerObjData.m_ListCount	; adjust the count
			dec Count
			.WHILE Count > 0
				; now move our objects up one spot
				;  we don't alloc a shorter list because it is likely we're being
				;  terminated. A new list will be alloced at next Advise anyway.
				mov eax, [ecx + SIZEOF CONNECTDATA].CONNECTDATA.pUnk
				mov [ecx].CONNECTDATA.pUnk, eax
				mov eax, [ecx + SIZEOF CONNECTDATA].CONNECTDATA.dwCookie
				mov [ecx].CONNECTDATA.dwCookie, eax
				add edx, SIZEOF CONNECTDATA  
				dec Count
			.ENDW
		.ENDIF
		add edx, SIZEOF CONNECTDATA  
		dec Count
	.ENDW
	; if we got here, we didn't find a connection
	mov eax, CONNECT_E_NOCONNECTION
	ret
IConnectionPoint_Unadvise ENDP

;--------------------------------------------------------------------------
IConnectionPoint_EnumConnections PROC PUBLIC this_:DWORD, ppEnum:DWORD
PrintText 'IConnectionPoint_EnumConnections'
	; we don't support this
	mov eax, E_NOTIMPL
	ret
IConnectionPoint_EnumConnections ENDP

;--------------------------------------------------------------------------

;END
