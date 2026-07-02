local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local TextService = game:GetService("TextService")

local Library = {
	Connections = {},
	TextCache = {},
	ActiveTweens = {},
	CacheLimit = 100,
	CacheCleanupThreshold = 150,
}

local TweenNormal = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenFast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local MouseButton1 = Enum.UserInputType.MouseButton1
local TouchInput = Enum.UserInputType.Touch
local MouseMovement = Enum.UserInputType.MouseMovement
local InputEnd = Enum.UserInputState.End

local White = Color3.fromRGB(255, 255, 255)
local Grey200 = Color3.fromRGB(200, 200, 200)
local Grey166 = Color3.fromRGB(166, 166, 166)

local Theme = {
	Colors = {
		Success = Color3.fromRGB(46, 204, 113),
		Warning = Color3.fromRGB(241, 196, 15),
		Error = Color3.fromRGB(231, 76, 60),
		Info = Color3.fromRGB(147, 51, 234),
	},
	Icons = {
		Info = "rbxassetid://6022668879",
		Success = "rbxassetid://6023426926",
		Warning = "rbxassetid://6031086176",
		Error = "rbxassetid://6034461619",
	},
}

local function CreateInstance(ClassName, Properties)
	local instance = Instance.new(ClassName)
	for property, value in next, Properties do
		instance[property] = value
	end
	return instance
end

local function AddUICorner(Parent, Radius)
	return CreateInstance("UICorner", {CornerRadius = UDim.new(0, Radius or 8), Parent = Parent})
end

local function TrackConnection(Connection)
	Library.Connections[#Library.Connections + 1] = Connection
	return Connection
end

local function GetTextSize(Text, TextSize, Font, MaxSize)
	local cacheKey = Text .. TextSize .. tostring(Font) .. tostring(MaxSize)
	local cachedSize = Library.TextCache[cacheKey]
	if cachedSize then return cachedSize end

	local cache = Library.TextCache
	if #cache >= Library.CacheCleanupThreshold then
		local newCache = {}
		local count = 0
		for key, value in next, cache do
			if count >= Library.CacheLimit then break end
			newCache[key] = value
			count += 1
		end
		Library.TextCache = newCache
		cache = newCache
	end

	local result = TextService:GetTextSize(Text, TextSize, Font, MaxSize)
	cache[cacheKey] = result
	return result
end

local function CreateTween(Object, Info, Properties)
	local tween = TweenService:Create(Object, Info, Properties)
	Library.ActiveTweens[#Library.ActiveTweens + 1] = tween
	tween.Completed:Connect(function()
		local index = table.find(Library.ActiveTweens, tween)
		if index then
			table.remove(Library.ActiveTweens, index)
		end
		tween:Destroy()
	end)
	return tween
end

local function ApplyHoverEffect(Button, NormalColor, HoverColor, UseTween)
	UseTween = UseTween ~= false
	local tweenInfo = UseTween and TweenFast or nil
	TrackConnection(Button.MouseEnter:Connect(function()
		if tweenInfo then
			CreateTween(Button, tweenInfo, {BackgroundColor3 = HoverColor}):Play()
		else
			Button.BackgroundColor3 = HoverColor
		end
	end))
	TrackConnection(Button.MouseLeave:Connect(function()
		if tweenInfo then
			CreateTween(Button, tweenInfo, {BackgroundColor3 = NormalColor}):Play()
		else
			Button.BackgroundColor3 = NormalColor
		end
	end))
end

local function SetupScrollingFrame(ScrollingFrame, ListLayout)
	local function UpdateCanvas()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
	end

	local debounce
	TrackConnection(ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if debounce then
			task.cancel(debounce)
		end
		debounce = task.delay(0.03, UpdateCanvas)
	end))

	TrackConnection(ScrollingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		if ScrollingFrame.Visible then
			task.wait(0.01)
			UpdateCanvas()
		end
	end))
	return UpdateCanvas
end

local Notifications = {
	Active = 0,
	Max = 3,
}

