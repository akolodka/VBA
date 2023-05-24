Attribute VB_Name = "z_Old_CommonProject_Code"
Option Explicit '������ �� ������������� ������� ����������

#If VBA7 Then
    Private Declare PtrSafe Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
    Private Declare PtrSafe Function IsIconic Lib "user32.dll" (ByVal hwnd As Long) As Long
#Else
    Private Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
    Private Declare Function IsIconic Lib "user32.dll" (ByVal hwnd As Long) As Long
#End If

Const SW_RESTORE = 9
Const DEFAULT_VALUE = "nodata"
Const REFERENCE_FIFNUM_FILENAME = "fifRegNum.ref"

Public myMenu As frmLoadType, myMultiSel As MyMultiSelectProperties
Public bolUF_Set_Load As Boolean, bolUF_Cnstr_Load As Boolean, isWorkFormLoaded As Boolean
Public bolBackSpace As Boolean, bolAlreadySaved As Boolean

Type MyMultiSelectProperties '������ ����������, ����������� ������ ������������
    sMSBaseDir As String: sMSfifNum As String: sMSAdditionalText As String: sMSFullFileName As String: bolThisWBSheetLoad As Boolean: sMSType As String
    templates As String
End Type

Type HeadVerName '������ ����������, ����������� ������ ������������� � ���������� ���������
    sHeadState As String: sHeadName As String: sVerName As String: sVerSecName As String
End Type

Type EmpDivision '������ ����������, ����������� ����� ������ � �����������
    sDepPref As String: sLabNum As String
End Type

Type MeasInstrument '������ ����������, ����������� 4 ��������� �������� ���������
    sName As String: sType As String: sFif As String: sMetodic As String: sModification As String: sRef As String
    bolEtal As Boolean
End Type

Type frmLoadType '��� ������������ ����
    type As Byte
End Type

Type StartWorkDirs '��������� � ������� ����������
    sStartDir As String
    sWorkDir As String
    templates As String
    protocolBaseDir As String
End Type

Type myPrintShift
    iShiftX As Integer: iShiftY As Integer
End Type


'##########################################################################
'������� ���������� ������� �������� �� ���������
Function setDir()
    setDir = Environ("APPDATA") & "\Microsoft\�������� ���\"
End Function

Function configDirNew( _
    ) As String
    
    configDirNew = Environ("APPDATA") & "\Microsoft\�������� ���\"
    
    If Dir(configDirNew, vbDirectory) = vbNullString Then _
        MkDir configDirNew
    
End Function

'##########################################################################
'����������� ������ ������ � ����������� ������
Function InStrDelimiter()
    InStrDelimiter = Chr(9)
End Function
'##########################################################################
'������� ��� �������������� �������������
Function BoundShiftX()
    BoundShiftX = 5
End Function
Function BoundShiftY()
    BoundShiftY = 7
End Function
'##########################################################################
'##########################################################################
'������� ��������� �� ������������� ����, ������������� �� ���������� ����
Function FileExist(fPath As String, Optional fName As String) As Boolean
    FileExist = False

    If fName = "����������" Then Exit Function
    If fName <> "" Then '������� �������� ���� � �������� ��� �����
        If Right(fPath, 1) <> "\" Then fPath = fPath & "\" '�� ������, ���� � ����� ���� ��� �����
        If Dir(fPath & fName) <> "" Then FileExist = True
    Else '������� ������ ���� �����
        If fPath <> "����������" Then _
            If Dir(fPath) <> "" Then FileExist = True
    End If
End Function
'##########################################################################
'������� ��������� �� ������������� ����, ������������� �� ���������� ����
Function FolderNotExist( _
    folderPath As String _
    ) As Boolean
    
    FolderNotExist = True
    
    If Dir(folderPath, vbDirectory) <> vbNullString Then _
        FolderNotExist = False
