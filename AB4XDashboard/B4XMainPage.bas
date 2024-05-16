B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private XUI 			As XUI
	Private Root 			As B4XView
	Private Drawer 			As B4XDrawer
	Private BtnMenu 		As Label
	Private BtnHide 		As Label
	Private BtnShow 		As Label
	Private BtnExit 		As Button
	Private Button1 		As Button
	Private PnlRoot 		As B4XView
	Private PnlMini 		As B4XView
	Private PnlStatic 		As B4XView
	Private PnlCenter 		As B4XView
	Private ClvMenuMini 	As CustomListView
	Private ClvMenuStatic 	As CustomListView
	Private ClvMenuDrawer 	As CustomListView
	#If B4J
	Private FX 				As JFX
	#End If
	'Private Title 		As String = "Aeric's B4X Dashboard"
	Private Title 		As String = "AB4XDashboard"
	Private MenuMode	As String = "Static"
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
	ShowLoginMenu
	#If B4J
	SetButtonMousePointer
	#End If
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If Drawer.IsInitialized Then Drawer.Resize(Width, Height)
End Sub

Private Sub BtnExit_Click
	ExitApplication
End Sub

Sub SetTitle
	B4XPages.SetTitle(Me, Title)
End Sub

Sub InitDrawer
	Drawer.Initialize(Me, "Drawer", Root, 300dip)
	Drawer.LeftPanel.LoadLayout("LeftDrawer")
	Drawer.CenterPanel.LoadLayout("MainPanel")
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
	PnlMini.LoadLayout("PanelMini")
	PnlStatic.LoadLayout("PanelStatic")
	PnlCenter.LoadLayout("PanelCenter")
	Select MenuMode
		Case "Mini"
			PnlMini.Visible = True
			PnlStatic.Visible = False
			PnlCenter.Width = PnlRoot.Width - PnlMini.Width
			PnlCenter.Left = 60dip
		Case "Static"
			PnlMini.Visible = False
			PnlStatic.Visible = True
			PnlCenter.Width = PnlRoot.Width - PnlStatic.Width
			PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
		Case Else
			PnlMini.Visible = False
			PnlStatic.Visible = False
			PnlCenter.Width = PnlRoot.Width
			PnlCenter.Left = 0
	End Select
	'PnlCenter.LoadLayout("PanelCenter")
	#End If
	'BtnExit.Visible = False	' If MainForm.FormStyle = "UNDECORATED"
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuMini, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuStatic, XUI.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvMenuDrawer, XUI.Color_Transparent)
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
End Sub
Sub ACToolBarLight1_NavigationItemClick
	Drawer.LeftOpen = Not(Drawer.LeftOpen)
End Sub

Private Sub BtnHide_MouseClicked (EventData As MouseEvent)
	MenuMode = "Drawer"
	PnlMini.Visible = False
	PnlStatic.Visible = False
	PnlCenter.Width = Root.Width
	PnlCenter.Left = 0
End Sub

Private Sub BtnShow_MouseClicked (EventData As MouseEvent)
	Drawer.LeftOpen = False
	MenuMode = "Static"
	PnlMini.Visible = False
	PnlStatic.Visible = True
	PnlCenter.Width = Root.Width - PnlStatic.Width
	PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
End Sub

Sub Drawer_StateChanged (Open As Boolean)
	If Open Then

	Else

	End If
End Sub

Private Sub ClvMenuDrawer_ItemClick (Index As Int, Value As Object)
	Drawer.LeftOpen = False
	Select Case Value
		Case "Login"
			'B4XPages.ShowPage("UserLogin")
		Case "Logout"
			Dim Txt As String = "You will need to log in again." & CRLF & _
			"Are you sure you want to log out ?"
			XUI.Msgbox2Async(Txt, "A T T E N T I O N", "Yes", "", "No", Null)
			Wait For Msgbox_Result (Answ As Int)
			If Answ = XUI.DialogResponse_Positive Then
				'Main.gUser = ""
				'lblCount.Text = "0"
				'If B4XPages.MainPage.PageUserLogin.lblMessage1.IsInitialized Then
				'	B4XPages.MainPage.PageUserLogin.ShowLabelMessage("Enter your Email and Password")
				'End If
				ShowLoginMenu
			End If
		Case "Register"
			'B4XPages.ShowPage("UserRegister")
		Case "Reset Password"
			'B4XPages.ShowPage("UserPasswordReset")
		Case "Change Password"
			'B4XPages.ShowPage("UserPasswordChange")
		Case "Delete Account"
			'B4XPages.ShowPage("UserDelete")
		Case "Help"
			If ClvMenuDrawer.GetPanel(ClvMenuDrawer.Size-2).GetView(0).Text = "Show Help" Then
				ClvMenuDrawer.GetPanel(ClvMenuDrawer.Size-2).GetView(0).Text = "Hide Help"
			Else
				ClvMenuDrawer.GetPanel(ClvMenuDrawer.Size-2).GetView(0).Text = "Show Help"
			End If
		Case "About"
			'B4XPages.ShowPage("MainAbout")
		Case Else
			LogColor(Value, XUI.Color_Red)
	End Select
End Sub

Sub SwitchMenu
	Select MenuMode
		Case "Mini"
			MenuMode = "Static"
			PnlMini.Visible = False
			PnlStatic.Visible = True
			PnlCenter.Width = Root.Width - PnlStatic.Width
			PnlCenter.Left = PnlStatic.Left + PnlStatic.Width
		Case "Static"
			MenuMode = "Mini"
			PnlStatic.Visible = False
			PnlMini.Visible = True
			PnlCenter.Width = Root.Width - PnlMini.Width
			PnlCenter.Left = PnlMini.Left + PnlMini.Width
	End Select
End Sub

Public Sub ShowLoginMenu
	ClvMenuDrawer.Clear
	ClvMenuDrawer.AddTextItem("Login", "Login")
	ClvMenuDrawer.AddTextItem("Register", "Register")
	ClvMenuDrawer.AddTextItem("Reset Password", "Reset Password")
	ClvMenuDrawer.AddTextItem("Show Help", "Help")
	ClvMenuDrawer.AddTextItem("About", "About")
	'lblMenuEmail.Text = ""
	'lblMenuUserName.Text = $"Hello"$
End Sub

Public Sub ShowLogoutMenu
	ClvMenuDrawer.Clear
	ClvMenuDrawer.AddTextItem("Logout", "Logout")
	ClvMenuDrawer.AddTextItem("Change Password", "Change Password")
	ClvMenuDrawer.AddTextItem("Delete Account", "Delete Account")
	ClvMenuDrawer.AddTextItem("Show Help", "Help")
	ClvMenuDrawer.AddTextItem("About", "About")
	'If Main.gUser = Main.gName Then
		'lblMenuUserName.Text = $"Hello, ${Main.gName}"$
	'Else
		'lblMenuUserName.Text = $"Hello, ${Main.gName} (${Main.gUser})"$
	'End If
	'lblMenuEmail.Text = Main.gEmail
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