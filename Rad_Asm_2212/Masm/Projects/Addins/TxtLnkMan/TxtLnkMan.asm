;#########################################################################
;		Assembler directives

.486
.model flat,stdcall
option casemap:none

;#########################################################################
;		Include file

include TxtLnkMan.inc

.code

; Finds links in main .txt file of proj
GetLinks	PROC uses esi edi,hMem,szStrSearch
LOCAL	pf:				PROFIND
LOCAL	buff[32]:		BYTE

	mov edx,hMem
	mov pf.hMem,edx
	lea eax, buff
	mov pf.lpFind,eax			
	invoke lstrcpy,eax,szStrSearch
	invoke lstrlen,eax
	mov searchLen,eax
	mov dword ptr buff[eax],'0,'
	mov pf.nFun,0
	mov pf.pFile,0
	mov pf.lpNot,offset szNot
	mov pf.lpLine,offset lineBuff
	mov pf.pLine,0				; RET: pos(in line buff)
	mov pf.nFile,0
	mov pf.pMem,0				; RET: ptr(where the found line start)
@@:	
	lea eax, pf
	push eax
	mov eax, lpProc
	call (ADDINPROCS ptr[eax]).lpProFind
	.if pf.pLine==-1
		jmp @f
	.endif

	mov eax, searchLen
	add pf.pMem,eax
	mov edi, pf.pMem
; what kind of link?
		cmp byte ptr[edi], 'N'			; NOTE
		je	note
		cmp byte ptr[edi], 'B'			; BUG
		je	bug
		cmp byte ptr[edi], 'T'			; TODO
		je todo
		
		mov pf.pMem, edi				; ... else not a link, try again!
		jmp @b
; note	-----------------------------------		
	note:
		mov ecx,nN						; number of chars
		mov esi,offset szNoteArr		; 
		add esi,ecx						; place after prev.
		add edi,4
	bn:			
		mov al, byte ptr[edi]			; get after NOTE
		cmp al, ':'						; is a ':'
		je fn							; then dont get
		mov byte ptr[esi],al			; put 
		inc esi							; ++
		inc edi							; get another char
		inc nN							; char index
		jmp bn							; compare them
	fn:	
		mov word ptr[esi],0				; terminate (00 00)
		inc nN
		mov pf.pMem,edi								
		jmp @b
; bug	-----------------------------------				
	bug:
		mov ecx,nB
		mov esi, offset szBugArr
		add esi,ecx
		add edi,3
	bb:	
		mov al, byte ptr[edi]
		cmp al, ':'
		je fb
		mov byte ptr[esi],al
		inc esi
		inc edi
		inc nB
		jmp bb
	fb:
		mov word ptr[esi],0
		inc nB
		mov pf.pMem,edi		
		jmp @b
; todo	-----------------------------------	
	todo:	
		mov ecx,nT
		mov esi, offset szTodoArr
		add esi,ecx
		add edi,4
	btt:	
		mov al, byte ptr[edi]
		cmp al, ':'
		je ftt
		mov byte ptr[esi],al
		inc esi
		inc edi
		inc nT
		jmp btt
	ftt:	
		mov word ptr[esi],0
		inc nT
		mov pf.pMem,edi
		jmp @b		
@@:		
			
	;Free memory
	mov pf.nFun,1
	lea eax, pf
	push eax
	mov eax, lpProc
	call (ADDINPROCS ptr[eax]).lpProFind
	RET

GetLinks ENDP

LoadListV PROC uses ebx edi esi,nTyp

	invoke SendMessage,hlist,LVM_DELETEALLITEMS,0,0
	xor ebx, ebx

	mov ecx, nTyp	
	mov esi, lpszLinks[ecx*4]			
	mov edi, lpszArrays[ecx*4]
	
	.while byte ptr[edi] != 0									; if all finished, must be another NULL
		mov lvi.iItem,ebx
		mov lvi.iSubItem,0
		invoke	lstrcpy, offset text, esi
		invoke	lstrcat, offset text, edi
		invoke SendMessage,hlist,LVM_INSERTITEM,0,offset lvi
		inc ebx													;increase item index
		invoke lstrlen,edi										; switch to
		add edi,eax												; after this string
		inc edi													; mm.. don't forget NULL :=)
	.endw
					
	RET

LoadListV ENDP

