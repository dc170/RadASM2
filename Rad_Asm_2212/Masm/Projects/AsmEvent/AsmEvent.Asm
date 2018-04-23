;-------------------------------------------------------------------------------
; MyCom3.dll		copyright 7/15/00 Ernest J Murphy
;
;  sample project to illustrate how to source events
;
;-------------------------------------------------------------------------------
;Modified by KetilO

.386
.model flat, stdcall
option casemap:none ; case sensitive

;-------------------------------------------------------------------------------

include		\masm32\include\windows.inc
include		\masm32\include\user32.inc
include		\masm32\include\kernel32.inc
include		\masm32\include\advapi32.inc	
include		\masm32\include\oleaut32.inc
include		\masm32\include\masm32.inc
include		\masm32\include\ole32.inc
;include	 \masm32\com\include\oaidl.inc
include		\masm32\com\include\colib.inc
;include	 \masm32\COM\include\component.inc	  

include \radasm\masm\inc\debug.inc
includelib \radasm\masm\lib\debug.lib

include		AsmEvent.inc

include		cpmgr.asm
;include		cpmgr\cpmgr.inc
;includelib	cpmgr\cpmgr.lib

includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\advapi32.lib
includelib	\masm32\lib\oleaut32.lib
includelib	\masm32\lib\ole32.lib
includelib	\masm32\lib\gdi32.lib
includelib	\masm32\lib\shell32.lib
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\comdlg32.lib
includelib	\masm32\lib\masm32.lib
includelib	\masm32\com\colib\colib.lib

PUBLIC ClassMap
PUBLIC EventMap

;-------------------------------------------------------------------------------
.data

; describe the classes inside the DLL
ClassMap	ClassItem <pCLSID_MyCom3,DISPINTERFACE + SUPPLY_TYPE_INFO,OFFSET MyCom3TypeLibInfo,OFFSET MyCom2IMap,CreateMyCom3,NULL,NULL,SIZEOF MyCom3Object>
			ClassItem <0,0,0,0,0,0,0,0>

EventMap	EventItem <pIID_MyEventClass,0>
			EventItem <0,0>

; describe the MyCom3 object's interfaces
MyCom2IMap	InterfaceItem <pIID_IMyCom2,OFFSET vtableIMyCom2>
			InterfaceItem <pIID_IConnectionPointContainer,OFFSET vtIConnectionPointContainer>
			InterfaceItem <0,0>

; describe the type libraries
MyCom3TypeLibInfo	TypeLibInfo <pLIBID_MyCom3,1,0>

; describe the MyCom2 object itself (takes 2 steps)
; step 1
MyCom3ObjData STRUCT		; MyCom3 object private data struct
	m_Value			DWORD 0	; Value (private data member)
MyCom3ObjData ENDS

; step 2
MyCom3Object STRUCT
	ObjectData0		ObjectData <>		; base values
	MyCom3ObjData0	MyCom3ObjData <>	; custom object data
	ObjectEntry0	ObjectEntry <>		; delegated Unknown
	ObjectEntry1	ObjectEntry <>		; IMyCom2
MyCom3Object ENDS

; fill in the vtable
vtableIMyCom2		IMyCom2		<<<QueryInterface,AddRef,Release>,GetTypeInfoCount,GetTypeInfo,GetIDsOfNames,Invoke_>,GetValue,SetValue,RaiseValue>

;sMC3		BYTE	"MC3", 0
;sCreate		BYTE	"cREATE", 0
;sDestroy	BYTE	"sDestroy", 0

;-------------------------------------------------------------------------------
.code

CreateMyCom3 PROC this_:DWORD
PrintText 'CreateMyCom3'
	pObjectData this_, edx	; cast this_ to object data
PrintHex edx
	xor eax, eax								; get variable
	mov (MyCom3ObjData ptr [edx]).m_Value, eax	; store new value	
	; NULL the EventMap pObjIEventMgr pointers
	; to keep naughty clients (such as VB) from abusing us.
	mov ecx, OFFSET EventMap
	mov eax, [ecx]
	.WHILE eax
		mov [ecx].EventItem.pObjIEventMgr, NULL
		add ecx, SIZEOF EventItem
		mov eax, [ecx]
	.ENDW
	xor eax, eax								; return S_OK
	ret
CreateMyCom3 ENDP

;-------------------------------------------------------------------------------
GetValue PROC this_:DWORD, pval:DWORD	; GetValue for the IMyCom Interface
PrintText 'GetValue'
	pObjectData this_, edx						; cast this_ to object data
	mov eax, (MyCom3ObjData ptr [edx]).m_Value	; get object data value
	mov ecx, pval								; get ptr to variable for return
	mov [ecx], eax								; mov value to variable
	xor eax, eax								; return S_OK
	ret
GetValue ENDP

;-------------------------------------------------------------------------------
SetValue PROC this_:DWORD, val:DWORD	; SetValue for the IMyCom Interface
PrintText 'SetValue'
	pObjectData this_, edx	; cast this_ to object data
	mov eax, val								; get variable
	mov (MyCom3ObjData ptr [edx]).m_Value, eax	; store new value	
	mov eax, (MyCom3ObjData ptr [edx]).m_Value
	.IF eax > 100
		FireEvents MyEventClass, XMax
	.ENDIF
	xor eax, eax								; return S_OK
	ret
SetValue ENDP

;-------------------------------------------------------------------------------
RaiseValue	PROC this_:DWORD, val:DWORD ; RaiseValue for the IMyCom Interface
PrintText 'RaiseValue'
	pObjectData this_, edx	; cast this_ to object data
	mov eax, val								; get variable
	add (MyCom3ObjData ptr [edx]).m_Value, eax	; add new value to current value
	mov eax, (MyCom3ObjData ptr [edx]).m_Value
	.IF eax >= 100
		FireEvents MyEventClass, XMax
	.ENDIF
	xor eax, eax								; return S_OK
	ret
RaiseValue ENDP

;-------------------------------------------------------------------------------
end DllMain
