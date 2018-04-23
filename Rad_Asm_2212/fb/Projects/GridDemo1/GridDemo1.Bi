#define IDD_DLG1 1000 
#define IDC_BTN1 1001
#define IDC_GRD1 1002

dim SHARED hLib as integer
dim SHARED hGrd as HWND

type ROWDATA
	lpszName as string ptr			' Data for Name column. Pointer to string
	lpszAddress as string ptr		' Data for Address column. Pointer to string
	nPoints as integer				' Data for Points column. Integer value
	lpszButton1 as string ptr		' Data for Button column
end type

' Just some row data
CONST szName1="Name#1"
CONST szAddress1="Address#1"
CONST szName2="Name#2"
CONST szAddress2="Address#2"
CONST szName3="Name#3"
CONST szAddress3="Address#3"
CONST szName4="Name#4"
CONST szAddress4="Address#4"

dim SHARED rdta1 as ROWDATA=(@szName1,@szAddress1,2000,@szAddress1)
dim SHARED rdta2 as ROWDATA=(@szName2,@szAddress2,4000,@szAddress2)
dim SHARED rdta3 as ROWDATA=(@szName3,@szAddress3,3000,@szAddress3)
dim SHARED rdta4 as ROWDATA=(@szName4,@szAddress4,5000,@szAddress4)
