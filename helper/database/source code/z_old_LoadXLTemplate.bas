Attribute VB_Name = "z_old_LoadXLTemplate"
Option Explicit

Const REFERENCE_FIFNUM_FILENAME = "fifRegNum.ref"
Const DEFAULT_VALUE = "nodata"

Const FirstVerifyString = "���������" '������������ ����� ����� xl � ��������� �������

Const FindCellInStrLimX = 10 '������������ �������� ��� ������ ����� ��
Const FindCellInStrLimY = 50 '������������ �������� ��� ������ ����� �Y
Const iHeadProrCnt = 23 '����� � ������ �����

Const DEFAULT_FILE_PREFIX = "prm_"

Const EtalonNameMaxLength = 75 '������������ ����� �������� ��� ������ ������ ��������

Private Type myCustomer
    sCustName As String: sCustINN As String: sCustAdress As String
End Type

Private Type EmpNameState
    empName As String: empState As String
End Type

Dim fso As New FileSystemObject
'###################################################################
'��������� �������� ������ ��������� � ������� ����������
Function LoadXlTemplate( _
    ByRef objZ_clsmSearch As Z_clsmSearch, _
    myMi As MeasInstrument) _
    As Boolean
    'todo:[-] LoadXlTemplate -- ����������� �������� ������� �� �������� ����� �����������
    
    Dim sBaseDir As String, _
        sWorkDir As String, _
        meEmp As EmpDivision, _
        bolLoadHelp As Boolean, _
        templatesDir As String
    

    sBaseDir = Config.sourceDataPath
    sWorkDir = Config.sandboxPath
    templatesDir = Config.instrumentsPath

    
    Dim sFileName As String, _
        sShortFileName As String
        
    sFileName = TemplateFileName( _
                                dbinstrumentsPath:=templatesDir, _
                                myMi:=myMi, _
                                fileExt:="*.xls*") ' �������� ������ ��� ����� ������� (��� ������� ��� � ������)
    
    If sFileName = vbNullString Then _
        Handler.Notify "���� ������� �� ���������, ���������� ��������"
    
    If sFileName <> vbNullString Then '���� ��� ������
        
        If InStr(GetBuiltInProperty("Keywords"), myMi.sFif) > 0 Then  '�������� �������� ������ ��������� ���� �� ��
            
            If MsgBox("��������� ������ � ������� ����� Excel?", vbYesNo) = vbYes Then _
                myMultiSel.bolThisWBSheetLoad = True
            
        End If
        
        Application.ScreenUpdating = False
'###################################################################
        GetMeWorkFile sFileName, templatesDir, sWorkDir, meEmp, myMi '����������������� �������� ��������
'###################################################################
        
        FillEtalonsAfterImport '��������� �������� �� ��������� ������������ � �������� ������� �����������
        FillNormalCondition objZ_clsmSearch '��������� �������� � ���������� �������� �������
        'If bolLoadHelp Then ActiveWorkbook.ActiveSheet.[l1] = "��������� " & LoadHelpString(sBaseDir) & "." '��������� �������� ���������
        
        Check_Footer '������ ������ ����������� �� ������ ��������
        
        ActiveWorkbook.Save
        
        LoadXlTemplate = True
        Application.ScreenUpdating = True
    End If
End Function
    Private Sub Check_Footer()
        
        With ActiveWorkbook.ActiveSheet
            
            If CBool(.HPageBreaks.count) Then '���������� �������� ������� > 1
                .PageSetup.FirstPage.LeftFooter.text = vbNullString
                .PageSetup.FirstPage.RightFooter.text = vbNullString
                    
            End If
        End With
        
    End Sub


'###################################################################
'��������� �������� ������� �������� � ������ ��������� ����� ��������� ����
Sub InsertBaseMIdata(objBaseWorkbook As Object, meEmp As EmpDivision, _
    myMi As MeasInstrument, bolFirstVer As Boolean, Optional bolDontChangeBuiltPror As Boolean)
          
    Dim rTempCell As Range
    If FindCellRight("���", rTempCell, , True) Then
        
        If Not rTempCell.address = "$A$2" Then
            rTempCell = Replace(rTempCell, "#���#", meEmp.sDepPref): rTempCell = Replace(rTempCell, "#���#", meEmp.sLabNum)
        
            Dim bStCh As Byte, sLenCh As Byte
            bStCh = InStr(CStr(rTempCell), "����������")
            If bStCh = 0 Then bStCh = InStr(CStr(rTempCell), "�����")
                
            sLenCh = Len(rTempCell) - InStr(rTempCell, "����������") + 1
            rTempCell.Characters(bStCh, sLenCh).Font.Size = 8
        End If
    End If
    
    If myMultiSel.bolThisWBSheetLoad = False Then
    
        If FindCellRight("������������,", rTempCell) Then
            
            If rTempCell = vbNullString Then
            
'                Dim sTempFif As String
'                sTempFif = Replace(myMi.sFif, "-", vbNullString) '�������� ����� � ��� ��� ����
'
'                If IsNumeric(sTempFif) Then

                rTempCell = myMi.sName & " " & myMi.sType '�� ��������� "������������ ���"
                
            End If
        End If
    End If
    
    If bolDontChangeBuiltPror = False Then '�� �������� �������� ���������
    
'        With objBaseWorkbook
'            Dim sTempStr As String, sWBName As String
'            sWBName = .Name: sTempStr = Replace(myMi.sFif, "-", "") '�������� ������ ��� �� �������
'
'            SetBuiltInProperty "Keywords", myMi.sFif '����� ���
'
'            If .Sheets.Count = 1 Then
'
'                If InStr(.ActiveSheet.Name, myMi.sType) = 0 Then '���� ��� ����������� �� �������� � ���� ��� ����
'                    SetBuiltInProperty "Comments", myMi.sType & " -- " & .ActiveSheet.Name '��� �������� ����� � �����
'                Else
'                    SetBuiltInProperty "Comments", .ActiveSheet.Name '��� �������� ����� � �����
'                End If
'            Else
'
'                Dim serialNum As String
'                If FindCellRight("��������� / �������� �����:", rTempCell) Then
'                    serialNum = CStr(rTempCell)
'                    DeleteSpaceStEnd serialNum
'                End If
'
'                Dim propertyText As String
'                propertyText = myMi.sType
'
'                If serialNum <> vbNullString Then _
'                    propertyText = propertyText & " -- " & serialNum
'
'                SetBuiltInProperty "Comments", propertyText
'            End If
'
'        End With
    End If
    
    If FindCellRight("���", rTempCell) Then
    
        Dim sTempFif As String
        sTempFif = Replace(myMi.sFif, "-", vbNullString) '�������� ����� � ��� ��� ����

      
        If rTempCell.Column <> 2 Then '� ������ �������� ������ ����� ���� �� ����������
            rTempCell = Chr(150)
            
            If IsNumeric(sTempFif) Then _
                rTempCell = myMi.sFif
        End If
    End If
    
    If FindCellRight("��������", rTempCell) Then rTempCell = myMi.sMetodic ': rTempCell.Font.Color = &H80000008: rTempCell.Font.Bold = False
    
    With objBaseWorkbook.ActiveSheet
        If myMi.bolEtal And InStr(.[l13], "������") > 0 Then .[l12] = "�������� ������� 1-�� �������"
' ----------------------------------------------------------------
If Not myMi.bolEtal And InStr(objBaseWorkbook.name, "pr_") > 0 Then _
    .[e25:e26].EntireRow.Delete '���� ����������� ������ ������� ��, � �� �������
' ----------------------------------------------------------------
        If FindCellRight("��� �������", rTempCell) Then
            rTempCell = "�������������": rTempCell.Font.Italic = True
            
            If bolFirstVer Then rTempCell = "���������": _
                rTempCell.Font.Italic = False: rTempCell.Font.Bold = True: .[j15] = "-": .[i16] = "-"
        End If
        
        If myMultiSel.bolThisWBSheetLoad = False Then
            If InStr(CStr(.[i8]), "����") > 0 Then .[j8] = Date  '�������� ������� ���� - ������ ���������
            If InStr(CStr(.[h8]), "����") > 0 Then .[i8] = Date '�������� ������� ���� - ���������� ���������
            If InStr(CStr(.[i10]), "����") > 0 Then .[i8] = Date '�������� ���������
            If InStr(CStr(.[i4]), "����") > 0 Then .[i2] = Date '�������� ���������
        End If
    End With
    
    Set rTempCell = Nothing
End Sub

