B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	#If B4J
	Private fx As JFX
	#End If
	Private xui As XUI
	'Private Root As B4XView
	Public mBase As B4XView
	Private Label1 As B4XView
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

'Private Sub B4XPage_Created (Root1 As B4XView)
'	'Root = Root1
'	If mBase.IsInitialized = False Then
'		'mBase = Root1
'		mBase = xui.CreatePanel("")
'		mBase.LoadLayout("Page1")
'		Label1.Text = "Page 1"
'	End If
'End Sub

Public Sub Show (Parent As B4XView)
	If mBase.IsInitialized = False Then
		'mBase = Root1
		mBase = xui.CreatePanel("")
		mBase.LoadLayout("Page1")
		Label1.Text = "Page 1"
	End If	
    mBase.RemoveViewFromParent
    Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
End Sub