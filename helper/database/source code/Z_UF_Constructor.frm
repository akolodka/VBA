VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Z_UF_Constructor 
   Caption         =   "����������� ���� ������ ���������� / ������� ��������� / ��������"
   ClientHeight    =   6915
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   9315
   OleObjectBlob   =   "Z_UF_Constructor.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Z_UF_Constructor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Text
Option Explicit '������ �� ������������� ������� ����������

Const DEFAULT_VALUE = "nodata"
Const REFERENCE_FIFNUM_FILENAME = "fifRegNum.ref"

Private myBase As New Z_clsmBase, WorkClsm As New Z_clsmConstructor, sConstrSrch As String '������ ��� �������� �������� � ������������
Dim sArrDataBase() As String, sArrKeyCode() As String, bolUserInput As Boolean, sLabelText As String, bolTbEntry As Boolean
Dim iDataBaseIndex As Integer, sArrSelResults() As String


Private Sub UserForm_Initialize()
    Set_UF_Cunstructor_Properties '�������� �������� � ������������ � ����������� ����� �����
    GetMyConfigFromFile '��������� ��������� � ������ ������
        
    FillArrKeycodeFromFile '��������� ������ ��������
    FillArrDataBaseFromFile '��������� ������ ���� ������
    RefreshLabelInfo ' �������� ������ �������������� �����
' ------------------------------------------------------
'todo: �������� workclsm
    If UMenu.typ� = instrumentsOLD Then CheckTempDir WorkClsm.startDir, sArrDataBase
    If UMenu.typ� = etalonsOLD Then SortMassBiv sArrDataBase, UBound(sArrDataBase) '����������� ������ �� ��������� �����
    
    bolAlreadySaved = True: UpdateListDataBase sArrDataBase '��������� �������� ������ ������� �����������
    SetEventControls Me '������������ ��������� ������� ��� ���� ���������

    If Me.listDataBase.ListCount = 0 Then Me.cmbAdd.Enabled = False: Me.cmbAdd.caption = "������"
    ' ------------------------------------------------------
'todo: �������� workclsm
    If Me.listDataBase.ListCount > 0 Then sConstrSrch = WorkClsm.constrSrch: Me.listDataBase.Selected(0) = True
    
    bolUF_Cnstr_Load = True: If sConstrSrch <> "����������" Then SelByConstrSrch sConstrSrch '������, ��������� � ����� ������
    bolUF_Cnstr_Load = False: Me.tboxSearchConstr = "": bolUF_Cnstr_Load = True '�������� ���� �������� ��������
End Sub
'#########################################################
'��������� ��������� �������� ��������� ��������� ������
Sub SelByConstrSrch(sConstrSrch As String)
    Dim i As Integer, iArrayDimention As Byte '�� ��������� ���������� ������ ��������� = 0
    
    If UMenu.typ� = instrumentsOLD Then iArrayDimention = 2 '����� � ���
    If UMenu.typ� = etalonsOLD Then iArrayDimention = 4 '�������� �����

    For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
        If InStr(sArrDataBase(iArrayDimention, i), sConstrSrch) > 0 Then Me.listDataBase.Selected(i) = True: Exit Sub
    Next i
End Sub


'#########################################################
'��������� ����������� ��� ��������� �����
Private Sub UserForm_Activate()
    Me.tboxSearchConstr.SetFocus
End Sub
'#########################################################
'��������� ����������� ��� �������� �����
Private Sub UserForm_Terminate()
    bolUF_Cnstr_Load = False: bolAlreadySaved = False: Set myBase = Nothing: Set WorkClsm = Nothing
End Sub
'#########################################################
'��������� ������������ �� ������
Sub GetMyConfigFromFile()
    

    With myBase
        .AddP "startDir", "templatesDir"
        
        Select Case UMenu.typ�  '�������� �������� ��������� �����
            
            Case organisationsOLD
                .AddP "cusDB" '���������
                
            Case instrumentsOLD
                .AddP "measInstrDB" '�������� ���������
                
            Case etalonsOLD
                .AddP "etalDB" '�������
                
            Case personsOLD
                .AddP "empDB" '������� � ���������
                
        End Select
        
        .GetArrFF setDir, Environ("USERNAME") & ".uCfg" '��������� � ����� ������������
        .FillValues '�����������: ����� �������� �������� ���������� �� ������
        
        WorkClsm.FillConfiguration .Parameters, .values '�������� ������������ � �����
        .ClearParameters
        
        .AddP "constrSrch": .GetArrFF setDir, "settings.ini" '��������� � ����� ������������
        .FillValues '�����������: ����� �������� �������� ���������� �� ������
        
        WorkClsm.FillSettings .Parameters, .values '�������� ������������ � �����
    End With
End Sub
'#########################################################
'��������� ��������� ������ ��������
Sub FillArrKeycodeFromFile()
    If FileExist(setDir, "keycode.npDb") Then '���� �������� ������� � �������� ���������� ����� ��������
 ' ------------------------------------------------------
'todo: �������� workclsm
        sArrKeyCode = WorkClsm.FillDataBase( _
            myBase.GetArrFF(setDir, "keycode.npDb"))  '�������� ������ ��������(���� ���� ���������)
    Else '���� ���� �� ��� ��������� � ��������
        ReDim sArrKeyCode(0, 1)
    End If
End Sub
'#########################################################
'��������� ��������� ������ ���� ������
Sub FillArrDataBaseFromFile()
' ------------------------------------------------------
'todo: �������� workclsm

    With WorkClsm
        If FileExist(.startDir, .DbName) Then '���� ���� ������ ���������� �� ���������� ����
            sArrDataBase = .FillDataBase(myBase.GetArrFF(.startDir, .DbName), True)  '������������� ������ ����� � ������ ���� ������
            sLabelText = .DbName & ", " & RusPadejPozition(UBound(sArrDataBase, 2) + 1)
        Else '���� �� �� ��� ��������
            ReDim sArrDataBase(0)
            RefreshLabelInfo "���� ������ �� ��������.", &H80& '�������
        End If
    End With
End Sub

'#########################################################
'��������� ��������� �������� �������������� �����
Sub RefreshLabelInfo(Optional sCaption As String, Optional sColor As String, Optional TrueElemFore As Boolean)

    With Me.LabelInfo
        .caption = sLabelText: TrueElementForeColor Me.LabelInfo
        
        If sCaption <> "" Then _
            .caption = sCaption: If sColor <> "" Then .foreColor = sColor
        
        If TrueElemFore Then TrueElementForeColor Me.LabelInfo
    End With
End Sub
'#########################################################
'������� ������
Private Sub tboxSearchConstr_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    If bolTbEntry = False Then _
        With Me.tboxSearchConstr: .SelStart = 0: .SelLength = Len(.text): bolTbEntry = True: End With '���������� ������� �����
End Sub
Private Sub tboxSearchConstr_Change()
    
    If bolUF_Cnstr_Load = False Then Exit Sub
    If Me.tboxSearchConstr = "" Then Me.listDataBase.ListIndex = -1: Exit Sub '���� ���� ������, �� ������ ��������� ������
    
    Dim sInputRus As String, sInputEng As String, sInputString As String
    ReDim sArrSelResults(UBound(sArrDataBase), 0) '�������� ������ ��� ��������� ������
    
    If sArrKeyCode(0, 0) = "" Then '������ �������� �� ��� ��������
        FindInBivArr sArrDataBase, sArrSelResults, Me.tboxSearchConstr  '�������� ������ ��������� ����������
    Else ' ������ �������� ��� ��������
        FillInputData sArrKeyCode, Me.tboxSearchConstr, sInputRus, sInputEng   '�������� �������� ��� ������ �� �������
        sInputString = sInputRus & " " & sInputEng: FindInBivArr sArrDataBase, sArrSelResults, sInputString  '�������� ������ ��������� ���������� ���������� �� ������� �����
    End If
        
    TrueSelectionlistDataBase '�������� ������� ��������� - ������ �����
End Sub
Private Sub tboxSearchConstr_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then KeyCode = 0: TrueSelectionlistDataBase True '������ � ����������� �����
End Sub
Private Sub tboxSearchConstr_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    bolTbEntry = False
End Sub