'#########################################################
'������� ���������� ����� ������ � ����� � ���������� ����� ������ (������� ������)
Function FindCellRight( _
    sSearchStr As String, _
    ByRef searchResultCell As Range, _
    Optional BottomCell As Boolean, _
    Optional ThisCell As Boolean, _
    Optional SelectAfterFind As Boolean, _
    Optional ByVal objWs As Worksheet) _
        As Boolean
    
    FindCellRight = False
    If objWs Is Nothing Then Set objWs = ActiveWorkbook.ActiveSheet
    
    With objWs

        Dim prArea As String, findedCell As Range
        If objWs.PageSetup.PrintArea <> "" Then
            Set findedCell = Range(objWs.PageSetup.PrintArea).Find(sSearchStr, LookAt:=xlPart) '����� � ������� ������
        Else
            Set findedCell = objWs.Cells.Find(sSearchStr) '����� �� ����� �����
        End If
        
        If Not findedCell Is Nothing Then  '���-�� �������
            
            FindCellRight = True
            
            Set searchResultCell = findedCell.Offset(0, 1) '�� ��������� - ������ ������
            If BottomCell Then Set searchResultCell = findedCell.Offset(1, 0) '������ ����
            If ThisCell Then Set searchResultCell = findedCell '��������� ������
            
            If SelectAfterFind Then searchResultCell.Select
        End If

        Set findedCell = Nothing: Set objWs = Nothing
    End With
End Function
'###################################################################
'��������� �������� ����� ���������� ��������
Sub CopyPrevTempHead( _
    objBaseWorkbook As Object _
)
    With objBaseWorkbook
    
        Dim firstSheet As Worksheet, _
            startRow As Integer, _
            endRow As Integer
            
        Set firstSheet = .Worksheets(1)
        GetHeadRows firstSheet, startRow, endRow
        
        Application.DisplayAlerts = False
        firstSheet.Rows(startRow).Resize(endRow - startRow + 1).Copy
        
        Dim newSheet As Worksheet
        Set newSheet = .Worksheets(.Worksheets.count)
        
        With newSheet
            
            .Rows(startRow).Resize(endRow - startRow + 1).Select
            .Paste
            
            If InStr(.[l9], "�����") > 0 Then
                .[l8].numberFormat = "General"
                .[l8].FormulaR1C1 = "='" & firstSheet.name & "'!RC:RC[1]"
                
            End If
            
        End With
        Application.DisplayAlerts = True
        
        Set firstSheet = Nothing
        Set newSheet = Nothing
    End With
End Sub
    Private Sub GetHeadRows( _
        ws As Worksheet, _
        startRow As Integer, _
        endRow As Integer _
    )
        With ws
        
            Dim i As Byte
            Do While i < 30
            
                i = i + 1
                If InStr(.Cells(i, 1), "���") > 0 Then startRow = i - 1
                If InStr(.Cells(i, 1), "svid export") > 0 Then endRow = i - 1
                
                If Not startRow = 0 And Not endRow = 0 Then Exit Do
            Loop
            
            .Rows(startRow).Resize(endRow - startRow + 1).Copy
        End With
        
    End Sub
    
' ----------------------------------------------------------------
' ����: 17.03.2023 09:58
' ----------------------------------------------------------------
Private Sub Protocol_BaseDir()
        
    Dim prBaseDir As String
    prBaseDir = fso.BuildPath(configDirNew, "protocol base")
    
    If Not fso.FolderExists(prBaseDir) Then _
        MkDir prBaseDir
        
    Set fso = Nothing
    Explorer.OpenFolder prBaseDir, True
    
End Sub

' ----------------------------------------------------------------
' ����: 17.03.2023 09:58
' ----------------------------------------------------------------
Private Sub RenameProtocolBases()
    
    Dim fileDir As Object
    Set fileDir = fso.GetFolder(fso.BuildPath(configDirNew, "protocol base"))
    
    Dim oFile As Object
    For Each oFile In fileDir.Files
        
        Dim newName As String
        newName = Replace(oFile.name, "_temp", "_base")
        
        Name fso.BuildPath(fileDir, oFile.name) As fso.BuildPath(fileDir, newName)
        
    Next
    
    Set fileDir = Nothing
    Set fso = Nothing
    
    
End Sub
'###################################################################
'��������� ���������� �������� ��������������� ����� ��������� �� ��������� ������
Private Sub GetMeWorkFile( _
    sFullName As String, _
    sBaseDir As String, _
    sWorkDir As String, _
    meEmp As EmpDivision, _
    myMi As MeasInstrument _
    )
    
    Dim sShortFileName As String, _
        bolFirstVerify As Boolean
        
    sShortFileName = TrueName(sFullName) '�������� ��� ����� ��� ���� (�������� �� \)
    
    If InStr(sShortFileName, FirstVerifyString) > 0 Then _
        bolFirstVerify = True
    
    Dim sOldFileName As String, _
        sFileExt As String, _
        sFileTemp As String, _
        sFilePref As String
        
    sOldFileName = sFullName '������ ��� ������������ ��� �������� �������
    
    Dim sCheckFif As String, _
        sCheckRef As String
        
    sCheckFif = Replace(myMi.sFif, "-", "") '�������� ����� � ��� ��� �������
    sCheckRef = Replace(myMi.sRef, "-", "") '�������� ����� � ��� ����������� ������ ��� �������
    
    sFilePref = DEFAULT_FILE_PREFIX 'prc ��� prm
    
    Dim bodyPath As String
    bodyPath = Left(sFullName, Len(sFullName) - Len(sShortFileName))
    
    If IsNumeric(sCheckFif) Then '��, ��� ����������
        sFilePref = "pr_"

        If Dir(bodyPath & "fif_" & "*") <> vbNullString Then _
            sFilePref = "jr_"
    Else '��, ��� �����������
    
        If Dir(bodyPath & "fif_" & "*") <> vbNullString Then _
            sFilePref = "jrc_" '��� ����������� �����
    End If
        
    If InStr(sShortFileName, "body") > 0 Then '����� ��� �������

        Dim prBaseDir As String
        prBaseDir = Config.templatesBasePath
        
        sFileTemp = Dir(prBaseDir & Application.PathSeparator & sFilePref & "*base*")
        sOldFileName = vbNullString '����� �����
        
        If sFileTemp <> vbNullString Then _
            sOldFileName = fso.BuildPath(prBaseDir, sFileTemp)
            
        Set fso = Nothing
        
        If sOldFileName = vbNullString Then _
            MsgBox "����������� ������ ������ ��������� � ���������� " & vbNewLine & prBaseDir: _
            Exit Sub
            
    End If

    Dim objBaseWorkbook As Object, _
        objBodyWb As Object
        
    If myMultiSel.bolThisWBSheetLoad Then '��������� � ��� �����
    
        Set objBaseWorkbook = ActiveWorkbook
        Set objBodyWb = Application.Workbooks.Open(sOldFileName, , True) '������� ����� � ������ ������
        
        With objBodyWb
            .ActiveSheet.Copy _
                After:=objBaseWorkbook.Worksheets(objBaseWorkbook.Worksheets.count)
            
            .Close False  '�������� � �����
        End With
        
        CopyPrevTempHead objBaseWorkbook   '�������� ����� ���������� ��������
    Else  '��������� � ����� ��������� �����
               
        SetBuiltInProperty "Comments", , True '�������� ��������
        SetBuiltInProperty "Category", , True '�������� ��������
        
'        Dim bodyPath As String
'        bodyPath = Left(sFullName, Len(sFullName) - Len(sShortFileName))
'        If Dir(bodyPath & "fif_" & "*") <> vbNullString Then _
'        sFilePref = "jr_" '��� ����������� �����
        
        Dim sNewFileName As String
        sNewFileName = sFilePref  '������� ����� ��� ������ ������ �������

        sFileExt = GetExt(sFullName) '�������� ���������� �����
        sNewFileName = sNewFileName & "TEMP_" & Format(Date, "dd-mm-yyyy") & sFileExt
'        sNewFileName = sNewFileName & meEmp.sDepPref & "_" & meEmp.sLabNum & "_TEMP_" & Right(Date, 2) & sFileExt
                
        sNewFileName = ReturnNotExistingName( _
                                            Load_Directory(sWorkDir), _
                                            sNewFileName)  '��������� ��� ����� � �������� ������

        ActiveWorkbook.SaveAs sNewFileName, xlWorkbookDefault '��������� ��� ������� �����

        Set objBaseWorkbook = ActiveWorkbook
        Set objBodyWb = Application.Workbooks.Open(sOldFileName, , True) '������� ����� � ������ ������
        
        With objBodyWb
            .ActiveSheet.Copy After:=objBaseWorkbook.Worksheets(objBaseWorkbook.Worksheets.count): .Close False  '�������� � �����
        End With
        
        Dim wsDelCount As Byte, i As Byte
        wsDelCount = ActiveWorkbook.Sheets.count - 1 '���������� ������ ��� �������� � �����

        Application.DisplayAlerts = False
        Do While wsDelCount > 0
            ActiveWorkbook.Sheets(1).Delete
            wsDelCount = wsDelCount - 1
        Loop
        Application.DisplayAlerts = True
                   
        ActiveWorkbook.Save
    End If
    
    InsertBaseMIdata objBaseWorkbook, meEmp, myMi, bolFirstVerify ' �������� � ���������� ������ ������� ������
    
    If myMultiSel.bolThisWBSheetLoad Then _
        CopyPrevTempHead objBaseWorkbook
        
    If InStr(sShortFileName, "body") > 0 Then _
        InsertBodyTemplate objBaseWorkbook, sFullName, myMi '����� ��� ������� - ����������
    
    FillInstrumentType objBaseWorkbook, myMi
    'TrueConvertation myMi '�������� "�������" �� "����������" � �������� � ������

    myMultiSel.bolThisWBSheetLoad = False
    Set objBodyWb = Nothing: Set objBaseWorkbook = Nothing
