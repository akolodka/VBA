VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Z_UF_Settings 
   Caption         =   "��������� ������ � ����������� ������"
   ClientHeight    =   7275
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   5760
   OleObjectBlob   =   "Z_UF_Settings.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Z_UF_Settings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit '������ �� ������������� ������� ����������

Const bolFullFirstNames = True '������ ����� ������ ��� �����������

Private myBase As New Z_clsmBase, WorkClsm As New Z_clsmSettings, sArrDataBase() As String

Private Sub cmbChooseTemplatesDir_Click()
    Dim sMyPath As String, _
        sTempName As String
    
    sMyPath = GetFolderFPath(, , False) '������� �������� ������� ����������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\"
        WorkClsm.templatesDir = sMyPath '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub

Private Sub cmbOpenTemplatesDir_Click()
    Explorer.OpenFolder WorkClsm.templatesDir, True  '������� � �������� �����
End Sub

'#######################################################
'�������������� ���������
Private Sub cmbUninstall_Click()

    Dim sFileName As String
    sFileName = WorkClsm.startDir & "Installer\Uninstall.vbs": If FileExist(sFileName) Then Shell "explorer.exe " & sFileName
    VBA.Unload Me
End Sub
'#######################################################
'��������� ������� ��������
Private Sub MultiPage1_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    
    If KeyCode = vbKeyEscape Then _
        UMenu.Unload
        
End Sub
'#######################################################
'��������� �������� �����
Private Sub UserForm_Initialize()
    ReDim sArrDataBase(0)
    
    TransformConfigFile '��� �������� �� ������� ���������� � ������
    
    If FileExist(setDir, Environ("USERNAME") & ".uCfg") Then
        Me.cmbCfgExp.Enabled = True: Me.cmbCfgImp.BackColor = &HFFFFFF    '�����
    End If
    
    With myBase '������ � ������� ��������
        '#######################################################
        .GetArrFF setDir, Environ("USERNAME") & ".uCfg" '��������� � ����� ���� ��������� ������������
        '#######################################################

        .AddP "startDir", "cusDB", "measInstrDB" '������� ��������� - �����
        .AddP "etalDB", "empDB", "isFullName"
        
        .AddP "workDir", "depPrefix", "labNum"
        .AddP "headNAME", "verNAME", "isPortable"
        .AddP "empNAME", "empSTATE", "helpOption"
        .AddP "empSecNAME", "empSecSTATE", "templatesDir"
        
        .AddP "xlPrPath", "xlPrcPath"
        .AddP "wdSvPath", "wdSrtPath", "wdInPath"
        .AddP "useArchiveDir", "ArchivePath"
        
        .FillValues '�����������: ����� �������� �������� ���������� �� ������
    End With
              
    WorkClsm.FillProperties myBase.Parameters, myBase.values '�������� ����������� �� �������� ��������� � ����������� �����
    UpdateDBLabels  '�������� ����� ��������� ������ �������� ����������� ������
    
'    With WorkClsm
'        If .empState = "����������" Then _
'            Me.cmbxEmployee = "<�������>": PreSaveSettings '��� �������� �������������
'
'        If .headSTATE = "����������" Then _
'            Me.cmbxHead = "<�������>": PreSaveSettings '��� �������� �������������
'    End With
    
  '  Me.VersionLabel.Caption = "v " & GetCDProp("Version") & " �� " & _
        Format(GetCDProp("VersionDate"), "[$-FC19]dd mmmm yyyy �.") & vbNewLine & "kolaa@vniim.ru; �/� 21-09"
        
    Me.VersionLabel.caption = Addin.VersionCaption
    
    SetEventControls Me
    
    WorkClsm.isFullName = bolFullFirstNames '����� ������ �����
    bolAlreadySaved = True: bolUF_Set_Load = True
End Sub
    Private Function VersionCaption( _
        ) As String
        
        Dim strData As String
        strData = "������ " & Properties.Version & vbNewLine & _
            Format(Properties.Comments, "dd mmmm yyyy �.")
        
        VersionCaption = strData
        
    End Function
    
    Private Sub TransformConfigFile( _
        )
        
        Dim oldConfigName As String
        oldConfigName = "localConfig.uCfg"
        
        Dim newConfigName As String
        newConfigName = Environ("USERNAME") & ".uCfg"
        
        Dim configDir As String
        configDir = Environ("APPDATA") & "\Microsoft\�������� ���\"
            
        If Dir(configDir & newConfigName) <> vbNullString Then _
            Exit Sub
        
        If Dir(configDir & oldConfigName) <> vbNullString Then
        
            FileCopy configDir & oldConfigName, _
                     configDir & newConfigName
        End If
        
    End Sub

