VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cItemKeysEtalon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' ����: 17.03.2023 11:11
' �����: akolodka
' ����������: ����� ������� � �������� ���� ��������
' ----------------------------------------------------------------

Option Explicit

Const TYPE_DEVICE_KEY = "����������� ����"
Const FACTORY_NUMBER_KEY = "��������� �����"

Const FGIS_REG_NUMBER_KEY = "���. ����� ���"
Const NUMBER_DOCUMENT_KEY = "����� ���������"
Const DATE_EXPIRE_KEY = "���� ��������"

Const COMMENT_KEY = "�����������"
Public Property Get typeDevice() As String
    typeDevice = TYPE_DEVICE_KEY
End Property
Public Property Get factoryNumber() As String
    factoryNumber = FACTORY_NUMBER_KEY
End Property
' ----------------------------------------------------------------
Public Property Get regFgisNum() As String
    regFgisNum = FGIS_REG_NUMBER_KEY
End Property
Public Property Get numberDocument() As String
    numberDocument = NUMBER_DOCUMENT_KEY
End Property
Public Property Get dateExpire() As String
    dateExpire = DATE_EXPIRE_KEY
End Property
' ----------------------------------------------------------------
Public Property Get comment() As String
    comment = COMMENT_KEY
End Property
