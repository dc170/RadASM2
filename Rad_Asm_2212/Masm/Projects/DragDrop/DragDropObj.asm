;By KetilO

;Based on the work by chorus and ...
;***************************************************************************************************************
;                                       WIN32ASM OLE/COM DragDrop Interfaces
;                                       by Random (c)2001 - norp74@hotmail.com
;*******DISCLAIMER**********************************************************************************************
;Fill free to (re)use this code as you like, but please put a reference to me and to those I thank below
;Please email me any bug/suggestion and any development/improvement you've made on this code
;I should not be held responsible for any damage that may derive from the use of this code
;*******REFERENCES**********************************************************************************************
;The DragDrop classes I wrote are mainly derived from the C++ source of John Rennie (jrennie@cix.compulink.co.uk)
;The COM interface structure in assembler come from the incredible tutorial written by Bill T.  (billasm@usa.net)
;***************************************************************************************************************

STDMETHOD MACRO name,argl:VARARG
    LOCAL	@tmp_a
    LOCAL	@tmp_b
    @tmp_a TYPEDEF PROTO this_:DWORD,argl
    @tmp_b TYPEDEF PTR @tmp_a
    name @tmp_b ?
ENDM

MK_ALT						equ 20h

DROPEFFECT_NONE				equ	0
DROPEFFECT_COPY				equ	1
DROPEFFECT_MOVE				equ	2
;DROPEFFECT_LINK			equ	4
;DROPEFFECT_SCROLL			equ	80000000h

TYMED_HGLOBAL				equ	1
;TYMED_FILE					equ	2
;TYMED_ISTREAM				equ	4
;TYMED_ISTORAGE				equ	8
;TYMED_GDI					equ	16
;TYMED_MFPICT				equ	32
;TYMED_ENHMF				equ	64
;TYMED_NULL					equ	0

DATADIR_GET					equ	1
DATADIR_SET					equ	2

;--------------------------------------------------------------------------------
;IUnknown
;--------------------------------------------------------------------------------
IUnknown struct
	STDMETHOD QueryInterface,:DWORD,:DWORD
	STDMETHOD AddRef
	STDMETHOD Release
IUnknown ends

;--------------------------------------------------------------------------------
;IDropTarget
;--------------------------------------------------------------------------------
IDropTarget	struct
	;IUnknown methods
	iu						IUnknown <?>
	;IDropTarget methods
	STDMETHOD DragEnter,:DWORD,:DWORD,:DWORD,:DWORD
	STDMETHOD DragOver,:DWORD,:DWORD,:DWORD
	STDMETHOD DragLeave
	STDMETHOD Drop,:DWORD,:DWORD,:DWORD,:DWORD
	;Additional	data
	refcount				dd ?
	valid					dd ?
IDropTarget	ends

;--------------------------------------------------------------------------------
;IDropSource
;--------------------------------------------------------------------------------
IDropSource	struct
	;IUnknown methods
	iu						IUnknown <?>
	;IDropSource methods
	STDMETHOD QueryContinueDrag,:DWORD,:DWORD
	STDMETHOD GiveFeedback,:DWORD
	;Additional	data
	refcount				dd ?
IDropSource	ends

;--------------------------------------------------------------------------------
;IDataObject
;--------------------------------------------------------------------------------
IDataObject	struct
	;IUnknown methods
	iu						IUnknown <?>
	;IDataObject methods
	STDMETHOD GetData,:DWORD,:DWORD
	STDMETHOD GetDataHere,:DWORD,:DWORD
	STDMETHOD QueryGetData,:DWORD
	STDMETHOD GetCanonicalFormatEtc,:DWORD,:DWORD
	STDMETHOD SetData,:DWORD,:DWORD,:DWORD
	STDMETHOD EnumFormatEtc,:DWORD,:DWORD
	STDMETHOD DAdvise,:DWORD,:DWORD,:DWORD,:DWORD
	STDMETHOD DUnadvise,:DWORD
	STDMETHOD EnumDAdvise,:DWORD
	;Additional	data
	refcount				dd ?
