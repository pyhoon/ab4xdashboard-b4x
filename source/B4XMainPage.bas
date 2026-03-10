B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	#If B4J
	Private fx 				As JFX
	#End If	
	Private xui 			As XUI
	Private Root 			As B4XView
	Public mBase 			As B4XView
	Private Drawer 			As B4XDrawer
	Private LblTitle 		As Label
	Private lblAppVersion1 	As Label
	Private lblAppVersion2 	As Label
	Private LblMiniLabel 	As Label
	Private BtnMenu 		As Label
	Private BtnHide 		As Label
	Private BtnShow 		As Label
	Private BtnExit 		As Button
	'Private Button1 		As Button
	Private PnlMini 		As B4XView
	Private PnlStatic 		As B4XView
	Public PnlCenter 		As B4XView
	Private ClvMenuMini 	As CustomListView
	Private ClvMenuStatic 	As CustomListView
	Private ClvMenuDrawer 	As CustomListView
	Private CurrentObject	As Object
	Private P1 				As Page1
	Private P2 				As Page2
	Private Title 			As String = "Dashboard"
	Private MenuMode		As String = "Static"
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	'Root.LoadLayout("MainPanel")
	SetTitle
	InitDrawer
	InitPanel
	InitMenu
	Show(PnlCenter)
	'ShowPage(mBase)
	CurrentObject = Me
	#If B4J
	SetButtonMousePointer
	CSSUtils.SetStyleProperty(BtnExit, "-fx-focus-color", "black")
	'CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "slateblue")
	#End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Drawer.IsInitialized Then Drawer.Resize(Width, Height)
	If ContentEmpty = False Then
		PnlCenter.GetView(0).SetLayoutAnimated(0, 0, 0, PnlCenter.Width, PnlCenter.Height)
	End If
End Sub

'Public Sub NavigateTo (PageID As String)
'	Dim pg As Object = B4XPages.GetPage(PageID)
'	LoadPage(pg)
'End Sub

Private Sub LoadPage (Instance As Object)
	'PnlCenter.RemoveAllViews
	If ContentEmpty = False Then PnlCenter.GetView(0).RemoveViewFromParent
	CallSub2(Instance, "Show", PnlCenter)
End Sub

Sub SetTitle
	B4XPages.SetTitle(Me, Title)
End Sub

#If B4A
Sub RotateNode (v As View, Degree As Float)
	Dim jo As JavaObject = v
	jo.RunMethod("setRotation", Array(Degree))
End Sub
#Else
Sub RotateNode (v As Node, Degree As Double)
	Dim jo As JavaObject = v
	jo.RunMethod("setRotate", Array(Degree))
End Sub
#End If

Sub InitDrawer
	Drawer.Initialize(Me, "Drawer", Root, 300dip)
	Drawer.LeftPanel.LoadLayout("LeftDrawer")
	Drawer.CenterPanel.LoadLayout("MainPanel")
	#If B4A
	PnlCenter.LoadLayout("Dashboard")
	#End If
	lblAppVersion1.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
	RotateNode(BtnShow, 45)
End Sub

Sub InitPanel	
	LblTitle.Text = Title
	PnlMini.LoadLayout("PanelMini")
	PnlStatic.LoadLayout("PanelStatic")
	lblAppVersion2.Text = $"${Title}${CRLF}Version ${Main.Version}"$
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
	'#If B4J
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
	'#Else
	'B4XPages.AddPage("P1", P1.Initialize)
	'B4XPages.AddPage("P2", P2.Initialize)
	'B4XPages.AddPageAndCreate("P1", P1.Initialize)
	'B4XPages.AddPageAndCreate("P2", P2.Initialize)
	'#End If
	'If mBase.IsInitialized = False Then
	'	mBase = xui.CreatePanel("")
	'	mBase.LoadLayout("Dashboard")
	'End If
	'If P1.mBase.IsInitialized = False Then
	'	P1.mBase = xui.CreatePanel("")
	'	P1.mBase.LoadLayout("Page1")
	'End If
	'If P2.mBase.IsInitialized = False Then
	'	P2.mBase = xui.CreatePanel("")
	'	P2.mBase.LoadLayout("Page2")
	'End If
	
