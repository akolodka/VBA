VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cErrorMessages"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' ����: 25.03.2023 16:44
' �����: akolodka
' ����������:
' ----------------------------------------------------------------
Option Explicit

Public Property Get journalBusy( _
    userName As String _
    ) As String
    
    journalBusy = "��������: ������ ����� �" & userName & "�."
End Property

Public Property Get journalNotFinded() As String
    journalNotFinded = "��������: ������ ���������� �� ������ " & Config.journalPath & "."
End Property

Public Property Get columnTypeNotFinded() As String
    columnTypeNotFinded = "��������: � ����� ������� ����������� ������� ���� ��."
End Property

Public Property Get columnSerialNotFinded() As String
    columnSerialNotFinded = "��������: � ����� ������� ����������� ������� ���������� ������ ��."
End Property

Public Property Get columnProtocolNumberNotFinded() As String
    columnProtocolNumberNotFinded = "��������: � ����� ������� ����������� ������� ������ ���������."
End Property

Public Property Get columnFgisNumberNotFinded() As String
    columnFgisNumberNotFinded = "��������: � ����� ������� ����������� ������� ������ ��������� ����."
End Property

Public Property Get columnFgisLinkNotFinded() As String
    columnFgisLinkNotFinded = "��������: � ����� ������� ����������� ������� ������ �� ������ �� ����."
End Property

Public Property Get incorrectTypeInstrument() As String
    incorrectTypeInstrument = "��������: ������������ ��� ��."
End Property

Public Property Get incorrectFactoryNumber() As String
    incorrectFactoryNumber = "��������: ������������ ��������� ����� ��."
End Property

Public Property Get incorrectProtocolNumber() As String
    incorrectProtocolNumber = "��������: ������������ ����� ���������."
End Property

Public Property Get incorrectFgisDocumentNumber() As String
    incorrectFgisDocumentNumber = "��������: ������������ ����� ��������� ����."
End Property

Public Property Get incorrectFgisLinkNumber() As String
    incorrectFgisLinkNumber = "��������: ������������ ����� ������ ����."
End Property

Public Property Get incorrectDateVerifying() As String
    incorrectDateVerifying = "��������: ������������ ���� �������."
End Property