'#########################################################
'��������� �������� ������� ���������
Sub TrueSelectionlistDataBase(Optional bolSecondSearch As Boolean)

    Dim myInd As Integer, i As Integer, j As Integer, K As Integer
    myInd = -1 '�� ���������
    
    With Me.listDataBase
        For i = LBound(.List) To UBound(.List)
            '��� ������ ������ ����� ���������� �� ������� �������� ��������� ��������
            If InStr(.List(i), sArrSelResults(LBound(sArrSelResults), 0)) > 0 And _
                InStr(.List(i), sArrSelResults(LBound(sArrSelResults) + 1, 0)) > 0 And _
                    InStr(.List(i), sArrSelResults(LBound(sArrSelResults) + 2, 0)) > 0 Then myInd = i: Exit For
        Next i
    
        If bolSecondSearch Then '����� �������������� ����������
            K = Me.listDataBase.ListIndex
            
            For j = LBound(sArrSelResults, 2) To UBound(sArrSelResults, 2)
                '����� ������� � ������� ��������� ��������
                If InStr(.List(K), sArrSelResults(LBound(sArrSelResults), j)) > 0 And _
                    InStr(.List(K), sArrSelResults(LBound(sArrSelResults) + 1, j)) > 0 And _
                        InStr(.List(K), sArrSelResults(LBound(sArrSelResults) + 2, j)) > 0 Then Exit For
            Next j

            If j = UBound(sArrSelResults, 2) Then
                j = LBound(sArrSelResults, 2) '������� �� ���������� �������� � �������
            Else
                j = j + 1
            End If
            
            For i = LBound(.List) To UBound(.List)
                '��� ������ ������ ����� ���������� �� ������� �������� ��������� ��������
                If InStr(.List(i), sArrSelResults(LBound(sArrSelResults), j)) > 0 And _
                    InStr(.List(i), sArrSelResults(LBound(sArrSelResults) + 1, j)) > 0 And _
                        InStr(.List(i), sArrSelResults(LBound(sArrSelResults) + 2, j)) > 0 Then myInd = i: Exit For
            Next i
        End If
    End With

    Me.listDataBase.ListIndex = -1 '������ ��������� ������
    If myInd >= 0 Then Me.listDataBase.Selected(myInd) = True
End Sub

'#########################################################
'��������� ��������� ���������� ���������, ������ �� ��������������� �������
Sub UpdateListDataBase(sArrDBase() As String) '�������� ���������� ���������1
    Me.listDataBase.Clear
    
    If UBound(sArrDBase) > 0 Then '������ ������ ��� �������
    
        Dim i As Integer, sTempStr As String
        For i = LBound(sArrDBase, 2) To UBound(sArrDBase, 2) '��� ������� �����
            sTempStr = vbNullString '�������� ����������
            
            Select Case UMenu.typ�
            
                Case instrumentsOLD '�������� ���������
                    sTempStr = GetListStringForInstruments(sArrDataBase, i) '�������� ������ ��� ���� ������ ������� ���������
                    
                Case Else
                    sTempStr = GetListStringOtherDB(sArrDataBase, i)
            End Select
            
            If sTempStr <> "" Then _
                sTempStr = TrueSpace(i + 1) & sTempStr: Me.listDataBase.AddItem sTempStr
        Next
    End If
End Sub
'#########################################################
'�������� ������ ��� ���� ������ ������� ���������
Function GetListStringForInstruments(sArrDBase() As String, iDbIndex As Integer) As String
    
    Dim sTempStr As String
    If sArrDBase(LBound(sArrDBase), iDbIndex) <> "" Then
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 2, iDbIndex) & " \\ " '����� � ���
        
        If sArrDBase(UBound(sArrDBase), iDbIndex) <> "nodata" Then _
            sTempStr = sTempStr & sArrDBase(UBound(sArrDBase), iDbIndex) & " \\ " '������� ������� ��� ������� ��
        
        If sArrDBase(LBound(sArrDBase) + 1, iDbIndex) <> DEFAULT_VALUE And _
            sArrDBase(LBound(sArrDBase) + 1, iDbIndex) <> "" Then _
            sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 1, iDbIndex) & " \\ " '��� ��
            
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase), iDbIndex) & " \\ " '������ ������������
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 3, iDbIndex) '�������� �������
        
        If sArrDBase(LBound(sArrDBase) + 5, iDbIndex) <> "nodata" Then _
            sTempStr = sTempStr & " \\ " & sArrDBase(UBound(sArrDBase) - 1, iDbIndex) '������� �� �������� ��������
    End If

    GetListStringForInstruments = sTempStr
End Function
'#########################################################
'�������� ������ ��� ���� ������ ������� ���������
Function GetListStringOtherDB(sArrDBase() As String, iDbIndex As Integer) As String
    
    Dim sTempStr As String, j As Byte, bolStopReplaceJ As Boolean
    
    If UMenu.typ� = etalonsOLD And sArrDBase(LBound(sArrDBase), iDbIndex) <> "" Then _
        sTempStr = sTempStr & sArrDBase(UBound(sArrDBase), iDbIndex) & " \\ " '�������� ����� � ������������ �������
                
    For j = LBound(sArrDBase) To UBound(sArrDBase) '�������� �������� �� ��������
        If UMenu.typ� = etalonsOLD And j = UBound(sArrDBase) Then Exit For '�� ������� �������� ����� �������� ��������
        
        If UMenu.typ� = organisationsOLD And j = 2 Then j = 3: bolStopReplaceJ = True '�������� �����
        If bolStopReplaceJ = False And UMenu.typ� = organisationsOLD And j = 3 Then j = 2: bolStopReplaceJ = True '�����
            
            If j > LBound(sArrDBase) And sArrDBase(j, iDbIndex) <> DEFAULT_VALUE And sArrDBase(j, iDbIndex) <> "" Then
                sTempStr = sTempStr & " \\ " '�����������
                If UMenu.typ� = organisationsOLD Then If j = 1 Then sTempStr = sTempStr & "��� " '������ ���
            End If
            
            If sArrDBase(j, iDbIndex) <> DEFAULT_VALUE And sArrDBase(j, iDbIndex) <> "" Then _
                sTempStr = sTempStr & sArrDBase(j, iDbIndex) '���������� ��� ���������� � ��������
            
        If bolStopReplaceJ And UMenu.typ� = organisationsOLD And j = 3 Then j = 2: bolStopReplaceJ = False '�������� �����
        If bolStopReplaceJ And UMenu.typ� = organisationsOLD And j = 2 Then j = 3 '�����
        
    Next j

    GetListStringOtherDB = sTempStr
End Function
'#########################################################
'������� ��������� ������� ����� � �������� �������� � ���������
Function TrueSpace(number As Integer)
    Select Case Len(CStr(number))
        Case 1 '����� �� 1 �� 10
            TrueSpace = number & "     "
        Case 2 '����� ����� 10
            TrueSpace = number & "   "
        Case 3
            TrueSpace = number & " "
    End Select
End Function
'#########################################################
'��������� ������ � ���� ������
Private Sub listDataBase_Click()

    Dim myData As New MSForms.DataObject
    Me.TextBox2 = "": Me.TextBox3 = "": Me.TextBox4 = "": Me.TextBox5 = ""
    
    ' 0 - ������������ ����������� / �� / ������� / �������
    ' 1 - ��� / ����������� �� / ��� �������
    ' 2 - �������� ����� ��� ������ / ����� � ��� �� / ����� � ��� ������� / ���������
    ' 3 - ����� ����������� / �������� ������� �� / ���. �������� �������
    Me.TextBox1 = sArrDataBase(0, listDataBase.ListIndex)

    If UMenu.typ� <> personsOLD Then
        If sArrDataBase(1, listDataBase.ListIndex) <> "nodata" Then _
            myData.SetText sArrDataBase(1, listDataBase.ListIndex): Me.TextBox2.text = CheckDataBeforepaste(myData, Me.TextBox2.name, 0, 0)
    
        If sArrDataBase(2, listDataBase.ListIndex) <> "nodata" Then _
            myData.SetText sArrDataBase(2, listDataBase.ListIndex): Me.TextBox3.text = CheckDataBeforepaste(myData, Me.TextBox3.name, 0, 0)

        If sArrDataBase(3, listDataBase.ListIndex) <> "nodata" Then _
            myData.SetText sArrDataBase(3, listDataBase.ListIndex): Me.TextBox4.text = CheckDataBeforepaste(myData, Me.TextBox4.name, 0, 0)
        
        If UMenu.typ� = instrumentsOLD Then '�������� ���������
    
            If Me.cmbImport.caption <> "�������" Then '����� ����������� ������
                Me.chbVerRefer = False
            
                Dim sReferenceStr As String '����������� ������
                sReferenceStr = "nodata"
                
                If listDataBase.ListIndex >= 0 Then _
                    sReferenceStr = sArrDataBase(LBound(sArrDataBase) + 4, listDataBase.ListIndex)
                    
                If sReferenceStr <> "nodata" Then
                    Me.cmbImport.caption = sReferenceStr
                    Me.chbVerRefer = True
                End If
                
            End If
            
            Me.chbEtalon = False:  If listDataBase.ListIndex >= 0 Then _
                If sArrDataBase(LBound(sArrDataBase) + 5, listDataBase.ListIndex) <> "nodata" Then Me.chbEtalon = True
            
        End If

        If UMenu.typ� = etalonsOLD Then '�������
            If sArrDataBase(UBound(sArrDataBase), listDataBase.ListIndex) <> "nodata" Then _
                myData.SetText sArrDataBase(UBound(sArrDataBase), listDataBase.ListIndex): Me.TextBox5.text = CheckDataBeforepaste(myData, Me.TextBox5.name, 0, 0)
        End If
        
    Else '���� �������� � �������� � ����������
        If sArrDataBase(1, listDataBase.ListIndex) <> "nodata" Then _
            myData.SetText sArrDataBase(1, listDataBase.ListIndex): Me.TextBox3.text = CheckDataBeforepaste(myData, Me.TextBox3.name, 0, 0)
        
        Me.chbVerRefer = False: If sArrDataBase(2, listDataBase.ListIndex) <> "nodata" Then Me.chbVerRefer = True
    End If
    
    With Me.cmbAdd
        If Me.cmbImport.caption = "������" Then .caption = "��������": .Enabled = True: .BackColor = &HFFFFFF '����� ����
    End With
    
    Set myData = Nothing: RefreshLabelInfo
    If Me.cmbImport.caption = "������" Then PreSaveSetButton True