'#######################################################
'�������� ����� �� ������
Private Sub UserForm_Terminate()
    Set myBase = Nothing: Set WorkClsm = Nothing '�����������: ������� ��������
    bolUF_Set_Load = False: bolAlreadySaved = False
End Sub
'#######################################################
'��������� ��������� ������ ������ �� ������������
Sub UpdateEmployees(bolFormIsLoad As Boolean)
    Dim i As Byte, sEmpName As String, sHeadName As String, sVerName As String, sempSecName As String, _
        sArrTemp() As String, sTempStr As String, sTempFull As String
    
    With WorkClsm
        If FileExist(.startDir, .empDB) Then '���� ���� ������ ������� ���������� �� ���������� ����
            If UBound(sArrDataBase) = 0 Then sArrDataBase = .FillDataBase(myBase.GetArrFF(.startDir, .empDB), True)  '������������� ������ ����� � ������ ���� ������
            If UBound(sArrDataBase) > 0 Then '���� ������ ����� ��� �������
            
                Me.labelEmployee.Enabled = True: Me.labelHead.Enabled = True
                Me.labelVerifier.Enabled = True: Me.labelEmpSecond.Enabled = True
                
                Me.cmbxHead.Enabled = True: Me.cmbxEmployee.Enabled = True
                Me.cmbxVerifier.Enabled = True: Me.cmbxEmpSecond.Enabled = True
                
                If bolFormIsLoad Then Exit Sub
                
                Me.cmbxHead.Clear: Me.cmbxVerifier.Clear:  Me.cmbxEmpSecond.Clear: Me.cmbxEmployee.Clear
                Me.cmbxHead.AddItem "<�������>": Me.cmbxVerifier.AddItem "<�������>"
                Me.cmbxEmpSecond.AddItem "<�������>": Me.cmbxEmployee.AddItem "<�������>"
                
                sHeadName = .headNAME: sVerName = .verNAME: sempSecName = .empSecName: sEmpName = .empName '�������� ������ �� ������
                
                If sHeadName = "" Then .headNAME = "����������": sHeadName = "����������"
                If sVerName = "" Then .verNAME = "����������": sVerName = "����������"
                If sempSecName = "" Then .empSecName = "����������": sempSecName = "����������"
                If sEmpName = "" Then .empName = "����������": sEmpName = "����������"

                If InStr(sHeadName, " ") > 0 Then sHeadName = Left(sHeadName, InStr(sHeadName, " ")) '�������� ������ �������
                If InStr(sVerName, " ") > 0 Then sVerName = Left(sVerName, InStr(sVerName, " "))
                If InStr(sempSecName, " ") > 0 Then sempSecName = Left(sempSecName, InStr(sempSecName, " "))
                If InStr(sEmpName, " ") > 0 Then sEmpName = Left(sEmpName, InStr(sEmpName, " "))
                
                For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2) '�������� � ���������� �������� � �����������
 
                    sArrTemp = Split(sArrDataBase(0, i), " "): sTempStr = sArrTemp(0) & " " '������� ������ �� ��������
                    
                    Dim K As Byte
                    For K = LBound(sArrTemp) + 1 To UBound(sArrTemp)
                        sTempStr = sTempStr & Left(sArrTemp(K), 1) & "." '�������� ����� ��� �����������
                    Next
                        
                    sTempFull = sArrDataBase(0, i) '������ ����� ������ �����
                    If bolFullFirstNames = False Then sTempFull = sTempStr  '���� �� ������� ����� ������ ����� ������ �����
                    
                    If InStr(sArrDataBase(1, i), "��������") > 0 Then
                        Me.cmbxHead.AddItem sTempFull
                        
                        If InStr(Me.cmbxHead.List(Me.cmbxHead.ListCount - 1), sHeadName) > 0 Then _
                            Me.cmbxHead = Me.cmbxHead.List(Me.cmbxHead.ListCount - 1)
                            
                    End If
                        
                    If InStr(sArrDataBase(2, i), "����������") > 0 Then
                        Me.cmbxVerifier.AddItem sTempFull
                        If InStr(Me.cmbxVerifier.List(Me.cmbxVerifier.ListCount - 1), sVerName) > 0 Then _
                            Me.cmbxVerifier = Me.cmbxVerifier.List(Me.cmbxVerifier.ListCount - 1)
                    End If
                        
                    Me.cmbxEmployee.AddItem sTempStr
                    If InStr(Me.cmbxEmployee.List(Me.cmbxEmployee.ListCount - 1), sEmpName) > 0 _
                        Then Me.cmbxEmployee = Me.cmbxEmployee.List(Me.cmbxEmployee.ListCount - 1)
                        
                    Me.cmbxEmpSecond.AddItem sTempStr
                    If InStr(Me.cmbxEmpSecond.List(Me.cmbxEmpSecond.ListCount - 1), sempSecName) > 0 Then _
                        Me.cmbxEmpSecond = Me.cmbxEmpSecond.List(Me.cmbxEmpSecond.ListCount - 1)
                Next i
                
                With Me.cmbxHead
                   If .text = "����������" Or .text = "" Then .text = "<�������>"
                End With
                
                With Me.cmbxVerifier
                   If .text = "����������" Or .text = "" Then .text = "<�������>"
                End With
                
                With Me.cmbxEmpSecond
                   If .text = "����������" Or .text = "" Then .text = "<�������>"
                End With
                
                With Me.cmbxEmployee
                   If .text = "����������" Or .text = "" Then .text = "<�������>"
                End With
                
                Exit Sub
            End If
        End If
        .empName = "����������": .headNAME = "����������": .verNAME = "����������": .empSecName = "����������"
    End With
