local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGuiService = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local Config = {
	TweenTime       = 0.22,
	FastTweenTime   = 0.12,
	SlowTweenTime   = 0.35,
	SpringTweenTime = 0.42,

	BG              = Color3.fromRGB(20, 20, 25),
	BG2             = Color3.fromRGB(26, 26, 32),
	BG3             = Color3.fromRGB(34, 34, 42),
	BG4             = Color3.fromRGB(44, 44, 54),
	Accent          = Color3.fromRGB(100, 100, 255),
	AccentDim       = Color3.fromRGB(70, 70, 200),
	AccentGlow      = Color3.fromRGB(140, 140, 255),
	TextPrimary     = Color3.fromRGB(245, 245, 250),
	TextSecondary   = Color3.fromRGB(160, 160, 180),
	TextMuted       = Color3.fromRGB(100, 100, 120),
	Success         = Color3.fromRGB(80, 230, 150),
	Danger          = Color3.fromRGB(255, 100, 110),
	Warning         = Color3.fromRGB(255, 200, 70),
	Border          = Color3.fromRGB(55, 55, 72),

	WindowW         = 580,
	WindowH         = 360,
	MenuBarW        = 120,
	TitleBarH       = 32,
	ElementH        = 28,
	ElementPad      = 5,

	Font            = Enum.Font.GothamBold,
	FontLight       = Enum.Font.Gotham,
	FontMono        = Enum.Font.Code,
}

local function MakeTweenInfo(t, style, dir, rep, rev, delay)
	return TweenInfo.new(
		t or Config.TweenTime,
		style or Enum.EasingStyle.Quad,
		dir or Enum.EasingDirection.Out,
		rep or 0,
		rev or false,
		delay or 0
	)
end

local TI_Normal  = MakeTweenInfo(Config.TweenTime)
local TI_Fast    = MakeTweenInfo(Config.FastTweenTime)
local TI_Slow    = MakeTweenInfo(Config.SlowTweenTime)
local TI_Spring  = MakeTweenInfo(Config.SpringTweenTime, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local TI_Back    = MakeTweenInfo(Config.SpringTweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function Tween(obj, props, info)
	local t = TweenService:Create(obj, info or TI_Normal, props)
	t:Play()
	return t
end

local Level = 1

local function NextLevel()
	Level += 1
	return Level
end

local function NewFrame(name, parent)
	local f = Instance.new("Frame")
	f.Name = name or "Frame"
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.ZIndex = Level
	f.Parent = parent
	return f
end

local function NewRound(cornerRadius, parent, isButton)
	local img = Instance.new(isButton and "ImageButton" or "ImageLabel")
	img.BackgroundTransparency = 1
	img.Image = "rbxassetid://3570695787"
	img.SliceCenter = Rect.new(100, 100, 100, 100)
	img.SliceScale = math.clamp((cornerRadius or 8) * 0.01, 0.01, 1)
	img.ScaleType = Enum.ScaleType.Slice
	img.ZIndex = Level
	img.Parent = parent
	return img
end

local function NewScrollFrame(name, parent)
	local sf = Instance.new("ScrollingFrame")
	sf.Name = name or "ScrollFrame"
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 3
	sf.ScrollBarImageColor3 = Config.Accent
	sf.ScrollBarImageTransparency = 0.4
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.ZIndex = Level
	sf.Parent = parent
	return sf
end

local function NewTextLabel(text, size, parent)
	local lbl = Instance.new("TextLabel")
	lbl.Text = text or ""
	lbl.Font = Config.FontLight
	lbl.TextColor3 = Config.TextPrimary
	lbl.BackgroundTransparency = 1
	lbl.TextSize = size or 13
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.ZIndex = Level
	lbl.Parent = parent
	return lbl
end

local function NewTextButton(text, size, parent)
	local btn = Instance.new("TextButton")
	btn.Text = text or ""
	btn.AutoButtonColor = false
	btn.Font = Config.FontLight
	btn.TextColor3 = Config.TextPrimary
	btn.BackgroundTransparency = 1
	btn.TextSize = size or 13
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.ZIndex = Level
	btn.Parent = parent
	return btn
end

local function NewTextBox(placeholder, size, parent)
	local box = Instance.new("TextBox")
	box.PlaceholderText = placeholder or ""
	box.Text = ""
	box.Font = Config.FontLight
	box.TextColor3 = Config.TextPrimary
	box.PlaceholderColor3 = Config.TextMuted
	box.BackgroundTransparency = 1
	box.TextSize = size or 13
	box.Size = UDim2.new(1, 0, 1, 0)
	box.ZIndex = Level
	box.ClearTextOnFocus = false
	box.Parent = parent
	return box
end

local function NewListLayout(parent, padding)
	local ul = Instance.new("UIListLayout")
	ul.SortOrder = Enum.SortOrder.LayoutOrder
	ul.Padding = UDim.new(0, padding or Config.ElementPad)
	ul.Parent = parent
	return ul
end

local function NewUIPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 0)
	p.PaddingBottom = UDim.new(0, bottom or 0)
	p.PaddingLeft   = UDim.new(0, left   or 0)
	p.PaddingRight  = UDim.new(0, right  or 0)
	p.Parent = parent
	return p
end

local function NewCorner(radius, parent)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = parent
	return c
end

local function NewStroke(color, thickness, parent, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Config.Border
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.Parent = parent
	return s
end

local function Ripple(parent)
	local rip = Instance.new("Frame")
	rip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	rip.BackgroundTransparency = 0.85
	rip.Size = UDim2.new(0, 0, 0, 0)
	rip.AnchorPoint = Vector2.new(0.5, 0.5)
	rip.Position = UDim2.new(0.5, 0, 0.5, 0)
	rip.ZIndex = Level + 5
	NewCorner(999, rip)
	rip.Parent = parent

	local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 3
	Tween(rip, {Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1}, MakeTweenInfo(0.5, Enum.EasingStyle.Quad))
	task.delay(0.55, function()
		rip:Destroy()
	end)
end

local function AddHoverGlow(btn, bg, hoverColor, normalColor)
	btn.MouseEnter:Connect(function()
		Tween(bg, {ImageColor3 = hoverColor}, TI_Fast)
	end)
	btn.MouseLeave:Connect(function()
		Tween(bg, {ImageColor3 = normalColor}, TI_Fast)
	end)
end

local NotifParent = nil
local CloseWarningToggle = false
local FeaturesToReset = {}

local function NotifySetup(screenGui)
	local holder = NewFrame("NotifHolder", screenGui)
	holder.Size = UDim2.new(0, 280, 1, 0)
	holder.Position = UDim2.new(1, -290, 0, 0)
	holder.BackgroundTransparency = 1
	holder.ZIndex = 100

	local list = NewListLayout(holder, 6)
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NewUIPadding(holder, 0, 12, 0, 0)

	NotifParent = holder
end

local function Notify(title, message, notifType, duration)
	if not NotifParent then return end
	duration = duration or 4
	notifType = notifType or "info"

	local typeColor = {
		info    = Config.Accent,
		success = Config.Success,
		warning = Config.Warning,
		error   = Config.Danger,
	}
	local color = typeColor[notifType] or Config.Accent

	Level = 100
	local container = NewFrame("Notif_"..os.time(), NotifParent)
	container.Size = UDim2.new(1, 0, 0, 68)
	container.BackgroundTransparency = 1

	local bg = NewRound(10, container)
	bg.ImageColor3 = Config.BG3
	bg.Size = UDim2.new(1, 0, 1, 0)
	NewStroke(color, 1, bg, 0.4)

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 3, 1, -12)
	accent.Position = UDim2.new(0, 6, 0, 6)
	accent.BackgroundColor3 = color
	accent.BorderSizePixel = 0
	NewCorner(4, accent)
	accent.Parent = bg
	accent.ZIndex = 101

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Text = title
	titleLbl.Font = Config.Font
	titleLbl.TextColor3 = Config.TextPrimary
	titleLbl.TextSize = 13
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1, -20, 0, 20)
	titleLbl.Position = UDim2.new(0, 16, 0, 6)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 102
	titleLbl.Parent = bg

	local msgLbl = Instance.new("TextLabel")
	msgLbl.Text = message
	msgLbl.Font = Config.FontLight
	msgLbl.TextColor3 = Config.TextSecondary
	msgLbl.TextSize = 12
	msgLbl.BackgroundTransparency = 1
	msgLbl.Size = UDim2.new(1, -20, 0, 30)
	msgLbl.Position = UDim2.new(0, 16, 0, 28)
	msgLbl.TextXAlignment = Enum.TextXAlignment.Left
	msgLbl.TextWrapped = true
	msgLbl.ZIndex = 102
	msgLbl.Parent = bg

	local progress = Instance.new("Frame")
	progress.Size = UDim2.new(1, -12, 0, 2)
	progress.Position = UDim2.new(0, 6, 1, -4)
	progress.BackgroundColor3 = color
	progress.BorderSizePixel = 0
	NewCorner(2, progress)
	progress.ZIndex = 102
	progress.Parent = bg

	bg.Position = UDim2.new(1, 25, 0, 0)
	Tween(bg, {Position = UDim2.new(0, 0, 0, 0)}, TI_Back)

	Tween(progress, {Size = UDim2.new(0, 0, 0, 2)}, MakeTweenInfo(duration, Enum.EasingStyle.Linear))

	task.delay(duration, function()
		Tween(bg, {Position = UDim2.new(1, 25, 0, 0), ImageTransparency = 1}, TI_Normal)
		task.delay(Config.TweenTime + 0.08, function()
			container:Destroy()
		end)
	end)
