VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Z_UF_Search 
   Caption         =   "���� ������ ����������/������� ���������/��������"
   ClientHeight    =   3330
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   9660
   OleObjectBlob   =   "Z_UF_Search.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Z_UF_Search"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Text
Option Explicit '������ �� ������������� ������� ����������

Const REFERENCE_FIFNUM_FILENAME = "fifRegNum.ref"

Private myBase As New Z_clsmBase, _
        WorkClsm As New Z_clsmSearch, _
        myMi As MeasInstrument

Dim sArrKeyCode() As String, _
    sArrDataBase() As String

Private itemIndex As String, _
        bolTbEntry As Boolean
    
Private fso As New FileSystemObject

Private Sub UserForm_Initialize() '�������� �����
    
    Set_Z_UF_Search_Size '������ �������������� �������� ��� ����� ������ �� ��
    GetMyConfigFromFile myBase, WorkClsm '��������� ��������� �� ������
    ' ------------------------------------------------------
    TransferConfig
    ' ------------------------------------------------------

' ------------------------------------------------------
'todo: ��������� � ����� ������ cache.db
    If UMenu.typ� <> archiveOLD Then _
        FillArrDataBaseFromFile sArrDataBase(), WorkClsm.DbName  '��������� ������ �������� ���� ������
' ------------------------------------------------------
    If UMenu.typ� = personsOLD Then '������ ��� ����� ������� � ����������
        ' ------------------------------------------------------
'todo: ��������� � ����� ������ cache.db
        If WorkClsm.isFullName = "True" Then _
            WorkClsm.FullFirstName = True '���� � ��������� ������� �������� ������� �����
' ------------------------------------------------------
'todo: ��������� � ����� ������ cache.db
        If WorkClsm.FullFirstName = "����������" Then _
            WorkClsm.FullFirstName = False
            
        Me.chbFullName = WorkClsm.FullFirstName '�������� �������� � �������
        
    End If
    
    If UMenu.typ� = archiveOLD Then '�����

        FillArchivedata sArrDataBase '�������� ������ � ������� ��������� �������� �����
        Me.LabelInfo.caption = DataBase.LabelInfoText
        
    End If
        

    
    TrueElementForeColor Me.LabelInfo '��������� �������������� ����� � ����������� �� ���� ����������
' ------------------------------------------------------
'todo: ��������� � �������
    FillArrKeycodeFromFile '��������� ������ ��������
' ------------------------------------------------------

    If UMenu.typ� = etalonsOLD Then _
        SortMassBiv sArrDataBase, UBound(sArrDataBase) '����������� ������ �� ��������� �����
        
    UpdateTboxAndListbox '�������� ��������� �������� � ���������
    
    If Me.listResults.ListCount = 0 Then _
        UpdateListResults sArrDataBase

    SetEventControls Me '������������ ��������� ������� ��� ���� ���������

    InsertSearchData
    
    With Me.tboxSearch
        .SelStart = 0
        .SelLength = Len(.text)
    End With
    
    
End Sub
    ' ----------------------------------------------------------------
    ' ����: 26.02.2023 10:46
    ' ����������: ��� �������� �� ������ �������� � �����
    ' ----------------------------------------------------------------
    Private Sub TransferConfig()
        
        If Config.sourceDataPath = Base.defaultValue Then _
            Config.sourceDataPath = WorkClsm.startDir
        
        If Config.sandboxPath = Base.defaultValue Then _
            Config.sandboxPath = WorkClsm.workDir
        
        If WorkClsm.ArchivePath <> vbNullString Then
        
            If Config.archiveLocalPath = Base.defaultValue Then _
                Config.archiveLocalPath = WorkClsm.ArchivePath
            
        End If
        
        Config.Save
        
    End Sub
Private Sub UserForm_Activate()
    
    If Not UMenu.isLoaded Then _
        VBA.Unload Me
    
End Sub
'#########################################################
'�������� � ������ ������ ������ � ��
Private Sub InsertSearchData()

    If UMenu.typ� = instrumentsOLD Then '������ ��� �� ��
        
        Properties.SetTargetWorkbook ActiveWorkbook
        
        Dim sKeyWord As String
        sKeyWord = Properties.Keywords '�������� ����� � ���

        If sKeyWord <> vbNullString Then
                        
            If InStr(sKeyWord, "-") = 0 Then '���������� ������ � ��� �� ������
                
                If Len(sKeyWord) >= 8 Then
                    sKeyWord = Left(sKeyWord, 8)
                    sKeyWord = Replace(sKeyWord, ".", "-")
                    
                End If
                
            End If
            
            Me.tboxSearch = sKeyWord
            
            Dim i As Integer
            For i = LBound(Me.listResults.List) To UBound(Me.listResults.List)
                If InStr(Me.listResults.List(i), sKeyWord) > 0 Then Me.listResults.Selected(i) = True: Exit Sub
            Next i
        End If
    End If
End Sub

    ' ----------------------------------------------------------------
    ' ����: 09.03.2023 18:31
    ' ����������: �������� ������ ������ ������
    ' ----------------------------------------------------------------
    Private Sub FillArchivedata( _
        ByRef sArrToFill() As String, _
        Optional key As String _
        )
        
        Dim sArchivePath As String, sTempStr As String
        sArchivePath = Config.archiveLocalPath

        Dim arc As New Collection
        Set arc = DataBase.FilterArchive(key)
        
        If Not CBool(arc.count) Then _
            ReDim sArrToFill(0, 0): _
            Exit Sub
            
            
        Dim tempCol As New Collection
        
            
        ReDim sArrToFill(0, arc.count - 1)
        
        Dim i As Integer
        For i = 1 To arc.count
            sArrToFill(0, i - 1) = arc(i)
        Next i
        
        
'        If sArrDataBase(LBound(sArrDataBase), UBound(sArrDataBase, 2)) <> vbNullString Then _
'            SortMassBiv sArrToFill, , , False
'
    End Sub
Private Sub UserForm_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    
    If Shift = 2 And UMenu.typ� = instrumentsOLD Then _
        Me.cmb1.caption = "*"
    
    If KeyCode = vbKeyEscape Then _
        VBA.Unload Me
End Sub
Private Sub UserForm_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    
    If UMenu.typ� = instrumentsOLD Then _
        Me.cmb1.caption = "�"
        
End Sub

'#########################################################
'��������� ����������� ��� �������� �����
Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    
    myBase.GetArrFF setDir, "settings.ini" '��������� � ����� ���� ��������
    myBase.SaveProperties WorkClsm.myParameters, WorkClsm.myValues '�������� ��������� � ���� ��������
    ' ------------------------------------------------------
    'todo: ��������� Cache ���� -- db.close
    