IDataObject	ends

;--------------------------------------------------------------------------------
;IEnumFORMATETC
;--------------------------------------------------------------------------------
IEnumFORMATETC struct
	;IUnknown methods
	iu						IUnknown <?>
	;IEnumFORMATETC	methods
	STDMETHOD Next,:DWORD,:DWORD,:DWORD
	STDMETHOD Skip,:DWORD
	STDMETHOD Reset
	STDMETHOD Clone,:DWORD
	;Additional	data
	refcount				dd ?
	ifmt					dd ?
	ifmtmax					dd ?
IEnumFORMATETC ends

;Structures	used by	an IDataObject
STGMEDIUM struct
	tymed					dd ?
	hGlobal					dd ?
	pUnkForRelease			dd ?
STGMEDIUM ends

FORMATETC struct
	cfFormat				dd ?
	lptd					dd ?
	dwAspect				dd ?
	lindex					dd ?
	tymed					dd ?
FORMATETC ends

.const

IID_IUnknown				GUID <000000000H,00000H,00000H,<0C0H,000H,000H,000H,000H,000H,000H,046H>>
IID_IDropTarget				GUID <000000122H,00000H,00000H,<0C0H,000H,000H,000H,000H,000H,000H,046H>>
IID_IDropSource				GUID <000000121H,00000H,00000H,<0C0H,000H,000H,000H,000H,000H,000H,046H>>
IID_IDataObject				GUID <00000010EH,00000H,00000H,<0C0H,000H,000H,000H,000H,000H,000H,046H>>
IID_IEnumFORMATETC			GUID <000000103H,00000H,00000H,<0C0H,000H,000H,000H,000H,000H,000H,046H>>

.data

vtIDropTarget				IDropTarget	<<IDropTarget_QueryInterface,IDropTarget_AddRef,IDropTarget_Release>,IDropTarget_DragEnter,IDropTarget_DragOver,IDropTarget_DragLeave,IDropTarget_Drop,0,0>
pvtIDropTarget				dd vtIDropTarget

vtIDropSource				IDropSource	<<IDropSource_QueryInterface,IDropSource_AddRef,IDropSource_Release>,IDropSource_QueryContinueDrag,IDropSource_GiveFeedback,0>
pvtIDropSource				dd vtIDropSource

vtIDataObject				IDataObject	<<IDataObject_QueryInterface,IDataObject_AddRef,IDataObject_Release>,IDO_GetData,IDO_GetDataHere,IDO_QueryGetData,IDO_GetCanonicalFormatEtc,IDO_SetData,IDO_EnumFormatEtc,IDO_DAdvise,IDO_DUnadvise,IDO_EnumDAdvise,0>
pvtIDataObject				dd vtIDataObject

vtIEnumFORMATETC			IEnumFORMATETC <<IEnumFORMATETC_QueryInterface,IEnumFORMATETC_AddRef,IEnumFORMATETC_Release>,IEnumFORMATETC_Next,IEnumFORMATETC_Skip,IEnumFORMATETC_Reset,IEnumFORMATETC_Clone,0,0,1>
pvtIEnumFORMATETC			dd vtIEnumFORMATETC

.code

IsEqualGUID	proc uses ecx esi edi,rguid1,rguid2

	xor		eax,eax
	mov		esi,rguid1
	mov		edi,rguid2
	mov		ecx,sizeof GUID/4
	repe	cmpsd
	setz	al
	ret

IsEqualGUID	endp

;IDropTarget methods
IDropTarget_QueryInterface proc	pthis,iid,ppvObject

;PrintText 'IDropTarget_QueryInterface'
	invoke IsEqualGUID,iid,offset IID_IDropTarget
	.if	!eax
		invoke IsEqualGUID,iid,offset IID_IUnknown
	.endif
	mov		edx,ppvObject
	.if	eax
		mov		eax,pthis
		mov		[edx],eax
		mov		edx,[eax]
		invoke [edx].IDropTarget.iu.AddRef,eax
		mov		eax,S_OK
	.else
		mov		dword ptr [edx],0
		mov		eax,E_NOINTERFACE
	.endif
	ret