End Sub
    Private Function Load_Directory( _
        default_workDir As String _
        ) As String
        
        Load_Directory = default_workDir '�� ��������� - ������� �������� ������ ��������
        
        Dim aWbPath As String
        aWbPath = ActiveWorkbook.path
        
        If aWbPath = vbNullString Then _
            Exit Function '���� ������ ��� � ������������� ������
            
        aWbPath = aWbPath & Application.PathSeparator
        If aWbPath <> default_workDir Then Load_Directory = aWbPath
        
    End Function

    Private Sub FillInstrumentType( _
        objBaseWorkbook As Workbook, _
        myMi As MeasInstrument _
    )
            
        With objBaseWorkbook
            Dim sTempStr As String, _
                sWBName As String
                
            sWBName = .name
            sTempStr = Replace(myMi.sFif, "-", "") '�������� ������ ��� �� �������
        
            SetBuiltInProperty "Keywords", myMi.sFif '����� ���
            
            If .Sheets.count = 1 Then
            
                If InStr(.ActiveSheet.name, myMi.sType) = 0 Then '���� ��� ����������� �� �������� � ���� ��� ����
                    SetBuiltInProperty "Comments", myMi.sType & " -- " & .ActiveSheet.name '��� �������� ����� � �����
                Else
                    SetBuiltInProperty "Comments", .ActiveSheet.name '��� �������� ����� � �����
                End If
            Else
            
                Dim serialNum As String, _
                    rTempCell As Range
                    
                If FindCellRight("��������� / �������� �����:", rTempCell) Then
                    serialNum = CStr(rTempCell)
                    DeleteSpaceStEnd serialNum
                End If
                
                Dim propertyText As String
                propertyText = myMi.sType
                
                If serialNum <> vbNullString Then _
                    propertyText = propertyText & " -- " & serialNum
                    
                SetBuiltInProperty "Comments", propertyText
            End If
            
        End With
    
    End Sub


'###################################################################
'��������� �������� �������� �� ������ ��� �������� ������� ���������� �� ���� �������
Sub TrueConvertation(myMi As MeasInstrument)
    
    Dim sFifNum As String, sRefNum As String, bolFif As Boolean, bolRef As Boolean
    sFifNum = Replace(myMi.sFif, "-", ""): sRefNum = Replace(myMi.sRef, "-", "")
    
    If IsNumeric(sFifNum) Then bolFif = True '����� ����������� ��������, ����������� �������
    If IsNumeric(sRefNum) Then bolRef = True '����� ����������� ��������, ����������� �������
    
    'If bolFif And bolRef = False Then ReplaceData 1, 2 '�������� "����������" �� "�������"
    'If bolFif = False And bolRef Then ReplaceData 2, 1 '�������� "�������" �� "����������"
End Sub
'###################################################################
'��������� �������� ������ ��������� �� ����������� ����+����
Sub InsertBodyTemplate( _
    wbTemplateBase As Object, _
    bodyTemplatePath As String, _
    currentMI As MeasInstrument _
    )
    
    Dim i As Byte, _
        bodyRow As Byte, _
        instrumentNameRow As Byte, _
        cellText As String
        
    i = 1
    Do While i < 255
        
        cellText = CStr(wbTemplateBase.ActiveSheet.Cells(i, 1))
        
        If InStr(cellText, "������������,") > 0 Then instrumentNameRow = i
        If InStr(cellText, "body") > 0 Then bodyRow = i: Exit Do
        i = i + 1
    Loop
    
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    Application.Calculation = xlCalculationManual
    
    Dim wbBody As Object, _
        bodyStartRow As Byte, _
        bodyEndRow As Byte, _
        instrumentName As String, _
        etalonRank As String
        
    Set wbBody = Application.Workbooks.Open(bodyTemplatePath, , True) '������� ����� � ����� ��������� ������ ��� ������
    
    With wbBody.ActiveSheet
    
        bodyEndRow = .Cells(.Rows.count, 1).End(xlUp).Row '��������� ����������� ������ ����� �����
        i = bodyEndRow
        
        Do While i > 0
            
            cellText = CStr(.Cells(i, 1))
            
            If InStr(cellText, "end body") > 0 Then
                
                bodyEndRow = i '������ ����� ���� ���������
                If InStr(cellText, "=") > 0 Then _
                    etalonRank = cellText: _
                    etalonRank = Right(etalonRank, Len(etalonRank) - InStr(etalonRank, "=")) '��� �������
            End If
            
            If InStr(cellText, "body") > 0 And InStr(cellText, "end body") = 0 Then
                bodyStartRow = i '������ ������ ���� ���������
                
                If InStr(cellText, "=") > 0 Then _
                    instrumentName = cellText: _
                    instrumentName = Right(instrumentName, Len(instrumentName) - InStr(instrumentName, "=")) '������� �������� ��
            End If
            i = i - 1
        Loop
        
        .Rows(bodyStartRow + 1).Resize(bodyEndRow - bodyStartRow - 1).Copy '���������� ������ ����� ���� ���������
    End With
    
    With wbTemplateBase.ActiveSheet
        
        If myMultiSel.bolThisWBSheetLoad = False Then
        
            If instrumentName <> vbNullString Then _
                .Cells(instrumentNameRow, 1).Offset(0, 1) = currentMI.sName & " " & currentMI.sType & ", ����������� " & instrumentName ' �������� ������������ �� ����� ����
                
            If etalonRank <> vbNullString Then _
                .Cells(instrumentNameRow, 1).Offset(0, 10) = etalonRank ' �������� ������ �������
                
        End If
        
        If bodyRow <> 0 Then
            
            .Cells(bodyRow, 1).Insert
            .Cells(bodyRow + bodyEndRow - bodyStartRow - 1, 1).EntireRow.Delete '������� ������� body
            
        End If
        
    End With
    
    wbTemplateBase.ActiveSheet.name = NonTakenShName(wbTemplateBase, wbBody.ActiveSheet.name) '��������� ���������� ��� �������� �����
    
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    Application.Calculation = xlCalculationAutomatic
    
    wbBody.Close False
    Set wbBody = Nothing
End Sub
    '###################################################################
    '��������� ��������� ��������������� ���� ��� �������
    Private Function NonTakenShName( _
        objWorkBook As Object, _
        currentName As String _
        ) As String
        
        NonTakenShName = currentName
        
        Dim isNameTaken As Boolean
        isNameTaken = SheetExists(objWorkBook, currentName)
        
        If Not isNameTaken Then Exit Function
        
        Dim newName As String
        newName = currentName
        
        Dim j As Integer
        j = 2
        
        Do While isNameTaken
            
            newName = currentName & " (" & j & ")"
            isNameTaken = SheetExists(objWorkBook, newName)
            j = j + 1
            
        Loop
        
        NonTakenShName = newName
        
    End Function
        Private Function SheetExists( _
            Workbook As Object, _
            sheetName As String _
            ) As Boolean
            
            SheetExists = False
            
            Dim i As Integer
            For i = 1 To Workbook.Sheets.count
    
                If Workbook.Sheets(i).name = sheetName Then _
                    SheetExists = True: _
                    Exit Function '����� ���������� ���
            Next
        
        End Function
            
'#########################################################
'��������� ��������� ������ �� ��������
Private Sub FillEtalonsAfterImport( _
    Optional noEtalData As Boolean, _
    Optional objWs As Worksheet _
    )
    
    Dim myBase2 As New Z_clsmBase, WorkClsm2 As New Z_clsmSearch, sArrDataBase2() As String
    
    Application.ScreenUpdating = False
    
    With myBase2 '������ � ������� ��������
        .GetArrFF setDir, Environ("USERNAME") & ".uCfg" '��������� � ����� ���� ��������
        .AddP "startDir", "etalDB"
        .AddP "headNAME", "headSTATE"
        .AddP "empNAME", "empSTATE"
        .AddP "empSecNAME", "empSecSTATE"
        
        .FillValues '�����������: ����� �������� �������� ���������� �� ������
    End With
    

    With WorkClsm2
        .FillConfiguration myBase2.Parameters, myBase2.values '�������� ����������� �� �������� ��������� � ����������� �����
        
        
        
        
        
        
        
        ' ------------------------------------------------------
        'todo: FillLastName -- �������� workclsm -- ���, ���������
        FillLastName .headNAME, .headSTATE, True, , objWs '�������� ������� � ��������� ������������ - ��� ��������� ���������� �����
        FillLastName .empSecName, .empSecState, , True, objWs '�������� ������� � ��������� ������� �����������
        FillLastName .empName, .empState, , , objWs '�������� ������� � ��������� �����������
        ' ------------------------------------------------------
        
        
        
        
        
        
        
        
