VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cNumNameProtocol"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const PROT_PREF_VER = "pr_"
Const PROT_PREF_CAL = "prc_"
Const PROT_PREF_MEAS = "prm_"

Const JRN_PREF_VER = "jr_"
Const JRN_PREF_CAL = "jrc_"
Const DELIMITER_FILENAME = "_"

Const COMMENT_SEPARATOR = " -- "

Public Enum EProtocolTypes

    verifying
    calibration
    measurement
    unknown
    
End Enum

Const ORGANISATION_CELL_KEY = "�������"
Const FACTORY_NUMCELL_KEY = "��������"
Const PROT_NUMCELL_KEY = "����� ���������"

Private m_typeDoc As EProtocolTypes, _
        m_filePrefix As String

Private m_organisation As String, _
        m_typeInstrument As String, _
        m_factoryNumber As String

Private m_protocolNumberCell As Range
Private fso As New FileSystemObject

Private Sub Class_Initialize()
    
    GetProtocolType
    GetFilePrefix
    
    GetOrganisation
    GetTypeIntrument
    GetfactoryNumber
    
    GetProtocolNumberCell
    
End Sub
    Private Sub GetProtocolType()
    
        Dim fileName As String
        fileName = ActiveWorkbook.name
        
        m_typeDoc = unknown
        Select Case True
            
            Case InStr(fileName, PROT_PREF_VER) > 0, InStr(fileName, JRN_PREF_VER) > 0
                m_typeDoc = verifying
        
            Case InStr(fileName, PROT_PREF_CAL) > 0, InStr(fileName, JRN_PREF_CAL) > 0
                m_typeDoc = calibration
            
            Case InStr(fileName, PROT_PREF_MEAS) > 0
                m_typeDoc = measurement

        End Select
    
    End Sub
    Private Sub GetFilePrefix()
        
        m_filePrefix = vbNullString
        
        If m_typeDoc <> unknown Then _
            m_filePrefix = Left(ActiveWorkbook.name, InStr(ActiveWorkbook.name, DELIMITER_FILENAME))
            
    End Sub
    ' ----------------------------------------------------------------
    ' ����: 18.02.2023 18:05
    ' ����������: �������� ����������� �� �������� �����
    ' ----------------------------------------------------------------
    Private Sub GetOrganisation()
        
        m_organisation = Base.defaultValue

        Dim result As String
        result = Properties.Company
        
        If result <> vbNullString Then _
            m_organisation = Trim(result)
        