End Function
'##########################################################################
'������� ������������� ���� ������ �����
Function GetFileFPath( _
    ControlIndex As Byte, _
    sBaseDir As String, _
    Optional sTitle As String _
    ) As String
    
    With Application.FileDialog(msoFileDialogFilePicker)
    
        .Filters.Clear
        .InitialView = msoFileDialogViewDetails
        
        .Title = "����� ��������� ������"
        
        If sTitle <> vbNullString Then _
            .Title = sTitle
        
        .AllowMultiSelect = False
        .InitialFileName = sBaseDir
        
        Select Case ControlIndex
            
            Case 1, 2 '������� ���� �������� ����������
                .Filters.Add "�������� ����������", "*.cuDb; *.o13Db", 1
            
            Case 3, 4 '������� ���� �������� ��
                .Filters.Add "�������� � ��������� ���������", "*.miDb", 1
            
            Case 5, 6 '������� ���� �������� ��������
                .Filters.Add "�������� �� ��������", "*.etDb", 1
            
            Case 7, 8 '������� ���� �������� �������
                .Filters.Add "�������� � �������� � ����������", "*.nmDb", 1
            
            Case 9 '������������ ���������
                .Filters.Add "����� ������������", "*.uCfg", 1
            
            Case 10 '�������� Word
                .Filters.Add "��������� Word", "*.doc*", 1
            
            Case 11 '������ ��������� xl
                .Filters.Add "����� Excel", "*.xls*", 1
        
        End Select
        
        If .Show = False Then _
            GetFileFPath = "NoPath": _
            Exit Function
            
        GetFileFPath = .SelectedItems(1) '������ ���� � �����
    End With
    
End Function
'##########################################################################
'������� ������������� ���� ������ ��������
Function GetFolderFPath(Optional sTitle As String, Optional StartFolder As String, Optional Somnium As Boolean)
    With Application.FileDialog(msoFileDialogFolderPicker)
    
        .Filters.Clear: .InitialView = msoFileDialogViewDetails
        .Title = "����� ���������� ����������"
        If sTitle <> "" Then .Title = sTitle
        
        .InitialFileName = StartFolder
        If StartFolder = "" Or StartFolder = "����������" Then
            .InitialFileName = "C:\Users\" & Environ("USERNAME") & "\Desktop\"
            If Somnium Then .InitialFileName = "\\somnium\irlab\���������\"
        End If

        .AllowMultiSelect = False
        If .Show = 0 Then GetFolderFPath = "NoPath": Exit Function
        
        GetFolderFPath = .SelectedItems(1) '���� � ��������
    End With
End Function
'##########################################################################
'��������� ��������� ���������� ���������� ������� ������� �������
Sub SortMassBiv(ByRef arrToSort() As String, _
    Optional arrSortLevel As Integer = 0, Optional SortByNumeric As Boolean = False, Optional SortByDecrease = True)
    
    '�� ��������� ���������� ��� �� ������� ������, ��������� ��������� � �� ��������
    Dim K As Integer, i As Integer, j As Integer, iArrLEdge As Integer, iArrUEdge As Integer, iStep As Integer, jP As Integer
    ReDim arrTempSort(UBound(arrToSort())) '������� �������������� ������
    
    iArrLEdge = LBound(arrToSort, 2) + 1 '������ ������� ������� ��������� �������
    iArrUEdge = UBound(arrToSort, 2) '������� ������� ������� ��������� �������
    iStep = 1 '������ ���
    
    If SortByDecrease = False Then  ' ���� ������� ����� ���������� �� �����������
        iArrLEdge = UBound(arrToSort, 2) - 1: iArrUEdge = LBound(arrToSort, 2): iStep = -1 '�������� ���
    End If
    
    For i = iArrLEdge To iArrUEdge Step iStep '�������� �� ���� ��������� ������� � ����� iStep
        j = i
        Do
            If j = iArrLEdge - iStep Then Exit Do '���� ��������������� ����� ������ ������� - ����� �� �����
            
            jP = j - 1 '�� ��������� ���������� �� ��������
            If SortByDecrease = False Then jP = j + 1
            
            If SortByNumeric = True Then '���������� ��� �� ������
            
                If arrToSort(LBound(arrToSort), jP) <> 0 Then '���� ���������� ������� �� ������
                    If arrToSort(LBound(arrToSort), j) = 0 Then Exit Do '���� ������� ������� - ������� �������
                    If CDbl(arrToSort(arrSortLevel, jP)) < CDbl(arrToSort(arrSortLevel, j)) Then Exit Do '���� ���������� ������� ������ ��������
                    
                    If CDbl(arrToSort(arrSortLevel, jP)) = CDbl(arrToSort(arrSortLevel, j)) Then '���������� ������������
                        If arrSortLevel + 1 <= UBound(arrToSort) Then '���������� ����� ��������� �������
                            If CDbl(arrToSort(arrSortLevel + 1, jP)) < CDbl(arrToSort(arrSortLevel + 1, j)) Then Exit Do
                        End If
                    End If
                End If
            Else '���������� �� ������
                
                If arrToSort(LBound(arrToSort), jP) <> "" Then '���� ���������� ������� �� ������
                    If arrToSort(LBound(arrToSort), j) = "" Then Exit Do '���� ������� ������� - ������ �������
                    If Format(arrToSort(arrSortLevel, jP), ">") < Format(arrToSort(arrSortLevel, j), ">") Then Exit Do '���� ���������� ������� ������ ��������
                    
                    If LCase(arrToSort(arrSortLevel, jP)) = LCase(arrToSort(arrSortLevel, j)) Then '���������� ������������
                        If arrSortLevel + 1 <= UBound(arrToSort) Then '���������� ����� ��������� �������
                            If LCase(arrToSort(arrSortLevel + 1, jP)) < LCase(arrToSort(arrSortLevel + 1, j)) Then Exit Do
                        End If
                    End If
                End If
            End If
            
            For K = LBound(arrToSort) To UBound(arrToSort) '������ ��������� ������������ �������
                arrTempSort(K) = arrToSort(K, j) '��������� ������
                arrToSort(K, j) = arrToSort(K, jP): arrToSort(K, jP) = arrTempSort(K)
            Next K
            
            j = jP
        Loop
    Next i
