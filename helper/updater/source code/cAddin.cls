VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cAddin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const DEVELOPER_KEYWORD As String = "dev"
Const RELEASE_KEYWORD = "release"
Const IDE_KEYWORD = "VBA"

Const ENVIRON_KEYWORD = "USERPROFILE"
Const CLOUD_DIR = "Box\helper_updates"
Const SERVER_DIR = "\\somnium\irlab\���������\�������� ���\updates"

Enum e_updateTypes
    major
    medium
    micro
End Enum

Private fso As New FileSystemObject, _
        m_addin As Workbook

Private Sub Class_Initialize()
    Set m_addin = ThisWorkbook
End Sub

Private Sub Class_Terminate()
    Set m_addin = Nothing
End Sub

Friend Property Get VersionCaption( _
    ) As String
    
    Properties.Initialize thisWb
    
    Dim strData As String
    strData = Replace(Properties.comments, " � ", vbNewLine)
    
    If isDev Then _
        strData = " Dev build" & " " & Properties.build & vbNewLine & _
        Format(Properties.comments, " dd mmmm yyyy �.")
    
    VersionCaption = strData
    
End Property
Friend Sub IncreaseBuild()
    
    Properties.Initialize thisWb
    
    If Not IsPropertiesCorrect Then _
        Initialialize
    
    IncreaseValue

End Sub
    Private Function IsPropertiesCorrect( _
        )
        
        IsPropertiesCorrect = Properties.version <> vbNullString _
                And Properties.build <> vbNullString _
                And IsNumeric(Properties.build)
        
    End Function
    Private Sub IncreaseValue( _
        )
        
        If Not isDev Then Exit Sub
                        
        Properties.build = Properties.build + 1
        Properties.comments = Format(Date, "dd.mm.yyyy")
    
        Debug.Print "~~~ "; Time; " "; m_addin.name; " // "; _
                    Properties.build; " // "; _
                    Properties.version & " ~~~" '; " // "; version_date
                    
    End Sub
        Private Function isDev( _
            ) As Boolean
        
            isDev = False
            
            If Properties.category = DEVELOPER_KEYWORD Then _
                isDev = True
            
        End Function
' ----------------------------------------------------------------
' ������������: Initialialize (Friend Sub)
' ����������: �������������� ������� ������� ����������
' ����: 08.10.2022 14:18
' ----------------------------------------------------------------
Friend Sub Initialialize()
    
    Properties.Initialize thisWb
    
    Properties.category = DEVELOPER_KEYWORD
    Properties.keywords = IDE_KEYWORD
    Properties.comments = Format(Date, "dd.mm.yyyy")
    Properties.version = "0.1"
    Properties.build = vbEmpty

    Debug.Print "~~~ " & Time & " �������� ������� ��������� � " & m_addin.name & " ~~~"
    
End Sub
Friend Sub Upload( _
    Optional updateType As e_updateTypes = micro _
    )
    
    Properties.Initialize thisWb
    
    Dim newVersionNum As String
    newVersionNum = NewVersion(updateType)
    
 '   newVersionNum = InputBox("����������� ��������� ������", m_addin.Name, newVersionNum)
    
    
    newVersionNum = InputBox("������� ������: " & Properties.version & vbNewLine & _
            "����� ������:", m_addin.name, newVersionNum)
            
'    newVersionNum = InputBox("����������� ��������� ������." & vbNewLine & vbNewLine & _
'            "������� ������: " & properties.version & vbNewLine & vbNewLine & _
'            "����� ������:", m_addin.Name, newVersionNum)
'
    
    
    If newVersionNum = vbNullString Then _
        Debug.Print "~~~ !������ �� ���� �������, ���������� �������� ~~~": _
        Exit Sub
        
    Debug.Print
    
    DevUpload
    FreezeReleaseProperties newVersionNum '����������� �������� ��� ������
    
    ReleaseUpload
    
    ReturnDevProperties
    m_addin.Save

    Debug.Print "----------------------------"
    
