VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Z_UF_MultiSelect_Load 
   Caption         =   "�������� ��������� ��������"
   ClientHeight    =   3555
   ClientLeft      =   30
   ClientTop       =   375
   ClientWidth     =   5610
   OleObjectBlob   =   "Z_UF_MultiSelect_Load.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Z_UF_MultiSelect_Load"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Option Compare Text

Const sKeywordPrimary = "���������" '����� ����� ������ �������������� � ������������ �����
Const FIF_PR_KEYWORD = "fif_"

Private myBase As New Z_clsmBase, WorkClsm As New Z_clsmSearch
Dim dbInstumentsDir As String, sArrKeyCode() As String
Private isFormLoaded As Boolean

Private Sub UserForm_Initialize()
    
    Dim verificationType As String, _
        rTempCell As Range, _
        TemplateFileName As String
    
    If FindCellRight("��� �������", rTempCell) Then _
        verificationType = CStr(rTempCell): _
        DeleteSpaceStEnd verificationType '��� ������� �� ��������� ���������

    With myMultiSel '����� ���������� ������������
        dbInstumentsDir = Dir(.sMSBaseDir & "*" & .sMSfifNum & "*", vbDirectory)  '���������� ��� ������ ������
        
        If UMenu.typ� <> instrumentsOLD Then '���� ��� ������ � ������ �������� �������������
            
            Me.chbPrimary.Enabled = True
            If verificationType = "���������" Then _
                Me.chbPrimary = True
                
            .sMSAdditionalText = GetAdditionTextFromComment
            
        Else '�������� ������� ���������
            
            If .bolThisWBSheetLoad Then '���� �������� ��� � ������� �����
            
                If verificationType = "���������" Then _
                    Me.chbPrimary = True '���� ��������, ��� ���� �������� �������� ��������� �������
                    
            Else
                If dbInstumentsDir <> vbNullString Then '���������� � ��������� ���� ��������
                    TemplateFileName = .sMSBaseDir & dbInstumentsDir & "\*" & .sMSfifNum & "*���������*" & "*.xls*"
            
                    If Dir(TemplateFileName) <> vbNullString Then _
                        Me.chbPrimary.Enabled = True  '���� ������ ���� ���� ���� ��������� �������
                        
                End If
            End If
            
        End If
        
    End With

    FillArrKeycodeFromFile '��������� ������ ��������
    UpdateListBoxResults '�������� ���������� ���������
    
    isFormLoaded = True

End Sub
Private Sub UserForm_Terminate()
    myMultiSel.sMSAdditionalText = ""
    
    Set myBase = Nothing
    Set WorkClsm = Nothing
    
    If UMenu.typ� = instrumentsOLD Then _
        Z_UF_Search.tboxSearch.SetFocus
        
End Sub
Private Sub UserForm_Activate()
    
    If UMenu.typ� <> instrumentsOLD Then
        
        With Me.tboxSearch
            
            .text = GetAdditionTextFromComment & " " '������ ��� �������������
            
            If Me.listFiles.List(0) = vbNullString Then _
                .text = vbNullString
        End With
    End If
    
    If Me.listFiles.ListCount = 1 Then
        
        If Me.listFiles.List(0) <> vbNullString Then _
            InitiateLoad
    
    End If
        

End Sub
'#########################################################
'������� ���������� � �������� ��������� ��� ���������� �����������
Function GetAdditionTextFromComment() As String
    
    Dim ws As Worksheet, _
        sAdditionalText As String, _
        sSearchArray() As String, _
        stringToSearch As String
        
    For Each ws In ActiveWorkbook.Worksheets
    
        sAdditionalText = ws.name
        sSearchArray = Split(sAdditionalText, "-")
        
        If stringToSearch <> vbNullString Then _
            stringToSearch = stringToSearch & " "
        
        Dim i As Byte
        For i = LBound(sSearchArray) To UBound(sSearchArray)
            stringToSearch = stringToSearch & sSearchArray(i)
            If i < UBound(sSearchArray) Then stringToSearch = stringToSearch & " -"
        Next i
    Next ws
    
    GetAdditionTextFromComment = stringToSearch '�������������� ������ ������
    Set ws = Nothing
End Function
'#########################################################
'��������� ��������� ������ ��������
Sub FillArrKeycodeFromFile()
    
    Const fileName As String = "keycode.npDb"
     
    Dim fso As New FileSystemObject, _
        charTablePath As String
        
    charTablePath = fso.BuildPath(Config.sourceDataPath, fileName)
    
    If fso.FileExists(charTablePath) Then '���� �������� ������� � �������� ���������� ����� ��������
        
        sArrKeyCode = WorkClsm.FillDataBase( _
            myBase.GetArrFF(charTablePath))  '�������� ������ ��������(���� ���� ���������)

    Else '���� ���� �� ��� ��������� � ��������
        ReDim sArrKeyCode(0, 1)
    End If
    