'        Dim searchResult As Range
'        Set searchResult = FindCell( _
'            findKey:=ORGANISATION_CELL_KEY, _
'            searchAtPrintArea:=True _
'            )
'
'        If searchResult Is Nothing Then _
'            Exit Sub
        
        
    
    End Sub
        ' ----------------------------------------------------------------
        ' ����: 18.02.2023 17:36
        ' ����������: ����� ������ � ������� ��������� �����
        '    �������� findKey: ��������� ������ -- �����
        '    �������� lookType: xlPart ��� xlWhole
        '    �������� searchAtPrintArea: True ��� False
        ' ������������ ���: Range
        ' ----------------------------------------------------------------
        Private Function FindCell( _
            findKey As String, _
            Optional lookType = xlPart, _
            Optional searchAtPrintArea = False _
            ) As Range
            
            Set FindCell = Nothing

            Dim searchRange As Range
            Set searchRange = ActiveWorkbook.ActiveSheet.UsedRange
            
            If searchAtPrintArea Then
                
                If ActiveWorkbook.ActiveSheet.PageSetup.PrintArea <> vbNullString Then _
                    Set searchRange = Range(ActiveWorkbook.ActiveSheet.PageSetup.PrintArea)
                
            End If
            
            Dim result As Range
            Set result = searchRange.Find(findKey, LookAt:=lookType, LookIn:=xlValues)
            
            Set FindCell = result
            
        End Function
    ' ----------------------------------------------------------------
    ' ����: 18.02.2023 17:59
    ' ����������: �������� ��� (�����������) �� �� ����������� ���������
    ' ----------------------------------------------------------------
    Private Sub GetTypeIntrument()
        
        m_typeInstrument = Base.defaultValue
        Properties.SetTargetWorkbook ActiveWorkbook
        
        Dim comment As String
        comment = Properties.Comments
       
        Dim instrDelitimer As Integer
        instrDelitimer = InStr(comment, COMMENT_SEPARATOR)
        
        m_typeInstrument = comment '���� ��������� ����� �� ��� ����� �����, �� ��������� ������ ������ �� ����
        If CBool(instrDelitimer) Then _
            m_typeInstrument = Trim(Left(comment, instrDelitimer))

        
    End Sub
    ' ----------------------------------------------------------------
    ' ����: 18.02.2023 18:01
    ' ����������: �������� ��������� ����� � �������� �����
    ' ----------------------------------------------------------------
    Private Sub GetfactoryNumber()
        
        m_factoryNumber = Base.defaultValue

        Dim searchResult As Range
        Set searchResult = FindCell( _
            findKey:=FACTORY_NUMCELL_KEY, _
            searchAtPrintArea:=True _
            )
        
        If searchResult Is Nothing Then _
            Exit Sub
        
        Dim result As String
        result = Trim(searchResult.Offset(0, 1))
        
        If result <> vbNullString Then _
            m_factoryNumber = result

    End Sub
    Private Sub GetProtocolNumberCell()
        
        Set m_protocolNumberCell = Nothing
        
        Dim searchResult As Range
        Set searchResult = FindCell( _
            findKey:=PROT_NUMCELL_KEY, _
            lookType:=xlWhole _
            )
        
        If searchResult Is Nothing Then _
            Exit Sub
            
        Set m_protocolNumberCell = searchResult.Offset(-1, 0)

    End Sub
'=====================================================
Friend Property Get typeDoc() As EProtocolTypes
    typeDoc = m_typeDoc
End Property

Friend Property Get filePrefix() As String
    filePrefix = m_filePrefix
End Property

Friend Property Get organisation() As String
    organisation = m_organisation
End Property

Friend Property Get typeInstrument() As String
    typeInstrument = m_typeInstrument
End Property

Friend Property Get factoryNumber() As String
    factoryNumber = m_factoryNumber
End Property

'            '=====================================================
'            Private Sub SendToFile( _
'                )
'
''                If m_numberCore = vbNullString Then _
''                    Exit Sub '������
'
'                Dim newNum As String
'                'newNum = FullNumber
'            '
'            '    Protocol.FillNumberToSheet newNum
'            '
'            '    SendToSheet newNum '��������� � ������ ������
'            '    '=====================
'            '    'SendFactoryNumberToComment '��������� ��������� ����� � ����������� ���������
'            '    '=====================
'            '    RenameActiveDocument ProtocolFileMask '��������� � ��� �����
'
'                If UMenu.isLoaded Then _
'                    UMenu.Unload
'
'            End Sub

' ----------------------------------------------------------------
' ����: 18.02.2023 18:15
' ����������: �������� ����� ��������� � ������
'    �������� fullnumberCore: ��������� ��������
' ----------------------------------------------------------------
Friend Sub SendNumberToSheet( _
    FullNumber As String _
    )
    
    Dim targetCell As Range
    Set targetCell = m_protocolNumberCell
    
    If targetCell Is Nothing Then _
        Set targetCell = ActiveCell
    
    targetCell = FullNumber
    
End Sub
' ----------------------------------------------------------------
' ����: 18.02.2023 23:46
' ����������: �������� �������� � ��������� ������ � �����������
' ----------------------------------------------------------------
Friend Sub SendFactoryNumberToComment( _
    )
    Dim commentData As String
    commentData = CommentInstrumentData

    Properties.Comments = commentData
    