End Sub
'#########################################################
'��������� ����������� ��� �������� �����
Private Sub UserForm_Terminate()

    UMenu.isLoaded = False
    
    Set myBase = Nothing
    Set WorkClsm = Nothing
    
    ClearSingletone
End Sub

'#########################################################
'����� ���������� �� ���� ������
Private Sub tboxSearch_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    
    If bolTbEntry = False Then '���������� ������� �����
    
        With Me.tboxSearch
            
            .SelStart = 0
            .SelLength = Len(.text)
            
        End With
        
        bolTbEntry = True
        
    End If
End Sub
Private Sub tboxSearch_KeyDown( _
    ByVal KeyCode As MSForms.ReturnInteger, _
    ByVal Shift As Integer _
    ) '����� �� ������������
    
    Dim i As Integer, _
    bolSeleceted As Boolean
    
    If KeyCode = 13 Then '������� enter
        
        For i = LBound(listResults.List) To UBound(listResults.List)
            
            If listResults.Selected(i) = True Then _
                bolSeleceted = True: _
                Exit For '���� �� �������� ���� ���� ������
                
        Next i
        
        If bolSeleceted Then  '������� ���������� ������
            
            If Shift = 2 Then '����� CTRL
                TransferManufacturer
                
            ElseIf Shift = 1 Then 'shift
                
                If Me.btnOpenFolder.Enabled Then _
                    btnOpenFolder_Click
            
            Else
            
                If Me.cmbProtSv.Enabled Then _
                    cmbProtSv_Click: Exit Sub '������
                    
                If Me.cmbDescription.Enabled Then _
                    cmbDescription_Click: _
                    Exit Sub '�������� ����
                    
                If Me.cmbMetodic.Enabled Then _
                    cmbMetodic_Click: _
                    Exit Sub '�������� �������
                
                cmbOneClick '������ ������������ ������� ��
                
            End If
        Else '������ �� ���� ��������
            If UMenu.typ� = etalonsOLD And myWdDoc = False And _
                Me.cmbProtSv.Enabled Then cmbProtSv_Click: Exit Sub '����� � ���������� �������� �� ��������� ������������
                
            Me.listResults.Selected(0) = True '�������� ������ ������� ���������� �������
        End If
        
    End If
    
    If KeyCode = vbKeyEscape Then _
        VBA.Unload Me
End Sub
    Private Sub TransferManufacturer()
        
        If Not UMenu.typ� = organisationsOLD Then _
            Exit Sub
            
        Application.ScreenUpdating = False
        
        Dim customerCell As Range
        If FindCellRight("������������:", customerCell, ThisCell:=True) Then
            
            customerCell.Offset(0, 1) = sArrDataBase(0, CInt(itemIndex)) ' ������������
        Else
            ActiveCell = sArrDataBase(0, CInt(itemIndex)) ' ������������
            ActiveCell.Offset(1, 0).Select
        End If
        
        Application.ScreenUpdating = True
        VBA.Unload Me
        
    End Sub
    
Private Sub tboxSearch_Change()
    DisableButtons '��������� ��� ������ �����
    
    If tboxSearch = "" Then
        UpdateListResults sArrDataBase  '�������� ���������� ���������1
    Else
        Dim sTempArr() As String
        ReDim sTempArr(UBound(sArrDataBase), 0) '�������� ������ ��� ��������� ������
        
        If sArrKeyCode(0, 0) = "" Then '������ �������� �� ��� ��������
            FindInBivArr sArrDataBase, sTempArr, Me.tboxSearch  '�������� ������ ��������� ����������
        Else ' ������ �������� ��� ��������
            
            Dim sInputRus As String, sInputEng As String, sInputString As String
            FillInputData sArrKeyCode, Me.tboxSearch, sInputRus, sInputEng  '�������� �������� ��� ������ �� �������
            sInputString = sInputRus & " " & sInputEng

            FindInBivArr sArrDataBase, sTempArr, sInputString  '�������� ������ ��������� ���������� ���������� �� ������� �����

        End If

        UpdateListResults sTempArr  '�������� ������ ���������� �� ������� sTempArr
    End If
    ' ------------------------------------------------------
    'todo: ��������� � db.LastSearch
    WorkClsm.LastSearch = Me.tboxSearch '�������� �������� � ������
    
    Dim iListCount As Integer
    iListCount = listResults.ListCount - 1
    
    If UMenu.typ� = archiveOLD Then _
        iListCount = listResults.ListCount
        
    Me.labelUnderSearchField.caption = RusPadejCoincidence(iListCount, Me.labelUnderSearchField)

    If tboxSearch = "" Then _
        Me.labelUnderSearchField.caption = "����� ����������": Me.labelUnderSearchField.foreColor = &H80000012 '- ������
    
    If listResults.ListCount = 2 Then _
        If listResults.List(1) = "������ ��������� � ���� ������..." Then listResults.Selected(0) = True '������� ������ �������
    
    If listResults.ListCount = 1 Then _
        If listResults.List(0) <> "������ ��������� � ���� ������..." Then listResults.Selected(0) = True
End Sub
Private Sub tboxSearch_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    bolTbEntry = False
End Sub
'#########################################################
'������������� ����������� ������� � ���������
Private Sub chbFullName_Change()
    
    If Me.chbFullName Then
        TrueElementForeColor Me.chbFullName
        
        If UMenu.typ� = personsOLD Then _
            Me.cmb1.caption = "��� ���������"
    Else
        Me.chbFullName.foreColor = &H80000007
        
        If UMenu.typ� = personsOLD Then _
            Me.cmb1.caption = "������� �.�."
    End If
    
    If UMenu.isLoaded Then

        If UMenu.typ� = personsOLD Then '�������
            ' ------------------------------------------------------
            'todo: ��������� � db
            WorkClsm.FullFirstName = Me.chbFullName
            tboxSearch_Change
        End If
        
        If UMenu.typ� = archiveOLD Then '����� �����
            If Me.chbFullName Then
            
                If MsgBox("�������� �����?", vbYesNo) = vbYes Then _
                    ProtectSheets: _
                    Me.chbFullName = Not Me.chbFullName: _
                    VBA.Unload Me
                    
            End If
        End If
    End If
End Sub
Private Sub chbFullName_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then cmbOneClick
End Sub
'############################
'��������� ������ ����������
Private Sub listResults_Click()

    Dim sLB1str As String
    Call DisableButtons: sLB1str = listResults.text  '��������� ������
    
    If sLB1str <> "������ ��������� � ���� ������..." Then
    ' ------------------------------------------------------
    'todo: ��������� � db.lastsearch
        WorkClsm.LastIndex = listResults.ListIndex  ' ������ ������� ��������� ������
        WorkClsm.constrSrch = GetconstrSrch(sLB1str)  '�������� ������� ��� ������ � ������������
        
        GetDBindAndMyMi sLB1str
    End If
