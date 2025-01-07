B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Public mBase As B4XView
	Private fx As JFX
	Private xui As XUI
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub Show (Parent As B4XView)
	If mBase.IsInitialized = False Then
		mBase = xui.CreatePanel("")
		mBase.LoadLayout("Form1")
	End If
	mBase.RemoveViewFromParent
	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
End Sub
