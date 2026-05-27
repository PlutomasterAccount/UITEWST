local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGuiService = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- ─────────────────────────────────────────
-- CONFIG
-- ─────────────────────────────────────────
local Config = {
	TweenTime       = 0.18,
	FastTweenTime   = 0.10,
	SlowTweenTime   = 0.30,
	SpringTweenTime = 0.35,

	-- Colours
	BG              = Color3.fromRGB(18, 18, 22),
	BG2             = Color3.fromRGB(24, 24, 30),
	BG3             = Color3.fromRGB(32, 32, 40),
	BG4             = Color3.fromRGB(40, 40, 52),
	Accent          = Color3.fromRGB(120, 90, 255),
	AccentDim       = Color3.fromRGB(80, 58, 180),
	AccentGlow      = Color3.fromRGB(160, 130, 255),
	TextPrimary     = Color3.fromRGB(240, 240, 248),
	TextSecondary   = Color3.fromRGB(140, 140, 160),
	TextMuted       = Color3.fromRGB(80, 80, 100),
	Success         = Color3.fromRGB(72, 220, 140),
	Danger          = Color3.fromRGB(255, 90, 100),
	Warning         = Color3.fromRGB(255, 190, 60),
	Border          = Color3.fromRGB(50, 50, 68),

	-- Dimensions
	WindowW         = 560,
	WindowH         = 340,
	MenuBarW        = 110,
	TitleBarH       = 26,
	ElementH        = 24,
	ElementPad      = 4,

	-- Icon atlas
	IconLib1        = "rbxassetid://3926305904",
	IconLib2        = "rbxassetid://3926307971",
	DropShadowID    = "rbxassetid://297774371",

	-- Font
	Font            = Enum.Font.GothamBold,
	FontLight       = Enum.Font.Gotham,
	FontMono        = Enum.Font.Code,
}

