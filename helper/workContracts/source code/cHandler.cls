VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Enum ENotifyTypes

    debugMessage
    msgboxMessage
    debugAndMsgbox
    nomessage
        
End Enum

Public Sub Notify( _
    mes As String, _
    Optional msgType As ENotifyTypes = msgboxMessage _
    )
    
    Select Case True
        
        Case msgType = nomessage
            Exit Sub
        
        Case msgType = debugMessage
            Debug.Print mes
        
        Case msgType = msgboxMessage
            MsgBox mes
            
        Case msgType = debugAndMsgbox
            Debug.Print mes
            MsgBox mes
            
    End Select
    
End Sub

Public Function Ask( _
    mes As String, _
    Optional answer As Integer = vbNo _
    ) As Integer
    
    Ask = answer
    Ask = MsgBox(Prompt:=mes, Buttons:=vbYesNo + vbDefaultButton2)
    
    
'    If UserForms.Count = 0 Then _
'        Debug.Print "Question is: "; mes
'        Debug.Print "Answer is: "; answer
'
'    If UserForms.Count > 0 Then _
'        Ask = MsgBox(Prompt:=mes, Buttons:=vbYesNo)
    
End Function

