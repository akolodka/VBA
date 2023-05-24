Attribute VB_Name = "z_Old_CrossAppCode"
'� ������ ������ ��� ��� ���������� ������� Excel & Word

#Const CurrentAppCode = "xl" '������� ��������� ���������� ����
'wd - ������ � MsWord. ������ = �, ������ = �
'xl - ������ � MsExcel. ������ = � - 5, ������ = � - 7
Option Explicit '������ �� ������������� ������� ����������
'###################################################################
'��������� �������� ������ ����� ������ �� ��
Sub Set_Z_UF_Search_Size()

    Select Case True  '�������� �������� ����
        
        Case UMenu.typ� = organisationsOLD
            SearchBy1
            
        Case UMenu.typ� = instrumentsOLD
            SearchBy2
            
        Case UMenu.typ� = etalonsOLD
            SearchBy3
            
        Case UMenu.typ� = personsOLD
        
            With Z_UF_Search
            
                .caption = "�������� � ��� � ���������� �����������"
                .cmb1.caption = "������� �.�.": .cmb2.Visible = False
                .cmb4.caption = "������������"
                .chbFullName.Visible = True
                
                With .cmb3
                    .caption = "���������"
                    .Enabled = True
                    
                End With
                
            End With
            
        Case UMenu.typ� = archiveOLD
            SearchBy14
            
    End Select
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 13:46
' ����������:
' ----------------------------------------------------------------
Sub SearchBy1()
    With Z_UF_Search
        
        .caption = "����������� �����" '���������
        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
            .cmb1.caption = "�������� ��������" & vbNewLine & "� ������� �������"
        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
            .cmb1.caption = "��������" & vbNewLine & "�� ����"
        #End If
        
        .cmb1.Height = 48
        .cmb1.Width = .cmb1.Width / 2
        
        With .cmb2
            .caption = "������������": .Top = 88
        End With
        
        With .cmb3
            .Top = 112: .Width = 57: .caption = "���":
        End With
        
        With .cmb4
            .Left = 63: .Width = 57: .caption = "�����"
        End With
        
        .btnOpenFolder.Visible = True
        .btnOpenFolder.Left = .cmb4.Left
        .btnOpenFolder.Top = .cmb1.Top
        .btnOpenFolder.Width = .cmb1.Width
        .btnOpenFolder.Height = .cmb1.Height
        
    End With
End Sub
' ----------------------------------------------------------------
' ����: 25.02.2023 13:46
' ����������:
' ----------------------------------------------------------------
Sub SearchBy2()

    With Z_UF_Search
    
        .caption = "�������� ���������" '���������
        
        With .cmbProtSv '������ �������� ������� ������������� ��� ���������
            
            .Visible = True
            .Height = 48
            .Width = .Width / 2
            .Left = 6
            .caption = "���������" & vbNewLine & "������"
            
        End With
        
        With .cmbDescription '�������� ���� ��
            .Visible = True: .Top = 88: .Left = 6: .Width = 57
        End With

        With .cmbMetodic '�������� �������
            .Visible = True: .Left = 63: .Width = 57: .ControlTipText = "������� �������� ������� ��� ������� ��"
        End With
        
        With .cmb1 '������������ ��
            .Width = 29: .Top = 112: .caption = "�": .ControlTipText = "�������� ������������ ��"
        End With
        
        With .cmb2 '������� ������ ��
            .Width = 28: .Top = 112: .Left = 35: .caption = "�": .ControlTipText = "�������� ������� ������ ��"
        End With
        
        With .cmb3 '����� � ���
            .Width = 28: .Top = 112: .Left = 64: .caption = "�": .ControlTipText = "�������� ����� � ���"
        End With

        With .cmb4 '�������� �������
            .Width = 28: .Left = 92: .caption = "�": .ControlTipText = "�������� ������������ ��"
        End With
        
        .btnOpenFolder.Visible = True
        .btnOpenFolder.Left = .cmbMetodic.Left
        .btnOpenFolder.Top = .cmbProtSv.Top
        .btnOpenFolder.Width = .cmbProtSv.Width
        .btnOpenFolder.Height = .cmbProtSv.Height
        
    End With
End Sub
'###################################################################
'������� ����� ������ ��������
Sub SearchBy3()
     With Z_UF_Search
     
        .caption = "������� � ��������������� ������������" '���������
                
        With .cmbProtSv
            .Visible = True: .Left = 6: .Height = 48
        
            #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                .caption = "�������� ��������" & vbNewLine & "� ������� �������"
            #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                .caption = "����� � ����������" & vbNewLine & "����� ������������"
            #End If
        End With
        
        With .cmb1 '������������ ������������
            .Top = 88: .Width = 57: .caption = "����.": .ControlTipText = "������������ ���������� ������������"
        End With
        
        With .cmb2 '��� ������������
            .Top = 88: .Width = 57: .caption = "���": .Left = 63: .ControlTipText = "��� ���������� ������������"
        End With
        
        With .cmb3 '����� ������������
            .Top = 112: .Width = 57: .caption = "�����": .ControlTipText = "����������� �����"
        End With
        
        With .cmb4 '�������� � �������
            .Left = 63: .Width = 57: .caption = "����.": .ControlTipText = "���������� (�������� � ������� / ����������)"
        End With
    End With
End Sub
'###################################################################
'������� ����� ������ �� ������ ����������� �����
Sub SearchBy14()
    With Z_UF_Search
        .cmbUpdate.Left = 336: .caption = "�����" '���������
        
        With .btnOpenFolder
            .Visible = True: .Enabled = True: .ControlTipText = "������� ������� ������ �����"
        End With
        
        With .cmb1
            .Height = 48: .caption = "������� �������" & vbNewLine & "������ ������"
        End With
        
        With .cmb3
            #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                If ActiveDocument.path <> "" Then .Enabled = True
            #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                If ActiveWorkbook.path <> "" Then .Enabled = True
            #End If
            
            .Height = 48: .caption = "������� �������" & vbNewLine & "������ ������"
        End With
        .cmb2.Visible = False: .cmb4.Visible = False
        
        With .chbFullName
            .caption = "��������� ���������"
            .ControlTipText = "��������� �������������� �������� ���������"
            '.value = True
            .Visible = True
            .Width = .Width + 20
            .Top = Z_UF_Search.btnOpenFolder.Top + 3
            .Left = Z_UF_Search.cmbUpdate.Left - Z_UF_Search.cmbUpdate.Width - 20
        End With
    End With
End Sub
'###################################################################
'��������� ��������� �������� ��� ��������
Sub AddInvertParameter(objClsm As Z_clsmBase)
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        objClsm.AddP "wdFullFirstName"
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        objClsm.AddP "xlFullFirstName"
    #End If
End Sub
'###################################################################
'������� ���������� ���������� ���������� ����
Function myWdDoc() As Boolean
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        myWdDoc = True
    #End If
