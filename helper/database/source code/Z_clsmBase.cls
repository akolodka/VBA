VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Z_clsmBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'����� ������������ ������ ������ �� �����, ��������� �������� �� �����
Option Explicit
Private sArrParameters() As String, sArrFile() As String, sArrValues() As String, sSavePath As String
'#######################################################
'����� ����������� ��� �������� ������
Private Sub Class_Initialize()
    ReDim sArrParameters(0)
End Sub
'#######################################################
'������� ��������� ������ ������� ����������
Function AddP(sItem1 As String, Optional sItem2 As String, Optional sItem3 As String)
    '���� ������ �����, ��������� ���
    If sItem1 <> "" Then
        If sArrParameters(UBound(sArrParameters)) <> "" Then ReDim Preserve sArrParameters(UBound(sArrParameters) + 1)
        sArrParameters(UBound(sArrParameters)) = sItem1 '�������� �������� � ������
    End If
    If sItem2 <> "" Then
        If sArrParameters(UBound(sArrParameters)) <> "" Then ReDim Preserve sArrParameters(UBound(sArrParameters) + 1)
        sArrParameters(UBound(sArrParameters)) = sItem2 '�������� �������� � ������
    End If
    If sItem3 <> "" Then
        If sArrParameters(UBound(sArrParameters)) <> "" Then ReDim Preserve sArrParameters(UBound(sArrParameters) + 1)
        sArrParameters(UBound(sArrParameters)) = sItem3 '�������� �������� � ������
    End If
End Function
'#######################################################
'����� ������� ������ ����������
Sub ClearParameters()
    ReDim sArrParameters(0)
End Sub
Property Get Parameters() As String()
    Parameters = sArrParameters()
End Property
Property Get values() As String()
    values = sArrValues()
End Property
'#######################################################
'������� ���������� ������ ����� �� ���������� ����, � ����� ��������� ���������� ������ �����
Function GetArrFF( _
    sPath As String, _
    Optional sFName As String _
    ) As String()

    Dim i As Integer, sArrTemp() As String, iFileInd As Integer
    If sFName <> "" Then '���� ������� ��������� ��� ����� � ��������
        sSavePath = sPath & sFName
        If FileExist(sPath & sFName) = False Then ReDim sArrFile(0): Exit Function
        
    Else '������ ������ ����
        sSavePath = sPath
        If FileExist(sPath) = False Then ReDim sArrFile(0): Exit Function
    End If
    
    iFileInd = FreeFile '�������� ����� ������� ���������� �����
    
    Open sSavePath For Input As iFileInd
        sArrTemp = Split(Input$(LOF(iFileInd), #iFileInd), vbNewLine) '��������� � ������ ���������� ����� �����
    Close
    
     '�������� ������ �� ������� � ���������� ��������� ����������� ������
    For i = UBound(sArrTemp) To LBound(sArrTemp) Step -1
        If sArrTemp(i) <> "" Then Exit For '���������� ������� ������� ������������ �������
    Next i
    
    If i < 0 Then i = 0 '�� ������, ���� ������ ��� ������
    ReDim Preserve sArrTemp(i) '������� �� �������� ������� ������ �������� � �����
    sArrFile = sArrTemp: GetArrFF = sArrTemp
    
End Function
'#######################################################
'������� ���������� ������ �������� �� �������-���������
Function FillValues()
    Dim i As Integer, j As Integer, bolNotExitCycle As Boolean, sArrTemp() As String
    
    ReDim sArrValues(UBound(sArrParameters))
    
    If sArrParameters(UBound(sArrParameters)) <> "" Then '���� �������� ���������� ����������
        For i = LBound(sArrFile) To UBound(sArrFile) '�������� �� ����� �������
            For j = LBound(sArrParameters) To UBound(sArrParameters)
                
                '���� ������ ������� �������� ������ �����, �������� �������� � ������� ������
                If sArrFile(i) Like sArrParameters(j) & "=*" Then
                    If sArrValues(j) = "" Or sArrValues(j) = "����������" Then '���� �������� �� ���� �������� �����
                    
                        sArrTemp = Split(sArrFile(i), "=")
                        If UBound(sArrTemp) = 1 Then sArrValues(j) = sArrTemp(UBound(sArrTemp))
                    End If
                End If
            Next j
            '����� �� ����� ��������� ���� ����� ������� ��������, ���� �������� ��� ��������
            For j = LBound(sArrParameters) To UBound(sArrParameters)
                If sArrValues(j) = "" Then bolNotExitCycle = True: Exit For
            Next j
            If bolNotExitCycle = False Then Exit For '���� ��� ��������� �������� � �������� ������
        Next i
        '��������� ������ ��� ���������� ������ ��������
        For j = LBound(sArrParameters) To UBound(sArrParameters)
            If sArrValues(j) = "" Then sArrValues(j) = "����������"
        Next j
    End If
End Function
'#######################################################
'����� ����� ������ �������� �� ��������� �������
Sub SaveProperties(Parameters() As String, values() As String)

    If Dir(setDir, vbDirectory) = "" Then MkDir setDir      '����� ������������� ������ ��� ����������
    
    Dim i As Integer, j As Integer, iFillCount As Integer, sTempStr As String, iFileInd As Integer
    Dim bolArrFill() As Boolean
    
    sArrParameters = Parameters: sArrValues = values
    
    iFillCount = UBound(sArrValues) + 1 '���������� ���������� ���� ������
    ReDim bolArrFill(UBound(sArrValues)) '������ �������� ����� � ����
    
    For i = LBound(sArrFile) To UBound(sArrFile) '�������� �� ����� ��������� �������
        If iFillCount > 0 Then '���������� ����� �������� ���� ��������
        
            For j = LBound(sArrParameters) To UBound(sArrParameters)
            
                '���� ������ ������� �������� ������ �����, �������� �������� � ������� ������
                If sArrFile(i) Like sArrParameters(j) & "=*" Then
                    If sArrValues(j) = "" Then sArrValues(j) = "����������"
                    sArrFile(i) = sArrParameters(j) & "=" & sArrValues(j) '�������� �������� � ������
                    
                    iFillCount = iFillCount - 1: bolArrFill(j) = True: Exit For
                End If
            Next j
        End If
        sTempStr = sTempStr & sArrFile(i)
        If i < UBound(sArrFile) Then sTempStr = sTempStr & vbNewLine
    Next i
    
    If iFillCount > 0 Then '�������� �� ��� ����������
        For i = LBound(bolArrFill) To UBound(bolArrFill)
            If bolArrFill(i) = False Then '������ ���������� �� ���� ��������
                
                If sTempStr <> "" Then _
                    sTempStr = sTempStr & vbNewLine '����� �� ���� ������ ����� ��� ������ ����������
                
                sTempStr = sTempStr & sArrParameters(i) & "=" & sArrValues(i)
                bolArrFill(i) = True: iFillCount = iFillCount - 1
            End If
            If iFillCount < 0 Then Exit For '����������� ��� ���������
        Next i
    End If
    
    iFileInd = FreeFile '�������� ����� ������� ���������� �����
    
    Open sSavePath For Output As iFileInd '������� ���� ��� ������
        Print #iFileInd, sTempStr
    Close
End Sub