End Sub
'############################
'�������������� ����������
Private Sub GetDBindAndMyMi(sLB1str As String, Optional DontEnableButtons As Boolean)

    itemIndex = DataBaseIndex(sLB1str) '�������� ������ �������� � ����� �������
    If IsNumeric(itemIndex) Then
    
        If DontEnableButtons = False Then
            EnableButtons '������������ ������ � ������������� �� ��������� ���������� ����� ������ ������� ���� ������
            Me.labelUnderSearchField.caption = "������� Enter": TrueElementForeColor Me.labelUnderSearchField
        End If
       
        With myMi
            .sName = sArrDataBase(0, CInt(itemIndex))
            If UMenu.typ� <> archiveOLD Then
                .sType = sArrDataBase(1, CInt(itemIndex)): .sFif = sArrDataBase(2, CInt(itemIndex))
                
                If UMenu.typ� <> personsOLD Then
                    .sMetodic = sArrDataBase(3, CInt(itemIndex)): .sRef = sArrDataBase(UBound(sArrDataBase) - 2, CInt(itemIndex))
                    .bolEtal = False: If sArrDataBase(UBound(sArrDataBase) - 1, CInt(itemIndex)) <> "nodata" Then .bolEtal = True
                End If
            End If
        End With
    End If
End Sub

'############################
'������� �������� ��������� ��� �������� � ���������� ������ � ������������
Function GetconstrSrch(ByVal sSelectedLBstr As String) As String
    
    Dim sArrTemp() As String
    sArrTemp = Split(sSelectedLBstr, " \\ ")
    
    Select Case UMenu.typ�
    
        Case organisationsOLD
            Dim i As Integer '��������� ������ = ������������ �����������
            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                If sArrDataBase(0, i) = sArrTemp(0) Then GetconstrSrch = sArrDataBase(0, i): Exit Function
            Next i
           
        Case instrumentsOLD, etalonsOLD
            GetconstrSrch = sArrTemp(0)   '����� ��� ��� �� �������� �����
            
        Case personsOLD
            sArrTemp = Split(sArrTemp(0), " "): GetconstrSrch = sArrTemp(0) '�������
            
    End Select
    
End Function
Private Sub listResults_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 13 Then 'enter
        If Me.cmbProtSv.Enabled Then Me.cmbProtSv.SetFocus: Exit Sub '������
        If Me.cmbDescription.Enabled Then Me.cmbDescription.SetFocus: Exit Sub '�������� ����
        If Me.cmbMetodic.Enabled Then Me.cmbMetodic.SetFocus: Exit Sub '�������� �������
        
        Me.cmb1.SetFocus '������ ������������ ������� ��
    End If
End Sub
Private Sub listResults_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    If listResults.text = "������ ��������� � ���� ������..." Then _
        VBA.Unload Me: Z_UF_Constructor.Show 0 '�������� ����� ������������ ��
End Sub
Private Sub listResults_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If listResults.text = "������ ��������� � ���� ������..." Then _
        VBA.Unload Me: Z_UF_Constructor.Show 0 '�������� ����� ������������ ��
End Sub
'#########################################################
'������� ���������� ������� �������� � ����� �������
Function DataBaseIndex(sFindStr As String) As Integer
    DataBaseIndex = -1 '�� ���������
    
    If UMenu.typ� <> archiveOLD Then _
        sFindStr = Left(sFindStr, InStr(sFindStr, " \\ ") - 1) ' ������ ��� ������ � ������� ���� ������
    
    Dim i As Integer, j As Integer, bolExitFor As Boolean, iUbound As Integer
    iUbound = UBound(sArrDataBase)
    
    If UMenu.typ� = instrumentsOLD Then _
        iUbound = LBound(sArrDataBase) + 3
    
    For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
        For j = LBound(sArrDataBase) To iUbound
            If InStr(sArrDataBase(j, i), sFindStr) > 0 Then bolExitFor = True: Exit For '������� ������ ���� ������
        Next j
        If bolExitFor Then Exit For
    Next i

    If i > UBound(sArrDataBase, 2) Then '������ ������ - ������� ����� ���������� ��� ��� ����������
        If InStr(sFindStr, " ") > 0 Then '������ ���� ���� ������ � ��������� ������
        
            Dim sArrTemp() As String
            sArrTemp = Split(sFindStr, " "): sFindStr = sArrTemp(0)
            
            For i = LBound(sArrTemp) To UBound(sArrTemp)
                If Len(sArrTemp(i)) > Len(sFindStr) Then sFindStr = sArrTemp(i)
            Next i
    
            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                For j = LBound(sArrDataBase) To UBound(sArrDataBase)
                    If InStr(sArrDataBase(j, i), sFindStr) > 0 Then bolExitFor = True: Exit For '������� ������ ���� ������
                Next j
                If bolExitFor Then Exit For
            Next i
            
        End If
    End If
    
    If i <= UBound(sArrDataBase, 2) Then
        If sArrDataBase(0, i) <> "" Then DataBaseIndex = i
    End If
    
End Function
' ----------------------------------------------------------------
' ����: 25.02.2023 13:01
' ����������:
'    �������� DbIndex:
' ----------------------------------------------------------------
Private Sub EnableButtons( _
    )
    Select Case True
    
        Case UMenu.typ� = organisationsOLD
            EnableForOrganisations
        ' ----------------------------------------------------------------
        Case UMenu.typ� = instrumentsOLD
            EnableForInstruments
        ' ----------------------------------------------------------------
        Case Else
            EnableForArchive
            
    End Select