End Sub
Private Sub listDataBase_Change()

    Me.cmbDelete.Enabled = False '������ "�������"
    
    If UMenu.typ� = instrumentsOLD Then _
        Me.cmbFillTempProp.Enabled = False: Me.cmbOpenTemplateFolder.Enabled = False  '������ ������������ ������

    If Me.listDataBase.ListIndex >= 0 Then
        Me.cmbDelete.Enabled = True
        
        If UMenu.typ� = instrumentsOLD And myWdDoc = False Then
            Me.cmbFillTempProp.Enabled = True
            
            Dim sTempStr As String
            If listDataBase.ListIndex >= 0 Then sTempStr = sArrDataBase(LBound(sArrDataBase) + 2, listDataBase.ListIndex)
        ' ------------------------------------------------------
'todo: �������� workclsm
            If Dir(WorkClsm.templatesDir & "*" & sTempStr & "*", vbDirectory) <> "" Then Me.cmbOpenTemplateFolder.Enabled = True
        End If
        
    End If
End Sub
'#########################################################
'��������� ��������� �� ���� �������� � ����������
Sub PreSaveSetButton(Optional NoRecapture As Boolean)
' ------------------------------------------------------
'todo: �������� workclsm
    If NoRecapture = False Then '����� ����� �������������� ��������
        If WorkClsm.DbName <> "����������" Then _
            Me.cmbAdd.caption = "������": EnableAddButton
    End If

    With Me.cmbReady
        If UBound(listDataBase.List) >= 0 And bolUserInput And listDataBase.ListIndex >= 0 Then '����� �������� ������� �������
            .caption = "��������": .Font.Size = 12: .BackColor = &HC0E0FF   '����������
        Else
            If bolAlreadySaved = False Then '��������� �� ���� ���������
                .caption = "���������": .Font.Size = 11: .BackColor = &HC0FFFF '������ ����
            Else '��������� ���� ���������
                .caption = "������": .Font.Size = 12: .BackColor = &HFFFFFF '����� ����
            End If
        End If
    End With
End Sub
'#########################################################
'������������ ����������� / �� / �������
Private Sub TextBox1_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = True
End Sub
Private Sub TextBox1_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = False
End Sub
Private Sub TextBox1_Change()

    With Me.TextBox1
        .BackColor = &HFFFFFF: If .text = "" Then .BackColor = &HC0FFFF '�����

        If bolUserInput = False Then Exit Sub
        .text = Replace(.text, Chr(45) & Chr(45), Chr(150)) '�������� ������� ����� �� ����
    End With

    PreSaveSetButton
End Sub
Private Sub TextBox1_BeforeDropOrPaste(ByVal Cancel As MSForms.ReturnBoolean, ByVal Action As MSForms.fmAction, ByVal data As MSForms.DataObject, ByVal X As Single, ByVal Y As Single, ByVal Effect As MSForms.ReturnEffect, ByVal Shift As Integer)
    Cancel = True

    With Me.Controls(ActiveControl.name): _
        .text = CheckDataBeforepaste(data, ActiveControl.name, .SelStart, .SelLength): End With
End Sub
'#########################################################
' ��� / ����������� �� / ��� ������� / �.�.�������
Private Sub TextBox2_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = False
End Sub
Private Sub TextBox2_Change()
    With Me.TextBox2
        .BackColor = &HFFFFFF '�����
        
        Select Case UMenu.typ�
        
            Case organisationsOLD
                If Len(.text) < .maxLength Then .BackColor = &HC0FFFF   '�����
                
            Case instrumentsOLD, etalonsOLD
                If .text = "" Then .BackColor = &HC0FFFF '�����
        End Select
        
        If bolUserInput = False Then Exit Sub
        .text = Replace(.text, Chr(45) & Chr(45), Chr(150)) '�������� ������� ����� �� ����
    End With
    
    PreSaveSetButton
End Sub
Private Sub TextBox2_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = True
    Select Case KeyCode
        Case 8, 27, 35, 36, 37, 39 '��� ������� �������������� � ������ oTxtBx
        Case Else
            If UMenu.typ� = organisationsOLD Then '������ ��� �� ����������
                With Me.TextBox2
                    Select Case Len(.text)
                        Case 3, 7, 10
                            .text = .text & " " '�������� ���.������� � ��� ��� ���������������
                    End Select
                End With
            End If
    End Select
End Sub
Private Sub TextBox2_KeyPress(ByVal KeyAscii As MSForms.ReturnInteger) '������ ��������� ���� �������� �� ������� ������ � ����������
    If UMenu.typ� = organisationsOLD Then
        '���� �������� �� ������� "0123456789", �� ��������� ���� ����� �������
        If KeyAscii < 48 Or KeyAscii > 57 Then KeyAscii = 0
    End If
End Sub
Private Sub TextBox2_BeforeDropOrPaste(ByVal Cancel As MSForms.ReturnBoolean, ByVal Action As MSForms.fmAction, ByVal data As MSForms.DataObject, ByVal X As Single, ByVal Y As Single, ByVal Effect As MSForms.ReturnEffect, ByVal Shift As Integer)
    Cancel = True
    With Me.Controls(ActiveControl.name)
        .text = CheckDataBeforepaste(data, _
            ActiveControl.name, .SelStart, .SelLength)
    End With
End Sub
'#########################################################
' ����������� ������������ ��� ������ / ����� � ��� �� / ����� � ��� �������
Private Sub TextBox3_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = True
End Sub
Private Sub TextBox3_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = False
End Sub
Private Sub TextBox3_Enter()
    If UMenu.typ� = etalonsOLD Then _
        RefreshLabelInfo "����� ����� ��������� ����.", &H800080
End Sub
Private Sub TextBox3_Change()
    With Me.TextBox3
    
        .BackColor = &HFFFFFF '�����
        
        Select Case UMenu.typ�
            
            Case instrumentsOLD  '�������� ���������
                If bolUserInput And Len(.text) < .maxLength Then .BackColor = &HC0FFFF  '�����
                
            Case organisationsOLD, etalonsOLD, personsOLD  ' ���������, �������, ������� � ���������,
                If .text = "" Then .BackColor = &HC0FFFF '�����
                
        End Select
    End With
    
    If bolUserInput = False Then Exit Sub
    PreSaveSetButton
End Sub
Private Sub TextBox3_KeyPress(ByVal KeyAscii As MSForms.ReturnInteger)

    Select Case UMenu.typ�
        Case instrumentsOLD  '�������� ��������� - ���� ������ � ��� (����� ��������)
        
            Select Case KeyAscii
                Case 34, 42, 47, 58, 60, 62, 63, 92, 124: KeyAscii = 0 ' \/:*?"<>| ����������� � ������������ ����� �������
            End Select
            
        Case etalonsOLD  ',1 '������� - ���� ������ ��������� ��������
            
            Select Case KeyAscii
                Case 34, 42, 47, 58, 60, 62, 63, 92, 124: KeyAscii = 0: Exit Sub ' \/:*?"<>| ����������� � ������������ ����� �������
            End Select
            
            Dim iCode As Integer, bArrTemp(1) As Byte, sSym As String
            iCode = KeyAscii: KeyAscii = 0
            '##################################################################### '��, ��� ��� ��������
            bArrTemp(0) = iCode Mod 256: bArrTemp(1) = iCode / 256: sSym = bArrTemp
            '##################################################################### '�� ��������
            With Me.TextBox3
            
                If Len(.text) < .maxLength Then
                    Dim sLeftStr As String, sRightStr As String, iselSt As Integer
                    
                    iselSt = .SelStart: sLeftStr = Left(.text, .SelStart) '����� ����� ������
                    sRightStr = Right(.text, Len(.text) - (.SelStart + .SelLength)) '������ ����� ������
                    .text = sLeftStr & UCase(sSym) & sRightStr: .SelStart = iselSt + 1
                End If
            End With
    End Select