IDropTarget_QueryInterface endp

IDropTarget_AddRef proc	pthis

;PrintText 'IDropTarget_AddRef'
	mov		eax,pthis
	mov		eax,[eax]
	inc		[eax].IDropTarget.refcount
	mov		eax,[eax].IDropTarget.refcount
	ret

IDropTarget_AddRef endp

IDropTarget_Release	proc pthis

;PrintText 'IDropTarget_Release'
	mov		eax,pthis
	mov		eax,[eax]
	inc		[eax].IDropTarget.refcount
	mov		eax,[eax].IDropTarget.refcount
	ret

IDropTarget_Release	endp

IDropTarget_DragEnter proc uses	ebx	esi	edi,pthis,lpDataObject,grfKeyState,pt:POINT,lpdwEffect
	LOCAL	medium:STGMEDIUM
	LOCAL	fmte:FORMATETC

;PrintText 'IDropTarget_DragEnter'
	mov		esi,lpDataObject
	mov		ebx,lpdwEffect
	mov		edi,pthis
	mov		edi,[edi]

	mov		dword ptr [ebx],DROPEFFECT_NONE
	mov		[edi].IDropTarget.valid,FALSE
	mov		eax,E_INVALIDARG
	.if esi
		mov		fmte.cfFormat,CF_TEXT
		mov		fmte.lptd,NULL
		mov		fmte.dwAspect,DVASPECT_CONTENT
		mov		fmte.lindex,-1
		mov		fmte.tymed,TYMED_HGLOBAL
		mov		edx,[esi]
		invoke [edx].IDataObject.GetData,esi,addr fmte,addr medium
		.if eax==S_OK
			.if grfKeyState & MK_ALT
				mov		dword ptr [ebx],DROPEFFECT_MOVE
			.else
				mov		dword ptr [ebx],DROPEFFECT_COPY 
			.endif
			mov		[edi].IDropTarget.valid,TRUE
			mov		eax,medium.pUnkForRelease
			.if eax
				mov		edx,[eax]
				invoke [edx].IDataObject.iu.Release,eax
			.else
				invoke GlobalFree,medium.hGlobal
			.endif
			mov		eax,S_OK
		.endif
	.endif
	ret

IDropTarget_DragEnter endp

IDropTarget_DragOver proc pthis,grfKeyState,pt:POINT,lpdwEffect

;PrintText 'IDropTarget_DragOver'
	mov		eax,pthis
	mov		eax,[eax]
	mov		edx,lpdwEffect
	mov		dword ptr [edx],DROPEFFECT_NONE
	.if [eax].IDropTarget.valid
		.if grfKeyState & MK_ALT
			mov		dword ptr [edx],DROPEFFECT_MOVE
		.else
			mov		dword ptr [edx],DROPEFFECT_COPY
		.endif
	.endif
	mov		eax,S_OK
	ret

IDropTarget_DragOver endp

IDropTarget_DragLeave proc pthis

;PrintText 'IDropTarget_DragLeave'
	mov		eax,S_OK
	ret

IDropTarget_DragLeave endp

IDropTarget_Drop proc uses ebx esi edi,pthis,lpDataObject,grfKeyState,pt:POINT,lpdwEffect
	LOCAL	medium:STGMEDIUM
	LOCAL	fmte:FORMATETC