End Sub
    ' ----------------------------------------------------------------
    ' ����: 25.02.2023 13:27
    ' ����������:
    ' ----------------------------------------------------------------
    Private Sub EnableForOrganisations()

        Dim itemKey As String
        itemKey = sArrDataBase(LBound(sArrDataBase) + 2, CInt(itemIndex)) '�������� ����� ��� �����������
        
        If DataBase.IsDirAvailable(itemKey) Then

            Me.btnOpenFolder.Enabled = True
            Me.btnOpenFolder.BackColor = Colors.oragnePastel
            
        End If

        If sArrDataBase(0, itemIndex) <> "nodata" Then '������������ �������
        
            Me.cmb1.Enabled = True '�������� �� ����
            Me.cmb1.BackColor = Colors.greenPastel
            
            Me.cmb2.Enabled = True '������������
            
        End If
        
        If sArrDataBase(1, itemIndex) <> "nodata" Then _
            Me.cmb3.Enabled = True '���
        
        If sArrDataBase(3, itemIndex) <> "nodata" Then _
            Me.cmb4.Enabled = True '�����
    
    End Sub
    ' ----------------------------------------------------------------
    ' ����: 25.02.2023 13:36
    ' ����������:
    ' ----------------------------------------------------------------
    Private Sub EnableForInstruments()

        If sArrDataBase(0, itemIndex) <> "nodata" Then _
            Me.cmb1.Enabled = True '������������ ��
        
        If sArrDataBase(1, itemIndex) <> "nodata" Then _
            Me.cmb2.Enabled = True '��� ��
            
        If sArrDataBase(2, itemIndex) <> "nodata" Then _
            Me.cmb3.Enabled = True '���. ����� ���
        
        If sArrDataBase(3, itemIndex) <> "nodata" Then _
            Me.cmb4.Enabled = True '�������� �������
        ' ----------------------------------------------------------------
        Dim keySearch As String '���� ������ � ��� �����
        keySearch = sArrDataBase(LBound(sArrDataBase) + 2, CInt(itemIndex))
        
        Dim targetDir As String
        targetDir = ItemDirectory(keySearch) '\instruments\Canberra_18509-04
          
        If targetDir <> vbNullString Then
            
            Me.btnOpenFolder.Enabled = True

            
            EnableDescriptionButton targetDir
            EnableMethodicButton targetDir
            EnableLoadTemplateButton
               
        End If
    End Sub
        ' ----------------------------------------------------------------
        ' ����: 25.02.2023 14:54
        ' ����������:
        '    �������� itemKey:
        ' ������������ ���: String
        ' ----------------------------------------------------------------
        Private Function ItemDirectory( _
            itemKey As String _
            ) As String
            
            
