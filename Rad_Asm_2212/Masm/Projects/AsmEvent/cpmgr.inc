;-------------------------------------------------------------------------------
; cpmgr.inc
;
; working code for the Connection Point Manager class methods
;
;-------------------------------------------------------------------------------
;IFNDEF		 cpmgr_inc
;cpmgr_inc	 EQU		 1

;EXTERNDEF	 gConCount_FireEvents:DWORD
;EXTERNDEF	 gpList_FireEvents:DWORD
;EXTERNDEF	 IID_IConnectionPointContainer:GUID
;EXTERNDEF	 vtIConnectionPoint:IUnknown
;EXTERNDEF	 vtIConnectionPointContainer:IUnknown

EventItem  STRUCT
	pIID_IEvent		DWORD	0
	pObjIEventMgr	DWORD	0
EventItem  ENDS

;DeclareEvent	MACRO	IEvent:REQ
;	LOCAL istatement
;	istatement TEXTEQU <{pIID_&IEvent&, NULL}>
;	EXITM istatement 
;	ENDM 
;	
;END_EVENT_MAP	MACRO
;		DWORD	0
;		DWORD	0
;	ENDM
;
CPManagerObjData STRUCT
	m_refiid		DWORD	0	; which interface we support
	m_pParent		DWORD	0	; our parent object
	m_pList0		DWORD	0	; start of our linked list of advise member pointers
	m_ListCount		DWORD	0	; count of how many connection we currently have
	m_Cookie		DWORD	0	; current Cookie to pass out
CPManagerObjData ENDS


FireEvents MACRO IEventSink:REQ, MethodName:REQ, Params:vararg
   LOCAL istatement, pIEvent
	pIEvent CATSTR <pIID_&IEventSink&>
	istatement CATSTR <invoke [edx].&IEventSink&.&IEventSink&_&MethodName&, ecx>
   IFNB <Params>	 ;; add the list of parameter arguments if any
	   istatement CATSTR istatement, <, >, <&Params> 
   ENDIF 
	mov ecx, OFFSET EventMap
	mov gpList_FireEvents, ecx
	mov eax, [ecx]
	.WHILE (eax > 0)
		; we have another legit interface pointer
		invoke IsEqualGUID, pIEvent, eax
		.IF TRUE
			; we found our interface!
			mov ecx, gpList_FireEvents
			mov edx, [ecx].EventItem.pObjIEventMgr			; now we have our manager object ref
			.IF edx > 0		; then we have a legit manager interface
				mov edx, [ecx].EventItem.pObjIEventMgr		
				mov ecx, [edx].ObjectEntry.m_pBase			; walk to base data
				add ecx, SIZEOF ObjectData
				mov eax, [ecx].CPManagerObjData.m_pList0
				mov gpList_FireEvents, eax
				mov eax, [ecx].CPManagerObjData.m_ListCount
				mov gConCount_FireEvents, eax
				.WHILE gConCount_FireEvents > 0
					mov ecx, gpList_FireEvents
					mov ecx, [ecx].CONNECTDATA.pUnk
					.IF ecx
						mov edx, [ecx]
						; invoke [edx].IEventSink.IEventSink_MethodName, ecx
						istatement
						dec gConCount_FireEvents
						add gpList_FireEvents, SIZEOF CONNECTDATA
					.ENDIF
				.ENDW
			.ENDIF
			jmp FireEvents_DONE
		.ENDIF
		mov ecx, gpList_FireEvents
		add ecx, SIZEOF EventItem
		mov gpList_FireEvents, ecx
		mov eax, ecx
	.ENDW
FireEvents_DONE:
	ENDM
;-------------------------------------------------------------------------------
;ENDIF	 ;cpmgr.inc END
