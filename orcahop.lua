--[[
    uiogunio / orca  «broockhaven»
    Custom UI (no external library) - Mars theme
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local RS           = game:GetService("ReplicatedStorage")
local LP           = Players.LocalPlayer

local HUB_NAME = "uiogunio / orca  «broockhaven🏡RB»"

------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------
local function New(class, props, children)
	local o = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else o[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = o end
	if parent then o.Parent = parent end
	return o
end

local function Corner(p, r) return New("UICorner", {CornerRadius = UDim.new(0, r), Parent = p}) end
local function Tw(o, t, props, style, dir)
	local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local C = {
	bg    = Color3.fromRGB(13, 9, 14),
	panel = Color3.fromRGB(22, 15, 24),
	card  = Color3.fromRGB(32, 22, 34),
	line  = Color3.fromRGB(70, 42, 50),
	text  = Color3.fromRGB(244, 236, 238),
	sub   = Color3.fromRGB(165, 148, 158),
	mars  = Color3.fromRGB(255, 98, 48),
	mars2 = Color3.fromRGB(255, 170, 70),
	off   = Color3.fromRGB(58, 44, 58),
	white = Color3.new(1, 1, 1),
}

local function rainbow()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 70, 70)),
		ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 170, 50)),
		ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255, 60, 200)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 200, 255)),
		ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 70, 70)),
	})
end

local function Label(props)
	props.BackgroundTransparency = 1
	props.Font = props.Font or Enum.Font.GothamMedium
	props.TextColor3 = props.TextColor3 or C.text
	props.TextSize = props.TextSize or 13
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	return New("TextLabel", props)
end

local spinners, hueTexts, conns = {}, {}, {}

------------------------------------------------------------------
-- Drawn icons (built from shapes, no emojis)
------------------------------------------------------------------
local TextService = game:GetService("TextService")

local function Icon(name, parent, size, color)
	color = color or C.text
	local root = New("Frame", {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = parent})
	local u = size / 24

	local function R(x, y, w, h, rot, r, col, ox, oy)
		local f = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset((x + (ox or 0)) * u, (y + (oy or 0)) * u),
			Size = UDim2.fromOffset(w * u, h * u), BackgroundColor3 = col or color, BorderSizePixel = 0,
			Rotation = rot or 0, Parent = root,
		})
		if r and r > 0 then Corner(f, r * u) end
		return f
	end
	local function O(x, y, d, col, ox, oy) return R(x, y, d, d, 0, d / 2, col, ox, oy) end
	local function Box(x, y, w, h, r, th, col, ox, oy, rot)
		local f = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset((x + (ox or 0)) * u, (y + (oy or 0)) * u),
			Size = UDim2.fromOffset(w * u, h * u), BackgroundTransparency = 1, Rotation = rot or 0, Parent = root,
		})
		if r and r > 0 then Corner(f, r * u) end
		New("UIStroke", {Color = col or color, Thickness = math.max(1, th * u), Parent = f})
		return f
	end
	local function Ring(x, y, d, th, col, ox, oy) return Box(x, y, d, d, d / 2, th, col, ox, oy) end

	if name == "crown" then
		R(12, 19, 16, 4, 0, 1)
		R(12, 15, 12.5, 4)
		R(5.5, 12.5, 6, 6, 45, 1)
		R(12, 10, 7.5, 7.5, 45, 1)
		R(18.5, 12.5, 6, 6, 45, 1)
		O(5.5, 7.8, 3)
		O(12, 4.4, 3.4)
		O(18.5, 7.8, 3)
	elseif name == "hat" then
		R(12, 11, 10, 12, 0, 2.5)
		R(12, 18.5, 20, 3.2, 0, 1.6)
		R(12, 15, 10.2, 2, 0, 0, Color3.fromRGB(14, 8, 14))
	elseif name == "people" then
		O(8.5, 8, 5.5)
		R(8.5, 17, 10, 7, 0, 3.5)
		O(17, 9, 4.6)
		R(17, 17, 8, 6.4, 0, 3.2)
	elseif name == "pill" then
		Box(12, 12, 19, 8, 4, 1.8, nil, 0, 0, -45)
		R(12, 12, 1.8, 8, -45)
	elseif name == "user" then
		O(12, 8, 7.5)
		R(12, 18.5, 15, 8, 0, 4)
	elseif name == "film" then
		Box(12, 12, 18, 14, 2.2, 1.8)
		R(12, 12, 7, 6, 0, 1)
		for _, yy in ipairs({8, 12, 16}) do
			O(6.5, yy, 2)
			O(17.5, yy, 2)
		end
	elseif name == "music" then
		O(7.5, 18.5, 6)
		O(16.5, 16.5, 6)
		R(10.1, 11, 1.8, 14, 0, 0.9)
		R(19.1, 9, 1.8, 14, 0, 0.9)
		R(14.6, 3.9, 11, 3, -9, 1)
	elseif name == "sliders" then
		R(12, 6, 19, 2, 0, 1)
		O(8.5, 6, 4.8)
		R(12, 12, 19, 2, 0, 1)
		O(16, 12, 4.8)
		R(12, 18, 19, 2, 0, 1)
		O(10.5, 18, 4.8)
	elseif name == "trophy" then
		R(12, 9.5, 10, 11, 0, 3)
		R(12, 5.5, 10, 3)
		Ring(4.8, 9, 5, 1.5)
		Ring(19.2, 9, 5, 1.5)
		R(12, 17.6, 2.4, 4)
		R(12, 20.8, 9, 2.4, 0, 1.2)
	elseif name == "phone" then
		Box(12, 12, 11, 19, 2.8, 1.9)
		O(12, 18, 1.8)
		R(12, 6.5, 4, 1.2, 0, 0.6)
	elseif name == "tiktok" then
		local function tt(col, ox, oy)
			R(14.6, 10.5, 3.2, 14, 0, 1.6, col, ox, oy)
			Ring(10.4, 16.8, 7, 2.8, col, ox, oy)
			R(18.2, 5.2, 6, 3.2, 35, 1.6, col, ox, oy)
			R(20.4, 8.2, 3.2, 3.6, 0, 1.6, col, ox, oy)
		end
		tt(Color3.fromRGB(37, 244, 238), -0.9, -0.9)
		tt(Color3.fromRGB(254, 44, 85), 0.9, 0.9)
		tt(Color3.new(1, 1, 1), 0, 0)
	elseif name == "scissors" then
		R(11.2, 10, 1.9, 16, 28, 0.9)
		R(12.8, 10, 1.9, 16, -28, 0.9)
		Ring(7, 19, 6, 1.8)
		Ring(17, 19, 6, 1.8)
	elseif name == "pin" then
		Ring(12, 9, 13, 2.4)
		O(12, 9, 4.4)
		R(9.25, 17.5, 2.4, 9.7, -34.5, 1.2)
		R(14.75, 17.5, 2.4, 9.7, 34.5, 1.2)
	elseif name == "eye" then
		Box(12, 12, 20, 11, 5.5, 1.8)
		O(12, 12, 6)
	elseif name == "house" then
		R(12, 16, 13, 9, 0, 1.5)
		R(12, 9.5, 12, 12, 45, 1.5)
		R(12, 18.5, 3.4, 6, 0, 0.8, Color3.fromRGB(14, 8, 14))
	elseif name == "x" then
		R(12, 12, 16, 3, 45, 1.5)
		R(12, 12, 16, 3, -45, 1.5)
	elseif name == "chev" then
		R(12, 8, 12, 3, 45, 1.5)
		R(12, 16, 12, 3, -45, 1.5)
	elseif name == "warn" then
		Ring(12, 12, 17, 2)
		R(12, 9.5, 2.4, 7, 0, 1.2)
		O(12, 16.5, 2.6)
	end
	return root
end

local function recolor(root, col)
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("Frame") and d.BackgroundTransparency < 1 then
			d.BackgroundColor3 = col
		elseif d:IsA("UIStroke") then
			d.Color = col
		end
	end
end

------------------------------------------------------------------
-- GUI root (re-execute safe)
------------------------------------------------------------------
local function getRoot()
	local ok, g = pcall(function() return gethui and gethui() end)
	if ok and g then return g end
	local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and cg then return cg end
	return LP:WaitForChild("PlayerGui")
end
local Root = getRoot()
if Root:FindFirstChild("OrcaHubUI") then Root.OrcaHubUI:Destroy() end

local Gui = New("ScreenGui", {
	Name = "OrcaHubUI", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
})
pcall(function() if syn and syn.protect_gui then syn.protect_gui(Gui) end end)
Gui.Parent = Root
Gui.Destroying:Connect(function() for _, c in ipairs(conns) do c:Disconnect() end end)

------------------------------------------------------------------
-- Notifications
------------------------------------------------------------------
local NotifHolder = New("Frame", {
	Size = UDim2.new(0, 270, 1, -20), Position = UDim2.new(1, -10, 0, 10),
	AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Parent = Gui,
}, {
	New("UIListLayout", {
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	}),
})

local function Notify(title, content, color, icon, fancy)
	color = color or C.mars
	local wrap = New("Frame", {Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, Parent = NotifHolder})
	local card = New("Frame", {
		Size = UDim2.fromScale(1, 1), Position = UDim2.new(1, 300, 0, 0),
		BackgroundColor3 = C.panel, Parent = wrap,
	})
	Corner(card, 10)
	local stroke = New("UIStroke", {
		Color = fancy and C.white or color, Thickness = fancy and 2 or 1.5, Transparency = 0.15, Parent = card,
	})
	if fancy then
		local g = New("UIGradient", {Color = rainbow(), Parent = stroke})
		spinners[g] = 150
	end
	local tx = 22
	if icon then
		local ic = Icon(icon, card, 26, color)
		ic.Position = UDim2.fromOffset(12, 16)
		tx = 50
	else
		local bar = New("Frame", {
			Size = UDim2.new(0, 4, 1, -16), Position = UDim2.fromOffset(8, 8),
			BackgroundColor3 = color, BorderSizePixel = 0, Parent = card,
		})
		Corner(bar, 2)
	end
	Label({Text = title, Font = Enum.Font.GothamBold, TextSize = 13, Size = UDim2.new(1, -(tx + 6), 0, 20),
		Position = UDim2.fromOffset(tx, 6), Parent = card})
	Label({Text = content, TextSize = 12, TextColor3 = C.sub, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, -(tx + 6), 0, 28), Position = UDim2.fromOffset(tx, 26), Parent = card})
	Tw(card, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)
	task.delay(3, function()
		Tw(card, 0.3, {Position = UDim2.new(1, 300, 0, 0)})
		task.wait(0.35)
		wrap:Destroy()
	end)
end

------------------------------------------------------------------
-- Main window
------------------------------------------------------------------
local function baseScale()
	local cam = workspace.CurrentCamera
	local v = cam and cam.ViewportSize or Vector2.new(1280, 720)
	return math.clamp(math.min(v.X / 620, v.Y / 420), 0.55, 1)
end

local Main = New("Frame", {
	Name = "Main", Size = UDim2.fromOffset(560, 360), Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg, ClipsDescendants = true,
	Visible = false, Parent = Gui,
})
Corner(Main, 16)
local MainScale = New("UIScale", {Scale = 0, Parent = Main})
local isOpen = false
New("UIGradient", {
	Color = ColorSequence.new(Color3.fromRGB(24, 11, 15), Color3.fromRGB(10, 8, 20)),
	Rotation = 60, Parent = Main,
})
do
	local s = New("UIStroke", {Thickness = 2.2, Color = C.white, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Main})
	local g = New("UIGradient", {Color = rainbow(), Parent = s})
	spinners[g] = 70
