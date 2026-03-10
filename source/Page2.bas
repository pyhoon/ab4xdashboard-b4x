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
	Private Label2 As B4XView
End Sub

Public Sub Initialize As Object
'	mBase = xui.CreatePanel("")
'	mBase.LoadLayout("Page2")
'	Label2.Text = "Page 2"
	Return Me
End Sub

'Private Sub B4XPage_Created (Root1 As B4XView)
'	'Root = Root1
'	'mBase = Root1
'	mBase = xui.CreatePanel("")
'	mBase.LoadLayout("Page2")
'	Label2.Text = "Page 2"
'End Sub

Public Sub Show (Parent As B4XView)
	If mBase.IsInitialized = False Then
		mBase = xui.CreatePanel("")
		mBase.LoadLayout("Page2")
	End If	
	mBase.RemoveViewFromParent
	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
	Label2.Text = "Page 2"
End Sub

'Public Sub Show (Parent As B4XView)
''	If mBase.IsInitialized = False Then
''		mBase = xui.CreatePanel("")
''		mBase.LoadLayout("Page2")
''	End If
'	'mBase.RemoveViewFromParent
'	'Parent.AddView(Root, 0, 0, Parent.Width, Parent.Height)
'	B4XPages.MainPage.ShowPage(mBase)
'	Label2.Text = "Page 2"
'End Sub
