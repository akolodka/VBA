VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cItemKeysArchive"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' ����: 19.03.2023 10:02
' �����: akolodka
' ----------------------------------------------------------------

Option Explicit

Const DATE_BEGIN_KEY = "���� ������ �����"
Const DATE_FINISH_KEY = "���� ��������� �����"

Const TYPE_SERIAL_KEY = "������������� ��"
Const ORGANISATION_KEY = "�����������"
Const COMMENT_KEY = "�����������"

Public Property Get beginDate() As String
    beginDate = DATE_BEGIN_KEY
End Property

Public Property Get endDate() As String
    endDate = DATE_FINISH_KEY
End Property

Public Property Get typeSerial() As String
    typeSerial = TYPE_SERIAL_KEY
End Property

Public Property Get organisation() As String
    organisation = ORGANISATION_KEY
End Property

Public Property Get comment() As String
    comment = COMMENT_KEY
End Property