End Sub
'##########################################################################
'���������� ����������� ������� ������� �������
Sub SortMassOne(arrToSort() As String, Optional SortByIncrease As Boolean, Optional PrimaryString As Boolean)
    '�� ��������� ���������� ��� �� ��������
    
    Dim iArrLEdge As Integer, iArrUEdge As Integer, iStep As Integer
    iArrLEdge = LBound(arrToSort) + 1 '������ ������� ������� ��������� �������
    iArrUEdge = UBound(arrToSort) '������� ������� ������� ��������� �������
    iStep = 1 '������ ���
    
    If SortByIncrease Then '���������� �� �����������
        iArrLEdge = UBound(arrToSort) - 1: iArrUEdge = LBound(arrToSort): iStep = -1 '�������� ���
    End If


    Dim sTemp As String, i As Integer, j As Integer, jP As Integer
    
    For i = iArrLEdge To iArrUEdge Step iStep '���������� ��� �� � ��������, � � ������� ��������
        j = i
        
        Do
            If j = iArrLEdge - iStep Then Exit Do '���� ��������������� ����� ������ �������
            
            jP = j - 1 '�� ��������� ���������� �� ��������
            If SortByIncrease Then jP = j + 1 '���������� �� �����������
            If arrToSort(j) = "" Then Exit Do '���� ������� ������� - ������ �������
            
            If arrToSort(jP) <> "" Then '���� ���������� ������� ��������
            
                If PrimaryString And InStr(arrToSort(j), "���") > 0 Then '���� � ���������� ���� ���
                    If InStr(arrToSort(jP), "���") > 0 And _
                        LCase(arrToSort(jP)) < LCase(arrToSort(j)) Then Exit Do '���� � ����� ��������� ���� ���
                        
                    If InStr(arrToSort(jP), "���") > 0 Then Exit Do    '���� � ������� ��� ��� - ����� �� �����
                Else '������� ����������
                    If LCase(arrToSort(jP)) < LCase(arrToSort(j)) Then Exit Do   '���� ���������� ������� ������ ��������
                End If
            End If
            
            sTemp = arrToSort(j)  '�������� ���������� ��������
            arrToSort(j) = arrToSort(jP)
            arrToSort(jP) = sTemp
            j = jP
        Loop
    Next i
End Sub