End Sub
'#######################################################
'��������� ���������� �������� ���� � ����������� ���� ���������, ������� ���������� ��� ��������
Sub AllControlsToZeroPos()
    bolUF_Set_Load = False
    
    Me.cmbOpenFolder.Enabled = False '������� ��������� ����������
    Me.cmbChoseBaseDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    Me.cmbCreateCus1.Enabled = False: Me.cmbChoseCus2.Enabled = False
    Me.cmbCreateMi3.Enabled = False: Me.cmbChoseMi4.Enabled = False
    Me.cmbCreateEt5.Enabled = False: Me.cmbChoseEt6.Enabled = False
    Me.cmbCreateLn7.Enabled = False: Me.cmbChoseLn8.Enabled = False
    
    Me.labelEmployee.Enabled = False: Me.cmbxEmployee.Enabled = False
    Me.labelHead.Enabled = False: Me.cmbxHead.Enabled = False
    Me.labelVerifier.Enabled = False: Me.cmbxVerifier.Enabled = False
    Me.labelEmpSecond.Enabled = False: Me.cmbxEmpSecond.Enabled = False
    
    Me.chbUseArchiveDir = False
'    Me.chbHelp = False
  '  Me.chbPortable = False
    
    Me.cmbOpenPrDir.Enabled = False
    Me.cmbChoosePrDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    cmbOpenPrcDir.Enabled = False
    Me.cmbChoosePrcDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    cmbOpenSvDir.Enabled = False
    Me.cmbChooseSvDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    cmbOpenSrtDir.Enabled = False
    Me.cmbChooseSrtDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    cmbOpenInDir.Enabled = False
    Me.cmbChooseInDir.BackColor = &HC0FFFF    '������ ���� - ��������
    
    bolUF_Set_Load = True
End Sub
'#######################################################
'����������� ������� ����� �����������
Private Sub chbUseArchiveDir_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)

End Sub
Private Sub chbUseArchiveDir_Change()
    TrueElementForeColor Me.chbUseArchiveDir, Not Me.chbUseArchiveDir, 1: If bolUF_Set_Load = False Then Exit Sub
    
    WorkClsm.ArchivePath = "����������" '�������� �������� � ������� �����
    WorkClsm.useArchiveDir = False
    
    If Me.chbUseArchiveDir Then
    
        Dim sMyPath As String
        sMyPath = GetFolderFPath("����� ���������� ������") '������� ���� � ��������
        
        If sMyPath <> "NoPath" Then
            sMyPath = sMyPath & "\"
            
            WorkClsm.ArchivePath = sMyPath '�������� �������� � ������� �����
            WorkClsm.useArchiveDir = Me.chbUseArchiveDir
        End If
        If sMyPath = "NoPath" Then Me.chbUseArchiveDir = False
    End If
    
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
'#######################################################
'��������� ��������� ���������� �� ������ ��������� ������
Sub UpdateDBLabels()
    
    If bolUF_Set_Load Then AllControlsToZeroPos '������� �������� ��������� � ������� ���������
    
    Dim sMyDir As String
    
    With WorkClsm
        sMyDir = .startDir '��������� ���������� ������, ��� �������� ���� ������
        If sMyDir <> "����������" Then  '���� ���������� ���� �������
        
            With Me.baseDirLabel
                PaintLabels Me.baseDirLabel.name, sMyDir
                
                If FolderNotExist(sMyDir) = False Then
                    Me.cmbOpenFolder.Enabled = True
                    Me.cmbChoseBaseDir.BackColor = &HFFFFFF 'white color
                
                    Me.cmbCreateCus1.Enabled = True: Me.cmbChoseCus2.Enabled = True
                    Me.cmbCreateMi3.Enabled = True: Me.cmbChoseMi4.Enabled = True
                    Me.cmbCreateEt5.Enabled = True: Me.cmbChoseEt6.Enabled = True
                    Me.cmbCreateLn7.Enabled = True: Me.cmbChoseLn8.Enabled = True
                End If
                
                PaintLabels Me.CusLabel.name, sMyDir, WorkClsm.cusDB
                PaintLabels Me.InstrLabel.name, sMyDir, WorkClsm.measInstrDB
                PaintLabels Me.EtalLabel.name, sMyDir, WorkClsm.etalDB
                PaintLabels Me.empLabel.name, sMyDir, WorkClsm.empDB
            End With
            
        End If