End Function
'###################################################################
'��������� ������� ������ � �������� � ����������� �� ���� ���������� MS Office
Function Z_UF_Search_Cmb2(ByRef DataBase() As String, ByRef dbInd As Integer) As Boolean

    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
    
        If UMenu.typ� = organisationsOLD Then _
            DataTransfer "��� " & DataBase(1, dbInd), True: Exit Function '������ ��� ����� ����������
        DataTransfer DataBase(1, dbInd), True
        
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
    
        If InStr(ActiveCell.Offset(0, -1), "���") > 0 Then _
            DataTransfer DataBase(1, dbInd)
        
        If InStr(ActiveCell.Offset(-1, 3), "��. �����:") > 0 Then _
            ActiveCell.Offset(-1, 2).Select: Z_UF_Search_Cmb2 = True: Exit Function
    #End If
End Function
'###################################################################
'��������� ��������� ���������� ������ �������� �������� � ��������
Sub EtalonsSearchButton()
    With Z_UF_Search
    
        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
            .cmbProtSv.Enabled = .cmb1.Enabled
        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
            .cmbProtSv.Enabled = True
        #End If
    End With
End Sub
'###################################################################
'��������� �������� ������� ����� ������������ ��
Sub Set_UF_Cunstructor_Properties()
    
    Select Case True   '�������� �������� ��������� �����
        
        Case UMenu.typ� = organisationsOLD  '���������
            ConstructorBy1
        
        Case UMenu.typ� = instrumentsOLD  '�������� ���������
            ConstructorBy2
        
        Case UMenu.typ� = etalonsOLD   '�������
            ConstructorBy3
        
        Case UMenu.typ� = personsOLD  '�������
            With Z_UF_Constructor
                .chbVerRefer.Visible = True
                .caption = "����������� �������� � ��� � ���������� �����������"
                
                .Label2.caption = "�������, ��� � �������� ���������:"
                .Label2.Width = .Label4.Width: .TextBox1.Width = .TextBox2.Width
                
                .Label3.Visible = False: .TextBox2.Visible = False
                
                .Label4.caption = "���������:": .Label4.Top = .Label2.Top
                .TextBox3.Top = .TextBox1.Top: .TextBox3.BackColor = .TextBox1.BackColor
                
                .Label5.Visible = False: .TextBox4.Visible = False
                    
                .cmbImport.Top = .Label3.Top: .cmbDelete.Top = .Label3.Top
                .cmbAdd.Top = .Label3.Top: .cmbReady.Top = .Label3.Top
                .LabelInfo.Top = .Label3.Top + 5: .Label3.Top = .Label2.Top
                
                '.cmbOpenTemplateFolder.Visible = False
                Select Case Application.Version
                    Case "16.0" 'Office 2016
                        .Height = 290
                    Case "15.0" 'Office 2013
                        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                            .Height = 290
                        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                            .Height = 284
                        #End If
                    Case Else '2010, 2007
                        .Height = 284
                End Select
            End With
    End Select
End Sub
'###################################################################
'��������� ������������ ������� �����
Sub ConstructorBy1()
    With Z_UF_Constructor
    
        .caption = "����������� �������� � ����������" '���������
        .Label2.caption = "������ ������������ ���������:": .Label3.caption = "�������������� ��������� �����:"
        .Label4.caption = "���������� ������������ ��� ������:": .Label5.caption = "����� ���������:"
        
        With .TextBox2
            .maxLength = 13: .BackColor = &HC0FFFF    '�����
        End With
        
        .TextBox3.maxLength = 27
        .cmbOpenTemplateFolder.Visible = False
    End With
End Sub
'###################################################################
'��������� ������������ ������� ����� ������� ���������
Sub ConstructorBy2()
    With Z_UF_Constructor
        
        .caption = "����������� �������� � ��������� ���������" '���������
                
         With .Label4
             .caption = "����� � ���:": .Left = 378: .Width = 84
         End With
         
         .Label4.Top = .Label2.Top: .Label4.Left = .Label2.Left
         
         With .TextBox3 '����� � ���
             .Width = 84: .maxLength = 8: .BackColor = &HC0FFFF   '�����
         End With
         .TextBox3.Top = .TextBox1.Top: .TextBox3.Left = .TextBox1.Left
         
         .TextBox2.Width = .TextBox3.Width  '���� ����� �������� ������� ��
         .TextBox2.BackColor = &HC0FFFF   '�����
         
         With .Label3
             .Width = 400: .caption = "��� ��:"
         End With
                            
         .TextBox1.Left = .TextBox1.Left + .TextBox3.Width
         .TextBox1.Width = .TextBox1.Width - .TextBox3.Width
         
         .Label2.caption = "������ ������������ �������� ���������:"
         .Label2.Left = .TextBox1.Left
         
         .LabelInfo.Top = .Label5.Top + 4
         .cmbImport.Top = .Label5.Top
         
         .cmbDelete.Top = .Label5.Top
         .cmbAdd.Top = .Label5.Top
         .cmbReady.Top = .Label5.Top
         
         .Label5.Top = .Label3.Top: .Label5.Left = .TextBox1.Left: .Label5.caption = "�������� �������:"

         .TextBox4.Top = .TextBox2.Top: .TextBox4.Left = .TextBox1.Left
         .TextBox4.Width = .TextBox1.Width: .TextBox4.BackColor = &HC0FFFF    '�����
         .cmbOpenTemplateFolder.Visible = True
         
        With .chbVerRefer
            .Visible = True: .Width = 130: .Left = 340: .caption = "����������� ������"
            .ControlTipText = "�������� ������ �� �������� ������� �� �� ���������� ������� ������ ���"
        End With
        
        .chbEtalon.Visible = True
        
        If myWdDoc = False Then .tboxSearchConstr.Width = 126: .cmbFillTempProp.Visible = True: .LabelGetTemplate.Visible = True
         
         Select Case Application.Version
             Case "16.0" 'Office 2016
                 .Height = 332
             Case "15.0" 'Office 2013
                 #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                     .Height = 332
                 #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                     .Height = 324
                 #End If
             Case Else '2010, 2007
                 .Height = 324
         End Select
    End With
End Sub
'###################################################################
'��������� ������������ ������� ����� ��������
Sub ConstructorBy3()
    With Z_UF_Constructor
    
        .caption = "����������� �������� �� ��������� � ��������������� ������������" '���������
        .Label2.caption = "������������ ������������:"
        
        With .Label6
            .Visible = True: .Left = 6: .Width = 150: .Top = 234: .caption = "�������� ����� ��� ������:"
        End With
        With .TextBox5 '�������� ����� ��� ������
            .Visible = True: .Left = 6: .Width = 170: .Top = 252: .BackColor = &HC0FFFF    '�����
        End With
        
        With .Label3
            .Left = 176: .Width = 130: .caption = "��� ������������:"
        End With
        With .TextBox2 '��� �������
            .Left = 176: .Width = 130: .BackColor = &HC0FFFF    '�����
        End With
        
        With .Label4
           .Left = 306: .caption = "����������� �����:"
        End With
        With .TextBox3 '��������� �����
            .Left = 306: .Width = 156: .maxLength = 25: .BackColor = &HC0FFFF   '�����
        End With
    
        .Label5.caption = "���������� (�������� � �������):"
        .TextBox4.BackColor = &HC0FFFF    '�����
        
        .cmbOpenTemplateFolder.Visible = False
    End With