-- ─────────────────────────────────────────
-- TWEEN HELPERS
-- ─────────────────────────────────────────
local function MakeTweenInfo(t, style, dir, rep, rev, delay)
	return TweenInfo.new(
		t or Config.TweenTime,
		style or Enum.EasingStyle.Quint,
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

local function TweenSeq(obj, steps)
	-- steps = {{props, info, delay?}, ...}
	local totalDelay = 0
	for _, step in ipairs(steps) do
		local props, info, delay = step[1], step[2], step[3] or 0
		totalDelay += delay
		task.delay(totalDelay, function()
			Tween(obj, props, info)
		end)
		if info then
			totalDelay += info.Time
		end
	end
end

-- ─────────────────────────────────────────
-- UTILITY
-- ─────────────────────────────────────────
local Level = 1

local function NextLevel()
	Level += 1
	return Level
end

local function GetXY(gui)
	local touch = UserInputService:GetMouseLocation()
	local X = touch.X - gui.AbsolutePosition.X
	local Y = touch.Y - gui.AbsolutePosition.Y
	local maxX = gui.AbsoluteSize.X
	local maxY = gui.AbsoluteSize.Y
	X = math.clamp(X, 0, maxX)
	Y = math.clamp(Y, 0, maxY)
	return X, Y, X / maxX, Y / maxY
end

local function IsMobile()
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- ─────────────────────────────────────────
-- UI PRIMITIVES
-- ─────────────────────────────────────────
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
	sf.ScrollBarThickness = 2
	sf.ScrollBarImageColor3 = Config.Accent
	sf.ScrollBarImageTransparency = 0.5
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

-- ─────────────────────────────────────────
-- ICON HELPERS
-- ─────────────────────────────────────────
local function IconLabel(lib, ox, oy, sx, sy, size, parent)
	local img = Instance.new("ImageLabel")
	img.BackgroundTransparency = 1
	img.Image = lib
	img.ImageRectOffset = Vector2.new(ox, oy)
	img.ImageRectSize = Vector2.new(sx, sy)
	img.Size = UDim2.new(0, size or 14, 0, size or 14)
	img.ZIndex = Level
	img.Parent = parent
	return img
end

local function IconButton(lib, ox, oy, sx, sy, size, parent)
	local img = Instance.new("ImageButton")
	img.BackgroundTransparency = 1
	img.Image = lib
	img.ImageRectOffset = Vector2.new(ox, oy)
	img.ImageRectSize = Vector2.new(sx, sy)
	img.Size = UDim2.new(0, size or 14, 0, size or 14)
	img.ZIndex = Level
	img.Parent = parent
	return img
end

-- ripple effect on button click
local function Ripple(parent)
	local rip = Instance.new("Frame")
	rip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	rip.BackgroundTransparency = 0.8
	rip.Size = UDim2.new(0, 0, 0, 0)
	rip.AnchorPoint = Vector2.new(0.5, 0.5)
	rip.Position = UDim2.new(0.5, 0, 0.5, 0)
	rip.ZIndex = Level + 5
	NewCorner(999, rip)
	rip.Parent = parent

	local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
	Tween(rip, {Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1}, MakeTweenInfo(0.45, Enum.EasingStyle.Quad))
	task.delay(0.5, function()
		rip:Destroy()
	end)
end

-- hover glow pulse
local function AddHoverGlow(btn, bg, hoverColor, normalColor)
	btn.MouseEnter:Connect(function()
		Tween(bg, {ImageColor3 = hoverColor}, TI_Fast)
	end)
	btn.MouseLeave:Connect(function()
		Tween(bg, {ImageColor3 = normalColor}, TI_Fast)
	end)
end

-- ─────────────────────────────────────────
-- NOTIFICATION SYSTEM
-- ─────────────────────────────────────────
local NotifParent = nil

local function NotifySetup(screenGui)
	local holder = NewFrame("NotifHolder", screenGui)
	holder.Size = UDim2.new(0, 260, 1, 0)
	holder.Position = UDim2.new(1, -270, 0, 0)
	holder.BackgroundTransparency = 1
	holder.ZIndex = 100

	local list = NewListLayout(holder, 6)
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NewUIPadding(holder, 0, 10, 0, 0)

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
	container.Size = UDim2.new(1, 0, 0, 64)
	container.BackgroundTransparency = 1

	local bg = NewRound(10, container)
	bg.ImageColor3 = Config.BG3
	bg.Size = UDim2.new(1, 0, 1, 0)
	NewStroke(color, 1, bg, 0.5)

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
	titleLbl.TextSize = 12
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1, -20, 0, 18)
	titleLbl.Position = UDim2.new(0, 16, 0, 6)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 102
	titleLbl.Parent = bg

	local msgLbl = Instance.new("TextLabel")
	msgLbl.Text = message
	msgLbl.Font = Config.FontLight
	msgLbl.TextColor3 = Config.TextSecondary
	msgLbl.TextSize = 11
	msgLbl.BackgroundTransparency = 1
	msgLbl.Size = UDim2.new(1, -20, 0, 28)
	msgLbl.Position = UDim2.new(0, 16, 0, 24)
	msgLbl.TextXAlignment = Enum.TextXAlignment.Left
	msgLbl.TextWrapped = true
	msgLbl.ZIndex = 102
	msgLbl.Parent = bg

	-- progress bar
	local progress = Instance.new("Frame")
	progress.Size = UDim2.new(1, -12, 0, 2)
	progress.Position = UDim2.new(0, 6, 1, -4)
	progress.BackgroundColor3 = color
	progress.BorderSizePixel = 0
	NewCorner(2, progress)
	progress.ZIndex = 102
	progress.Parent = bg

	-- animate in
	bg.Position = UDim2.new(1, 20, 0, 0)
	Tween(bg, {Position = UDim2.new(0, 0, 0, 0)}, TI_Back)

	-- shrink progress bar over duration
	Tween(progress, {Size = UDim2.new(0, 0, 0, 2)}, MakeTweenInfo(duration, Enum.EasingStyle.Linear))

	task.delay(duration, function()
		Tween(bg, {Position = UDim2.new(1, 20, 0, 0), ImageTransparency = 1}, TI_Normal)
		task.delay(Config.TweenTime + 0.05, function()
			container:Destroy()
		end)
	end)
end

-- ─────────────────────────────────────────
-- TOOLTIP
-- ─────────────────────────────────────────
local function AddTooltip(target, tipText, screenGui)
	if not tipText or tipText == "" then return end

	local tip = Instance.new("Frame")
	tip.BackgroundColor3 = Config.BG4
	tip.BorderSizePixel = 0
	tip.Size = UDim2.new(0, 0, 0, 22)
	tip.ZIndex = 200
	tip.Visible = false
	NewCorner(6, tip)
	NewStroke(Config.Border, 1, tip)
	tip.Parent = screenGui

	local tipLbl = Instance.new("TextLabel")
	tipLbl.Text = tipText
	tipLbl.Font = Config.FontLight
	tipLbl.TextColor3 = Config.TextPrimary
	tipLbl.TextSize = 11
	tipLbl.BackgroundTransparency = 1
	tipLbl.Size = UDim2.new(1, -10, 1, 0)
	tipLbl.Position = UDim2.new(0, 5, 0, 0)
	tipLbl.ZIndex = 201
	tipLbl.Parent = tip

	local textSize = TextService:GetTextSize(tipText, 11, Config.FontLight, Vector2.new(1000, 22))
	tip.Size = UDim2.new(0, textSize.X + 14, 0, 22)

	local conn1, conn2
	conn1 = target.MouseEnter:Connect(function()
		tip.Visible = true
		tip.BackgroundTransparency = 1
		Tween(tip, {BackgroundTransparency = 0}, TI_Fast)
	end)
	conn2 = target.MouseLeave:Connect(function()
		tip.Visible = false
	end)

	RunService.RenderStepped:Connect(function()
		if tip.Visible then
			tip.Position = UDim2.new(0, Mouse.X + 12, 0, Mouse.Y - 28)
		end
	end)
