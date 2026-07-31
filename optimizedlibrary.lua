local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Debris = cloneref(game:GetService("Debris"))
local TextService = game:GetService("TextService")

local FontGotham = Enum.Font.Gotham
local FontGothamBold = Enum.Font.GothamBold
local EasingStyleQuad = Enum.EasingStyle.Quad
local EasingDirectionOut = Enum.EasingDirection.Out
local UserInputTypeMouseButton1 = Enum.UserInputType.MouseButton1
local UserInputTypeTouch = Enum.UserInputType.Touch
local UserInputTypeMouseMovement = Enum.UserInputType.MouseMovement
local SortOrderLayout = Enum.SortOrder.LayoutOrder
local HorizontalAlignmentCenter = Enum.HorizontalAlignment.Center
local VerticalAlignmentTop = Enum.VerticalAlignment.Top
local TextXAlignmentLeft = Enum.TextXAlignment.Left
local TextXAlignmentRight = Enum.TextXAlignment.Right
local TextYAlignmentTop = Enum.TextYAlignment.Top
local TextWrapped = true
local TextTruncateAtEnd = Enum.TextTruncate.AtEnd
local ZIndexBehaviorSibling = Enum.ZIndexBehavior.Sibling

local ColorWhite = Color3.fromRGB(255, 255, 255)
local ColorLightGray = Color3.fromRGB(200, 200, 200)
local ColorGray = Color3.fromRGB(166, 166, 166)
local ColorDarkGray = Color3.fromRGB(120, 120, 130)
local ColorPurple = Color3.fromRGB(147, 51, 234)
local ColorDarkPurple = Color3.fromRGB(138, 43, 226)
local ColorDarkerPurple = Color3.fromRGB(116, 39, 188)
local ColorBackground = Color3.fromRGB(28, 28, 32)
local ColorTopBar = Color3.fromRGB(24, 24, 28)
local ColorElementBg = Color3.fromRGB(35, 35, 40)
local ColorElementHover = Color3.fromRGB(45, 45, 50)
local ColorBarBg = Color3.fromRGB(50, 50, 55)
local ColorInputBg = Color3.fromRGB(40, 40, 45)
local ColorError = Color3.fromRGB(231, 76, 60)

local TweenNormal = TweenInfo.new(0.2, EasingStyleQuad, EasingDirectionOut)
local TweenFast = TweenInfo.new(0.1, EasingStyleQuad, EasingDirectionOut)

local Library = {
	Connections = {},
	ActiveTweens = {},
}

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
	}
}

local Insert = table.insert
local Remove = table.remove
local Find = table.find
local MathClamp = math.clamp
local MathMax = math.max
local MathMin = math.min
local MathFloor = math.floor
local StringGsub = string.gsub
local StringFind = string.find
local TaskDelay = task.delay
local TaskCancel = task.cancel
local TaskDefer = task.defer
local Pairs = pairs
local IPairs = ipairs
local Type = type

local function Create(ClassName, Properties)
	local Instance = Instance.new(ClassName)
	for Prop, Value in Pairs(Properties) do
		Instance[Prop] = Value
	end
	return Instance
end

local function AddUICorner(Parent, Radius)
	return Create("UICorner", {CornerRadius = UDim.new(0, Radius or 8), Parent = Parent})
end

local function TrackConnection(Connection)
	Insert(Library.Connections, Connection)
	return Connection
end

local function CreateTween(Object, TweenInfo, Properties)
	local Tween = TweenService:Create(Object, TweenInfo, Properties)
	Insert(Library.ActiveTweens, Tween)
	Tween.Completed:Connect(function()
		local Index = Find(Library.ActiveTweens, Tween)
		if Index then
			Remove(Library.ActiveTweens, Index)
		end
		Tween:Destroy()
	end)
	return Tween
end

local Children = CoreGui:GetChildren()
for i = #Children, 1, -1 do
	local child = Children[i]
	if child.Name:lower():sub(1, 8) == "sentinel" then
		child:Destroy()
	end
end

local function SetupDrag(Frame, Target)
	local Dragging, DragStart, StartPos
	TrackConnection(Frame.InputBegan:Connect(function(Input)
		local inputType = Input.UserInputType
		if inputType == UserInputTypeMouseButton1 or inputType == UserInputTypeTouch then
			Dragging = true
			DragStart = Input.Position
			StartPos = Target.Position
			TrackConnection(Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end))
		end
	end))

	TrackConnection(UserInputService.InputChanged:Connect(function(Input)
		if Dragging then
			local inputType = Input.UserInputType
			if inputType == UserInputTypeMouseMovement or inputType == UserInputTypeTouch then
				local Delta = Input.Position - DragStart
				Target.Position = UDim2.new(
					StartPos.X.Scale, StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
				)
			end
		end
	end))