'        If noEtalData = False And FileExist(.startDir, .DbName) Then '���� ���� ������ ���������� �� ���������� ����
'            sArrDataBase2 = .FillDataBase(myBase2.GetArrFF(.startDir, .DbName), True)  '������������� ������ ����� � ������ ���� ������
'
'            If UBound(sArrDataBase2) > 0 Then PasteEtalonsData sArrDataBase2 '���� ������ ����� ��� �������
'        End If
        
    End With
    Application.ScreenUpdating = True
End Sub



'#########################################################
'��������� ���� � ��������� �������� �� ��������
Sub PasteEtalonsData(myDataBase() As String)
    With ActiveWorkbook.ActiveSheet
    
        Dim i As Byte, bEtalWorkRow As Byte, sCellStr As String
        i = 1: bEtalWorkRow = 1
        
        Do While i < 40 '����� ������ ������ ���������� �������
            sCellStr = CStr(.Cells(i, 1))
            If InStr(LCase(sCellStr), "�������") > 0 Then bEtalWorkRow = i + 3: Exit Do
            i = i + 1
        Loop
        
        Application.ScreenUpdating = False
        Do While CStr(.Cells(bEtalWorkRow, 1)) <> vbNullString  '���������, ���� �� �������� ������
            
            With .Cells(bEtalWorkRow, 1)
            
                Dim sSearchType As String, sSearchNumber As String, j As Byte
                sSearchType = CStr(.Offset(0, 1))
                sSearchNumber = CStr(.Offset(0, 2))  '�������� �������� ��� �������������
                
                DeleteSpaceStEnd sSearchType: DeleteSpaceStEnd sSearchNumber
                For j = LBound(myDataBase, 2) To UBound(myDataBase, 2)
                    
                    If InStr(sSearchType, myDataBase(1, j)) > 0 Then '�������� ���������� �� ����
                        
                        If sSearchNumber <> vbNullString Then
                            
                            If InStr(myDataBase(2, j), sSearchNumber) > 0 Then _
                                GiveTrueDate myDataBase(3, j), .Offset(0, 3): Exit For  '������� ����������
                        Else
                            GiveTrueDate myDataBase(3, j), .Offset(0, 3): Exit For  '������� ����������
                        End If
                        
                    End If
                        
                Next j
            End With
            
            bEtalWorkRow = bEtalWorkRow + 2
        Loop
        Application.ScreenUpdating = True
        
        If bEtalWorkRow <> 1 Then .[a1].Select '����� ������ ���� ��������
     '   If bEtalWorkRow = 1 Then ActiveCell = "���� �������� �� ���������."
    End With
End Sub
'#########################################################
'��������� ��������� ������ � ��������� �� ��������� � ������
Sub GiveTrueDate(sCommentToPaste As String, objCell As Range)

    Dim sCellText As String
    sCellText = objCell: If sCellText = "" Then sCellText = sCommentToPaste
    
    Dim iStPos As Integer, sLeftStr As String, sRightStr As String, dDateOfComm As Date
    iStPos = InStr(sCellText, "����������") '����� ���� � ������
    dDateOfComm = Date + 30 '�� ��������� ���� �������� ��������� � ������� �����������������
    
    If iStPos > 0 Then '������� ���� � ������ ����������
        sLeftStr = Left(sCommentToPaste, iStPos - 2): DeleteSpaceStEnd sLeftStr
        sRightStr = Right(sCommentToPaste, Len(sCommentToPaste) - Len(sLeftStr)): DeleteSpaceStEnd sRightStr
        dDateOfComm = CDate(Right(sRightStr, 10)): sCellText = sLeftStr & vbLf & sRightStr
    End If
    
    objCell = sCellText
    
    With Range(Cells(objCell.Row, 1), objCell)     '��������� ������ � ����������� �� ����
        .Interior.Pattern = xlNone: .Font.ColorIndex = xlAutomatic '������ ���� ������
        
        Select Case dDateOfComm - Date '������� ��� �� ��������� ����� �������
            Case Is <= 0 '����������
                '.Font.Color = -16776961 '������� ���� ������
                .Font.color = 10921638 '����� ���� ������
            Case Is <= 7 '�������� ������
                .Font.color = -16776961 '������� ���� ������
                '.Font.Color = 36799 '������ ���� ������
                '.Font.Italic = True '�������� ��������
                '.Interior.Color = 65535 '����� ����
            Case Is <= 21 '�������� 3 ������
                '.Font.Color = -6279056 '���������� ���� '.Font.Color = 24704 '����-���������� ����
                .Font.color = 36799 '������ ���� ������
        End Select
    End With
End Sub
'###################################################################
'��������� ��������� ������� �������� ����� ��� ������������ ������� ���������
Sub FillTempProperties(myInstr As MeasInstrument, sDestDir As String)
    DeleteWrongSheet '������� ����� ���� �� ������
    
    GetTrueModificationMi myInstr '�������� �������� �����������
 
    Dim sSaveName As String, sAdditionalText As String
    sSaveName = "body_": sAdditionalText = myInstr.sMetodic
    If myInstr.sModification <> "" Then sAdditionalText = myInstr.sModification
    
    sSaveName = sSaveName & myInstr.sFif & " " & sAdditionalText  '����� ����� ������ �����
    Application.ScreenUpdating = False
    
    Dim rHeadCell As Range
    If SheetIsEmpty(ActiveWorkbook.ActiveSheet) Then '������ ����
        Dim objBaseWb As Object, objBodyWb As Object
        Set objBaseWb = ActiveWorkbook: Set objBodyWb = ThisWorkbook

        With objBodyWb '����� ����������
            .Sheets.item("protocol").Copy After:=objBaseWb.Worksheets(objBaseWb.Worksheets.count) '�������� � �����
            Application.DisplayAlerts = False: objBaseWb.Worksheets(1).Delete: Application.DisplayAlerts = True

            Set rHeadCell = objBaseWb.ActiveSheet.[a1]: rHeadCell = GetHeadBodyText(myInstr.sType, myInstr.sMetodic, myInstr.sName)  '�������� ���������
        End With
        
        Set objBaseWb = Nothing: Set objBodyWb = Nothing
    Else '�������� ����
        Dim rEndCell As Range
        
        With ActiveWorkbook.ActiveSheet
            
            If FindCellRight("�������", rHeadCell, , True) Then '���� ������� ������ "�������"
                Set rHeadCell = rHeadCell.Offset(-1, 0)
                FillHeadCell rHeadCell, myInstr, sSaveName '������������� ������ ������� �������
            
                If rHeadCell.Row > 1 Then _
                    .Range(.[a1], rHeadCell.Offset(-1, 0)).EntireRow.Delete '������� ��� ������ ����
                .Range(rHeadCell, Cells(rHeadCell.Row, 10)).Merge  '���������� ������
                
                If .[o1] <> ThisWorkbook.Worksheets("����1").[o1] Then '���� ���� ������ �����������
                    ThisWorkbook.Worksheets("����1").Columns("N:Q").Copy '������� ���� ��������
                    .Columns("N:Q").PasteSpecial: .[a1].Select
                End If
                
                FillEtalStringBlock rHeadCell '��������� �� ���������� ������ �������� ������
            End If
            
            If GetrEndCell(rEndCell) Then '�������� ������ ������ �������
            
                FillEndCell rEndCell '������������� ������ ������ �������
                .Range(rEndCell, Cells(rEndCell.Row, 10)).Merge '���������� ������
                
                Application.CutCopyMode = False
                .Cells.Replace What:="$", Replacement:="" '������ ������������� ���� �����
                
                Dim shShape As Shape
                For Each shShape In .Shapes
                    shShape.Delete '������� ��� �������, ������� �����
                Next
            End If
        End With
    End If
    
    With ActiveWorkbook.ActiveSheet
        .name = myInstr.sType: If myInstr.sType <> myInstr.sMetodic Then .name = myInstr.sMetodic '�������� ��� ��������� �����
    End With
          
    SaveNewName sSaveName, True, False, True, sDestDir '��������� ������� ����� excel ��� ����� ��������� ���������
    FillThisPathDocTempName myInstr '�������� ������ wd
    Application.ScreenUpdating = True
End Sub
'###################################################################
'��������� ������������ ������ � ����������� ��
Sub GetTrueModificationMi(ByRef myInstr As MeasInstrument)
    
    With myInstr
        DeleteSpaceStEnd .sModification '������� ������ ������� � ������ � ����� ������������
    
        Select Case .sModification
            Case "", "��� �����������"
                .sModification = "": .sMetodic = .sType '���-� ������, ������� ����� �������� � ��������
                
            Case Else '�������� �����������
                '.sMetodic = .sType & " " & .sModification
                .sMetodic = .sModification
                
                If InStr(.sModification, .sType) > 0 Then _
                    .sMetodic = .sModification '���-� ���-�03-1� ���������� � ���-�03-1�
        End Select
    End With
    
    With ActiveWorkbook
       .BuiltinDocumentProperties("Keywords") = myInstr.sFif '����� � ���
       .BuiltinDocumentProperties("Comments") = myInstr.sMetodic '������ ������������ ���� �� � ������������
    End With
