Attribute VB_Name = "RibbonCallbacks"
Option Explicit '����������� ������ ���������� ���� ���������� � �����

'contractsConfig (�������: button, �������: onAction), 2010+
Private Sub ContractsConfig(control As IRibbonControl)
    OpenConfig
End Sub

'buttonContracts (�������: button, �������: onAction), 2010+
Private Sub ContractsMain(control As IRibbonControl)

    InitiateUnload
    frmContractsMain.Show False
End Sub