'������ �������� ��������
        
        sMyDir = .workDir '�������, � ������� ���������� ������� � �������
        
        If sMyDir = "����������" Then _
            .workDir = "C:\Users\" & Environ("USERNAME") & "\Desktop\": sMyDir = .workDir

        With Me.labelWorkDir
        
            PaintLabels .name, sMyDir
            If FolderNotExist(sMyDir) = False Then  '���� ��������� ������� ��������
                Me.cmbOpenWorkDir.Enabled = True
                Me.cmbChoseWorkDir.BackColor = &HFFFFFF 'white color
            End If
            
        End With
        
        '----------------------
        sMyDir = .templatesDir
        
        With Me.labelTemplatesDir
        
            PaintLabels .name, sMyDir
            
            If Not FolderNotExist(sMyDir) Then  '���� ��������� ������� ��������
            
                Me.cmbOpenTemplatesDir.Enabled = True
                Me.cmbChooseTemplatesDir.BackColor = &HFFFFFF 'white color
                
            End If
            
        End With

        If .depPrefix <> "����������" Then Me.tboxDepPrefix = .depPrefix
        If .labNum <> "����������" Then Me.tBoxLabNum = .labNum
        
        If bolUF_Set_Load Then
            bolUF_Set_Load = False
            
            If .useArchiveDir <> "����������" Then _
                If Dir(.ArchivePath, vbDirectory) <> "" Then Me.chbUseArchiveDir = .useArchiveDir
            bolUF_Set_Load = True
        Else
            If .useArchiveDir <> "����������" Then _
                If Dir(.ArchivePath, vbDirectory) <> "" Then Me.chbUseArchiveDir = .useArchiveDir
        End If
            
        If .isPortable = "����������" Then .isPortable = "False"
       ' Me.chbPortable = .isPortable
        
        If .helpOption = "����������" Then .helpOption = "True"
       ' Me.chbHelp = .helpOption
        
        UpdateEmployees (bolUF_Set_Load) '�������� ���������� ���������� �����������
        
'������ �������� ��������
        If .xlPrPath = "����������" Then .xlPrPath = sMyDir
        PaintLabels Me.labelPrDir.name, .xlPrPath
        
        If FolderNotExist(.xlPrPath) = False Then  '���� ��������� ������� ��������
            Me.labelPrDir.foreColor = &H8000& '������ ����
            Me.cmbChoosePrDir.BackColor = &HFFFFFF 'white color
            Me.cmbOpenPrDir.Enabled = True
        End If

        If .xlPrcPath = "����������" Then .xlPrcPath = sMyDir
        PaintLabels Me.labelPrcDir.name, .xlPrcPath
        
        If FolderNotExist(.xlPrcPath) = False Then  '���� ��������� ������� ��������
            Me.labelPrcDir.foreColor = &H8000& '������ ����
            Me.cmbChoosePrcDir.BackColor = &HFFFFFF 'white color
            Me.cmbOpenPrcDir.Enabled = True
        End If
        
        If .wdSvPath = "����������" Then .wdSvPath = sMyDir
        PaintLabels Me.labelSvDir.name, .wdSvPath
            
        If FolderNotExist(.wdSvPath) = False Then  '���� ��������� ������� ��������
            Me.labelSvDir.foreColor = &HFF0000    '����� ����
            Me.cmbChooseSvDir.BackColor = &HFFFFFF 'white color
            Me.cmbOpenSvDir.Enabled = True
        End If
        
        If .wdSrtPath = "����������" Then .wdSrtPath = sMyDir
        PaintLabels Me.labelSrtDir.name, .wdSrtPath
            
        If FolderNotExist(.wdSrtPath) = False Then  '���� ��������� ������� ��������
            Me.labelSrtDir.foreColor = &HFF0000    '����� ����
            Me.cmbChooseSrtDir.BackColor = &HFFFFFF 'white color
            Me.cmbOpenSrtDir.Enabled = True
        End If
        
        If .wdInPath = "����������" Then .wdInPath = sMyDir
        PaintLabels Me.labelInDir.name, .wdInPath
            
        If FolderNotExist(.wdInPath) = False Then  '���� ��������� ������� ��������
            Me.labelInDir.foreColor = &HFF0000    '����� ����
            Me.cmbChooseInDir.BackColor = &HFFFFFF 'white color
            Me.cmbOpenInDir.Enabled = True
        End If
    End With
