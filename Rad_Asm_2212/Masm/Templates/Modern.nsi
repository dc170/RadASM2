; Modern interface script template.

;Application specification
!define PRODUCT_NAME "MyProject"
!define PRODUCT_VERSION "FileVersion"
!define PRODUCT_PUBLISHER "Author"
!define PRODUCT_WEB_SITE "Website"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\MyApp.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"


;Setup options Modern User Interface
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "Path to icon\MyInstallIcon.ico"
!define MUI_UNICON "Path to icon\MyUninstallIcon.ico"
!insertmacro MUI_PAGE_WELCOME
!define MUI_LICENSEPAGE_CHECKBOX/RADIOBUTTONS ;Classic buttons delete the line
!insertmacro MUI_PAGE_LICENSE "path to MyProject\Licens.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\MyApp.exe"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

;Setup options
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\MyProject"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section Install
	SetOutPath "$INSTDIR\"
	SetOverwrite ifnewer
	File "Path to MyProject\MyApp.exe"

	CreateDirectory "$SMPROGRAMS\MyProject"

	CreateShortCut "$SMPROGRAMS\MyProject\MyProject.lnk" "$INSTDIR\MyApp.exe"
	CreateShortCut "$DESKTOP\MyProject.lnk" "$INSTDIR\MyApp.exe"

	WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
	CreateShortCut "$SMPROGRAMS\MyProject\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"

	CreateShortCut "$SMPROGRAMS\MyProject\Uninstall.lnk" "$INSTDIR\uninst.exe"

	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\MyApp.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\MyApp.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
	HideWindow
	MessageBox MB_ICONINFORMATION|MB_OK "MyProject was successfully removed from your computer."
FunctionEnd

Function un.onInit
	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove MyProject and all of its components?" IDYES +2
	Abort
FunctionEnd

Section Uninstall
	Delete "$INSTDIR\${PRODUCT_NAME}.url"
	Delete "$INSTDIR\uninst.exe"

	Delete "$INSTDIR\MyAPP.exe"

	Delete "$SMPROGRAMS\MyProject\Uninstall.lnk"
	Delete "$SMPROGRAMS\MyProject\MyProject.lnk"
	Delete "$DESKTOP\MyProject.lnk"

	RMDir "$INSTDIR"
	RMDir "$SMPROGRAMS\MyProject"

	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
	SetAutoClose true
SectionEnd