End Sub
Private Sub TextBox3_BeforeDropOrPaste(ByVal Cancel As MSForms.ReturnBoolean, ByVal Action As MSForms.fmAction, ByVal data As MSForms.DataObject, ByVal X As Single, ByVal Y As Single, ByVal Effect As MSForms.ReturnEffect, ByVal Shift As Integer)
    Cancel = True
    
    With Me.Controls(ActiveControl.name)
        .text = CheckDataBeforepaste(data, ActiveControl.name, .SelStart, .SelLength)
    End With
End Sub
Private Sub TextBox3_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    If UMenu.typ� = etalonsOLD Then RefreshLabelInfo
End Sub
'#########################################################
' ����� ����������� / �������� ������� �� / ���. �������� �������
Private Sub TextBox4_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = True
End Sub
Private Sub TextBox4_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = False
End Sub
Private Sub TextBox4_Change()
    
    With Me.TextBox4
        .BackColor = &HFFFFFF '�����
        
        Select Case UMenu.typ�
            
            Case organisationsOLD, instrumentsOLD, etalonsOLD
                If .text = "" Then .BackColor = &HC0FFFF '�����
                
        End Select
    End With
    
    If bolUserInput = False Then Exit Sub
    PreSaveSetButton
End Sub
Private Sub TextBox4_BeforeDropOrPaste(ByVal Cancel As MSForms.ReturnBoolean, ByVal Action As MSForms.fmAction, ByVal data As MSForms.DataObject, ByVal X As Single, ByVal Y As Single, ByVal Effect As MSForms.ReturnEffect, ByVal Shift As Integer)
    Cancel = True
    With Me.Controls(ActiveControl.name)
        .text = CheckDataBeforepaste(data, _
            ActiveControl.name, .SelStart, .SelLength)
    End With
End Sub
'#########################################################
' �������� �����
Private Sub TextBox5_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = True
End Sub
Private Sub TextBox5_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    bolUserInput = False
End Sub
Private Sub TextBox5_Change()
    With Me.TextBox5
        .BackColor = &HFFFFFF '�����
        
        Select Case UMenu.typ�
            
            Case etalonsOLD
                If .text = "" Then .BackColor = &HC0FFFF '�����
                
                If bolUserInput = False Then Exit Sub
                .text = Replace(.text, Chr(45) & Chr(45), Chr(150)) '�������� ������� ����� �� ����
                
        End Select
    End With
    
    PreSaveSetButton
End Sub
'#########################################################
'������� ���������� ����������������� �������� ������ ������ � ������� ���� �����
Function CheckDataBeforepaste(ByVal data As MSForms.DataObject, _
    controlName As String, SelStart As Integer, SelLength As Integer) As String
    
    Dim sBaseStr As String, sLeftStr As String, sRightStr As String
    sBaseStr = Me.Controls(controlName).text '������� ���������� ���� �����
    sLeftStr = Left(sBaseStr, SelStart): If SelStart <= Len(sBaseStr) Then sRightStr = Right(sBaseStr, Len(sBaseStr) - SelStart - SelLength)
    
    Dim sTempStr As String
    sTempStr = data.GetText '�������� �������� �� ������ ������
    sTempStr = DeleteSpaceStEnd(sTempStr) '������ ���������� ������� � ������ � �����
    ReplaceInvCommas sTempStr '��������� �������� �������
    
    Select Case UMenu.typ�
        
        Case organisationsOLD '���������
            CheckCustomersData controlName, sTempStr, sBaseStr
            
        Case instrumentsOLD '�������� ���������
            CheckInstrumentsData controlName, sTempStr, sBaseStr
            
        Case etalonsOLD  '�������
            CheckEtalonsData controlName, sTempStr
    End Select
    
    sBaseStr = sLeftStr & sTempStr & sRightStr '����� �������� ��� ��������
    
    InsertSpaceToBaseStr controlName, sBaseStr

    If Me.Controls(controlName).maxLength > 0 Then '���� � �������� ���� ���� ����������� �� ����� ��������
        If Len(sBaseStr) > Me.Controls(controlName).maxLength Then _
            sBaseStr = Left(sBaseStr, Me.Controls(controlName).maxLength)
    End If
        
    CheckDataBeforepaste = sBaseStr
End Function

'#########################################################
'������� ��������� ��� ������������ ����������
Sub CheckCustomersData(sCtrlName As String, ByRef sTempStr As String, ByRef sBaseStr As String)
    
    If sCtrlName = "TextBox2" Then  '������ ��� ����� ���
        sTempStr = Replace(LCase(sTempStr), "�", ""): sTempStr = Replace(LCase(sTempStr), "�", "") '������ ���
        sBaseStr = Replace(sBaseStr, " ", "") '������ ������� � �������� ������
        sTempStr = Replace(sTempStr, " ", ""): sTempStr = Replace(sTempStr, ":", "") '������ ������� � ����������� ������
        
        If IsNumeric(sTempStr) = False Or Len(sBaseStr & sTempStr) > 10 Then _
            sTempStr = "": RefreshLabelInfo "���� ������������ ������", &HFF& '������� ����
    End If
End Sub
'#########################################################
'������� ��������� ��� ������������ ������� ���������
Sub CheckInstrumentsData(sCtrlName As String, ByRef sTempStr As String, ByRef sBaseStr As String)
     '������ ��� ����� ������ � ��� ��
    If sCtrlName = "TextBox3" Then _
        If Len(sBaseStr & sTempStr) > 8 Then sTempStr = "": RefreshLabelInfo "���� ������������ ������", &HFF& '������� ����
End Sub
'#########################################################
'������� ��������� ��� ������������ ��������
Sub CheckEtalonsData(sCtrlName As String, ByRef sTempStr As String)
                
    If sCtrlName = "TextBox3" Then  '������ ��� ����� ������ � ��� �������
        sTempStr = Replace(sTempStr, " ", "")
        
        If Len(sTempStr) > Me.Controls(sCtrlName).maxLength Then _
            sTempStr = "": RefreshLabelInfo "���� ������������ ������", &HFF& '������� ����
    End If
End Sub
'#########################################################
'������� ��������� ��� ������� �������� � ������
Sub InsertSpaceToBaseStr(sCtrlName As String, ByRef sBaseStr As String)
                
    Dim i As Integer
    If UMenu.typ� = organisationsOLD And sCtrlName = "TextBox2" Then
        i = Len(sBaseStr) '����� ���������� �������� � ������
        
        Do '������� �������������� ��������
            If i < 3 Then Exit Do
            Select Case i
                Case 3, 6, 8
                    sBaseStr = Left(sBaseStr, i) & " " & Right(sBaseStr, Len(sBaseStr) - i)
            End Select
            i = i - 1
        Loop
    End If
