VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ------------------------------------------------------
' ������������: cBase (Class Module)
' ����������: ������� ���������� ��� ������ ���������
' �����: akolodka
' Date: 23.10.2022 18:30, 17.04.2023 21:35
' ------------------------------------------------------

Option Explicit

Public Enum ESortingTypes

    byIncrease
    byDecrease
    
End Enum

Public Enum DefaultValues

    stringDefault
    boolDefault
    intDefault
    
End Enum

Const ENVIRON_ADDPATA = "APPDATA" ' 2  APPDATA=C:\Users\���������\AppData\Roaming
Const ENVIRON_USERPROFILE = "USERPROFILE"
Const ENVIRON_DESKTOP = "Desktop"

Const EXCEL_DIR = "\Microsoft\Excel\XLSTART\"
Const WORD_DIR = "\Microsoft\Word\STARTUP\"

Const PROGRAMDATA_DIR_NAME = "�������� ���"
Const SERVER_BASE_PATH = "\\somnium\irlab\���������\"

Const DEFAULT_VALUE = "null"
Const DEFAULT_VALUE_PRINTED = "����������"
Const DELIMITER_KEY_VALUE = "="

Const WIN_PROCESS_WORD = "WINWORD.EXE"

Private Type TLocalVariables

    configDataPath As String
    desktopPath As String
    
    excelAddinsDir As String
    wordAddinsDir As String
    
End Type

Private fso As New FileSystemObject, _
        this As TLocalVariables

Private Sub Class_Initialize()

    this.configDataPath = fso.BuildPath(Environ(ENVIRON_ADDPATA), PROGRAMDATA_DIR_NAME)
    If Not fso.FolderExists(this.configDataPath) Then _
        fso.CreateFolder this.configDataPath
    
    this.excelAddinsDir = Environ(ENVIRON_ADDPATA) & EXCEL_DIR
    this.wordAddinsDir = Environ(ENVIRON_ADDPATA) & WORD_DIR
    
End Sub

Friend Property Get configDataPath( _
    ) As String '"C:\Users\���������\AppData\Roaming\�������� ���\"
    
    configDataPath = this.configDataPath
    
End Property

Friend Property Get defaultValue( _
    Optional dataType As DefaultValues = stringDefault _
    ) As String
    
    defaultValue = DEFAULT_VALUE
    Select Case True
    
        Case dataType = boolDefault
            defaultValue = False
            
        Case dataType = intDefault
            defaultValue = -1
            
    End Select
        
End Property

Public Property Get excelAddinsDir() As String
    excelAddinsDir = this.excelAddinsDir
End Property

Public Property Get wordAddinsDir() As String
    wordAddinsDir = this.wordAddinsDir
End Property

Friend Property Get defaultValuePrinted( _
    ) As String
    
    defaultValuePrinted = DEFAULT_VALUE_PRINTED
End Property

Friend Property Get delimiterKeyValue( _
    ) As String
    
    delimiterKeyValue = DELIMITER_KEY_VALUE
End Property
Public Property Get serverInitialPath() As String
    serverInitialPath = SERVER_BASE_PATH
End Property
Public Property Get desktopPath() As String
    desktopPath = fso.BuildPath(Environ(ENVIRON_USERPROFILE), ENVIRON_DESKTOP)
End Property
Public Property Get serverProgramDataPath() As String
    serverProgramDataPath = fso.BuildPath(SERVER_BASE_PATH, PROGRAMDATA_DIR_NAME)

End Property
' ----------------------------------------------------------------
' ����: 27.03.2023 20:22
' ----------------------------------------------------------------
Friend Function ContentFromFile( _
    path As String _
    ) As String
    
    ContentFromFile = Base.defaultValue
    
    Dim file As TextStream
    Set file = fso.OpenTextFile(path, ForReading)
    ' ------------------------------------------------------
    If Not file.AtEndOfStream Then _
        ContentFromFile = file.ReadAll
    ' ------------------------------------------------------
    file.Close
    
End Function
' ----------------------------------------------------------------
' ����: 27.03.2023 20:22
' ----------------------------------------------------------------
Friend Sub WriteContent( _
    path As String, _
    content As String _
    )
    
    Dim file As TextStream
    Set file = fso.OpenTextFile(path, ForWriting, Create:=True)  '������� ���� ��� ������, ������� ����, ���� ��� ���
    ' ------------------------------------------------------
    file.Write content
    file.Close

End Sub
' ----------------------------------------------------------------
' ����: 18.03.2023 19:35
' ----------------------------------------------------------------
Public Sub DeletePath( _
    path As String _
    )
    Shell "cmd /c rd /S/Q """ & path & """"
End Sub
' ----------------------------------------------------------------
' ����: 04.04.2023 21:33
' ----------------------------------------------------------------
Public Function SortArray( _
    arrToSort() As String, _
    Optional sortingType As ESortingTypes = byIncrease _
    ) As String()
    '�� ��������� ���������� �� �����������

    Dim lowerBound As Integer, _
        upperBound As Integer, _
        sortStep As Integer

    lowerBound = LBound(arrToSort) + 1
    upperBound = UBound(arrToSort)
    sortStep = 1

    If sortingType = byDecrease Then

        lowerBound = UBound(arrToSort) - 1
        upperBound = LBound(arrToSort)
        sortStep = -1

    End If

    Dim i As Integer, _
        j As Integer, _
        jPrevious As Integer

    For i = lowerBound To upperBound Step sortStep
        j = i

        Do
            If j = lowerBound - sortStep Then Exit Do '���� ��������������� ����� ������ �������
            If arrToSort(j) = vbNullString Then Exit Do '���� ������� ������� - ������ �������

            jPrevious = j - 1
            If sortingType = byDecrease Then jPrevious = j + 1

            If arrToSort(jPrevious) <> vbNullString Then '���� ���������� ������� ��������
                If LCase(arrToSort(jPrevious)) < LCase(arrToSort(j)) Then Exit Do   '���� ���������� ������� ������ ��������
            End If

            Dim tempData As String
            tempData = arrToSort(j)  '�������� ���������� ��������

            arrToSort(j) = arrToSort(jPrevious)
            arrToSort(jPrevious) = tempData

            j = jPrevious

        Loop
    Next i

    SortArray = arrToSort
    
End Function
' ----------------------------------------------------------------
' ����: 30.05.2023 21:49 -- ������ ������� ���������� Word
' ----------------------------------------------------------------
Friend Function IsWordExecuting( _
    ) As Boolean

    IsWordExecuting = False

    Dim winProcess As Object
    For Each winProcess In GetObject("winmgmts:").ExecQuery("Select * from Win32_Process")
    
        If winProcess.caption Like WIN_PROCESS_WORD Then _
            IsWordExecuting = True: _
            Exit Function
    Next

End Function