;PrintText 'IDropTarget_Drop'
	mov		esi,lpDataObject
	mov		ebx,lpdwEffect
	mov		edi,pthis
	mov		edi,[edi]
	mov		eax,E_INVALIDARG
	mov		dword ptr [ebx],DROPEFFECT_NONE
	mov		[edi].IDropTarget.valid,FALSE
	.if esi
		mov		fmte.cfFormat,CF_TEXT
		mov		fmte.lptd,NULL
		mov		fmte.dwAspect,DVASPECT_CONTENT
		mov		fmte.lindex,-1
		mov		fmte.tymed,TYMED_HGLOBAL
		mov		edx,[esi]
		invoke [edx].IDataObject.GetData,esi,addr fmte,addr medium
		.if eax==S_OK
			invoke WindowFromPoint,pt.x,pt.y
			push	eax
			mov		edx,eax
			invoke ScreenToClient,edx,addr pt
			pop		eax
			invoke ChildWindowFromPoint,eax,pt.x,pt.y
			push	eax
			invoke GlobalLock,medium.hGlobal
			pop		edx
			invoke SetWindowText,edx,eax
			invoke GlobalUnlock,medium.hGlobal
			mov		[edi].IDropTarget.valid,TRUE
			.if grfKeyState & MK_ALT
				mov		dword ptr [ebx],DROPEFFECT_MOVE
			.else
				mov		dword ptr [ebx],DROPEFFECT_COPY
			.endif
			mov		eax,medium.pUnkForRelease
			.if eax
				mov		edx,[eax]
				invoke [edx].IDataObject.iu.Release,eax
			.else
				invoke GlobalFree,medium.hGlobal
			.endif
			mov		eax,S_OK
		.endif
	.endif
	ret

IDropTarget_Drop endp

;IDropSource methods
IDropSource_QueryInterface proc	pthis,iid,ppvObject

;PrintText 'IDropSource_QueryInterface'
	invoke IsEqualGUID,iid,offset IID_IDropSource
	.if	!eax
		invoke IsEqualGUID,iid,offset IID_IUnknown
	.endif
	mov		edx,ppvObject
	.if	eax
		mov		eax,pthis
		mov		[edx],eax
		mov		edx,[eax]
		invoke [edx].IDropSource.iu.AddRef,eax
		mov		eax,S_OK
	.else
		mov		dword ptr [edx],0
		mov		eax,E_NOINTERFACE
	.endif
	ret

IDropSource_QueryInterface endp

IDropSource_AddRef proc	pthis

;PrintText 'IDropSource_AddRef'
	mov		eax,pthis
	mov		eax,[eax]
	inc		[eax].IDropSource.refcount
	mov		eax,[eax].IDropSource.refcount
	ret

IDropSource_AddRef endp

IDropSource_Release	proc pthis

;PrintText 'IDropSource_Release'
	mov		eax,pthis
	mov		eax,[eax]
	.if [eax].IDropTarget.refcount
		dec		[eax].IDropTarget.refcount
	.endif
	mov		eax,[eax].IDropTarget.refcount
	ret

IDropSource_Release	endp

IDropSource_QueryContinueDrag proc pthis,fEscapePressed,grfKeyState

;PrintText 'IDropSource_QueryContinueDrag'
	.if	fEscapePressed
		mov		eax,DRAGDROP_S_CANCEL
	.elseif	!(grfKeyState &	MK_LBUTTON)
		mov		eax,DRAGDROP_S_DROP
	.else
		mov		eax,S_OK
	.endif
	ret

IDropSource_QueryContinueDrag endp

IDropSource_GiveFeedback proc pthis,dwEffect

;PrintText 'IDropSource_GiveFeedback'
	mov		eax,DRAGDROP_S_USEDEFAULTCURSORS
	ret

IDropSource_GiveFeedback endp

;IDataObject methods
IDataObject_QueryInterface proc	pthis,iid,ppvObject

;PrintText 'IDataObject_QueryInterface'
	invoke IsEqualGUID,iid,offset IID_IDataObject
	.if	!eax
		invoke IsEqualGUID,iid,offset IID_IUnknown
	.endif
	mov		edx,ppvObject
	.if	eax
		mov		eax,pthis
		mov		[edx],eax
		mov		edx,[eax]
		invoke [edx].IDataObject.iu.AddRef,eax
		mov		eax,S_OK
	.else
		mov		dword ptr [edx],0
		mov		eax,E_NOINTERFACE
	.endif
	ret

IDataObject_QueryInterface endp

IDataObject_AddRef proc	pthis

;PrintText 'IDataObject_AddRef'
	mov		eax,pthis
	mov		eax,[eax]
	inc		[eax].IDataObject.refcount
	mov		eax,[eax].IDataObject.refcount
	ret

