VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Z_clsmConstructor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private sArrValCfg() As String, sArrParamCfg() As String, sArrValSet() As String, sArrParamSet() As String
Property Get startDir() As String
    startDir = GetProp("startDir")
End Property
Property Get DbName() As String
    DbName = GetProp("DB")
End Property
Property Get constrSrch() As String
    constrSrch = GetProp("constrSrch") '��������� ���������� "Search" ����������� - � ����� ������ ������������� ���������
End Property
Property Get templatesDir() As String
    templatesDir = GetProp("templatesDir")
End Property

Property Get myValues() As String()
    myValues = sArrValSet
End Property
Property Get myParameters() As String()
    myParameters = sArrParamSet
End Property
'#######################################################
'������� ������� � ����� �������� � �������
Function FillConfiguration(Parameters() As String, values() As String)
    sArrValCfg = values: sArrParamCfg = Parameters
End Function
'#######################################################
'������� ������� � ����� �������� � �������
Function FillSettings(Parameters() As String, values() As String)
    sArrValSet = values: sArrParamSet = Parameters
End Function
'#######################################################
'������� ������� ������ �������� �� �����
Private Function GetProp(keyProp As String) As String
    Dim i As Integer
    For i = LBound(sArrParamCfg) To UBound(sArrParamCfg)
        If sArrParamCfg(i) Like "*" & keyProp & "*" Then GetProp = sArrValCfg(i): Exit Function
    Next i
    For i = LBound(sArrParamSet) To UBound(sArrParamSet)
        If sArrParamSet(i) Like "*" & keyProp & "*" Then GetProp = sArrValSet(i): Exit Function
    Next i
End Function
'#######################################################
'������� ��������� ����������� ������ ������
Function FillDataBase(sArrFile() As String, Optional AllData As Boolean) As String()
    Dim i As Integer, j As Integer, sArrTemp() As String, sArrKeyC() As String
    If AllData Then '������ ���� ��������
        sArrTemp = Split(sArrFile(0), InStrDelimiter) '������� ������ � ������� � �������� ��� ������
        ReDim sArrKeyC(UBound(sArrTemp), UBound(sArrFile)) '�������� ������ ��� ������
        If UMenu.typ� = instrumentsOLD Then ReDim sArrKeyC(UBound(sArrTemp) + 1, UBound(sArrFile)) '�������� ������ ��� ������
    Else '��������� ������ ��������
        ReDim sArrKeyC(1, UBound(sArrFile)) '�������� ������ ��� ������ � ����� ���������
        ' 0 - ������������� ���������
        ' 1 - ������������ ���������
    End If
    For i = LBound(sArrFile) To UBound(sArrFile)
        sArrTemp = Split(sArrFile(i), InStrDelimiter) '������� ������ � ������� � �������� ��� ������
        For j = LBound(sArrTemp()) To UBound(sArrTemp())
            If AllData Then '������ ���� ��������
                sArrKeyC(j, i) = sArrTemp(j)
            Else '��������� ������ ��������
                sArrKeyC(LBound(sArrKeyC), i) = sArrTemp(UBound(sArrTemp) - 1)
                sArrKeyC(UBound(sArrKeyC), i) = sArrTemp(UBound(sArrTemp))
                Exit For
            End If
        Next j
    Next i
    FillDataBase = sArrKeyC
End Function
