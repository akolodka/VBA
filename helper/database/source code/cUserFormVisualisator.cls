VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cUserFormVisualisator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const SUFFIX_ONE = "�������"
Const SUFFIX_TWO = "��������"
Const SUFFIX_THREE = "���������"

Const LABEL_LENGTH = 50

' ----------------------------------------------------------------
' ����: 19.03.2023 10:48
' ----------------------------------------------------------------
Public Function ItemTextSuffix( _
    value As String _
    ) As String
    
    Dim rightChar As String
    rightChar = Right(value, 1)
    
    Dim result As String
    Select Case rightChar
    
        Case 1
        
            result = value & " " & SUFFIX_ONE
            
            If Len(value) >= 2 Then
            
                If Right(value, 2) = 11 Then _
                    result = value & " " & SUFFIX_THREE
                
            End If
            
        Case 2 To 4
            result = value & " " & SUFFIX_TWO
            
            If Len(value) >= 2 Then
            
                If Right(value, 2) >= 12 And Right(value, 2) <= 14 Then _
                    result = value & " " & SUFFIX_THREE
                
            End If
            
        Case Else
            result = value & " " & SUFFIX_THREE
            
            
    End Select
    
    ItemTextSuffix = result
    
End Function
' ----------------------------------------------------------------
' ����: 19.03.2023 10:55
' ----------------------------------------------------------------
Public Function ShortedString( _
    strData As String, _
    Optional maxLength As Integer = LABEL_LENGTH _
    ) As String
    
    ShortedString = strData ' �� ��������� ���������� ��� ������ '�������� ���� ��������� ���������
    
    Dim leftPart As String, _
        rightPart As String, _
        iStrStart As Integer
        
    If Len(strData) > maxLength Then '����� �� ��������� ���������
        
        iStrStart = InStr(strData, Application.PathSeparator)
        
        If Not (CBool(iStrStart)) Then _
            Exit Function
        
        If iStrStart + 2 <= Len(strData) Then _
            leftPart = Left(strData, InStr(iStrStart + 2, strData, Application.PathSeparator)) '������������ ����� ����� ������
        
        If maxLength - Len(leftPart) - 5 >= 0 Then _
            rightPart = Right(strData, maxLength - Len(leftPart) - 5) ' ����� �� ���� ������ � ������ �������� ������

        ShortedString = leftPart & " ... " & rightPart
    End If
    
End Function

' ----------------------------------------------------------------
' ����: 21.03.2023 21:28
' ----------------------------------------------------------------
Public Function LabelBackgroundText( _
    typeDb As EDadaBaseTypes _
    ) As String
    
    Dim result As String
    Select Case True
    
        Case typeDb = organisations
            result = "����� �����������..."
        
        Case typeDb = instruments
            result = "����� �������� ���������..."
        
        Case typeDb = persons
            result = "����� � �������� �����..."

        Case typeDb = etalons
            result = "����� �������� �������..."

        Case typeDb = archiveLocal
            result = "����� � ������..."
            
    End Select
    
    LabelBackgroundText = result
End Function