End Sub
'##################################################
'������������� ������ ��������� �������
Private Sub chbPrimary_Change()
    If isFormLoaded Then UpdateListBoxResults: Me.tboxSearch.SetFocus
    
    TrueElementForeColor Me.chbPrimary, True '������� ������ ����
    If Me.chbPrimary Then TrueElementForeColor Me.chbPrimary '����� ������ �������������
End Sub
Private Sub tboxSearch_Change()
    
    If isFormLoaded Then _
        UpdateListBoxResults

    If Me.listFiles.List(0) = vbNullString Then
        
        With Me.tboxSearch
            .SelStart = 0
            .SelLength = Len(.text)
        End With
    End If
End Sub
'##################################################
'��������� ��������� ������ ��� �������� ������
Sub UpdateListBoxResults()

    Dim sSearchFileMask As String, _
        TemplateFileName As String, _
        sArrTemp() As String, _
        i As Byte, _
        sArrFind() As String
        
    Me.listFiles.Clear
    Me.cmbLoad.Enabled = False
    
    sSearchFileMask = myMultiSel.sMSBaseDir _
                    & dbInstumentsDir & "\*" & myMultiSel.sMSfifNum & "*"  '����� ������ ��� ������

    TemplateFileName = sSearchFileMask & "*.xls*" '�������� ��������� �������
   ' If UMenu.typ� = wdProject Then TemplateFileName = sSearchFileMask & "*.doc*"  '�������� ������� �������������
    
    TemplateFileName = Dir(TemplateFileName)
    
'    If Dir(templateFileName) = vbNullString Then _
'        templateFileName = vbNullString
'
'    If Dir(templateFileName) <> vbNullString Then _
'        templateFileName = Dir(templateFileName)
    
    ReDim sArrFind(1, 0) '�������� ������ ���� ��������� ������
    Do While TemplateFileName <> vbNullString
        
        If Not TemplateFileName Like FIF_PR_KEYWORD & "*" Then
        
            If Me.chbPrimary Then
                If InStr(TemplateFileName, sKeywordPrimary) > 0 Then _
                    FillsArrTemp sArrFind, sArrTemp, TemplateFileName
            Else
                If InStr(TemplateFileName, sKeywordPrimary) = 0 Then _
                    FillsArrTemp sArrFind, sArrTemp, TemplateFileName
            End If
            
        End If
        
        TemplateFileName = Dir
    Loop
    SortMassBiv sArrFind '����������� ���������� ������ ������� �������
    
    If Me.tboxSearch = vbNullString Then '��������� �������� ���������� ����������
        
        For i = LBound(sArrFind, 2) To UBound(sArrFind, 2)
            Me.listFiles.AddItem sArrFind(UBound(sArrFind), i)
        Next
        
    Else
        Dim sTempArr() As String
        ReDim sTempArr(UBound(sArrFind), 0) '�������� ������ ��� ��������� ������
        
        If sArrKeyCode(0, 0) = vbNullString Then '������ �������� �� ��� ��������
            FindInBivArr sArrFind, sTempArr, Me.tboxSearch  '�������� ������ ��������� ����������
        Else ' ������ �������� ��� ��������
            Dim sInputRus As String, sInputEng As String, sInputString As String
            FillInputData sArrKeyCode, Me.tboxSearch, sInputRus, sInputEng  '�������� �������� ��� ������ �� �������
            sInputString = sInputRus & " " & sInputEng: FindInBivArr sArrFind, sTempArr, sInputString  '�������� ������ ��������� ���������� ���������� �� ������� �����
        End If
        
        For i = LBound(sTempArr, 2) To UBound(sTempArr, 2) '��������� �������� ���������� ����������
            Me.listFiles.AddItem sTempArr(UBound(sArrFind), i)
        Next
    End If
    
    If UBound(Me.listFiles.List) >= 0 Then
    
        If Me.listFiles.List(0) <> vbNullString Then _
            Me.listFiles.Selected(0) = True: _
            Me.cmbLoad.Enabled = True
        
    End If
End Sub

