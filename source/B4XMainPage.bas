B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
#Macro: Title, Sync files, ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#Macro: Title, Export as zip, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip
#End Region

Sub Class_Globals
	#If B4J
	Private fx 				As JFX
	#End If	
	Private xui 			As XUI
	Public Root 			As B4XView
	Private mBase 			As B4XView
	Private Drawer 			As B4XDrawer
	Private LblTitle 		As Label
	Private lblAppVersion1 	As Label
	Private lblAppVersion2 	As Label
	Private LblMiniLabel 	As Label
	Private BtnMenu 		As B4XView
	Private BtnHide 		As B4XView
	Private BtnShow 		As B4XView
	Private BtnExit 		As Button
	Private Button1 		As Button
	Private PnlRoot 		As B4XView
	Private PnlMini 		As B4XView
	Private PnlStatic 		As B4XView
	Private PnlCenter 		As B4XView
	Private ClvMenuMini 	As CustomListView
	Private ClvMenuStatic 	As CustomListView
	Private ClvMenuDrawer 	As CustomListView
	Private CurrentObject	As Object
	Private Title 			As String = "Dashboard"
	Private MenuMode		As String = "Static"
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	SetTitle
	InitDrawer
	InitPanel
	InitMenu
	LoadPage(Me)
	#If B4J
	SetButtonMousePointer
	CSSUtils.SetStyleProperty(BtnExit, "-fx-focus-color", "black")
	CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "slateblue")
	#End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Drawer.IsInitialized Then Drawer.Resize(Width, Height)
	'If ContentEmpty = False Then
	'	PnlCenter.GetView(0).SetLayoutAnimated(0, 0, 0, PnlCenter.Width, PnlCenter.Height)
	'End If
End Sub

Sub SetTitle
	B4XPages.SetTitle(Me, Title)
End Sub

Sub InitDrawer
	Drawer.Initialize(Me, "Drawer", Root, 300dip)
	Drawer.LeftPanel.LoadLayout("LeftDrawer")
	Drawer.CenterPanel.LoadLayout("MainPanel")
	lblAppVersion1.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
	BtnShow.Rotation = 45
End Sub

Sub InitPanel
	LblTitle.Text = Title
	PnlMini.LoadLayout("PanelMini")
	PnlStatic.LoadLayout("PanelStatic")
	lblAppVersion1.Text = $"${Title}${CRLF}Version ${Main.Version}"$
	lblAppVersion2.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
	Select MenuMode
		Case "Mini"
			ModeMini
		Case "Static"
			ModeStatic
		Case Else
			ModeDrawer
	End Select
	#If B4J
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuMini, xui.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuStatic, xui.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuDrawer, xui.Color_Transparent)
	#End If
End Sub

Public Sub InitMenu
	ClvMenuDrawer.Clear
	Dim P1 As Page1
	Dim P2 As Page2
	P1.Initialize
	P2.Initialize
	ClvMenuDrawer.AddTextItem("Dashboard", Me)
	ClvMenuDrawer.AddTextItem("Page1", P1)
	ClvMenuDrawer.AddTextItem("Page2", P2)
	
	ClvMenuStatic.AddTextItem("Dashboard", Me)
	ClvMenuStatic.AddTextItem("Page1", P1)
	ClvMenuStatic.AddTextItem("Page2", P2)
	
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF015), ClvMenuMini.AsView.Width), Me)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF004), ClvMenuMini.AsView.Width), P1)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF06B), ClvMenuMini.AsView.Width), P2)
End Sub

#If B4J
Sub BtnMenu_MouseClicked (EventData As MouseEvent)
#Else
Sub BtnMenu_Click
#End If
	Select MenuMode
		Case "Mini", "Static"
			SwitchMenu
		Case Else
			Drawer.LeftOpen = Not(Drawer.LeftOpen)
	End Select
	'LoadPage(CurrentObject)
End Sub