end

local Decor = New("Frame", {
	Size = UDim2.fromOffset(240, 240), Position = UDim2.new(1, -130, 1, -130),
	BackgroundColor3 = C.white, BackgroundTransparency = 0.82, BorderSizePixel = 0, Parent = Main,
})
Corner(Decor, 120)
New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 130, 70), Color3.fromRGB(110, 25, 30)), Rotation = 40, Parent = Decor})

local stars = {}
for i = 1, 18 do
	local sz = math.random(2, 3)
	local st = New("Frame", {
		Size = UDim2.fromOffset(sz, sz), BackgroundColor3 = C.white, BorderSizePixel = 0,
		Position = UDim2.fromScale(math.random(), math.random()), Parent = Main,
	})
	Corner(st, 2)
	stars[i] = {f = st, sp = 0.6 + math.random() * 1.6, ph = math.random() * 6}
end

local TopBar = New("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Parent = Main})
local Title = Label({
	Text = HUB_NAME, Font = Enum.Font.GothamBlack, TextSize = 15,
	Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(46, 0), Parent = TopBar,
})
do
	local hi = Icon("house", TopBar, 24, C.mars2)
	hi.Position = UDim2.fromOffset(16, 11)
end
hueTexts[Title] = 0
local CloseBtn = New("TextButton", {
	Text = "", Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, -42, 0, 7),
	BackgroundColor3 = Color3.fromRGB(215, 40, 55), AutoButtonColor = false, Parent = TopBar,
})
Corner(CloseBtn, 10)
New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 90, 100), Color3.fromRGB(170, 18, 40)), Rotation = 90, Parent = CloseBtn})
local CloseStroke = New("UIStroke", {Color = Color3.fromRGB(255, 70, 80), Thickness = 1.5, Transparency = 0.35, Parent = CloseBtn})
local CloseX = Icon("x", CloseBtn, 18, C.white)
CloseX.AnchorPoint = Vector2.new(0.5, 0.5)
CloseX.Position = UDim2.fromScale(0.5, 0.5)
CloseBtn.MouseEnter:Connect(function()
	Tw(CloseX, 0.25, {Rotation = 90}, Enum.EasingStyle.Back)
	Tw(CloseStroke, 0.15, {Transparency = 0, Thickness = 2.5})
end)
CloseBtn.MouseLeave:Connect(function()
	Tw(CloseX, 0.25, {Rotation = 0}, Enum.EasingStyle.Back)
	Tw(CloseStroke, 0.15, {Transparency = 0.35, Thickness = 1.5})
end)
local Divider = New("Frame", {
	Size = UDim2.new(1, -24, 0, 2), Position = UDim2.fromOffset(12, 46),
	BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = Main,
})
New("UIGradient", {Color = rainbow(), Parent = Divider})