'##################################################
'��������� ��������� ������� � ������
Sub FillsArrTemp(ByRef sArrFind() As String, sArrTemp() As String, TemplateFileName As String)
    sArrTemp = Split(TemplateFileName, myMultiSel.sMSfifNum) '������� ������ �� ������ � ���
    
    If sArrFind(LBound(sArrFind), UBound(sArrFind, 2)) <> "" Then ReDim Preserve sArrFind(UBound(sArrFind), UBound(sArrFind, 2) + 1) '��������� ������
    
    DeleteSpaceStEnd sArrTemp(UBound(sArrTemp))
    sArrFind(LBound(sArrFind), UBound(sArrFind, 2)) = sArrTemp(UBound(sArrTemp)) '��������� ������ ������������ � ������ ������ �������
    If InStr(sArrTemp(UBound(sArrTemp)), "#!") > 0 Then sArrTemp = Split(sArrTemp(UBound(sArrTemp)), "#!")
    sArrFind(UBound(sArrFind), UBound(sArrFind, 2)) = sArrTemp(UBound(sArrTemp)) '����������� ������������, ���� �������
End Sub
'##################################################
'�������� ������ ������������ ���������� ����� � ����������
Private Sub cmbLoad_Click()
    
    InitiateLoad

End Sub
    Private Sub InitiateLoad()
    
        With myMultiSel
            
            Dim TemplateFileName As String
            
            If Me.listFiles.ListIndex >= 0 Then _
                TemplateFileName = Dir(.sMSBaseDir & dbInstumentsDir & "\*" & .sMSfifNum & _
                    "*" & Me.listFiles.List(Me.listFiles.ListIndex))
            
            If UMenu.typ� <> instrumentsOLD Then '�������� ������� word
            
                If Me.chbPrimary And InStr(TemplateFileName, sKeywordPrimary) = 0 Then
                    
                    If TemplateFileName <> vbNullString Then _
                        TemplateFileName = Dir '����� ������� word ��� ��������� �������
                End If
                
            End If
            
            If TemplateFileName <> vbNullString Then _
                .sMSFullFileName = .sMSBaseDir & dbInstumentsDir & "\" & TemplateFileName
                
        End With
        
        VBA.Unload Me
    
    End Sub

Private Sub UserForm_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 27 Then VBA.Unload Me 'esc
    If KeyCode = 13 Then cmbLoad_Click 'enter
End Sub
Private Sub listFiles_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 27 Then VBA.Unload Me 'esc
    If KeyCode = 13 Then cmbLoad_Click 'enter
    
    If KeyCode = 38 Then
        If Me.listFiles.Selected(0) = True Then
            
            With Me.tboxSearch
                .SetFocus
                .SelStart = 0
                .SelLength = Len(.text)
            End With
        End If
    End If
End Sub
Private Sub chbPrimary_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 27 Then VBA.Unload Me 'esc
    If KeyCode = 13 Then cmbLoad_Click 'enter
End Sub
Private Sub tboxSearch_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 27 Then VBA.Unload Me 'esc
    If KeyCode = 13 Then cmbLoad_Click 'enter
    
    If KeyCode = 40 Then
        If Me.listFiles.ListCount > 0 Then Me.listFiles.Selected(1) = True: Me.listFiles.SetFocus
    End If
End Sub
Private Sub cmbLoad_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 27 Then VBA.Unload Me 'esc
    If KeyCode = 13 Then cmbLoad_Click 'enter
End Sub

Private Sub FillInputData(sArrKeyCode() As String, StrToSearch As String, ByRef RusInput As String, ByRef EngInput As String)
    'RusInput - ���������� ���������� �������� �� ������� �����
    'EngInput - ���������� ���������� �������� �� ���������� �����
    Dim i As Integer, j As Integer, sSym As String
    StrToSearch = Replace(StrToSearch, "[", "{") '����� �� ���� ������ ������
    For i = 1 To Len(StrToSearch) '��� ������� �������, ����������� � ������
        sSym = Mid(StrToSearch, i, 1) '�������������� ������
        For j = LBound(sArrKeyCode, 2) To UBound(sArrKeyCode, 2) '�������� �� ������� ��������
            If sSym = sArrKeyCode(0, j) Then '������� ������������ ����� �������� �� ������� �����
                RusInput = RusInput & sArrKeyCode(0, j) '������� �������� �� ������� ���������
                EngInput = EngInput & sArrKeyCode(1, j) '������� �������� �� ���������� ���������
                Exit For
            ElseIf sSym = sArrKeyCode(1, j) Then '������� ������������ ����� �������� �� ���������� �����
                RusInput = RusInput & sArrKeyCode(0, j) '������� �������� �� ������� ���������
                EngInput = EngInput & sArrKeyCode(1, j) '������� �������� �� ���������� ���������
                Exit For
            End If
        Next j
    Next i
End Sub