IDataObject_AddRef endp

IDataObject_Release	proc pthis

;PrintText 'IDataObject_Release'
	mov		eax,pthis
	mov		eax,[eax]
	.if	[eax].IDataObject.refcount
		dec		[eax].IDataObject.refcount
	.endif
	mov		eax,[eax].IDataObject.refcount
	ret

IDataObject_Release	endp

IDO_GetData	proc uses ebx,pthis,pFormatetc,pmedium

;PrintText 'IDataObject_GetData'
	mov		ebx,pFormatetc
	.if [ebx].FORMATETC.cfFormat==CF_TEXT
		.if [ebx].FORMATETC.dwAspect==DVASPECT_CONTENT
			.if [ebx].FORMATETC.lindex==-1
				.if [ebx].FORMATETC.tymed==TYMED_HGLOBAL
					invoke GlobalAlloc,GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT,sizeof AboutMsg
					mov		ebx,eax
					invoke GlobalLock,ebx
					invoke lstrcpy,eax,offset AboutMsg
					invoke GlobalUnlock,ebx
					mov		eax,pmedium
					mov		[eax].STGMEDIUM.tymed,TYMED_HGLOBAL
					mov		[eax].STGMEDIUM.hGlobal,ebx
					mov		[eax].STGMEDIUM.pUnkForRelease,NULL
					mov		eax,S_OK
				.else
					mov		eax,DV_E_TYMED
				.endif
			.else
				mov		eax,DV_E_LINDEX
			.endif
		.else
			mov		eax,DV_E_DVASPECT
		.endif
	.else
		mov		eax,DV_E_FORMATETC
	.endif
	ret

IDO_GetData	endp

IDO_GetDataHere	proc uses ebx,pthis,pFormatetc,pmedium

;PrintText 'IDataObject_GetDataHere'
	mov		eax,E_NOTIMPL
	ret

IDO_GetDataHere	endp

IDO_QueryGetData proc uses ebx,pthis,pFormatetc

;PrintText 'IDataObject_QueryGetData'
	mov		ebx,pFormatetc
	.if [ebx].FORMATETC.cfFormat==CF_TEXT
		.if [ebx].FORMATETC.dwAspect==DVASPECT_CONTENT
			.if [ebx].FORMATETC.lindex==-1
				.if [ebx].FORMATETC.tymed==TYMED_HGLOBAL
					mov		eax,S_OK
				.else
					mov		eax,DV_E_TYMED
				.endif
			.else
				mov		eax,DV_E_LINDEX
			.endif
		.else
			mov		eax,DV_E_DVASPECT
		.endif
	.else
		mov		eax,DV_E_FORMATETC
	.endif
	ret

IDO_QueryGetData endp

IDO_GetCanonicalFormatEtc proc uses	esi	edi,pthis,pFormatetcIn,pFormatetcOut

;PrintText 'IDataObject_GetCanonicalFormatEtc'
	mov		esi,pFormatetcIn
	mov		edi,pFormatetcOut
	mov		ecx,sizeof FORMATETC
	rep		movsb
	mov		[edi].FORMATETC.lptd,NULL
	mov		eax, DATA_S_SAMEFORMATETC
	ret

IDO_GetCanonicalFormatEtc endp

IDO_SetData	proc pthis,pFormatetc,pmedium,fRelease

;PrintText 'IDataObject_SetData'
	mov		eax,E_NOTIMPL
	ret

IDO_SetData	endp

IDO_EnumFormatEtc proc pthis,dwDirection,ppenumFormatetc

;PrintText 'IDataObject_EnumFormatEtc'
	.if	dwDirection==DATADIR_GET
		mov		eax,offset pvtIEnumFORMATETC
		mov		edx,ppenumFormatetc
		mov		[edx],eax
		mov		eax,S_OK
	.else
		mov		eax,E_NOTIMPL
	.endif
	ret

IDO_EnumFormatEtc endp

IDO_DAdvise	proc pthis,pFormatetc,advf,pAdvSink,pdwConnection