End Sub
'###################################################################
'��������� ������� � �������� ����� xl ������� �����������
'todo: [+] FillLastName -- ����������� � ��������� � LoadXlTemplate
Sub FillLastName( _
    sName As String, _
    sNameState As String, _
    Optional bolNameHead As Boolean, _
    Optional bolNameSecond As Boolean, _
    Optional objWs As Object _
    )
    '##################################################
    '��������� �������
    If ActiveWorkbook.name Like "jr*" Then Exit Sub
    
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        If objWs Is Nothing Then Set objWs = ActiveWorkbook.ActiveSheet
        With objWs
        
            Dim ilastRow As Integer, sCellStr As String
            ilastRow = .Cells(Rows.count, 1).End(xlUp).Row '��������� ����������� ������ 1 ������� �����
            
            Do While ilastRow > 24 '25 ������ - ��������� ��� ������
                
                sCellStr = LCase(CStr(.Cells(ilastRow, 1)))
                                
                If bolNameHead And sCellStr Like "*������������ ��������*" Then Exit Do  '������ ������������
                If bolNameSecond And sCellStr Like "*�����*" And sCellStr Like "*��������*" Then Exit Do '������ �����������
                If sCellStr Like "*������*" Or sCellStr Like "*�������*" Or sCellStr Like "*������*" Then Exit Do '������ �����������
                
                ilastRow = .Cells(ilastRow, 1).End(xlUp).Row '������� � ��������� ������ ����
            Loop
            
            If ilastRow = 25 Then Exit Sub
            
            If sName = "����������" Or sName = vbNullString Then
            
                If bolNameSecond Then _
                    .Cells(ilastRow - 2, 1).Resize(4, 1).EntireRow.Delete
                
                Exit Sub
                
            End If
            
            
            If InStr(CStr(.Cells(ilastRow + 1, 9)), "�������") > 0 Then _
                .Cells(ilastRow, 9) = sName '�������� ���
            
            If InStr(CStr(.Cells(ilastRow + 1, 3)), "���������") > 0 Then _
                .Cells(ilastRow, 3) = sNameState '�������� ���������
                
            If .Cells(ilastRow, 3) <> "" Then _
                SetPrintArea ilastRow, objWs '��������� ���������
        End With

        
    #End If
    
End Sub
Private Sub SetPrintArea(ilastRow As Integer, Optional objWs As Object)

    If objWs Is Nothing Then Set objWs = ActiveSheet
    
    Dim prArea As String, printMaxRow As Integer
    prArea = ActiveSheet.PageSetup.PrintArea
    printMaxRow = Right(prArea, InStr(StrReverse(prArea), "$") - 1)
    
    'ActiveSheet.PageSetup.PrintArea = "a1:j136"
    
    If ilastRow + 1 > printMaxRow Then _
        prArea = Left(prArea, Len(prArea) - Len(printMaxRow) - 1) & ilastRow + 1

    objWs.PageSetup.PrintArea = prArea
    Set objWs = Nothing