End Sub
'#######################################################
'��������� ����������� ���� � ������� ������
Function PaintLabels( _
    labelName As String, _
    sDBPath As String, _
    Optional sDbName As String _
    ) As Boolean
    
    With Me.Controls(labelName)
        .foreColor = &H80&       '�������
        
        If sDbName <> "" Then '��������� ������������ �����
        
            .caption = ShortedString(sDBPath & sDbName, 48)
            If FileExist(sDBPath, sDbName) Then _
                .TextAlign = fmTextAlignLeft: .foreColor = &H808000: PaintLabels = True '���������
        Else '��������� ������������ ��������
        
            .caption = ShortedString(sDBPath, 43)
            If FolderNotExist(sDBPath) = False Then _
                .TextAlign = fmTextAlignLeft: .foreColor = &H808000: PaintLabels = True   '���������
        End If
    End With
End Function
'#######################################################
'������ ������� ��� ���������� ��������
Sub PreSaveSettings()
    With Me.cmbSaveReady '������ ������
        .Font.Size = 11: .caption = "���������": .BackColor = &HC0FFFF '������ ����
    End With
    bolAlreadySaved = False
End Sub
'#######################################################
'����� ������� ����������
Private Sub cmbChoseWorkDir_Click()
    
    Dim sMyPath As String, _
        sTempName As String
    
    sMyPath = GetFolderFPath(, , False) '������� �������� ������� ����������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\"
        WorkClsm.workDir = sMyPath '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
    
End Sub
'#######################################################
'������� ������� ����������
Private Sub cmbOpenWorkDir_Click()
    Explorer.OpenFolder WorkClsm.workDir, True
End Sub
'#######################################################
'��������� ��������� ������� ��������� �������
Private Sub cmbChoseBaseDir_Click()
    Dim sMyPath As String, sTempName As String
    sMyPath = GetFolderFPath(, , True) '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\"
        WorkClsm.startDir = sMyPath '�������� �������� � ������� �����
        
        WorkClsm.cusDB = "����������"
        sTempName = Dir(sMyPath & "\*.cuDb") '����� ���� ������ ����������
        If sTempName <> "" Then
            WorkClsm.cusDB = sTempName
            sTempName = Dir
            If sTempName <> "" Then WorkClsm.cusDB = "����������"
        End If
        
        WorkClsm.measInstrDB = "����������"
        sTempName = Dir(sMyPath & "\*.miDb") '����� ���� ������ ����������
        If sTempName <> "" Then
            WorkClsm.measInstrDB = sTempName
            sTempName = Dir
            If sTempName <> "" Then WorkClsm.measInstrDB = "����������"
        End If
        
        WorkClsm.etalDB = "����������"
        sTempName = Dir(sMyPath & "\*.etDb") '����� ���� ������ ����������
        If sTempName <> "" Then
            WorkClsm.etalDB = sTempName
            sTempName = Dir
            If sTempName <> "" Then WorkClsm.etalDB = "����������"
        End If
        
        WorkClsm.empDB = "����������"
        sTempName = Dir(sMyPath & "\*.nmDb") '����� ���� ������ ����������
        If sTempName <> "" Then
            WorkClsm.empDB = sTempName
            sTempName = Dir
            If sTempName <> "" Then WorkClsm.empDB = "����������"
        End If
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub
'#######################################################
'��������� ��������� ������� ��� ������� ������ ���� ���� ������
Sub ChooseFile(controlName As String, Optional CreateNew As Boolean)
    Dim sTempPath As String
    
    If CreateNew Then '�������� ������ �����
        sTempPath = GetSaveAsFname(myCmbIndex(controlName), WorkClsm.startDir) '���� � ����� ��� ����������
    Else '����� ������������� �����
        sTempPath = GetFileFPath(myCmbIndex(controlName), WorkClsm.startDir)   '�������� ������ ���� � �����
    End If
    
    If sTempPath <> "NoPath" Then
        
        If CreateNew Then
            Open sTempPath For Output As #1
                Print #1, "newFile"
            Close
        End If
        
        UpdateProperties controlName, sTempPath
    End If