end

local UILibrary = {}

function UILibrary.Load(GUITitle, options)
	options = options or {}
	local accentColor = options.AccentColor or Config.Accent

	local TargetedParent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or CoreGuiService

	local old = TargetedParent:FindFirstChild(GUITitle)
	if old then old:Destroy() end

	Level = 1

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = GUITitle
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = TargetedParent

	NotifySetup(ScreenGui)

	Level = 1
	local ContainerFrame = NewFrame("ContainerFrame", ScreenGui)
	ContainerFrame.Size = UDim2.new(0, Config.WindowW, 0, Config.WindowH)
	ContainerFrame.Position = UDim2.new(0.5, -Config.WindowW/2, 0.5, -Config.WindowH/2)
	ContainerFrame.BackgroundTransparency = 1

	for i = 6, 1, -1 do
		local shadow = Instance.new("Frame")
		shadow.Size = UDim2.new(1, i * 10, 1, i * 10)
		shadow.Position = UDim2.new(0, -i * 5, 0, -i * 5)
		shadow.BackgroundColor3 = Color3.fromRGB(8, 6, 18)
		shadow.BackgroundTransparency = 0.55 + (i * 0.08)
		shadow.BorderSizePixel = 0
		shadow.ZIndex = 0
		NewCorner(14 + i, shadow)
		shadow.Parent = ContainerFrame
	end

	Level = 2

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.BackgroundColor3 = Config.BG
	MainFrame.BorderSizePixel = 0
	MainFrame.ZIndex = Level
	NewCorner(12, MainFrame)
	NewStroke(Config.Border, 1, MainFrame, 0.25)
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ContainerFrame

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundTransparency = 0.98
	overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	overlay.BorderSizePixel = 0
	overlay.ZIndex = Level + 1
	overlay.Parent = MainFrame

	Level = 3

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, Config.TitleBarH)
	TitleBar.BackgroundColor3 = Config.BG2
	TitleBar.BorderSizePixel = 0
	TitleBar.ZIndex = Level
	TitleBar.Parent = MainFrame

	local TitleAccentLine = Instance.new("Frame")
	TitleAccentLine.Size = UDim2.new(1, 0, 0, 2)
	TitleAccentLine.Position = UDim2.new(0, 0, 1, -2)
	TitleAccentLine.BackgroundColor3 = accentColor
	TitleAccentLine.BackgroundTransparency = 0.3
	TitleAccentLine.BorderSizePixel = 0
	TitleAccentLine.ZIndex = Level + 1
	TitleAccentLine.Parent = TitleBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = GUITitle
	TitleLabel.Font = Config.Font
	TitleLabel.TextColor3 = Config.TextPrimary
	TitleLabel.TextSize = 14
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -100, 1, 0)
	TitleLabel.Position = UDim2.new(0, 45, 0, 0)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.ZIndex = Level + 2
	TitleLabel.Parent = TitleBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "X"
	CloseBtn.Font = Config.Font
	CloseBtn.TextColor3 = Config.TextSecondary
	CloseBtn.TextSize = 13
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Size = UDim2.new(0, 30, 1, 0)
	CloseBtn.Position = UDim2.new(1, -32, 0, 0)
	CloseBtn.ZIndex = Level + 2
	CloseBtn.AutoButtonColor = false
	CloseBtn.Parent = TitleBar

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "-"
	MinBtn.Font = Config.Font
	MinBtn.TextColor3 = Config.TextSecondary
	MinBtn.TextSize = 16
	MinBtn.BackgroundTransparency = 1
	MinBtn.Size = UDim2.new(0, 30, 1, 0)
	MinBtn.Position = UDim2.new(1, -64, 0, 0)
	MinBtn.ZIndex = Level + 2
	MinBtn.AutoButtonColor = false
	MinBtn.Parent = TitleBar

	local SettingsBtn = Instance.new("TextButton")
	SettingsBtn.Text = "..."
	SettingsBtn.Font = Config.Font
	SettingsBtn.TextColor3 = Config.TextSecondary
	SettingsBtn.TextSize = 13
	SettingsBtn.BackgroundTransparency = 1
	SettingsBtn.Size = UDim2.new(0, 30, 1, 0)
	SettingsBtn.Position = UDim2.new(0, 8, 0, 0)
	SettingsBtn.ZIndex = Level + 2
	SettingsBtn.AutoButtonColor = false
	SettingsBtn.Parent = TitleBar

	local ProfileFrame = Instance.new("Frame")
	ProfileFrame.Name = "ProfileFrame"
	ProfileFrame.Size = UDim2.new(0, 32, 1, -4)
	ProfileFrame.Position = UDim2.new(0, 8, 0, 2)
	ProfileFrame.BackgroundColor3 = Config.BG4
	ProfileFrame.BorderSizePixel = 0
	ProfileFrame.ZIndex = Level + 2
	NewCorner(8, ProfileFrame)
	ProfileFrame.Parent = TitleBar

	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.Size = UDim2.new(1, -4, 1, -4)
	AvatarImage.Position = UDim2.new(0, 2, 0, 2)
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
	AvatarImage.ZIndex = Level + 3
	NewCorner(6, AvatarImage)
	AvatarImage.Parent = ProfileFrame

	local ProfileStroke = NewStroke(Config.Border, 1, ProfileFrame, 0.5)

	local DisplayNameLabel = Instance.new("TextLabel")
	DisplayNameLabel.Text = Player.DisplayName
	DisplayNameLabel.Font = Config.Font
	DisplayNameLabel.TextColor3 = Config.TextPrimary
	DisplayNameLabel.TextSize = 12
	DisplayNameLabel.BackgroundTransparency = 1
	DisplayNameLabel.Size = UDim2.new(0, 0, 0, 16)
	DisplayNameLabel.Position = UDim2.new(0, 45, 0, 4)
	DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	DisplayNameLabel.ZIndex = Level + 2
	DisplayNameLabel.Parent = TitleBar

	local UsernameLabel = Instance.new("TextLabel")
	UsernameLabel.Text = "@"..Player.Name
	UsernameLabel.Font = Config.FontLight
	UsernameLabel.TextColor3 = Config.TextSecondary
	UsernameLabel.TextSize = 10
	UsernameLabel.BackgroundTransparency = 1
	UsernameLabel.Size = UDim2.new(0, 0, 0, 14)
	UsernameLabel.Position = UDim2.new(0, 45, 0, 18)
	UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
	UsernameLabel.ZIndex = Level + 2
	UsernameLabel.Parent = TitleBar

	local function UpdateProfileSize()
		local nameWidth = TextService:GetTextSize(DisplayNameLabel.Text, 12, Config.Font, Vector2.new(1000, 16)).X
		local userWidth = TextService:GetTextSize(UsernameLabel.Text, 10, Config.FontLight, Vector2.new(1000, 14)).X
		local maxWidth = math.max(nameWidth, userWidth) + 8
		DisplayNameLabel.Size = UDim2.new(0, maxWidth, 0, 16)
		UsernameLabel.Size = UDim2.new(0, maxWidth, 0, 14)
	end
	UpdateProfileSize()
	DisplayNameLabel:GetPropertyChangedSignal("Text"):Connect(UpdateProfileSize)
	UsernameLabel:GetPropertyChangedSignal("Text"):Connect(UpdateProfileSize)

	local function ShowCloseWarning()
		local warningFrame = Instance.new("Frame")
		warningFrame.Name = "CloseWarning"
		warningFrame.Size = UDim2.new(0, 280, 0, 140)
		warningFrame.Position = UDim2.new(0.5, -140, 0.5, -70)
		warningFrame.BackgroundColor3 = Config.BG3
		warningFrame.BorderSizePixel = 0
		warningFrame.ZIndex = 500
		NewCorner(10, warningFrame)
		NewStroke(Config.Border, 1, warningFrame, 0.4)
		warningFrame.Parent = ScreenGui

		local warningTitle = Instance.new("TextLabel")
		warningTitle.Text = "Close Confirmation"
		warningTitle.Font = Config.Font
		warningTitle.TextColor3 = Config.TextPrimary
		warningTitle.TextSize = 14
		warningTitle.BackgroundTransparency = 1
		warningTitle.Size = UDim2.new(1, -20, 0, 30)
		warningTitle.Position = UDim2.new(0, 10, 0, 10)
		warningTitle.TextXAlignment = Enum.TextXAlignment.Left
		warningTitle.ZIndex = 501
		warningTitle.Parent = warningFrame

		local warningMessage = Instance.new("TextLabel")
		warningMessage.Text = "Reset all features before closing?"
		warningMessage.Font = Config.FontLight
		warningMessage.TextColor3 = Config.TextSecondary
		warningMessage.TextSize = 12
		warningMessage.BackgroundTransparency = 1
		warningMessage.Size = UDim2.new(1, -20, 0, 20)
		warningMessage.Position = UDim2.new(0, 10, 0, 45)
		warningMessage.TextXAlignment = Enum.TextXAlignment.Left
		warningMessage.ZIndex = 501
		warningMessage.Parent = warningFrame

		local yesBtn = Instance.new("TextButton")
		yesBtn.Text = "Yes"
		yesBtn.Font = Config.Font
		yesBtn.TextColor3 = Config.Success
		yesBtn.TextSize = 13
		yesBtn.BackgroundColor3 = Config.BG4
		yesBtn.Size = UDim2.new(0, 80, 0, 30)
		yesBtn.Position = UDim2.new(0.5, -90, 1, -40)
		yesBtn.ZIndex = 502
		NewCorner(6, yesBtn)
		yesBtn.AutoButtonColor = false
		yesBtn.Parent = warningFrame

		local noBtn = Instance.new("TextButton")
		noBtn.Text = "No"
		noBtn.Font = Config.Font
		noBtn.TextColor3 = Config.Danger
		noBtn.TextSize = 13
		noBtn.BackgroundColor3 = Config.BG4
		noBtn.Size = UDim2.new(0, 80, 0, 30)
		noBtn.Position = UDim2.new(0.5, 10, 1, -40)
		noBtn.ZIndex = 502
		NewCorner(6, noBtn)
		noBtn.AutoButtonColor = false
		noBtn.Parent = warningFrame

		local cancelBtn = Instance.new("TextButton")
		cancelBtn.Text = "Cancel"
		cancelBtn.Font = Config.FontLight
		cancelBtn.TextColor3 = Config.TextSecondary
		cancelBtn.TextSize = 12
		cancelBtn.BackgroundTransparency = 1
		cancelBtn.Size = UDim2.new(0, 60, 0, 25)
		cancelBtn.Position = UDim2.new(1, -70, 0, 5)
		cancelBtn.ZIndex = 502
		cancelBtn.AutoButtonColor = false
		cancelBtn.Parent = warningFrame

		local dontAskToggle = Instance.new("TextButton")
		dontAskToggle.Text = "[ ] Don't ask again"
		dontAskToggle.Font = Config.FontLight
		dontAskToggle.TextColor3 = Config.TextMuted
		dontAskToggle.TextSize = 11
		dontAskToggle.BackgroundTransparency = 1
		dontAskToggle.Size = UDim2.new(0, 120, 0, 20)
		dontAskToggle.Position = UDim2.new(0, 10, 1, -40)
		dontAskToggle.TextXAlignment = Enum.TextXAlignment.Left
		dontAskToggle.ZIndex = 502
		dontAskToggle.AutoButtonColor = false
		dontAskToggle.Parent = warningFrame

		local toggleState = false

		dontAskToggle.MouseButton1Click:Connect(function()
			toggleState = not toggleState
			dontAskToggle.Text = toggleState and "[X] Don't ask again" or "[ ] Don't ask again"
		end)

		local function closeWarning(shouldReset)
			Tween(warningFrame, {BackgroundTransparency = 1}, TI_Fast)
			for _, child in ipairs(warningFrame:GetChildren()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") then
					Tween(child, {TextTransparency = 1}, TI_Fast)
				end
			end
			task.delay(0.2, function()
				warningFrame:Destroy()
			end)
			if shouldReset then
				for _, resetFunc in ipairs(FeaturesToReset) do
					resetFunc()
				end
				Notify("Closed", "All features have been reset", "success", 3)
			end
			if toggleState then
				CloseWarningToggle = true
			end
			Tween(MainFrame, {BackgroundTransparency = 1}, TI_Normal)
			for _, ch in ipairs(ContainerFrame:GetChildren()) do
				if ch:IsA("Frame") and ch.ZIndex == 0 then
					Tween(ch, {BackgroundTransparency = 1}, TI_Normal)
				end
			end
			task.delay(Config.TweenTime + 0.08, function()
				ScreenGui:Destroy()
			end)
		end

		yesBtn.MouseButton1Click:Connect(function()
			closeWarning(true)
		end)
		noBtn.MouseButton1Click:Connect(function()
			closeWarning(false)
		end)
		cancelBtn.MouseButton1Click:Connect(function()
			closeWarning(nil)
		end)

		warningFrame.BackgroundTransparency = 1
		Tween(warningFrame, {BackgroundTransparency = 0}, TI_Back)
	end

	CloseBtn.MouseButton1Click:Connect(function()
		if CloseWarningToggle then
			if CloseWarningToggle == true then
				Tween(MainFrame, {BackgroundTransparency = 1}, TI_Normal)
				for _, ch in ipairs(ContainerFrame:GetChildren()) do
					if ch:IsA("Frame") and ch.ZIndex == 0 then
						Tween(ch, {BackgroundTransparency = 1}, TI_Normal)
					end
				end
				task.delay(Config.TweenTime + 0.08, function()
					ScreenGui:Destroy()
				end)
			end
		else
			ShowCloseWarning()
		end
	end)

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, {TextColor3 = Config.Danger}, TI_Fast)
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, {TextColor3 = Config.TextSecondary}, TI_Fast)
	end)
	MinBtn.MouseEnter:Connect(function()
		Tween(MinBtn, {TextColor3 = Config.Warning}, TI_Fast)
	end)
	MinBtn.MouseLeave:Connect(function()
		Tween(MinBtn, {TextColor3 = Config.TextSecondary}, TI_Fast)
	end)
	SettingsBtn.MouseEnter:Connect(function()
		Tween(SettingsBtn, {TextColor3 = Config.Accent}, TI_Fast)
	end)
	SettingsBtn.MouseLeave:Connect(function()
		Tween(SettingsBtn, {TextColor3 = Config.TextSecondary}, TI_Fast)
	end)

	local minimised = false
	local fullHeight = Config.WindowH

	MinBtn.MouseButton1Click:Connect(function()
		minimised = not minimised
		Tween(ContainerFrame, {
			Size = minimised
				and UDim2.new(0, Config.WindowW, 0, Config.TitleBarH)
				or  UDim2.new(0, Config.WindowW, 0, fullHeight)
		}, TI_Back)
	end)

	local function ShowSettingsMenu()
		local settingsFrame = Instance.new("Frame")
		settingsFrame.Name = "SettingsMenu"
		settingsFrame.Size = UDim2.new(0, 200, 0, 250)
		settingsFrame.Position = UDim2.new(0, 45, 0, Config.TitleBarH)
		settingsFrame.BackgroundColor3 = Config.BG3
		settingsFrame.BorderSizePixel = 0
		settingsFrame.ZIndex = 400
		NewCorner(8, settingsFrame)
		NewStroke(Config.Border, 1, settingsFrame, 0.4)
		settingsFrame.ClipsDescendants = true
		settingsFrame.Parent = MainFrame

		local settingsList = NewListLayout(settingsFrame, 4)
		NewUIPadding(settingsFrame, 8, 8, 8, 8)

		local closeWarningSetting = Instance.new("Frame")
		closeWarningSetting.Size = UDim2.new(1, 0, 0, 25)
		closeWarningSetting.BackgroundTransparency = 1
		closeWarningSetting.LayoutOrder = 1
		closeWarningSetting.Parent = settingsFrame

		local closeWarningLabel = Instance.new("TextLabel")
		closeWarningLabel.Text = "Close Warning:"
		closeWarningLabel.Font = Config.FontLight
		closeWarningLabel.TextColor3 = Config.TextPrimary
		closeWarningLabel.TextSize = 11
		closeWarningLabel.BackgroundTransparency = 1
		closeWarningLabel.Size = UDim2.new(0.6, 0, 1, 0)
		closeWarningLabel.TextXAlignment = Enum.TextXAlignment.Left
		closeWarningLabel.Parent = closeWarningSetting

		local closeWarningTrack = Instance.new("Frame")
		closeWarningTrack.Size = UDim2.new(0, 28, 0, 14)
		closeWarningTrack.Position = UDim2.new(1, -32, 0.5, -7)
		closeWarningTrack.BackgroundColor3 = CloseWarningToggle and Config.Accent or Config.BG4
		closeWarningTrack.BorderSizePixel = 0
		NewCorner(999, closeWarningTrack)
		closeWarningTrack.Parent = closeWarningSetting

		local closeWarningKnob = Instance.new("Frame")
		closeWarningKnob.Size = UDim2.new(0, 10, 0, 10)
		closeWarningKnob.Position = CloseWarningToggle and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		closeWarningKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		closeWarningKnob.BorderSizePixel = 0
		NewCorner(999, closeWarningKnob)
		closeWarningKnob.Parent = closeWarningTrack

		local closeWarningBtn = Instance.new("TextButton")
		closeWarningBtn.Text = ""
		closeWarningBtn.BackgroundTransparency = 1
		closeWarningBtn.Size = UDim2.new(1, 0, 1, 0)
		closeWarningBtn.Parent = closeWarningSetting

		closeWarningBtn.MouseButton1Click:Connect(function()
			CloseWarningToggle = not CloseWarningToggle
			Tween(closeWarningTrack, {BackgroundColor3 = CloseWarningToggle and Config.Accent or Config.BG4}, TI_Fast)
			Tween(closeWarningKnob, {Position = CloseWarningToggle and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}, TI_Back)
		end)

		settingsFrame.Position = UDim2.new(0, -5, 0, Config.TitleBarH)
		settingsFrame.BackgroundTransparency = 1
		Tween(settingsFrame, {Position = UDim2.new(0, 45, 0, Config.TitleBarH), BackgroundTransparency = 0}, TI_Back)

		local closeSettings = Instance.new("TextButton")
		closeSettings.Text = "X"
		closeSettings.Font = Config.Font
		closeSettings.TextColor3 = Config.TextSecondary
		closeSettings.TextSize = 11
		closeSettings.BackgroundTransparency = 1
		closeSettings.Size = UDim2.new(0, 20, 0, 20)
		closeSettings.Position = UDim2.new(1, -25, 0, 5)
		closeSettings.ZIndex = 401
		closeSettings.AutoButtonColor = false
		closeSettings.Parent = settingsFrame

		closeSettings.MouseButton1Click:Connect(function()
			Tween(settingsFrame, {Position = UDim2.new(0, -5, 0, Config.TitleBarH), BackgroundTransparency = 1}, TI_Fast)
			task.delay(0.2, function()
				settingsFrame:Destroy()
			end)
		end)

		local function closeOnClickOutside(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local mousePos = UserInputService:GetMouseLocation()
				local settingsAbsPos = settingsFrame.AbsolutePosition
				local settingsSize = settingsFrame.AbsoluteSize
				if mousePos.X < settingsAbsPos.X or mousePos.X > settingsAbsPos.X + settingsSize.X or
				   mousePos.Y < settingsAbsPos.Y or mousePos.Y > settingsAbsPos.Y + settingsSize.Y then
					Tween(settingsFrame, {Position = UDim2.new(0, -5, 0, Config.TitleBarH), BackgroundTransparency = 1}, TI_Fast)
					task.delay(0.2, function()
						settingsFrame:Destroy()
					end)
					UserInputService.InputBegan:Disconnect(clickConn)
				end
			end
		end

		local clickConn = UserInputService.InputBegan:Connect(closeOnClickOutside)
	end

	SettingsBtn.MouseButton1Click:Connect(ShowSettingsMenu)

	local dragging = false
	local dragStart, startPos
	local dragConnection = nil

	local function startDrag(inputPos)
		dragging = true
		dragStart = inputPos
		startPos = ContainerFrame.Position
		if dragConnection then dragConnection:Disconnect() end
		dragConnection = RunService.RenderStepped:Connect(function()
			if dragging then
				local delta = UserInputService:GetMouseLocation() - dragStart
				ContainerFrame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	local function endDrag()
		dragging = false
		if dragConnection then
			dragConnection:Disconnect()
			dragConnection = nil
		end
	end

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			startDrag(Vector2.new(input.Position.X, input.Position.Y))
		elseif input.UserInputType == Enum.UserInputType.Touch then
			startDrag(Vector2.new(input.Position.X, input.Position.Y))
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			endDrag()
		end
	end)

	Level = 4

	local BodyFrame = NewFrame("Body", MainFrame)
	BodyFrame.Size = UDim2.new(1, 0, 1, -Config.TitleBarH)
	BodyFrame.Position = UDim2.new(0, 0, 0, Config.TitleBarH)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, Config.MenuBarW, 1, 0)
	Sidebar.BackgroundColor3 = Config.BG2
	Sidebar.BorderSizePixel = 0
	Sidebar.ZIndex = Level
	Sidebar.Parent = BodyFrame

	local SidebarBorder = Instance.new("Frame")
	SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
	SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
	SidebarBorder.BackgroundColor3 = Config.Border
	SidebarBorder.BorderSizePixel = 0
	SidebarBorder.ZIndex = Level + 1
	SidebarBorder.Parent = Sidebar

	local SidebarScroll = NewScrollFrame("SidebarScroll", Sidebar)
	SidebarScroll.Size = UDim2.new(1, -1, 1, 0)
	SidebarScroll.ZIndex = Level + 1

	local SidebarList = NewListLayout(SidebarScroll, 4)
	NewUIPadding(SidebarScroll, 8, 8, 8, 8)

	SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local h = SidebarList.AbsoluteContentSize.Y + 16
		SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, h)
	end)

	local ContentArea = NewFrame("ContentArea", BodyFrame)
	ContentArea.Size = UDim2.new(1, -Config.MenuBarW, 1, 0)
	ContentArea.Position = UDim2.new(0, Config.MenuBarW, 0, 0)

	Level = 5

	local PageIndicator = Instance.new("Frame")
	PageIndicator.Size = UDim2.new(0, 3, 0, 22)
	PageIndicator.Position = UDim2.new(0, 0, 0, 8)
	PageIndicator.BackgroundColor3 = accentColor
	PageIndicator.BorderSizePixel = 0
	PageIndicator.ZIndex = Level + 2
	NewCorner(4, PageIndicator)
	PageIndicator.Parent = Sidebar

	local TabCount = 0
	local ActivePage = nil

	local TabLibrary = {}

	TabLibrary.Notify = function(title, msg, t, dur)
		Notify(title, msg, t, dur)
	end

	TabLibrary.AddResetCallback = function(resetFunc)
		table.insert(FeaturesToReset, resetFunc)
	end

	function TabLibrary.AddPage(PageTitle)
		local pageIndex = TabCount
		TabCount += 1

		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = "Tab_"..PageTitle
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.Size = UDim2.new(1, 0, 0, 32)
		TabBtn.BackgroundColor3 = (pageIndex == 0) and Config.BG3 or Color3.fromRGB(0,0,0)
		TabBtn.BackgroundTransparency = (pageIndex == 0) and 0 or 1
		TabBtn.BorderSizePixel = 0
		TabBtn.ZIndex = Level
		TabBtn.LayoutOrder = pageIndex
		NewCorner(8, TabBtn)
		TabBtn.Parent = SidebarScroll

		local TabLbl = Instance.new("TextLabel")
		TabLbl.Text = PageTitle
		TabLbl.Font = Config.Font
		TabLbl.TextColor3 = (pageIndex == 0) and Config.TextPrimary or Config.TextSecondary
		TabLbl.TextSize = 12
		TabLbl.BackgroundTransparency = 1
		TabLbl.Size = UDim2.new(1, -16, 1, 0)
		TabLbl.Position = UDim2.new(0, 8, 0, 0)
		TabLbl.TextXAlignment = Enum.TextXAlignment.Left
		TabLbl.ZIndex = Level + 1
		TabLbl.Parent = TabBtn

		TabBtn.MouseEnter:Connect(function()
			if ActivePage ~= pageIndex then
				Tween(TabBtn, {BackgroundTransparency = 0.85, BackgroundColor3 = Config.BG3}, TI_Fast)
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if ActivePage ~= pageIndex then
				Tween(TabBtn, {BackgroundTransparency = 1}, TI_Fast)
			end
		end)

		local Page = NewScrollFrame("Page_"..PageTitle, ContentArea)
		Page.Visible = (pageIndex == 0)
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ZIndex = Level

		local PageList = NewListLayout(Page, Config.ElementPad)
		NewUIPadding(Page, 10, 10, 12, 12)

		PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			local h = PageList.AbsoluteContentSize.Y + 20
			Page.CanvasSize = UDim2.new(0, 0, 0, h)
		end)

		if pageIndex == 0 then
			ActivePage = 0
		end

		local function SelectTab()
			ActivePage = pageIndex

			for _, child in ipairs(ContentArea:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					if child == Page then
						child.Visible = true
						child.Position = UDim2.new(0.03, 0, 0, 0)
						Tween(child, {Position = UDim2.new(0, 0, 0, 0)}, TI_Normal)
					else
						child.Visible = false
					end
				end
			end

			for _, child in ipairs(SidebarScroll:GetChildren()) do
				if child:IsA("TextButton") then
					local isActive = (child == TabBtn)
					Tween(child, {
						BackgroundColor3 = isActive and Config.BG3 or Color3.fromRGB(0,0,0),
						BackgroundTransparency = isActive and 0 or 1
					}, TI_Normal)
					local lbl = child:FindFirstChildWhichIsA("TextLabel")
					if lbl then
						Tween(lbl, {TextColor3 = isActive and Config.TextPrimary or Config.TextSecondary}, TI_Normal)
					end
				end
			end

			local absPos = TabBtn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y + SidebarScroll.CanvasPosition.Y
			Tween(PageIndicator, {
				Position = UDim2.new(0, 0, 0, absPos + 5),
				Size = UDim2.new(0, 3, 0, 22)
			}, TI_Spring)
		end

		TabBtn.MouseButton1Click:Connect(function()
			Ripple(TabBtn)
			SelectTab()
		end)

		if pageIndex == 0 then
			SelectTab()
		end

		local PageLibrary = {}
		local ElementOrder = 0

		local function NextOrder()
			ElementOrder += 1
			return ElementOrder
		end

		function PageLibrary.AddSection(text)
			local container = NewFrame(text.."_Section", Page)
			container.Size = UDim2.new(1, 0, 0, 24)
			container.LayoutOrder = NextOrder()

			local line1 = Instance.new("Frame")
			line1.Size = UDim2.new(0.28, 0, 0, 1)
			line1.Position = UDim2.new(0, 0, 0.5, 0)
			line1.BackgroundColor3 = Config.Border
			line1.BorderSizePixel = 0
			line1.ZIndex = Level + 1
			line1.Parent = container

			local line2 = Instance.new("Frame")
			line2.Size = UDim2.new(0.28, 0, 0, 1)
			line2.Position = UDim2.new(0.72, 0, 0.5, 0)
			line2.BackgroundColor3 = Config.Border
			line2.BorderSizePixel = 0
			line2.ZIndex = Level + 1
			line2.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = string.upper(text)
			lbl.Font = Config.Font
			lbl.TextColor3 = accentColor
			lbl.TextSize = 10
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.44, 0, 1, 0)
			lbl.Position = UDim2.new(0.28, 0, 0, 0)
			lbl.ZIndex = Level + 1
			lbl.Parent = container
		end

		function PageLibrary.AddButton(text, callback, tooltip)
			local container = Instance.new("Frame")
			container.Name = text.."_Button"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.ClipsDescendants = true
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local btn = Instance.new("TextButton")
			btn.Text = text
			btn.Font = Config.FontLight
			btn.TextColor3 = Config.TextPrimary
			btn.TextSize = 12
			btn.BackgroundTransparency = 1
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.ZIndex = Level + 2
			btn.AutoButtonColor = false
			btn.Parent = bg

			local arrow = Instance.new("TextLabel")
			arrow.Text = ">"
			arrow.Font = Config.Font
			arrow.TextColor3 = accentColor
			arrow.TextSize = 14
			arrow.BackgroundTransparency = 1
			arrow.Size = UDim2.new(0, 22, 1, 0)
			arrow.Position = UDim2.new(1, -24, 0, 0)
			arrow.ZIndex = Level + 2
			arrow.Parent = bg

			AddHoverGlow(btn, bg, Config.BG4, Config.BG3)
			btn.MouseButton1Down:Connect(function()
				Ripple(bg)
				Tween(bg, {BackgroundColor3 = Config.BG4}, TI_Fast)
				Tween(arrow, {Position = UDim2.new(1, -16, 0, 0)}, TI_Fast)
				task.spawn(callback)
				task.delay(0.12, function()
					Tween(bg, {BackgroundColor3 = Config.BG3}, TI_Normal)
					Tween(arrow, {Position = UDim2.new(1, -24, 0, 0)}, TI_Normal)
				end)
			end)

			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				btn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				btn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end
		end

		function PageLibrary.AddLabel(text)
			local container = Instance.new("Frame")
			container.Name = text.."_Label"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG2
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			bg.Parent = container

			local leftBar = Instance.new("Frame")
			leftBar.Size = UDim2.new(0, 3, 0.7, 0)
			leftBar.Position = UDim2.new(0, 0, 0.15, 0)
			leftBar.BackgroundColor3 = accentColor
			leftBar.BorderSizePixel = 0
			leftBar.ZIndex = Level + 2
			NewCorner(2, leftBar)
			leftBar.Parent = bg

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextSecondary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, -16, 1, 0)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			return lbl
		end

		function PageLibrary.AddToggle(text, default, callback, tooltip)
			local state = default or false

			local container = Instance.new("Frame")
			container.Name = text.."_Toggle"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, -56, 1, 0)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local track = Instance.new("Frame")
			track.Size = UDim2.new(0, 34, 0, 18)
			track.Position = UDim2.new(1, -44, 0.5, -9)
			track.BackgroundColor3 = state and accentColor or Config.BG4
			track.BorderSizePixel = 0
			track.ZIndex = Level + 2
			NewCorner(999, track)
			track.Parent = bg

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.ZIndex = Level + 3
			NewCorner(999, knob)
			knob.Parent = track

			local btn = Instance.new("TextButton")
			btn.Text = ""
			btn.BackgroundTransparency = 1
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.ZIndex = Level + 4
			btn.AutoButtonColor = false
			btn.Parent = bg

			local function updateVisual()
				Tween(track, {BackgroundColor3 = state and accentColor or Config.BG4}, TI_Fast)
				Tween(knob, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, TI_Spring)
			end

			btn.MouseButton1Click:Connect(function()
				state = not state
				updateVisual()
				task.spawn(callback, state)
			end)

			AddHoverGlow(btn, bg, Config.BG4, Config.BG3)
			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				btn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				btn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			local toggleObj = {
				Set = function(_, val)
					state = val
					updateVisual()
				end,
				Get = function()
					return state
				end
			}
			return toggleObj
		end

		function PageLibrary.AddSlider(text, config, callback, tooltip)
			local cfg = config or {}
			local minVal = cfg.Min or 0
			local maxVal = cfg.Max or 100
			local defVal = cfg.Default or minVal
			local step   = cfg.Step or 1
			local suffix = cfg.Suffix or ""

			if minVal > maxVal then minVal, maxVal = maxVal, minVal end
			defVal = math.clamp(defVal, minVal, maxVal)
			local current = defVal

			local container = Instance.new("Frame")
			container.Name = text.."_Slider"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH + 14)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 0, 18)
			lbl.Position = UDim2.new(0, 12, 0, 3)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local valLbl = Instance.new("TextLabel")
			valLbl.Text = tostring(defVal)..suffix
			valLbl.Font = Config.Font
			valLbl.TextColor3 = accentColor
			valLbl.TextSize = 12
			valLbl.BackgroundTransparency = 1
			valLbl.Size = UDim2.new(0.4, -16, 0, 18)
			valLbl.Position = UDim2.new(0.6, 0, 0, 3)
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.ZIndex = Level + 2
			valLbl.Parent = bg

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -24, 0, 5)
			track.Position = UDim2.new(0, 12, 1, -12)
			track.BackgroundColor3 = Config.BG4
			track.BorderSizePixel = 0
			track.ZIndex = Level + 2
			NewCorner(999, track)
			track.Parent = bg

			local defaultScale = (defVal - minVal) / (maxVal - minVal)
			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(defaultScale, 0, 1, 0)
			fill.BackgroundColor3 = accentColor
			fill.BorderSizePixel = 0
			fill.ZIndex = Level + 3
			NewCorner(999, fill)
			fill.Parent = track

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(defaultScale, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.ZIndex = Level + 4
			NewCorner(999, knob)
			NewStroke(accentColor, 2, knob)
			knob.Parent = track

			local function updateSlider(xScale)
				xScale = math.clamp(xScale, 0, 1)
				local rawVal = minVal + (maxVal - minVal) * xScale
				current = math.floor(rawVal / step + 0.5) * step
				current = math.clamp(current, minVal, maxVal)
				local snappedScale = (current - minVal) / (maxVal - minVal)

				Tween(fill, {Size = UDim2.new(snappedScale, 0, 1, 0)}, TI_Fast)
				Tween(knob, {Position = UDim2.new(snappedScale, 0, 0.5, 0)}, TI_Fast)
				valLbl.Text = tostring(current)..suffix
				task.spawn(callback, current)
			end

			local sliderBtn = Instance.new("TextButton")
			sliderBtn.Text = ""
			sliderBtn.BackgroundTransparency = 1
			sliderBtn.Size = UDim2.new(1, 0, 1, 0)
			sliderBtn.ZIndex = Level + 5
			sliderBtn.AutoButtonColor = false
			sliderBtn.Parent = track

			local sliding = false
			sliderBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or
				   input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					Tween(knob, {Size = UDim2.new(0, 18, 0, 18)}, TI_Fast)
					local absPos = track.AbsolutePosition
					local mousePos = UserInputService:GetMouseLocation()
					local xs = (mousePos.X - absPos.X) / track.AbsoluteSize.X
					updateSlider(xs)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding then
					if input.UserInputType == Enum.UserInputType.MouseMovement or
					   input.UserInputType == Enum.UserInputType.Touch then
						local absPos = track.AbsolutePosition
						local mousePos = UserInputService:GetMouseLocation()
						local xs = (mousePos.X - absPos.X) / track.AbsoluteSize.X
						updateSlider(xs)
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or
				   input.UserInputType == Enum.UserInputType.Touch then
					if sliding then
						sliding = false
						Tween(knob, {Size = UDim2.new(0, 14, 0, 14)}, TI_Spring)
					end
				end
			end)

			AddHoverGlow(sliderBtn, bg, Config.BG4, Config.BG3)
			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				sliderBtn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				sliderBtn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			return {
				Set = function(_, val)
					local sc = (val - minVal) / (maxVal - minVal)
					updateSlider(sc)
				end,
				Get = function() return current end
			}
		end

		function PageLibrary.AddDropdown(text, options, callback, default, tooltip)
			local opts = options or {}
			local selected = default or (opts[1] or "")
			local open = false

			local container = Instance.new("Frame")
			container.Name = text.."_Dropdown"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.ClipsDescendants = false
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.ClipsDescendants = true
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.5, 0, 0, Config.ElementH)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local selLbl = Instance.new("TextLabel")
			selLbl.Text = selected
			selLbl.Font = Config.Font
			selLbl.TextColor3 = accentColor
			selLbl.TextSize = 12
			selLbl.BackgroundTransparency = 1
			selLbl.Size = UDim2.new(0.5, -42, 0, Config.ElementH)
			selLbl.Position = UDim2.new(0.5, 0, 0, 0)
			selLbl.TextXAlignment = Enum.TextXAlignment.Right
			selLbl.ZIndex = Level + 2
			selLbl.Parent = bg

			local chevron = Instance.new("TextLabel")
			chevron.Text = "v"
			chevron.Font = Config.Font
			chevron.TextColor3 = Config.TextSecondary
			chevron.TextSize = 12
			chevron.BackgroundTransparency = 1
			chevron.Size = UDim2.new(0, 24, 0, Config.ElementH)
			chevron.Position = UDim2.new(1, -28, 0, 0)
			chevron.ZIndex = Level + 2
			chevron.Parent = bg

			local optFrame = Instance.new("Frame")
			optFrame.Size = UDim2.new(1, 0, 0, #opts * Config.ElementH)
			optFrame.Position = UDim2.new(0, 0, 0, Config.ElementH)
			optFrame.BackgroundTransparency = 1
			optFrame.BorderSizePixel = 0
			optFrame.ZIndex = Level + 2
			optFrame.Visible = false
			optFrame.Parent = bg

			local optList = NewListLayout(optFrame, 0)

			for _, opt in ipairs(opts) do
				local optBtn = Instance.new("TextButton")
				optBtn.Text = opt
				optBtn.Font = Config.FontLight
				optBtn.TextColor3 = Config.TextSecondary
				optBtn.TextSize = 12
				optBtn.BackgroundColor3 = Config.BG4
				optBtn.BackgroundTransparency = 0
				optBtn.BorderSizePixel = 0
				optBtn.Size = UDim2.new(1, 0, 0, Config.ElementH)
				optBtn.ZIndex = Level + 3
				optBtn.AutoButtonColor = false
				optBtn.Parent = optFrame

				optBtn.MouseEnter:Connect(function()
					Tween(optBtn, {BackgroundColor3 = Config.BG3, TextColor3 = Config.TextPrimary}, TI_Fast)
				end)
				optBtn.MouseLeave:Connect(function()
					Tween(optBtn, {BackgroundColor3 = Config.BG4, TextColor3 = Config.TextSecondary}, TI_Fast)
				end)

				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					selLbl.Text = opt
					open = false
					optFrame.Visible = false
					Tween(container, {Size = UDim2.new(1, 0, 0, Config.ElementH)}, TI_Back)
					Tween(bg, {Size = UDim2.new(1, 0, 1, 0)}, TI_Back)
					Tween(chevron, {Rotation = 0}, TI_Back)
					task.spawn(callback, opt)
				end)
			end

			local headerBtn = Instance.new("TextButton")
			headerBtn.Text = ""
			headerBtn.BackgroundTransparency = 1
			headerBtn.Size = UDim2.new(1, 0, 0, Config.ElementH)
			headerBtn.ZIndex = Level + 4
			headerBtn.AutoButtonColor = false
			headerBtn.Parent = bg

			headerBtn.MouseButton1Click:Connect(function()
				open = not open
				local expandedH = Config.ElementH + (#opts * Config.ElementH)
				optFrame.Visible = open
				Tween(container, {Size = open and UDim2.new(1, 0, 0, expandedH) or UDim2.new(1, 0, 0, Config.ElementH)}, TI_Back)
				Tween(bg, {Size = open and UDim2.new(1, 0, 0, expandedH) or UDim2.new(1, 0, 1, 0)}, TI_Back)
				Tween(chevron, {Rotation = open and 180 or 0}, TI_Back)
			end)

			AddHoverGlow(headerBtn, bg, Config.BG4, Config.BG3)
			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				headerBtn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				headerBtn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			return {
				Set = function(_, val)
					selected = val
					selLbl.Text = val
				end,
				Get = function() return selected end,
				Refresh = function(_, newOpts)
					for _, ch in ipairs(optFrame:GetChildren()) do
						if ch:IsA("TextButton") then ch:Destroy() end
					end
					opts = newOpts
					for _, opt in ipairs(opts) do
						local optBtn = Instance.new("TextButton")
						optBtn.Text = opt
						optBtn.Font = Config.FontLight
						optBtn.TextColor3 = Config.TextSecondary
						optBtn.TextSize = 12
						optBtn.BackgroundColor3 = Config.BG4
						optBtn.BackgroundTransparency = 0
						optBtn.BorderSizePixel = 0
						optBtn.Size = UDim2.new(1, 0, 0, Config.ElementH)
						optBtn.ZIndex = Level + 3
						optBtn.AutoButtonColor = false
						optBtn.Parent = optFrame
						optBtn.MouseButton1Click:Connect(function()
							selected = opt
							selLbl.Text = opt
							open = false
							optFrame.Visible = false
							Tween(container, {Size = UDim2.new(1, 0, 0, Config.ElementH)}, TI_Back)
							Tween(bg, {Size = UDim2.new(1, 0, 1, 0)}, TI_Back)
							Tween(chevron, {Rotation = 0}, TI_Back)
							task.spawn(callback, opt)
						end)
					end
				end
			}
		end

		function PageLibrary.AddTextInput(text, placeholder, callback, tooltip)
			local container = Instance.new("Frame")
			container.Name = text.."_TextInput"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			local stroke = NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextSecondary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.4, 0, 1, 0)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local box = Instance.new("TextBox")
			box.PlaceholderText = placeholder or "Enter text..."
			box.Text = ""
			box.Font = Config.FontLight
			box.TextColor3 = Config.TextPrimary
			box.PlaceholderColor3 = Config.TextMuted
			box.TextSize = 12
			box.BackgroundTransparency = 1
			box.Size = UDim2.new(0.6, -12, 1, 0)
			box.Position = UDim2.new(0.4, 0, 0, 0)
			box.TextXAlignment = Enum.TextXAlignment.Left
			box.ZIndex = Level + 2
			box.ClearTextOnFocus = false
			box.Parent = bg

			box.Focused:Connect(function()
				Tween(stroke, {Color = accentColor, Transparency = 0}, TI_Fast)
			end)
			box.FocusLost:Connect(function(enter)
				Tween(stroke, {Color = Config.Border, Transparency = 0.5}, TI_Fast)
				if enter then
					task.spawn(callback, box.Text)
				end
			end)

			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				box.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				box.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			return {
				Set = function(_, val) box.Text = val end,
				Get = function() return box.Text end,
			}
		end

		function PageLibrary.AddKeybind(text, default, callback, tooltip)
			local key = default or Enum.KeyCode.Unknown
			local listening = false

			local container = Instance.new("Frame")
			container.Name = text.."_Keybind"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 1, 0)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local keyPill = Instance.new("Frame")
			keyPill.Size = UDim2.new(0, 70, 0, 20)
			keyPill.Position = UDim2.new(1, -78, 0.5, -10)
			keyPill.BackgroundColor3 = Config.BG4
			keyPill.BorderSizePixel = 0
			keyPill.ZIndex = Level + 2
			NewCorner(5, keyPill)
			NewStroke(Config.Border, 1, keyPill)
			keyPill.Parent = bg

			local keyLbl = Instance.new("TextLabel")
			keyLbl.Text = key.Name
			keyLbl.Font = Config.FontMono
			keyLbl.TextColor3 = accentColor
			keyLbl.TextSize = 11
			keyLbl.BackgroundTransparency = 1
			keyLbl.Size = UDim2.new(1, 0, 1, 0)
			keyLbl.ZIndex = Level + 3
			keyLbl.Parent = keyPill

			local keyBtn = Instance.new("TextButton")
			keyBtn.Text = ""
			keyBtn.BackgroundTransparency = 1
			keyBtn.Size = UDim2.new(1, 0, 1, 0)
			keyBtn.ZIndex = Level + 4
			keyBtn.AutoButtonColor = false
			keyBtn.Parent = keyPill

			keyBtn.MouseButton1Click:Connect(function()
				listening = true
				keyLbl.Text = "..."
				Tween(keyPill, {BackgroundColor3 = Config.AccentDim}, TI_Fast)
			end)

			UserInputService.InputBegan:Connect(function(input, gpe)
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					listening = false
					key = input.KeyCode
					keyLbl.Text = key.Name
					Tween(keyPill, {BackgroundColor3 = Config.BG4}, TI_Fast)
					task.spawn(callback, key)
				end
			end)

			AddHoverGlow(keyBtn, keyPill, Config.BG3, Config.BG4)
			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				keyBtn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				keyBtn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			return {
				Get = function() return key end
			}
		end

		function PageLibrary.AddColorPicker(text, default, callback, tooltip)
			local col = default or Color3.fromRGB(255, 255, 255)
			if type(default) == "table" then
				col = Color3.fromRGB(default[1] or 255, default[2] or 255, default[3] or 255)
			end

			local open = false

			local container = Instance.new("Frame")
			container.Name = text.."_ColorPicker"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH)
			container.BackgroundTransparency = 1
			container.BorderSizePixel = 0
			container.ClipsDescendants = true
			container.LayoutOrder = NextOrder()
			container.ZIndex = Level
			container.Parent = Page

			local bg = Instance.new("Frame")
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = Config.BG3
			bg.BorderSizePixel = 0
			bg.ZIndex = Level + 1
			NewCorner(8, bg)
			NewStroke(Config.Border, 1, bg, 0.5)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 0, Config.ElementH)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local preview = Instance.new("Frame")
			preview.Size = UDim2.new(0, 22, 0, 16)
			preview.Position = UDim2.new(1, -34, 0.5, -8)
			preview.BackgroundColor3 = col
			preview.BorderSizePixel = 0
			preview.ZIndex = Level + 2
			NewCorner(4, preview)
			preview.Parent = bg

			local previewBtn = Instance.new("TextButton")
			previewBtn.Text = ""
			previewBtn.BackgroundTransparency = 1
			previewBtn.Size = UDim2.new(1, 0, 0, Config.ElementH)
			previewBtn.ZIndex = Level + 3
			previewBtn.AutoButtonColor = false
			previewBtn.Parent = bg

			local expandH = Config.ElementH + 90

			local colorFrame = Instance.new("Frame")
			colorFrame.Size = UDim2.new(1, 0, 0, 90)
			colorFrame.Position = UDim2.new(0, 0, 0, Config.ElementH)
			colorFrame.BackgroundTransparency = 1
			colorFrame.BorderSizePixel = 0
			colorFrame.ZIndex = Level + 2
			colorFrame.Parent = bg

			local colorList = NewListLayout(colorFrame, 3)
			NewUIPadding(colorFrame, 4, 4, 8, 8)

			local function makeChannelSlider(ch, defVal, onChanged)
				local sf = Instance.new("Frame")
				sf.Size = UDim2.new(1, 0, 0, 22)
				sf.BackgroundTransparency = 1
				sf.BorderSizePixel = 0
				sf.ZIndex = Level + 3
				sf.Parent = colorFrame

				local slbl = Instance.new("TextLabel")
				slbl.Text = ch
				slbl.Font = Config.Font
				slbl.TextColor3 = Config.TextSecondary
				slbl.TextSize = 11
				slbl.BackgroundTransparency = 1
				slbl.Size = UDim2.new(0, 16, 1, 0)
				slbl.ZIndex = Level + 4
				slbl.Parent = sf

				local track = Instance.new("Frame")
				track.Size = UDim2.new(1, -48, 0, 5)
				track.Position = UDim2.new(0, 20, 0.5, -2.5)
				track.BackgroundColor3 = Config.BG4
				track.BorderSizePixel = 0
				track.ZIndex = Level + 4
				NewCorner(999, track)
				track.Parent = sf

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new(defVal / 255, 0, 1, 0)
				fill.BackgroundColor3 = accentColor
				fill.BorderSizePixel = 0
				fill.ZIndex = Level + 5
				NewCorner(999, fill)
				fill.Parent = track

				local valDisplay = Instance.new("TextLabel")
				valDisplay.Text = tostring(defVal)
				valDisplay.Font = Config.FontMono
				valDisplay.TextColor3 = Config.TextSecondary
				valDisplay.TextSize = 10
				valDisplay.BackgroundTransparency = 1
				valDisplay.Size = UDim2.new(0, 28, 1, 0)
				valDisplay.Position = UDim2.new(1, -28, 0, 0)
				valDisplay.ZIndex = Level + 4
				valDisplay.Parent = sf

				local sliding = false
				local sBtn = Instance.new("TextButton")
				sBtn.Text = ""
				sBtn.BackgroundTransparency = 1
				sBtn.Size = UDim2.new(1, 0, 1, 0)
				sBtn.ZIndex = Level + 6
				sBtn.AutoButtonColor = false
				sBtn.Parent = track

				local currentVal = defVal
				sBtn.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or
					   input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						local absPos = track.AbsolutePosition
						local mousePos = UserInputService:GetMouseLocation()
						local xs = (mousePos.X - absPos.X) / track.AbsoluteSize.X
						xs = math.clamp(xs, 0, 1)
						currentVal = math.floor(xs * 255)
						fill.Size = UDim2.new(xs, 0, 1, 0)
						valDisplay.Text = tostring(currentVal)
						onChanged(currentVal)
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if sliding then
						if input.UserInputType == Enum.UserInputType.MouseMovement or
						   input.UserInputType == Enum.UserInputType.Touch then
							local absPos = track.AbsolutePosition
							local mousePos = UserInputService:GetMouseLocation()
							local xs = (mousePos.X - absPos.X) / track.AbsoluteSize.X
							xs = math.clamp(xs, 0, 1)
							currentVal = math.floor(xs * 255)
							fill.Size = UDim2.new(xs, 0, 1, 0)
							valDisplay.Text = tostring(currentVal)
							onChanged(currentVal)
						end
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or
					   input.UserInputType == Enum.UserInputType.Touch then
						sliding = false
					end
				end)
				return function() return currentVal end
			end

			local rVal, gVal, bVal = math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255)
			local getRed, getGreen, getBlue

			local function updateColor()
				col = Color3.fromRGB(getRed(), getGreen(), getBlue())
				Tween(preview, {BackgroundColor3 = col}, TI_Fast)
				task.spawn(callback, col)
			end

			getRed   = makeChannelSlider("R", rVal,   function() updateColor() end)
			getGreen = makeChannelSlider("G", gVal,   function() updateColor() end)
			getBlue  = makeChannelSlider("B", bVal,   function() updateColor() end)

			previewBtn.MouseButton1Click:Connect(function()
				open = not open
				Tween(container, {Size = open and UDim2.new(1, 0, 0, expandH) or UDim2.new(1, 0, 0, Config.ElementH)}, TI_Back)
			end)

			AddHoverGlow(previewBtn, bg, Config.BG4, Config.BG3)
			if tooltip then
				local tip = Instance.new("Frame")
				tip.BackgroundColor3 = Config.BG4
				tip.BorderSizePixel = 0
				tip.Size = UDim2.new(0, 0, 0, 24)
				tip.ZIndex = 200
				tip.Visible = false
				NewCorner(6, tip)
				NewStroke(Config.Border, 1, tip)
				tip.Parent = ScreenGui

				local tipLbl = Instance.new("TextLabel")
				tipLbl.Text = tooltip
				tipLbl.Font = Config.FontLight
				tipLbl.TextColor3 = Config.TextPrimary
				tipLbl.TextSize = 11
				tipLbl.BackgroundTransparency = 1
				tipLbl.Size = UDim2.new(1, -12, 1, 0)
				tipLbl.Position = UDim2.new(0, 6, 0, 0)
				tipLbl.ZIndex = 201
				tipLbl.Parent = tip

				local textSize = TextService:GetTextSize(tooltip, 11, Config.FontLight, Vector2.new(1000, 24))
				tip.Size = UDim2.new(0, textSize.X + 18, 0, 24)

				previewBtn.MouseEnter:Connect(function()
					tip.Visible = true
					tip.BackgroundTransparency = 1
					Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
				end)
				previewBtn.MouseLeave:Connect(function()
					tip.Visible = false
				end)

				RunService.RenderStepped:Connect(function()
					if tip.Visible then
						tip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y - 30)
					end
				end)
			end

			return {
				Get = function() return col end,
				Set = function(_, newCol)
					col = newCol
					Tween(preview, {BackgroundColor3 = col}, TI_Fast)
				end
			}
		end

		do
			local searchContainer = Instance.new("Frame")
			searchContainer.Name = "SearchBar"
			searchContainer.Size = UDim2.new(1, 0, 0, Config.ElementH)
			searchContainer.BackgroundTransparency = 1
			searchContainer.BorderSizePixel = 0
			searchContainer.LayoutOrder = -1
			searchContainer.ZIndex = Level
			searchContainer.Parent = Page

			local searchBg = Instance.new("Frame")
			searchBg.Size = UDim2.new(1, 0, 1, 0)
			searchBg.BackgroundColor3 = Config.BG2
			searchBg.BorderSizePixel = 0
			searchBg.ZIndex = Level + 1
			NewCorner(8, searchBg)
			local searchStroke = NewStroke(Config.Border, 1, searchBg, 0.5)
			searchBg.Parent = searchContainer

			local searchIcon = Instance.new("TextLabel")
			searchIcon.Text = "S"
			searchIcon.TextSize = 11
			searchIcon.Font = Config.Font
			searchIcon.BackgroundTransparency = 1
			searchIcon.Size = UDim2.new(0, 24, 1, 0)
			searchIcon.Position = UDim2.new(0, 6, 0, 0)
			searchIcon.ZIndex = Level + 2
			searchIcon.Parent = searchBg

			local searchBox = Instance.new("TextBox")
			searchBox.PlaceholderText = "Search elements..."
			searchBox.Text = ""
			searchBox.Font = Config.FontLight
			searchBox.TextColor3 = Config.TextPrimary
			searchBox.PlaceholderColor3 = Config.TextMuted
			searchBox.TextSize = 12
			searchBox.BackgroundTransparency = 1
			searchBox.Size = UDim2.new(1, -32, 1, 0)
			searchBox.Position = UDim2.new(0, 28, 0, 0)
			searchBox.TextXAlignment = Enum.TextXAlignment.Left
			searchBox.ZIndex = Level + 2
			searchBox.ClearTextOnFocus = false
			searchBox.Parent = searchBg

			searchBox.Focused:Connect(function()
				Tween(searchStroke, {Color = accentColor, Transparency = 0}, TI_Fast)
			end)
			searchBox.FocusLost:Connect(function()
				Tween(searchStroke, {Color = Config.Border, Transparency = 0.5}, TI_Fast)
			end)

			searchBox:GetPropertyChangedSignal("Text"):Connect(function()
				local query = searchBox.Text:lower()
				for _, el in ipairs(Page:GetChildren()) do
					if el:IsA("Frame") and el.Name ~= "SearchBar" then
						if query == "" then
							el.Visible = true
							Tween(el, {BackgroundTransparency = 0}, TI_Fast)
						else
							local visible = el.Name:lower():find(query, 1, true) ~= nil
							el.Visible = visible
							if visible then
								Tween(el, {BackgroundTransparency = 0}, TI_Fast)
							end
						end
					end
				end
			end)
		end

		return PageLibrary
	end

	TabLibrary.Notify = Notify

	ContainerFrame.Size = UDim2.new(0, Config.WindowW * 0.85, 0, Config.WindowH * 0.85)
	ContainerFrame.Position = UDim2.new(0.5, -(Config.WindowW * 0.85) / 2, 0.5, -(Config.WindowH * 0.85) / 2)
	MainFrame.BackgroundTransparency = 1
	Tween(ContainerFrame, {
		Size = UDim2.new(0, Config.WindowW, 0, Config.WindowH),
		Position = UDim2.new(0.5, -Config.WindowW / 2, 0.5, -Config.WindowH / 2)
	}, TI_Spring)
	Tween(MainFrame, {BackgroundTransparency = 0}, TI_Normal)

	return TabLibrary
end

return UILibrary