Private Sub BtnExit_Click
	#If Not(B4i)
	ExitApplication
	#End If
End Sub

#If B4J
Private Sub BtnHide_MouseClicked (EventData As MouseEvent)
#Else
Private Sub BtnHide_Click
#End If
	MenuMode = "Drawer"
	ModeDrawer
	LoadPage(CurrentObject)
End Sub

#If B4J
Private Sub BtnShow_MouseClicked (EventData As MouseEvent)
#Else
Private Sub BtnShow_Click
#End If
	Drawer.LeftOpen = False
	MenuMode = "Static"
	ModeStatic
	LoadPage(CurrentObject)
End Sub

Sub Drawer_StateChanged (Open As Boolean)
	If Open Then

	Else

	End If
End Sub

Private Sub ContentEmpty As Boolean
	Return PnlCenter.NumberOfViews = 0
End Sub

Private Sub LoadPage (Value As Object)
	If ContentEmpty = False Then PnlCenter.GetView(0).RemoveViewFromParent
	CallSub2(Value, "Show", PnlCenter)
	CurrentObject = Value
End Sub

Public Sub Show (Parent As B4XView)
	If NotInitialized(mBase) Then
		mBase = xui.CreatePanel("")
		PnlCenter.AddView(mBase, 0, 0, PnlCenter.Width, PnlCenter.Height)
		mBase.LoadLayout("Dashboard")
	Else
		mBase.RemoveViewFromParent
		Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
	End If
End Sub

Private Sub ClvMenuMini_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
End Sub

Private Sub ClvMenuStatic_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
End Sub

Private Sub ClvDrawer_ItemClick (Index As Int, Value As Object)
	Drawer.LeftOpen = False
	LoadPage(Value)
End Sub

Sub SwitchMenu
	Select MenuMode
		Case "Mini"
			MenuMode = "Static"
			ModeStatic
		Case "Static"
			MenuMode = "Mini"
			ModeMini
	End Select
	LoadPage(CurrentObject)
End Sub

Private Sub ModeMini
	PnlMini.Visible = True
	PnlStatic.Visible = False
	PnlCenter.Width = Root.Width - PnlMini.Width
	PnlCenter.Left = PnlMini.Width
End Sub

Private Sub ModeStatic
	PnlMini.Visible = False
	PnlStatic.Visible = True
	PnlCenter.Width = Root.Width - PnlStatic.Width
	PnlCenter.Left = PnlStatic.Left + PnlStatic.Width	
End Sub

Private Sub ModeDrawer
	PnlMini.Visible = False
	PnlStatic.Visible = False
	PnlCenter.Width = Root.Width
	PnlCenter.Left = 0
End Sub

Sub CreateMiniItem (Text As String, Width As Int) As B4XView
	Dim pnl As B4XView = xui.CreatePanel("")
	pnl.SetLayoutAnimated(0, 0, 0, Width, 60dip)
	pnl.LoadLayout("MiniItem")
	LblMiniLabel.Text = Text
	#If B4J
	pnl.As(Pane).MouseCursor = fx.Cursors.HAND
	#End If
	Return pnl
End Sub

#If B4J
' B4J specific UI
Private Sub SetScrollPaneBackgroundColor (View As CustomListView, Color As Int)
	Dim SP As JavaObject = View.GetBase.GetView(0)
	Dim V As B4XView = SP
	V.Color = Color
	Dim V As B4XView = SP.RunMethod("lookup", Array(".viewport"))
	V.Color = Color
End Sub

Private Sub SetButtonMousePointer
	BtnMenu.MouseCursor = fx.Cursors.HAND
	BtnExit.MouseCursor = fx.Cursors.HAND
	BtnHide.MouseCursor = fx.Cursors.HAND
	BtnShow.MouseCursor = fx.Cursors.HAND
	Button1.MouseCursor = fx.Cursors.HAND
End Sub
#End If