End Sub
'#########################################################
'��������� �������� �� ��������� ������ "��������"
Sub EnableAddButton()
    Dim bolStopEnable As Boolean, sTempStr As String

    With Me.cmbAdd  '������ "��������"
        If .caption = "������" Then .Enabled = False: .BackColor = &HFFFFFF '����� ����

        If Me.TextBox1 = "" Then bolStopEnable = True '������ ������������
        sTempStr = "��������� ������������ ����"
        
        Select Case UMenu.typ�
        
            Case organisationsOLD '1 - ���������
                If Len(Me.TextBox2.text) < Me.TextBox2.maxLength Or _
                    Len(Me.TextBox4.text) = 0 Then bolStopEnable = True: '��� / �����
                    
                If Not IsItemUnique(Me.TextBox3) Then _
                    bolStopEnable = True: sTempStr = "��� �������� �������� ����������."
                    
            Case instrumentsOLD '2 - �������� ���������
                If Len(Me.TextBox3.text) < Me.TextBox3.maxLength - 1 Or _
                   Me.TextBox2 = "" Or Me.TextBox4 = "" Then bolStopEnable = True '����� � ��� ������ / ��� �� / ��
                   
                If AlreadyInBase(Me.TextBox3) Then _
                    bolStopEnable = True: sTempStr = "��� �������� �������� ����� ���."
            Case etalonsOLD '�������
            
                If Me.TextBox2 = "" Or Me.TextBox3 = "" Or _
                    Me.TextBox4 = "" Or Me.TextBox5 = "" Then bolStopEnable = True '��� / ��� � / ���������� / �������� �����
                    
                If AlreadyInBase(Me.TextBox3) Then _
                    bolStopEnable = True: sTempStr = "��� �������� �������� �����."
                    
            Case personsOLD '�������
                If Me.TextBox3 = "" Then bolStopEnable = True '���������
                
                If AlreadyInBase(Me.TextBox1) Then _
                    bolStopEnable = True: sTempStr = "��������� ��� ������������ � ����."
        End Select
        
        If bolStopEnable = False Then .Enabled = True: .BackColor = &HC0FFC0 '������
        If bolStopEnable Then RefreshLabelInfo sTempStr, &H800080     '���������� ���� '.BackColor = &HC0FFFF
    End With
End Sub
    ' ----------------------------------------------------------------
    ' ����: 25.02.2023 17:20
    ' ����������:
    '    �������� key:
    ' ������������ ���: Boolean
    ' ----------------------------------------------------------------
    Private Function IsItemUnique( _
        key As String _
        ) As Boolean
        
        IsItemUnique = False
        
        If key = vbNullString Then _
            Exit Function
        
        Dim i As Integer
        For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
        
            If sArrDataBase(2, i) = key Then _
                Exit Function '����� ��������� ����� �����������
                
        Next
        
        IsItemUnique = True
    End Function
'#########################################################
'�������� ������� � �������
Function AlreadyInBase(sFindStr As String) As Boolean
    
    Dim i As Integer

    With listDataBase
        
        For i = LBound(.List) To UBound(.List)
            If InStr(.List(i), sFindStr) > 0 Then _
                AlreadyInBase = True: Exit Function '���� ����� � ��� ��� ���� � ����
        Next
        
    End With
End Function


'#########################################################
'������ ������ �� ������������ ���� ������
Private Sub cmbImport_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then bolUserInput = False
End Sub
Private Sub cmbImport_Click()
        
    

    Select Case cmbImport.caption

        Case "������"
        
            MsgBox "���������� ����������, ������� :("
'            Dim sJoinDBName As String, iJoinCnt As Integer
'            sJoinDBName = GetFileFPath(myMenu.ty pe * 2, WorkClsm.startDir, "������������ � ���� ������ " & WorkClsm.DbName)
'
'            If sJoinDBName <> "NoPath" Then '���� ��� ������ ���� � �����
'                iJoinCnt = JoinDataBase(sJoinDBName, sArrDataBase) '������������� �� � �������� ���������� ��������������� ������
'
'                Select Case iJoinCnt '���������� ��������������� ��������
'                    Case 0: RefreshLabelInfo "��� �������� ��� �������", &H800080    '���������� ����
'                    Case Else
'                        Me.listDataBase.Selected(0) = True: RefreshLabelInfo RusPadej3(iJoinCnt), &H8000& '������ ����
'                        bolAlreadySaved = False: PreSaveSetButton True '������� ������ "���������"
'                End Select
'            End If
        Case "�������" '������� ����������� ������

            If iDataBaseIndex = listDataBase.ListIndex Then
                RefreshLabelInfo "�������� ������ �������.", &H800080
            Else

                Dim referenceFifNum As String, _
                    currentFifNum As String

                referenceFifNum = Me.TextBox3
                currentFifNum = sArrDataBase(LBound(sArrDataBase) + 2, iDataBaseIndex)

                sArrDataBase(LBound(sArrDataBase) + 4, iDataBaseIndex) = referenceFifNum '�������� ������ �� ������
                Me.cmbImport.caption = referenceFifNum
                
                ' ------------------------------------------------------
                Dim targetDir As String
                targetDir = Dir(Config.instrumentsPath & "*" & currentFifNum & "*", vbDirectory) '������� ��
                
                Dim fso As New FileSystemObject
                
                Dim targetPath As String
                targetPath = fso.BuildPath(Config.instrumentsPath, targetDir)
                
                Dim targetFilePath As String
                targetFilePath = fso.BuildPath(targetPath, REFERENCE_FIFNUM_FILENAME)
                
                Base.WriteContent targetFilePath, referenceFifNum
                ' ------------------------------------------------------

                bolAlreadySaved = False
                PreSaveSetButton True '������� ������ "���������"
            End If

        Case Else '������� � ������ � ���
            Dim sTempStr As String, i As Integer
            sTempStr = Me.cmbImport.caption

            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                If sArrDataBase(2, i) = sTempStr Then Me.listDataBase.Selected(i) = True: Exit For
            Next i
    End Select
End Sub
'#########################################################
'������� ����������� ������ ���� ������ � ���������� ���������� ��������������� �����
Function JoinDataBase(JoinFPath As String, ByRef BaseDataArr() As String) As Integer
    Dim sArrFile() As String, sInstrDel As String, bolOldFileFormat As Boolean, bolInstrFound As Boolean
    
    sArrFile = myBase.GetArrFF(JoinFPath)    '��������� �� ��������� ������ ������ ������������ �����
    If sArrFile(LBound(sArrFile)) = "newFile" Then Exit Function '�������������� ���� JoinDataBase = 0
    
    sInstrDel = "%" '����� ������ �� ����������� ������� ����
    If InStr(sArrFile(LBound(sArrFile)), sInstrDel) > 0 Then bolInstrFound = True: bolOldFileFormat = True
    
    If bolInstrFound = False Then sInstrDel = InStrDelimiter: _
        If InStr(sArrFile(LBound(sArrFile)), sInstrDel) > 0 Then bolInstrFound = True '����� ������ ������ ����, ���� �� ������� ������ ���
    
    If bolInstrFound Then '���� ���� �������� ������� ���� ������ ����������� � ������������� �����
        JoinDataBase = SubJoinDB(BaseDataArr, sArrFile, sInstrDel, bolOldFileFormat) '������� ��������� �������
        SortMassBiv BaseDataArr(): UpdateListDataBase BaseDataArr  '������������� ��������� ������ �� ������ �� ��������, ������� � �������� ��������
    End If
End Function
'#########################################################
'���������� ������� ��
Function SubJoinDB(ByRef BaseDataArr() As String, _
    sArrFile() As String, sInstrDel As String, Optional OldFileFormat As Boolean) As Integer

    Dim sArrTemp() As String, i As Integer, j As Integer, bolStopLineImport As Boolean
    For i = LBound(sArrFile) To UBound(sArrFile) '�������� �� ����� �������
    
        bolStopLineImport = False: sArrTemp = Split(sArrFile(i), sInstrDel) '������� ������ �� ����������� ��������
        
        If UBound(BaseDataArr) = 0 Then _
            ReDim BaseDataArr(UBound(sArrTemp), 0): If UMenu.typ� = instrumentsOLD Then ReDim BaseDataArr(UBound(sArrTemp) + 1, 0)

        For j = LBound(BaseDataArr, 2) To UBound(BaseDataArr, 2) '�������� �� ������� ��������� �������
            
            If UMenu.typ� = organisationsOLD Then '���������
            
                If OldFileFormat Then '��� ������� ������� ������ ����������
                    If sArrTemp(LBound(sArrTemp) + 1) = BaseDataArr(LBound(BaseDataArr), j) Then _
                        bolStopLineImport = True: Exit For '���� ������������ ��� ���� � ������� - �� ��������� �������
                Else '����������� ������ �����
                    If sArrTemp(LBound(sArrTemp)) = BaseDataArr(LBound(BaseDataArr), j) Then _
                        bolStopLineImport = True: Exit For '���� ������������ ��� ���� � ������� - �� ��������� �������
                End If
                
            ElseIf UMenu.typ� = instrumentsOLD Then '���� ������ ������� ��������� - �������� �� ������ � ���
                If sArrTemp(2) = BaseDataArr(2, j) Then bolStopLineImport = True: Exit For
                
            Else '����������� ������ �����
                If sArrTemp(LBound(sArrTemp)) = BaseDataArr(LBound(BaseDataArr), j) Then _
                    bolStopLineImport = True: Exit For '���� ������������ ��� ���� � ������� - �� ��������� �������
            End If
        Next j
        
        If bolStopLineImport = False Then
            If BaseDataArr(LBound(BaseDataArr), UBound(BaseDataArr, 2)) <> "" Then _
                ReDim Preserve BaseDataArr(UBound(BaseDataArr), UBound(BaseDataArr, 2) + 1) '��������� ������, ���� �� ������
            
            If OldFileFormat And UMenu.typ� = organisationsOLD Then '��� ������� ������� ������ ����������
                BaseDataArr(0, UBound(BaseDataArr, 2)) = sArrTemp(LBound(sArrTemp) + 1) '������������
                BaseDataArr(1, UBound(BaseDataArr, 2)) = sArrTemp(LBound(sArrTemp) + 2) '���
                BaseDataArr(2, UBound(BaseDataArr, 2)) = sArrTemp(LBound(sArrTemp) + 3) '����������
            Else '����������� ������ �����
                
                For j = LBound(sArrTemp) To UBound(sArrTemp) '�������� �������� �� ���������� �������
                    BaseDataArr(j, UBound(BaseDataArr, 2)) = sArrTemp(j) '��������� ������ ��������� ���� ������
                Next j
                
                If UMenu.typ� = instrumentsOLD Then BaseDataArr(UBound(BaseDataArr), UBound(BaseDataArr, 2)) = "nodata" '�������� � ������� ��������
            End If
            
            SubJoinDB = SubJoinDB + 1
        End If
    Next i