'            Dim itemPath As String
'            itemPath = Config.instrumentsPath
'            ' ----------------------------------------------------------------
'            If Right(itemPath, 1) <> Application.PathSeparator Then _
'                itemPath = itemPath & Application.PathSeparator
'            ' ----------------------------------------------------------------
'            Dim result As String
'            result = Dir(itemPath & "*" & itemKey & "*", vbDirectory) '\instruments\Canberra_18509-04
            
            Dim itemPath As String
            itemPath = fso.BuildPath(Config.instrumentsPath, "*" & itemKey & "*")
            
            Dim result As String
            result = Dir(itemPath, vbDirectory) '\instruments\Canberra_18509-04
            
            ItemDirectory = result

            
        End Function
        Private Sub EnableDescriptionButton( _
            targetDir As String _
            )
            
            Dim targetPath As String
            targetPath = fso.BuildPath(Config.instrumentsPath, targetDir)
        
            Dim targetTypeDesc As String
            targetTypeDesc = Dir(targetPath & "\" & "*" & "ot_" & "*") '\instruments\Canberra_18509-04\mp_xxxxx
            
            If targetTypeDesc <> vbNullString Then
               
               Me.cmbDescription.Enabled = True
               Me.cmbDescription.BackColor = Colors.greenPastel
               
            End If
        End Sub
        Private Sub EnableMethodicButton( _
            targetDir As String _
            )
            
            Dim targetPath As String
            targetPath = fso.BuildPath(Config.instrumentsPath, targetDir)
            
            Dim targetMp As String
            targetMp = Dir(targetPath & "\" & "*" & "mp_" & "*") '\instruments\Canberra_18509-04\mp_xxxxx
            
            If targetMp <> vbNullString Then
                
                Me.cmbMetodic.Enabled = True
                Me.cmbMetodic.BackColor = Colors.greenPastel
                
            End If
               
        End Sub
        Private Sub EnableLoadTemplateButton( _
            )
            
            Dim itemKey As String '���� ������ � ��� �����
            itemKey = sArrDataBase(LBound(sArrDataBase) + 2, CInt(itemIndex))
            
            Dim itemReferenceKey As String '����������� ������
            itemReferenceKey = sArrDataBase(LBound(sArrDataBase) + 4, CInt(itemIndex))
            ' ----------------------------------------------------------------
            Dim targetKey As String
            targetKey = itemKey
            
            If itemReferenceKey <> "nodata" Then _
                targetKey = itemReferenceKey
            ' ----------------------------------------------------------------
            Dim targetDir As String
            targetDir = ItemDirectory(targetKey) '\instruments\Canberra_18509-04
            ' ----------------------------------------------------------------
            Dim targetPath As String
            targetPath = fso.BuildPath(Config.instrumentsPath, targetDir)
            ' ----------------------------------------------------------------
            Dim targetTemplate As String
            targetTemplate = Dir(targetPath & Application.PathSeparator & "*" & "body_" & "*") '\instruments\Canberra_18509-04\mp_xxxxx
            
            If targetTemplate = vbNullString Then _
                targetTemplate = Dir(targetPath & Application.PathSeparator & "*" & "pr_" & "*")  '\instruments\Canberra_18509-04\mp_xxxxx
            ' ----------------------------------------------------------------
            If targetTemplate = vbNullString Then _
                Exit Sub
            ' ----------------------------------------------------------------
            Me.cmbProtSv.Enabled = True
            Me.cmbProtSv.BackColor = Colors.oragnePastel
            
        End Sub
    ' ----------------------------------------------------------------
    ' ����: 25.02.2023 13:38
    ' ����������:
    ' ----------------------------------------------------------------
    Private Sub EnableForArchive()
           
        Dim j As Byte
        For j = LBound(sArrDataBase) To UBound(sArrDataBase) '������ �� ���� ����� �������
        
            If sArrDataBase(j, itemIndex) <> "nodata" Then
            
                If j < 4 Then _
                    Me.Controls("cmb" & j + 1).Enabled = True

            End If
        Next j
        
        
    End Sub
    
    

'        sFifNum = sArrData(LBound(sArrData) + 2, i)
'        referenceRegFifNum = sArrData(LBound(sArrData) + 4, i) '����������� ������
'
'        sTempDir = Dir(sStartDir & "*" & sFifNum & "*", vbDirectory) '������� ��
'        sRefDir = Dir(sStartDir & "*" & referenceRegFifNum & "*", vbDirectory) '������� ����������� ������
'
'        If sTempDir <> vbNullString Then '������� � ������� � ��� ���������
'
'            If Dir(sTempPath & "\pr" & "*" & sFifNum & "*.xls*") <> vbNullString Or _
'                    Dir(sTempPath & "\body" & "*" & sFifNum & "*.xls*") <> vbNullString Then bolTMP = True '������� ��������
'
'            If Dir(sRefPath & "\pr" & "*" & referenceRegFifNum & "*.xls*") <> vbNullString Or _
'                    Dir(sRefPath & "\body" & "*" & referenceRegFifNum & "*.xls*") <> vbNullString Then bolRef = True '������� ������������ �������
'
'            If bolRef Then '�������� ������� ����������� ������ - ��������� ��������
'                If sTempStr <> vbNullString Then sTempStr = sTempStr & "+"
'                sTempStr = sTempStr & "��*"
'            Else
'                If bolTMP Then '�������� ������� �������
'                    If sTempStr <> vbNullString Then sTempStr = sTempStr & "+"
'                    sTempStr = sTempStr & "��"
'                End If
'            End If

'        End If
'    Next
'End Sub
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

'########�������#################################################
'��������� ��������� ��������� ����� �� ������
Sub TrueBtnFocus(ACtrlName As String)
    Dim iCtrlInd As Integer
    If ACtrlName Like "cmb*" And IsNumeric(Right(ACtrlName, 1)) Then '������ ��� ������
        iCtrlInd = Right(ACtrlName, 1) '����� ������
        Do
            iCtrlInd = iCtrlInd + 1 '��������� ������
            If iCtrlInd = 5 Then Me.cmbReady.SetFocus:  Exit Do
            If iCtrlInd < 5 Then Me.labelUnderSearchField.caption = "������� Enter": Call TrueElementForeColor(Me.labelUnderSearchField) 'Me.labelUnderSearchField.ForeColor = &H8000& ' - ������
            
            If Me.Controls("cmb" & iCtrlInd).Enabled = True Then
                If Me.Controls("cmb" & iCtrlInd).Visible = True Then
                    Me.Controls("cmb" & iCtrlInd).SetFocus
                    Exit Do
                End If
            End If
        Loop
        
    Else '���� �������� ������� - �� ������, �� ������� ������ ������
        TrueBtnFocus "cmb1"
    End If
End Sub
'#########################################################
'������������ �����������+��� / ������������ �� / ������������ ������� / ������� ����������
Private Sub cmb1_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    If myWdDoc = False Then _
        InsertInstrumentName Shift: _
        Exit Sub
        
    cmbOneClick
End Sub
Private Sub cmb1_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If myWdDoc = False Then InsertInstrumentName Shift: Exit Sub
    cmbOneClick
End Sub
'#########################################################
'��������� ������������ ���� � ����� ������ �� ��������� ���������
Sub InsertInstrumentName( _
    ByVal Shift As Integer _
    )
    
    If Shift = 2 Then
        
        If UMenu.typ� <> instrumentsOLD Or myWdDoc Then _
            cmbOneClick: _
            Exit Sub
            
        If MsgBox("����� ��������� ����� � ������ ���������� ������������. ����������?", vbYesNo) = vbNo Then _
            Me.cmb1.caption = "�": _
            Exit Sub
        
        ChangeXlPropertyComment myMi '�������� ��� ��
        'SetBuiltInProperty "Comments", sArrDataBase(1, CInt(itemIndex)) '��� ��
        SetBuiltInProperty "Keywords", sArrDataBase(2, CInt(itemIndex)) '����� � ���
        
        FillNameInstrument myMi
        Commit_factory_number '�������� ��������� ����� � ���� ��
        ActiveWorkbook.Save
        
        VBA.Unload Me
        Exit Sub
    End If
    
    cmbOneClick
End Sub
Private Sub cmbOneClick()
    Select Case UMenu.typ�
        Case organisationsOLD '������������ ����������� ��������� + ��� ��������
            
            Application.ScreenUpdating = False
            
            Dim customerCell As Range
            If FindCellRight("��������:", customerCell, ThisCell:=True) Then
                
                customerCell.Offset(0, 1) = sArrDataBase(0, CInt(itemIndex)) ' ������������
                
                If InStr(customerCell.Offset(1, 0), "���") > 0 Then _
                    customerCell.Offset(1, 1) = sArrDataBase(1, CInt(itemIndex)) ' ���
                
                If sArrDataBase(3, CInt(itemIndex)) <> "nodata" Then
                
                    If InStr(customerCell.Offset(1, 0), "�����") > 0 Then customerCell.Offset(1, 1) = sArrDataBase(3, CInt(itemIndex)) '�����
                    If InStr(customerCell.Offset(1, 2), "�����") > 0 Then customerCell.Offset(1, 3) = sArrDataBase(3, CInt(itemIndex)) '�����
                End If
                
                
                SetBuiltInProperty "Company", sArrDataBase(0, CInt(itemIndex))                 '�������� �������� ��������� � �������� �����
              '  SetBuiltInProperty "Category", sArrDataBase(0, CInt(itemIndex))                 '�������� �������� ��������� � �������� �����
              
               ' TransferManufacturer
                
                Application.ScreenUpdating = True
                VBA.Unload Me
            Else
                MsgBox "���� ��������� �� �������"
                Application.ScreenUpdating = True
                
                Exit Sub
            End If
            
            
        ' ------------------------------------------------------
        'todo: ��������� � db
        Case personsOLD '�������
            DataTransfer sArrDataBase(0, CInt(itemIndex)), True, WorkClsm.FullFirstName '������������ �� / ������� ����������
            TrueBtnFocus ActiveControl.name
        
        Case archiveOLD '����� �����
            Explorer.OpenFolder Config.archiveLocalPath & Application.PathSeparator & sArrDataBase(0, CInt(itemIndex)), True
            
        Case instrumentsOLD '�������� ���������
            DataTransfer sArrDataBase(0, CInt(itemIndex)) & " " & sArrDataBase(1, CInt(itemIndex)), True
            TrueBtnFocus ActiveControl.name
        Case Else
            DataTransfer sArrDataBase(0, CInt(itemIndex)), True  '������������ �� / ������� ����������
            TrueBtnFocus ActiveControl.name
    End Select
End Sub
'#########################################################
'������������ ����������� / ����������� �� / ?????��� �������
Private Sub cmb2_Click()

    Select Case UMenu.typ�
    
        Case organisationsOLD '�������� ����������
            DataTransfer sArrDataBase(0, CInt(itemIndex)), True, , True
            
        Case Else '�� / �������
            DataTransfer sArrDataBase(1, CInt(itemIndex)), , , False
        '    Z_UF_Search_Cmb2 sArrDataBase, CInt(itemIndex) '�������� ������ � ����� /����
    End Select
    
    Call TrueBtnFocus(ActiveControl.name)
End Sub
'#########################################################
'��� / ����� � ��� �� / ����� � ��� �������  /��������� ����������
Private Sub cmb3_Click()
    
    Select Case UMenu.typ�
        
        Case organisationsOLD

            Application.ScreenUpdating = False
            
                ActiveCell = sArrDataBase(1, CInt(itemIndex)) ' ���
                ActiveCell.numberFormat = "0"
                
            Application.ScreenUpdating = True
            
        Case personsOLD
            DataTransfer sArrDataBase(1, CInt(itemIndex)), True, True
            
        Case archiveOLD
        ' ------------------------------------------------------
        'todo: ��������� � db & config
            If Me.chbFullName Then ProtectSheets
            TrueMkDir myBase, WorkClsm, sArrDataBase '������� ������� � ������
            
        Case Else
        
            Dim sTempStr As String
            sTempStr = sArrDataBase(2, itemIndex)
            If myWdDoc And InStr(sTempStr, "ZZB") > 0 Then sTempStr = "���. � " & sTempStr
            
            DataTransfer sTempStr, True
    End Select
    
    If UMenu.typ� <> archiveOLD Then _
        TrueBtnFocus ActiveControl.name
End Sub
    Private Sub ProtectSheets()
        
        Application.DisplayAlerts = False
        Application.ScreenUpdating = False
        
        Dim ws As Worksheet
        For Each ws In ActiveWorkbook.Worksheets
            
            Dim arrSearch(), i As Byte, rSearchCell As Range
            '###################################################################
            arrSearch = Array("����(", _
                                "������(", _
                                "�������(", _
                                "����������(", _
                                "�������(", _
                                "������(", _
                                "����������(") '������ ��� ������ ��������
            '###################################################################
            For i = LBound(arrSearch) To UBound(arrSearch) '��� ���� ��������� ��������
                
                Set rSearchCell = ws.Cells.Find(arrSearch(i))
                Do While Not rSearchCell Is Nothing
                    rSearchCell.value = rSearchCell.value
                    Set rSearchCell = ws.Cells.Find(arrSearch(i))
                Loop
            Next i
            
    '        ws.[l:s].EntireColumn.Hidden = True
            ws.EnableSelection = xlNoSelection
            
            Dim password As String
            password = NewPassword

            ws.Protect password, _
                UserInterfaceOnly:=True

            Debug.Print "Sheet �" & ws.name & "� protected, password = " & password
        Next
        
        Dim protectedDirectoryPath As String
        protectedDirectoryPath = ActiveWorkbook.path & "\somnium\"
        
        If Dir(protectedDirectoryPath, vbDirectory) = vbNullString Then _
            MkDir protectedDirectoryPath
            
        ActiveWorkbook.SaveAs protectedDirectoryPath & _
            GetFileNameWithOutExt(ActiveWorkbook.name) & "." & GetExt(ActiveWorkbook.name)
            
        Application.DisplayAlerts = True
        Application.ScreenUpdating = True
    End Sub
    Private Function NewPassword() As String
        
        Dim i As Byte, _
            index_second As Integer, _
            pass As String
            
        Do While Len(pass) < 10
        
            Randomize
            index_second = CInt(Rnd * UBound(sArrKeyCode, 2) - 1)
            If index_second = -1 Then index_second = 0
            
            pass = pass + sArrKeyCode(1, index_second)
            If Len(pass) < 10 And index_second < UBound(sArrKeyCode, 2) / 2 Then _
                pass = pass & Left(index_second, 1)
            
            i = i + 1
        Loop
        
        NewPassword = pass
    End Function

'#########################################################
'����� ����������� / �������� ������� �� / ���. �������� �������
Private Sub cmb4_Click()

    If UMenu.typ� <> personsOLD Then
        DataTransfer sArrDataBase(3, CInt(itemIndex)), True
    Else
        DataTransfer "����������", True, True
    End If
    
    TrueBtnFocus ActiveControl.name
End Sub
'#########################################################
Private Sub cmbReady_Click() '������
    VBA.Unload Me
End Sub
Private Sub cmbReady_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)

    If Shift = 1 Or Shift = 2 Then '����� ctrl ��� shift
    
        If UMenu.typ� = organisationsOLD Then
            

            DataBase.Refactor _
                oldDataBaseArray:=sArrDataBase
                
        ElseIf UMenu.typ� = instrumentsOLD Then
        
            DataBase.Refactor _
                oldDataBaseArray:=sArrDataBase
                
        ElseIf UMenu.typ� = personsOLD Then
        
            DataBase.Refactor _
                oldDataBaseArray:=sArrDataBase
            
        End If
        
        VBA.Unload Me
        
    End If

End Sub
'#########################################################
'��������� ��������� ������� � ������� ���������� ������ ��������
Private Sub btnOpenFolder_Click()

    If UMenu.typ� = archiveOLD Then _
        Explorer.OpenFolder Config.archiveLocalPath, True: _
        Exit Sub
        
    If UMenu.typ� = organisationsOLD Then

        
        Dim itemKey As String
        itemKey = sArrDataBase(LBound(sArrDataBase) + 2, CInt(itemIndex))
        
        If DataBase.IsDirAvailable(itemKey) Then _
            DataBase.TargetItemKey = itemKey
            DataBase.OpenItemDir
        
        VBA.Unload Me
        Exit Sub
        
    End If
    
    Dim sTempDir As String, _
        templatesDir As String, _
        fifRegNum As String, _
        sTypeName As String
        
    templatesDir = Config.instrumentsPath & "\"
    fifRegNum = sArrDataBase(2, itemIndex)
        
    Dim currTemplateDir As String
    currTemplateDir = Dir(templatesDir & "*" & fifRegNum & "*", vbDirectory)   '������� ���������� ��
    
    Dim targetPath As String
    targetPath = fso.BuildPath(templatesDir, currTemplateDir)
    
    Dim refFifPath As String
    refFifPath = templatesDir & currTemplateDir & Application.PathSeparator & REFERENCE_FIFNUM_FILENAME
    
    Dim refRegNumber As String
    
    If FileExist(refFifPath) Then
        
        refRegNumber = Base.ContentFromFile(refFifPath): _
        refRegNumber = Replace(refRegNumber, vbNewLine, vbNullString)
    
        If refRegNumber <> fifRegNum Then
                
            Dim newTargetDir As String
            newTargetDir = Dir(templatesDir & "*" & refRegNumber & "*", vbDirectory)  '������� ��
            
            targetPath = fso.BuildPath(templatesDir, newTargetDir)
            
        End If
        
    End If
    
    Explorer.OpenFolder targetPath, True
    VBA.Unload Me
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 13:31
' ����������:
' ----------------------------------------------------------------
Private Sub DisableButtons()
    
    Me.cmb1.Enabled = False
    Me.cmb1.BackColor = Colors.white
    
    Me.cmb2.Enabled = False
    Me.cmb4.Enabled = False
    
    Me.cmbProtSv.Enabled = False
    Me.cmbProtSv.BackColor = Colors.white
    
    Me.cmbDescription.Enabled = False
    Me.cmbDescription.BackColor = Colors.white
    
    Me.cmbMetodic.Enabled = False
    Me.cmbMetodic.BackColor = Colors.white
    
    If UMenu.typ� <> archiveOLD Then
        
        Me.btnOpenFolder.Enabled = False
        Me.btnOpenFolder.BackColor = Colors.white
        

        
    End If
'
'    If UMenu.typ� = instrumentsOLD And myWdDoc = False Then _
'        Me.cmbProtSv.Caption = "������" & vbNewLine & "���������"
    
    If UMenu.typ� <> personsOLD Then
    
        If UMenu.typ� <> archiveOLD Then _
            Me.cmb3.Enabled = False
            
        If myWdDoc = False And UMenu.typ� = etalonsOLD Then _
            Me.cmbProtSv.Enabled = True
        
    End If
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 15:05
' ����������: �������� �������
' ----------------------------------------------------------------
Private Sub cmbProtSv_Click()
        
    Dim bolStopUnload As Boolean
    
    If UMenu.typ� = instrumentsOLD Then '�������� ���������
    
        If myWdDoc Then
            cmbOneClick
            
        Else '������ ��� xl
            If myMi.sName = vbNullString Then _
                GetDBindAndMyMi listResults.text
            ' ------------------------------------------------------
            'todo: ��������� � db, config
            If SaveAsTemplate(WorkClsm, myMi) = False Then _
                bolStopUnload = True
        End If
        
    ElseIf UMenu.typ� = etalonsOLD Then '�������
    
        If myWdDoc Then
            cmb3_Click
            cmb4_Click
        Else
            PasteEtalons sArrDataBase
        End If
    End If
    
    If bolStopUnload = False Then _
        VBA.Unload Me
End Sub
'#########################################################
'��������� ��������� �������� ����
Private Sub cmbDescription_Click()

    OpenPDF Config.sourceDataPath, myMi.sFif, "ot"
    VBA.Unload Me
    
End Sub
'#########################################################
'��������� ��������� �������� �������
Private Sub cmbMetodic_Click()

    OpenPDF Config.sourceDataPath, myMi.sFif, "mp"
    VBA.Unload Me
    
End Sub

'#########################################################
'��������� ������������ �� ������
Private Sub GetMyConfigFromFile(ByRef myBase As Z_clsmBase, ByRef WorkClsm As Z_clsmSearch)
    
    With myBase '������ � ������� ��������
        .AddP "startDir", "workDir"
        .AddP "depPrefix", "labNum"
        .AddP "templatesDir"
        
        Select Case True '�������� �������� ��������� �����
        
            Case UMenu.typ� = organisationsOLD
                .AddP "cusDB" '���������
                
            Case UMenu.typ� = instrumentsOLD
                .AddP "measInstrDB" '�������� ���������
                
            Case UMenu.typ� = etalonsOLD
                .AddP "etalDB" '�������
                
            Case UMenu.typ� = personsOLD
                .AddP "empDB", "isFullName" '�������
                
            Case UMenu.typ� = archiveOLD
                .AddP "cusDB", "useArchiveDir", "ArchivePath" '����� ���
                
        End Select
        
        .GetArrFF setDir, Environ("USERNAME") & ".uCfg" '��������� � ����� ������������
        .FillValues '�����������: ����� �������� �������� ���������� �� ������

        WorkClsm.FillConfiguration .Parameters, .values '�������� ������������ � �����
        .ClearParameters
        
        .AddP "constrSrch"
        Select Case True '�������� �������� ��������� �����
            
            Case UMenu.typ� = organisationsOLD
                .AddP "custSearch", "custIndex"  '���������
                
            Case UMenu.typ� = instrumentsOLD
                .AddP "instrSearch", "instrIndex", "normalCondition" '�������� ���������
                
            Case UMenu.typ� = etalonsOLD
                .AddP "etalSearch", "etalIndex" '�������
                
            Case UMenu.typ� = personsOLD
                .AddP "empSearch", "empIndex": AddInvertParameter myBase '�������
                
            Case UMenu.typ� = archiveOLD
                .AddP "archveSearch", "archiveIndex" '����� ���
        End Select
        
        .GetArrFF setDir, "settings.ini" '��������� � ����� ������������
        .FillValues '�����������: ����� �������� �������� ���������� �� ������
        
        WorkClsm.FillSettings .Parameters, .values '�������� ������������ � �����
    End With
End Sub
'#########################################################
'��������� ��������� ������ ��������
Private Sub FillArrKeycodeFromFile()
    
    Const fileName As String = "keycode.npDb"
     
    Dim charTablePath As String
    charTablePath = fso.BuildPath(Config.sourceDataPath, fileName)
    
    If fso.FileExists(charTablePath) Then '���� �������� ������� � �������� ���������� ����� ��������
        
        sArrKeyCode = WorkClsm.FillDataBase( _
            myBase.GetArrFF(charTablePath))  '�������� ������ ��������(���� ���� ���������)

    Else '���� ���� �� ��� ��������� � ��������
        ReDim sArrKeyCode(0, 1)
    End If
    
End Sub
'#########################################################
'��������� ��������� ������ ���� ������
Private Sub FillArrDataBaseFromFile( _
    ByRef sArrDataName() As String, _
    sDbName As String _
    )
    ' ------------------------------------------------------
    'todo: ��������� � db -- �������� ���� ������ �� �����

    If FileExist(WorkClsm.startDir, sDbName) Then '���� ���� ������ ���������� �� ���������� ����
        sArrDataName = WorkClsm.FillDataBase(myBase.GetArrFF(WorkClsm.startDir, sDbName), True)  '������������� ������ ����� � ������ ���� ������
        
        If UMenu.typ� <> archiveOLD Then _
            Me.LabelInfo.caption = "���� ������ �" & sDbName & "�, " & RusPadejPozition(UBound(sArrDataBase, 2) + 1)
        
    Else '���� �� �� ��� ��������
        ReDim sArrDataName(0)
        With Me.LabelInfo: .caption = "���� ������ �� ��������.": .foreColor = &H80&: End With '������� ����
    End If
    
End Sub
'#########################################################
'��������� ������������� ��������� ��������� ������ �������� � ���������� � ��������� �������
Private Sub UpdateTboxAndListbox()
    
    If sArrDataBase(LBound(sArrDataBase), UBound(sArrDataBase, 2)) <> vbNullString Then '���� ������ ����� ��� �������
    
        If UMenu.typ� = etalonsOLD And myWdDoc = False Then _
            Me.cmbProtSv.Enabled = True
            
  
' ------------------------------------------------------
'todo: ��������� � Cache
        If WorkClsm.LastSearch <> "����������" Then _
            Me.tboxSearch = WorkClsm.LastSearch: '��������� ��������� ������
' ------------------------------------------------------
'todo: ��������� � Cache
        If WorkClsm.LastIndex <> "����������" Then '��������� ������ ������� ��������� ��������
            If Me.listResults.ListCount = 0 Then UpdateListResults sArrDataBase
            

        ' ------------------------------------------------------
'todo: ��������� � Cache
            
            If WorkClsm.LastIndex >= 0 Then
            
                Dim bolSelind As Boolean
                If WorkClsm.LastIndex < Me.listResults.ListCount - 1 Then _
                    bolSelind = True
                
                If bolSelind Then
                    
                    Me.listResults.Selected(CInt(WorkClsm.LastIndex)) = True '�������� ����� ��������� �������
                    TrueElementForeColor Me.labelUnderSearchField '�������� �����
                    Me.labelUnderSearchField.caption = "������� Enter" '�������������� �������
                    
                End If
                
            End If
        End If

      
    End If
End Sub

'#########################################################
'��������� ��������� ���������� ���������, ������ �� ��������������� ������� ������
Private Sub UpdateListResults(sArrDBase() As String, _
    Optional strException As String = "nodata") '�������� ���������� ���������1
    
    Dim i As Integer, sTempStr As String
    Me.listResults.Clear
    ' ------------------------------------------------------
    Dim lowerBound As Integer
    lowerBound = LBound(sArrDBase, 2)
    
    If UMenu.typ� = archiveOLD Then _
        lowerBound = UBound(sArrDBase, 2)
    ' ------------------------------------------------------
    Dim upperBound As Integer
    upperBound = UBound(sArrDBase, 2)
    
    If UMenu.typ� = archiveOLD Then _
        upperBound = LBound(sArrDBase, 2)
    ' ------------------------------------------------------
    Dim stepData As Integer
    stepData = 1
    
    If UMenu.typ� = archiveOLD Then _
        stepData = -1
    ' ------------------------------------------------------
    If sArrDataBase(LBound(sArrDataBase), UBound(sArrDataBase, 2)) <> vbNullString Then '������ ��� �������
        
        For i = lowerBound To upperBound Step stepData '��� ������� �����
            sTempStr = vbNullString '�������� ����������
            
            Select Case UMenu.typ�
                ' ------------------------------------------------------
                Case instrumentsOLD
                    sTempStr = GetTempStrBy2(sArrDBase, i, strException)  '�������� ���������
                ' ------------------------------------------------------
                Case Else
                
                    If UMenu.typ� = etalonsOLD And sArrDBase(LBound(sArrDBase), i) <> "" Then _
                        sTempStr = sTempStr & sArrDBase(UBound(sArrDBase), i) & " \\ " '�������� �����
                    
                    If UMenu.typ� <> archiveOLD Then _
                        sTempStr = sTempStr & GetTempStrByOther(sArrDBase, i, strException) '������ ��
                    
                    If UMenu.typ� = archiveOLD Then _
                        sTempStr = sArrDBase(0, i)
                        
            End Select
            
            If sTempStr <> "" Then _
                Me.listResults.AddItem sTempStr

        Next i
        
        'If myMen u.type = 14 And sArrDBase(LBound(sArrDBase), UBound(sArrDBase, 2)) = "" Then Me.listResults.AddItem " "
    End If
    
    If UMenu.typ� <> archiveOLD Then
    
        Me.listResults.AddItem "������ ��������� � ���� ������..."
        ' ------------------------------------------------------
        'todo: ��������� � db cache
        If UMenu.isLoaded = True Then _
            WorkClsm.LastIndex = "����������"  '������� ���������� ���������� ���������� ������� ����� ���������� ������
            
    End If
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 12:54
' ����������: ������� ������� ������ ��� ���������� � ������ ����������� ��� ����� ������� ���������
'    �������� sArrDBase:
'    �������� i:
'    �������� strException:
' ������������ ���: String
' ----------------------------------------------------------------
Function GetTempStrBy2( _
    sArrDBase() As String, _
    i As Integer, _
    strException As String _
    ) As String
    
    Dim sTempStr As String
    
    If sArrDBase(LBound(sArrDBase), i) <> vbNullString Then '����� �� ���� ������ ������ � �������
        
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 2, i) & " \\ " '����� � ���
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 1, i) & " \\ "
        