'##########################################################################
'������� ������� ���������� ������� � ������ � ����� ������
Function DeleteSpaceStEnd(ByRef stringValue As String, Optional noDataForNull As Boolean) As String

    Dim i As Integer, sSym As String
    If stringValue <> "" Then
    
        Select Case Len(stringValue) '���������� �������� � �������� ������
            Case 1
                If Asc(stringValue) <= 32 Then stringValue = "" '���� ��� ������� ���� �� ���������� ��������
            Case Else
                sSym = ""
                Do '1) ������ �����
                    sSym = Left(stringValue, 1)
                    If Asc(sSym) > 32 Then Exit Do
                    If Asc(sSym) <= 32 Then _
                        stringValue = Right(stringValue, Len(stringValue) - 1)
                    If Len(stringValue) < 1 Then Exit Do
                Loop
                
                sSym = ""
                Do '1) ������ ������
                    If stringValue = "" Then Exit Do
                    sSym = Right(stringValue, 1)
                    If Asc(sSym) > 32 Then Exit Do
                    If Asc(sSym) <= 32 Then _
                        stringValue = Left(stringValue, Len(stringValue) - 1)
                    If Len(stringValue) < 1 Then Exit Do
                Loop
        End Select
        
    End If
    
    If noDataForNull Then
        If stringValue = "" Then stringValue = DEFAULT_VALUE
    End If
    
    DeleteSpaceStEnd = stringValue '�������� ������������ ��������
