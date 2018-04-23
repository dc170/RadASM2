; Simple Classic interface script template.

;Application specification
!define PRODUCT_NAME "MyProject"
!define PRODUCT_VERSION "FileVersion"


;Setup options 
SetCompressor zlib

;Setup options
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
InstallDir "$PROGRAMFILES\MyProject"
Icon "Path to icon\MyInstallIcon.ico"
DirText "Setup will install $(^Name) in the following folder.$\r$\n$\r$\nTo install in a different folder, click Browse and select another folder."
LicenseText "If you accept all the terms of the agreement, choose I Agree to continue. You must accept the agreement to install $(^Name)."
LicenseData "path to MyProject\Licens.txt"

Section Install
	SetOutPath "$INSTDIR\"
	SetOverwrite ifnewer
	File "Path to MyProject\MyApp.exe"

	CreateDirectory "$SMPROGRAMS\MyProject"

	CreateShortCut "$SMPROGRAMS\MyProject\MyProject.lnk" "$INSTDIR\MyApp.exe"
	CreateShortCut "$DESKTOP\MyProject.lnk" "$INSTDIR\MyApp.exe"
SectionEnd