End Sub
    Private Function CommentInstrumentData( _
        ) As String
        
        Dim data As String
        data = Trim(Properties.Comments)
        
        If data = vbNullString Then _
            Exit Function
        
        Dim newComment As String
        newComment = ClearedComment(data)
        
        CommentInstrumentData = newComment & COMMENT_SEPARATOR & m_factoryNumber
        
    End Function
        Private Function ClearedComment( _
            comment As String _
            ) As String
            
            Dim commentData() As String
            commentData = Split(comment, COMMENT_SEPARATOR)
            
            If ArrayLength(commentData) = 1 Then _
                ClearedComment = comment: _
                Exit Function '���-��6101�
            
            If ArrayLength(commentData) = 2 Then ' ���-��6101� -- 6689   ���   ����-3 -- Am-241
                
                If commentData(LBound(commentData)) <> ActiveWorkbook.ActiveSheet.name Then _
                    ClearedComment = comment: _
                    Exit Function '����-3 -- Am-241
                
            End If
            
            ReDim Preserve commentData(UBound(commentData) - 1) '����-3 -- Am-241 -- 6689     ���        ���-��6101� -- 6689
            ClearedComment = Join(commentData, COMMENT_SEPARATOR)
            
        End Function
            Private Function ArrayLength( _
                sourceArray() As String _
                )
                
                ArrayLength = UBound(sourceArray) - LBound(sourceArray) + 1
                
            End Function
' ----------------------------------------------------------------
' ����: 18.02.2023 23:55
' ����������:
'    �������� fileMask: ��� ����� ��� ����������
'    �������� saveAsCopy:
' ----------------------------------------------------------------
Friend Sub RenameFile( _
    fileMask As String, _
    Optional saveAsCopy As Boolean = False _
    )
    
    If ActiveWorkbook.name = ThisWorkbook.name Then _
        Handler.Notify "�������������� ���������� ���������.": _
        Exit Sub

    If ActiveWorkbook.path = vbNullString Then _
        Handler.Notify "������� (���������) ���� ������ �������������.": _
        Exit Sub

    Dim oldPath As String
    oldPath = ActiveWorkbook.FullName
    
    Dim newPath As String
    newPath = FileNewPath(fileMask)
    
    If oldPath = newPath Then _
        ActiveWorkbook.Save: _
        Exit Sub

    ActiveWorkbook.SaveAs _
        fileName:=newPath, _
        FileFormat:=xlOpenXMLWorkbook

    If Not saveAsCopy Then _
       Kill oldPath

End Sub
    Private Function FileNewPath( _
        fileMask As String _
        ) As String

        FileNewPath = ActiveWorkbook.FullName
        
        If fileMask = vbNullString Then _
            Exit Function

        Dim fileDir As String
        fileDir = ActiveWorkbook.path

        Dim fileExt As String
        fileExt = "." & fso.GetExtensionName(ActiveWorkbook.name)

        Dim result As String
        result = CheckedPath(fileDir, fileMask, fileExt) '�������� �� ������������� ����� ����� � ����������

        FileNewPath = result

    End Function
        ' ----------------------------------------------------------------
        ' ����: 19.02.2023 15:30
        ' ����������: �������� ����� ������ ����� �� ������������
        '    �������� fileDir: �������, ��� ����� ��������� ����
        '    �������� fileMask: ��� ����� ��� ����������
        '    �������� fileExt: .xlsx
        ' ������������ ���: String
        ' ----------------------------------------------------------------
        Private Function CheckedPath( _
            fileDir As String, _
            fileMask As String, _
            fileExt As String _
            ) As String
            
            CheckedPath = Base.defaultValue
            
            Dim result As String
            result = fso.BuildPath(fileDir, fileMask & fileExt)
            
            Dim i As Integer: i = 1
            Do
            
                If Not fso.FileExists(result) Then _
                    Exit Do
                    
                result = fso.BuildPath(fileDir, fileMask & " (" & i & ")" & fileExt)
                i = i + 1
                
            Loop
            
            CheckedPath = result
            
        End Function