End Sub
'###################################################################
'��������� ��������� ������ ����1 � ����2 ������
Sub FillEtalStringBlock(Optional rHeadCell As Range, Optional bolMultiProtExport As Boolean)
    Dim rEtalCell As Range, sArrExport() As String ' ������ �� ���������� �� ��������
    
    If bolMultiProtExport Then '���������� �������� ��� ��������������� ���������
        If GetEtalExportCell(rEtalCell, ActiveWorkbook.Worksheets(1)) = False Then Exit Sub  '���� ������ �� �������
        If FillEtalArrayMultiExport(sArrExport) = False Then Exit Sub '���� � ������ �� ���� �������� �� ������ ��������
    Else '���������� �������� ��� ������� ��������
        If GetEtalExportCell(rEtalCell, ActiveWorkbook.ActiveSheet) = False Then Exit Sub '���� ������ �� �������
    
        Dim rWorkCell As Range '- ����� ������ � ����� �������� ���������
        Set rWorkCell = rHeadCell.Offset(4, 0): Set rWorkCell = rWorkCell.Offset(0, 1) '������ ����������� ������ � ����� �������
        
        If FillEtalArrayExportCell(sArrExport, rWorkCell) = False Then Exit Sub '���� � ������ �� ���� �������� �� ������ ��������
    End If
    
    '########################### - ������������ ���� ����� ��������
    Dim sTempStr As String, i As Byte, sEtalFirstStr As String, sEtalSecondStr As String
    
    SortMassOne sArrExport, , True
    
    For i = LBound(sArrExport) To UBound(sArrExport)
        sTempStr = sTempStr & sArrExport(i) & ", "
    Next

    sEtalFirstStr = TrueNameLength(sTempStr, EtalonNameMaxLength): DeleteSpaceStEnd sEtalFirstStr
    If Right(sEtalFirstStr, 1) = "," Then sEtalFirstStr = Left(sEtalFirstStr, Len(sEtalFirstStr) - 1) '������ �������
    
    sEtalSecondStr = TrueNameLength(sTempStr, EtalonNameMaxLength, True)
    If sEtalSecondStr <> "" Then sEtalSecondStr = sEtalSecondStr & " "
    
    sTempStr = "������������ ������� ��������� �� ��������� �������"
    If UBound(sArrExport) > 0 Then sTempStr = "������������ �������� ��������� �� ��������� �������"
    
    sEtalSecondStr = sEtalSecondStr & sTempStr
    '########################### - �������� �������� � ������
    Set rEtalCell = rEtalCell.Offset(0, 1)
    
    rEtalCell.value = sEtalFirstStr
    rEtalCell.Offset(1, 0).value = sEtalSecondStr
    
    Set rEtalCell = Nothing: Set rWorkCell = Nothing
End Sub
'###################################################################
'������� ��������� ������ ������ ������� �� ���� ��������� ����� ��� �������� � ���� �������� ������
Function FillEtalArrayMultiExport(ByRef sArrTemp() As String) As Boolean
    FillEtalArrayMultiExport = False
    
    Dim ws As Worksheet, wsCnt As Byte, sTempStr As String
    wsCnt = ActiveWorkbook.Sheets.count: ReDim sArrTemp(0)
    
    For Each ws In ActiveWorkbook.Worksheets '�������� �� ���� ������
    
        Dim iRowSvidExp As Integer
        iRowSvidExp = FindSvidExportRow(ws) ' 1 - �������� ����� ������ � ������ ��������
        
        If iRowSvidExp <> -1 Then '�������� ������� ����� ��������
        
            Dim rEtalCell As Range, sArrWork() As String, i As Byte, j As Byte, sArrHelp() As String
            If GetEtalExportCell(rEtalCell, ws) Then  '���� ������ ������� � ����� �������� ������
            
                sTempStr = rEtalCell.Offset(0, 1) & ", " & rEtalCell.Offset(1, 1) '��������� ������ �������� 1 � 2
                
                sArrWork = Split(sTempStr, ", ") '������� ������
                ReDim Preserve sArrWork(UBound(sArrWork) - 1) '��������� ����������� ������� �� 1 - ������� ������� "������������ ��������..."
                ReDim sArrHelp(1, UBound(sArrWork)) '��������������� ������
                
                For i = LBound(sArrWork) To UBound(sArrWork) '�������� �� ����� ������� ���������� ����� ��������
                    sArrHelp(LBound(sArrHelp), i) = sArrWork(i) '������������ �������
                    sArrHelp(UBound(sArrHelp), i) = False '���������� ���������� ����� �������
                    
                    For j = LBound(sArrTemp) To UBound(sArrTemp) '�������� �� ���� ��������� ��������� ����� ��������
                        If InStr(sArrTemp(j), sArrWork(i)) > 0 Then sArrHelp(UBound(sArrHelp), i) = True '������������ ������� - ������� ��� � �������
                    Next
                Next
                
                For i = LBound(sArrHelp, 2) To UBound(sArrHelp, 2)
                    If sArrHelp(UBound(sArrHelp), i) = False Then
                        If sArrTemp(UBound(sArrTemp)) <> "" Then ReDim Preserve sArrTemp(UBound(sArrTemp) + 1)
                        sArrTemp(UBound(sArrTemp)) = sArrHelp(LBound(sArrHelp), i) '�������� �������
                    End If
                Next
            End If
        End If
    Next
    If sArrTemp(LBound(sArrTemp)) <> "" Then FillEtalArrayMultiExport = True '���� ��� ������� ���� �� 1 �������
End Function

'###################################################################
'������� ������� ������ �������� ������ � ����� ��������
Function GetEtalExportCell(ByRef rEtalCell As Range, ws As Worksheet) As Boolean
    GetEtalExportCell = False
   
    Set rEtalCell = ws.Cells(6, 11).End(xlToRight) '������ ����������� ������ ������
    If rEtalCell.Column > 20 Then Exit Function '������ �� ���������� �����
    
    Set rEtalCell = ws.Cells(1, rEtalCell.Column).End(xlDown) '������ ����������� ������ ������, ������ � 1 ������
    
    Dim K As Byte
    Do While K < 2 '���������, ���� �� ����� 2 ������ ������ ������
        If InStr(CStr(rEtalCell), "#����") > 0 Then Exit Do
        If CStr(rEtalCell) = "" Then K = K + 1 '������� ������ �����
        If CStr(rEtalCell) <> "" Then K = 0 '������� ������ �����
        Set rEtalCell = rEtalCell.Offset(1, 0) '���������� �� ������ ����
    Loop
    
    If CStr(rEtalCell) = "" Then Exit Function '���� ������ �� �������
    GetEtalExportCell = True
End Function
'###################################################################
'������� ��������� ������ ������ ������� ��� �������� � ���� �������� ������
Function FillEtalArrayExportCell(ByRef sArrTemp() As String, rWorkCell As Range) As Boolean
    FillEtalArrayExportCell = False
    
    Dim sTempName As String, sTempNum As String
    ReDim sArrTemp(0)
    
    Do While CStr(rWorkCell) = "-" '���������, ���� �������������� ������ ��� ���� ��
        sTempName = CStr(rWorkCell.Offset(0, -4)) '�������� ������������ �������
        sTempNum = CStr(rWorkCell.Offset(0, 1)) '�������� ����� �������
        
        If InStr(sTempName, "���") > 0 Or InStr(sTempName, "����") > 0 Or InStr(sTempName, "������") > 0 Then   '������ ������
            If sArrTemp(UBound(sArrTemp)) <> "" Then _
                ReDim Preserve sArrTemp(UBound(sArrTemp) + 1) '��������� ������, ���� �� �����
            
            If InStr(sTempName, " ���") > 0 Then sTempName = Right(sTempName, Len(sTempName) - InStr(sTempName, " ���")) '���� � ������������ ������������ ��������� ����� ����� �������
            If InStr(sTempName, " ����") > 0 Then sTempName = Right(sTempName, Len(sTempName) - InStr(sTempName, " ����")) '���� � ������������ ������������ ��������� ����� ����� �������
            
            sArrTemp(UBound(sArrTemp)) = sTempName & ", " '�� ��������� �������� ������������ ������� (��� ����������)
            If InStr(sTempNum, "ZZB") > 0 Then sArrTemp(UBound(sArrTemp)) = "���. � " & sTempNum & ", " '�������� ����� ��� ��������� � �������
            
        End If
        Set rWorkCell = rWorkCell.Offset(1, 0) '���������� �� 2 ������ ����
    Loop
    If sArrTemp(LBound(sArrTemp)) <> "" Then FillEtalArrayExportCell = True '���� ������ ���� ���� ������
End Function
'###################################################################
'��������� ��������� ������ body
Sub FillHeadCell(rHeadCell As Range, myInstr As MeasInstrument, sSaveName As String)
    With rHeadCell
        .Font.color = 0: .HorizontalAlignment = xlCenter: .Interior.color = 65535 '����� ���� ������
        rHeadCell = GetHeadBodyText(myInstr.sType, myInstr.sMetodic, myInstr.sName)  '�������� ���������

        .Offset(1, 0) = "�������� �������: ������� � ��������������� ������������"
        If InStr(sSaveName, "bodyc_") > 0 Then .Offset(1, 0) = "�������� ����������: ������� � ��������������� ������������"
    End With