local Sidebar = New("ScrollingFrame", {
	Size = UDim2.fromOffset(142, 296), Position = UDim2.fromOffset(10, 54),
	BackgroundColor3 = C.panel, BackgroundTransparency = 0.2, BorderSizePixel = 0,
	ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = Main,
}, {
	New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
	New("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingBottom = UDim.new(0, 8)}),
})
Corner(Sidebar, 12)

local Content = New("Frame", {
	Size = UDim2.fromOffset(388, 296), Position = UDim2.fromOffset(162, 54),
	BackgroundColor3 = C.panel, BackgroundTransparency = 0.2, ClipsDescendants = true, Parent = Main,
})
Corner(Content, 12)

------------------------------------------------------------------
-- Tab system
------------------------------------------------------------------
local allTabs = {}
local tabOrder = 0

local function SelectTab(t)
	for _, o in ipairs(allTabs) do
		local on = (o == t)
		o.page.Visible = on
		Tw(o.btn, 0.2, {BackgroundTransparency = on and 0 or 1, BackgroundColor3 = on and Color3.fromRGB(70, 30, 28) or C.card})
		Tw(o.bar, 0.2, {BackgroundTransparency = on and 0 or 1})
		o.label.TextColor3 = on and C.text or C.sub
		recolor(o.icon, on and C.mars2 or C.sub)
	end
	t.page.Position = UDim2.fromOffset(0, 14)
	Tw(t.page, 0.3, {Position = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Quint)
end

local function CreateTab(name, icon)
	tabOrder += 1
	local tab = {}
	local btn = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.card, BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, LayoutOrder = tabOrder, Parent = Sidebar,
	})
	Corner(btn, 9)
	local tabIcon = Icon(icon, btn, 18, C.sub)
	tabIcon.Position = UDim2.fromOffset(11, 8)
	local tabLabel = Label({Text = name, TextSize = 13, TextColor3 = C.sub, Size = UDim2.new(1, -40, 1, 0),
		Position = UDim2.fromOffset(36, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn})
	local bar = New("Frame", {
		Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 0, 0.2, 0),
		BackgroundColor3 = C.mars, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = btn,
	})
	Corner(bar, 2)

	local page = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
		ScrollBarThickness = 3, ScrollBarImageColor3 = C.mars, AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(), Parent = Content,
	}, {
		New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
		New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 10)}),
	})

	tab.btn, tab.bar, tab.page, tab.icon, tab.label = btn, bar, page, tabIcon, tabLabel
	table.insert(allTabs, tab)
	btn.MouseButton1Click:Connect(function() SelectTab(tab) end)

	local order = 0
	local function nextOrder() order += 1 return order end

	function tab:Paragraph(title, text)
		local f = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = C.card, LayoutOrder = nextOrder(), Parent = page,
		}, {
			New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}),
			New("UIPadding", {PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, 9), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}),
		})
		Corner(f, 9)
		New("UIStroke", {Color = C.line, Thickness = 1, Parent = f})
		Label({Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.mars2,
			Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1, Parent = f})
		Label({Text = text, TextSize = 12, TextColor3 = C.sub, TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = f})
		return f
	end

	function tab:Button(name, cb)
		local b = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.card, Text = "", AutoButtonColor = false,
			LayoutOrder = nextOrder(), Parent = page,
		})
		Corner(b, 9)
		local st = New("UIStroke", {Color = C.line, Thickness = 1, Parent = b})
		Label({Text = name, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(14, 0),
			TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
		local chv = Icon("chev", b, 14, C.mars)
		chv.Position = UDim2.new(1, -28, 0.5, -7)
		b.MouseEnter:Connect(function() Tw(st, 0.15, {Color = C.mars}) Tw(b, 0.15, {BackgroundColor3 = Color3.fromRGB(44, 28, 38)}) end)
		b.MouseLeave:Connect(function() Tw(st, 0.15, {Color = C.line}) Tw(b, 0.15, {BackgroundColor3 = C.card}) end)
		b.MouseButton1Click:Connect(function()
			Tw(b, 0.08, {BackgroundColor3 = C.mars})
			task.delay(0.1, function() Tw(b, 0.2, {BackgroundColor3 = C.card}) end)
			task.spawn(pcall, cb)
		end)
		return b
	end

	function tab:Toggle(name, default, cb)
		local state = default and true or false
		local f = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.card, Text = "", AutoButtonColor = false,
			LayoutOrder = nextOrder(), Parent = page,
		})
		Corner(f, 9)
		New("UIStroke", {Color = C.line, Thickness = 1, Parent = f})
		Label({Text = name, Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(14, 0), Parent = f})
		local track = New("Frame", {
			Size = UDim2.fromOffset(42, 22), Position = UDim2.new(1, -54, 0.5, -11),
			BackgroundColor3 = state and C.mars or C.off, Parent = f,
		})
		Corner(track, 11)
		local knob = New("Frame", {
			Size = UDim2.fromOffset(16, 16), Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
			BackgroundColor3 = C.white, Parent = track,
		})
		Corner(knob, 8)
		f.MouseButton1Click:Connect(function()
			state = not state
			Tw(track, 0.2, {BackgroundColor3 = state and C.mars or C.off})
			Tw(knob, 0.2, {Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)}, Enum.EasingStyle.Back)
			task.spawn(pcall, cb, state)
		end)
		return f
	end

	function tab:Input(name, numeric, cb)
		local f = New("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.card, LayoutOrder = nextOrder(), Parent = page})
		Corner(f, 9)
		local st = New("UIStroke", {Color = C.line, Thickness = 1, Parent = f})
		Label({Text = name, Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.fromOffset(14, 0), Parent = f})
		local tb = New("TextBox", {
			Size = UDim2.new(0.5, -14, 0, 26), Position = UDim2.new(0.5, 0, 0.5, -13),
			BackgroundColor3 = C.bg, Text = "", PlaceholderText = "type + enter", PlaceholderColor3 = C.sub,
			TextColor3 = C.text, Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, Parent = f,
		})
		Corner(tb, 7)
		tb.Focused:Connect(function() Tw(st, 0.15, {Color = C.mars}) end)
		if numeric then
			tb:GetPropertyChangedSignal("Text"):Connect(function()
				local clean = (tb.Text:gsub("%D", ""))
				if clean ~= tb.Text then tb.Text = clean end
			end)
		end
		tb.FocusLost:Connect(function(enter)
			Tw(st, 0.15, {Color = C.line})
			if enter then task.spawn(pcall, cb, tb.Text) end
		end)
		return f, tb
	end

	function tab:Slider(name, min, max, default, cb, step)
		step = step or 1
		local f = New("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = C.card, LayoutOrder = nextOrder(), Parent = page})
		Corner(f, 9)
		New("UIStroke", {Color = C.line, Thickness = 1, Parent = f})
		Label({Text = name, Size = UDim2.new(1, -100, 0, 24), Position = UDim2.fromOffset(14, 4), Parent = f})
		local val = Label({
			Text = tostring(default), Font = Enum.Font.GothamBold, TextColor3 = C.mars2, TextXAlignment = Enum.TextXAlignment.Right,
			Size = UDim2.fromOffset(80, 24), Position = UDim2.new(1, -94, 0, 4), Parent = f,
		})
		local track = New("Frame", {
			Size = UDim2.new(1, -28, 0, 6), Position = UDim2.fromOffset(14, 38), BackgroundColor3 = C.off, BorderSizePixel = 0, Parent = f,
		})
		Corner(track, 3)
		local rel = (default - min) / (max - min)
		local fill = New("Frame", {Size = UDim2.fromScale(rel, 1), BackgroundColor3 = C.mars, BorderSizePixel = 0, Parent = track})
		Corner(fill, 3)
		local knob = New("Frame", {
			Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(rel, 0, 0.5, 0),
			BackgroundColor3 = C.white, Parent = track,
		})
		Corner(knob, 7)
		local hit = New("TextButton", {
			Size = UDim2.new(1, -14, 0, 28), Position = UDim2.fromOffset(7, 27), BackgroundTransparency = 1, Text = "", Parent = f,
		})
		local dragging = false
		local function setFromX(x)
			local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local v = min + (max - min) * r
			v = math.floor(v / step + 0.5) * step
			v = math.clamp(v, min, max)
			v = math.floor(v * 100 + 0.5) / 100
			local rr = (v - min) / (max - min)
			fill.Size = UDim2.fromScale(rr, 1)
			knob.Position = UDim2.new(rr, 0, 0.5, 0)
			val.Text = tostring(v)
			task.spawn(pcall, cb, v)
		end
		local function setValue(v)
			v = math.clamp(v, min, max)
			local rr = (v - min) / (max - min)
			fill.Size = UDim2.fromScale(rr, 1)
			knob.Position = UDim2.new(rr, 0, 0.5, 0)
			val.Text = tostring(v)
			task.spawn(pcall, cb, v)
		end
		hit.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				page.ScrollingEnabled = false
				setFromX(i.Position.X)
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then
						dragging = false
						page.ScrollingEnabled = true
					end
				end)
			end
		end)
		table.insert(conns, UIS.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				setFromX(i.Position.X)
			end
		end))
		return f, setValue
	end

	function tab:Card(height)
		local f = New("Frame", {Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = C.card, LayoutOrder = nextOrder(), Parent = page})
		Corner(f, 10)
		New("UIStroke", {Color = C.line, Thickness = 1, Parent = f})
		return f
	end

	function tab:SmallButton(name, color, cb)
		local b = New("TextButton", {
			Size = UDim2.fromOffset(92, 30), BackgroundColor3 = color, Text = name, Font = Enum.Font.GothamBlack,
			TextSize = 13, TextColor3 = C.white, AutoButtonColor = false, LayoutOrder = nextOrder(), Parent = page,
		})
		Corner(b, 9)
		b.MouseButton1Click:Connect(function()
			Tw(b, 0.08, {Size = UDim2.fromOffset(86, 27)})
			task.delay(0.1, function() Tw(b, 0.2, {Size = UDim2.fromOffset(92, 30)}, Enum.EasingStyle.Back) end)
			task.spawn(pcall, cb)
		end)
		return b
	end

	function tab:Header(text, small)
		local f = New("Frame", {Size = UDim2.new(1, 0, 0, small and 20 or 28), BackgroundTransparency = 1, LayoutOrder = nextOrder(), Parent = page})
		Label({
			Text = text, Font = small and Enum.Font.GothamBold or Enum.Font.GothamBlack, TextSize = small and 11 or 14,
			TextColor3 = small and C.sub or C.mars2, Size = UDim2.new(1, 0, 0, small and 16 or 22), Parent = f,
		})
		local line = New("Frame", {
			Size = UDim2.new(1, 0, 0, small and 1 or 2), Position = UDim2.new(0, 0, 1, small and -2 or -3),
			BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = f,
		})
		New("UIGradient", {Color = rainbow(), Parent = line})
		return f
	end

	function tab:Rainbow(name, cb, opts)
		opts = opts or {}
		local h = opts.height or 46
		local ts = opts.textSize or 16
		local b = New("TextButton", {
			Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			LayoutOrder = nextOrder(), Parent = page,
		})
		local bg = New("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = b})
		Corner(bg, 12)
		local g = New("UIGradient", {Color = rainbow(), Parent = bg})
		spinners[g] = 110
		Label({
			Text = name, Font = Enum.Font.GothamBlack, TextSize = ts, TextXAlignment = Enum.TextXAlignment.Center,
			TextStrokeTransparency = 0.35, TextStrokeColor3 = Color3.new(0, 0, 0), ZIndex = 2,
			Size = UDim2.fromScale(1, 1), Position = opts.icon and UDim2.fromOffset(16, 0) or UDim2.new(), Parent = b,
		})
		if opts.icon then
			local w = TextService:GetTextSize(name, ts, Enum.Font.GothamBlack, Vector2.new(400, 100)).X
			local ic = Icon(opts.icon, b, opts.iconSize or 26, Color3.fromRGB(16, 9, 16))
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0.5, -w / 2 - (opts.iconSize or 26) / 2 - 8, 0.5, 0)
			ic.ZIndex = 2
		end
		b.MouseButton1Click:Connect(function()
			Tw(b, 0.08, {Size = UDim2.new(1, -8, 0, h - 4)})
			task.delay(0.1, function() Tw(b, 0.2, {Size = UDim2.new(1, 0, 0, h)}, Enum.EasingStyle.Back) end)
			task.spawn(pcall, cb)
		end)
		return b
	end

	function tab:ColorToggle(name, cb, icon)
		local GREEN, RED = Color3.fromRGB(46, 190, 100), Color3.fromRGB(225, 50, 60)
		local state = false
		local b = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = GREEN, Text = "", AutoButtonColor = false,
			LayoutOrder = nextOrder(), Parent = page,
		})
		Corner(b, 12)
		New("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 190)), Rotation = 90, Parent = b})
		local st = New("UIStroke", {Color = GREEN, Thickness = 2, Transparency = 0.25, Parent = b})
		local left = 16
		if icon then
			local ic = Icon(icon, b, 28, C.white)
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0, 14, 0.5, 0)
			left = 54
		end
		Label({
			Text = name, Font = Enum.Font.GothamBlack, TextSize = 16, TextStrokeTransparency = 0.6,
			Size = UDim2.new(1, -(left + 10), 0, 24), Position = UDim2.fromOffset(left, 7), Parent = b,
		})
		local status = Label({
			Text = "OFF", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(235, 255, 240),
			Size = UDim2.new(1, -(left + 10), 0, 16), Position = UDim2.fromOffset(left, 31), Parent = b,
		})
		local obj = {}
		function obj.Set(v)
			state = v and true or false
			Tw(b, 0.25, {BackgroundColor3 = state and RED or GREEN})
			Tw(st, 0.25, {Color = state and RED or GREEN})
			status.Text = state and "ON" or "OFF"
		end
		function obj.Get() return state end
		b.MouseButton1Click:Connect(function()
			obj.Set(not state)
			task.spawn(pcall, cb, state)
		end)
		return obj
	end

	function tab:PlayerPicker(onPick)
		local selected, open, targetH = nil, false, 0
		local pick, setOpen, refresh
		local idleText = "tap the arrow to see who is in the server"

		local holder = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			LayoutOrder = nextOrder(), Parent = page,
		}, {New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})})

		local head = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = C.card, Text = "", AutoButtonColor = false,
			LayoutOrder = 1, Parent = holder,
		})
		Corner(head, 10)
		New("UIStroke", {Color = C.line, Thickness = 1, Parent = head})
		local avatar = New("ImageLabel", {
			Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(8, 8), BackgroundColor3 = C.bg, Image = "", Parent = head,
		})
		Corner(avatar, 17)
		local nameL = Label({
			Text = "Select a player", Font = Enum.Font.GothamBold, Size = UDim2.new(1, -104, 0, 20),
			Position = UDim2.fromOffset(52, 7), TextTruncate = Enum.TextTruncate.AtEnd, Parent = head,
		})
		local subL = Label({
			Text = idleText, TextSize = 11, TextColor3 = C.sub, Size = UDim2.new(1, -104, 0, 16),
			Position = UDim2.fromOffset(52, 27), TextTruncate = Enum.TextTruncate.AtEnd, Parent = head,
		})
		local arrowBox = New("Frame", {
			Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -40, 0.5, -15), BackgroundColor3 = C.mars, Parent = head,
		})
		Corner(arrowBox, 9)
		local chev = Icon("chev", arrowBox, 16, C.white)
		chev.AnchorPoint = Vector2.new(0.5, 0.5)
		chev.Position = UDim2.fromScale(0.5, 0.5)
		chev.Rotation = 90

		local list = New("ScrollingFrame", {
			Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = C.card, BorderSizePixel = 0, ScrollBarThickness = 3,
			ScrollBarImageColor3 = C.mars, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false, ClipsDescendants = true, LayoutOrder = 2, Parent = holder,
		}, {
			New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}),
			New("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 8)}),
		})
		Corner(list, 10)

		refresh = function()
			for _, c in ipairs(list:GetChildren()) do
				if c:IsA("GuiObject") then c:Destroy() end
			end
			local n = 0
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LP then
					n += 1
					local it = New("TextButton", {
						Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.panel, Text = "", AutoButtonColor = false,
						LayoutOrder = n, Parent = list,
					})
					Corner(it, 8)
					local th = New("ImageLabel", {
						Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(6, 5), BackgroundColor3 = C.bg,
						Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48", Parent = it,
					})
					Corner(th, 14)
					Label({Text = p.DisplayName, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, -50, 0, 18),
						Position = UDim2.fromOffset(42, 3), TextTruncate = Enum.TextTruncate.AtEnd, Parent = it})
					Label({Text = "@" .. p.Name, TextSize = 10, TextColor3 = C.sub, Size = UDim2.new(1, -50, 0, 14),
						Position = UDim2.fromOffset(42, 20), TextTruncate = Enum.TextTruncate.AtEnd, Parent = it})
					it.MouseEnter:Connect(function() Tw(it, 0.12, {BackgroundColor3 = Color3.fromRGB(60, 30, 34)}) end)
					it.MouseLeave:Connect(function() Tw(it, 0.12, {BackgroundColor3 = C.panel}) end)
					it.MouseButton1Click:Connect(function() pick(p) end)
				end
			end
			if n == 0 then
				Label({Text = "No other players in the server", TextSize = 12, TextColor3 = C.sub,
					Size = UDim2.new(1, 0, 0, 30), TextXAlignment = Enum.TextXAlignment.Center, Parent = list})
			end
			targetH = math.clamp(math.max(n, 1) * 42 + 12, 50, 200)
			if open then Tw(list, 0.15, {Size = UDim2.new(1, 0, 0, targetH)}) end
		end

		setOpen = function(v)
			open = v
			Tw(chev, 0.25, {Rotation = v and -90 or 90}, Enum.EasingStyle.Back)
			if v then
				refresh()
				list.Visible = true
				Tw(list, 0.25, {Size = UDim2.new(1, 0, 0, targetH)}, Enum.EasingStyle.Quint)
			else
				Tw(list, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
				task.delay(0.22, function() if not open then list.Visible = false end end)
			end
		end

		pick = function(p)
			selected = p
			avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48"
			nameL.Text = p.DisplayName
			subL.Text = "@" .. p.Name
			setOpen(false)
			if onPick then task.spawn(pcall, onPick, p) end
		end

		head.MouseButton1Click:Connect(function() setOpen(not open) end)
		table.insert(conns, Players.PlayerAdded:Connect(function()
			if open then task.delay(0.3, refresh) end
		end))
		table.insert(conns, Players.PlayerRemoving:Connect(function(p)
			if selected == p then
				selected = nil
				avatar.Image = ""
				nameL.Text = "Select a player"
				subL.Text = idleText
			end
			if open then task.delay(0.3, refresh) end
		end))

		return {Get = function() return selected end}
	end

	function tab:Owner(label, value, icon)
		local b = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = C.card, Text = "", AutoButtonColor = false,
			LayoutOrder = nextOrder(), Parent = page,
		})
		Corner(b, 12)
		local s = New("UIStroke", {Thickness = 2.4, Color = C.white, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b})
		local g = New("UIGradient", {Color = rainbow(), Parent = s})
		spinners[g] = 140
		local oi = Icon(icon, b, 34, C.mars2)
		oi.Position = UDim2.fromOffset(15, 19)
		Label({Text = label, TextSize = 11, TextColor3 = C.sub, Size = UDim2.new(1, -120, 0, 14),
			Position = UDim2.fromOffset(58, 12), Parent = b})
		local v = Label({Text = value, Font = Enum.Font.GothamBlack, TextSize = 18, Size = UDim2.new(1, -120, 0, 28),
			Position = UDim2.fromOffset(58, 30), TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
		hueTexts[v] = math.random()
		local hint = Label({Text = "TAP TO COPY", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.mars2,
			Size = UDim2.fromOffset(64, 72), Position = UDim2.new(1, -70, 0, 0), TextXAlignment = Enum.TextXAlignment.Center, Parent = b})
		b.MouseButton1Click:Connect(function()
			local sc = setclipboard or toclipboard or (Clipboard and Clipboard.set)
			if sc then pcall(sc, value) end
			Tw(b, 0.08, {BackgroundColor3 = Color3.fromRGB(70, 36, 40)})
			task.delay(0.1, function() Tw(b, 0.3, {BackgroundColor3 = C.card}) end)
			hint.Text = "COPIED"
			task.delay(1.2, function() hint.Text = "TAP TO COPY" end)
			Notify("Copied", value, C.mars2)
		end)
		return b
	end

	return tab
end

------------------------------------------------------------------
-- Remote helpers
------------------------------------------------------------------
local function TOOL(name)
	RS.RE["1Too1l"]:InvokeServer("PickingTools", name)
end

local function WEAR(id)
	RS:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(id)
end

local function COLOR(name)
	RS:WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(name)
end

local cooldown = false
local function AvatarChanges(torso, rarm, larm, rleg, lleg, head)
	if cooldown then
		Notify("Wait...", "Please wait before trying again!", C.mars2)
		return
	end
	cooldown = true
	pcall(function()
		RS:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({torso, rarm, larm, rleg, lleg, head})
	end)
	Notify("Avatar Changes...", "Applying changes...")
	task.delay(1, function()
		cooldown = false
		Notify("Success", "Avatar changed successfully!", Color3.fromRGB(90, 220, 140))
	end)
end

------------------------------------------------------------------
-- Tabs
------------------------------------------------------------------
local T = {
	Owners      = CreateTab("OWNERS", "crown"),
	CopiesSkin  = CreateTab("copies skin", "scissors"),
	Teleport    = CreateTab("Teleport", "pin"),
	Bang        = CreateTab("bang", "people"),
	Smla        = CreateTab("smla", "eye"),
	Accessories = CreateTab("Accessories", "hat"),
	Bundles     = CreateTab("Bundles", "people"),
	Antidotes   = CreateTab("Antidotes", "pill"),
	Avatar      = CreateTab("Avatar", "user"),
	Animation   = CreateTab("Animation", "film"),
	Music       = CreateTab("Music", "music"),
	Misc        = CreateTab("Misc", "sliders"),
	Credits     = CreateTab("Credits", "trophy"),
}

---------------- OWNERS
T.Owners:Paragraph("OWNERS", "Tap any card to copy it.")
T.Owners:Owner("Developer number:", "+21224838993", "phone")
T.Owners:Owner("TikTok Developer:", "uiogunio", "tiktok")

---------------- COPIES SKIN
local copyBusy = false

local ITEM_KEYS = {"Shirt", "Pants", "GraphicTShirt", "Face"}
local ANIM_KEYS = {"IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation", "FallAnimation",
	"ClimbAnimation", "SwimAnimation", "MoodAnimation"}
local RESET_WORDS = {"reset", "remove", "clear", "unequip", "strip", "takeoff"}
local AVATAR_WORDS = {"appear", "avatar", "charact", "access", "outfit", "cloth", "body", "skin", "wear"}

local function addId(list, seen, v)
	if type(v) == "number" and v > 0 and not seen[v] then
		seen[v] = true
		table.insert(list, v)
	end
end

local function collectFromDesc(desc, items, anims, seen)
	for _, k in ipairs(ITEM_KEYS) do
		local ok, v = pcall(function() return desc[k] end)
		if ok then addId(items, seen, v) end
	end
	local ok, accs = pcall(function() return desc:GetAccessories(true) end)
	if ok and accs then
		for _, a in ipairs(accs) do addId(items, seen, a.AssetId) end
	end
	for _, k in ipairs(ANIM_KEYS) do
		local ok2, v = pcall(function() return desc[k] end)
		if ok2 then addId(anims, seen, v) end
	end
end

local function readDescriptions(plr)
	local list = {}
	local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local ok, d = pcall(function() return hum:GetAppliedDescription() end)
		if ok and d then table.insert(list, d) end
		local attached = hum:FindFirstChildOfClass("HumanoidDescription")
		if attached then table.insert(list, attached) end
	end
	return list
end

local function myHum()
	local c = LP.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function ownWorn()
	local set, n = {}, 0
	local hum = myHum()
	if hum then
		local ok, d = pcall(function() return hum:GetAppliedDescription() end)
		if ok and d then
			local items, anims = {}, {}
			collectFromDesc(d, items, anims, {})
			for _, id in ipairs(items) do set[id] = "item"; n += 1 end
			for _, id in ipairs(anims) do set[id] = "anim"; n += 1 end
		end
	end
	return set, n
end

local function waitMyChar()
	local t0 = os.clock()
	while os.clock() - t0 < 8 do
		local c = LP.Character
		local h = c and c:FindFirstChildOfClass("Humanoid")
		if h and h.Health > 0 and c:FindFirstChild("HumanoidRootPart") then return true end
		task.wait(0.15)
	end
	return false
end

local function hasAny(name, words)
	name = name:lower()
	for _, w in ipairs(words) do
		if name:find(w, 1, true) then return true end
	end
	return false
end

local function fireResetRemotes()
	local fired = 0
	for _, folderName in ipairs({"Remotes", "RE"}) do
		local folder = RS:FindFirstChild(folderName)
		if folder then
			for _, r in ipairs(folder:GetChildren()) do
				if (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) and hasAny(r.Name, RESET_WORDS) and hasAny(r.Name, AVATAR_WORDS) then
					task.spawn(pcall, function()
						if r:IsA("RemoteFunction") then r:InvokeServer() else r:FireServer() end
					end)
					fired += 1
					task.wait(0.1)
				end
			end
		end
	end
	return fired
end

local function wearParallel(ids)
	local pending, done, failed = #ids, 0, 0
	for _, id in ipairs(ids) do
		task.spawn(function()
			local ok = pcall(WEAR, id)
			if not ok then
				task.wait(0.2)
				ok = pcall(WEAR, id)
			end
			if ok then done += 1 else failed += 1 end
			pending -= 1
		end)
		task.wait(0.05)
	end
	local t0 = os.clock()
	while pending > 0 and os.clock() - t0 < 12 do task.wait(0.05) end
	return done, failed
end

local function wearList(ids, worn)
	local todo = {}
	for _, id in ipairs(ids) do
		if not worn[id] then table.insert(todo, id) end
	end
	return wearParallel(todo)
end

local function stripByToggle()
	local set, n = ownWorn()
	if n == 0 then return end
	local ids = {}
	for id, kind in pairs(set) do
		if kind == "item" then table.insert(ids, id) end
	end
	if #ids == 0 then return end

	local probe = ids[1]
	pcall(WEAR, probe)
	task.wait(0.4)
	if ownWorn()[probe] then return end

	local rest = {}
	for i = 2, #ids do table.insert(rest, ids[i]) end
	wearParallel(rest)
	task.wait(0.3)
	local left = {}
	for id, kind in pairs(ownWorn()) do
		if kind == "item" then table.insert(left, id) end
	end
	if #left > 0 then wearParallel(left) end
end

local function pickBody(descs)
	local t = nil
	for _, d in ipairs(descs) do
		t = {d.Torso, d.RightArm, d.LeftArm, d.RightLeg, d.LeftLeg, d.Head}
		for _, v in ipairs(t) do
			if v and v > 0 then return t end
		end
	end
	return nil
end

local function wearSeq(ids, delay)
	for _, id in ipairs(ids) do
		pcall(WEAR, id)
		task.wait(delay)
	end
end

local function runCopy(plr)
	local descs = readDescriptions(plr)
	if #descs == 0 then error("could not read this player's avatar") end

	local items, anims, seen = {}, {}, {}
	for _, d in ipairs(descs) do collectFromDesc(d, items, anims, seen) end
	local body = pickBody(descs)

	Notify("copy skin", "Copying " .. plr.DisplayName .. "...", C.mars, "scissors")

	local mine = {}
	for id, kind in pairs(ownWorn()) do
		if kind == "item" then table.insert(mine, id) end
	end
	wearSeq(mine, 0.2)

	if body then
		pcall(function()
			RS:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(body)
		end)
		task.wait(0.5)
	end

	wearSeq(items, 0.3)

	local colors = plr.Character and plr.Character:FindFirstChild("Body Colors")
	if colors then
		pcall(function() COLOR(colors.HeadColor.Name) end)
		task.wait(0.3)
	end

	wearSeq(anims, 0.3)

	local bag = plr:FindFirstChild("PlayersBag")
	if bag then
		pcall(function()
			local RE = RS:WaitForChild("RE")
			local nameRem, colRem = RE:FindFirstChild("1RPNam1eTex1t"), RE:FindFirstChild("1RPNam1eColo1r")
			local n, b = bag:FindFirstChild("RPName"), bag:FindFirstChild("RPBio")
			local nc, bc = bag:FindFirstChild("RPNameColor"), bag:FindFirstChild("RPBioColor")
			if nameRem and n and n.Value ~= "" then nameRem:FireServer("RolePlayName", n.Value) task.wait(0.3) end
			if nameRem and b and b.Value ~= "" then nameRem:FireServer("RolePlayBio", b.Value) task.wait(0.3) end
			if colRem and nc then colRem:FireServer("PickingRPNameColor", nc.Value) task.wait(0.3) end
			if colRem and bc then colRem:FireServer("PickingRPBioColor", bc.Value) task.wait(0.3) end
		end)
	end

	local ch = plr.Character
	if ch then
		for _, t in ipairs(ch:GetChildren()) do
			if t:IsA("Tool") then pcall(TOOL, t.Name) end
		end
	end

	Notify("Success", "Skin copied from " .. plr.DisplayName, Color3.fromRGB(90, 220, 140), "scissors", true)
end

local function copySkin(plr)
	if copyBusy then
		Notify("Wait...", "A skin is already being copied", C.mars2, "warn")
		return
	end
	if not plr or not plr.Parent then
		Notify("copy skin", "Select a player first", C.mars2, "warn")
		return
	end
	copyBusy = true
	task.spawn(function()
		local ok, err = pcall(runCopy, plr)
		copyBusy = false
		if not ok then
			Notify("copy skin", tostring(err):sub(1, 70), C.mars2, "warn")
		end
	end)
end

T.CopiesSkin:Paragraph("copies skin", "Open the list, pick a player, then press copy skin.")
local skinPicker = T.CopiesSkin:PlayerPicker()
T.CopiesSkin:Rainbow("copy skin", function() copySkin(skinPicker.Get()) end, {
	height = 64, textSize = 20, icon = "scissors", iconSize = 30,
})

T.CopiesSkin:Button("Copy remote list", function()
	local lines = {}
	for _, fname in ipairs({"Remotes", "RE"}) do
		local f = RS:FindFirstChild(fname)
		if f then
			for _, r in ipairs(f:GetChildren()) do
				table.insert(lines, fname .. "." .. r.Name .. " (" .. r.ClassName .. ")")
			end
		end
	end
	local sc = setclipboard or toclipboard
	if sc then pcall(sc, table.concat(lines, "\n")) end
	Notify("Remote list", #lines .. " remotes copied", C.mars2, "scissors")
end)

---------------- BUNDLES
T.Bundles:Header("body")
T.Bundles:Paragraph("Bundles", "Funny Bundles")

T.Bundles:Button("Minecraft", function()
	AvatarChanges(14976595538, 14976595831, 14976595559, 14976595617, 14976595675, 14976598345)
end)
T.Bundles:Button("R6 - 1x1x1x1", function()
	AvatarChanges(17662225318, 103452055306587, 87202958751790, 129699548221468, 106411216404626, 0)
	WEAR(17521857429)
	task.wait(1)
	WEAR(6913613757)
	task.wait(1)
	WEAR(12850150835)
	task.wait(1)
	WEAR(4586060885)
end)
T.Bundles:Button("R6 - Male", function()
	AvatarChanges(81500432784353, 103452055306587, 87202958751790, 129699548221468, 106411216404626, 0)
end)
T.Bundles:Button("R6 - Female", function()
	AvatarChanges(124225564167965, 103452055306587, 87202958751790, 129699548221468, 106411216404626, 0)
end)
T.Bundles:Button("Classic R6", function()
	AvatarChanges(17675630775, 17675630666, 17675630763, 17675630677, 17675630636, 0)
end)
T.Bundles:Button("Robloxian V2 R6", function()
	AvatarChanges("76647226869628", "105638394824015", "139039414452825", "79885522911494", "81311062776381", "0")
end)
T.Bundles:Button("Invisible", function()
	AvatarChanges("15312911732", "14532583477", "14532583469", "14532583517", "14532583483", "134082579")
end)

---------------- AVATAR
T.Avatar:Paragraph("Colors", "Some Exclusive Color That Didn't Appear In Color UI")
T.Avatar:Button("Pastel Yellow", function() COLOR("Pastel yellow") end)
T.Avatar:Button("Noob Yellow", function() COLOR("Bright yellow") end)

T.Avatar:Paragraph("Heads", "Yeah Just Some Head Like Headless")
T.Avatar:Input("Head ID", true, function(text)
	local headId = tonumber(text)
	if headId then
		AvatarChanges(0, 0, 0, 0, 0, headId)
	else
		Notify("Invalid Head ID", "Enter numbers only.", C.mars2)
	end
end)
T.Avatar:Button("Headless", function() AvatarChanges(0, 0, 0, 0, 0, 134082579) end)
T.Avatar:Button("Neko Head", function() AvatarChanges(0, 0, 0, 0, 0, 18112201695) end)
T.Avatar:Button("BlazeBurner Head", function() AvatarChanges(0, 0, 0, 0, 0, 3210773801) end)
T.Avatar:Button("DeathWalker Head", function() AvatarChanges(0, 0, 0, 0, 0, 16580493236) end)

T.Avatar:Paragraph("Legs", "I mean,\nwho wouldn’t want to walk around looking like they’ve never seen a gym in their life?\nTruly, you're setting new trends.")
T.Avatar:Button("Korblox Right Leg", function() AvatarChanges(0, 0, 0, 139607718, 0, 0) end)
T.Avatar:Button("Korblox Left Leg", function() AvatarChanges(0, 0, 0, 0, 139607718, 0) end)

---------------- ACCESSORIES
local function addList(tab, list)
	for _, a in ipairs(list) do
		tab:Button(a.Name, function() WEAR(a.ID) end)
	end
end

T.Accessories:Paragraph("Sound Accessories", "Yes, Accessories with sound.")
addList(T.Accessories, {
	{Name = "Witches Brew Hat", ID = 305888394},
	{Name = "Transient-Harmonica", ID = 33070696},
	{Name = "Chicken-Suit", ID = 24112667},
	{Name = "Bloxy-Cola", ID = 24114402},
})

T.Accessories:Paragraph("Hand Accessories", "Yes, Holdable Accessories")
addList(T.Accessories, {
	{Name = "Ambris-Lum-Sword", ID = 5722175994},
	{Name = "Atlantean-Trident", ID = 3241238974},
	{Name = "Barbarian-Battleaxe", ID = 3131064293},
	{Name = "Tide-Shovel", ID = 3381195240},
	{Name = "Spray-Can", ID = 2936950534},
	{Name = "Thickhoof-Axe", ID = 3240543366},
	{Name = "Bread-Sword", ID = 3052700547},
	{Name = "Terrible-Teddy", ID = 3339372724},
	{Name = "Frozen-Blaster", ID = 3013849063},
	{Name = "Infinity-Gauntlet", ID = 2988781799},
	{Name = "Classic Sword Classic RIGHT", ID = 72563448587538},
	{Name = "Firebrand Sword Red LEFT", ID = 103807649971342},
	{Name = "Dual Venomshank Swords Green", ID = 72612615631590},
	{Name = "Dual Darkheart Swords Black", ID = 127135045879692},
	{Name = "Ghostwalker Sword RIGHT TRANSPARENT 75", ID = 86312248993609},
	{Name = "Darkheart Sword Black LEFT", ID = 127604887527094},
	{Name = "Darkheart Sword Black RIGHT", ID = 124312895586978},
	{Name = "Classic Sword LEFT HAND", ID = 110239613631704},
})

T.Accessories:Paragraph("Particles Whoa", "Yes, Particles Accessories")
addList(T.Accessories, {
	{Name = "Doomsekkar", ID = 132809431},
	{Name = "Ghosdeeri", ID = 183468963},
	{Name = "Cursed Flames", ID = 3756389957},
	{Name = "Hiccup's Improved Viking Helmet", ID = 262669756},
	{Name = "Korblox Grand Marshal", ID = 233253311},
	{Name = "Fiery Horns of the Netherworld", ID = 215718515},
	{Name = "Bluesteel Horns of Pwnage", ID = 233705354},
	{Name = "Boss White Hat", ID = 89171071},
	{Name = "Spring Fairy", ID = 150381051},
	{Name = "Winter Fairy", ID = 141742418},
	{Name = "Fall Fairy", ID = 128217885},
	{Name = "St Patrick's Day Fairy", ID = 226189871},
	{Name = "Snow Queen's Necklace", ID = 187998056},
	{Name = "Sparkling Angel Wings", ID = 192557913},
	{Name = "Rbadam's Smokestack Top Hat", ID = 169444515},
})

---------------- ANIMATION
local Animations = {
	{Category = "Idle", Name = "Borock Idle", Id = 3710007708},
	{Category = "Idle", Name = "Ud'zal Idle", Id = 3307605825},
	{Category = "Idle", Name = "R15 Idle", Id = 4211409027},
	{Category = "Idle", Name = "Long Idle", Id = 18308506919},
	{Category = "Idle", Name = "Bold Idle", Id = 16744209868},
	{Category = "Idle", Name = "Realistic Idle", Id = 11600321661},
	{Category = "Idle", Name = "Adidas Sports Idle", Id = 18538150608},
	{Category = "Idle", Name = "NFL Idle", Id = 101094325978637},
	{Category = "Idle", Name = "Catwalk Glam Idle", Id = 101279640971758},
	{Category = "Idle", Name = "Mr. Toilet Idle", Id = 4418326547},
	{Category = "Idle", Name = "No Boundaries Idle", Id = 18755930927},

	{Category = "Walk", Name = "No Boundaries Walk", Id = 18755942776},
	{Category = "Walk", Name = "Catwalk Glam Walk", Id = 103190462987721},
	{Category = "Walk", Name = "Bold Walk", Id = 16744219182},

	{Category = "Run", Name = "Rthro Heavy Run", Id = 3236849826},
	{Category = "Run", Name = "Adidas Sports Run", Id = 18538133604},
	{Category = "Run", Name = "Catwalk Glam Run", Id = 75036746190467},
	{Category = "Run", Name = "Bold Run", Id = 16744214662},
	{Category = "Run", Name = "NFL Run", Id = 84823630062362},
	{Category = "Run", Name = "Mr. Toilet Run", Id = 4418324223},
	{Category = "Run", Name = "No Boundaries Run", Id = 18755933883},

	{Category = "Jump", Name = "No Boundaries Jump", Id = 18755925411},
	{Category = "Jump", Name = "Catwalk Glam Jump", Id = 138641066989023},
	{Category = "Jump", Name = "Bold Jump", Id = 16744214662},
	{Category = "Jump", Name = "Wicked Jump", Id = 130373407996664},

	{Category = "Fall", Name = "No Boundaries Fall", Id = 18755922352},
	{Category = "Fall", Name = "Catwalk Glam Fall", Id = 72706690305027},
	{Category = "Fall", Name = "Adidas Fall", Id = 18538164337},
	{Category = "Fall", Name = "Bold Fall", Id = 16744207822},

	{Category = "Climb", Name = "Adidas Climb", Id = 18538170170},
	{Category = "Climb", Name = "Adidas2 Climb", Id = 18538170170},
}

local lastCat
for _, anim in ipairs(Animations) do
	if anim.Category ~= lastCat then
		lastCat = anim.Category
		T.Animation:Header(anim.Category, true)
	end
	T.Animation:Button(anim.Name, function()
		Notify("Applying " .. anim.Category .. " Animation...", "Hold on while we switch your style.")
		WEAR(anim.Id)
		task.delay(1, function()
			Notify(anim.Category .. " Animation Applied", "If you don't see it, lag might be messing with it.", Color3.fromRGB(90, 220, 140))
		end)
	end)
end

------------------------------------------------------------------
-- Shared state
------------------------------------------------------------------
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")

local flyOn, flySpeed = false, 60
local rainbowHead = false
local resetting = false

------------------------------------------------------------------
-- ANTIDOTES
------------------------------------------------------------------
local storingTools = false
local originalCFrame
local seatedDisabled = false

table.insert(conns, RunService.PreSimulation:Connect(function()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if storingTools then
		if not humanoid or not character:FindFirstChild("HumanoidRootPart") then return end
		local root = character.HumanoidRootPart
		local backpack = LP:FindFirstChild("Backpack")

		if humanoid and not seatedDisabled then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			seatedDisabled = true
		end
		if not originalCFrame then originalCFrame = root.CFrame end
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.CFrame = originalCFrame

		if backpack then
			for _, tool in ipairs(backpack:GetChildren()) do
				if tool:IsA("Tool") then tool.Parent = character end
			end
		end
		for _, tool in ipairs(character:GetChildren()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				local voidPos = Vector3.new(0, -99999, 0)
				if tool.GripPos ~= voidPos then tool.GripPos = voidPos end
			end
		end
	elseif seatedDisabled and humanoid then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		seatedDisabled = false
		originalCFrame = nil
	end
end))
table.insert(conns, LP.CharacterAdded:Connect(function() resetting = false end))

local antiHit = false
table.insert(conns, RunService.Stepped:Connect(function()
	if not antiHit then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and root) then return end
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	if not resetting and hum.Health > 0 and hum.Health < hum.MaxHealth then
		hum.Health = hum.MaxHealth
	end
	if not flyOn and root.AssemblyLinearVelocity.Magnitude > 350 then
		root.AssemblyLinearVelocity = Vector3.zero
	end
end))
T.Antidotes:Toggle("Anti Hit", false, function(state)
	antiHit = state
	if not state then
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		end
	end
	Notify("Anti Hit", state and "Anti Hit is now ON" or "Anti Hit is now OFF")
end)

local antiFling = false
table.insert(conns, RunService.Stepped:Connect(function()
	if not antiFling then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			for _, part in ipairs(p.Character:GetChildren()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root and not flyOn then
		if root.AssemblyAngularVelocity.Magnitude > 100 then root.AssemblyAngularVelocity = Vector3.zero end
		if root.AssemblyLinearVelocity.Magnitude > 350 then root.AssemblyLinearVelocity = Vector3.zero end
	end
end))
T.Antidotes:Toggle("Anti Fling", false, function(state)
	antiFling = state
	Notify("Anti Fling", state and "Anti Fling is now ON" or "Anti Fling is now OFF")
end)

local antiAfk = false
table.insert(conns, LP.Idled:Connect(function()
	if not antiAfk then return end
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end))
T.Antidotes:Toggle("Anti AFK", false, function(state)
	antiAfk = state
	Notify("Anti AFK", state and "Anti AFK is now ON" or "Anti AFK is now OFF")
end)

local lagOn, lagConn = false, nil
local lagStore, lagSaved = {}, {}
local function lagKill(o)
	if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then
		if lagStore[o] == nil then lagStore[o] = o.Enabled end
		o.Enabled = false
	end
end
local function setAntiLag(on)
	lagOn = on
	if on then
		pcall(function()
			lagSaved.shadows = Lighting.GlobalShadows
			Lighting.GlobalShadows = false
		end)
		pcall(function()
			lagSaved.quality = settings().Rendering.QualityLevel
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)
		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") then
				if lagStore[e] == nil then lagStore[e] = e.Enabled end
				e.Enabled = false
			end
		end
		task.spawn(function()
			local n = 0
			for _, o in ipairs(workspace:GetDescendants()) do
				if not lagOn then break end
				lagKill(o)
				n += 1
				if n % 400 == 0 then task.wait() end
			end
		end)
		lagConn = workspace.DescendantAdded:Connect(function(o) if lagOn then lagKill(o) end end)
	else
		if lagConn then lagConn:Disconnect() lagConn = nil end
		for o, v in pairs(lagStore) do pcall(function() o.Enabled = v end) end
		table.clear(lagStore)
		pcall(function()
			if lagSaved.shadows ~= nil then Lighting.GlobalShadows = lagSaved.shadows end
			if lagSaved.quality then settings().Rendering.QualityLevel = lagSaved.quality end
		end)
	end
end
T.Antidotes:Toggle("Anti Lag", false, function(state)
	setAntiLag(state)
	Notify("Anti Lag", state and "Anti Lag is now ON" or "Anti Lag is now OFF")
end)

local autoClick, clickCps, clickAcc = false, 10, 0
table.insert(conns, RunService.Heartbeat:Connect(function(dt)
	if not autoClick then clickAcc = 0 return end
	clickAcc += dt
	if clickAcc < 1 / clickCps then return end
	clickAcc = 0
	local ch = LP.Character
	local tool = ch and ch:FindFirstChildOfClass("Tool")
	if tool then
		pcall(function() tool:Activate() end)
	elseif not isOpen then
		pcall(function()
			local v = workspace.CurrentCamera.ViewportSize
			VirtualUser:ClickButton1(Vector2.new(v.X / 2, v.Y / 2))
		end)
	end
end))
T.Antidotes:Toggle("Auto Click", false, function(state)
	autoClick = state
	Notify("Auto Click", state and "Auto Click is now ON" or "Auto Click is now OFF")
end)
T.Antidotes:Slider("Click Speed (per sec)", 1, 30, 10, function(v) clickCps = v end)

T.Antidotes:Toggle("Dupe Tools", false, function(value)
	storingTools = value
	if not value then
		originalCFrame = nil
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			resetting = true
			hum.Health = 0
		end
	end
end)

------------------------------------------------------------------
-- MUSIC
------------------------------------------------------------------
local musicSound, musicVol, musicLoop = nil, 5, false

local function playMusic(text)
	local id = tonumber(text)
	if not id then
		Notify("music", "Put a valid ID first", C.mars2, "music")
		return
	end
	if musicSound then musicSound:Destroy() end
	local s = New("Sound", {
		Name = "OrcaMusic", SoundId = "rbxassetid://" .. id, Volume = musicVol, Looped = musicLoop, Parent = SoundService,
	})
	musicSound = s
	s:Play()
	task.spawn(function()
		local t0 = os.clock()
		while not s.IsLoaded and os.clock() - t0 < 6 do task.wait(0.1) end
		if musicSound ~= s then return end
		if s.IsLoaded then
			Notify("music", "It has been activated", C.mars, "music", true)
		else
			Notify("music", "This ID could not be loaded", C.mars2, "warn")
		end
	end)
end

local _, musicBox = T.Music:Input("Put id music", true, function(text) playMusic(text) end)
T.Music:Button("Play the song", function() playMusic(musicBox.Text) end)
T.Music:Button("Stop the song", function()
	if musicSound then musicSound:Stop() musicSound:Destroy() musicSound = nil end
	Notify("music", "Stopped", C.mars2, "music")
end)
T.Music:Slider("Volume", 0, 100, 50, function(v)
	musicVol = v / 10
	if musicSound then musicSound.Volume = musicVol end
end)
T.Music:Toggle("Loop", false, function(state)
	musicLoop = state
	if musicSound then musicSound.Looped = state end
end)

------------------------------------------------------------------
-- MISC
------------------------------------------------------------------
local function getHum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end

local flyBV, flyBG
local function stopFly()
	flyOn = false
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local hum = getHum()
	if hum then hum.PlatformStand = false end
end
local function startFly()
	local root, hum = getRoot(), getHum()
	if not (root and hum) then return false end
	flyOn = true
	flyBV = New("BodyVelocity", {MaxForce = Vector3.new(1e9, 1e9, 1e9), Velocity = Vector3.zero, Parent = root})
	flyBG = New("BodyGyro", {MaxTorque = Vector3.new(1e9, 1e9, 1e9), P = 9e4, CFrame = root.CFrame, Parent = root})
	hum.PlatformStand = true
	return true
end

local noclip, infJump, spinOn, fbOn = false, false, false, false
local speedOn, speedVal, jumpOn, jumpVal, fovVal = false, 50, false, 100, nil

table.insert(conns, RunService.Heartbeat:Connect(function(dt)
	local hum, root = getHum(), getRoot()
	if hum then
		if speedOn then hum.WalkSpeed = speedVal end
		if jumpOn then hum.UseJumpPower = true hum.JumpPower = jumpVal end
	end
	if spinOn and root and not flyOn then
		root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(720) * dt, 0)
	end
	if fbOn then Lighting.ClockTime = 14 end
	if fovVal then
		local cam = workspace.CurrentCamera
		if cam then cam.FieldOfView = fovVal end
	end
	if flyOn then
		if not flyBV or not flyBV.Parent then startFly() end
		local cam = workspace.CurrentCamera
		if flyBV and flyBG and root and hum and cam then
			local look = cam.CFrame.LookVector
			local md = hum.MoveDirection
			local vel = Vector3.zero
			if md.Magnitude > 0 then
				local flat = Vector3.new(look.X, 0, look.Z)
				local fwd = flat.Magnitude > 0 and md:Dot(flat.Unit) or 0
				vel = md * flySpeed + Vector3.new(0, look.Y * fwd * flySpeed, 0)
			end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpeed, 0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
				vel -= Vector3.new(0, flySpeed, 0)
			end
			flyBV.Velocity = vel
			flyBG.CFrame = cam.CFrame
		end
	end
end))

table.insert(conns, RunService.Stepped:Connect(function()
	if not noclip then return end
	local ch = LP.Character
	if not ch then return end
	for _, p in ipairs(ch:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end))

table.insert(conns, UIS.JumpRequest:Connect(function()
	if infJump then
		local hum = getHum()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end))

local xray, xrayConn = false, nil
local xrayDone = setmetatable({}, {__mode = "k"})
local function xrayPart(o)
	if o:IsA("BasePart") then
		local m = o:FindFirstAncestorOfClass("Model")
		if m and m:FindFirstChildOfClass("Humanoid") then return end
		xrayDone[o] = true
		o.LocalTransparencyModifier = 0.7
	end
end
local function setXray(on)
	xray = on
	if on then
		task.spawn(function()
			local n = 0
			for _, o in ipairs(workspace:GetDescendants()) do
				if not xray then break end
				xrayPart(o)
				n += 1
				if n % 300 == 0 then task.wait() end
			end
		end)
		xrayConn = workspace.DescendantAdded:Connect(function(o) if xray then xrayPart(o) end end)
	else
		if xrayConn then xrayConn:Disconnect() xrayConn = nil end
		for o in pairs(xrayDone) do pcall(function() o.LocalTransparencyModifier = 0 end) end
		table.clear(xrayDone)
	end
end

local lightSaved
local function setFullbright(on)
	fbOn = on
	if on then
		lightSaved = lightSaved or {
			Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
			Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
		}
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(170, 170, 170)
		Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
	elseif lightSaved then
		for k, v in pairs(lightSaved) do Lighting[k] = v end
		lightSaved = nil
	end
end

local fogSaved, atmoSaved = nil, {}
local function setNoFog(on)
	if on then
		fogSaved = fogSaved or {FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart}
		Lighting.FogEnd = 1e9
		Lighting.FogStart = 1e9
		for _, a in ipairs(Lighting:GetChildren()) do
			if a:IsA("Atmosphere") then
				if atmoSaved[a] == nil then atmoSaved[a] = a.Density end
				a.Density = 0
			end
		end
	else
		if fogSaved then
			Lighting.FogEnd = fogSaved.FogEnd
			Lighting.FogStart = fogSaved.FogStart
			fogSaved = nil
		end
		for a, d in pairs(atmoSaved) do pcall(function() a.Density = d end) end
		table.clear(atmoSaved)
	end
end

local espOn, espObjs = false, {}
local function espRemove(p)
	local o = espObjs[p]
	if o then
		for _, x in ipairs(o) do pcall(function() x:Destroy() end) end
		espObjs[p] = nil
	end
end
local function espApply(p)
	if p == LP or not espOn then return end
	espRemove(p)
	local ch = p.Character
	local head = ch and ch:FindFirstChild("Head")
	if not head then return end
	local hl = New("Highlight", {
		FillColor = C.mars, OutlineColor = C.white, FillTransparency = 0.6, OutlineTransparency = 0,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = ch,
	})
	local bb = New("BillboardGui", {
		Size = UDim2.fromOffset(140, 22), StudsOffset = Vector3.new(0, 3, 0), AlwaysOnTop = true, Adornee = head, Parent = head,
	})
	Label({
		Text = p.DisplayName, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Center,
		TextStrokeTransparency = 0.3, Size = UDim2.fromScale(1, 1), Parent = bb,
	})
	espObjs[p] = {hl, bb}
end
local function espHook(p)
	if p == LP then return end
	table.insert(conns, p.CharacterAdded:Connect(function()
		task.wait(1)
		if espOn then espApply(p) end
	end))
end
for _, p in ipairs(Players:GetPlayers()) do espHook(p) end
table.insert(conns, Players.PlayerAdded:Connect(espHook))
table.insert(conns, Players.PlayerRemoving:Connect(espRemove))

T.Misc:Toggle("Fly", false, function(s)
	if s then
		if not startFly() then Notify("Fly", "Character not found", C.mars2) end
	else
		stopFly()
	end
end)
T.Misc:Slider("Fly Speed", 10, 300, 60, function(v) flySpeed = v end)
T.Misc:Toggle("Noclip", false, function(s) noclip = s end)
T.Misc:Toggle("X-Ray", false, setXray)
T.Misc:Toggle("Walk Speed", false, function(s)
	speedOn = s
	if not s then local h = getHum() if h then h.WalkSpeed = 16 end end
end)
T.Misc:Slider("Walk Speed Value", 16, 300, 50, function(v) speedVal = v end)
T.Misc:Toggle("Jump Power", false, function(s)
	jumpOn = s
	if not s then local h = getHum() if h then h.JumpPower = 50 end end
end)
T.Misc:Slider("Jump Power Value", 50, 400, 100, function(v) jumpVal = v end)
T.Misc:Toggle("Infinite Jump", false, function(s) infJump = s end)
T.Misc:Toggle("Spin", false, function(s) spinOn = s end)
T.Misc:Toggle("Fullbright", false, setFullbright)
T.Misc:Toggle("Remove Fog", false, setNoFog)
T.Misc:Toggle("ESP Players", false, function(s)
	espOn = s
	for _, p in ipairs(Players:GetPlayers()) do
		if s then espApply(p) else espRemove(p) end
	end
end)
T.Misc:Slider("Field of View", 30, 120, 70, function(v) fovVal = v end)
T.Misc:Slider("Gravity", 0, 300, 196, function(v) workspace.Gravity = v end)

-- TELEPORT tab
local permTarget, permOn = nil, false
local permBtn

local tpPicker = T.Teleport:PlayerPicker(function(p)
	if permOn then permTarget = p end
end)

T.Teleport:Rainbow("Teleport", function()
	local p = tpPicker.Get()
	if not p or not p.Parent then
		Notify("Teleport", "Select a player first", C.mars2, "warn")
		return
	end
	local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	local mine = getRoot()
	if r and mine then
		mine.CFrame = r.CFrame * CFrame.new(0, 0, 3)
		Notify("Teleport", "Teleported to " .. p.DisplayName, C.mars, "pin")
	else
		Notify("Teleport", "Player not found", C.mars2, "warn")
	end
end, {height = 70, textSize = 22, icon = "pin", iconSize = 32})

permBtn = T.Teleport:ColorToggle("Permanent Teleport", function(state)
	if state then
		local p = tpPicker.Get()
		if not p or not p.Parent then
			permBtn.Set(false)
			Notify("Permanent Teleport", "Select a player first", C.mars2, "warn")
			return
		end
		permTarget = p
		permOn = true
		Notify("Permanent Teleport", "Following " .. p.DisplayName, C.mars, "pin")
	else
		permOn = false
		permTarget = nil
		Notify("Permanent Teleport", "Stopped following", C.mars, "pin")
	end
end, "pin")

table.insert(conns, RunService.Heartbeat:Connect(function()
	if not permOn then return end
	if not permTarget or not permTarget.Parent then
		permOn, permTarget = false, nil
		permBtn.Set(false)
		Notify("Permanent Teleport", "That player left the server", C.mars2, "warn")
		return
	end
	local r = permTarget.Character and permTarget.Character:FindFirstChild("HumanoidRootPart")
	local mine = getRoot()
	if r and mine then
		mine.CFrame = r.CFrame * CFrame.new(0, 0, 3)
		mine.AssemblyLinearVelocity = Vector3.zero
	end
end))

------------------------------------------------------------------
-- BANG & BANG FACE (تم تعديل الـ Bang العادي ليلحق الظهر تماماً كالـ Face Bang)
------------------------------------------------------------------
local bangPicker = T.Bang:PlayerPicker()
local bangBtn, faceBtn
local bangOn, faceOn = false, false
local bangTarget, bangAway = nil, false

local bangAnimTrack = nil
local bangSpeed, faceSpeed = 5, 5
local originalAnimateScript = nil

local function applyStance(active)
	local character = LP.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local animate = character:FindFirstChild("Animate")

	if active then
		if animate then
			originalAnimateScript = animate.Disabled
			animate.Disabled = true
		end
		if humanoid then
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				track:Stop()
			end
		end
	else
		if animate and originalAnimateScript ~= nil then
			animate.Disabled = originalAnimateScript
		end
	end
end

local function stopBangAnim()
	if bangAnimTrack then
		bangAnimTrack:Stop()
		bangAnimTrack:Destroy()
		bangAnimTrack = nil
	end
	applyStance(false)
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Sit = false
	end
end

local function playBangAnim(animId, isFaceBang)
	stopBangAnim()
	
	if isFaceBang then
		applyStance(false)
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.Sit = true end
	else
		applyStance(true)
	end

	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(animId)
		bangAnimTrack = hum:LoadAnimation(anim)
		bangAnimTrack:Play()
		bangAnimTrack:AdjustSpeed(bangOn and bangSpeed or faceSpeed)
	end
end

bangBtn = T.Bang:ColorToggle("BANG", function(state)
	bangOn = state
	if state then
		if faceOn then
			faceOn = false
			if faceBtn then faceBtn.Set(false) end
		end
		local p = bangPicker.Get()
		if not p or not p.Parent then
			bangOn = false
			bangBtn.Set(false)
			Notify("BANG", "Select a player first", C.mars2, "warn")
			return
		end
		bangTarget, bangAway = {id = p.UserId, name = p.Name, player = p}, false
		playBangAnim(148840371, false)
		Notify("BANG Activated  " .. p.Name, "", C.mars, "user")
	else
		stopBangAnim()
		if not faceOn then bangTarget, bangAway = nil, false end
	end
end)

faceBtn = T.Bang:ColorToggle("BANG FACE", function(state)
	faceOn = state
	if state then
		if bangOn then
			bangOn = false
			if bangBtn then bangBtn.Set(false) end
		end
		local p = bangPicker.Get()
		if not p or not p.Parent then
			faceOn = false
			if faceBtn then faceBtn.Set(false) end
			Notify("BANG FACE", "Select a player first", C.mars2, "warn")
			return
		end
		bangTarget, bangAway = {id = p.UserId, name = p.Name, player = p}, false
		
		playBangAnim(148840371, true)
		Notify("BANG FACE Activated  " .. p.Name, "", C.mars, "user")
	else
		stopBangAnim()
		if not bangOn then bangTarget, bangAway = nil, false end
	end
end)

local _, setBangSpeed = T.Bang:Slider("speed bang", 0, 100, 5, function(v) 
	bangSpeed = v 
	if bangAnimTrack and bangOn then bangAnimTrack:AdjustSpeed(v) end
end)
local _, setFaceSpeed = T.Bang:Slider("speed face bang", 0, 100, 5, function(v) 
	faceSpeed = v 
	if bangAnimTrack and faceOn then bangAnimTrack:AdjustSpeed(v) end
end)

T.Bang:SmallButton("reset", Color3.fromRGB(225, 50, 60), function()
	setBangSpeed(5)
	setFaceSpeed(5)
end)

local bangAnimLoop = 0
table.insert(conns, RunService.Heartbeat:Connect(function(dt)
	if (bangOn or faceOn) and bangTarget and bangTarget.player and bangTarget.player.Parent then
		local targetChar = bangTarget.player.Character
		local myChar = LP.Character
		local tRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		local tHead = targetChar and targetChar:FindFirstChild("Head")
		local mRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
		
		if tRoot and mRoot and myHum then
			local speed = bangOn and bangSpeed or faceSpeed
			bangAnimLoop = bangAnimLoop + (dt * (speed * 2.5))
			local offsetZ = math.sin(bangAnimLoop) * 1.0
			
			mRoot.AssemblyLinearVelocity = Vector3.zero
			mRoot.AssemblyAngularVelocity = Vector3.zero
			
			-- استخدام Head أو جزء أساسي ديناميكي للـ Bang ليلحق الظهر تماماً حتى لو كان يرقص أو نايم
			if bangOn then
				local targetPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or tRoot
				mRoot.CFrame = targetPart.CFrame * CFrame.new(0, 0, 1.1 + offsetZ)
			elseif faceOn and tHead then
				myHum.Sit = true
				mRoot.CFrame = tHead.CFrame * CFrame.new(0, 0.5, -0.9 + (offsetZ * 0.5)) * CFrame.Angles(0, math.pi, 0)
			end
		end
	end
end))

table.insert(conns, Players.PlayerRemoving:Connect(function(p)
	if bangTarget and (bangOn or faceOn) and p.UserId == bangTarget.id then
		bangAway = true
		Notify(bangTarget.name, "Easy", C.mars, "user")
	end
end))
table.insert(conns, Players.PlayerAdded:Connect(function(p)
	if bangTarget and bangAway and p.UserId == bangTarget.id then
		bangAway = false
		bangTarget.player = p
		Notify(bangTarget.name, "The player returned", C.mars, "user")
	end
end))

------------------------------------------------------------------
-- SMLA tab (player tracker)
------------------------------------------------------------------
local GREEN = Color3.fromRGB(46, 200, 110)
local RED = Color3.fromRGB(235, 60, 70)
local sessionStart = os.clock()

local function fmtTime(sec)
	sec = math.floor(sec)
	local h = math.floor(sec / 3600)
	local m = math.floor((sec % 3600) / 60)
	return string.format("%02d:%02d:%02d", h, m, sec % 60)
end

T.Smla:Header("smla", true)

local sessCard = T.Smla:Card(76)
do
	local st = New("UIStroke", {Thickness = 2, Color = C.white, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = sessCard})
	local g = New("UIGradient", {Color = rainbow(), Parent = st})
	spinners[g] = 120
end
Label({
	Text = "Your time in this server", TextSize = 11, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Center,
	Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 10), Parent = sessCard,
})
local sessLabel = Label({
	Text = "00:00:00", Font = Enum.Font.GothamBlack, TextSize = 28, TextXAlignment = Enum.TextXAlignment.Center,
	Size = UDim2.new(1, 0, 0, 36), Position = UDim2.fromOffset(0, 28), Parent = sessCard,
})
hueTexts[sessLabel] = 0

local smlaPicker = T.Smla:PlayerPicker()
local tracked = {}

local function stayOf(e)
	return e.acc + (e.present and (os.clock() - e.since) or 0)
end

local function refreshEntry(e)
	e.joinL.Text = "Joined: " .. e.joined
	e.leftL.Text = "Left: " .. e.left
	e.statusL.Text = e.present and "online" or "offline"
	e.statusL.TextColor3 = e.present and GREEN or RED
	e.dot.BackgroundColor3 = e.present and GREEN or RED
	e.timeL.TextColor3 = e.present and GREEN or RED
end

local function addTracked(p)
	if tracked[p.UserId] then
		Notify("smla", p.DisplayName .. " is already added", C.mars2, "warn")
		return
	end
	local card = T.Smla:Card(96)
	local avatar = New("ImageLabel", {
		Size = UDim2.fromOffset(52, 52), Position = UDim2.fromOffset(12, 22), BackgroundColor3 = C.bg,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=100&h=100", Parent = card,
	})
	Corner(avatar, 26)
	Label({Text = p.DisplayName, Font = Enum.Font.GothamBlack, TextSize = 14, Size = UDim2.new(1, -232, 0, 18),
		Position = UDim2.fromOffset(74, 12), TextTruncate = Enum.TextTruncate.AtEnd, Parent = card})
	Label({Text = "@" .. p.Name, TextSize = 11, TextColor3 = C.sub, Size = UDim2.new(1, -232, 0, 16),
		Position = UDim2.fromOffset(74, 31), TextTruncate = Enum.TextTruncate.AtEnd, Parent = card})

	local e = {
		name = p.Name, present = true, joined = 0, left = 0, acc = 0, since = os.clock(), card = card,
	}
	e.timeL = Label({Text = "+ 00:00:00", Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.fromOffset(100, 18), Position = UDim2.new(1, -152, 0, 12), Parent = card})
	e.dot = New("Frame", {Size = UDim2.fromOffset(18, 18), Position = UDim2.new(1, -70, 0, 34), BackgroundColor3 = GREEN, Parent = card})
	Corner(e.dot, 9)
	e.statusL = Label({Text = "online", Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
		Size = UDim2.fromOffset(100, 14), Position = UDim2.new(1, -152, 0, 55), Parent = card})
	e.joinL = Label({Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = GREEN,
		Size = UDim2.new(1, -84, 0, 16), Position = UDim2.fromOffset(74, 64), Parent = card})
	e.leftL = Label({Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = RED,
		Size = UDim2.new(1, -84, 0, 16), Position = UDim2.fromOffset(162, 64), Parent = card})

	local rm = New("TextButton", {
		Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -34, 0, 8), BackgroundColor3 = C.panel,
		Text = "", AutoButtonColor = false, Parent = card,
	})
	Corner(rm, 7)
	local rx = Icon("x", rm, 14, RED)
	rx.AnchorPoint = Vector2.new(0.5, 0.5)
	rx.Position = UDim2.fromScale(0.5, 0.5)
	rm.MouseButton1Click:Connect(function()
		tracked[p.UserId] = nil
		card:Destroy()
	end)

	refreshEntry(e)
	tracked[p.UserId] = e
	Notify("smla", p.DisplayName .. " added", GREEN, "eye")
end

T.Smla:Rainbow("add player", function()
	local p = smlaPicker.Get()
	if not p or not p.Parent then
		Notify("smla", "Select a player first", C.mars2, "warn")
		return
	end
	addTracked(p)
end, {height = 46, textSize = 15, icon = "eye", iconSize = 22})

table.insert(conns, Players.PlayerAdded:Connect(function(p)
	if p == LP then return end
	local e = tracked[p.UserId]
	if e then
		Notify("Server", "(" .. p.Name .. ") joined the server", GREEN, "user")
		e.present = true
		e.since = os.clock()
		e.joined += 1
		refreshEntry(e)
	end
end))
table.insert(conns, Players.PlayerRemoving:Connect(function(p)
	if p == LP then return end
	local e = tracked[p.UserId]
	if e and e.present then
		Notify("Server", "(" .. p.Name .. ") has left the server", RED, "user")
		e.acc = stayOf(e)
		e.present = false
		e.left += 1
		refreshEntry(e)
	end
end))

local lastUi = 0
table.insert(conns, RunService.Heartbeat:Connect(function()
	local now = os.clock()
	if now - lastUi < 0.25 then return end
	lastUi = now
	sessLabel.Text = fmtTime(now - sessionStart)
	for _, e in pairs(tracked) do
		e.timeL.Text = "+ " .. fmtTime(stayOf(e))
	end
end))

T.Misc:Button("Reset Character", function()
	local h = getHum()
	if h then resetting = true h.Health = 0 end
end)
T.Misc:Button("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)
T.Misc:Button("Server Hop", function()
	Notify("Server Hop", "Searching for a server...")
	local ok, res = pcall(function()
		return game:GetService("HttpService"):JSONDecode(game:HttpGet(
			"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if ok and res and res.data then
		for _, s in ipairs(res.data) do
			if s.id ~= game.JobId and s.playing < s.maxPlayers then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP)
				return
			end
		end
	end
	Notify("Server Hop", "No server found", C.mars2)
end)

T.Misc:Toggle("Rainbow Head Text", false, function(s) rainbowHead = s end)

T.Misc:Rainbow("start script", function()
	Notify("start script", "Running...", C.mars2)
	local ok = pcall(function()
		loadstring(game:HttpGet("https://pastefy.app/UoCnT459/raw"))()
	end)
	if not ok then Notify("start script", "Failed to load", C.mars2) end
end)

------------------------------------------------------------------
-- CREDITS
------------------------------------------------------------------
T.Credits:Paragraph("Credits", "Hub: uiogunio / orca\nGame: Brookhaven\nUI: custom Mars theme")
T.Credits:Owner("TikTok Developer:", "uiogunio", "tiktok")

------------------------------------------------------------------
-- Startup
------------------------------------------------------------------
local function SetHeadText()
	local nameText, bioText = "[uiogunio / orca]>< [[script]]", "--[It was turned on]]"
	local re = RS:FindFirstChild("RE")
	local rem = re and re:FindFirstChild("1RPNam1eTex1t")
	if rem then
		pcall(function() rem:FireServer("RolePlayName", nameText) end)
		pcall(function() rem:FireServer("RolePlayBio", bioText) end)
		local colRem = re:FindFirstChild("1RPNam1eColo1r")
		if colRem then
			task.spawn(function()
				while Gui.Parent do
					if rainbowHead then
						local t = os.clock() * 0.2
						pcall(function() colRem:FireServer("PickingRPNameColor", Color3.fromHSV(t % 1, 0.8, 1)) end)
						pcall(function() colRem:FireServer("PickingRPBioColor", Color3.fromHSV((t + 0.5) % 1, 0.8, 1)) end)
					end
					task.wait(0.7)
				end
			end)
		end
		return
	end
	local function make()
		local head = LP.Character and LP.Character:FindFirstChild("Head")
		if not head or head:FindFirstChild("OrcaSign") then return end
		local bb = New("BillboardGui", {
			Name = "OrcaSign", Size = UDim2.fromOffset(220, 46), StudsOffset = Vector3.new(0, 3.2, 0),
			AlwaysOnTop = true, Adornee = head, Parent = head,
		})
		local l1 = Label({Text = nameText, Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center,
			TextStrokeTransparency = 0.3, Size = UDim2.new(1, 0, 0.5, 0), Parent = bb})
		local l2 = Label({Text = bioText, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
			TextStrokeTransparency = 0.3, Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.fromScale(0, 0.5), Parent = bb})
		hueTexts[l1] = 0
		hueTexts[l2] = 0.5
	end
	make()
	table.insert(conns, LP.CharacterAdded:Connect(function() task.wait(1) make() end))
end

local function SendChat(msg)
	local ok = pcall(function()
		local TCS = game:GetService("TextChatService")
		if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
			TCS.TextChannels.RBXGeneral:SendAsync(msg)
		else
			error("legacy")
		end
	end)
	if not ok then
		pcall(function()
			RS.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
		end)
	end
end

local function OpenMain()
	isOpen = true
	Main.Visible = true
	MainScale.Scale = 0
	Tw(MainScale, 0.45, {Scale = baseScale()}, Enum.EasingStyle.Back)
end
local function CloseMain()
	isOpen = false
	local tw = Tw(MainScale, 0.25, {Scale = 0}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	tw.Completed:Connect(function() if not isOpen then Main.Visible = false end end)
end
local function ToggleMain() if isOpen then CloseMain() else OpenMain() end end
CloseBtn.MouseButton1Click:Connect(CloseMain)

do
	local dragging, dStart, sPos
	TopBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, dStart, sPos = true, i.Position, Main.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	table.insert(conns, UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dStart
			Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
		end
	end))
end

local Orb = New("Frame", {
	Name = "OrcaOrb", Size = UDim2.fromOffset(150, 150), Position = UDim2.new(0, 16, 0.35, 0),
	BackgroundTransparency = 1, Parent = Gui,
})

local rings = {
	{w = 124, h = 46, rot = 0,   sp = 24,  th = 2,   z = 2},
	{w = 124, h = 46, rot = 60,  sp = -32, th = 2,   z = 2},
	{w = 112, h = 40, rot = 120, sp = 40,  th = 1.6, z = 7},
}
for _, d in ipairs(rings) do
	d.f = New("Frame", {
		Size = UDim2.fromOffset(d.w, d.h), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1, Rotation = d.rot, ZIndex = d.z, Parent = Orb,
	})
	Corner(d.f, d.h / 2)
	local s = New("UIStroke", {Thickness = d.th, Color = C.white, Transparency = 0.1, Parent = d.f})
	local g = New("UIGradient", {Color = rainbow(), Parent = s})
	spinners[g] = 90
end

local Halo = New("Frame", {
	Size = UDim2.fromOffset(74, 74), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1, ZIndex = 3, Parent = Orb,
})
Corner(Halo, 37)
do
	local s = New("UIStroke", {Thickness = 3, Color = C.white, Parent = Halo})
	local g = New("UIGradient", {Color = rainbow(), Parent = s})
	spinners[g] = -160
end

local Core = New("Frame", {
	Size = UDim2.fromOffset(60, 60), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = C.white, ZIndex = 4, Parent = Orb,
})
Corner(Core, 30)
New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(70, 22, 20), Color3.fromRGB(14, 8, 14)), Rotation = 50, Parent = Core})
local CoreText = Label({
	Text = "orca", Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.fromScale(1, 1),
	TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, Parent = Core,
})
hueTexts[CoreText] = 0.3

local planets = {
	{size = 16, rx = 60, ry = 22, sp = 1.1,  ph = 0,   tilt = -20, c0 = Color3.fromRGB(255, 150, 90),  c1 = Color3.fromRGB(120, 28, 20)},
	{size = 9,  rx = 50, ry = 32, sp = 1.9,  ph = 2,   tilt = 35,  c0 = Color3.fromRGB(200, 180, 160), c1 = Color3.fromRGB(70, 58, 52)},
	{size = 7,  rx = 66, ry = 16, sp = -1.4, ph = 4,   tilt = 70,  c0 = Color3.fromRGB(225, 195, 165), c1 = Color3.fromRGB(95, 72, 60)},
	{size = 12, rx = 56, ry = 27, sp = 0.8,  ph = 3.3, tilt = -65, c0 = Color3.fromRGB(255, 195, 110), c1 = Color3.fromRGB(150, 58, 24)},
}
for _, p in ipairs(planets) do
	p.f = New("Frame", {
		Size = UDim2.fromOffset(p.size, p.size), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = Orb,
	})
	Corner(p.f, 20)
	New("UIGradient", {Color = ColorSequence.new(p.c0, p.c1), Rotation = 45, Parent = p.f})
	New("UIStroke", {Color = Color3.fromRGB(255, 120, 70), Thickness = 1, Transparency = 0.55, Parent = p.f})
end

local Hit = New("TextButton", {
	Size = UDim2.fromOffset(96, 96), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1, Text = "", ZIndex = 20, Parent = Orb,
})
do
	local dragging, moved, dStart, sPos
	Hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, moved, dStart, sPos = true, false, i.Position, Orb.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
					if not moved then ToggleMain() end
				end
			end)
		end
	end)
	table.insert(conns, UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dStart
			if d.Magnitude > 6 then moved = true end
			if moved then
				Orb.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
			end
		end
	end))