End Sub
'#######################################################
'�������� ��������� �������� �������� � �����
Sub UpdateProperties(controlName As String, sPath As String)
    With WorkClsm
        Select Case myCmbIndex(controlName)
            Case 1, 2: .cusDB = TrueName(sPath)  '���������
            Case 3, 4: .measInstrDB = TrueName(sPath)  '�������� ���������
            Case 5, 6: .etalDB = TrueName(sPath) '�������
            Case 7, 8: .empDB = TrueName(sPath) '�������
        End Select
    End With
    
    UpdateDBLabels
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
'#######################################################
'������� ���������� � ������� ��� ������
Private Sub cmbOpenFolder_Click()
    Explorer.OpenFolder WorkClsm.startDir, True  '������� � �������� �����
End Sub
'#######################################################
'������ / ���������
Private Sub cmbSaveReady_Click()
    With Me.cmbSaveReady
        
        If .caption = "������" Then
            VBA.Unload Me
        Else '��������� ���������
            '####################################
            With myBase
                .GetArrFF setDir, Environ("USERNAME") & ".uCfg" '��������� � ����� ���� ��������� ������������
                .SaveProperties WorkClsm.myParameters, WorkClsm.myValues '�������� �������� � ��������� � ��������� � ����� ����� �����
            End With
            '####################################
            .Font.Size = 12: .caption = "������": bolAlreadySaved = True: .BackColor = &HFFFFFF  '����� ����
            
            Me.VersionLabel.caption = "������������ ���������."
            
            If Me.cmbCfgExp.Enabled = False Then _
                Me.cmbCfgExp.Enabled = True
        End If
    End With
End Sub
Private Sub cmbSaveReady_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    If Shift = 6 Then SaveNewVersion WorkClsm.startDir: VBA.Unload Me   '����������� ��� ������� ctrl+alt
End Sub
'#######################################################
'������� ���������� ������ ������ �� � �����
Private Function myCmbIndex(ctrlName As String) As Byte
    myCmbIndex = Right(ctrlName, 1)
End Function
'#######################################################
'��������� ������������ �� ���������
Private Sub cmbxHead_Change()
    With Me.cmbxHead
        If .text <> "<�������>" Then .BackColor = &H80000005 '�����
        
        If bolUF_Set_Load = False Then Exit Sub
        
        If .text = "<�������>" Then _
            WorkClsm.headNAME = "����������": .BackColor = &HC0FFFF '������
        
        If .text <> "<�������>" Then
            WorkClsm.headNAME = .text
            
            Dim i As Byte, sTempStr As String
            sTempStr = .text: If InStr(sTempStr, " ") > 0 Then sTempStr = Left(sTempStr, InStr(sTempStr, " "))
            
            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                If InStr(sArrDataBase(0, i), sTempStr) > 0 Then WorkClsm.headSTATE = sArrDataBase(1, i): Exit For '���������
            Next i
        End If
    End With
    
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
Private Sub cmbxHead_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 38 Or KeyCode = 40 Then

    ElseIf KeyCode = 13 Then cmbSaveReady_Click
    Else: KeyCode = 0
    End If
End Sub
'#######################################################
'��������� ���������� �� ���������
Private Sub cmbxVerifier_Change()
        
    With Me.cmbxVerifier
        If .text <> "<�������>" Then .BackColor = &H80000005 '�����
        
        If bolUF_Set_Load = False Then Exit Sub
        
        If .text = "<�������>" Then _
            WorkClsm.verNAME = "����������": .BackColor = &HC0FFFF '������
        
        If .text <> "<�������>" Then WorkClsm.verNAME = .text
    End With
    
    If Me.cmbxEmployee = "<�������>" Then Me.cmbxEmployee = Me.cmbxVerifier
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
Private Sub cmbxVerifier_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 38 Or KeyCode = 40 Then

    ElseIf KeyCode = 13 Then cmbSaveReady_Click
    Else: KeyCode = 0
    End If