end

-- ─────────────────────────────────────────
-- MAIN LIBRARY
-- ─────────────────────────────────────────
local UILibrary = {}

function UILibrary.Load(GUITitle, options)
	options = options or {}
	local accentColor = options.AccentColor or Config.Accent

	local TargetedParent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or CoreGuiService

	-- destroy old instance
	local old = TargetedParent:FindFirstChild(GUITitle)
	if old then old:Destroy() end

	Level = 1

	-- Screen GUI
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = GUITitle
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = TargetedParent

	NotifySetup(ScreenGui)

	-- ── Outer shadow / container
	Level = 1
	local ContainerFrame = NewFrame("ContainerFrame", ScreenGui)
	ContainerFrame.Size = UDim2.new(0, Config.WindowW, 0, Config.WindowH)
	ContainerFrame.Position = UDim2.new(0.5, -Config.WindowW/2, 0.5, -Config.WindowH/2)
	ContainerFrame.BackgroundTransparency = 1

	-- Drop shadow using multiple layered frames for a soft glow
	for i = 5, 1, -1 do
		local shadow = Instance.new("Frame")
		shadow.Size = UDim2.new(1, i * 8, 1, i * 8)
		shadow.Position = UDim2.new(0, -i * 4, 0, -i * 4)
		shadow.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
		shadow.BackgroundTransparency = 0.6 + (i * 0.07)
		shadow.BorderSizePixel = 0
		shadow.ZIndex = 0
		NewCorner(14 + i, shadow)
		shadow.Parent = ContainerFrame
	end

	Level = 2

	-- ── Main window
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.BackgroundColor3 = Config.BG
	MainFrame.BorderSizePixel = 0
	MainFrame.ZIndex = Level
	NewCorner(12, MainFrame)
	NewStroke(Config.Border, 1, MainFrame, 0.3)
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ContainerFrame

	-- subtle noise/grid overlay for texture
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundTransparency = 0.97
	overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	overlay.BorderSizePixel = 0
	overlay.ZIndex = Level + 1
	overlay.Parent = MainFrame

	Level = 3

	-- ── Title bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, Config.TitleBarH)
	TitleBar.BackgroundColor3 = Config.BG2
	TitleBar.BorderSizePixel = 0
	TitleBar.ZIndex = Level
	TitleBar.Parent = MainFrame

	-- accent line under title bar
	local TitleAccentLine = Instance.new("Frame")
	TitleAccentLine.Size = UDim2.new(1, 0, 0, 1)
	TitleAccentLine.Position = UDim2.new(0, 0, 1, -1)
	TitleAccentLine.BackgroundColor3 = accentColor
	TitleAccentLine.BackgroundTransparency = 0.5
	TitleAccentLine.BorderSizePixel = 0
	TitleAccentLine.ZIndex = Level + 1
	TitleAccentLine.Parent = TitleBar

	-- dot indicators (macOS style)
	local dotColors = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 190, 60), Color3.fromRGB(72, 210, 100)}
	local dotSize = 9
	for i, dc in ipairs(dotColors) do
		local dot = Instance.new("Frame")
		dot.Size = UDim2.new(0, dotSize, 0, dotSize)
		dot.Position = UDim2.new(0, 8 + (i - 1) * (dotSize + 5), 0.5, -dotSize / 2)
		dot.BackgroundColor3 = dc
		dot.BorderSizePixel = 0
		dot.ZIndex = Level + 2
		NewCorner(999, dot)
		dot.Parent = TitleBar
	end

	-- title text
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = GUITitle
	TitleLabel.Font = Config.Font
	TitleLabel.TextColor3 = Config.TextPrimary
	TitleLabel.TextSize = 13
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
	TitleLabel.ZIndex = Level + 2
	TitleLabel.Parent = TitleBar

	-- minimise / close buttons
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"
	CloseBtn.Font = Config.Font
	CloseBtn.TextColor3 = Config.TextSecondary
	CloseBtn.TextSize = 11
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Size = UDim2.new(0, 24, 1, 0)
	CloseBtn.Position = UDim2.new(1, -26, 0, 0)
	CloseBtn.ZIndex = Level + 2
	CloseBtn.AutoButtonColor = false
	CloseBtn.Parent = TitleBar

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "─"
	MinBtn.Font = Config.Font
	MinBtn.TextColor3 = Config.TextSecondary
	MinBtn.TextSize = 11
	MinBtn.BackgroundTransparency = 1
	MinBtn.Size = UDim2.new(0, 24, 1, 0)
	MinBtn.Position = UDim2.new(1, -52, 0, 0)
	MinBtn.ZIndex = Level + 2
	MinBtn.AutoButtonColor = false
	MinBtn.Parent = TitleBar

	-- hover effects on buttons
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

	-- minimise toggle
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

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(MainFrame, {BackgroundTransparency = 1}, TI_Normal)
		-- fade shadows
		for _, ch in ipairs(ContainerFrame:GetChildren()) do
			if ch:IsA("Frame") and ch.ZIndex == 0 then
				Tween(ch, {BackgroundTransparency = 1}, TI_Normal)
			end
		end
		task.delay(Config.TweenTime + 0.05, function()
			ScreenGui:Destroy()
		end)
	end)

	-- ── Dragging (mouse + touch)
	local dragging = false
	local dragStart, startPos

	local function startDrag(inputPos)
		dragging = true
		dragStart = inputPos
		startPos = ContainerFrame.Position
	end
	local function moveDrag(inputPos)
		if not dragging then return end
		local delta = inputPos - dragStart
		ContainerFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
	local function endDrag()
		dragging = false
	end

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			startDrag(Vector2.new(input.Position.X, input.Position.Y))
		elseif input.UserInputType == Enum.UserInputType.Touch then
			startDrag(Vector2.new(input.Position.X, input.Position.Y))
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			moveDrag(Vector2.new(input.Position.X, input.Position.Y))
		elseif input.UserInputType == Enum.UserInputType.Touch then
			moveDrag(Vector2.new(input.Position.X, input.Position.Y))
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			endDrag()
		end
	end)

	Level = 4

	-- ── Body layout
	local BodyFrame = NewFrame("Body", MainFrame)
	BodyFrame.Size = UDim2.new(1, 0, 1, -Config.TitleBarH)
	BodyFrame.Position = UDim2.new(0, 0, 0, Config.TitleBarH)

	-- ── Sidebar (tab menu)
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, Config.MenuBarW, 1, 0)
	Sidebar.BackgroundColor3 = Config.BG2
	Sidebar.BorderSizePixel = 0
	Sidebar.ZIndex = Level
	Sidebar.Parent = BodyFrame

	-- sidebar accent border right
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

	local SidebarList = NewListLayout(SidebarScroll, 3)
	NewUIPadding(SidebarScroll, 6, 6, 6, 6)

	SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local h = SidebarList.AbsoluteContentSize.Y + 12
		SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, h)
	end)

	-- ── Content area
	local ContentArea = NewFrame("ContentArea", BodyFrame)
	ContentArea.Size = UDim2.new(1, -Config.MenuBarW, 1, 0)
	ContentArea.Position = UDim2.new(0, Config.MenuBarW, 0, 0)

	Level = 5

	-- ── Page indicator (accent bar that slides)
	local PageIndicator = Instance.new("Frame")
	PageIndicator.Size = UDim2.new(0, 3, 0, 20)
	PageIndicator.Position = UDim2.new(0, 0, 0, 6)
	PageIndicator.BackgroundColor3 = accentColor
	PageIndicator.BorderSizePixel = 0
	PageIndicator.ZIndex = Level + 2
	NewCorner(4, PageIndicator)
	PageIndicator.Parent = Sidebar

	-- ── Tab system
	local TabCount = 0
	local ActivePage = nil

	local TabLibrary = {}

	-- expose notify globally for pages to use
	TabLibrary.Notify = function(title, msg, t, dur)
		Notify(title, msg, t, dur)
	end

	function TabLibrary.AddPage(PageTitle, icon)
		local pageIndex = TabCount
		TabCount += 1

		-- ── Tab button in sidebar
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = "Tab_"..PageTitle
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.Size = UDim2.new(1, 0, 0, 28)
		TabBtn.BackgroundColor3 = (pageIndex == 0) and Config.BG3 or Color3.fromRGB(0,0,0)
		TabBtn.BackgroundTransparency = (pageIndex == 0) and 0 or 1
		TabBtn.BorderSizePixel = 0
		TabBtn.ZIndex = Level
		TabBtn.LayoutOrder = pageIndex
		NewCorner(6, TabBtn)
		TabBtn.Parent = SidebarScroll

		local TabLbl = Instance.new("TextLabel")
		TabLbl.Text = PageTitle
		TabLbl.Font = Config.Font
		TabLbl.TextColor3 = (pageIndex == 0) and Config.TextPrimary or Config.TextSecondary
		TabLbl.TextSize = 12
		TabLbl.BackgroundTransparency = 1
		TabLbl.Size = UDim2.new(1, -10, 1, 0)
		TabLbl.Position = UDim2.new(0, 10, 0, 0)
		TabLbl.TextXAlignment = Enum.TextXAlignment.Left
		TabLbl.ZIndex = Level + 1
		TabLbl.Parent = TabBtn

		-- hover
		TabBtn.MouseEnter:Connect(function()
			if ActivePage ~= pageIndex then
				Tween(TabBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = Config.BG3}, TI_Fast)
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if ActivePage ~= pageIndex then
				Tween(TabBtn, {BackgroundTransparency = 1}, TI_Fast)
			end
		end)

		-- ── Content page
		local Page = NewScrollFrame("Page_"..PageTitle, ContentArea)
		Page.Visible = (pageIndex == 0)
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ZIndex = Level

		local PageList = NewListLayout(Page, Config.ElementPad)
		NewUIPadding(Page, 8, 8, 8, 8)

		PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			local h = PageList.AbsoluteContentSize.Y + 16
			Page.CanvasSize = UDim2.new(0, 0, 0, h)
		end)

		if pageIndex == 0 then
			ActivePage = 0
		end

		-- switch to this tab
		local function SelectTab()
			ActivePage = pageIndex

			-- hide all pages, show this one
			for _, child in ipairs(ContentArea:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					if child == Page then
						child.Visible = true
						child.Position = UDim2.new(0.05, 0, 0, 0)
						Tween(child, {Position = UDim2.new(0, 0, 0, 0)}, TI_Normal)
					else
						child.Visible = false
					end
				end
			end

			-- update sidebar tab styles
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

			-- slide indicator
			local absPos = TabBtn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y + SidebarScroll.CanvasPosition.Y
			Tween(PageIndicator, {
				Position = UDim2.new(0, 0, 0, absPos + 4),
				Size = UDim2.new(0, 3, 0, 20)
			}, TI_Back)
		end

		TabBtn.MouseButton1Click:Connect(function()
			Ripple(TabBtn)
			SelectTab()
		end)

		if pageIndex == 0 then
			SelectTab()
		end

		-- ── Page Library (elements)
		local PageLibrary = {}
		local ElementOrder = 0

		local function NextOrder()
			ElementOrder += 1
			return ElementOrder
		end

		-- ── SEPARATOR / SECTION LABEL
		function PageLibrary.AddSection(text)
			local container = NewFrame(text.."_Section", Page)
			container.Size = UDim2.new(1, 0, 0, 20)
			container.LayoutOrder = NextOrder()

			local line1 = Instance.new("Frame")
			line1.Size = UDim2.new(0.3, 0, 0, 1)
			line1.Position = UDim2.new(0, 0, 0.5, 0)
			line1.BackgroundColor3 = Config.Border
			line1.BorderSizePixel = 0
			line1.ZIndex = Level + 1
			line1.Parent = container

			local line2 = Instance.new("Frame")
			line2.Size = UDim2.new(0.3, 0, 0, 1)
			line2.Position = UDim2.new(0.7, 0, 0.5, 0)
			line2.BackgroundColor3 = Config.Border
			line2.BorderSizePixel = 0
			line2.ZIndex = Level + 1
			line2.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text:upper()
			lbl.Font = Config.Font
			lbl.TextColor3 = accentColor
			lbl.TextSize = 10
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.4, 0, 1, 0)
			lbl.Position = UDim2.new(0.3, 0, 0, 0)
			lbl.ZIndex = Level + 1
			lbl.Parent = container
		end

		-- ── BUTTON
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
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

			-- right arrow hint
			local arrow = Instance.new("TextLabel")
			arrow.Text = "›"
			arrow.Font = Config.Font
			arrow.TextColor3 = accentColor
			arrow.TextSize = 16
			arrow.BackgroundTransparency = 1
			arrow.Size = UDim2.new(0, 20, 1, 0)
			arrow.Position = UDim2.new(1, -22, 0, 0)
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
					Tween(arrow, {Position = UDim2.new(1, -22, 0, 0)}, TI_Normal)
				end)
			end)

			if tooltip then
				AddTooltip(btn, tooltip, ScreenGui)
			end
		end

		-- ── LABEL
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
			NewCorner(6, bg)
			bg.Parent = container

			local leftBar = Instance.new("Frame")
			leftBar.Size = UDim2.new(0, 3, 0.6, 0)
			leftBar.Position = UDim2.new(0, 0, 0.2, 0)
			leftBar.BackgroundColor3 = accentColor
			leftBar.BorderSizePixel = 0
			leftBar.ZIndex = Level + 2
			NewCorner(3, leftBar)
			leftBar.Parent = bg

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextSecondary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, -12, 1, 0)
			lbl.Position = UDim2.new(0, 8, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			return lbl
		end

		-- ── TOGGLE
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, -50, 1, 0)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			-- pill track
			local track = Instance.new("Frame")
			track.Size = UDim2.new(0, 32, 0, 16)
			track.Position = UDim2.new(1, -40, 0.5, -8)
			track.BackgroundColor3 = state and accentColor or Config.BG4
			track.BorderSizePixel = 0
			track.ZIndex = Level + 2
			NewCorner(999, track)
			track.Parent = bg

			-- pill knob
			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 12, 0, 12)
			knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
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
				Tween(knob, {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, TI_Back)
			end

			btn.MouseButton1Click:Connect(function()
				state = not state
				updateVisual()
				task.spawn(callback, state)
			end)

			AddHoverGlow(btn, bg, Config.BG4, Config.BG3)
			if tooltip then AddTooltip(btn, tooltip, ScreenGui) end

			-- expose set function
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

		-- ── SLIDER
		function PageLibrary.AddSlider(text, config, callback, tooltip)
			local cfg = config or {}
			local minVal = cfg.Min or cfg.min or 0
			local maxVal = cfg.Max or cfg.max or 100
			local defVal = cfg.Default or cfg.Def or cfg.def or minVal
			local step   = cfg.Step or cfg.step or 1
			local suffix = cfg.Suffix or ""

			if minVal > maxVal then minVal, maxVal = maxVal, minVal end
			defVal = math.clamp(defVal, minVal, maxVal)
			local current = defVal

			local container = Instance.new("Frame")
			container.Name = text.."_Slider"
			container.Size = UDim2.new(1, 0, 0, Config.ElementH + 10)
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 0, 16)
			lbl.Position = UDim2.new(0, 10, 0, 2)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local valLbl = Instance.new("TextLabel")
			valLbl.Text = tostring(defVal)..suffix
			valLbl.Font = Config.Font
			valLbl.TextColor3 = accentColor
			valLbl.TextSize = 12
			valLbl.BackgroundTransparency = 1
			valLbl.Size = UDim2.new(0.4, -10, 0, 16)
			valLbl.Position = UDim2.new(0.6, 0, 0, 2)
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.ZIndex = Level + 2
			valLbl.Parent = bg

			-- track
			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -20, 0, 4)
			track.Position = UDim2.new(0, 10, 1, -10)
			track.BackgroundColor3 = Config.BG4
			track.BorderSizePixel = 0
			track.ZIndex = Level + 2
			NewCorner(999, track)
			track.Parent = bg

			-- fill
			local defaultScale = (defVal - minVal) / (maxVal - minVal)
			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(defaultScale, 0, 1, 0)
			fill.BackgroundColor3 = accentColor
			fill.BorderSizePixel = 0
			fill.ZIndex = Level + 3
			NewCorner(999, fill)
			fill.Parent = track

			-- knob
			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 12, 0, 12)
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
					Tween(knob, {Size = UDim2.new(0, 16, 0, 16)}, TI_Fast)
					local _, _, xs, _ = GetXY(track)
					updateSlider(xs)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if sliding then
					if input.UserInputType == Enum.UserInputType.MouseMovement or
					   input.UserInputType == Enum.UserInputType.Touch then
						local _, _, xs, _ = GetXY(track)
						updateSlider(xs)
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or
				   input.UserInputType == Enum.UserInputType.Touch then
					if sliding then
						sliding = false
						Tween(knob, {Size = UDim2.new(0, 12, 0, 12)}, TI_Back)
					end
				end
			end)

			AddHoverGlow(sliderBtn, bg, Config.BG4, Config.BG3)
			if tooltip then AddTooltip(sliderBtn, tooltip, ScreenGui) end

			return {
				Set = function(_, val)
					local sc = (val - minVal) / (maxVal - minVal)
					updateSlider(sc)
				end,
				Get = function() return current end
			}
		end

		-- ── DROPDOWN
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
			bg.ClipsDescendants = true
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.5, 0, 0, Config.ElementH)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local selLbl = Instance.new("TextLabel")
			selLbl.Text = selected
			selLbl.Font = Config.Font
			selLbl.TextColor3 = accentColor
			selLbl.TextSize = 12
			selLbl.BackgroundTransparency = 1
			selLbl.Size = UDim2.new(0.5, -36, 0, Config.ElementH)
			selLbl.Position = UDim2.new(0.5, 0, 0, 0)
			selLbl.TextXAlignment = Enum.TextXAlignment.Right
			selLbl.ZIndex = Level + 2
			selLbl.Parent = bg

			-- chevron
			local chevron = Instance.new("TextLabel")
			chevron.Text = "›"
			chevron.Font = Config.Font
			chevron.TextColor3 = Config.TextSecondary
			chevron.TextSize = 16
			chevron.BackgroundTransparency = 1
			chevron.Size = UDim2.new(0, 20, 0, Config.ElementH)
			chevron.Position = UDim2.new(1, -22, 0, 0)
			chevron.Rotation = 90
			chevron.ZIndex = Level + 2
			chevron.Parent = bg

			-- options frame
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
					Tween(chevron, {Rotation = 90}, TI_Back)
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
				Tween(chevron, {Rotation = open and 270 or 90}, TI_Back)
			end)

			AddHoverGlow(headerBtn, bg, Config.BG4, Config.BG3)
			if tooltip then AddTooltip(headerBtn, tooltip, ScreenGui) end

			return {
				Set = function(_, val)
					selected = val
					selLbl.Text = val
				end,
				Get = function() return selected end,
				Refresh = function(_, newOpts)
					-- rebuild options
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
							Tween(chevron, {Rotation = 90}, TI_Back)
							task.spawn(callback, opt)
						end)
					end
				end
			}
		end

		-- ── TEXT INPUT
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
			NewCorner(6, bg)
			local stroke = NewStroke(Config.Border, 1, bg, 0.6)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextSecondary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.4, 0, 1, 0)
			lbl.Position = UDim2.new(0, 10, 0, 0)
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
			box.Size = UDim2.new(0.6, -10, 1, 0)
			box.Position = UDim2.new(0.4, 0, 0, 0)
			box.TextXAlignment = Enum.TextXAlignment.Left
			box.ZIndex = Level + 2
			box.ClearTextOnFocus = false
			box.Parent = bg

			box.Focused:Connect(function()
				Tween(stroke, {Color = accentColor, Transparency = 0}, TI_Fast)
			end)
			box.FocusLost:Connect(function(enter)
				Tween(stroke, {Color = Config.Border, Transparency = 0.6}, TI_Fast)
				if enter then
					task.spawn(callback, box.Text)
				end
			end)

			if tooltip then AddTooltip(box, tooltip, ScreenGui) end

			return {
				Set = function(_, val) box.Text = val end,
				Get = function() return box.Text end,
			}
		end

		-- ── KEYBIND
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 1, 0)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local keyPill = Instance.new("Frame")
			keyPill.Size = UDim2.new(0, 60, 0, 16)
			keyPill.Position = UDim2.new(1, -68, 0.5, -8)
			keyPill.BackgroundColor3 = Config.BG4
			keyPill.BorderSizePixel = 0
			keyPill.ZIndex = Level + 2
			NewCorner(4, keyPill)
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
			if tooltip then AddTooltip(keyBtn, tooltip, ScreenGui) end

			return {
				Get = function() return key end
			}
		end

		-- ── COLOUR PICKER
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
			NewCorner(6, bg)
			NewStroke(Config.Border, 1, bg, 0.6)
			bg.Parent = container

			local lbl = Instance.new("TextLabel")
			lbl.Text = text
			lbl.Font = Config.FontLight
			lbl.TextColor3 = Config.TextPrimary
			lbl.TextSize = 12
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0.6, 0, 0, Config.ElementH)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = Level + 2
			lbl.Parent = bg

			local preview = Instance.new("Frame")
			preview.Size = UDim2.new(0, 20, 0, 14)
			preview.Position = UDim2.new(1, -28, 0.5, -7)
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

			local expandH = Config.ElementH + 78

			-- RGB sliders inside
			local colorFrame = Instance.new("Frame")
			colorFrame.Size = UDim2.new(1, 0, 0, 78)
			colorFrame.Position = UDim2.new(0, 0, 0, Config.ElementH)
			colorFrame.BackgroundTransparency = 1
			colorFrame.BorderSizePixel = 0
			colorFrame.ZIndex = Level + 2
			colorFrame.Parent = bg

			local colorList = NewListLayout(colorFrame, 2)
			NewUIPadding(colorFrame, 2, 2, 4, 4)

			local function makeChannelSlider(ch, defVal, onChanged)
				local sf = Instance.new("Frame")
				sf.Size = UDim2.new(1, 0, 0, 20)
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
				slbl.Size = UDim2.new(0, 14, 1, 0)
				slbl.ZIndex = Level + 4
				slbl.Parent = sf

				local track = Instance.new("Frame")
				track.Size = UDim2.new(1, -40, 0, 4)
				track.Position = UDim2.new(0, 16, 0.5, -2)
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
				valDisplay.Size = UDim2.new(0, 24, 1, 0)
				valDisplay.Position = UDim2.new(1, -24, 0, 0)
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
						local _, _, xs, _ = GetXY(track)
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
							local _, _, xs, _ = GetXY(track)
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
			if tooltip then AddTooltip(previewBtn, tooltip, ScreenGui) end

			return {
				Get = function() return col end,
				Set = function(_, newCol)
					col = newCol
					Tween(preview, {BackgroundColor3 = col}, TI_Fast)
				end
			}
		end

		-- ── SEARCH BAR (auto-added at top of each page)
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
			NewCorner(6, searchBg)
			local searchStroke = NewStroke(Config.Border, 1, searchBg, 0.6)
			searchBg.Parent = searchContainer

			local searchIcon = Instance.new("TextLabel")
			searchIcon.Text = "🔍"
			searchIcon.TextSize = 10
			searchIcon.Font = Config.FontLight
			searchIcon.BackgroundTransparency = 1
			searchIcon.Size = UDim2.new(0, 20, 1, 0)
			searchIcon.Position = UDim2.new(0, 4, 0, 0)
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
			searchBox.Size = UDim2.new(1, -28, 1, 0)
			searchBox.Position = UDim2.new(0, 24, 0, 0)
			searchBox.TextXAlignment = Enum.TextXAlignment.Left
			searchBox.ZIndex = Level + 2
			searchBox.ClearTextOnFocus = false
			searchBox.Parent = searchBg

			searchBox.Focused:Connect(function()
				Tween(searchStroke, {Color = accentColor, Transparency = 0}, TI_Fast)
			end)
			searchBox.FocusLost:Connect(function()
				Tween(searchStroke, {Color = Config.Border, Transparency = 0.6}, TI_Fast)
			end)

			searchBox:GetPropertyChangedSignal("Text"):Connect(function()
				local query = searchBox.Text:lower()
				for _, el in ipairs(Page:GetChildren()) do
					if el:IsA("Frame") and el.Name ~= "SearchBar" then
						if query == "" then
							el.Visible = true
						else
							el.Visible = el.Name:lower():find(query, 1, true) ~= nil
						end
					end
				end
			end)
		end

		return PageLibrary
	end

	-- expose Notify
	TabLibrary.Notify = Notify

	-- open animation
	ContainerFrame.Size = UDim2.new(0, Config.WindowW * 0.8, 0, Config.WindowH * 0.8)
	ContainerFrame.Position = UDim2.new(0.5, -(Config.WindowW * 0.8) / 2, 0.5, -(Config.WindowH * 0.8) / 2)
	MainFrame.BackgroundTransparency = 1
	Tween(ContainerFrame, {
		Size = UDim2.new(0, Config.WindowW, 0, Config.WindowH),
		Position = UDim2.new(0.5, -Config.WindowW / 2, 0.5, -Config.WindowH / 2)
	}, TI_Back)
	Tween(MainFrame, {BackgroundTransparency = 0}, TI_Normal)

	return TabLibrary