'	ClvMenuDrawer.AddTextItem("Dashboard", "mainpage")
'	ClvMenuDrawer.AddTextItem("Page1", "p1")
'	ClvMenuDrawer.AddTextItem("Page2", "p2")
'	
'	ClvMenuStatic.AddTextItem("Dashboard", "mainpage")
'	ClvMenuStatic.AddTextItem("Page1", "p1")
'	ClvMenuStatic.AddTextItem("Page2", "p2")
'	
'	ClvMenuMini.Add(CreateMiniItem(Chr(0xF015), ClvMenuMini.AsView.Width), "mainpage")
'	ClvMenuMini.Add(CreateMiniItem(Chr(0xF004), ClvMenuMini.AsView.Width), "p1")
'	ClvMenuMini.Add(CreateMiniItem(Chr(0xF06B), ClvMenuMini.AsView.Width), "p2")
End Sub

#If B4J
Sub BtnMenu_MouseClicked (EventData As MouseEvent)
#Else
Sub BtnMenu_Click
#End If
	Select MenuMode
		Case "Mini"
			ModeStatic
		Case "Static"
			ModeMini
		Case Else
			Drawer.LeftOpen = Not(Drawer.LeftOpen)
			Return
	End Select
	'LoadPage(Me)
	LoadPage(CurrentObject)
	'ShowPage(mBase)
End Sub

Private Sub BtnExit_Click
	ExitApplication
End Sub

#If B4J
Private Sub BtnHide_MouseClicked (EventData As MouseEvent)
#Else
Private Sub BtnHide_Click
#End If
	ModeDrawer
	LoadPage(CurrentObject)
	'ShowPage(mBase)
End Sub

#If B4J
Private Sub BtnShow_MouseClicked (EventData As MouseEvent)
#Else
Private Sub BtnShow_Click
#End If
	Drawer.LeftOpen = False
	ModeStatic
	LoadPage(CurrentObject)
	'ShowPage(mBase)
End Sub

Sub Drawer_StateChanged (Open As Boolean)
	If Open Then

	Else

	End If
End Sub

Private Sub ContentEmpty As Boolean
	Return PnlCenter.NumberOfViews = 0
End Sub

'Private Sub LoadPage (Value As Object)
'	#If B4J
'	If ContentEmpty = False Then PnlCenter.GetView(0).RemoveViewFromParent
'	CallSub2(Value, "Show", PnlCenter)
'	#Else
'	'Dim PageId As String = B4XPages.GetPageId(Value)
'	'Log(PageId)
'	'B4XPages.ShowPage(PageId)
'	Show
'	#End If
'	CurrentObject = Value
'End Sub

'Public Sub Show (Parent As B4XView)
'	If mBase.IsInitialized = False Then
'		mBase = xui.CreatePanel("")
'		mBase.LoadLayout("Dashboard")
'	End If
'	mBase.RemoveViewFromParent
'	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
'End Sub

Public Sub Show (Parent As B4XView)
	If mBase.IsInitialized = False Then
		mBase = xui.CreatePanel("")
		mBase.LoadLayout("Dashboard")
	End If
	mBase.RemoveViewFromParent
	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
	'PnlCenter.RemoveViewFromParent
	'Parent.AddView(PnlCenter, 0, 0, Parent.Width, Parent.Height)
End Sub

Private Sub ClvMenuMini_ItemClick (Index As Int, Value As Object)
	LoadPage(Value)
End Sub

Private Sub ClvMenuStatic_ItemClick (Index As Int, Value As Object)
	Log(Value)
	LoadPage(Value)
	'NavigateTo(Value)
	'ShowPage(Value)
End Sub

Private Sub ClvDrawer_ItemClick (Index As Int, Value As Object)
	Drawer.LeftOpen = False
	LoadPage(Value)
	'ShowPage(Value)
End Sub

Private Sub ModeMini
	MenuMode = "Mini"
	PnlMini.Visible = True
	PnlStatic.Visible = False
	PnlCenter.Width = Root.Width - PnlMini.Width
	PnlCenter.Left = PnlMini.Width
End Sub

Private Sub ModeStatic
	MenuMode = "Static"
	PnlMini.Visible = False
	PnlStatic.Visible = True
	PnlCenter.Width = Root.Width - PnlStatic.Width
	PnlCenter.Left = PnlStatic.Width
End Sub

Private Sub ModeDrawer
	MenuMode = "Drawer"
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
	'Button1.MouseCursor = FX.Cursors.HAND
End Sub
#End If