End Function
'#########################################################
'������ "�������" ��������� ������ �� ���� ������
Private Sub cmbDelete_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then bolUserInput = False
End Sub
Private Sub cmbDelete_Click()
    
    Dim ask As Integer
    ask = Handler.ask("������� ������� �� ����?")
    
    If ask = vbYes Then _
        cmbDeleteClck
        
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 15:53
' ����������:
'    �������� bolUpdateString:
' ----------------------------------------------------------------
Private Sub cmbDeleteClck( _
    Optional bolUpdateString As Boolean = False _
    )
    With Me.listDataBase
    
        If .ListIndex >= 0 Then '���� ������� ���� �� ������ ������
        
            Dim iLiInd As Integer
            iLiInd = .ListIndex
            ' ----------------------------------------------------------------
            If bolUpdateString Then '������ �������� ������
           
                UpdateArrDB sArrDataBase, .ListIndex
                bolAlreadySaved = True
                ' ------------------------------------------------------
'todo: �������� workclsm
                ArrDBaseToFile sArrDataBase, WorkClsm.startDir & WorkClsm.DbName  '��������� ���� ���������
                PreSaveSetButton True  '������� ������ "���������"
                
                Exit Sub
            End If
            ' ----------------------------------------------------------------
            ReduceArrDB sArrDataBase, .ListIndex '������� ������� �������
            UpdateListDataBase sArrDataBase '��������� �������� ������ ������� �����������
            
            If .ListCount > 0 Then '���� � ��������� ������� ���� ���� �������
                If iLiInd <= UBound(.List()) Then .Selected(iLiInd) = True '�������� ��������� �� ������� ��������
                If iLiInd > UBound(.List()) Then .Selected(UBound(.List())) = True '�������� ��������� ��������� �������
            Else '� ��������� �� �������� ���������
                With Me.cmbAdd: .caption = "������": .Enabled = False: End With
                Me.cmbDelete.Enabled = False: ClearTxtBxes
            End If
            
            bolAlreadySaved = False
            PreSaveSetButton True  '������� ������ "���������"
            
        Else
            RefreshLabelInfo "������ �������� �������."
        End If
        
    End With
    TextBox1.SetFocus
End Sub
'#########################################################
'��������� ��������� ������� ������ �� ���� �������
Sub ReduceArrDB(ByRef BaseArrData() As String, RIndex As Integer)

    Dim j As Integer
    For j = LBound(BaseArrData) To UBound(BaseArrData)
        BaseArrData(j, RIndex) = "" '�������� ��� �������� ������� ������
    Next j
    
    SortMassBiv BaseArrData '������������� ������ �� ���������
    If UBound(BaseArrData, 2) > 0 Then _
        ReDim Preserve BaseArrData(UBound(BaseArrData), UBound(BaseArrData, 2) - 1) '��������� ������ �� ���� ������� � ����������� ������
End Sub
























' ----------------------------------------------------------------
' ����: 25.02.2023 15:55
' ����������: ��������� ��������� �������� �������� �������
'    �������� BaseArrData:
'    �������� RIndex:
' ----------------------------------------------------------------
Private Sub UpdateArrDB( _
    ByRef BaseArrData() As String, _
    RIndex As Integer _
    )

    Dim sSelSaved As String '��������� ������� ��� ��������� ��� � ������ ������������
    Select Case UMenu.typ�
    
        Case organisationsOLD, personsOLD
            sSelSaved = Me.TextBox1 '������������
            
        Case instrumentsOLD, etalonsOLD
            sSelSaved = Me.TextBox3 '����� � ��� / ��������� �����
            
    End Select

    Dim sTb1Text As String, _
        sTb2Text As String, _
        sTb3Text As String, _
        sTb4Text As String, _
        sTb5Text As String
        
    sTb1Text = Me.TextBox1
    sTb2Text = Me.TextBox2
    sTb3Text = Me.TextBox3
    sTb4Text = Me.TextBox4
    sTb5Text = Me.TextBox5
    
    If UMenu.typ� = organisationsOLD Then _
        sTb2Text = Replace(sTb2Text, " ", "")  '���� �������� ���
    
    DeleteSpaceStEnd sTb1Text, True: DeleteSpaceStEnd sTb2Text, True: DeleteSpaceStEnd sTb3Text, True
    DeleteSpaceStEnd sTb4Text, True: DeleteSpaceStEnd sTb5Text, True
    
    ' ----------------------------------------------------------------
    If UMenu.typ� = organisationsOLD Then
    
        Dim key As String
        key = BaseArrData(2, RIndex)
        
        Dim newKey As String
        newKey = sTb3Text
         
        Dim item As New cItemOrganisation
        item.shortName = sTb1Text
        item.taxNumber = sTb2Text
        item.legalAddress = sTb4Text

        DataBase.AddItem _
            key:=key, _
            itemData:=item

    End If

    ' ----------------------------------------------------------------
    Select Case UMenu.typ�
    
        Case organisationsOLD, instrumentsOLD, etalonsOLD
            BaseArrData(0, RIndex) = sTb1Text '������������
            BaseArrData(1, RIndex) = sTb2Text '��� / ���
            BaseArrData(2, RIndex) = sTb3Text '���� ����������� / ���. � ���
            BaseArrData(3, RIndex) = sTb4Text '����� / ��
            
        Case personsOLD '������� � ���������
            BaseArrData(0, RIndex) = sTb1Text: BaseArrData(1, RIndex) = sTb3Text '���������
            BaseArrData(2, RIndex) = "nodata": If Me.chbVerRefer Then BaseArrData(2, RIndex) = "����������"
            
    End Select
    ' ----------------------------------------------------------------
    If UMenu.typ� = etalonsOLD Then _
        BaseArrData(4, RIndex) = sTb5Text
    
    Select Case UMenu.typ�
        
        Case instrumentsOLD
            SortMassBiv BaseArrData, 1 '������������� ������ �� ���� ��
            
        Case etalonsOLD
            SortMassBiv BaseArrData, UBound(BaseArrData) '������������� ������ �� ��������� ����� �������
        
        Case Else
            SortMassBiv BaseArrData '������������� ������ �� ��������� '���������, ������� - ����������� �� ������� ������������
            
    End Select
    
  
    UpdateListDataBase sArrDataBase '��������� �������� ������ ������� �����������
    
    Dim i As Integer
    For i = LBound(listDataBase.List) To UBound(listDataBase.List)
        If InStr(listDataBase.List(i), sSelSaved) > 0 Then _
            listDataBase.Selected(i) = True: Exit For '�������� ����������� ������
    Next i
    
    bolAlreadySaved = False
    PreSaveSetButton True '������� ������ "���������"
End Sub





