GotoLink PROC uses ebx,labelLnk
LOCAL	buffer[50]:	BYTE
LOCAL	findtxt:FINDTEXTEX
	
	invoke lstrcpy,addr buffer,addr szSee
	invoke lstrcat,addr buffer,labelLnk		; ex. buffer: ### SEE - NOTE2
	invoke lstrlen,eax
	mov edx,'3,'					; EDX: ,3 Whole Word and Case sensitive
	mov dword ptr buffer[eax],edx	; buffer: NOTE2,3
	lea edx, buffer
	push offset szNot
	push edx						; push buffer
	mov eax,lpProc
	call (ADDINPROCS ptr[eax]).lpProScan
	mov		findtxt.chrg.cpMin,0
	mov		findtxt.chrg.cpMax,-1
	mov		eax,labelLnk
	mov		findtxt.lpstrText,eax
	invoke SendMessage,hREd,EM_FINDTEXTEX,FR_DOWN or FR_MATCHCASE or FR_WHOLEWORD,addr findtxt
	.if eax!=-1
		invoke SendMessage,hREd,EM_EXSETSEL,0,addr findtxt.chrgText
		invoke SendMessage,hREd,EM_SCROLLCARET,0,0
		invoke SendMessage,hREd,REM_VCENTER,0,0
		invoke SendMessage,hREd,EM_SCROLLCARET,0,0
	.endif
	RET

GotoLink ENDP

PrepareListView PROC
	
	mov lvc.imask,LVCF_WIDTH+LVCF_FMT
	mov lvc.fmt,LVCFMT_LEFT
	mov lvc.lx,138	
	invoke SendMessage,hlist, LVM_INSERTCOLUMN,0,offset lvc
; grid lines etc.		
	invoke SendMessage,hlist,LVM_SETEXTENDEDLISTVIEWSTYLE,\
			LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT,\
			LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT	
	RET

PrepareListView ENDP

DlgManageProc PROC uses ebx hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	racol:RACOLOR
	LOCAL	rafnt:RAFONT

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke GetDlgItem,hWin,EDT_OUT
		mov		hREd,eax
		mov		edx,lpHandles
		mov		eax,[edx].ADDINHANDLES.hFontTxt
		mov		rafnt.hFont,eax
		mov		rafnt.hIFont,eax
		mov		eax,[edx].ADDINHANDLES.hFont[8]
		mov		rafnt.hLnrFont,eax
		invoke SendMessage,hREd,REM_SETFONT,0,addr rafnt
		mov		eax,lpData
		mov		eax,[eax].ADDINDATA.TabSize
		invoke SendMessage,hREd,REM_TABWIDTH,eax,FALSE
		invoke SendMessage,hREd,REM_GETCOLOR,0,addr racol
		xor		eax,eax
		mov		racol.bckcol,0FFFFFFh
		mov		racol.txtcol,0
		mov		racol.cmntcol,0
		mov		racol.strcol,0
		mov		racol.oprcol,0
		mov		racol.numcol,0
		invoke SendMessage,hREd,REM_SETCOLOR,0,addr racol
		invoke SendMessage,hREd,REM_SETWORDGROUP,0,15
		invoke SendMessage,hREd,REM_SETHILITEWORDS,hilitecolor,offset hilitewords
		invoke GetDlgItem,hWin,LSV_LINKS
		mov hlist,eax
		call PrepareListView
		invoke CheckDlgButton,hWin,RADIO_NOTE,BST_CHECKED
		
		mov eax,lpProc		
		push offset szTxt							; All links stored in main txt with names. 
		call (ADDINPROCS ptr[eax]).lpGetMainFile
		.if eax
			push eax
			invoke SetDlgItemText,hWin,EDT_OUT,eax			
			mov nN,0
			mov nB,0
			mov nT,0	
			pop	eax
			invoke GetLinks,eax,offset szLink		; which links does this project has?
		.endif						
		invoke LoadListV,0
		invoke SendMessage,hREd,REM_SETBLOCKS,0,offset rabdtxtlnk
						
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		mov		edx,eax
		shr		edx,16
		and		eax,0FFFFh
		.if edx==BN_CLICKED
			.if 	eax==BTN_REPLACE			
				invoke EndDialog,hWin,1
			.elseif eax==BTN_CANCEL || eax==IDCANCEL
				invoke EndDialog,hWin,0
			.elseif eax==RADIO_NOTE
				invoke LoadListV,0
			.elseif eax==RADIO_BUG
				invoke LoadListV,1
			.elseif eax==RADIO_TODO
				invoke LoadListV,2						
			.elseif ax==-3
				;Expand button clicked
				invoke SendMessage,hREd,REM_EXPANDALL,0,0
				invoke SendMessage,hREd,EM_SCROLLCARET,0,0
				invoke SendMessage,hREd,REM_REPAINT,0,0
			.elseif ax==-4
				;Collapse button clicked
				invoke SendMessage,hREd,REM_COLLAPSEALL,0,offset rabdtxtlnk
				invoke SendMessage,hREd,EM_SCROLLCARET,0,0
				invoke SendMessage,hREd,REM_REPAINT,0,0
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.elseif eax==WM_NOTIFY
		push edi
		mov edi,lParam
		mov eax,[edi].NMHDR.hwndFrom
		.if eax==hlist		
			.if [edi].NMHDR.code==NM_DBLCLK
				invoke SendMessage,hlist,LVM_GETNEXTITEM,-1,LVNI_FOCUSED+LVNI_ALL
				mov lvi.iItem,eax
		       	mov lvi.iSubItem,0
				invoke SendMessage,hlist,LVM_GETITEM,0,addr lvi
				; item text is in "text" variable				
				invoke GotoLink, addr text				
			.endif
		.else
			mov		eax,[edi].NMHDR.code
			.if eax==EN_SELCHANGE
				push	esi
				mov		eax,[edi].RASELCHANGE.chrg.cpMin
				sub		eax,[edi].RASELCHANGE.cpLine
				.if [edi].RASELCHANGE.seltyp==SEL_OBJECT
					invoke SendMessage,hREd,REM_GETBOOKMARK,[edi].RASELCHANGE.line,0
					.if eax==1
						;Collapse
						invoke SendMessage,hREd,REM_ISLINE,[edi].RASELCHANGE.line,rabdtxtlnk.lpszStart
						.if eax!=-1
							invoke SendMessage,hREd,REM_COLLAPSE,[edi].RASELCHANGE.line,offset rabdtxtlnk
						.endif
					.elseif eax==2
						;Expand
						invoke SendMessage,hREd,REM_EXPAND,[edi].RASELCHANGE.line,0
					.endif
				.endif
				pop		esi
			.endif
		.endif
		assume edi:nothing
		pop edi		
	.else
		mov	eax,FALSE
		ret
	.endif
	mov	eax,TRUE
	ret

