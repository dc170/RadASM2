VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "MyCom Server Tester"
   ClientHeight    =   4380
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3105
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4380
   ScaleWidth      =   3105
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   "Object 1"
      Height          =   3495
      Left            =   420
      TabIndex        =   0
      Top             =   360
      Width           =   2235
      Begin VB.CommandButton cmdReset1 
         Caption         =   "Reset"
         Height          =   375
         Left            =   540
         TabIndex        =   6
         Top             =   2880
         Width           =   1155
      End
      Begin VB.CommandButton cmdRaise1 
         Caption         =   "Raise"
         Height          =   375
         Left            =   540
         TabIndex        =   3
         Top             =   2280
         Width           =   1155
      End
      Begin VB.TextBox Text2 
         Height          =   315
         Left            =   240
         TabIndex        =   2
         Text            =   "10"
         Top             =   1680
         Width           =   1755
      End
      Begin VB.TextBox Text1 
         Height          =   315
         Left            =   240
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   660
         Width           =   1755
      End
      Begin VB.Label Label2 
         Caption         =   "Raise Value:"
         Height          =   195
         Left            =   300
         TabIndex        =   5
         Top             =   1440
         Width           =   915
      End
      Begin VB.Label Label1 
         Caption         =   "Value:"
         Height          =   195
         Left            =   300
         TabIndex        =   4
         Top             =   420
         Width           =   675
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents MC3 As MyCom3
Attribute MC3.VB_VarHelpID = -1

Private Sub cmdRaise1_Click()
    MC3.Raise (Text2)       ' read the object value
    Text1 = MC3.Value       ' refresh the display
End Sub
Private Sub cmdReset1_Click()
    MC3.Value = 0           ' set the object value to zero
    Text1 = MC3.Value       ' refresh the display
End Sub
Private Sub Form_Load()
    Set MC3 = New MyCom3    ' create the objects
    MC3.Value = 10          ' set initial values
    Text1 = MC3.Value       ' refresh the displays
End Sub

Private Sub MC3_XMax()
    MsgBox " We just got an event!", vbOKOnly, "Look at this"
End Sub