local NotificationScreenGui = CreateInstance("ScreenGui", {
	Name = "sentinel-notifications",
	Parent = CoreGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ResetOnSpawn = false,
	DisplayOrder = 10,
})

local NotificationHolder = CreateInstance("Frame", {
	Name = "NotificationHolder",
	Parent = NotificationScreenGui,
	AnchorPoint = Vector2.new(1, 0),
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -10, 0, 10),
	Size = UDim2.new(0, 320, 0, 0),
	ZIndex = 10,
})
CreateInstance("UIListLayout", {
	Parent = NotificationHolder,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	VerticalAlignment = Enum.VerticalAlignment.Top,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
})

function Library:Notify(Config)
	if Notifications.Active >= Notifications.Max then return end

	Config = Config or {}
	local title = Config.Title or "Notification"
	local description = Config.Description or "No description provided"
	local duration = Config.Duration or 5
	local notificationType = Config.Type or "info"
	local typeKey = notificationType:sub(1, 1):upper() .. notificationType:sub(2)
	local accentColor = Theme.Colors[typeKey] or Theme.Colors.Info
	local iconAsset = Theme.Icons[typeKey] or Theme.Icons.Info

	local notification = CreateInstance("Frame", {
		Name = "Notification",
		Parent = NotificationHolder,
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		ZIndex = 10,
	})
	AddUICorner(notification, 8)
	CreateInstance("UIStroke", {
		Parent = notification,
		Color = accentColor,
		Thickness = 2,
		LineJoinMode = Enum.LineJoinMode.Round,
	})
	CreateInstance("ImageLabel", {
		Name = "Icon",
		Parent = notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 12),
		Size = UDim2.new(0, 22, 0, 22),
		Image = iconAsset,
		ImageColor3 = accentColor,
		ZIndex = 10,
	})

	local contentFrame = CreateInstance("Frame", {
		Name = "Content",
		Parent = notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 42, 0, 12),
		Size = UDim2.new(1, -80, 1, -24),
		ZIndex = 10,
	})
	CreateInstance("TextLabel", {
		Name = "Title",
		Parent = contentFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = White,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 10,
	})
	CreateInstance("TextLabel", {
		Name = "Description",
		Parent = contentFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 18),
		Size = UDim2.new(1, 0, 1, -18),
		Font = Enum.Font.Gotham,
		Text = description,
		TextColor3 = Grey200,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 10,
	})

	local closeButton = CreateInstance("ImageButton", {
		Name = "Close",
		Parent = notification,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -10, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://6035047409",
		ImageColor3 = Grey166,
		AutoButtonColor = false,
		ZIndex = 10,
	})

	local contentWidth = NotificationHolder.AbsoluteSize.X - 80
	local descriptionHeight = GetTextSize(description, 11, Enum.Font.Gotham, Vector2.new(contentWidth, math.huge)).Y
	local totalHeight = math.max(60, math.min(90, 46 + descriptionHeight))
	CreateTween(notification, TweenNormal, {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
	Notifications.Active += 1

	local closed = false
	local function CloseNotification()
		if closed or not notification.Parent then return end
		closed = true
		Notifications.Active = math.max(0, Notifications.Active - 1)
		CreateTween(notification, TweenFast, {Size = UDim2.new(1, 0, 0, 0)}):Play()
		Debris:AddItem(notification, 0.15)
	end

	TrackConnection(closeButton.MouseButton1Click:Connect(CloseNotification))
	task.delay(duration, CloseNotification)
end

local function SetupDrag(Frame, Target)
	local dragging, dragStart, startPosition
	TrackConnection(Frame.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType == MouseButton1 or inputType == TouchInput then
			dragging = true
			dragStart = input.Position
			startPosition = Target.Position
			TrackConnection(input.Changed:Connect(function()
				if input.UserInputState == InputEnd then
					dragging = false
				end
			end))
		end
	end))

	TrackConnection(UserInputService.InputChanged:Connect(function(input)
		local inputType = input.UserInputType
		if dragging and (inputType == MouseMovement or inputType == TouchInput) then
			local delta = input.Position - dragStart
			Target.Position = UDim2.new(
				startPosition.X.Scale, startPosition.X.Offset + delta.X,
				startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
			)
		end
	end))
end

function Library:Window(Title)
	for _, child in next, CoreGui:GetChildren() do
		if child.Name:lower():sub(1, 8) == "sentinel" and child.Name ~= "sentinel-notifications" then
			child:Destroy()
		end
	end

	local windowGui = CreateInstance("ScreenGui", {
		Name = "sentinel-library",
		Parent = CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	})

	local mainFrame = CreateInstance("Frame", {
		Name = "Main",
		Parent = windowGui,
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 530, 0, 320),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Active = true,
		Selectable = true,
	})
	AddUICorner(mainFrame, 10)
	CreateInstance("UIStroke", {
		Parent = mainFrame,
		Color = Color3.fromRGB(20, 20, 24),
		Transparency = 0.3,
		Thickness = 1.5,
		LineJoinMode = Enum.LineJoinMode.Round,
	})
	SetupDrag(mainFrame, mainFrame)

	local topBar = CreateInstance("Frame", {
		Name = "Top",
		Parent = mainFrame,
		BackgroundColor3 = Color3.fromRGB(24, 24, 28),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 38),
	})
	AddUICorner(topBar, 10)
	CreateInstance("Frame", {
		Name = "Cover",
		Parent = topBar,
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = Color3.fromRGB(24, 24, 28),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 6),
	})
	CreateInstance("Frame", {
		Name = "Line",
		Parent = topBar,
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = White,
		BackgroundTransparency = 0.920,
		Position = UDim2.new(0.5, 0, 1, 1),
		Size = UDim2.new(1, 0, 0, 1),
	})
	CreateInstance("ImageLabel", {
		Name = "Logo",
		Parent = topBar,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 8, 0.5, 0),
		Size = UDim2.new(0, 26, 0, 30),
		Image = "rbxassetid://7803241868",
		ImageColor3 = Color3.fromRGB(147, 51, 234),
	})
	CreateInstance("TextLabel", {
		Name = "GameName",
		Parent = topBar,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 36, 0.5, 0),
		Size = UDim2.new(0, 165, 0, 22),
		Font = Enum.Font.Gotham,
		Text = Title or "SentinelLIB",
		TextColor3 = Color3.fromRGB(147, 51, 234),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local minimizeButton = CreateInstance("ImageButton", {
		Name = "Minimize",
		Parent = topBar,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -40, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://118026365011536",
		ImageColor3 = Grey166,
	})

	local closeButton = CreateInstance("ImageButton", {
		Name = "Close",
		Parent = topBar,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://6035047409",
		ImageColor3 = Grey166,
		AutoButtonColor = false,
	})
	ApplyHoverEffect(closeButton, Grey166, Color3.fromRGB(231, 76, 60), true)

	local minimizedIcon = CreateInstance("ImageButton", {
		Name = "MinimizedIcon",
		Parent = windowGui,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(147, 51, 234),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -20, 0, 20),
		Size = UDim2.new(0, 40, 0, 40),
		Visible = false,
		ZIndex = 10,
		Image = "rbxassetid://7803241868",
	})
	AddUICorner(minimizedIcon, 10)
	SetupDrag(minimizedIcon, minimizedIcon)

	TrackConnection(minimizeButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
		minimizedIcon.Visible = true
	end))
	TrackConnection(minimizedIcon.MouseButton1Click:Connect(function()
		mainFrame.Visible = true
		minimizedIcon.Visible = false
	end))

	local overlay = CreateInstance("TextButton", {
		Name = "Overlay",
		Parent = mainFrame,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 99,
		Text = "",
		AutoButtonColor = false,
		Active = true,
		Modal = true,
		Visible = false,
	})
	AddUICorner(overlay, 10)

	local confirmDialog = CreateInstance("Frame", {
		Name = "ConfirmDialog",
		Parent = mainFrame,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 300, 0, 140),
		ZIndex = 100,
		Visible = false,
	})
	AddUICorner(confirmDialog, 10)
	CreateInstance("UIStroke", {
		Parent = confirmDialog,
		Color = Color3.fromRGB(147, 51, 234),
		Thickness = 2,
		LineJoinMode = Enum.LineJoinMode.Round,
	})
	CreateInstance("TextLabel", {
		Name = "Title",
		Parent = confirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 15),
		Size = UDim2.new(1, 0, 0, 25),
		Font = Enum.Font.GothamBold,
		Text = "Close UI?",
		TextColor3 = White,
		TextSize = 16,
		ZIndex = 101,
	})
	CreateInstance("TextLabel", {
		Name = "Description",
		Parent = confirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 45),
		Size = UDim2.new(1, 0, 0, 30),
		Font = Enum.Font.Gotham,
		Text = "This will destroy the UI.\nAre you sure?",
		TextColor3 = Grey200,
		TextSize = 13,
		TextWrapped = true,
		ZIndex = 101,
	})

	local buttonContainer = CreateInstance("Frame", {
		Name = "ButtonContainer",
		Parent = confirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 85),
		Size = UDim2.new(1, -40, 0, 40),
		ZIndex = 101,
	})

	local cancelBackground = Color3.fromRGB(35, 35, 40)
	local cancelBackgroundHover = Color3.fromRGB(45, 45, 50)
	local confirmBackground = Color3.fromRGB(116, 39, 188)
	local confirmBackgroundHover = Color3.fromRGB(138, 43, 226)

	local cancelButton = CreateInstance("TextButton", {
		Name = "Cancel",
		Parent = buttonContainer,
		BackgroundColor3 = cancelBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.48, 0, 1, 0),
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "Cancel",
		TextColor3 = White,
		TextSize = 14,
		ZIndex = 102,
	})
	AddUICorner(cancelButton, 8)
	ApplyHoverEffect(cancelButton, cancelBackground, cancelBackgroundHover, true)

	local confirmButton = CreateInstance("TextButton", {
		Name = "Confirm",
		Parent = buttonContainer,
		BackgroundColor3 = confirmBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0.52, 0, 0, 0),
		Size = UDim2.new(0.48, 0, 1, 0),
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "Close",
		TextColor3 = White,
		TextSize = 14,
		ZIndex = 102,
	})
	AddUICorner(confirmButton, 8)
	ApplyHoverEffect(confirmButton, confirmBackground, confirmBackgroundHover, true)

	local function ShowConfirm(show)
		overlay.Visible = show
		confirmDialog.Visible = show
	end

	TrackConnection(cancelButton.MouseButton1Click:Connect(function() ShowConfirm(false) end))
	TrackConnection(confirmButton.MouseButton1Click:Connect(function() Library:Destroy() end))
	TrackConnection(closeButton.MouseButton1Click:Connect(function() ShowConfirm(true) end))

	local tabsFrame = CreateInstance("Frame", {
		Name = "Tabs",
		Parent = mainFrame,
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 39),
		Size = UDim2.new(0, 124, 1, -39),
	})
	AddUICorner(tabsFrame, 10)
	CreateInstance("Frame", {
		Name = "Cover",
		Parent = tabsFrame,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 6, 1, 0),
	})

	local tabsContainer = CreateInstance("ScrollingFrame", {
		Name = "TabsContainer",
		Parent = tabsFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 0,
	})
	local tabsListLayout = CreateInstance("UIListLayout", {
		Parent = tabsContainer,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
	})
	CreateInstance("UIPadding", {Parent = tabsContainer, PaddingTop = UDim.new(0, 8)})
	SetupScrollingFrame(tabsContainer, tabsListLayout)

	local pagesFrame = CreateInstance("Frame", {
		Name = "Pages",
		Parent = mainFrame,
		BackgroundColor3 = Color3.fromRGB(28, 28, 32),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 132, 0, 46),
		Size = UDim2.new(1, -140, 1, -54),
	})
	AddUICorner(pagesFrame, 8)

	local tabFactory = {}
	local firstTabCreated = false
	local tabInactiveColor = Color3.fromRGB(120, 120, 130)
	local tabActiveColor = White

	function tabFactory:Tab(TabTitle)
		local tabButton = CreateInstance("TextButton", {
			Name = "TabButton",
			Parent = tabsContainer,
			BackgroundColor3 = Color3.fromRGB(147, 51, 234),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -14, 0, 32),
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
			TextSize = 14,
		})
		AddUICorner(tabButton, 8)

		local tabLabel = CreateInstance("TextLabel", {
			Name = "TextLabel",
			Parent = tabButton,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.Gotham,
			Text = TabTitle or "Tab",
			TextColor3 = tabInactiveColor,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Center,
		})

		local page = CreateInstance("ScrollingFrame", {
			Name = "Page",
			Visible = false,
			Parent = pagesFrame,
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarThickness = 0,
		})
		local pageListLayout = CreateInstance("UIListLayout", {
			Parent = page,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 3),
		})
		CreateInstance("UIPadding", {Parent = page, PaddingTop = UDim.new(0, 8)})
		local updatePageCanvas = SetupScrollingFrame(page, pageListLayout)

		TrackConnection(tabButton.MouseButton1Click:Connect(function()
			for _, child in ipairs(pagesFrame:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					child.Visible = false
				end
			end
			for _, child in ipairs(tabsContainer:GetChildren()) do
				if child.Name == "TabButton" then
					CreateTween(child, TweenNormal, {BackgroundTransparency = 1}):Play()
					local label = child:FindFirstChild("TextLabel")
					if label then
						CreateTween(label, TweenNormal, {TextColor3 = tabInactiveColor}):Play()
					end
				end
			end
			page.Visible = true
			CreateTween(tabButton, TweenNormal, {BackgroundTransparency = 0.6}):Play()
			CreateTween(tabLabel, TweenNormal, {TextColor3 = tabActiveColor}):Play()
			updatePageCanvas()
		end))

		if not firstTabCreated then
			firstTabCreated = true
			page.Visible = true
			tabButton.BackgroundTransparency = 0.6
			tabLabel.TextColor3 = White
		end

		local elementFactory = {}

		function elementFactory:Button(Text, Callback)
			local buttonBackground = Color3.fromRGB(116, 39, 188)
			local buttonBackgroundHover = Color3.fromRGB(138, 43, 226)
			local button = CreateInstance("TextButton", {
				Name = "Button",
				Parent = page,
				BackgroundColor3 = buttonBackground,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				AutoButtonColor = false,
				Font = Enum.Font.Gotham,
				Text = Text or "Button",
				TextColor3 = White,
				TextSize = 14,
			})
			AddUICorner(button, 8)
			ApplyHoverEffect(button, buttonBackground, buttonBackgroundHover, true)
			TrackConnection(button.MouseButton1Click:Connect(Callback))
		end

		function elementFactory:Toggle(Text, Default, Callback)
			local toggleButton = CreateInstance("TextButton", {
				Name = "Toggle",
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				AutoButtonColor = false,
				Text = "",
			})
			AddUICorner(toggleButton, 8)
			CreateInstance("TextLabel", {
				Name = "Title",
				Parent = toggleButton,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -50, 1, 0),
				Font = Enum.Font.Gotham,
				Text = Text or "Toggle",
				TextColor3 = White,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local togglePurple = Color3.fromRGB(138, 43, 226)
			local toggleFrame = CreateInstance("Frame", {
				Name = "ToggleFrame",
				Parent = toggleButton,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = togglePurple,
				BackgroundTransparency = Default and 0 or 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
			})
			CreateInstance("UIStroke", {
				Parent = toggleFrame,
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = 2,
				Color = togglePurple,
			})
			AddUICorner(toggleFrame, 10)

			local toggled = Default or false
			TrackConnection(toggleButton.MouseButton1Click:Connect(function()
				toggled = not toggled
				CreateTween(toggleFrame, TweenFast, {BackgroundTransparency = toggled and 0 or 1}):Play()
				if Callback then
					Callback(toggled)
				end
			end))

			return {
				Set = function(_, Value)
					toggled = Value
					toggleFrame.BackgroundTransparency = toggled and 0 or 1
					if Callback then
						Callback(toggled)
					end
				end,
			}
		end

		function elementFactory:Label(Text)
			local label = CreateInstance("TextLabel", {
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				Font = Enum.Font.Gotham,
				Text = Text or "Label",
				TextColor3 = White,
				TextSize = 14,
				TextWrapped = true,
			})
			AddUICorner(label, 8)
			CreateInstance("UIPadding", {
				Parent = label,
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
			})

			local function UpdateLabelSize()
				local contentWidth = label.AbsoluteSize.X - 20
				if contentWidth > 0 then
					local textHeight = GetTextSize(label.Text, 14, Enum.Font.Gotham, Vector2.new(contentWidth, math.huge)).Y
					label.Size = UDim2.new(1, -10, 0, math.max(36, textHeight + 20))
					updatePageCanvas()
				end
			end

			local debounce
			TrackConnection(label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if debounce then task.cancel(debounce) end
				debounce = task.delay(0.02, UpdateLabelSize)
			end))
			task.defer(UpdateLabelSize)

			return {
				Set = function(_, NewText)
					label.Text = NewText or "Label"
					UpdateLabelSize()
				end,
			}
		end

		function elementFactory:Slider(Text, Min, Max, Default, Increment, Callback)
			Min = Min or 0
			Max = Max or 100
			Default = Default or Min
			Increment = Increment or 1

			local sliderFrame = CreateInstance("Frame", {
				Name = "Slider",
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				Size = UDim2.new(1, -10, 0, 52),
			})
			AddUICorner(sliderFrame, 8)
			CreateInstance("TextLabel", {
				Name = "Title",
				Parent = sliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -6, 0, 36),
				Font = Enum.Font.Gotham,
				Text = Text or "Slider",
				TextColor3 = White,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local valueLabel = CreateInstance("TextLabel", {
				Name = "Value",
				Parent = sliderFrame,
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0, 0),
				Size = UDim2.new(1, 0, 0, 36),
				Font = Enum.Font.Gotham,
				Text = tostring(Default),
				TextColor3 = White,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Right,
			})

			local barFrame = CreateInstance("Frame", {
				Name = "Bar",
				Parent = sliderFrame,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(50, 50, 55),
				Position = UDim2.new(0.5, 0, 1, -10),
				Size = UDim2.new(1, -16, 0, 8),
			})
			AddUICorner(barFrame, 8)

			local fillFrame = CreateInstance("Frame", {
				Name = "Fill",
				Parent = barFrame,
				BackgroundColor3 = Color3.fromRGB(138, 43, 226),
				Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
			})
			AddUICorner(fillFrame, 8)

			local dragging, pendingCallback, lastValue = false, false, Default
			local valueRange = Max - Min
			local precision = 1000000

			local function RoundValue(value)
				if Increment == 0 then return value end
				return math.floor((math.floor(value / Increment + 0.5) * Increment) * precision + 0.5) / precision
			end

			local function FormatValue(value)
				local stringValue = tostring(math.floor(value * precision + 0.5) / precision)
				if stringValue:find("%.") then
					stringValue = stringValue:gsub("0+$", ""):gsub("%.$", "")
				end
				return stringValue
			end

			local function UpdateSlider(percent, callNow)
				local newValue = RoundValue(Min + (percent * valueRange))
				fillFrame.Size = UDim2.new((newValue - Min) / valueRange, 0, 1, 0)
				valueLabel.Text = FormatValue(newValue)
				if newValue ~= lastValue then
					lastValue = newValue
					if callNow and Callback then
						Callback(newValue)
					else
						pendingCallback = true
					end
				end
			end

			local function Slide(Input)
				local percent = math.clamp((Input.Position.X - barFrame.AbsolutePosition.X) / barFrame.AbsoluteSize.X, 0, 1)
				UpdateSlider(percent, false)
			end

			TrackConnection(barFrame.InputBegan:Connect(function(input)
				local inputType = input.UserInputType
				if inputType == MouseButton1 or inputType == TouchInput then
					dragging = true
					Slide(input)
					TrackConnection(input.Changed:Connect(function()
						if input.UserInputState == InputEnd then
							dragging = false
							if pendingCallback and Callback then
								Callback(lastValue)
								pendingCallback = false
							end
						end
					end))
				end
			end))

			TrackConnection(UserInputService.InputChanged:Connect(function(input)
				local inputType = input.UserInputType
				if dragging and (inputType == MouseMovement or inputType == TouchInput) then
					Slide(input)
				end
			end))

			return {
				Set = function(_, Value)
					UpdateSlider((math.clamp(Value, Min, Max) - Min) / valueRange, true)
				end,
			}
		end

		function elementFactory:InputBox(Text, Placeholder, Callback)
			local inputBoxFrame = CreateInstance("Frame", {
				Name = "InputBox",
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
			})
			AddUICorner(inputBoxFrame, 8)
			CreateInstance("TextLabel", {
				Name = "Title",
				Parent = inputBoxFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0.5, -6, 1, 0),
				Font = Enum.Font.Gotham,
				Text = Text or "Input",
				TextColor3 = White,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local boxContainer = CreateInstance("Frame", {
				Name = "BoxContainer",
				Parent = inputBoxFrame,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0.45, -12, 0, 28),
			})

			local textBox = CreateInstance("TextBox", {
				Name = "Box",
				Parent = boxContainer,
				BackgroundColor3 = Color3.fromRGB(40, 40, 45),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				ClipsDescendants = true,
				Font = Enum.Font.Gotham,
				Text = "",
				PlaceholderText = Placeholder or "",
				PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
				TextColor3 = White,
				TextSize = 14,
			})
			AddUICorner(textBox, 6)
			TrackConnection(textBox.FocusLost:Connect(function(enterPressed)
				if Callback and enterPressed then
					Callback(textBox.Text)
				end
			end))
		end

		function elementFactory:Dropdown(Text, DefaultOption, Options, Callback)
			if type(DefaultOption) == "table" then
				Callback = Options
				Options = DefaultOption
				DefaultOption = ""
			end

			Options = Options or {}
			DefaultOption = DefaultOption or ""
			if Callback and type(Callback) ~= "function" then
				Callback = nil
			end

			local dropdownFrame = CreateInstance("Frame", {
				Name = "Dropdown",
				Parent = page,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				ClipsDescendants = true,
				ZIndex = 10,
			})
			AddUICorner(dropdownFrame, 8)

			local chooseFrame = CreateInstance("Frame", {
				Name = "Choose",
				Parent = dropdownFrame,
				BackgroundColor3 = Color3.fromRGB(35, 35, 40),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 36),
				ZIndex = 11,
			})
			AddUICorner(chooseFrame, 8)

			local dropdownTitle = Text or "Dropdown"
			local titleLabel = CreateInstance("TextLabel", {
				Name = "Title",
				Parent = chooseFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -46, 1, 0),
				Font = Enum.Font.Gotham,
				Text = dropdownTitle,
				TextColor3 = White,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 11,
			})

			local arrowButton = CreateInstance("ImageButton", {
				Name = "Arrow",
				Parent = chooseFrame,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://6031091004",
				ImageColor3 = Color3.fromRGB(138, 43, 226),
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 11,
			})

			local optionsContainer = CreateInstance("ScrollingFrame", {
				Name = "OptionsContainer",
				Parent = dropdownFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 42),
				Size = UDim2.new(1, 0, 1, -42),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false,
				ZIndex = 10,
			})
			local optionsListLayout = CreateInstance("UIListLayout", {
				Parent = optionsContainer,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
			})
			CreateInstance("UIPadding", {
				Parent = optionsContainer,
				PaddingTop = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
			})

			local maxDropdownHeight = 150
			local collapsedHeight = 36
			local dropped = false
			local currentOption = DefaultOption

			local function ResizeDropdown()
				local contentHeight = optionsListLayout.AbsoluteContentSize.Y + 12
				optionsContainer.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
				dropdownFrame.Size = UDim2.new(1, -10, 0, 42 + math.min(contentHeight, maxDropdownHeight))
				updatePageCanvas()
			end

			local resizeDebounce
			TrackConnection(optionsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if resizeDebounce then task.cancel(resizeDebounce) end
				resizeDebounce = task.delay(0.02, function()
					if optionsContainer.Visible then
						ResizeDropdown()
					end
				end)
			end))

			local function CollapseDropdown()
				dropdownFrame.Size = UDim2.new(1, -10, 0, collapsedHeight)
				updatePageCanvas()
			end

			local function ToggleDropdown()
				dropped = not dropped
				optionsContainer.Visible = dropped
				arrowButton.Rotation = dropped and 180 or 0
				if dropped then
					ResizeDropdown()
				else
					CollapseDropdown()
				end
			end

			local function RefreshOptions(newOptions)
				newOptions = newOptions or {}
				for _, child in ipairs(optionsContainer:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end

				if #newOptions == 0 then
					local noOptionButton = CreateInstance("TextButton", {
						Name = "NoOption",
						Parent = optionsContainer,
						BackgroundColor3 = Color3.fromRGB(50, 50, 55),
						BorderSizePixel = 0,
						Size = UDim2.new(1, -12, 0, 30),
						Font = Enum.Font.Gotham,
						Text = "No Options Available",
						TextColor3 = Color3.fromRGB(150, 150, 150),
						TextSize = 14,
						AutoButtonColor = false,
						ZIndex = 10,
					})
					AddUICorner(noOptionButton, 6)
				else
					local optionBackground = Color3.fromRGB(116, 39, 188)
					for _, optionText in ipairs(newOptions) do
						local optionButton = CreateInstance("TextButton", {
							Name = "Option",
							Parent = optionsContainer,
							BackgroundColor3 = optionBackground,
							BorderSizePixel = 0,
							Size = UDim2.new(1, -12, 0, 30),
							AutoButtonColor = false,
							Font = Enum.Font.Gotham,
							Text = optionText,
							TextColor3 = White,
							TextSize = 14,
							ZIndex = 10,
						})
						AddUICorner(optionButton, 6)
						TrackConnection(optionButton.MouseButton1Click:Connect(function()
							if Callback then Callback(optionText) end
							currentOption = optionText
							titleLabel.Text = dropdownTitle .. ": " .. optionText
							dropped = false
							optionsContainer.Visible = false
							arrowButton.Rotation = 0
							CollapseDropdown()
						end))
					end
				end
			end

			if DefaultOption ~= "" and table.find(Options, DefaultOption) then
				if Callback then Callback(DefaultOption) end
				titleLabel.Text = dropdownTitle .. ": " .. DefaultOption
			else
				titleLabel.Text = dropdownTitle .. ": None"
			end

			RefreshOptions(Options)
			TrackConnection(arrowButton.MouseButton1Click:Connect(ToggleDropdown))

			return {
				Refresh = function(_, newOptions)
					Options = newOptions or {}
					RefreshOptions(Options)
				end,
				Add = function(_, option)
					if not table.find(Options, option) then
						Options[#Options + 1] = option
						RefreshOptions(Options)
					end
				end,
				Remove = function(_, option)
					local index = table.find(Options, option)
					if index then
						table.remove(Options, index)
						if currentOption == option then
							currentOption = ""
							titleLabel.Text = dropdownTitle .. ": None"
						end
						RefreshOptions(Options)
					end
				end,
			}
		end

		return elementFactory
	end

	return tabFactory
end

function Library:Destroy()
	for _, tween in ipairs(self.ActiveTweens) do
		if tween then
			tween:Cancel()
			tween:Destroy()
		end
	end
	self.ActiveTweens = {}

	for _, connection in ipairs(self.Connections) do
		if connection and connection.Connected then
			connection:Disconnect()
		end
	end
	self.Connections = {}
	self.TextCache = {}

	for _, child in next, CoreGui:GetChildren() do
		if child.Name:lower():sub(1, 8) == "sentinel" then
			child:Destroy()
		end
	end
end

return Library