End Sub
    Private Function NewVersion( _
        updateType As e_updateTypes _
        ) As String
        
        Dim currVersion As String
        currVersion = Properties.version
        
        Dim arrVersion() As String
        arrVersion = Split(currVersion, ".")
        
        ReDim Preserve arrVersion(2)
        If arrVersion(LBound(arrVersion) + 2) = vbNullString Then _
            arrVersion(LBound(arrVersion) + 2) = vbEmpty
        
        Select Case True
        
            Case updateType = micro
                arrVersion(LBound(arrVersion) + 2) = CInt(arrVersion(LBound(arrVersion) + 2)) + 1
            
            Case updateType = medium
                arrVersion(LBound(arrVersion) + 1) = CInt(arrVersion(LBound(arrVersion) + 1)) + 1
                arrVersion(LBound(arrVersion) + 2) = vbNullString
                ReDim Preserve arrVersion(1)
                
            Case updateType = major
                arrVersion(LBound(arrVersion)) = CInt(arrVersion(LBound(arrVersion))) + 1
                arrVersion(LBound(arrVersion) + 1) = vbEmpty
                arrVersion(LBound(arrVersion) + 2) = vbNullString
                ReDim Preserve arrVersion(1)
                
        End Select
        
        NewVersion = Join(arrVersion, ".")
    End Function
    Private Sub DevUpload()
           
        If fso.FolderExists(CloudPath) Then
            
            m_addin.SaveCopyAs fso.BuildPath(CloudPath, m_addin.name)
            Debug.Print "~~~ " & Time & " �������� � ������ ��������� ~~~"
            
        Else
            Debug.Print "~~~ " & Time & " !������ �������� � ������: ������� ���������� ~~~"
        End If

    End Sub
        Private Function CloudPath( _
            ) As String
            
            CloudPath = fso.BuildPath(Environ(ENVIRON_KEYWORD), CLOUD_DIR)
            
        End Function
    Private Sub FreezeReleaseProperties( _
        versionNumber As String _
        )
        
        Properties.category = RELEASE_KEYWORD
        Properties.version = versionNumber
        Properties.comments = "v." & versionNumber & " (build " & Properties.build & ") � " & Format(Date, "dd mmmm yyyy �.")
        
    End Sub
    Private Sub ReleaseUpload( _
        )
        If fso.FolderExists(SERVER_DIR) Then
        
            m_addin.SaveCopyAs fso.BuildPath(SERVER_DIR, m_addin.name)
            Debug.Print "~~~ " & Time & " �������� �� Somnium ��������� ~~~"
            
        Else
            Debug.Print "~~~ " & Time & " !������ �������� �� Somnium: ������� ���������� ~~~"
            m_addin.SaveCopyAs fso.BuildPath(Base.desktopPath, m_addin.name)
            Debug.Print "~~~ " & Time & " ���������� �� ������� ���� ~~~"
            
        End If
        
    End Sub
    Private Sub ReturnDevProperties()
        
        Properties.category = DEVELOPER_KEYWORD
        Properties.comments = Format(Date, "dd.mm.yyyy")
        Properties.build = Properties.build - 1
     
    End Sub
            
Friend Sub Download()

    Properties.Initialize thisWb

    Debug.Print
    If fso.FolderExists(CloudPath) Then
        
        Explorer.OpenFolder Properties.TargetWorkbook.path, True
        Explorer.OpenFolder CloudPath, True
        
    Else
        Debug.Print "~~~ �������� �� ������... !������ ��������. ������� ���������� ~~~"
        
        If fso.FolderExists(SERVER_DIR) Then
            
            Explorer.OpenFolder Properties.TargetWorkbook.path, True
            Explorer.OpenFolder SERVER_DIR, True
            
        Else
            Debug.Print "~~~ �������� c �������... !������ ��������. ������� ���������� ~~~"
        End If
        
    End If
    
    Properties.TargetWorkbook.Close False
    
End Sub