End Sub
'#######################################################
'��������� ����������� �� ���������
Private Sub cmbxEmployee_Change()

    With Me.cmbxEmployee
        If .text <> "<�������>" Then .BackColor = &H80000005 '�����
        
        If bolUF_Set_Load = False Then Exit Sub
        
        If .text = "<�������>" Then _
            WorkClsm.empName = "����������": .BackColor = &HC0FFFF '������
        
        If .text <> "<�������>" Then
            WorkClsm.empName = .text
            
            Dim i As Byte, sTempStr As String
            sTempStr = .text: If InStr(sTempStr, " ") > 0 Then sTempStr = Left(sTempStr, InStr(sTempStr, " "))
            
            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                If InStr(sArrDataBase(0, i), sTempStr) > 0 Then WorkClsm.empState = sArrDataBase(1, i): Exit For '���������
            Next i
        End If
    End With
    
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
Private Sub cmbxEmployee_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 38 Or KeyCode = 40 Then

    ElseIf KeyCode = 13 Then cmbSaveReady_Click
    Else: KeyCode = 0
    End If
End Sub
'#######################################################
'��������� ��������������� ����������
Private Sub cmbxEmpSecond_change()

    With Me.cmbxEmpSecond
        If .text <> "<�������>" Then .BackColor = &H80000005 '�����
        
        If bolUF_Set_Load = False Then Exit Sub
        
        If .text = "<�������>" Then _
            WorkClsm.empSecName = "����������": .BackColor = &HC0FFFF '������
        
        If .text <> "<�������>" Then
            WorkClsm.empSecName = .text
            
            Dim i As Byte, sTempStr As String
            sTempStr = .text: If InStr(sTempStr, " ") > 0 Then sTempStr = Left(sTempStr, InStr(sTempStr, " "))
            
            For i = LBound(sArrDataBase, 2) To UBound(sArrDataBase, 2)
                If InStr(sArrDataBase(0, i), sTempStr) > 0 Then WorkClsm.empSecState = sArrDataBase(1, i): Exit For '���������
            Next i
        End If
    End With

    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
Private Sub cmbxEmpSecond_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If KeyCode = 38 Or KeyCode = 40 Then

    ElseIf KeyCode = 13 Then cmbSaveReady_Click
    Else: KeyCode = 0
    End If
End Sub
'#######################################################
'��������� ������ �� ���������
Private Sub tboxDepPrefix_Change()
    If bolUF_Set_Load = False Then Exit Sub
    WorkClsm.depPrefix = tboxDepPrefix
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub
'#######################################################
'��������� ����������� �� ���������
Private Sub tBoxLabNum_Change()
    If bolUF_Set_Load = False Then Exit Sub
    WorkClsm.labNum = tBoxLabNum
    PreSaveSettings '�������� ��������� ������ ������ / ���������
End Sub