end

table.insert(conns, RunService.Heartbeat:Connect(function(dt)
	local t = os.clock()

	for g, sp in pairs(spinners) do
		if g.Parent then g.Rotation = (g.Rotation + dt * sp) % 360 else spinners[g] = nil end
	end
	for l, off in pairs(hueTexts) do
		if l.Parent then l.TextColor3 = Color3.fromHSV((t * 0.25 + off) % 1, 0.65, 1) else hueTexts[l] = nil end
	end

	for _, s in ipairs(stars) do
		s.f.BackgroundTransparency = 0.45 + 0.5 * math.sin(t * s.sp + s.ph)
	end

	for _, p in ipairs(planets) do
		local a = t * p.sp + p.ph
		local x, y = math.cos(a) * p.rx, math.sin(a) * p.ry
		local th = math.rad(p.tilt)
		local px = x * math.cos(th) - y * math.sin(th)
		local py = x * math.sin(th) + y * math.cos(th)
		local z = math.sin(a)
		local s = p.size * (1 + 0.28 * z)
		p.f.Size = UDim2.fromOffset(s, s)
		p.f.Position = UDim2.new(0.5, px, 0.5, py)
		p.f.ZIndex = z > 0 and 6 or 1
	end

	for _, d in ipairs(rings) do
		d.f.Rotation = (d.rot + t * d.sp) % 360
	end
	Halo.Size = UDim2.fromOffset(74 + math.sin(t * 2.2) * 3, 74 + math.sin(t * 2.2) * 3)
end))

SelectTab(T.Owners)
Orb.Size = UDim2.fromOffset(0, 0)
Tw(Orb, 0.6, {Size = UDim2.fromOffset(150, 150)}, Enum.EasingStyle.Back)
Notify("uiogunio / orca", "Loaded. Tap the orca orb to open the hub.", C.mars)
task.spawn(function()
	task.wait(1.5)
	SetHeadText()
	SendChat("-----------uiogunio / orca ____[on] 🏠")
end)
