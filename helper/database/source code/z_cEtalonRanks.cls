VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "z_cEtalonRanks"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Enum ERankTypes

    primaryStandard
    secondaryStandard
    workStandard
    instrumentLikeStandard
    measuringInstrument

End Enum

Const RANK_PRIMARY_KEY = "��������� ������ ��"
Const RANK_SECONDARY_KEY = "��������� ������ ��"
Const RANK_WORK_KEY = "������� ������ ��"
Const RANK_INSTRUMENT_LIKE_STANDARD_KEY = "�������� ��������� �� ��� ������"
Const RANK_MEASURING_INSTRUMENT_KEY = "�������� ��������� ��"

' ----------------------------------------------------------------
Public Property Get primaryStandardKey() As String
    primaryStandardKey = RANK_PRIMARY_KEY
End Property
Public Property Get secondaryStandardKey() As String
    secondaryStandardKey = RANK_SECONDARY_KEY
End Property
Public Property Get workStandardKey() As String
    workStandardKey = RANK_WORK_KEY
End Property
Public Property Get instrumentLikeStandardKey() As String
    instrumentLikeStandardKey = RANK_INSTRUMENT_LIKE_STANDARD_KEY
End Property
Public Property Get instrumentKey() As String
    instrumentKey = RANK_MEASURING_INSTRUMENT_KEY
End Property