'#######################################################
'����� ���������� ���������� �������
Private Sub cmbChoosePrDir_Click( _
    )
    
    Dim sMyPath As String, _
        sTempPath As String
    
    sTempPath = WorkClsm.xlPrPath
    
    If FolderNotExist(sTempPath) Then _
        sTempPath = "����������"
    
    If sTempPath <> "����������" Then _
        sTempPath = Left(sTempPath, Len(sTempPath) - InStr(2, StrReverse(sTempPath), "\") + 1) '��������� �� ������� ����
        
    sMyPath = GetFolderFPath(, sTempPath)  '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
    
        sMyPath = sMyPath & "\"
        WorkClsm.xlPrPath = sMyPath  '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
    
End Sub
Private Sub cmbOpenPrDir_Click()
    Explorer.OpenFolder WorkClsm.xlPrPath, True
End Sub
'#######################################################
'����� ���������� ���������� ����������
Private Sub cmbChoosePrcDir_Click( _
    )
    Dim sMyPath As String, _
        sTempPath As String
    
    sTempPath = WorkClsm.xlPrcPath
    
    If FolderNotExist(sTempPath) Then _
        sTempPath = "����������"
    
    If sTempPath <> "����������" Then _
        sTempPath = Left(sTempPath, Len(sTempPath) - InStr(2, StrReverse(sTempPath), "\") + 1) '��������� �� ������� ����
        
    sMyPath = GetFolderFPath(, sTempPath)  '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
        
        sMyPath = sMyPath & "\"
        WorkClsm.xlPrcPath = sMyPath  '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
    
End Sub
Private Sub cmbOpenPrcDir_Click()
    Explorer.OpenFolder WorkClsm.xlPrcPath, True
End Sub
'#######################################################
'����� ���������� ������������ � �������
Private Sub cmbChooseSvDir_Click( _
    )
    Dim sMyPath As String, _
        sTempPath As String
    
    sTempPath = WorkClsm.wdSvPath
    
    If FolderNotExist(sTempPath) Then _
        sTempPath = "����������"
    
    If sTempPath <> "����������" Then _
        sTempPath = Left(sTempPath, Len(sTempPath) - InStr(2, StrReverse(sTempPath), "\") + 1) '��������� �� ������� ����
        
    sMyPath = GetFolderFPath(, sTempPath)  '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\": WorkClsm.wdSvPath = sMyPath  '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub
Private Sub cmbOpenSvDir_Click()
    Explorer.OpenFolder WorkClsm.wdSvPath, True
End Sub
'#######################################################
'����� ���������� ������������ ����������
Private Sub cmbChooseSrtDir_Click()
    Dim sMyPath As String, sTempPath As String
    
    sTempPath = WorkClsm.wdSrtPath
    If FolderNotExist(sTempPath) Then _
        sTempPath = "����������"
    
    If sTempPath <> "����������" Then _
        sTempPath = Left(sTempPath, Len(sTempPath) - InStr(2, StrReverse(sTempPath), "\") + 1) '��������� �� ������� ����
        
    sMyPath = GetFolderFPath(, sTempPath)  '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\": WorkClsm.wdSrtPath = sMyPath  '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub
Private Sub cmbOpenSrtDir_Click()
    Explorer.OpenFolder WorkClsm.wdSrtPath, True
End Sub
'#######################################################
'����� ���������� ��������� � ������������� � ����������
Private Sub cmbChooseInDir_Click()
    Dim sMyPath As String, sTempPath As String
    
    sTempPath = WorkClsm.wdInPath
    
    If FolderNotExist(sTempPath) Then _
        sTempPath = "����������"
    
    If sTempPath <> "����������" Then _
        sTempPath = Left(sTempPath, Len(sTempPath) - InStr(2, StrReverse(sTempPath), "\") + 1) '��������� �� ������� ����
        
    sMyPath = GetFolderFPath(, sTempPath)  '������� ���� � ��������
    
    If sMyPath <> "NoPath" Then
        sMyPath = sMyPath & "\": WorkClsm.wdInPath = sMyPath  '�������� �������� � ������� �����
        
        UpdateDBLabels
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub
Private Sub cmbOpenInDir_Click()
    Explorer.OpenFolder WorkClsm.wdInPath, True
End Sub
'#######################################################
'������� ����� ��������� ������������
Private Sub cmbCfgExp_Click()
    Dim sTempPath As String
    sTempPath = GetSaveAsFname(9, "C:\Users\" & Environ("USERNAME") & "\Desktop\") '���� � ����� ��� ����������
    
    If sTempPath <> "NoPath" Then
        myBase.GetArrFF sTempPath '��������� � ����� ���� ����� ������������
        myBase.SaveProperties WorkClsm.myParameters, WorkClsm.myValues '�������� �������� � ��������� � ��������� � ����� ����� �����
        
        Me.VersionLabel.caption = "������������ ��������������" & vbNewLine & "�� ������� ����."
        
        myBase.GetArrFF setDir, "localConfig.uCfg" '��������� � ����� ������� ������������
    End If
End Sub
'#######################################################
'������ ����� ��������� ������������
Private Sub cmbCfgImp_Click()
    Dim sTempPath As String
    sTempPath = GetFileFPath(9, "C:\Users\" & Environ("USERNAME") & "\Desktop\")   '�������� ������ ���� � �����
    
    If sTempPath <> "NoPath" Then
        With myBase '������ � ������� ��������
            '#######################################################
            .GetArrFF sTempPath '��������� � ����� ���� ����� ������������
            '#######################################################
            .FillValues '�����������: ����� �������� �������� ���������� �� ������
        End With
          
        WorkClsm.FillProperties myBase.Parameters, myBase.values '�������� ����������� �� �������� ��������� � ����������� �����
        
        With myBase '������ � ������� ��������
            '#######################################################
            .GetArrFF setDir, "localConfig.uCfg" '��������� � ����� ���� ��������� ������������
            '#######################################################
        End With
        
        Me.cmbCfgImp.BackColor = &HFFFFFF    '�����
        
        UpdateDBLabels '�������� ����� ��������� ������ �������� ����������� ������
        UpdateEmployees bolUF_Set_Load '�������� ������ ������ ������������
        PreSaveSettings '�������� ��������� ������ ������ / ���������
    End If
End Sub