end

local Notifications = {
	Active = 0,
	Max = 3,
}

local NotificationUI = Create("ScreenGui", {
	Name = "sentinel-notifications",
	Parent = CoreGui,
	ZIndexBehavior = ZIndexBehaviorSibling,
	ResetOnSpawn = false,
	DisplayOrder = 10
})

local NotificationHolder = Create("Frame", {
	Name = "NotificationHolder",
	Parent = NotificationUI,
	AnchorPoint = Vector2.new(1, 0),
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -10, 0, 10),
	Size = UDim2.new(0, 320, 0, 0),
	ZIndex = 10
})
Create("UIListLayout", {
	Parent = NotificationHolder,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	VerticalAlignment = VerticalAlignmentTop,
	SortOrder = SortOrderLayout,
	Padding = UDim.new(0, 8)
})

function Library:Notify(Config)
	if Notifications.Active >= Notifications.Max then
		return
	end

	Config = Config or {}
	local Title = Config.Title
	if not Title or Title == "" then
		Title = "Notification"
	end

	local Desc = Config.Description
	if not Desc or Desc == "" then
		Desc = "No description provided"
	end

	local Duration = Config.Duration or 5
	local Type = Config.Type or "info"
	local typeKey = Type:gsub("^%l", string.upper)
	local Accent = Theme.Colors[typeKey] or Theme.Colors.Info
	local Icon = Theme.Icons[typeKey] or Theme.Icons.Info

	local Notification = Create("Frame", {
		Name = "Notification",
		Parent = NotificationHolder,
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		ZIndex = 10
	})
	AddUICorner(Notification, 8)
	Create("UIStroke", {
		Parent = Notification,
		Color = Accent,
		Thickness = 2,
		LineJoinMode = Enum.LineJoinMode.Round
	})
	Create("ImageLabel", {
		Name = "Icon",
		Parent = Notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 12),
		Size = UDim2.new(0, 22, 0, 22),
		Image = Icon,
		ImageColor3 = Accent,
		ZIndex = 10
	})

	local Content = Create("Frame", {
		Name = "Content",
		Parent = Notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 42, 0, 12),
		Size = UDim2.new(1, -80, 1, -24),
		ZIndex = 10
	})
	Create("TextLabel", {
		Name = "Title",
		Parent = Content,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		Font = FontGothamBold,
		Text = Title,
		TextColor3 = ColorWhite,
		TextSize = 13,
		TextXAlignment = TextXAlignmentLeft,
		TextYAlignment = TextYAlignmentTop,
		TextTruncate = TextTruncateAtEnd,
		ZIndex = 10
	})
	Create("TextLabel", {
		Name = "Description",
		Parent = Content,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 18),
		Size = UDim2.new(1, 0, 1, -18),
		Font = FontGotham,
		Text = Desc,
		TextColor3 = ColorLightGray,
		TextSize = 11,
		TextWrapped = TextWrapped,
		TextXAlignment = TextXAlignmentLeft,
		TextYAlignment = TextYAlignmentTop,
		ZIndex = 10
	})

	local CloseBtn = Create("ImageButton", {
		Name = "Close",
		Parent = Notification,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -10, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://6035047409",
		ImageColor3 = ColorGray,
		AutoButtonColor = false,
		ZIndex = 10
	})

	local ContentWidth = NotificationHolder.AbsoluteSize.X - 80
	local DescHeight = TextService:GetTextSize(Desc, 11, FontGotham, Vector2.new(ContentWidth, math.huge)).Y
	local TotalHeight = MathMax(60, MathMin(90, 46 + DescHeight))
	CreateTween(Notification, TweenNormal, {Size = UDim2.new(1, 0, 0, TotalHeight)}):Play()
	Notifications.Active = Notifications.Active + 1

	local Closed = false
	local function Close()
		if Closed or not Notification.Parent then
			return
		end
		Closed = true
		Notifications.Active = MathMax(0, Notifications.Active - 1)
		local CloseTween = CreateTween(Notification, TweenFast, {Size = UDim2.new(1, 0, 0, 0)})
		CloseTween:Play()
		Debris:AddItem(Notification, 0.15)
	end

	TrackConnection(CloseBtn.MouseButton1Click:Connect(Close))
	TaskDelay(Duration, Close)
