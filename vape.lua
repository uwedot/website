local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local RainbowState = {Value = 0, HuePos = 0}
RunService.RenderStepped:Connect(function(DeltaTime)
	RainbowState.Value += DeltaTime * 0.5
	if RainbowState.Value >= 1 then RainbowState.Value = 0 end
	RainbowState.HuePos = (RainbowState.HuePos + 1) % 80
end)

local function CreateTween(InstanceTarget, Properties, Duration, Style, Direction)
	TweenService:Create(InstanceTarget, TweenInfo.new(Duration, Style or Enum.EasingStyle.Quart, Direction or Enum.EasingDirection.Out), Properties):Play()
end

local function MakeDraggable(TriggerObject, TargetObject)
	local IsDragging = false
	local DragInput = nil
	local DragStart = Vector2.zero
	local StartPosition = UDim2.new()

	TriggerObject.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsDragging = true
			DragStart = Input.Position
			StartPosition = TargetObject.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then IsDragging = false end
			end)
		end
	end)

	TriggerObject.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if IsDragging and Input == DragInput then
			local Delta = Input.Position - DragStart
			TargetObject.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

local Library = {}
Library.__index = Library

function Library.Window(TitleText: string, PresetColor: Color3?, CloseBind: Enum.KeyCode?): table
	local ActiveColor = PresetColor or Color3.fromRGB(44, 120, 224)
	local ToggleKey = CloseBind or Enum.KeyCode.RightControl
	local IsOpen = true

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "DebloatUI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainFrame = Instance.new("Frame")
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local DragRegion = Instance.new("Frame")
	DragRegion.BackgroundTransparency = 1
	DragRegion.Size = UDim2.new(1, 0, 0, 41)
	DragRegion.Parent = MainFrame
	MakeDraggable(DragRegion, MainFrame)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0.034, 0, 0.056, 0)
	TitleLabel.Size = UDim2.new(0, 200, 0, 23)
	TitleLabel.Font = Enum.Font.GothamSemibold
	TitleLabel.Text = TitleText
	TitleLabel.TextColor3 = Color3.fromRGB(68, 68, 68)
	TitleLabel.TextSize = 12
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = MainFrame

	local TabFolder = Instance.new("Folder")
	TabFolder.Name = "TabFolder"
	TabFolder.Parent = MainFrame

	local TabButtonHolder = Instance.new("Frame")
	TabButtonHolder.BackgroundTransparency = 1
	TabButtonHolder.Position = UDim2.new(0.034, 0, 0.147, 0)
	TabButtonHolder.Size = UDim2.new(0, 107, 0, 254)
	TabButtonHolder.Parent = MainFrame

	local TabButtonLayout = Instance.new("UIListLayout")
	TabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabButtonLayout.Padding = UDim.new(0, 11)
	TabButtonLayout.Parent = TabButtonHolder

	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed or Input.KeyCode ~= ToggleKey then return end
		IsOpen = not IsOpen
		CreateTween(MainFrame, {Size = IsOpen and UDim2.new(0, 560, 0, 319) or UDim2.new(0, 0, 0, 0)}, 0.6)
		task.wait(0.5)
		ScreenGui.Enabled = IsOpen
	end)

	task.defer(function() CreateTween(MainFrame, {Size = UDim2.new(0, 560, 0, 319)}, 0.6) end)

	local WindowApi = {}
	local IsFirstTab = true

	function WindowApi.Tab(TabName: string): table
		local TabButton = Instance.new("TextButton")
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(0, 107, 0, 21)
		TabButton.Text = ""
		TabButton.Parent = TabButtonHolder

		local Indicator = Instance.new("Frame")
		Indicator.BackgroundColor3 = ActiveColor
		Indicator.BorderSizePixel = 0
		Indicator.Position = UDim2.new(0, 0, 1, 0)
		Indicator.Size = UDim2.new(0, 0, 0, 2)
		Indicator.Parent = TabButton
		Instance.new("UICorner", Indicator)

		local TabLabel = Instance.new("TextLabel")
		TabLabel.BackgroundTransparency = 1
		TabLabel.Size = UDim2.new(1, 0, 1, 0)
		TabLabel.Font = Enum.Font.Gotham
		TabLabel.Text = TabName
		TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabLabel.TextSize = 14
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Parent = TabButton

		local ContentFrame = Instance.new("ScrollingFrame")
		ContentFrame.Active = true
		ContentFrame.BackgroundTransparency = 1
		ContentFrame.BorderSizePixel = 0
		ContentFrame.Position = UDim2.new(0.314, 0, 0.147, 0)
		ContentFrame.Size = UDim2.new(0, 373, 0, 254)
		ContentFrame.ScrollBarThickness = 3
		ContentFrame.Visible = false
		ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ContentFrame.Parent = TabFolder

		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 6)
		ContentLayout.Parent = ContentFrame

		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
		end)

		local function SetActive(State: boolean)
			CreateTween(Indicator, {Size = UDim2.new(0, State and 13 or 0, 0, 2)}, 0.2)
			CreateTween(TabLabel, {TextColor3 = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)}, 0.3, Enum.EasingStyle.Quad)
			ContentFrame.Visible = State
		end

		if IsFirstTab then
			SetActive(true)
			IsFirstTab = false
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, Child in TabFolder:GetChildren() do
				if Child:IsA("ScrollingFrame") then Child.Visible = false end
			end
			for _, Child in TabButtonHolder:GetChildren() do
				if Child:IsA("TextButton") then
					local ChildIndicator = Child:FindFirstChildWhichIsA("Frame")
					if ChildIndicator and ChildIndicator ~= Indicator then 
						CreateTween(ChildIndicator, {Size = UDim2.new(0, 0, 0, 2)}, 0.2)
						CreateTween(Child:FindFirstChildOfClass("TextLabel"), {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.3, Enum.EasingStyle.Quad)
					end
				end
			end
			SetActive(true)
		end)

		local TabApi = {}

		function TabApi.Button(ButtonName: string, Callback: () -> ())
			local Button = Instance.new("TextButton")
			Button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Button.Size = UDim2.new(0, 363, 0, 42)
			Button.AutoButtonColor = false
			Button.Text = ""
			Button.Parent = ContentFrame
			Instance.new("UICorner", Button)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = ButtonName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Button

			Button.MouseEnter:Connect(function() CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(37, 37, 37)}, 0.3, Enum.EasingStyle.Quad) end)
			Button.MouseLeave:Connect(function() CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}, 0.2, Enum.EasingStyle.Quad) end)
			Button.MouseButton1Click:Connect(Callback)
		end

		function TabApi.Toggle(ToggleName: string, DefaultState: boolean?, Callback: (boolean) -> ())
			local Toggled = DefaultState or false
			local Button = Instance.new("TextButton")
			Button.BackgroundColor3 = Toggled and Color3.fromRGB(37, 37, 37) or Color3.fromRGB(34, 34, 34)
			Button.Size = UDim2.new(0, 363, 0, 42)
			Button.AutoButtonColor = false
			Button.Text = ""
			Button.Parent = ContentFrame
			Instance.new("UICorner", Button)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = ToggleName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Button

			local Box = Instance.new("Frame")
			Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Box.Position = UDim2.new(0.86, 0, 0.286, 0)
			Box.Size = UDim2.new(0, 37, 0, 18)
			Box.BackgroundTransparency = Toggled and 1 or 0
			Box.Parent = Button
			Instance.new("UICorner", Box)

			local Fill = Instance.new("Frame")
			Fill.BackgroundColor3 = ActiveColor
			Fill.Size = UDim2.new(1, 0, 1, 0)
			Fill.BackgroundTransparency = Toggled and 0 or 1
			Fill.Parent = Box
			Instance.new("UICorner", Fill)

			local Circle = Instance.new("Frame")
			Circle.BackgroundColor3 = Toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)
			-- FIX: Set position immediately based on state, don't rely solely on tween for init
			Circle.Position = Toggled and UDim2.new(0.587, 0, 0.222, 0) or UDim2.new(0.127, 0, 0.222, 0)
			Circle.Size = UDim2.new(0, 10, 0, 10)
			Circle.Parent = Box
			Instance.new("UICorner", Circle)

			local function UpdateVisuals(State: boolean)
				CreateTween(Button, {BackgroundColor3 = State and Color3.fromRGB(37, 37, 37) or Color3.fromRGB(34, 34, 34)}, 0.3, Enum.EasingStyle.Quad)
				CreateTween(Box, {BackgroundTransparency = State and 1 or 0}, 0.3, Enum.EasingStyle.Quad)
				CreateTween(Fill, {BackgroundTransparency = State and 0 or 1}, 0.3, Enum.EasingStyle.Quad)
				CreateTween(Circle, {BackgroundColor3 = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50), Position = State and UDim2.new(0.587, 0, 0.222, 0) or UDim2.new(0.127, 0, 0.222, 0)}, 0.3, Enum.EasingStyle.Quad)
			end

			-- FIX: If default is true, force visuals immediately without waiting for click
			if DefaultState then 
				Circle.Position = UDim2.new(0.587, 0, 0.222, 0)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Box.BackgroundTransparency = 1
				Fill.BackgroundTransparency = 0
				Button.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			end

			Button.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				UpdateVisuals(Toggled)
				Callback(Toggled)
			end)
		end

		function TabApi.Slider(SliderName: string, MinValue: number, MaxValue: number, StartValue: number?, Callback: (number) -> ())
			local CurrentValue = StartValue or MinValue
			local IsDragging = false

			local Slider = Instance.new("Frame")
			Slider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Slider.Size = UDim2.new(0, 363, 0, 60)
			Slider.Parent = ContentFrame
			Instance.new("UICorner", Slider)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = SliderName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Slider

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Position = UDim2.new(0.036, 0, 0, 0)
			ValueLabel.Size = UDim2.new(0, 335, 0, 42)
			ValueLabel.Font = Enum.Font.Gotham
			ValueLabel.Text = tostring(CurrentValue)
			ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValueLabel.TextSize = 14
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = Slider

			local Track = Instance.new("Frame")
			Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Track.BorderSizePixel = 0
			Track.Position = UDim2.new(0.034, 0, 0.686, 0)
			Track.Size = UDim2.new(0, 335, 0, 3)
			Track.Parent = Slider

			local Fill = Instance.new("Frame")
			Fill.BackgroundColor3 = ActiveColor
			Fill.BorderSizePixel = 0
			Fill.Size = UDim2.new((CurrentValue - MinValue) / (MaxValue - MinValue), 0, 1, 0)
			Fill.Parent = Track

			local Handle = Instance.new("ImageButton")
			Handle.BackgroundTransparency = 1
			Handle.Image = "rbxassetid://3570695787"
			Handle.ImageColor3 = ActiveColor
			Handle.Size = UDim2.new(0, 11, 0, 11)
			Handle.AnchorPoint = Vector2.new(0.5, 0.5)
			Handle.Position = UDim2.new((CurrentValue - MinValue) / (MaxValue - MinValue), 0, 0.5, 0)
			Handle.Parent = Track

			local function UpdateSlider(InputPosition: number)
				local Ratio = math.clamp((InputPosition - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
				local NewValue = math.floor(Ratio * (MaxValue - MinValue) + MinValue)
				if NewValue ~= CurrentValue then
					CurrentValue = NewValue
					ValueLabel.Text = tostring(CurrentValue)
					Callback(CurrentValue)
				end
				Fill.Size = UDim2.new(Ratio, 0, 1, 0)
				Handle.Position = UDim2.new(Ratio, 0, 0.5, 0)
			end

			Handle.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsDragging = true
					UpdateSlider(Input.Position.X)
				end
			end)

			Handle.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsDragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					UpdateSlider(Input.Position.X)
				end
			end)
		end

		function TabApi.Dropdown(DropdownName: string, Options: {string}, Callback: (string) -> ())
			local IsOpen = false
			local ItemCount = 0
			local MaxVisibleItems = 3

			local Container = Instance.new("Frame")
			Container.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Container.ClipsDescendants = true
			Container.Size = UDim2.new(0, 363, 0, 42)
			Container.Parent = ContentFrame
			Instance.new("UICorner", Container)

			local Header = Instance.new("TextButton")
			Header.BackgroundTransparency = 1
			Header.Size = UDim2.new(1, 0, 0, 42)
			Header.Text = ""
			Header.Parent = Container

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = DropdownName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Header

			local Arrow = Instance.new("ImageLabel")
			Arrow.BackgroundTransparency = 1
			Arrow.Image = "http://www.roblox.com/asset/?id=6034818375"
			Arrow.Position = UDim2.new(0.9, 0, 0.19, 0)
			Arrow.Size = UDim2.new(0, 26, 0, 26)
			Arrow.Parent = Header

			local ListHolder = Instance.new("ScrollingFrame")
			ListHolder.Active = true
			ListHolder.BackgroundTransparency = 1
			ListHolder.BorderSizePixel = 0
			ListHolder.Position = UDim2.new(0, 0, 1, 0)
			ListHolder.Size = UDim2.new(1, 0, 0, 0)
			ListHolder.ScrollBarThickness = 3
			ListHolder.Parent = Container

			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Parent = ListHolder

			for _, Option in ipairs(Options) do
				ItemCount += 1
				local Item = Instance.new("TextButton")
				Item.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
				Item.Size = UDim2.new(1, -8, 0, 25)
				Item.Position = UDim2.new(0, 4, 0, 0)
				Item.AutoButtonColor = false
				Item.Font = Enum.Font.Gotham
				Item.Text = Option
				Item.TextColor3 = Color3.fromRGB(255, 255, 255)
				Item.TextSize = 15
				Item.Parent = ListHolder
				Instance.new("UICorner", Item)

				Item.MouseEnter:Connect(function() CreateTween(Item, {BackgroundColor3 = Color3.fromRGB(37, 37, 37)}, 0.3, Enum.EasingStyle.Quad) end)
				Item.MouseLeave:Connect(function() CreateTween(Item, {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}, 0.3, Enum.EasingStyle.Quad) end)
				Item.MouseButton1Click:Connect(function()
					Label.Text = DropdownName .. " - " .. Option
					Callback(Option)
					IsOpen = false
					CreateTween(Container, {Size = UDim2.new(0, 363, 0, 42)}, 0.2)
					CreateTween(Arrow, {Rotation = 0}, 0.3, Enum.EasingStyle.Quad)
				end)
			end

			ListHolder.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)

			Header.MouseButton1Click:Connect(function()
				IsOpen = not IsOpen
				local TargetHeight = IsOpen and 42 + math.min(ItemCount, MaxVisibleItems) * 26 or 42
				CreateTween(Container, {Size = UDim2.new(0, 363, 0, TargetHeight)}, 0.2)
				CreateTween(Arrow, {Rotation = IsOpen and 270 or 0}, 0.3, Enum.EasingStyle.Quad)
			end)
		end

		function TabApi.Colorpicker(PickerName: string, DefaultColor: Color3?, Callback: (Color3) -> ())
			local IsOpen = false
			local Hue, Sat, Val = Color3.toHSV(DefaultColor or Color3.fromRGB(255, 0, 4))
			local ColorInput = nil
			local HueInput = nil

			local Container = Instance.new("Frame")
			Container.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Container.ClipsDescendants = true
			Container.Size = UDim2.new(0, 363, 0, 42)
			Container.Parent = ContentFrame
			Instance.new("UICorner", Container)

			local Header = Instance.new("TextButton")
			Header.BackgroundTransparency = 1
			Header.Size = UDim2.new(1, 0, 0, 42)
			Header.Text = ""
			Header.Parent = Container

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = PickerName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Header

			local Preview = Instance.new("Frame")
			Preview.BackgroundColor3 = DefaultColor or Color3.fromRGB(255, 0, 4)
			Preview.Position = UDim2.new(0.85, 0, 0.214, 0)
			Preview.Size = UDim2.new(0, 41, 0, 23)
			Preview.Parent = Header
			Instance.new("UICorner", Preview)

			local ColorArea = Instance.new("ImageLabel")
			ColorArea.Image = "rbxassetid://4155801252"
			ColorArea.Position = UDim2.new(0, 0, 0, 42)
			ColorArea.Size = UDim2.new(0, 194, 0, 80)
			ColorArea.Visible = false
			ColorArea.Parent = Container
			Instance.new("UICorner", ColorArea)

			local ColorSelector = Instance.new("ImageLabel")
			ColorSelector.AnchorPoint = Vector2.new(0.5, 0.5)
			ColorSelector.BackgroundTransparency = 1
			ColorSelector.Image = "http://www.roblox.com/asset/?id=4805639000"
			ColorSelector.Size = UDim2.new(0, 18, 0, 18)
			ColorSelector.Visible = false
			ColorSelector.Parent = ColorArea

			local HueBar = Instance.new("Frame")
			HueBar.Position = UDim2.new(0, 202, 0, 42)
			HueBar.Size = UDim2.new(0, 25, 0, 80)
			HueBar.Visible = false
			HueBar.Parent = Container
			Instance.new("UICorner", HueBar)

			local HueGradient = Instance.new("UIGradient")
			HueGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
				ColorSequenceKeypoint.new(0.2, Color3.fromRGB(234, 255, 0)),
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(21, 255, 0)),
				ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 17, 255)),
				ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 0, 251)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 4))
			})
			HueGradient.Rotation = 270
			HueGradient.Parent = HueBar

			local HueSelector = Instance.new("ImageLabel")
			HueSelector.AnchorPoint = Vector2.new(0.5, 0.5)
			HueSelector.BackgroundTransparency = 1
			HueSelector.Image = "http://www.roblox.com/asset/?id=4805639000"
			HueSelector.Size = UDim2.new(0, 18, 0, 18)
			HueSelector.Visible = false
			HueSelector.Parent = HueBar

			local function UpdateColor()
				local NewColor = Color3.fromHSV(Hue, Sat, Val)
				Preview.BackgroundColor3 = NewColor
				ColorArea.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
				Callback(NewColor)
			end

			local function HandleColorInput(Input)
				Sat = math.clamp((Input.Position.X - ColorArea.AbsolutePosition.X) / ColorArea.AbsoluteSize.X, 0, 1)
				Val = 1 - math.clamp((Input.Position.Y - ColorArea.AbsolutePosition.Y) / ColorArea.AbsoluteSize.Y, 0, 1)
				ColorSelector.Position = UDim2.new(Sat, 0, 1 - Val, 0)
				UpdateColor()
			end

			local function HandleHueInput(Input)
				Hue = 1 - math.clamp((Input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
				HueSelector.Position = UDim2.new(0.5, 0, 1 - Hue, 0)
				UpdateColor()
			end

			ColorArea.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					HandleColorInput(Input)
					ColorInput = RunService.RenderStepped:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							ColorInput:Disconnect()
							return
						end
						HandleColorInput(Input)
					end)
				end
			end)

			ColorArea.InputEnded:Connect(function(Input)
				if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and ColorInput then
					ColorInput:Disconnect()
				end
			end)

			HueBar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					HandleHueInput(Input)
					HueInput = RunService.RenderStepped:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							HueInput:Disconnect()
							return
						end
						HandleHueInput(Input)
					end)
				end
			end)

			HueBar.InputEnded:Connect(function(Input)
				if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and HueInput then
					HueInput:Disconnect()
				end
			end)

			Header.MouseButton1Click:Connect(function()
				IsOpen = not IsOpen
				ColorArea.Visible = IsOpen
				HueBar.Visible = IsOpen
				ColorSelector.Visible = IsOpen
				HueSelector.Visible = IsOpen
				CreateTween(Container, {Size = UDim2.new(0, 363, 0, IsOpen and 132 or 42)}, 0.2)
			end)

			UpdateColor()
		end

		function TabApi.Label(LabelText: string)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			LabelFrame.Size = UDim2.new(0, 363, 0, 42)
			LabelFrame.Parent = ContentFrame
			Instance.new("UICorner", LabelFrame)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = LabelText
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = LabelFrame
		end

		function TabApi.Textbox(TextboxName: string, ClearOnSubmit: boolean?, Callback: (string) -> ())
			local Container = Instance.new("Frame")
			Container.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Container.ClipsDescendants = true
			Container.Size = UDim2.new(0, 363, 0, 42)
			Container.Parent = ContentFrame
			Instance.new("UICorner", Container)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = TextboxName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Container

			local InputFrame = Instance.new("Frame")
			InputFrame.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
			InputFrame.Position = UDim2.new(0.65, 0, 0.214, 0)
			InputFrame.Size = UDim2.new(0, 100, 0, 23)
			InputFrame.Parent = Container
			Instance.new("UICorner", InputFrame)

			local TextBox = Instance.new("TextBox")
			TextBox.BackgroundTransparency = 1
			TextBox.Size = UDim2.new(1, 0, 1, 0)
			TextBox.Font = Enum.Font.Gotham
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 14
			TextBox.Parent = InputFrame

			TextBox.FocusLost:Connect(function(EnterPressed)
				if EnterPressed and #TextBox.Text > 0 then
					Callback(TextBox.Text)
					if ClearOnSubmit then TextBox.Text = "" end
				end
			end)
		end

		function TabApi.Bind(BindName: string, DefaultKey: Enum.KeyCode?, Callback: () -> ())
			local CurrentKey = DefaultKey
			local IsBinding = false

			local Button = Instance.new("TextButton")
			Button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			Button.Size = UDim2.new(0, 363, 0, 42)
			Button.AutoButtonColor = false
			Button.Text = ""
			Button.Parent = ContentFrame
			Instance.new("UICorner", Button)

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.036, 0, 0, 0)
			Label.Size = UDim2.new(0, 187, 0, 42)
			Label.Font = Enum.Font.Gotham
			Label.Text = BindName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Button

			local KeyLabel = Instance.new("TextLabel")
			KeyLabel.BackgroundTransparency = 1
			KeyLabel.Position = UDim2.new(0.036, 0, 0, 0)
			KeyLabel.Size = UDim2.new(0, 337, 0, 42)
			KeyLabel.Font = Enum.Font.Gotham
			KeyLabel.Text = CurrentKey and CurrentKey.Name or "None"
			KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyLabel.TextSize = 14
			KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
			KeyLabel.Parent = Button

			Button.MouseButton1Click:Connect(function()
				if IsBinding then return end
				IsBinding = true
				KeyLabel.Text = "..."
				local Input = UserInputService.InputBegan:Wait()
				if Input.KeyCode.Name ~= "Unknown" then
					CurrentKey = Input.KeyCode
					KeyLabel.Text = CurrentKey.Name
				end
				IsBinding = false
			end)

			UserInputService.InputBegan:Connect(function(Input, GameProcessed)
				if not GameProcessed and not IsBinding and CurrentKey and Input.KeyCode == CurrentKey then
					Callback()
				end
			end)
		end

		return TabApi
	end

	function WindowApi.Notification(NotifyTitle: string, NotifyDesc: string, ButtonText: string)
		local Overlay = Instance.new("TextButton")
		Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Overlay.BackgroundTransparency = 1
		Overlay.Size = UDim2.new(1, 0, 1, 0)
		Overlay.Text = ""
		Overlay.AutoButtonColor = false
		Overlay.Parent = MainFrame

		CreateTween(Overlay, {BackgroundTransparency = 0.7}, 0.3, Enum.EasingStyle.Quad)

		local NotifyFrame = Instance.new("Frame")
		NotifyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.ClipsDescendants = true
		NotifyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		NotifyFrame.Size = UDim2.new(0, 0, 0, 0)
		NotifyFrame.Parent = Overlay

		CreateTween(NotifyFrame, {Size = UDim2.new(0, 164, 0, 193)}, 0.6)
		task.wait(0.4)

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Position = UDim2.new(0.067, 0, 0.083, 0)
		TitleLbl.Size = UDim2.new(0, 143, 0, 26)
		TitleLbl.Font = Enum.Font.Gotham
		TitleLbl.Text = NotifyTitle
		TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleLbl.TextSize = 18
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.Parent = NotifyFrame

		local DescLbl = Instance.new("TextLabel")
		DescLbl.BackgroundTransparency = 1
		DescLbl.Position = UDim2.new(0.067, 0, 0.219, 0)
		DescLbl.Size = UDim2.new(0, 143, 0, 91)
		DescLbl.Font = Enum.Font.Gotham
		DescLbl.Text = NotifyDesc
		DescLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		DescLbl.TextSize = 15
		DescLbl.TextWrapped = true
		DescLbl.TextXAlignment = Enum.TextXAlignment.Left
		DescLbl.TextYAlignment = Enum.TextYAlignment.Top
		DescLbl.Parent = NotifyFrame

		local OkBtn = Instance.new("TextButton")
		OkBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
		OkBtn.Position = UDim2.new(0.061, 0, 0.72, 0)
		OkBtn.Size = UDim2.new(0, 144, 0, 42)
		OkBtn.Text = ButtonText
		OkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		OkBtn.Font = Enum.Font.Gotham
		OkBtn.TextSize = 14
		OkBtn.Parent = NotifyFrame
		Instance.new("UICorner", OkBtn)

		local function CloseNotification()
			CreateTween(NotifyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.6)
			task.wait(0.4)
			CreateTween(Overlay, {BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quad)
			task.wait(0.3)
			Overlay:Destroy()
		end

		OkBtn.MouseButton1Click:Connect(CloseNotification)
	end

	return WindowApi
end

return Library