End Function
'##########################################################################
'������� ���������� ��������� ������ ������ ����� � ����������� �� ������������� �������
Function ShortedString( _
    strData As String, _
    maxLength As Byte _
    ) As String
    
    ShortedString = strData ' �� ��������� ���������� ��� ������ '�������� ���� ��������� ���������
    
    Dim leftPart As String, _
        rightPart As String, _
        iStrStart As Integer
        
    If Len(strData) > maxLength Then '����� �� ��������� ���������
        
        iStrStart = InStr(strData, "\")
        If iStrStart = 0 Then _
            Exit Function
        
        If iStrStart + 2 <= Len(strData) Then _
            leftPart = Left(strData, InStr(iStrStart + 2, strData, "\")) '������������ ����� ����� ������
        
        If maxLength - Len(leftPart) - 5 >= 0 Then _
            rightPart = Right(strData, maxLength - Len(leftPart) - 5) ' ����� �� ���� ������ � ������ �������� ������

        ShortedString = leftPart & " ... " & rightPart
    End If
End Function


'#######################################################
'������� ������������� ���� ���������� ����� � ������ ������������
Function GetSaveAsFname( _
    DataBaseType As Byte, _
    Optional sBasePath As String _
    )
    
    Dim sStrAddition As String, sStrExt As String, sStrCaption As String
    Select Case DataBaseType
        Case 1, 2 '�� ����������
            sStrAddition = "_customers": sStrExt = ".cuDb": sStrCaption = "������ ����������:"
        Case 3, 4 '�� ������� ���������
            sStrAddition = "_instruments": sStrExt = ".miDb": sStrCaption = "������ ������� ���������:"
        Case 5, 6 '�� ��������
            sStrAddition = "_etalons": sStrExt = ".etDb": sStrCaption = "������ ��������:"
        Case 7, 8 '�������
            sStrAddition = "_employees": sStrExt = ".nmDb": sStrCaption = "������ ������� � ����������:"
        Case 9 '������� ������������
            sStrAddition = "_pkrconfig": sStrExt = ".uCfg": sStrCaption = "������������ ���������:"
    End Select
    
    GetSaveAsFname = InputBox("������� ��� ��� ����� " & sStrCaption, "���������� ������ ����� ���� ������", Environ("USERNAME") & sStrAddition)
    If GetSaveAsFname <> "" Then
        If sBasePath = "" Then
            GetSaveAsFname = setDir & GetSaveAsFname & sStrExt: Exit Function
        Else
            GetSaveAsFname = sBasePath & GetSaveAsFname & sStrExt: Exit Function
        End If
    End If
    GetSaveAsFname = "NoPath" '�� ���������
End Function
'#######################################################
'������� �������� ��� ����� ���� ������ �� ����
Function TrueName(fPath As String)
    If InStr(fPath, "\") = 0 Then Exit Function
    TrueName = Right(fPath, InStr(2, StrReverse(fPath), "\") - 1) '��� ��� �����
End Function
'############################################################
'������� ������������ ����� ��� ������ ��������� � ���������� ����������
Function RusPadejPozition(value As Integer)
    Select Case Right(value, 1)
        Case 1
            RusPadejPozition = value & " �������.": If Len(CStr(value)) >= 2 Then _
                If Right(CStr(value), 2) = 11 Then RusPadejPozition = value & " �������."
                
        Case 2 To 4
            RusPadejPozition = value & " �������.": If Len(CStr(value)) >= 2 Then _
                If Right(CStr(value), 2) >= 12 And Right(CStr(value), 2) <= 14 Then RusPadejPozition = value & " �������."
                
        Case Else
            RusPadejPozition = value & " �������."
    End Select
End Function
'##########################################################################
'������� ������������ ����� ��� ������ ���������� � ���������� ����������� ������
Function RusPadejCoincidence(number As Integer, objLabel As Object)
    objLabel.foreColor = &H80000012 ' - ������
    
    Select Case number
        Case 0
            RusPadejCoincidence = "��� ����������"
        Case 1
            RusPadejCoincidence = "������� Enter"
            TrueElementForeColor objLabel
        Case 21, 31, 41, 51, 61, 71
            RusPadejCoincidence = "������� " & number & " �������"
        Case 2 To 4, 22 To 24, 32 To 34, 42 To 44, 52 To 54
            RusPadejCoincidence = "������� " & number & " �������"
        Case Else
            RusPadejCoincidence = "������� " & number & " �������"
    End Select
End Function
'#########################################################
'��������� ��������� �������� � ������������� ��������
Sub CheckTempDir( _
    sStartDir As String, _
    ByRef sArrData() As String _
    )
    
    SortMassBiv sArrData, 1 '����������� ������ �� ���� ��
    
    Dim i As Byte, sTempPath As String, sTempDir As String, sFifNum As String, sTempStr As String, sTypeName As String
    Dim bolMp As Boolean, bolOT As Boolean, bolTMP As Boolean, referenceRegFifNum As String, bolRef As Boolean, sRefDir As String, sRefPath As String
    
    For i = LBound(sArrData, 2) To UBound(sArrData, 2) '��� ������� �����
    
        bolMp = False
        bolOT = False
        bolTMP = False
        bolRef = False
        
        sTempStr = vbNullString
        
        sFifNum = sArrData(LBound(sArrData) + 2, i)
        sTypeName = sArrData(LBound(sArrData) + 1, i)
        sArrData(UBound(sArrData), i) = DEFAULT_VALUE '�� ��������� ������ ������� ����������
        referenceRegFifNum = sArrData(LBound(sArrData) + 4, i) '����������� ������
        
        sTempDir = Dir(sStartDir & "*" & sFifNum & "*", vbDirectory) '������� ��
        sRefDir = Dir(sStartDir & "*" & referenceRegFifNum & "*", vbDirectory) '������� ����������� ������
        
        If sTempDir <> vbNullString Then '������� � ������� � ��� ���������
            
            sTempPath = sStartDir & sTempDir  '������� � ������� � ���
            sRefPath = sStartDir & sRefDir '������� ����������� ������
            
            If Dir(sTempPath & "\mp_" & sFifNum & "*") <> vbNullString Then bolMp = True    '������� ��������
            If Dir(sTempPath & "\ot_" & sFifNum & "*") <> vbNullString Then bolOT = True    '������� �������� ����
            
            If Dir(sTempPath & "\pr" & "*" & sFifNum & "*.xls*") <> vbNullString Or _
                    Dir(sTempPath & "\body" & "*" & sFifNum & "*.xls*") <> vbNullString Then bolTMP = True '������� ��������
            
            If Dir(sRefPath & "\pr" & "*" & referenceRegFifNum & "*.xls*") <> vbNullString Or _
                    Dir(sRefPath & "\body" & "*" & referenceRegFifNum & "*.xls*") <> vbNullString Then bolRef = True '������� ������������ �������

            If bolMp Then sTempStr = "��" '���� �������� ������� �������� �������
            
            If bolOT Then '���� �������� ������� �������� ����
                If sTempStr <> vbNullString Then sTempStr = sTempStr & "+"
                sTempStr = sTempStr & "��"
            End If
            
            If bolRef Then '�������� ������� ����������� ������ - ��������� ��������
                If sTempStr <> vbNullString Then sTempStr = sTempStr & "+"
                sTempStr = sTempStr & "��*"
            Else
                If bolTMP Then '�������� ������� �������
                    If sTempStr <> vbNullString Then sTempStr = sTempStr & "+"
                    sTempStr = sTempStr & "��"
                End If
            End If

            If sTempStr <> vbNullString Then sArrData(UBound(sArrData), i) = sTempStr
        End If
    Next
End Sub
'#########################################################
'��������� ��������� ����������� ����������� �������
Sub ReduceArrOne(ByRef sArrToReduce() As String)
    Do While sArrToReduce(UBound(sArrToReduce)) = ""
        If UBound(sArrToReduce) = 0 Then Exit Do
        ReDim Preserve sArrToReduce(UBound(sArrToReduce) - 1)
    Loop
End Sub
'#########################################################
'������� ��������� � ������ ����������� � ����� ����� �������
Function ReplaceBadSymbols(sTempStr As String) As String
    
    sTempStr = Replace(sTempStr, "\", "_"): sTempStr = Replace(sTempStr, "/", "_")
    sTempStr = Replace(sTempStr, ":", "_"): sTempStr = Replace(sTempStr, "*", "_")
    sTempStr = Replace(sTempStr, "?", "_"): sTempStr = Replace(sTempStr, "<", "_")
    sTempStr = Replace(sTempStr, ">", "_"): sTempStr = Replace(sTempStr, "|", "_")
    sTempStr = Replace(sTempStr, """", "_")
    
    ReplaceBadSymbols = sTempStr
End Function
'#########################################################
'��������� ������� ������������� �������� � �������
Sub ReplaceRepeateInArrOne(ByRef sArray() As String, Optional sReplaceText As String = DEFAULT_VALUE, Optional CompareWoExt As Boolean)
    
    Dim i As Integer, j As Integer, bRepeateCnt As Byte, sBaseStr As String, sCompareStr As String
    For i = LBound(sArray) To UBound(sArray)
        bRepeateCnt = 0
        
        For j = LBound(sArray) To UBound(sArray)
            If sArray(i) = "" Then Exit For
            
            sBaseStr = sArray(i): sCompareStr = sArray(j)
            If CompareWoExt Then sBaseStr = GetFileNameWithOutExt(sArray(i)): sCompareStr = GetFileNameWithOutExt(sArray(j))
            
            If sBaseStr = sCompareStr Then bRepeateCnt = bRepeateCnt + 1
        Next j
        
        If bRepeateCnt > 1 Then sArray(i) = sReplaceText
    Next i
End Sub
'#########################################################
'��������� ��������� ��������� ������, ���������� ��������� � ������ ������� ��������
Sub FindInBivArr( _
    sArrWhereToFind() As String, _
    ByRef sArrWhereAddResults() As String, _
    sStrToSearch As String, _
    Optional sStrExc As String = DEFAULT_VALUE _
    )
        
    If sArrWhereToFind(LBound(sArrWhereToFind), UBound(sArrWhereToFind, 2)) = "" Then _
        Exit Sub '������ �� ��� �������
    
    Dim sArrSplit() As String, _
        sArrTemp() As String '��������� ��������� �������
        
    sArrSplit = Split(sStrToSearch, " ")
    ReplaceRepeateInArrOne sArrSplit
    SortMassOne sArrSplit
    
    ReduceArrOne sArrSplit
    ReDim sArrTemp(UBound(sArrSplit), 1)
    
    Dim i As Integer, _
        j As Integer, _
        K As Integer, _
        bolIsFinded As Boolean, _
        iCoincedenceCnt As Integer, _
        bolExitFor As Boolean, _
        b As Integer

    For i = LBound(sArrWhereToFind, 2) To UBound(sArrWhereToFind, 2) '�������� �� ������� ��������� ���������� �������
        
        For K = LBound(sArrTemp) To UBound(sArrTemp) '�������� �� ������� ��������� ��������
            
            sArrTemp(K, 0) = sArrSplit(K)
            sArrTemp(K, 1) = False '�������� ��������� ��������
            
        Next K
        
'        Dim bUbound As Byte
'        bUbound = UBound(sArrWhereToFind): If UMenu.typ� = instrumentsOLD Then bUbound = LBound(sArrWhereToFind) + 3
        
        For j = LBound(sArrWhereToFind) To UBound(sArrWhereToFind) '�������� �� ������� ��������� ���������� �������
            
            For K = LBound(sArrTemp) To UBound(sArrTemp) '�������� �� ������� ��������� ��������
                If LCase(sArrTemp(K, 0)) <> sStrExc Then _
                    If InStr(LCase(sArrWhereToFind(j, i)), LCase(sArrTemp(K, 0))) > 0 Then sArrTemp(K, 1) = True '������� ���������� ��� ������
            Next K
            
        Next j '� ���������� ����� �������� ���� �� ���� ���������� �� ����� ���������

        bolIsFinded = False
        iCoincedenceCnt = 0
        
        For K = LBound(sArrTemp) To UBound(sArrTemp) '�������� �� ������� ��������� ��������
            
            If sArrTemp(K, 1) Then _
                iCoincedenceCnt = iCoincedenceCnt + 1
                
            If iCoincedenceCnt = (UBound(sArrTemp) + 1) / 2 Then _
                bolIsFinded = True: _
                Exit For '����� ������� ����������� ���������� ����������
            
        Next K

        If bolIsFinded Then  '�������� ������ ���������� ��������� ������
            
            For j = LBound(sArrWhereToFind) To UBound(sArrWhereToFind) '�������� �� ������� ��������� ���������� �������
                If sArrWhereToFind(j, i) = sStrExc Then Exit For
                
                For K = LBound(sArrWhereAddResults, 2) To UBound(sArrWhereAddResults, 2) '����� �������� �� �������, � ������� ����������� ������
                
                    If sArrWhereToFind(j, i) = sArrWhereAddResults(j, K) Then '�������� ���� ���� ���������� �� �� �����
                        iCoincedenceCnt = 0
                        For b = LBound(sArrWhereAddResults) To UBound(sArrWhereAddResults) '�������� �� ����� ��������� ������
                            If sArrWhereToFind(b, i) = sArrWhereAddResults(b, K) Then iCoincedenceCnt = iCoincedenceCnt + 1
                        Next b
                        If iCoincedenceCnt = UBound(sArrWhereAddResults) + 1 Then bolExitFor = True: Exit For '��� �������� ������������
                    End If
                Next K
                
                If bolExitFor Then bolExitFor = False: Exit For ' �������� ������ ���������� ������

                If sArrWhereAddResults(LBound(sArrWhereAddResults), UBound(sArrWhereAddResults, 2)) <> "" Then _
                    ReDim Preserve sArrWhereAddResults(UBound(sArrWhereAddResults), UBound(sArrWhereAddResults, 2) + 1) '���� ��������� ������ ��������, ��������� ���
                
                For K = LBound(sArrWhereAddResults) To UBound(sArrWhereAddResults) '�������� �� ����� ��������� ��������������� �������
                    sArrWhereAddResults(K, UBound(sArrWhereAddResults, 2)) = sArrWhereToFind(K, i) '�������� ��� ��������� ��������� ������ �� ��������� ������
                Next K
                Exit For '����� �� ����� j
            Next j
        End If
    Next i
End Sub
'#########################################################
'�������� ������� ��� ������� ������
Sub ReplaceInvCommas(ByRef sTempStr As String)
    
    Dim i As Integer
    For i = 0 To Len(sTempStr) - 1

        If Asc(Mid(sTempStr, i + 1, 1)) = 34 Then '�������� �������
            Select Case i
                Case 0: sTempStr = Chr(171) & Right(sTempStr, Len(sTempStr) - 1) '������������� ������� � ������
                Case Is < Len(sTempStr) - 1
                
                    If Asc(Mid(sTempStr, i, 1)) <= 32 Then
                        sTempStr = Left(sTempStr, i) & Chr(171) & Right(sTempStr, Len(sTempStr) - i - 1)
                    Else
                        sTempStr = Left(sTempStr, i) & Chr(187) & Right(sTempStr, Len(sTempStr) - i - 1)
                    End If
                    
                Case Len(sTempStr) - 1
                    sTempStr = Left(sTempStr, Len(sTempStr) - 1) & Chr(187) '������������� � �����
            End Select
        End If
    Next i
End Sub