End Sub
'###################################################################
'�������� ������� ������ rEndCell
Function GetrEndCell(ByRef rSearchCell As Range) As Boolean
    Dim rClearCell As Range, bolClear As Boolean
    
    GetrEndCell = False
    With ActiveWorkbook.ActiveSheet
        Set rSearchCell = .Cells(Rows.count, 1).End(xlUp) '��������� ����������� ������ �����
        If rSearchCell.text = "svid export" Then Set rClearCell = rSearchCell: bolClear = True  '������ ����� ������� ���� �������������
    
        Do While InStr(CStr(rSearchCell), "svid export") > 0 _
            Or InStr(CStr(rSearchCell), "��������") > 0 Or InStr(CStr(rSearchCell), "�������") > 0 _
                Or InStr(CStr(rSearchCell), "Error") > 0
                
            Set rSearchCell = .Cells(rSearchCell.Row, 1).End(xlUp) '��������� ����������� ������ �����
        Loop
    End With
    
    If bolClear Then rClearCell.value = ""
    If CStr(rSearchCell) <> "end body" Then Set rSearchCell = rSearchCell.Offset(1, 0)
    
    GetrEndCell = True
End Function
'###################################################################
'��������� ��������� ������ end body
Sub FillEndCell(rEndCell As Range)

    With rEndCell
        .UnMerge
        .HorizontalAlignment = xlCenter: .Font.color = 0: .Font.Size = 8: .Interior.color = 65535        '����� ���� ������
        rEndCell = "end body": .Offset(0, 11) = "'= ������ ������� � ����������� ������"
        .Offset(1, 0).Resize(8, 10).EntireRow.Delete '������� 8 �����, ������ � ������� ������
        .Offset(1, 0).Resize(40, 10).EntireRow.UnMerge '������ ����������� �����
        
        Dim i As Byte
        For i = 2 To 20
            If .Offset(i, 3) = "" Then Exit For '����� ������ �� ������ ������
        Next
        
        With .Offset(i, 1)
            .Font.Size = 14: .Font.color = -16776961 '������� ���� ������
            .value = "������������� ������ � ������� ������� �� ����� �����": .VerticalAlignment = xlCenter
        End With
        
    End With
End Sub
'###################################################################
'������� ���������� ����� ��� ���������� ����� body =
Function GetHeadBodyText(sTypeMiBase As String, sInputTypeMi As String, sNameMiBase As String) As String
    GetHeadBodyText = "body" '�������� �� ���������
    
    If sTypeMiBase <> sInputTypeMi Then _
        GetHeadBodyText = GetHeadBodyText & "=" & sInputTypeMi '����������� ��
         'GetHeadBodyText = GetHeadBodyText & "=" & sNameMiBase & " " & sTypeMiBase & ", ����������� " & sInputTypeMi
End Function
'#################################################
'��������� ������� ����� ���� �� �����
Sub DeleteWrongSheet()
    Application.DisplayAlerts = False
    
    Dim ws As Worksheet
    For Each ws In ActiveWorkbook.Worksheets
        If ws.name = "svidDSpec" Then ws.Delete: Exit For
    Next
    
    Application.DisplayAlerts = True
End Sub
'#########################################################
'������� ���������� ����� ��� ������� � InputBox �����������
Function GetDefaultInput(workInstr As MeasInstrument)
    GetDefaultInput = "��� �����������" '�������� �� ���������
    
    Dim sTempStr As String, sArrTemp() As String
    sTempStr = GetFileNameWithOutExt(ActiveWorkbook.name)  '��� ������� ����� Excel ��� ���������� pr_17406-17 ���-�
    
    If InStr(sTempStr, workInstr.sFif) > 0 Then '�������� �������� ����� ���������� ���� ��
        sArrTemp = Split(sTempStr, workInstr.sFif) '������� ������ �� ������ � ���
        
        If sArrTemp(UBound(sArrTemp)) = "" Then Exit Function
        If sArrTemp(UBound(sArrTemp)) <> workInstr.sFif Then _
            GetDefaultInput = DeleteSpaceStEnd(sArrTemp(UBound(sArrTemp))) '�������� �������� �����������
    End If
End Function
'#################################################
'������� ���������, �������� �� ���� excel
Function SheetIsEmpty(ws As Worksheet) As Boolean
    SheetIsEmpty = True '�� ��������� ���� ������

    If GetExt(ActiveWorkbook.name) = "" Then Exit Function
    If Application.WorksheetFunction.CountA(ws.Range(ws.[a1], ws.[z50])) > 0 Then SheetIsEmpty = False
End Function


'###################################################################
'������� ���������� �������� ��������������� ����� ��������� �� ��������� ������
Function LoadNewTempHead(sNewProtType As String, sBaseDir As String, _
    myCurrMI As MeasInstrument, myCurrEmp As EmpDivision, myCurrCust As myCustomer, objWs As Worksheet) As Boolean
    
    Dim rTempCell As Range
    If FindCellRight("svid", rTempCell, , , , objWs) = False Then Set rTempCell = Nothing: Exit Function '������ �� ����������� ������ �������
    
    Dim iCurrBeardCnt As Integer, iNewBeardCnt As Integer, iBeardCntCopy As Integer, iCurrWsBeardStart As Integer
    iCurrBeardCnt = GetProtTypeBeardCount(sBaseDir) '���������� ����� � ������� "����������"
    iNewBeardCnt = GetProtTypeBeardCount(sBaseDir, Right(sNewProtType, 1)) '����� � "����������" ������ ���� ���������
    iCurrWsBeardStart = objWs.Cells(Rows.count, 1).End(xlUp).Row + 1 - iCurrBeardCnt + 1 '������� ������ ����������
    
    iBeardCntCopy = iCurrBeardCnt: If iNewBeardCnt > iCurrBeardCnt Then iBeardCntCopy = iNewBeardCnt '���������� ����� ��� �����������
     
    Dim sTempInstrSym As String, sTempFileName As String '����� ��� ���������
    sTempInstrSym = "pr_": If Right(sNewProtType, 1) = 2 Then sTempInstrSym = "prc_"
    If Right(sNewProtType, 1) = 3 Then sTempInstrSym = "prm_"
    
    sTempFileName = Dir(sBaseDir & sTempInstrSym & "*" & "temp" & "*"): If sTempFileName = "" Then Exit Function '���� �� ������ ������
    sTempFileName = sBaseDir & sTempFileName '������ ���� � �����-����� �������
     
    Dim objWorkBook As Object
    Set objWorkBook = Application.Workbooks.Open(sTempFileName, , True) '������� ����� � ������ ������
    
    Application.DisplayAlerts = False
    
    With objWorkBook
        .ActiveSheet.Rows("1:1").Resize(iHeadProrCnt).Copy: objWs.Rows("1:1").Resize(iHeadProrCnt).PasteSpecial
        .ActiveSheet.Rows("25:25").Resize(iBeardCntCopy).Copy '������� ����� �����
        
        objWs.Rows(iCurrWsBeardStart).PasteSpecial: .Close
    End With
    
    Application.CutCopyMode = False: Application.DisplayAlerts = True
    
    InsertBaseMIdata ActiveWorkbook, myCurrEmp, myCurrMI, False, True ' �������� � ���������� ������ ������� ������
    
    If FindCellRight("���������", rTempCell, , , , objWs) Then rTempCell = myCurrMI.sRef '��������� ����� �������� �����
    If FindCellRight("���", rTempCell, , , , objWs) Then rTempCell = myCurrMI.sFif  '����� � ��� �������� �����
    If FindCellRight("������������", rTempCell, , , , objWs) Then rTempCell = myCurrMI.sName '������������
    If FindCellRight("��������", rTempCell, , , , objWs) Then rTempCell = myCurrMI.sMetodic  '��������
    
    If FindCellRight("����� �����������", rTempCell, , , , objWs) Then _
                rTempCell = myCurrMI.sModification: rTempCell.Offset(0, 2) = myCurrMI.sType   '����� � �����
    
    With myCurrCust
        If FindCellRight("��������", rTempCell, , , , objWs) Then rTempCell = .sCustName '������������ ���������
        If FindCellRight("���", rTempCell, , , , objWs) Then rTempCell = .sCustINN '��� ���������
        If FindCellRight("�����", rTempCell, , , , objWs) Then rTempCell = .sCustAdress '����� ���������
    End With
    
    LoadNewTempHead = True: Set rTempCell = Nothing: Set objWorkBook = Nothing