end

return UILibrary


-- ═══════════════════════════════════════════
-- USAGE EXAMPLE:
-- ═══════════════════════════════════════════
--[[
local UI = require(script.UILibrary_Enhanced)

local Window = UI.Load("My Script", {
	AccentColor = Color3.fromRGB(120, 90, 255)
})

local MainTab = Window.AddPage("Main")
MainTab.AddSection("General")
MainTab.AddButton("Say Hello", function()
	print("Hello!")
	Window.Notify("Success", "Button clicked!", "success")
end, "Click me to print hello")

MainTab.AddToggle("ESP", false, function(val)
	print("ESP:", val)
end)

local slider = MainTab.AddSlider("Walk Speed", {Min=16, Max=100, Default=16, Suffix=" stud/s"}, function(val)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

local dropdown = MainTab.AddDropdown("Team", {"Red", "Blue", "Green"}, function(val)
	print("Team:", val)
end)

MainTab.AddColorPicker("Name Colour", Color3.fromRGB(255,100,100), function(col)
	print(col)
end)

MainTab.AddTextInput("Username", "Enter name...", function(val)
	print("Username:", val)
end)

MainTab.AddKeybind("Toggle GUI", Enum.KeyCode.RightShift, function(key)
	print("Keybind set to:", key.Name)
end)

local SettingsTab = Window.AddPage("Settings")
SettingsTab.AddSection("Performance")
SettingsTab.AddToggle("FPS Boost", false, function(val)
	print("FPS Boost:", val)
end)
]]
