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
	Private FX 				As JFX
	#End If	
	Private XUI 			As XUI
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
	Private Button1 		As Button
	Private PnlMini 		As B4XView
	Private PnlStatic 		As B4XView
	Private PnlCenter 		As B4XView
	Private ClvMenuMini 	As CustomListView
	Private ClvMenuStatic 	As CustomListView
	Private ClvMenuDrawer 	As CustomListView
	Private CurrentObject	As Object
	Private Title 			As String = "AB4XDashboard"
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
	Show(PnlCenter)
	CurrentObject = Me
	#If B4J
	SetButtonMousePointer
	CSSUtils.SetStyleProperty(BtnExit, "-fx-focus-color", "white")
	CSSUtils.SetStyleProperty(Button1, "-fx-focus-color", "white")
	#End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Drawer.IsInitialized Then Drawer.Resize(Width, Height)
	If ContentEmpty = False Then
		PnlCenter.GetView(0).SetLayoutAnimated(0, 0, 0, PnlCenter.Width, PnlCenter.Height)
	End If
End Sub

Sub SetTitle
	B4XPages.SetTitle(Me, Title)
End Sub

Sub InitDrawer
	Drawer.Initialize(Me, "Drawer", Root, 300dip)
	Drawer.LeftPanel.LoadLayout("LeftDrawer")
	Drawer.CenterPanel.LoadLayout("MainPanel")
	lblAppVersion1.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
End Sub

Sub InitPanel
	#If B4A
	ToolbarHelper.Initialize
	ToolbarHelper.ShowUpIndicator = True 'set to true to show the up arrow
	lblAppVersion.Text = $"${Title}${CRLF}Version ${Application.VersionName}"$
	
	Dim bd As BitmapDrawable
	bd.Initialize(LoadBitmap(File.DirAssets, "img_hamburger.png"))
	ToolbarHelper.UpIndicatorDrawable =  bd
	ACToolBarLight1.InitMenuListener
	#End If
	#If B4i
	lblAppVersion.Text = $"${Title}${CRLF}Version ${Main.Version}"$
	#End If
	#If B4J
	LblTitle.Text = Title
	PnlMini.LoadLayout("PanelMini")
	PnlStatic.LoadLayout("PanelStatic")
	lblAppVersion2.Text = $"A B4X Dashboard${CRLF}   Version ${Main.Version}"$
	Select MenuMode
		Case "Mini"
			ModeMini
		Case "Static"
			ModeStatic
		Case Else
			ModeDrawer
	End Select
	#End If
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuMini, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuStatic, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuDrawer, XUI.Color_Transparent)
End Sub

Public Sub InitMenu
	ClvMenuDrawer.Clear
	Dim frm1 As Form1
	Dim frm2 As Form2
	frm1.Initialize
	frm2.Initialize
	ClvMenuDrawer.AddTextItem("Dashboard", Me)
	ClvMenuDrawer.AddTextItem("Form1", frm1)
	ClvMenuDrawer.AddTextItem("Form2", frm2)
	
	ClvMenuStatic.AddTextItem("Dashboard", Me)
	ClvMenuStatic.AddTextItem("Form1", frm1)
	ClvMenuStatic.AddTextItem("Form2", frm2)
	
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF015), ClvMenuMini.AsView.Width), Me)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF004), ClvMenuMini.AsView.Width), frm1)
	ClvMenuMini.Add(CreateMiniItem(Chr(0xF06B), ClvMenuMini.AsView.Width), frm2)
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
	LoadPage(CurrentObject)
End Sub

Sub ACToolBarLight1_NavigationItemClick
	Drawer.LeftOpen = Not(Drawer.LeftOpen)
End Sub

Private Sub BtnExit_Click
	ExitApplication
End Sub

Private Sub BtnHide_MouseClicked (EventData As MouseEvent)
	ModeDrawer
	LoadPage(CurrentObject)
End Sub

Private Sub BtnShow_MouseClicked (EventData As MouseEvent)
	Drawer.LeftOpen = False
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
	If mBase.IsInitialized = False Then
		mBase = XUI.CreatePanel("")
		mBase.LoadLayout("Dashboard")
	End If
	mBase.RemoveViewFromParent
	Parent.AddView(mBase, 0, 0, Parent.Width, Parent.Height)
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
	Dim pnl As B4XView = XUI.CreatePanel("")
	pnl.SetLayoutAnimated(0, 0, 0, Width, 60dip)
	pnl.LoadLayout("MiniItem")
	LblMiniLabel.Text = Text
	#If B4J
	pnl.As(Pane).MouseCursor = FX.Cursors.HAND
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
	BtnMenu.MouseCursor = FX.Cursors.HAND
	BtnExit.MouseCursor = FX.Cursors.HAND
	BtnHide.MouseCursor = FX.Cursors.HAND
	BtnShow.MouseCursor = FX.Cursors.HAND
	Button1.MouseCursor = FX.Cursors.HAND
End Sub
#End If