End Function
'###################################################################
'������� ���������� ���������� ����� "����������" �������� ���� ���������
Function GetProtTypeBeardCount(sBaseDir As String, Optional iProtType As Integer) As Integer
    GetProtTypeBeardCount = -1 '�� ���������
    If iProtType = 0 Then iProtType = GetCurrProtType '�������� ������� ��� ����� ���������
    
    Dim sTempInstrSym As String, sTempFileName As String '������� ��� ���������
    sTempInstrSym = "pr_": If iProtType = 2 Then sTempInstrSym = "prc_"
    If iProtType = 3 Then sTempInstrSym = "prm_"
    
    sTempFileName = Dir(sBaseDir & sTempInstrSym & "*" & "temp" & "*"): If sTempFileName = "" Then Exit Function '���� �� ������ ������
    sTempFileName = sBaseDir & sTempFileName '������ ���� � �����-����� �������
    
    Dim objWorkBook As Object, iRowEnd As Integer
    Set objWorkBook = Application.Workbooks.Open(sTempFileName, , True) '������� ����� � ������ ������
    
    iRowEnd = objWorkBook.ActiveSheet.Cells(Rows.count, 1).End(xlUp).Row + 1 '��������� ����������� ������ ����� + ������ ���� - ���������
    GetProtTypeBeardCount = iRowEnd - iHeadProrCnt - 1 '���������� ����� "����������"
    
    objWorkBook.Close: Set objWorkBook = Nothing
End Function
'###################################################################
'������� ���������� ������� ��� ��������� (�������, ���������� ��� ���������)
Function GetCurrProtType() As Integer
    GetCurrProtType = -1 '�� ���������
    
    With ActiveWorkbook
        If InStr(.name, "pr_") > 0 Then GetCurrProtType = 1 '�������
        If InStr(.name, "prc_") > 0 Then GetCurrProtType = 2 '����������
        If InStr(.name, "prm_") > 0 Then GetCurrProtType = 3 '���������
    End With
End Function

'###################################################################
'��������� �������� �� ������� ����� ��������
Sub ReplaceData(Optional iConverType As Integer = -1, Optional iSourceType As Integer = -1)

    If iConverType = -1 Or iSourceType = -1 Then Exit Sub '������ �� ������������� ���������
    
    Dim sCurrFileType As String, sNewFileType As String, bRowFrom As Byte, bRowTo As Byte
    sCurrFileType = "�������": If iSourceType = 2 Then sCurrFileType = "����������"
    If iSourceType = 3 Then sCurrFileType = "���������"
    
    sNewFileType = "�������": bRowFrom = 1: bRowTo = 2
    If iConverType = 2 Then sNewFileType = "����������": bRowFrom = 2: bRowTo = 1 '�������� ����������
    If iConverType = 3 Then sNewFileType = "���������": bRowFrom = 2: bRowTo = 1 '�������� ���������

    ActiveSheet.Cells.Replace sCurrFileType, sNewFileType '�������� ��� ��������
    
    Dim rTempCell As Range, i As Byte, sSearchStr As String, sReplaceStr As String
    For i = 1 To 4 '�������� ����������� �������
        sSearchStr = ThisWorkbook.Worksheets(1).Cells(bRowFrom, i + 1) '�������� ��� ������ �� �����
        sReplaceStr = ThisWorkbook.Worksheets(1).Cells(bRowTo, i + 1) '�������� ��� ������
        
        If i < 3 Then
            ActiveSheet.Cells.Replace sSearchStr, sReplaceStr
            
        Else ' �������� ������ � ��������
            Do While FindCellRight(sSearchStr, rTempCell, , True) = True
                ThisWorkbook.Worksheets(1).Cells(bRowTo, i + 1).Copy
                rTempCell.PasteSpecial xlPasteAllExceptBorders
                
                If rTempCell.Column > 1 Then rTempCell.HorizontalAlignment = xlCenter
            Loop
        End If
    Next i
    
    Application.CutCopyMode = False: Set rTempCell = Nothing
End Sub


    Private Function FifNumByReference( _
        fifNum As String _
        ) As String
        
        FifNumByReference = fifNum
         
         
    
    End Function
'###################################################################
'������� ���������� ��� ����� ������� / ���� ������� ��� ���������� ��������
Function TemplateFileName( _
    dbinstrumentsPath As String, _
    myMi As MeasInstrument, _
    fileExt As String _
    ) As String
    
    TemplateFileName = vbNullString
    
    Dim currentTemplateFileName As String, _
        currentInstrumentDir As String, _
        fifRegNum As String
        
    fifRegNum = myMi.sFif
    If myMi.sRef <> "nodata" Then _
        fifRegNum = myMi.sRef
    
    If InStr(fifRegNum, "-") = 0 Then '���������� ������ � ��� �� ������
        
        If Len(fifRegNum) >= 8 Then
            fifRegNum = Left(fifRegNum, 8)
            fifRegNum = Replace(fifRegNum, ".", "-")
        End If
    End If
    
    currentInstrumentDir = Dir(dbinstrumentsPath & Application.PathSeparator & "*" & fifRegNum & "*", vbDirectory)  '����� �������� �� ������ ��� � ��
    
    Dim refPath As String
    refPath = fso.BuildPath(dbinstrumentsPath, currentInstrumentDir)
    refPath = fso.BuildPath(refPath, REFERENCE_FIFNUM_FILENAME)
     
    If fso.FileExists(refPath) Then _
        fifRegNum = Base.ContentFromFile(refPath)
    
    currentInstrumentDir = Dir(dbinstrumentsPath & Application.PathSeparator & "*" & fifRegNum & "*", vbDirectory)   '��������� ����� �������� �� ������ ��� � ��
    currentTemplateFileName = Dir(dbinstrumentsPath & Application.PathSeparator & currentInstrumentDir & "\*" & fifRegNum & fileExt)  '����� ������ ��������� � ��������, ��������� ����
    
    Dim isSeveralTemplates As Boolean
    Do While currentTemplateFileName <> vbNullString
    
        If Not currentTemplateFileName = vbNullString And _
            Not currentTemplateFileName Like "fif_" & "*" Then
            
            isSeveralTemplates = True
            Exit Do
'            currentTemplateFileName = vbNullString
            
        End If
    
        currentTemplateFileName = Dir
    
    Loop
    currentTemplateFileName = Dir(dbinstrumentsPath & Application.PathSeparator & currentInstrumentDir & "\*" & fifRegNum & fileExt)  '����� ������ ���������
    
    If currentTemplateFileName <> vbNullString Then _
        currentTemplateFileName = dbinstrumentsPath & Application.PathSeparator & currentInstrumentDir & "\" & currentTemplateFileName
    
    If isSeveralTemplates Then    '����� ���� ������ �����, ���� ������ ���������
        
        With myMultiSel
            .sMSBaseDir = dbinstrumentsPath & Application.PathSeparator
            .sMSfifNum = fifRegNum
            .sMSFullFileName = vbNullString
            .sMSType = myMi.sType
        End With
        
        Z_UF_MultiSelect_Load.Show '����� ������ ����� �� �����

        currentTemplateFileName = myMultiSel.sMSFullFileName
    End If
    
    TemplateFileName = currentTemplateFileName
