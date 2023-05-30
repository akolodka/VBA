Attribute VB_Name = "RibbonCallbacks"
Option Explicit

Public myRibbonObject As IRibbonUI

'customUI (�������: customUI, �������: onLoad), 2010+
Private Sub Updateribbon(ribbon As IRibbonUI)
    Set myRibbonObject = ribbon
End Sub

'autoUpdateConfig (�������: button, �������: onAction), 2010+
Private Sub ribbon_UpdateMenu(control As IRibbonControl)
    
    frmUpdateConfig.Show False
    
End Sub
'cmbUpdate (�������: button, �������: getVisible), 2010+
Private Sub btnUpdateVisible( _
    control As IRibbonControl, _
    ByRef visible _
    )
    
    visible = False

    If Not Cache.isUpdateAvailable Then _
        Exit Sub

    If Not Config.isInstallAuto Then _
        visible = True: _
        Exit Sub
        
 '   Update.Install
End Sub
'cmbUpdate (�������: button, �������: onAction), 2010+
Private Sub ribbon_GetUpdate( _
    control As IRibbonControl _
    )

    Update.Install normalMode
    
    myRibbonObject.InvalidateControl "btnUpdate"
    Handler.Notify "���������� ���������."
    
End Sub