'        If sArrDBase(UBound(sArrDBase) - 1, i) <> "nodata" Then _
'            sTempStr = sTempStr & " \\ " & sTempStr & sArrDBase(UBound(sArrDBase) - 1, i) & " \\ " '�� �������� ��������
        
        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase), i) & " \\ " '������ ������������
        
'        If sArrDBase(UBound(sArrDBase), i) <> "nodata" Then _
'            sTempStr = sTempStr & sArrDBase(UBound(sArrDBase), i) & " \\ " '������� ������� ��� ������� ��
        
'        If sArrDBase(LBound(sArrDBase) + 1, i) <> strException And sArrDBase(LBound(sArrDBase) + 1, i) <> vbNullString Then _
'            sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 1, i) & " \\ " '��� ��
            

'        sTempStr = sTempStr & sArrDBase(LBound(sArrDBase) + 3, i) '�������� �������
               

            
    End If
    
    GetTempStrBy2 = sTempStr
    
End Function
'#########################################################
'������� ������� ������ ��� ���������� � ������ ����������� ��� ����, ����� ������� ���������
Function GetTempStrByOther(sArrDBase() As String, i As Integer, strException As String) As String
    Dim sTempStr As String, j As Byte, sArrTemp() As String

    For j = LBound(sArrDBase) To UBound(sArrDBase) '�������� �������� �� ��������
        
        If UMenu.typ� = etalonsOLD And j = UBound(sArrDBase) Then Exit For
        If UMenu.typ� = organisationsOLD And j = 2 Then   '�� ������� "�������� �����" ����������� ��������� � ���������� ������
        
        ElseIf UMenu.typ� = personsOLD And j = LBound(sArrDBase) Then '�������� ���
        
            If sArrDBase(j, i) <> strException And sArrDBase(j, i) <> "" Then
                If Me.chbFullName = False Then
                    sArrTemp = Split(sArrDBase(j, i), " "): sTempStr = sArrTemp(0) & " " '������� ������ �� ��������
                    
                    Dim K As Byte
                    For K = LBound(sArrTemp) + 1 To UBound(sArrTemp)
                        sTempStr = sTempStr & Left(sArrTemp(K), 1) & "."
                    Next
                Else
                    sTempStr = sArrDBase(j, i) '���������� ��� ���������� � ��������
                End If
            End If

        Else
            If j > LBound(sArrDBase) And sArrDBase(j, i) <> strException And sArrDBase(j, i) <> "" Then
                sTempStr = sTempStr & " \\ " '�����������
                If UMenu.typ� = organisationsOLD And j = 1 Then sTempStr = sTempStr & "��� "
            End If
            If sArrDBase(j, i) <> strException And sArrDBase(j, i) <> "" Then _
                sTempStr = sTempStr & sArrDBase(j, i) '���������� ��� ���������� � ��������
        End If
    Next j
    
    GetTempStrByOther = sTempStr
End Function

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