End Function
'###################################################################
'��������� ��������� ������� � �������� ������� ����� ��������������� ����� WD � ��������� ��� ��������, ���� �� �������
Sub FillThisPathDocTempName(myInstr As MeasInstrument)

    Dim objWdApp As Object, objWdDoc As Object, sTempDocExt As String
    Set objWdApp = CreateObject("Word.Application"): Set objWdDoc = objWdApp.Documents.Add(, , , True) '������� ����� ��������
    
    sTempDocExt = Dir(ActiveWorkbook.path & "\*.doc*") '��������� �������� �� ���, ���� ���� - �������� ����������
    sTempDocExt = GetExt(sTempDocExt): If sTempDocExt = "" Then sTempDocExt = ".docx"
    
    With objWdDoc
        .BuiltinDocumentProperties("Keywords") = myInstr.sFif
        .BuiltinDocumentProperties("Comments") = myInstr.sMetodic '������ ������������ ���� ��
        
        Dim sDocNewName As String, sTempStr As String
        With myInstr
            sDocNewName = "body_": sTempStr = .sType: If .sModification <> "" Then sTempStr = sTempStr & " #!" & .sModification
            sDocNewName = sDocNewName & .sFif & " " & sTempStr
            sDocNewName = ReturnNotExistingName(ActiveWorkbook.path & "\", sDocNewName, sTempDocExt)
        End With
        
        .SaveAs sDocNewName
    End With
    
    objWdApp.Quit: Set objWdApp = Nothing: Set objWdDoc = Nothing
End Sub
Sub Commit_factory_number( _
    ) '������������� ��������� ����� �� � ������� ���������
    
    Dim serialNum As String
    serialNum = SerialNumFromSheet
    
    If serialNum = vbNullString Then _
        Exit Sub
    
    Dim currentComment() As String
    currentComment = MiComment
        
    Dim arrayIndex As Integer
    arrayIndex = LBound(currentComment)
    
    Dim currentMiName As String
    currentMiName = ActiveWorkbook.ActiveSheet.name
    
    Do While arrayIndex <= UBound(currentComment)
    
        If currentMiName = currentComment(arrayIndex) Then _
            Exit Do
            
        arrayIndex = arrayIndex + 1
    Loop
    
    Dim NewComment As String
    If arrayIndex = UBound(currentComment) Then
        NewComment = Join(currentComment, " -- ") & " -- " & serialNum
        
    Else
        currentComment(UBound(currentComment)) = serialNum
        NewComment = Join(currentComment, " -- ")
    End If
               
    SetBuiltInProperty "Comments", NewComment  ': If InStr(sSaveName, "prm_") > 0 Then sTempStr = serialNum
End Sub
    Private Function SerialNumFromSheet( _
        ) As String

        Dim serialNumCell As Range
        If FindCellRight("��������� / �������� �����:", serialNumCell) Then
                
            Dim serialNum As String
            serialNum = CStr(serialNumCell)
            
            serialNum = Replace(serialNum, "�", vbNullString)
            serialNum = Trim(serialNum)
            
            Set serialNumCell = Nothing
            
        End If
        
        SerialNumFromSheet = serialNum
    End Function
    Private Function MiComment( _
        ) As String()
        
        Dim currentComment As String
        currentComment = GetBuiltInProperty("Comments")
        DeleteSpaceStEnd currentComment
        
        MiComment = Split(currentComment, " -- ")
    End Function
        
'###################################################################
'��������� ��������� ��������� ������ ��������� �� �����
Function LoadHelpString(sStartDir As String) As String
    
    Dim sArrHelp() As String, myBase As New Z_clsmBase, iHelpInd As Integer, sStr As String
    ReDim sArrHelp(0): If FileExist(sStartDir, "info.hpDb") = False Then Exit Function '���� ���� ����������������� ��������� �������
    sArrHelp = myBase.GetArrFF(sStartDir, "info.hpDb") '�������� ������
    
    Randomize: iHelpInd = Rnd * UBound(sArrHelp): sStr = "#" & iHelpInd + 1 & ". " & sArrHelp(iHelpInd)
    LoadHelpString = DeleteSpaceStEnd(sStr): Set myBase = Nothing
End Function

'###################################################################
'��������� ��������� ���� ������� �������
Private Sub FillNormalCondition( _
    ByRef objZ_clsmSearch As Z_clsmSearch _
    )
    
    Dim sCurrCond As String, sgTemp As Single, sgHum As Single, sgPress As Single, sgBkg As Single
    
    
    
    'todo: [+] FillNormalCondition -- �������� z_clsmSearch, ������� Cache
    sCurrCond = objZ_clsmSearch.normalCondition
    
    If sCurrCond <> "����������" Then '������� ���������� �������� �� ��������
        Dim sArrTemp() As String, lb As Byte
        sArrTemp = Split(sCurrCond, InStrDelimiter): lb = LBound(sArrTemp)
        
        If Now - CDate(sArrTemp(lb)) < 0.21 Then _
            sgTemp = sArrTemp(lb + 1): sgHum = sArrTemp(lb + 2): _
            sgPress = sArrTemp(lb + 3): sgBkg = sArrTemp(lb + 4) '���� �������� �������� ������ 5 �����
    End If
    
    If sgTemp = 0 Then '�������� �� ���� ��������� �� ��������
        sgTemp = Format(GaussRnd(22.7, 0.4), "0.0") '�������� �������� �����������
        
        Select Case Month(Date) '�������� �������� ��������� �� ������ � ����
            Case 1, 2, 3, 12: sgHum = Format(GaussRnd(43.5, 0.7), "0.0") '������, �������, ����, �������
            Case 4, 5, 6, 10, 11: sgHum = Format(GaussRnd(46, 1.2), "0.0") ' ������, ���, ����, �������, ������
            Case Else: sgHum = Format(GaussRnd(55, 2), "0.0") ' ����, ������, ��������
        End Select
        
        sgPress = Format(GaussRnd(101, 0.5), "0.0") '�������� �������� ������������ ��������
        sgBkg = Format(GaussRnd(0.14, 0.007), "0.00") '�������� �������� ����
        
        sCurrCond = Now & InStrDelimiter & sgTemp & InStrDelimiter & sgHum & _
            InStrDelimiter & sgPress & InStrDelimiter & sgBkg
            
        'todo: [+] FillNormalCondition -- �������� z_clsmSearch, ������� Cache
        objZ_clsmSearch.normalCondition = sCurrCond '�������� �������� � �����
    End If
    
    Dim rMyCell As Range '�������� ����������� �������� � ������
    If FindCellRight("�����������", rMyCell) Then _
        rMyCell = sgTemp: rMyCell.Offset(1, 0) = sgHum: rMyCell.Offset(2, 0) = sgPress: rMyCell.Offset(3, 0) = sgBkg
    
    Set rMyCell = Nothing
End Sub
'###################################################################
'������� ���������� ��������� �������� ����������� �������������
Function GaussRnd( _
    sgMathExp As Double, _
    sgSigma As Double _
    ) As Double
    
    Dim r1 As Double, _
        r2 As Double, _
        pi As Double
        
    pi = WorksheetFunction.pi
    
    Randomize
    r1 = Rnd
    r2 = Rnd
    
    GaussRnd = sgMathExp + sgSigma * Cos(2 * pi * r1) * Sqr(-2 * Log(r2))
End Function

Private Sub testgauss()
    
    Dim myVal As Double, _
        mySig As Double
        
    myVal = 7
    
    Dim i As Byte
    For i = 0 To 200
        Debug.Print GaussRnd(myVal, 0.1 * myVal) + GaussRnd(myVal, 0.2 * myVal) + _
                    GaussRnd(myVal, 0.25 * myVal)
        
    Next
    
End Sub


'###################################################################
'������� ������� ��������� �������� ���������� �������� � ������������
Private Function TrueNameLength(sStr As String, iStrMaxLen As Integer, _
    Optional bolRightPart As Boolean, Optional bolComma As Boolean)

    Dim sLeftStr As String, sRightStr As String
    If Len(sStr) <= iStrMaxLen Then '���� ������������ ��������� ���������
        TrueNameLength = sStr: If bolRightPart Then TrueNameLength = sRightStr
        Exit Function '������ ����� - ������ ������
    End If

    sLeftStr = Left(sStr, iStrMaxLen): sRightStr = Right(sStr, Len(sStr) - iStrMaxLen) '��������� ������ �� ������������ ���������� ��������

    Dim sTypeInStr As String, bInputType As Byte, sNameInStr As String
    bInputType = InStr(sStr, "; ���")
    If bInputType > 0 Then
        sTypeInStr = Right(sStr, Len(sStr) - bInputType - 5)     '�������� ������ ��� �� �� ������������
        sNameInStr = Left(sStr, Len(sStr) - Len(sTypeInStr) - 6)
    End If

    If Right(sLeftStr, 1) <> "" And Left(sRightStr, 1) <> "" Then '������ ���� ������� ������

        Do While Right(sLeftStr, 1) <> " " '���������, ���� �� ����� �������� ���������� ��������
            sLeftStr = Left(sLeftStr, Len(sLeftStr) - 1)
        Loop
        DeleteSpaceStEnd sLeftStr

        Select Case Right(sLeftStr, 2)
            Case " �", " �", " �", "��"
                sLeftStr = Left(sLeftStr, Len(sLeftStr) - 2) '����� �� �������� ����� �� �����
            Case " �"
                sLeftStr = Left(sLeftStr, Len(sLeftStr) - 6) '����� �� �������� ����� �� ���.�
        End Select

        If InStr(sLeftStr, "; ��� ") > 0 And InStr(sLeftStr, sTypeInStr) = 0 Then
            sLeftStr = sNameInStr: sRightStr = "��� " & sTypeInStr
        Else
            If Right(sLeftStr, 5) = "; ���" Then sLeftStr = Left(sLeftStr, Len(sLeftStr) - 5) '����� �� �������� ����� �� ����

            If Right(sLeftStr, 11) = "�����������" Then sLeftStr = Left(sLeftStr, Len(sLeftStr) - 11)
            DeleteSpaceStEnd sLeftStr

            sRightStr = Right(sStr, Len(sStr) - Len(sLeftStr))
        End If

        DeleteSpaceStEnd sRightStr
        If bolComma And sRightStr <> "" Then sRightStr = sRightStr & ";               "
    End If
    DeleteSpaceStEnd sLeftStr: TrueNameLength = sLeftStr: If bolRightPart Then TrueNameLength = sRightStr
End Function


'1-------###################################################-------1
'������� ���������� ������ ������ ����� �������� ������
Private Function FindSvidExportRow(myWs As Worksheet) As Integer
    FindSvidExportRow = -1 '�� ��������� ���� �� ������

    With myWs
        Dim sTempStr As String, i As Byte
        sTempStr = .Cells(.Rows.count, 1).End(xlUp).text '���������� ��������� ����������� ����� ������

        If sTempStr = "svid export" Then _
            FindSvidExportRow = .Cells(.Rows.count, 1).End(xlUp).Row '�������� ����� ������

        If FindSvidExportRow = -1 Then '������� ����� ������� ����� ��������� �� ���� ��������
            i = 5 '��������� ������ ��� ������

            Do While i < 30
                sTempStr = .Cells(i, 1).text
                If sTempStr = "svid export" Then _
                    FindSvidExportRow = .Cells(i, 1).Row: Exit Function '�������� ����� ������
                i = i + 1
            Loop

        End If
    End With
End Function