;PrintText 'IDataObject_DAdvise'
	mov		eax,E_NOTIMPL
	ret

IDO_DAdvise	endp

IDO_DUnadvise proc pthis,dwConnection

;PrintText 'IDataObject_DUnadvise'
	mov		eax,E_NOTIMPL
	ret

IDO_DUnadvise endp

IDO_EnumDAdvise	proc pthis,ppenumAdvise

;PrintText 'IDataObject_EnumDAdvise'
	mov		eax,E_NOTIMPL
	ret

IDO_EnumDAdvise	endp

;IEnumFORMATETC	methods
IEnumFORMATETC_QueryInterface proc pthis,iid,ppvObject

;PrintText 'IEnumFORMATETC_QueryInterface'
	invoke IsEqualGUID,iid,offset IID_IEnumFORMATETC
	.if	!eax
		invoke IsEqualGUID,iid,offset IID_IUnknown
	.endif
	mov		edx,ppvObject
	.if	eax
		mov		eax,pthis
		mov		[edx],eax
		mov		edx,[eax]
		invoke [edx].IEnumFORMATETC.iu.AddRef,eax
		mov		eax,S_OK
	.else
		mov		dword ptr [edx],0
		mov		eax,E_NOINTERFACE
	.endif
	ret

IEnumFORMATETC_QueryInterface endp

IEnumFORMATETC_AddRef proc pthis

;PrintText 'IEnumFORMATETC_AddRef'
	mov		eax,pthis
	mov		eax,[eax]
	inc		[eax].IEnumFORMATETC.refcount
	mov		eax,[eax].IEnumFORMATETC.refcount
	ret

IEnumFORMATETC_AddRef endp

IEnumFORMATETC_Release proc	pthis

;PrintText 'IEnumFORMATETC_Release'
	mov		eax,pthis
	mov		eax,[eax]
	.if [eax].IEnumFORMATETC.refcount
		dec		[eax].IEnumFORMATETC.refcount
	.endif
	.if ![eax].IEnumFORMATETC.refcount
		mov		[eax].IEnumFORMATETC.ifmt,0
	.endif
	mov		eax,[eax].IEnumFORMATETC.refcount
	ret

IEnumFORMATETC_Release	endp

IEnumFORMATETC_Next	proc pthis,celt,rgelt,pceltFetched

;PrintText 'IEnumFORMATETC_Next'
	xor		edx,edx
	mov		eax,pthis
	mov		eax,[eax]
	mov		ecx,[eax].IEnumFORMATETC.ifmt
	.if	ecx<[eax].IEnumFORMATETC.ifmtmax
		inc		edx
		inc		ecx
		mov		[eax].IEnumFORMATETC.ifmt,ecx
		mov		eax,rgelt
		mov		[eax].FORMATETC.cfFormat,CF_TEXT
		mov		[eax].FORMATETC.lptd,NULL
		mov		[eax].FORMATETC.dwAspect,DVASPECT_CONTENT
		mov		[eax].FORMATETC.lindex,-1
		mov		[eax].FORMATETC.tymed,TYMED_HGLOBAL
	.endif
	mov		eax,pceltFetched
	.if	eax
		mov		[eax],edx
	.endif
	.if	edx==celt
		mov		eax,S_OK
	.else
		mov		eax,S_FALSE
	.endif
	ret

IEnumFORMATETC_Next	endp

IEnumFORMATETC_Skip	proc pthis,celt

;PrintText 'IEnumFORMATETC_Skip'
	mov		eax,E_NOTIMPL
	ret

IEnumFORMATETC_Skip	endp

IEnumFORMATETC_Reset proc pthis

;PrintText 'IEnumFORMATETC_Reset'
	mov		eax,pthis
	mov		eax,[eax]
	mov		[eax].IEnumFORMATETC.ifmt,0
	mov		eax,S_OK
	ret

IEnumFORMATETC_Reset endp

IEnumFORMATETC_Clone proc pthis,ppenum

;PrintText 'IEnumFORMATETC_Clone'
	mov		eax,E_NOTIMPL
	ret

IEnumFORMATETC_Clone endp

