VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cItemKeysOrganisation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ------------------------------------------------------
' ������������: cItemKeysOrganisation (Class Module)
' ����������: ����� ������� � �������� �� �����������
' �����: akolodka
' Date: 24.02.2023 19:21
' ------------------------------------------------------

Option Explicit

Const SHORTNAME_KEY = "������������ �������"
Const FULLNAME_KEY = "������������ ������"
Const LEGAL_ADDRESS_KEY = "����������� �����"
Const TAXNUMBER_KEY = "���"
Const COUNTRY_KEY = "������"

Friend Property Get shortName() As String
    shortName = SHORTNAME_KEY
End Property

Friend Property Get fullName() As String
    fullName = FULLNAME_KEY
End Property

Friend Property Get legalAddress() As String
    legalAddress = LEGAL_ADDRESS_KEY
End Property

Friend Property Get taxNumber() As String
    taxNumber = TAXNUMBER_KEY
End Property

Friend Property Get country() As String
    country = COUNTRY_KEY
End Property
