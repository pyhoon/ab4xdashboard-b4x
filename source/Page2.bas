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
	Private Root As B4XView
	Private mBase As B4XView
	Private Label2 As B4XView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub Show (Parent As B4XView)
	If NotInitialized(mBase) Then
		Root = B4XPages.MainPage.Root
		mBase = xui.CreatePanel("")
		Parent.AddView(mBase, 0, 0, Root.Width, Root.Height)
		mBase.LoadLayout("Page2")
	Else
		mBase.RemoveViewFromParent
		Parent.AddView(mBase, 0, 0, Root.Width, Root.Height)
	End If
	Label2.Text = "Page 2"
End Sub