end

function Library:Window(Title)
	local UI = Create("ScreenGui", {
		Name = "sentinel-library",
		Parent = CoreGui,
		ZIndexBehavior = ZIndexBehaviorSibling,
		ResetOnSpawn = false
	})

	local Main = Create("Frame", {
		Name = "Main",
		Parent = UI,
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 530, 0, 320),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Active = true,
		Selectable = true
	})
	AddUICorner(Main, 10)
	Create("UIStroke", {
		Parent = Main,
		Color = Color3.fromRGB(20, 20, 24),
		Transparency = 0.3,
		Thickness = 1.5,
		LineJoinMode = Enum.LineJoinMode.Round
	})
	SetupDrag(Main, Main)

	local Top = Create("Frame", {
		Name = "Top",
		Parent = Main,
		BackgroundColor3 = ColorTopBar,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 38)
	})
	AddUICorner(Top, 10)
	Create("Frame", {
		Name = "Cover",
		Parent = Top,
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = ColorTopBar,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 6)
	})
	Create("Frame", {
		Name = "Line",
		Parent = Top,
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundColor3 = ColorWhite,
		BackgroundTransparency = 0.92,
		Position = UDim2.new(0.5, 0, 1, 1),
		Size = UDim2.new(1, 0, 0, 1)
	})
	Create("ImageLabel", {
		Name = "Logo",
		Parent = Top,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 8, 0.5, 0),
		Size = UDim2.new(0, 26, 0, 30),
		Image = "rbxassetid://7803241868",
		ImageColor3 = ColorPurple
	})

	local MinimizeBtn = Create("ImageButton", {
		Name = "Minimize",
		Parent = Top,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -40, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://118026365011536",
		ImageColor3 = ColorGray
	})

	local CloseBtn = Create("ImageButton", {
		Name = "Close",
		Parent = Top,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://6035047409",
		ImageColor3 = ColorGray,
		AutoButtonColor = false
	})
	TrackConnection(CloseBtn.MouseEnter:Connect(function()
		CreateTween(CloseBtn, TweenFast, {ImageColor3 = ColorError}):Play()
	end))
	TrackConnection(CloseBtn.MouseLeave:Connect(function()
		CreateTween(CloseBtn, TweenFast, {ImageColor3 = ColorGray}):Play()
	end))

	local Overlay = Create("TextButton", {
		Name = "Overlay",
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 99,
		Text = "",
		AutoButtonColor = false,
		Active = true,
		Modal = true,
		Visible = false
	})
	AddUICorner(Overlay, 10)

	local ConfirmDialog = Create("Frame", {
		Name = "ConfirmDialog",
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 300, 0, 140),
		ZIndex = 100,
		Visible = false
	})
	AddUICorner(ConfirmDialog, 10)
	Create("UIStroke", {
		Parent = ConfirmDialog,
		Color = ColorPurple,
		Thickness = 2,
		LineJoinMode = Enum.LineJoinMode.Round
	})
	Create("TextLabel", {
		Name = "Title",
		Parent = ConfirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 15),
		Size = UDim2.new(1, 0, 0, 25),
		Font = FontGothamBold,
		Text = "Close UI?",
		TextColor3 = ColorWhite,
		TextSize = 16,
		ZIndex = 101
	})
	Create("TextLabel", {
		Name = "Description",
		Parent = ConfirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 45),
		Size = UDim2.new(1, 0, 0, 30),
		Font = FontGotham,
		Text = "This will destroy the UI.\nAre you sure?",
		TextColor3 = ColorLightGray,
		TextSize = 13,
		TextWrapped = TextWrapped,
		ZIndex = 101
	})

	local ButtonContainer = Create("Frame", {
		Name = "ButtonContainer",
		Parent = ConfirmDialog,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 85),
		Size = UDim2.new(1, -40, 0, 40),
		ZIndex = 101
	})

	local CancelBtn = Create("TextButton", {
		Name = "Cancel",
		Parent = ButtonContainer,
		BackgroundColor3 = ColorElementBg,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.48, 0, 1, 0),
		AutoButtonColor = false,
		Font = FontGothamBold,
		Text = "Cancel",
		TextColor3 = ColorWhite,
		TextSize = 14,
		ZIndex = 102
	})
	AddUICorner(CancelBtn, 8)

	local ConfirmBtn = Create("TextButton", {
		Name = "Confirm",
		Parent = ButtonContainer,
		BackgroundColor3 = ColorDarkerPurple,
		BorderSizePixel = 0,
		Position = UDim2.new(0.52, 0, 0, 0),
		Size = UDim2.new(0.48, 0, 1, 0),
		AutoButtonColor = false,
		Font = FontGothamBold,
		Text = "Close",
		TextColor3 = ColorWhite,
		TextSize = 14,
		ZIndex = 102
	})
	AddUICorner(ConfirmBtn, 8)
	TrackConnection(CancelBtn.MouseEnter:Connect(function()
		CreateTween(CancelBtn, TweenFast, {BackgroundColor3 = ColorElementHover}):Play()
	end))
	TrackConnection(CancelBtn.MouseLeave:Connect(function()
		CreateTween(CancelBtn, TweenFast, {BackgroundColor3 = ColorElementBg}):Play()
	end))
	TrackConnection(ConfirmBtn.MouseEnter:Connect(function()
		CreateTween(ConfirmBtn, TweenFast, {BackgroundColor3 = ColorDarkPurple}):Play()
	end))
	TrackConnection(ConfirmBtn.MouseLeave:Connect(function()
		CreateTween(ConfirmBtn, TweenFast, {BackgroundColor3 = ColorDarkerPurple}):Play()
	end))
	TrackConnection(CancelBtn.MouseButton1Click:Connect(function()
		Overlay.Visible = false
		ConfirmDialog.Visible = false
	end))
	TrackConnection(ConfirmBtn.MouseButton1Click:Connect(function()
		Library:Destroy()
	end))
	TrackConnection(CloseBtn.MouseButton1Click:Connect(function()
		Overlay.Visible = true
		ConfirmDialog.Visible = true
	end))

	local MinimizedIcon = Create("ImageButton", {
		Name = "MinimizedIcon",
		Parent = UI,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = ColorPurple,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -20, 0, 20),
		Size = UDim2.new(0, 40, 0, 40),
		Visible = false,
		ZIndex = 10,
		Image = "rbxassetid://7803241868"
	})
	AddUICorner(MinimizedIcon, 10)
	SetupDrag(MinimizedIcon, MinimizedIcon)
	TrackConnection(MinimizeBtn.MouseButton1Click:Connect(function()
		Main.Visible = false
		MinimizedIcon.Visible = true
	end))
	TrackConnection(MinimizedIcon.MouseButton1Click:Connect(function()
		Main.Visible = true
		MinimizedIcon.Visible = false
	end))

	Create("TextLabel", {
		Name = "GameName",
		Parent = Top,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 36, 0.5, 0),
		Size = UDim2.new(0, 165, 0, 22),
		Font = FontGotham,
		Text = Title or "SentinelLIB",
		TextColor3 = ColorPurple,
		TextSize = 14,
		TextXAlignment = TextXAlignmentLeft
	})

	local Tabs = Create("Frame", {
		Name = "Tabs",
		Parent = Main,
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 39),
		Size = UDim2.new(0, 124, 1, -39)
	})
	AddUICorner(Tabs, 10)
	Create("Frame", {
		Name = "Cover",
		Parent = Tabs,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 6, 1, 0)
	})

	local TabsContainer = Create("ScrollingFrame", {
		Name = "TabsContainer",
		Parent = Tabs,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 0
	})

	local TabsList = Create("UIListLayout", {
		Parent = TabsContainer,
		HorizontalAlignment = HorizontalAlignmentCenter,
		SortOrder = SortOrderLayout,
		Padding = UDim.new(0, 6)
	})
	Create("UIPadding", {Parent = TabsContainer, PaddingTop = UDim.new(0, 8)})

	local ResizeDebounce
	TrackConnection(TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if ResizeDebounce then
			TaskCancel(ResizeDebounce)
		end
		ResizeDebounce = TaskDelay(0.03, function()
			TabsContainer.CanvasSize = UDim2.new(0, 0, 0, TabsList.AbsoluteContentSize.Y + 16)
		end)
	end))

	local Pages = Create("Frame", {
		Name = "Pages",
		Parent = Main,
		BackgroundColor3 = ColorBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 132, 0, 46),
		Size = UDim2.new(1, -140, 1, -54)
	})
	AddUICorner(Pages, 8)

	local TabContents = {}
	local FirstTabCreated = false

	function TabContents:Tab(TabTitle)
		local Button = Create("TextButton", {
			Name = "TabButton",
			Parent = TabsContainer,
			BackgroundColor3 = ColorPurple,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -14, 0, 32),
			AutoButtonColor = false,
			Font = FontGotham,
			Text = "",
			TextSize = 14
		})
		AddUICorner(Button, 8)

		local TextLabel = Create("TextLabel", {
			Name = "TextLabel",
			Parent = Button,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = FontGotham,
			Text = TabTitle or "Tab",
			TextColor3 = ColorDarkGray,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Center
		})

		local Page = Create("ScrollingFrame", {
			Name = "Page",
			Visible = false,
			Parent = Pages,
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarThickness = 0
		})

		local PageList = Create("UIListLayout", {
			Parent = Page,
			HorizontalAlignment = HorizontalAlignmentCenter,
			SortOrder = SortOrderLayout,
			Padding = UDim.new(0, 3)
		})
		Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 8)})

		local PageResizeDebounce
		TrackConnection(PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if PageResizeDebounce then
				TaskCancel(PageResizeDebounce)
			end
			PageResizeDebounce = TaskDelay(0.03, function()
				if Page.Visible then
					Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 16)
				end
			end)
		end))

		TrackConnection(Page:GetPropertyChangedSignal("Visible"):Connect(function()
			if Page.Visible then
				TaskWait(0.01)
				Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 16)
			end
		end))

		TrackConnection(Button.MouseButton1Click:Connect(function()
			for _, Child in IPairs(Pages:GetChildren()) do
				if Child:IsA("ScrollingFrame") then
					Child.Visible = false
				end
			end

			for _, Child in IPairs(TabsContainer:GetChildren()) do
				if Child.Name == "TabButton" then
					CreateTween(Child, TweenNormal, {BackgroundTransparency = 1}):Play()
					local Label = Child:FindFirstChild("TextLabel")
					if Label then
						CreateTween(Label, TweenNormal, {TextColor3 = ColorDarkGray}):Play()
					end
				end
			end

			Page.Visible = true
			CreateTween(Button, TweenNormal, {BackgroundTransparency = 0.6}):Play()
			CreateTween(TextLabel, TweenNormal, {TextColor3 = ColorWhite}):Play()
		end))

		local Elements = {}

		function Elements:Button(Text, Callback)
			local Btn = Create("TextButton", {
				Name = "Button",
				Parent = Page,
				BackgroundColor3 = ColorDarkerPurple,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				AutoButtonColor = false,
				Font = FontGotham,
				Text = Text or "Button",
				TextColor3 = ColorWhite,
				TextSize = 14
			})
			AddUICorner(Btn, 8)
			TrackConnection(Btn.MouseEnter:Connect(function()
				CreateTween(Btn, TweenNormal, {BackgroundColor3 = ColorDarkPurple}):Play()
			end))
			TrackConnection(Btn.MouseLeave:Connect(function()
				CreateTween(Btn, TweenNormal, {BackgroundColor3 = ColorDarkerPurple}):Play()
			end))
			TrackConnection(Btn.MouseButton1Click:Connect(Callback))
		end

		function Elements:Toggle(Text, Default, Callback)
			local Toggle = Create("TextButton", {
				Name = "Toggle",
				Parent = Page,
				BackgroundColor3 = ColorElementBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				AutoButtonColor = false,
				Text = ""
			})
			AddUICorner(Toggle, 8)
			Create("TextLabel", {
				Name = "Title",
				Parent = Toggle,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -50, 1, 0),
				Font = FontGotham,
				Text = Text or "Toggle",
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextXAlignment = TextXAlignmentLeft
			})

			local ToggleFrame = Create("Frame", {
				Name = "ToggleFrame",
				Parent = Toggle,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = ColorDarkPurple,
				BackgroundTransparency = Default and 0 or 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20)
			})
			Create("UIStroke", {
				Parent = ToggleFrame,
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = 2,
				Color = ColorDarkPurple
			})
			AddUICorner(ToggleFrame, 10)

			local Toggled = Default or false
			TrackConnection(Toggle.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				CreateTween(ToggleFrame, TweenFast, {BackgroundTransparency = Toggled and 0 or 1}):Play()
				if Callback then
					Callback(Toggled)
				end
			end))

			return {
				Set = function(_, Value)
					Toggled = Value
					ToggleFrame.BackgroundTransparency = Toggled and 0 or 1
					if Callback then
						Callback(Toggled)
					end
				end
			}
		end

		function Elements:Label(Text)
			local Label = Create("TextLabel", {
				Parent = Page,
				BackgroundColor3 = ColorElementBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				Font = FontGotham,
				Text = Text or "Label",
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextWrapped = TextWrapped
			})
			AddUICorner(Label, 8)
			Create("UIPadding", {
				Parent = Label,
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			})

			local SizeDebounce
			local function UpdateSize(Txt)
				if SizeDebounce then
					TaskCancel(SizeDebounce)
				end
				SizeDebounce = TaskDelay(0.02, function()
					local ContentWidth = Label.AbsoluteSize.X - 20
					if ContentWidth > 0 then
						local TextHeight = TextService:GetTextSize(Txt, 14, FontGotham, Vector2.new(ContentWidth, math.huge)).Y
						local TotalHeight = MathMax(36, TextHeight + 20)
						Label.Size = UDim2.new(1, -10, 0, TotalHeight)
					end
				end)
			end

			TrackConnection(Label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				UpdateSize(Label.Text)
			end))
			TaskDefer(function()
				UpdateSize(Text or "Label")
			end)

			return {
				Set = function(_, NewText)
					Label.Text = NewText or "Label"
					UpdateSize(NewText or "Label")
				end
			}
		end

		function Elements:Slider(Text, Min, Max, Default, Increment, Callback)
			Min = Min or 0
			Max = Max or 100
			Default = Default or Min
			Increment = Increment or 1

			local Slider = Create("Frame", {
				Name = "Slider",
				Parent = Page,
				BackgroundColor3 = ColorElementBg,
				Size = UDim2.new(1, -10, 0, 52)
			})
			AddUICorner(Slider, 8)
			Create("TextLabel", {
				Name = "Title",
				Parent = Slider,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -6, 0, 36),
				Font = FontGotham,
				Text = Text or "Slider",
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextXAlignment = TextXAlignmentLeft
			})

			local Value = Create("TextLabel", {
				Name = "Value",
				Parent = Slider,
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0, 0),
				Size = UDim2.new(1, 0, 0, 36),
				Font = FontGotham,
				Text = tostring(Default),
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextXAlignment = TextXAlignmentRight
			})

			local Bar = Create("Frame", {
				Name = "Bar",
				Parent = Slider,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = ColorBarBg,
				Position = UDim2.new(0.5, 0, 1, -10),
				Size = UDim2.new(1, -16, 0, 8)
			})
			AddUICorner(Bar, 8)

			local Fill = Create("Frame", {
				Name = "Fill",
				Parent = Bar,
				BackgroundColor3 = ColorDarkPurple,
				Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
			})
			AddUICorner(Fill, 8)

			local Dragging, PendingCallback, LastValue = false, false, Default
			local Range = Max - Min
			local Precision = 1000000
			local function Round(Val)
				if Increment == 0 then
					return Val
				end
				return MathFloor((MathFloor(Val / Increment + 0.5) * Increment) * Precision + 0.5) / Precision
			end

			local function Format(Val)
				local Rounded = MathFloor(Val * Precision + 0.5) / Precision
				local Str = tostring(Rounded)
				if StringFind(Str, "%.") then
					Str = StringGsub(Str, "0+$", ""):gsub("%.$", "")
				end
				return Str
			end

			local function Update(Percent, CallNow)
				local Val = Round(Min + (Percent * Range))
				local Adj = (Val - Min) / Range
				Fill.Size = UDim2.new(Adj, 0, 1, 0)
				Value.Text = Format(Val)
				if Val ~= LastValue then
					LastValue = Val
					if CallNow and Callback then
						Callback(Val)
					else
						PendingCallback = true
					end
				end
			end

			local function Slide(Input)
				local Percent = MathClamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				Update(Percent, false)
			end

			TrackConnection(Bar.InputBegan:Connect(function(Input)
				local inputType = Input.UserInputType
				if inputType == UserInputTypeMouseButton1 or inputType == UserInputTypeTouch then
					Dragging = true
					Slide(Input)
					TrackConnection(Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							Dragging = false
							if PendingCallback and Callback then
								Callback(LastValue)
								PendingCallback = false
							end
						end
					end))
				end
			end))

			TrackConnection(UserInputService.InputChanged:Connect(function(Input)
				if Dragging then
					local inputType = Input.UserInputType
					if inputType == UserInputTypeMouseMovement or inputType == UserInputTypeTouch then
						Slide(Input)
					end
				end
			end))

			return {
				Set = function(_, Val)
					Val = MathClamp(Val, Min, Max)
					local Adj = (Val - Min) / Range
					Update(Adj, true)
				end
			}
		end

		function Elements:InputBox(Text, Placeholder, Callback)
			local InputBox = Create("Frame", {
				Name = "InputBox",
				Parent = Page,
				BackgroundColor3 = ColorElementBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36)
			})
			AddUICorner(InputBox, 8)
			Create("TextLabel", {
				Name = "Title",
				Parent = InputBox,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0.5, -6, 1, 0),
				Font = FontGotham,
				Text = Text or "Input",
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextXAlignment = TextXAlignmentLeft
			})

			local BoxContainer = Create("Frame", {
				Name = "BoxContainer",
				Parent = InputBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0.45, -12, 0, 28)
			})

			local Box = Create("TextBox", {
				Name = "Box",
				Parent = BoxContainer,
				BackgroundColor3 = ColorInputBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				ClipsDescendants = true,
				Font = FontGotham,
				Text = "",
				PlaceholderText = Placeholder or "",
				PlaceholderColor3 = ColorGray,
				TextColor3 = ColorWhite,
				TextSize = 14
			})
			AddUICorner(Box, 6)
			TrackConnection(Box.FocusLost:Connect(function(Enter)
				if Callback and Enter then
					Callback(Box.Text)
				end
			end))
		end

		function Elements:Dropdown(Text, DefaultOption, Options, Callback)
			if Type(DefaultOption) == "table" then
				Callback = Options
				Options = DefaultOption
				DefaultOption = ""
			elseif Type(DefaultOption) == "string" and Type(Options) == "table" then
			else
				Options = Options or {}
				DefaultOption = DefaultOption or ""
			end

			Options = Options or {}
			DefaultOption = DefaultOption or ""
			if Callback and Type(Callback) ~= "function" then
				Callback = nil
			end

			local Dropdown = Create("Frame", {
				Name = "Dropdown",
				Parent = Page,
				BackgroundColor3 = ColorElementBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -10, 0, 36),
				ClipsDescendants = true,
				ZIndex = 10
			})
			AddUICorner(Dropdown, 8)

			local Choose = Create("Frame", {
				Name = "Choose",
				Parent = Dropdown,
				BackgroundColor3 = ColorElementBg,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 36),
				ZIndex = 11
			})
			AddUICorner(Choose, 8)

			local Title = Create("TextLabel", {
				Name = "Title",
				Parent = Choose,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -46, 1, 0),
				Font = FontGotham,
				Text = Text or "Dropdown",
				TextColor3 = ColorWhite,
				TextSize = 14,
				TextXAlignment = TextXAlignmentLeft,
				ZIndex = 11
			})

			local Arrow = Create("ImageButton", {
				Name = "Arrow",
				Parent = Choose,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://6031091004",
				ImageColor3 = ColorDarkPurple,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 11
			})

			local OptionsContainer = Create("ScrollingFrame", {
				Name = "OptionsContainer",
				Parent = Dropdown,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 42),
				Size = UDim2.new(1, 0, 1, -42),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false,
				ZIndex = 10
			})

			local OptionList = Create("UIListLayout", {
				Parent = OptionsContainer,
				HorizontalAlignment = HorizontalAlignmentCenter,
				SortOrder = SortOrderLayout,
				Padding = UDim.new(0, 4)
			})
			Create("UIPadding", {
				Parent = OptionsContainer,
				PaddingTop = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6)
			})

			local DropdownResizeDebounce
			TrackConnection(OptionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if DropdownResizeDebounce then
					TaskCancel(DropdownResizeDebounce)
				end
				DropdownResizeDebounce = TaskDelay(0.02, function()
					if not OptionsContainer.Visible then
						return
					end
					local ContentHeight = OptionList.AbsoluteContentSize.Y + 12
					OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
					local MaxDropdownHeight = 150
					local TotalHeight = 42 + MathMin(ContentHeight, MaxDropdownHeight)
					Dropdown.Size = UDim2.new(1, -10, 0, TotalHeight)
				end)
			end))

			local Dropped = false
			local CurrentOption = DefaultOption
			local DropdownText = Text or "Dropdown"

			if DefaultOption ~= "" and Find(Options, DefaultOption) then
				if Callback then
					Callback(DefaultOption)
				end
				Title.Text = DropdownText .. ": " .. DefaultOption
			else
				Title.Text = DropdownText .. ": None"
			end

			local MaxDropdownHeight = 150
			local CollapsedHeight = 36

			local function UpdatePageCanvas()
				TaskWait(0.01)
				Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 16)
			end

			local function ExpandDropdown()
				local ContentHeight = OptionList.AbsoluteContentSize.Y + 12
				OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
				local TotalHeight = 42 + MathMin(ContentHeight, MaxDropdownHeight)
				Dropdown.Size = UDim2.new(1, -10, 0, TotalHeight)
				UpdatePageCanvas()
			end

			local function CollapseDropdown()
				Dropdown.Size = UDim2.new(1, -10, 0, CollapsedHeight)
				UpdatePageCanvas()
			end

			local function ToggleDropdown()
				Dropped = not Dropped
				OptionsContainer.Visible = Dropped
				Arrow.Rotation = Dropped and 180 or 0
				if Dropped then
					ExpandDropdown()
				else
					CollapseDropdown()
				end
			end

			local function Refresh(NewOpts)
				NewOpts = NewOpts or {}
				local children = OptionsContainer:GetChildren()
				for i = #children, 1, -1 do
					local child = children[i]
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end

				if #NewOpts == 0 then
					local NoOpt = Create("TextButton", {
						Name = "NoOption",
						Parent = OptionsContainer,
						BackgroundColor3 = ColorBarBg,
						BorderSizePixel = 0,
						Size = UDim2.new(1, -12, 0, 30),
						Font = FontGotham,
						Text = "No Options Available",
						TextColor3 = ColorGray,
						TextSize = 14,
						AutoButtonColor = false,
						ZIndex = 10
					})
					AddUICorner(NoOpt, 6)
				else
					for _, Opt in IPairs(NewOpts) do
						local Btn = Create("TextButton", {
							Name = "Option",
							Parent = OptionsContainer,
							BackgroundColor3 = ColorDarkerPurple,
							BorderSizePixel = 0,
							Size = UDim2.new(1, -12, 0, 30),
							AutoButtonColor = false,
							Font = FontGotham,
							Text = Opt,
							TextColor3 = ColorWhite,
							TextSize = 14,
							ZIndex = 10
						})
						AddUICorner(Btn, 6)
						TrackConnection(Btn.MouseButton1Click:Connect(function()
							if Callback then
								Callback(Opt)
							end
							CurrentOption = Opt
							Title.Text = DropdownText .. ": " .. Opt
							Dropped = false
							OptionsContainer.Visible = false
							Arrow.Rotation = 0
							CollapseDropdown()
						end))
					end
				end
			end

			Refresh(Options)
			TrackConnection(Arrow.MouseButton1Click:Connect(ToggleDropdown))

			return {
				Refresh = function(_, NewOpts)
					Options = NewOpts or {}
					Refresh(Options)
				end,
				Add = function(_, Option)
					if not Find(Options, Option) then
						Insert(Options, Option)
						Refresh(Options)
					end
				end,
				Remove = function(_, Option)
					local Index = Find(Options, Option)
					if Index then
						Remove(Options, Index)
						if CurrentOption == Option then
							CurrentOption = ""
							Title.Text = DropdownText .. ": None"
						end
						Refresh(Options)
					end
				end
			}
		end

		if not FirstTabCreated then
			FirstTabCreated = true
			Page.Visible = true
			Button.BackgroundTransparency = 0.6
			TextLabel.TextColor3 = ColorWhite
		end

		return Elements
	end

	return TabContents
end

function Library:Destroy()
	for _, Tween in IPairs(self.ActiveTweens) do
		if Tween then
			Tween:Cancel()
			Tween:Destroy()
		end
	end
	self.ActiveTweens = {}

	for _, Conn in IPairs(self.Connections) do
		if Conn and Conn.Connected then
			Conn:Disconnect()
		end
	end
	self.Connections = {}

	for _, child in IPairs(CoreGui:GetChildren()) do
		if child.Name:lower():sub(1, 8) == "sentinel" then
			child:Destroy()
		end
	end
end

return Library