VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cItemKeysPerson"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' ����: 12.03.2023 21:18
' �����: akolodka
' ����������: ����� ��� �� �����������
' ----------------------------------------------------------------
Option Explicit

Const LASTNAME_KEY = "�������"
Const FIRSTNAME_KEY = "���"
Const MIDDLENAME_KEY = "��������"
Const STATE_KEY = "���������"
Const PHONE_NUMBER_KEY = "�������"
Const EMAIL_KEY = "Email"
Const ORGANISATION_KEY = "�����������"
Const BIRTHDAY_KEY = "���� ��������"

Friend Property Get lastName() As String
    lastName = LASTNAME_KEY
End Property

Friend Property Get firstName() As String
    firstName = FIRSTNAME_KEY
End Property

Friend Property Get middleName() As String
    middleName = MIDDLENAME_KEY
End Property

Friend Property Get state() As String
    state = STATE_KEY
End Property

Friend Property Get organisation() As String
    organisation = ORGANISATION_KEY
End Property

Friend Property Get birthDay() As String
    birthDay = BIRTHDAY_KEY
End Property

Friend Property Get phoneNumber() As String
    phoneNumber = PHONE_NUMBER_KEY
End Property

Friend Property Get email() As String
    email = EMAIL_KEY
End Property