'#########################################################
'������ "��������"
Private Sub cmbAdd_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then bolUserInput = False
End Sub
Private Sub cmbAdd_Click()
    
    With Me.cmbAdd

        If .caption = "��������" Then '�������� ���� ��� �������� ������ � ����
            
            Me.TextBox1.SetFocus
            If UMenu.typ� = instrumentsOLD Then _
                Me.TextBox3.SetFocus

            .caption = "������"
            .Enabled = False
            
            ClearTxtBxes 'bolUserInput = True: ClearTxtBxes: bolUserInput = False
            
            Me.chbVerRefer = False
            Me.chbEtalon = False
            PreSaveSetButton
        Else '������ �������� � ���� ������

            Dim sTempSelect As String, _
                sTb1Text As String, _
                sTb2Text As String, _
                sTb3Text As String, _
                sTb4Text As String, _
                sTb5Text As String
                
            Select Case UMenu.typ� '��������� ������ ��� ���������� ���������
                
                Case organisationsOLD, personsOLD
                    sTempSelect = Me.TextBox1 '������ ������������ ��� �������
                    
                Case instrumentsOLD, etalonsOLD
                    sTempSelect = Me.TextBox3 '����� ��� ��� �� ����������
                    
            End Select
            
            sTb1Text = Trim(Me.TextBox1)
            sTb2Text = Trim(Me.TextBox2)
            sTb3Text = Trim(Me.TextBox3)
            sTb4Text = Trim(Me.TextBox4)
            sTb5Text = Trim(Me.TextBox5)
            ' ------------------------------------------------------
            If UMenu.typ� = organisationsOLD Then _
                sTb2Text = Replace(sTb2Text, " ", "")  '���� �������� ���
            ' ------------------------------------------------------
            With myBase
                .ClearParameters
                .AddP DeleteSpaceStEnd(sTb1Text, True) '������ ������������
                
                Select Case UMenu.typ�
                
                    Case organisationsOLD '�����������
                        .AddP DeleteSpaceStEnd(sTb2Text, True) '���
                        
                        If sTb3Text = "" Then _
                            sTb3Text = "��������" ' ����������
                            
                        .AddP DeleteSpaceStEnd(sTb3Text, True) '�������� ����� � �������������
                        .AddP DeleteSpaceStEnd(sTb4Text, True) '�����
                        
                    Case instrumentsOLD '�������� ���������
                        .AddP DeleteSpaceStEnd(sTb2Text, True)
                        .AddP DeleteSpaceStEnd(sTb3Text, True)
                        .AddP DeleteSpaceStEnd(sTb4Text, True)
                        .AddP DeleteSpaceStEnd("", True) '������� ������� ��������� � ������������� - '- �� ��������� �����������.
                        
                    Case etalonsOLD '�������
                        .AddP DeleteSpaceStEnd(sTb2Text, True)
                        .AddP DeleteSpaceStEnd(sTb3Text, True)
                        .AddP DeleteSpaceStEnd(sTb4Text, True)
                        .AddP DeleteSpaceStEnd(sTb5Text, True) '�������� ����� ��� ������
                        
                    Case personsOLD '�������
                        .AddP DeleteSpaceStEnd(sTb3Text, True) '���������
                        
                        Dim sTempStr As String
                        If Me.chbVerRefer Then sTempStr = "����������"
                        
                        .AddP DeleteSpaceStEnd(sTempStr, True) '������ ����������
                End Select
                
                AddToArrDataBase sArrDataBase, .Parameters
            End With
            ' ----------------------------------------------------------------
            ' ����: 24.02.2023 22:57
            ' ����������: �������� �������� ������ ��������
            ' ----------------------------------------------------------------
            If UMenu.typ� = organisationsOLD Then
                
                Dim item As New cItemOrganisation
                item.shortName = sTb1Text
                item.taxNumber = sTb2Text
                item.legalAddress = sTb4Text
                
                
                DataBase.AddItem _
                    key:=sTb3Text, _
                    itemData:=item
                                
            End If
             ' ------------------------------------------------------
            If UMenu.typ� = instrumentsOLD Then
            
                Dim regFifNum As String, _
                    regTypeName As String, _
                    templateNewPath As String
                
                regFifNum = DeleteSpaceStEnd(sTb3Text)
                regTypeName = DeleteSpaceStEnd(sTb2Text)
            ' ------------------------------------------------------
'todo: �������� workclsm
                templateNewPath = WorkClsm.templatesDir & regTypeName & "_" & regFifNum & Application.PathSeparator
                If FolderNotExist(templateNewPath) Then _
                    MkDir templateNewPath '������� ������� ��� ������� ��
                
                Dim templateNewSomniumPath As String
                ' ------------------------------------------------------
'todo: �������� workclsm
                templateNewSomniumPath = WorkClsm.templatesDir & regTypeName & "_" & regFifNum & Application.PathSeparator
                
                If FolderNotExist(templateNewSomniumPath) Then _
                    MkDir templateNewSomniumPath '������� ������� ��� ������� ��
                    
       '         Dim referenceFifNum As String
        '        referenceFifNum = sArrDataBase(LBound(sArrDataBase) + 4, iDataBaseIndex)
                 ' ------------------------------------------------------
'todo: �������� workclsm
                CheckTempDir WorkClsm.startDir, sArrDataBase
            End If
             ' ------------------------------------------------------
            UpdateListDataBase sArrDataBase '��������� �������� ������ �������

            Dim i As Integer
            For i = LBound(listDataBase.List) To UBound(listDataBase.List)
            
                If listDataBase.List(i) Like "*" & sTempSelect & "*" Then _
                    listDataBase.Selected(i) = True: _
                    Exit For '�������� ����������� ������
                    
            Next i
            
            .caption = "��������"
            bolAlreadySaved = False
            PreSaveSetButton True '������� ������ "���������"
        End If
    End With
End Sub
' ----------------------------------------------------------------
' ����: 24.02.2023 17:56
' ����������: �������� �������� ��� �������� ���� ������
'    �������� itemName: �������� ����� �������� ��
' ----------------------------------------------------------------
    Private Function CreateItemDir( _
        itemName As String _
        ) As String
        
        Dim fso As New FileSystemObject, _
            sourceDataPath As String
  ' ------------------------------------------------------
'todo: �������� workclsm
        sourceDataPath = fso.BuildPath(WorkClsm.startDir, sourceDataPath)
        
        If Not fso.FolderExists(sourceDataPath) Then _
            fso.CreateFolder sourceDataPath
            
        Dim targetPath As String
        targetPath = fso.BuildPath(sourceDataPath, itemName)
        
        If Not fso.FolderExists(targetPath) Then _
            fso.CreateFolder targetPath
        
        CreateItemDir = targetPath
        
    End Function
        Private Function sourceDataPath( _
            ) As String
            
            sourceDataPath = Base.defaultValue
            
            Select Case True
                    
                Case UMenu.typ� = organisationsOLD
                    sourceDataPath = "organisations"
                    
                Case UMenu.typ� = instrumentsOLD
                    sourceDataPath = "instruments"
                
                Case UMenu.typ� = etalonsOLD
                    sourceDataPath = "etalons"
                    
                Case UMenu.typ� = personsOLD
                    sourceDataPath = "persons"
                
            End Select
            
        End Function

'#########################################################
'��������� ������������ � ��������� ������� �������������� ������
Sub AddToArrDataBase(ByRef BaseArrData() As String, InpArr() As String)

    Select Case UMenu.typ�
        
        Case organisationsOLD
            
            If UBound(BaseArrData) = 0 Then _
                ReDim BaseArrData(3, 0)
            
        Case instrumentsOLD, etalonsOLD
        
            If UBound(BaseArrData) = 0 Then _
                ReDim BaseArrData(4, 0)
            
        Case personsOLD
            If UBound(BaseArrData) = 0 Then _
                ReDim BaseArrData(2, 0)
                
    End Select
    
    If BaseArrData(0, UBound(BaseArrData, 2)) <> "" Then _
        ReDim Preserve BaseArrData(UBound(BaseArrData), UBound(BaseArrData, 2) + 1) '��������� ������, ���� �� ������
    
    ReDim Preserve InpArr(UBound(BaseArrData))
    
    Dim i As Integer
    For i = LBound(InpArr) To UBound(InpArr)
        If InpArr(i) = "" Then InpArr(i) = "nodata" ' �������� ������ ��������
        BaseArrData(i, UBound(BaseArrData, 2)) = InpArr(i) '�������� �������� � ������ ���� ������
    Next i
    
    SortMassBiv BaseArrData() '������������� ��������� ������ �� ������ �� ��������, ������� � �������� ��������
End Sub
'############################################################
'������ "������"/"���������"
Private Sub cmbReady_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then bolUserInput = False
End Sub
Private Sub cmbReady_Click()
    Select Case Me.cmbReady.caption
        Case "��������": cmbDeleteClck True
        Case "���������"
        ' ------------------------------------------------------
'todo: �������� workclsm
            bolAlreadySaved = True: ArrDBaseToFile sArrDataBase, WorkClsm.startDir & WorkClsm.DbName  '��������� ���� ���������
            'bolAlreadySaved = True: ArrDBaseToFile sArrDataBase, WorkClsm.startDir & WorkClsm.DbName, True  ' �������� ����� ��������
        Case Else
        
            VBA.Unload Me


    End Select