DlgManageProc endp

;#########################################################################
;		Common AddIn Procedures

DllEntry proc hInst:HINSTANCE, reason:DWORD, reserved1:DWORD
	mov eax, hInst
	mov hInstance, eax
	mov eax, TRUE
	ret
DllEntry Endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
InstallDll proc uses ebx hWin:DWORD, fOpt:DWORD

	mov	ebx,hWin

	;Get pointer to handles struct
	invoke SendMessage,ebx,AIM_GETHANDLES,0,0
	mov	lpHandles,eax

	;Get pointer to proc struct
	invoke SendMessage,ebx,AIM_GETPROCS,0,0
	mov	lpProc,eax

	;Get pointer to data struct
	invoke SendMessage,ebx,AIM_GETDATA,0,0	
	mov	lpData,eax

	invoke InitCommonControls

	; Allocate a new menu id
	invoke SendMessage,ebx,AIM_GETMENUID,0,0
	mov IDAddIn,eax
	call	AddMenu

		; Messages to hook into
		mov	eax, RAM_COMMAND OR RAM_CLOSE OR RAM_MENUREBUILD OR \
				RAM_INITMENUPOPUP

	; ECX and EDX must be null before we return
	xor ecx, ecx
	xor edx, edx
	ret 

InstallDll Endp

AddMenu proc
	LOCAL nMnu:DWORD
	LOCAL hMnu:DWORD

	.if IDAddIn
		mov	nMnu,6
		;Adjust topmost popup if maximized
		mov	eax,[lpData]
		mov	eax,(ADDINDATA ptr [eax]).fMaximized
		.if eax
			inc	nMnu
		.endif

		;Get handle of menu
		mov	eax,[lpHandles]
		mov	eax,(ADDINHANDLES ptr [eax]).hMenu

		;Get handle of Tools popup
		invoke GetSubMenu,eax,nMnu
		mov		hMnu,eax

		;Add our menuitem
		invoke AppendMenu,hMnu,MF_STRING,IDAddIn,addr szMenuString
	.endif
	ret
AddMenu endp

; Export this proc (it is autoexported if MakeDef is enabled with option 2)
DllProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; This proc handles messages sent from RadASM to our dll
	; Return TRUE to prevent RadASM and other DLL's from

	mov	eax, uMsg
	.if eax == AIM_COMMAND
		mov eax,wParam
		movzx edx,ax
		shr eax, 16
		.IF edx == IDAddIn && eax == BN_CLICKED
			; Your addin has been selected
			invoke DialogBoxParam,hInstance,DLG_1,hWin,addr DlgManageProc,0
			mov eax, TRUE
			ret
		.ENDIF

	.ELSEIF eax==AIM_CLOSE
		mov edx,lpHandles
		mov eax,[edx].ADDINHANDLES.hMenu
		invoke DeleteMenu,eax,IDAddIn,MF_BYCOMMAND
		mov IDAddIn,0
	.ELSEIF eax==AIM_MENUREBUILD
		call AddMenu
	.elseif eax==AIM_INITMENUPOPUP
			mov eax,[lpData]
			mov eax,(ADDINDATA ptr [eax]).fProject
			
			;Enable/disable the menuitem
			mov	edx,MF_GRAYED		; if no project open
			.if eax
				mov	edx,MF_ENABLED	; else enable
			.endif
			mov		eax,[lpHandles]
			mov		eax,(ADDINHANDLES ptr [eax]).hMenu
			invoke EnableMenuItem,eax,IDAddIn,edx
	.endif

	mov eax,FALSE
	ret
DllProc Endp

;#########################################################################

End DllEntry