End Sub
'###################################################################
'��������� ��������� pdf-����
Sub OpenPDF(sourcePath As String, sFifNum As String, pdfMAsk As String)
    
    Dim sFileName As String, sTempDir As String
    sTempDir = Dir(sourcePath & "\instruments\" & "*" & sFifNum & "*", vbDirectory)   '������� ��
    sFileName = Dir(sourcePath & "\instruments\" & sTempDir & "\" & pdfMAsk & "*.pdf") '��� �����
    
    If sTempDir <> "" Then _
        sFileName = sourcePath & "\instruments\" & sTempDir & "\" & sFileName '������� + ��� �����
    
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        ActiveDocument.FollowHyperlink sFileName
        
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        ActiveWorkbook.FollowHyperlink sFileName
    #End If
End Sub
'###################################################################
'��������� ��������� ����� �� �������
Sub openPath(sPath As String, Optional sFName As String)

    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        ActiveDocument.FollowHyperlink sPath & sFName
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        ActiveWorkbook.FollowHyperlink sPath & sFName
    #End If
End Sub
'###################################################################
'������������� ��������� ������ ������ ������ ��� xl
Function TrueFindCell() As Boolean

    TrueFindCell = False
    
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        Dim rTempCell As Range
        TrueFindCell = FindCellRight("��������", rTempCell, , , True)
    #End If
End Function
'###################################################################
'��������� ������� ������ � �������� / ����
Sub DataTransfer( _
    ByVal sData As String, _
    Optional insertEndSpace As Boolean, _
    Optional useLongName As Boolean, _
    Optional clearCellColors As Boolean = True, _
    Optional currAddress As String)
    
    Application.ScreenUpdating = False '��������� ���������� ������
    
    If UMenu.typ� = personsOLD And useLongName = False Then '�������� �������� ����� ���
    
        Dim sArrTemp() As String, K As Byte, sTempStr As String
        sArrTemp = Split(sData, " ")
        sTempStr = sArrTemp(0) & " "
        
        For K = LBound(sArrTemp) + 1 To UBound(sArrTemp)
            sTempStr = sTempStr & Left(sArrTemp(K), 1) & "."
        Next
        
        sData = sTempStr
    End If

    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        Application.DisplayAlerts = word.wdAlertsNone '��������� ����������� �� ������
        
        With Selection
            If insertEndSpace Then sData = sData & " " '�������� ������ ����� ������������ ������

            .text = sData  '�������� ������ � ������� �������
            .Range.HighlightColorIndex = wdNoHighlight '�������� ������� ������
            .Range.Font.ColorIndex = wdBlack '������ ���� ������
            .MoveRight Unit:=wdCharacter '������������� �� ���� ������� ������
        End With
        
        Application.DisplayAlerts = word.wdAlertsAll
        
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        If currAddress <> vbNullString Then _
            ActiveSheet.Range(currAddress).Select
        
        With ActiveCell
        
            If clearCellColors Then
                .Font.ColorIndex = xlAutomatic '������ ���� ������
               ' .Interior.Pattern = xlNone '�������� �������
            End If
            
            .numberFormat = "@"
            .value = sData
            
            Select Case True
                
                Case UMenu.typ� = etalonsOLD
                    .Offset(0, 1).Select '������ ��� ���������� ������������
                    
                Case Else:
                    .Offset(1, 0).Select
            End Select

        End With
    #End If
    
    Application.ScreenUpdating = True
End Sub
'###################################################################
'��������� ������� ������������ ��������� � �������� ���������
Sub SetBuiltInProperty( _
    sProperty As String, _
    Optional sData As String, _
    Optional ClearProp As Boolean _
)
    
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            If ClearProp Then .BuiltinDocumentProperties(sProperty) = vbNullString: Exit Sub
            
'            Dim currProperty As String
'            currProperty = .BuiltinDocumentProperties(sProperty)
'
'            If InStr(currProperty, "--") > 0 Then
'                currProperty = Right(currProperty, Len(currProperty) - InStr(currProperty, "--") + 2)
'                sData = sData & currProperty
'
'            End If
                
            .BuiltinDocumentProperties(sProperty) = sData
        End With
End Sub
'###################################################################
'������� ��������� ���������� ��������
Function GetBuiltInProperty(sProperty As String) As String
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            GetBuiltInProperty = .BuiltinDocumentProperties(sProperty)
        End With
End Function
'###################################################################
'��������� ��������� �������� � ����������� �� ��������� ����� - ������������� �������� ��������
Sub SaveNewName(SaveName As String, Optional saveAsCopy As Boolean, _
    Optional bolShortCut As Boolean, Optional NotInsNumber As Boolean, Optional sSavingDir As String)
    
'    SaveName - �������� ��� ����� ��� ���� � ���������� pr_210_2104_0000_18
'    saveAsCopy - �������� ��� ����� (�� �������������� ������� ��������)
'    bolShortCut - ������� ����� �� ������� �����
'    NotInsNumber - �� ���������� � ����������� ��������� ����� (��� �������� �������)
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
    
        With ActiveDocument
            If .name = ThisDocument.name Then MsgBox "������ ����������": Exit Sub  '������ �� �������� ��������� ��� ����������
            
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
            If .name = ThisWorkbook.name Then MsgBox "������ ����������": Exit Sub '������ �� �������� ��������� ��� ����������
            Commit_factory_number
    #End If
            
            Dim sFinalDir As String, _
                sExt As String
            
            sFinalDir = .path & "\"
            If .path = vbNullString Then sFinalDir = "C:\Users\" & Environ("USERNAME") & "\Desktop\"
            If sSavingDir <> vbNullString Then sFinalDir = sSavingDir  '�������� ����������
            
            sExt = GetExt(.fullName) '������� ���������� �����
            
            If sExt = vbNullString Then
                saveAsCopy = True '������� ���� �������� ��������� � �� �������
                
                #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                    sExt = ".docx"
                #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                    sExt = ".xlsx"
                #End If
            End If
            
            Dim sNewName As String, sPrevName As String
            sPrevName = .fullName '������� ��� �����
            sNewName = ReturnNotExistingName(sFinalDir, ReplaceBadSymbols(SaveName), sExt)  '����� ��� �����
            
            #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                .SaveAs sNewName, wdFormatDocumentDefault '������-�� ����� �� ��������
            #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                .SaveAs sNewName, 51
            #End If
            
            If saveAsCopy = False Then Kill sPrevName '���� ���������� �������������
            If bolShortCut Then _
                CreateShortcut sNewName, SaveName
        End With
End Sub
'###################################################################
'��������� ������ ����� �������� ��������� �� ������� �����
Sub CreateShortcut( _
    path As String, _
    Optional shcutName As String _
    )
    
    If shcutName = vbNullString Then _
        shcutName = Right(path, InStr(StrReverse(path), Application.PathSeparator) - 1)
        
    With CreateObject("WScript.Shell")
    
        If Dir(.SpecialFolders("Desktop") & "\" & shcutName & ".lnk") = vbNullString Then '���� ������ �� ����������
        
            With .CreateShortcut(.SpecialFolders("Desktop") & "\" & shcutName & ".lnk") '������� �����
                .targetPath = path '������ ���� � �����
                .description = "������� � �������"
                .Save
            End With
        End If
    End With
End Sub
'###################################################################
 '������� ��������� ���������� �������� �� ��������� ���������
Function TakeCategoryProperty(property As String)
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            TakeCategoryProperty = .BuiltinDocumentProperties(property) '������� �������� ��������� � ��������� �����
        End With
End Function
'###################################################################
'������� ����� ������ ����������� ���� � ����������
Function ListBoxDateFormatChange(myDate As Date, Optional bolAnotherDateFormat As Boolean) As String
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        
        ListBoxDateFormatChange = Format(myDate, "dd mmmm yyyy �.") '��������� ������
        If bolAnotherDateFormat Then ListBoxDateFormatChange = Format(myDate, "dd.mm.yyyy"): Exit Function '�������� ������
            
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        ListBoxDateFormatChange = Format(myDate, "dd.mm.yyyy") '�������� ������
        If bolAnotherDateFormat Then ListBoxDateFormatChange = Format(myDate, "dd mmmm yyyy �."): Exit Function '��������� ������
        
    #End If
End Function
'###################################################################
'��������� ������� � �������� ���� ���������� ������
Sub TrueDateTransfer(myDate As String, myInterval As Integer, FirstDateSelected As Boolean, SecondDateSelected As Boolean, AdditionDateFormat As Boolean)
    Application.ScreenUpdating = False
    
    Dim DateToTransfer As String
    DateToTransfer = DateAdd("yyyy", myInterval, CDate(myDate)) - 1 '��������� ���� ������������� ��
    
    If FirstDateSelected = True And SecondDateSelected = False Then DateToTransfer = myDate '�������������� ��������, ��� ��������� ���� ���������� ������

    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With Selection '������ � ���������� �������
        
            If AdditionDateFormat Then '���� ������ �������� ������ "��.����.����"
                .text = DateToTransfer
            Else '������ � ���� "�� ���� ���� �."
                .text = Format(CDate(DateToTransfer), "dd mmmm yyyy �.")
            End If
            
            .Range.HighlightColorIndex = wdNoHighlight '�������� ������� ������
            .Range.Font.ColorIndex = wdBlack '������ ���� ������
            .MoveRight Unit:=wdCharacter '������������� �� ���� ������� ������
            
        End With
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveCell
            .Font.ColorIndex = xlAutomatic '������ ���� ������
            .Interior.Pattern = xlNone '�������� �������
            
            If AdditionDateFormat Then '���� ������ ��������� ������ "�� ���� ���� �."
                .numberFormat = "@": .value = Format(CDate(DateToTransfer), "dd mmmm yyyy �.")
            Else '������ � ���� "��.����.����"
                .value = CDate(DateToTransfer)
            End If
            
            .Offset(1, 0).Select '�������� ������ ����
        End With
    #End If
    Application.ScreenUpdating = True
End Sub
'###################################################################
'������� ����������� � ������ � ������� ������ ������� � ������ � ����� ������
Function DataImport() As String '������������� ������ �� ���������
    Application.ScreenUpdating = False '��������� ���������� ������
    
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        Application.DisplayAlerts = word.wdAlertsNone
        
        DataImport = DeleteSpaceStEnd(Selection)  '�������� ������ �� ���������� �������
        
        Application.DisplayAlerts = word.wdAlertsAll
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        DataImport = DeleteSpaceStEnd(ActiveCell)
    #End If
    
    Application.ScreenUpdating = True
End Function
'###################################################################
'��������� ��������� ������ ������ � ����� ������ �� ������� �� Num +
'Sub NumPlusImport()
'    With F_UF_Buffer
'
'        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
'            If Selection.Characters.Count > 1 Then
'                .tboxBuffer = DataImport
'        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
'            If ActiveCell <> "" Then
'
'                .tboxBuffer = DataImport & "@" & ActiveCell.address
'        #End If
'                .Label2.Caption = "������ ��������"
'                TrueElementForeColor .Label2: OntimeUnload '���� ������ ������� ��������
'            Else
'                Dim sLabelText As String
'                sLabelText = .Label2.Caption: .Label2.Caption = "�������� ������ ��� �������": .Label2.Forecolor = &HFF&  '�������
'
'                Application.OnTime Now + TimeValue("00:00:02"), "LabelBack"
'            End If
'    End With
'End Sub
'###################################################################
'����� ��������� ������� ���� ������ ��������
Sub TrueElementForeColor(objName As Object, Optional clrBlack As Boolean, Optional clrWDXL As Byte)
    With objName
    
        If clrBlack Then .foreColor = &H80000008: Exit Sub '������ ���� �������
        
        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
            .foreColor = &HFF0000    '����� ����
        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
            .foreColor = &H8000& '������ ���� ������
        #End If
        
        Select Case clrWDXL '�������������� ������� ���������� �� ����������
            Case 1: .foreColor = &HFF0000   '����� ����
            Case 2: .foreColor = &H8000& '������ ���� ������
            Case 3: .foreColor = &HFF&       '������� ���� ������
            Case 4: .foreColor = &H808000    '���������
        End Select
    End With
End Sub


'######################################################
'��������� �������� ������ ��� �������� �����
Sub TrueCellSelInNum()

    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel

        With ActiveWorkbook
            If .Worksheets.count > 1 Then .Worksheets(1).Select '���� ������ ������ 1, �� ������� ������
            
            With .ActiveSheet
            
                Dim rTempCell As Range, i As Byte, j As Byte
                If FindCellRight("������", rTempCell) Then If rTempCell = "" Then rTempCell = Chr(150) '�������� ������� ����� �� ����
                Set rTempCell = Nothing
                            
                Dim sTempStr As String
                sTempStr = ActiveSheet.PageSetup.PrintArea
                If InStr(sTempStr, ":") > 0 Then ' ������� ������
                    sTempStr = Right(sTempStr, Len(sTempStr) - InStr(sTempStr, ":")): sTempStr = Replace(sTempStr, "$", "")
                    
                    Dim bColumnIndex As Byte
                    Select Case Left(sTempStr, 1)
                        Case "J": bColumnIndex = 10 '��� ���� ����������
                        Case Else: bColumnIndex = 16 '��� ������ ���������� (������������, �����)
                    End Select
                    
                    For i = 4 To 11
                        For j = 1 To 4
                            If InStr(CStr(.Cells(i, bColumnIndex + j)), "����� ���������") > 0 Then .Cells(i - 1, bColumnIndex + j).Select: Exit Sub
                        Next j
                    Next i
                    
                End If
            End With
        End With
    #End If
End Sub


'###################################################################
'��������� ���������� ��������� �������� ��������� � �������� ��������� �������� �� ����������
Sub ExportCopyOfDocument(objClsmExport As Object, SaveToSomnium As Boolean, _
        SaveToDesktop As Boolean, CreatePDF As Boolean, GroupExport As Boolean)
    
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            Dim sCurrentName As String
            sCurrentName = .name: SaveMeIfTemp sCurrentName   '���� ���� �� ��� ������� �����, �� ��������� ��� ����� ����������� �����������

            If GroupExport Then '��������� ��� ����� �������� ��������
                GroupFileExport objClsmExport, .path, SaveToSomnium, SaveToDesktop ' �������� ��������� ���������� ��������
            Else '��������� ������ �������� ����
                
                Dim sDestinationPath As String
                If SaveToSomnium Or SaveToDesktop Then '������� ����� �������� �� ������ �/��� �� ������� ����
                    
                    If SaveToSomnium Then '�������� �� ������
                        sDestinationPath = GetDestinationToServer(objClsmExport, sCurrentName, .path)
                        ExportToDestPath sCurrentName, .path, sDestinationPath, CreatePDF
                    End If
                                        
                    If SaveToDesktop Then '�������� �� ������� ����
                        sDestinationPath = "C:\Users\" & Environ("USERNAME") & "\Desktop\"
                        ExportToDestPath sCurrentName, .path, sDestinationPath, CreatePDF
                    End If
                Else '�� ��������� ����� ������������ � ������� �������
                    sDestinationPath = .path & "\"
                    ExportToDestPath sCurrentName, .path, sDestinationPath, CreatePDF
                End If
            End If
        End With
End Sub
'###################################################################
'��������������� ��������� ����������� ������ ��������
Sub ExportToDestPath(sCurrentName As String, sCurrentPath As String, _
    sDestinationPath As String, Optional CreatePDF As Boolean, Optional ReplaceExistingName As Boolean)
    
    If CreatePDF Then '���������� ����� � ������� pdf
        sCurrentName = GetFileNameWithOutExt(sCurrentName) '�������� ��� ����� ��� ����������: pr_210_2104_222_18
        TrueExportWithPDF ReturnNotExistingName(sDestinationPath, sCurrentName, ".pdf")
    Else
        If ReplaceExistingName Then '�������������� ��������� ���
            TrueExportWithPDF sDestinationPath & "\" & sCurrentName, sCurrentPath & "\" & sCurrentName
        Else
            TrueExportWithPDF ReturnNotExistingName(sDestinationPath, sCurrentName), sCurrentPath & "\" & sCurrentName
        End If
    End If
    
    If InStr(sDestinationPath, "\Desktop\") = 0 Then _
        Explorer.OpenFolder sDestinationPath, True   '������� ������� � ����
End Sub
'###################################################################
'������� ���������� ������� ����������
Function GetDestinationToServer(objClsmExport As Object, sCurrentName As String, sCurrentPath As String) As String
    
    Dim sCurrFileMask As String, sDestinationSecond As String, sSecondFileName As String, sDestinationPath  As String
    sCurrFileMask = GetFileNameWithOutExt(sCurrentName) '�������� ��� ����� ��� ����������: pr_210_2104_222_18
    
    If InStr(sCurrFileMask, "TEMP") = 0 Then  '�� �������������� �� ������ ����� ��� ������
        If InStr(sCurrFileMask, "_") > 0 Then sCurrFileMask = Right(sCurrFileMask, InStrRev(sCurrFileMask, "_") - 1)
        
        Select Case Right(objClsmExport.sendType, 1)
            Case 1 '�������� / �������������
                #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                    sDestinationPath = objClsmExport.wdSvPath: sDestinationSecond = objClsmExport.xlPrPath
                    sSecondFileName = Dir(sCurrentPath & "\*" & sCurrFileMask & "*.xls*")
                #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                    sDestinationPath = objClsmExport.xlPrPath: sDestinationSecond = objClsmExport.wdSvPath
                    sSecondFileName = Dir(sCurrentPath & "\*" & sCurrFileMask & "*.doc*")
                #End If
                
            Case 2 '�������� / ����������
                #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                    sDestinationPath = objClsmExport.wdSrtPath: sDestinationSecond = objClsmExport.xlPrcPath
                    sSecondFileName = Dir(sCurrentPath & "\*" & sCurrFileMask & "*.xls*")
                #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                    sDestinationPath = objClsmExport.xlPrcPath: sDestinationSecond = objClsmExport.wdSrtPath
                    sSecondFileName = Dir(sCurrentPath & "\*" & sCurrFileMask & "*.doc*")
                #End If
            Case 3 '���������
                #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                    sDestinationPath = objClsmExport.wdInPath
                #End If
        End Select
    End If

    If sSecondFileName <> "" Then
        TrueExportWithPDF ReturnNotExistingName(sDestinationSecond, sSecondFileName), sCurrentPath & "\" & sSecondFileName
        If InStr(sDestinationSecond, "\Desktop\") = 0 Then _
            Explorer.OpenFolder sDestinationSecond '������� ������� � ����
    End If
        
    GetDestinationToServer = sDestinationPath
End Function
'###################################################################
'��������� ��������� ����, ���� � ���� ����������� ���������� - ���� ���������
Sub SaveMeIfTemp(sCurrentName As String)
    If Not sCurrentName Like "*.*" Then '���� �� ��� ������� ����� - ��������� ��� �� ������� �����, ����� ������������ ��������� � ��� �����������
        
        #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
            ActiveDocument.SaveAs "C:\Users\" & Environ("USERNAME") & "\Desktop\" & sCurrentName, wdFormatDocumentDefault
        #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
            
            Dim myAppVer As String
            myAppVer = Application.Version
            
            If myAppVer = "11.0" Then '������ ��� 2003
                ActiveWorkbook.SaveAs "C:\Users\" & Environ("USERNAME") & "\Desktop\" & sCurrentName, xlWorkbook
            Else
                ActiveWorkbook.SaveAs "C:\Users\" & Environ("USERNAME") & "\Desktop\" & sCurrentName, xlOpenXMLWorkbook
            End If
        #End If
    End If
End Sub
'###################################################################
'������������ �������� ������ ������
Sub GroupFileExport(objClsmExport As Object, sCurrPath As String, SaveToSomnium As Boolean, SaveToDesktop As Boolean)
    
    Dim sArrNamesFiles() As String, collDestIsOpen As New Collection, sCurGroupName As String, sTempFMask As String, i As Integer, sDestinationPath As String
    ReDim sArrNamesFiles(0)
    
    sCurGroupName = Dir(sCurrPath & "\*.xls*")
    Do While sCurGroupName <> "" '��������� ������ ������� ������ xl
        If sArrNamesFiles(UBound(sArrNamesFiles)) <> "" Then ReDim Preserve sArrNamesFiles(UBound(sArrNamesFiles) + 1)
        sArrNamesFiles(UBound(sArrNamesFiles)) = sCurGroupName: sCurGroupName = Dir
    Loop
    
    sCurGroupName = Dir(sCurrPath & "\*.doc*")
    Do While sCurGroupName <> "" '��������� ������ ������� ������ wd
        If sArrNamesFiles(UBound(sArrNamesFiles)) <> "" Then ReDim Preserve sArrNamesFiles(UBound(sArrNamesFiles) + 1)
        sArrNamesFiles(UBound(sArrNamesFiles)) = sCurGroupName: sCurGroupName = Dir
    Loop
    
'    sCurGroupName = Dir(sCurrPath & "\*.pdf")
'    Do While sCurGroupName <> "" '��������� ������ ������� ������ pdf
'        If sArrNamesFiles(UBound(sArrNamesFiles)) <> "" Then ReDim Preserve sArrNamesFiles(UBound(sArrNamesFiles) + 1)
'        sArrNamesFiles(UBound(sArrNamesFiles)) = sCurGroupName: sCurGroupName = Dir
'    Loop
    
    SortMassOne sArrNamesFiles, True: ReplaceRepeateInArrOne sArrNamesFiles, "", True
    SortMassOne sArrNamesFiles: ReduceArrOne sArrNamesFiles
    
    With collDestIsOpen '������� ��������� ��� �������� ���������
        .Add "False", "pr_": .Add "False", "prc_": .Add "False", "sv_": .Add "False", "srt_": .Add "False", "in_"
    End With
    
    If SaveToSomnium Then '����� ������� �������� ������ � �������� ��������
        For i = LBound(sArrNamesFiles) To UBound(sArrNamesFiles)
            
            If InStr(sArrNamesFiles(i), "_") > 0 And InStr(sArrNamesFiles(i), "TEMP") = 0 Then '�� �������������� �� ������ ����� ��� ������
                sTempFMask = Left(sArrNamesFiles(i), InStr(sArrNamesFiles(i), "_"))

                Select Case sTempFMask
                    Case "pr_": sDestinationPath = objClsmExport.xlPrPath '��������� �������
                    Case "prc_": sDestinationPath = objClsmExport.xlPrcPath '��������� ����������
                    Case "sv_": sDestinationPath = objClsmExport.wdSvPath '������������� � �������
                    Case "srt_": sDestinationPath = objClsmExport.wdSrtPath '����������� ����������
                    Case "in_": sDestinationPath = objClsmExport.wdInPath '��������� � �������������
                End Select
                
                TrueExportWithPDF ReturnNotExistingName(sDestinationPath, sArrNamesFiles(i)), sCurrPath & "\" & sArrNamesFiles(i)
                
                With collDestIsOpen
                    If InStr(sDestinationPath, "\Desktop\") = 0 Then _
                        If .item(sTempFMask) = "False" Then .Remove (sTempFMask): .Add "True", sTempFMask: Explorer.OpenFolder sDestinationPath   '������� ������� � ����
                End With
            End If
        Next i
    End If
    
    If SaveToDesktop Then '����� ������� �������� ������ �� ������� ����
        sDestinationPath = "C:\Users\" & Environ("USERNAME") & "\Desktop\"
        
        For i = LBound(sArrNamesFiles) To UBound(sArrNamesFiles)
            TrueExportWithPDF ReturnNotExistingName(sDestinationPath, sArrNamesFiles(i)), sCurrPath & "\" & sArrNamesFiles(i)
        Next i
    End If
    
    Set collDestIsOpen = Nothing
End Sub
'###################################################################
'������� ������������ ������� �������� �� ���
Sub TrueExportWithPDF(sNewName As String, Optional sPrevName As String)

    If sNewName <> "�����������_�����" Then '������ ���� � �������� ����� � ����� TEMP
        If sPrevName = "" Then '������� � pdf
            
            #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
                ActiveDocument.ExportAsFixedFormat sNewName, wdExportFormatPDF, False, wdExportOptimizeForPrint
            #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                If SheetIsEmpty(ActiveWorkbook.ActiveSheet) Then MsgBox "���������� �������������� PDF �� ������� �����.", vbInformation: Exit Sub
                ActiveWorkbook.ExportAsFixedFormat xlTypePDF, sNewName, xlQualityStandard
            #End If
            
        Else '��������� ��� ������ �����
            CreateObject("Scripting.FileSystemObject").CopyFile sPrevName, sNewName
        End If
    Else
        MsgBox "�������� ����� �������� ��������� ������, �������� �� ������ ��������.", vbInformation
    End If
End Sub
'#################################################
'������� ���������, ���������� �� � ������ ���������� ���� � ����� ������, �, ���� ����������, ���������� � ���� ������
Function ReturnNotExistingName(sFinalDir As String, sFileName As String, Optional sExt As String) As String
    Dim i As Integer, sName As String, sTempName As String, sNewName As String
    
    If Right(sFinalDir, 1) <> "\" Then sFinalDir = sFinalDir & "\"
    
    If sExt = "" Then '���� � ������� ���� �������� ��� ����� ��������� � ������ ����������
        sName = GetFileNameWithOutExt(sFileName) '�������� ��� ��������� ��� ����������
        sExt = GetExt(sFileName) '�������� ���������� �����
    Else
        sName = sFileName
    End If
    
    sTempName = sName:    i = 1
    
    Do '���������, ���� ���� � ��������� ������ ���������� � ����������
        sNewName = sFinalDir & sTempName & sExt
        If Dir(sNewName) = "" Then Exit Do
        sTempName = sName & " (" & (i) & ")"
        i = i + 1
    Loop
    
    ReturnNotExistingName = sNewName
End Function
'###################################################################
'��������� ��������� ������� �������� ���������
Sub OpenMyFolder()
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        Explorer.OpenFolder ActiveDocument.path & "\", True
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        Explorer.OpenFolder ActiveWorkbook.path & "\", True
    #End If
End Sub
'#######################################################
'��������� ��������� �����, ���� ������ ������ ������ � xl
Sub TrueUnloadCreateProjectXl()
'    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
'        VBA.Unload H_UF_Create_Project_Xl
'    #End If
End Sub
'###################################################################
'������� �������� ������ � ������� ����������, � ����� ��������� ������
Function SaveAsTemplate( _
    ByRef objZ_clsmSearch As Z_clsmSearch, _
    myMIPackage As MeasInstrument _
    ) As Boolean
    
    SaveAsTemplate = False
    
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        SaveAsTemplate = LoadXlTemplate(objZ_clsmSearch, myMIPackage)
    #End If
End Function
'#######################################################
'��������� �������� ���� �������� � word �������� �� xl ���������
Sub ExportToSv()
'    #If CurrentAppCode = "xl" Then '������ ��� ���������� Word
'        H_UF_Create_Project_Xl.Show False
'    #End If
End Sub
'#######################################################
'������� ���������� ���������� � ����� �����
Function GetExt(sFileName As String) As String
    If InStr(sFileName, ".") = 0 Then Exit Function
    GetExt = Right(sFileName, InStr(StrReverse(sFileName), "."))
End Function
'#######################################################
'������� ���������� ��� ����� ��� ����������
Function GetFileNameWithOutExt(Optional sFileName As String) As String

    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            If sFileName = "" Then sFileName = .name
            
            GetFileNameWithOutExt = sFileName: If InStr(sFileName, ".") = 0 Then Exit Function
            GetFileNameWithOutExt = Left(sFileName, Len(sFileName) - InStr(StrReverse(sFileName), "."))
        End With
End Function
'###################################################################
'������������� ��������� ��� ���������� ������ ����� ������������
Sub PasteEtalons(sArrDataBase() As String)
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        PasteEtalonsData sArrDataBase
    #End If
End Sub


'#################################################
'��������� ����� �������� ��� ����������
Function SaveNewVersion(sStartDir As String) As String
    Dim sCurrVer As String, sNewVer As String, sDestinationPath As String, sCurVerDate As String, _
        sUpdateFilePath As String, sArrTemp() As String
        
    sDestinationPath = "C:\Users\" & Environ("USERNAME") & "\Desktop\"
    sUpdateFilePath = sDestinationPath & "\update.ini" '���� �������� ������ ����������
    
    sCurrVer = GetCDProp("Version")
    If FileExist(sUpdateFilePath) Then '���� ������� ����� �������������� ���� ������
        
        Open sUpdateFilePath For Input As #1 '�������� �������� ���������� � ����
            sArrTemp = Split(Input$(LOF(1), #1), vbNewLine) '��������� � ������ ���������� ����� �����
        Close
        
        sCurrVer = sArrTemp(LBound(sArrTemp) + 1)
    End If

    sNewVer = InputBox("���� ������ ������", "���������� ���������", sCurrVer): If sNewVer = "" Then sNewVer = sCurrVer
    LetCDProp "Version", sNewVer: LetCDProp "VersionDate", Date
    LetBIDProp "Comments", sNewVer: LetBIDProp "Category", Date
    
    Dim sCurrentName As String, sCurrentPath As String
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ThisDocument
            .Saved = False: .Save: sCurrentName = .name: sCurrentPath = .path
        End With
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ThisWorkbook
            .Save: sCurrentName = .name: sCurrentPath = .path
        End With
    #End If
    
    ExportToDestPath sCurrentName, sCurrentPath, sDestinationPath, , True '������� �� ������� ����
    
    Open sUpdateFilePath For Output As #1 '�������� �������� ���������� � ����
        Print #1, Date & vbNewLine & sNewVer
    Close
    
    Explorer.OpenFolder sStartDir, True
End Function
'#################################################
'������� ���������� �������� �������� �� ���������
Function GetCDProp(sPropName As String) As String
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ThisDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ThisWorkbook
    #End If
            GetCDProp = .CustomDocumentProperties(sPropName)
        End With
End Function
'#################################################
'������� ����������� �������� �������� �� ���������
Sub LetCDProp(sPropName As String, sPropText As String)
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ThisDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ThisWorkbook
    #End If
            .CustomDocumentProperties(sPropName) = sPropText
        End With
End Sub
'#################################################
'������� ����������� �������� �������� �� ���������
Sub LetBIDProp(sPropName As String, sPropText As String)
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ThisDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ThisWorkbook
    #End If
            .BuiltinDocumentProperties(sPropName) = sPropText
        End With
End Sub
'#################################################
'������������� ������� ��� �������� ���������� �����
Sub FillIfXl(objClsm As Z_clsmConstructor, sArrDataBase() As String, iListIndex As Integer)
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
                
        Dim myInstr As MeasInstrument
        myInstr.sName = sArrDataBase(0, iListIndex) '������������
        myInstr.sType = sArrDataBase(1, iListIndex) '���
        myInstr.sFif = sArrDataBase(2, iListIndex) '����� � ���
        
        myInstr.sModification = InputBox("������� ����������� ��" & vbNewLine & "��� �������� ������� ����������", , GetDefaultInput(myInstr)) ' "��� �����������")
        If myInstr.sModification = "" Then Z_UF_Constructor.cmbFillTempProp.Enabled = True: Exit Sub
        
        Dim sTempStr As String
        sTempStr = objClsm.templatesDir & myInstr.sType & "_" & myInstr.sFif & "\"
        If FolderNotExist(sTempStr) Then MkDir sTempStr '������� ����� �������
        
        Explorer.OpenFolder sTempStr: FillTempProperties myInstr, sTempStr
    #End If
End Sub
'#########################################################
'��������� ������ ������� � ������ ��� ��������� ���� ������
Sub TrueMkDir(objZ_clsmBase As Z_clsmBase, objClsmSrch As Z_clsmSearch, sArrDataBase() As String)
    Dim sFullCusName As String, sType As String, sLastSaveDate As String, sDocumentName As String
    
    #If CurrentAppCode = "wd" Then '������ ��� ���������� Word
        With ActiveDocument
    #ElseIf CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        With ActiveWorkbook
    #End If
            sFullCusName = .BuiltinDocumentProperties("Company")
            sType = .BuiltinDocumentProperties("Comments")
            
            sDocumentName = GetFileNameWithOutExt(.name)
            sLastSaveDate = .BuiltinDocumentProperties("Last Save Time")
            
            If InStr(sDocumentName, "_") > 0 Then '������ �� ������
                Dim sArrTemp() As String
                sArrTemp = Split(sDocumentName, "_") '�������� ��������� ����� ������������
                        
                sDocumentName = sArrTemp(LBound(sArrTemp))
                If UBound(sArrTemp) > 0 Then sDocumentName = sDocumentName & "_" & sArrTemp(UBound(sArrTemp) - 1) & "_" & sArrTemp(UBound(sArrTemp))
                
            End If
        End With
        
    With objClsmSrch
    
        Dim sShortCusName As String, sArrData() As String, i As Integer
        If sFullCusName <> "" Then '�������� ����� ���� ��������
            sArrData = .FillDataBase(objZ_clsmBase.GetArrFF(.startDir, .DbName), True) '������������� ������ ����� � ������ ���� ������
        
            For i = LBound(sArrData, 2) To UBound(sArrData, 2) '�������� ������� ������������ �����������
                If InStr(sArrData(0, i), sFullCusName) > 0 Then sShortCusName = sArrData(2, i): Exit For
            Next
            If sShortCusName = "" Then MsgBox "�������� �� ������ � ���� ������. ���������� �����������.": Exit Sub
            
        End If
        
        If sFullCusName = "" Then _
            sShortCusName = InputBox("�������� ��������� �� ��������. ������� �������� ����� ���������:", "���� ������"): If sShortCusName = "" Then Exit Sub
        
        Dim sDirName As String
        
        If sType = "" Then _
            sType = InputBox("�������� �� �� ��������. ������� �������� ����� ��:", "���� ������"): If sType = "" Then Exit Sub
        
        sShortCusName = ReplaceBadSymbols(sShortCusName): sType = ReplaceBadSymbols(sType) '������ ����������� � ����� ����� �������
'        sDocumentName = Replace(sDocumentName, "pr_", "sv_")
'        sDocumentName = Replace(sDocumentName, "jr_", "sv_")
'        sDocumentName = Replace(sDocumentName, "prc_", "srt_")
'        sDocumentName = Replace(sDocumentName, "jrc_", "srt_")
        
        If InStr(sDocumentName, "prm_") > 0 Then sDocumentName = "���������"

        sDirName = Format(sLastSaveDate, "yyyy.mm") & " " & _
                    sType & " -- " & _
                    sShortCusName & " - " & _
                    sDocumentName
        
        If Not sDocumentName = "���������" Then
            
            If InStr(sDocumentName, "prc_") > 0 Then _
                sDirName = sDirName & " srt_"
                
            If InStr(sDocumentName, "pr_") > 0 Then _
                sDirName = sDirName & " sv_"
        End If
        
        Dim currfgisSvNum As String
        currfgisSvNum = ActiveWorkbook.BuiltinDocumentProperties("Subject")
        
        If currfgisSvNum <> vbNullString Then _
        currfgisSvNum = Right(currfgisSvNum, InStr(StrReverse(currfgisSvNum), "/") - 1)
        
        If currfgisSvNum <> vbNullString Then _
            sDirName = sDirName & currfgisSvNum
        
        If Dir(.ArchivePath & sDirName, vbDirectory) <> "" Then
            MsgBox sDirName & vbNewLine & vbNewLine & "������� ��� ����������."
        Else
            sDirName = InputBox("��� ������������ ��������:", "����������� ����", sDirName)
            
            If sDirName <> "" Then
                sDirName = ReplaceBadSymbols(sDirName): sDirName = .ArchivePath & sDirName
                
                If Dir(sDirName, vbDirectory) = "" Then
                    MkSubDir .ArchivePath, sLastSaveDate, sArrDataBase(0, 0)
                    
                    MkDir sDirName
                  '  CreateShortcut sDirName
                End If
                
                Explorer.OpenFolder sDirName, True

            End If
        End If
    End With
    
    DataBase.ReCacheData
    
End Sub
'#########################################################
'��������� ������ �������������� ������� ��� ���������������
Sub MkSubDir(sArchvePath As String, sLastSaveDate As String, sFirstListDirDate As String)
    
    If sFirstListDirDate = "" Then Exit Sub '���� ������ ������� �� ������
    sLastSaveDate = Format(sLastSaveDate, "yyyy.mm")
    sFirstListDirDate = Left(sFirstListDirDate, InStr(sFirstListDirDate, " ") - 1) '�������� ����� ��� + �����
    
    Dim sTempDirName As String
    If Left(sLastSaveDate, 4) > Left(sFirstListDirDate, 4) Then '���� ��� ������������ �������� �����
        
        sTempDirName = sArchvePath & Left(sLastSaveDate, 4) & " +++++++++++++++++++++++++++++++"
        
        If FolderNotExist(sTempDirName) Then _
            MkDir sTempDirName '������� �������, ���� ��� ���
        
    ElseIf Left(sLastSaveDate, 4) = Left(sFirstListDirDate, 4) Then '���� � ��� �� ���
        
        If Right(sLastSaveDate, 2) <> Right(sFirstListDirDate, 2) Then '����� ����������
            sTempDirName = sArchvePath & sLastSaveDate & "  ============================="
            
            If FolderNotExist(sTempDirName) Then _
                MkDir sTempDirName '������� �������, ���� ��� ���
        End If
    End If
End Sub
'#########################################################
'��������� ��������� ������ �������� ��������� �� ���� ������
Sub FillNameInstrument(miData As MeasInstrument)
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        Application.ScreenUpdating = False
        Dim ws As Worksheet, rTempCell As Range
        
        With miData
        
            For Each ws In ActiveWorkbook.Worksheets
                If FindCellRight("������������", rTempCell, , , , ws) Then rTempCell = .sName & " " & .sType  '������������ ��
                If FindCellRight("���", rTempCell, , , , ws) Then rTempCell = .sFif  '���
                If FindCellRight("��������", rTempCell, , , , ws) Then rTempCell = .sMetodic '��������
            Next
        End With
        Set rTempCell = Nothing: Application.ScreenUpdating = True
        
        ActiveWorkbook.Save
    #End If
End Sub
'#########################################################
'������� ��������� ��������� ����� �� ������ � ������� ��� � ���������
Function GetSerialNumFromCell() As String
    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
        
        Dim rTempCell As Range, sTempStr As String
        If FindCellRight("��������� / �������� �����:", rTempCell) Then _
            sTempStr = CStr(rTempCell): DeleteSpaceStEnd sTempStr
        
        GetSerialNumFromCell = "prm_TEMP_PROTOCOL"
        If sTempStr <> "" Then GetSerialNumFromCell = "prm_" & sTempStr
        Set rTempCell = Nothing
    #End If
End Function

'#########################################################
'�������������� ������� ��� ����� word � excel
Sub SubExportFormatting()
'    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
'        ExportFormatting True
'    #End If
End Sub
'#########################################################
Sub ChangeXlPropertyComment(myInstrument As MeasInstrument)

    #If CurrentAppCode = "xl" Then '������ ��� ���������� Excel
    
        
        With ActiveWorkbook
            If .Sheets.count = 1 Then
                If InStr(.ActiveSheet.name, myInstrument.sType) = 0 Then '���� ��� ����������� �� �������� � ���� ��� ����
                    SetBuiltInProperty "Comments", myInstrument.sType & " (" & .ActiveSheet.name & ")" '��� �������� ����� � �����
                Else
                    SetBuiltInProperty "Comments", .ActiveSheet.name '��� �������� ����� � �����
                End If
            Else
                SetBuiltInProperty "Comments", myInstrument.sType '��������� ������� ������
            End If
        End With
    #End If
End Sub