End Sub
'############################################################
'��������� ��������� ������� � ���� ������
Sub ArrDBaseToFile( _
    BaseArr() As String, _
    fPath As String, _
    Optional myNewParameter As Boolean _
    )
    
    Dim i As Integer, j As Integer, sTempStr As String, bUpperBound As Byte
    bUpperBound = UBound(BaseArr): If UMenu.typ� = instrumentsOLD Then bUpperBound = UBound(BaseArr) - 1 '������������� ��� �� ��

    For i = LBound(BaseArr, 2) To UBound(BaseArr, 2)
        
        For j = LBound(BaseArr) To bUpperBound  '���������
            sTempStr = sTempStr & BaseArr(j, i): If j < bUpperBound Then sTempStr = sTempStr & InStrDelimiter '����������� ������ ������
        Next j
        
        '######################################
        If myNewParameter Then sTempStr = sTempStr & InStrDelimiter & "nodata" '������ ��� ���������� ������ ���������
        '######################################
        If i < UBound(BaseArr, 2) Then sTempStr = sTempStr & vbNewLine '����������� ����� �����
    Next i
    
    If fPath = "����������" Then
        MsgBox "���� ����������, �������� ����� �����. ��� �����, ������?"
'        Select Case uMenu.typ�
'
'            Case organisations, instruments, etalons
'                fPath = GetSaveAsFname(myMe nu.type * 2, WorkClsm.startDir)
'
'            Case persons
'                fPath = GetSaveAsFname(myMen u.type + 2, WorkClsm.startDir)
'
'        End Select
    End If
    
    If fPath <> "NoPath" Then
        Open fPath For Output As #1: Print #1, sTempStr: Close
        
        PreSaveSetButton True '������� ������ "������"
        RefreshLabelInfo "��������� ���������.", , True
    End If
End Sub
'############################################################
'��������� ������� ���� �����
Sub ClearTxtBxes()
    Me.TextBox1 = "": Me.TextBox2 = "": Me.TextBox3 = "": Me.TextBox4 = "": Me.TextBox5 = ""
    Me.tboxSearchConstr = "": Me.listDataBase.ListIndex = -1
End Sub
'############################################################
'������� ������������ ����� ��� ������ ��������� � ���������� ����������
Function RusPadej3(value As Integer)
    Select Case value
        Case 1, 21, 31, 41, 51, 61, 71, 81, 91, 101, 121
            RusPadej3 = "������������� " & value & " ������������."
        Case 2 To 4, 22 To 24, 32 To 34, 42 To 44, 52 To 54, 62 To 64, 72 To 74, 82 To 84, 92 To 94
            RusPadej3 = "������������� " & value & " ������������."
        Case Else
            RusPadej3 = "������������� " & value & " ������������."
    End Select
End Function
'############################################################
'��������� ��������� ������� �������� �������
Private Sub cmbOpenTemplateFolder_Click()

'    Dim sTempDir As String, sBaseDir As String, sFifNum As String, sTypeName As String
'    sBaseDir = WorkClsm.templatesDir
'    sFifNum = sArrDataBase(2, Me.listDataBase.ListIndex): sTypeName = sArrDataBase(1, Me.listDataBase.ListIndex)
'    sTempDir = Dir(sBaseDir & "*" & sFifNum & "*", vbDirectory)  '������� ��
'
'    Explorer.OpenFolder sBaseDir & sTempDir & "\", True
'
'
    Dim sTempDir As String, _
        templatesDir As String, _
        fifRegNum As String, _
        sTypeName As String
     ' ------------------------------------------------------
'todo: �������� workclsm
    templatesDir = WorkClsm.templatesDir & Application.PathSeparator
    fifRegNum = sArrDataBase(2, Me.listDataBase.ListIndex)
        
    Dim currTemplateDir As String
    currTemplateDir = Dir(templatesDir & "*" & fifRegNum & "*", vbDirectory)   '������� ���������� ��
    
    Dim refFifPath As String
    refFifPath = templatesDir & currTemplateDir & Application.PathSeparator & REFERENCE_FIFNUM_FILENAME
    
    If FileExist(refFifPath) Then _
        fifRegNum = Base.ContentFromFile(refFifPath)
    
    sTypeName = sArrDataBase(1, Me.listDataBase.ListIndex)
    sTempDir = Dir(templatesDir & "*" & fifRegNum & "*", vbDirectory)  '������� ��
    
    Explorer.OpenFolder templatesDir & sTempDir & "\", True
End Sub
'#########################################################
'�������� � �������� ��������� ����� ������ ��� �������
Private Sub cmbFillTempProp_Click()
' ------------------------------------------------------
'todo: �������� workclsm
    Me.cmbFillTempProp.Enabled = False: FillIfXl WorkClsm, sArrDataBase, Me.listDataBase.ListIndex
End Sub
'#########################################################
'������� �������� �����������
Private Sub chbVerRefer_Change()

    Me.chbVerRefer.foreColor = &H80000007
    
    If Me.chbVerRefer Then _
        TrueElementForeColor Me.chbVerRefer
    
    If UMenu.typ� = instrumentsOLD Then
    
        With Me.cmbImport
            
            .foreColor = Me.chbVerRefer.foreColor
            
            If Me.chbVerRefer = False Then
                .caption = "������"
                .ControlTipText = "������ ������ �� ������������ ����"
                
                If bolUF_Cnstr_Load And bolUserInput Then
                    '������� ������ �� ����������� ������, ���� ������� �������
                    Dim regFifNum As String
                    regFifNum = Me.TextBox3
                    
                    Dim currentInstrumentDir As String
                    ' ------------------------------------------------------
'todo: �������� workclsm
                    currentInstrumentDir = Dir(WorkClsm.templatesDir & "*" & regFifNum & "*", vbDirectory) '������� ��
                    
                    Dim referenceFilePath As String
                    ' ------------------------------------------------------
'todo: �������� workclsm
                    referenceFilePath = WorkClsm.templatesDir & currentInstrumentDir & Application.PathSeparator & REFERENCE_FIFNUM_FILENAME
                    
                    If FileExist(referenceFilePath) Then _
                        Kill referenceFilePath
                End If
                
            End If
            
            If Me.chbVerRefer And .caption = "������" Then
                .caption = "�������"
                .ControlTipText = "������� ������� ���� ��� ����������� ������"
            End If
            
            If Me.chbVerRefer And .caption <> "�������" Then
                .ControlTipText = "������� � �������� ����������� ������"
            End If
        End With
        
    End If
    
    If bolUF_Cnstr_Load And bolUserInput Then
    
        Dim iUboundArr As Integer
        iUboundArr = UBound(sArrDataBase) - 2 '�� ��������� ��� ������� ��������� - ������������� �������
        
        If UMenu.typ� = personsOLD Then _
            iUboundArr = UBound(sArrDataBase) '��� ������� � ����������
        
        If Me.chbVerRefer = False Then _
            sArrDataBase(iUboundArr, listDataBase.ListIndex) = "nodata"
            
        If UMenu.typ� = personsOLD And Me.chbVerRefer Then _
            sArrDataBase(iUboundArr, listDataBase.ListIndex) = "����������"
        
        If UMenu.typ� = instrumentsOLD Then
            
            iDataBaseIndex = 0
            
            If Me.chbVerRefer Then _
                iDataBaseIndex = listDataBase.ListIndex '�������� �������
        End If
    
        bolAlreadySaved = False: bolUserInput = False: PreSaveSetButton
    End If
End Sub
Private Sub chbVerRefer_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    bolUserInput = True
End Sub
'#########################################################
'�������� ��������� �������� ��������
Private Sub chbEtalon_Change()
    Me.chbEtalon.foreColor = &H80000007: If Me.chbEtalon Then TrueElementForeColor Me.chbEtalon
    
    If bolUF_Cnstr_Load And bolUserInput Then
    
        Dim iUboundArr As Integer
        iUboundArr = UBound(sArrDataBase) - 1 '�� ��������� ��� ������� ���������

        If Me.chbEtalon = False Then sArrDataBase(iUboundArr, listDataBase.ListIndex) = "nodata"
        If Me.chbEtalon Then sArrDataBase(iUboundArr, listDataBase.ListIndex) = "etalon"
        
        iDataBaseIndex = 0: If Me.chbEtalon Then iDataBaseIndex = listDataBase.ListIndex '�������� �������
        bolAlreadySaved = False: bolUserInput = False: PreSaveSetButton
    End If
End Sub
Private Sub chbEtalon_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    bolUserInput = True
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
