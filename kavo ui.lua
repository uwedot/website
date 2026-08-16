local Kavo = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Themes = {
	DarkTheme = {Scheme = Color3.fromRGB(64, 64, 64), Background = Color3.fromRGB(0, 0, 0), Header = Color3.fromRGB(0, 0, 0), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(20, 20, 20)},
	LightTheme = {Scheme = Color3.fromRGB(150, 150, 150), Background = Color3.fromRGB(255, 255, 255), Header = Color3.fromRGB(200, 200, 200), Text = Color3.fromRGB(0, 0, 0), Element = Color3.fromRGB(224, 224, 224)},
	BloodTheme = {Scheme = Color3.fromRGB(227, 27, 27), Background = Color3.fromRGB(10, 10, 10), Header = Color3.fromRGB(5, 5, 5), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(20, 20, 20)},
	GrapeTheme = {Scheme = Color3.fromRGB(166, 71, 214), Background = Color3.fromRGB(64, 50, 71), Header = Color3.fromRGB(36, 28, 41), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(74, 58, 84)},
	Ocean = {Scheme = Color3.fromRGB(86, 76, 251), Background = Color3.fromRGB(26, 32, 58), Header = Color3.fromRGB(38, 45, 71), Text = Color3.fromRGB(200, 200, 200), Element = Color3.fromRGB(38, 45, 71)},
	Midnight = {Scheme = Color3.fromRGB(26, 189, 158), Background = Color3.fromRGB(44, 62, 82), Header = Color3.fromRGB(57, 81, 105), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(52, 74, 95)},
	Sentinel = {Scheme = Color3.fromRGB(230, 35, 69), Background = Color3.fromRGB(32, 32, 32), Header = Color3.fromRGB(24, 24, 24), Text = Color3.fromRGB(119, 209, 138), Element = Color3.fromRGB(24, 24, 24)},
	Synapse = {Scheme = Color3.fromRGB(46, 48, 43), Background = Color3.fromRGB(13, 15, 12), Header = Color3.fromRGB(36, 38, 35), Text = Color3.fromRGB(152, 99, 53), Element = Color3.fromRGB(24, 24, 24)},
	Serpent = {Scheme = Color3.fromRGB(0, 166, 58), Background = Color3.fromRGB(31, 41, 43), Header = Color3.fromRGB(22, 29, 31), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(22, 29, 31)}
}

local DefaultTheme = {Scheme = Color3.fromRGB(74, 99, 135), Background = Color3.fromRGB(36, 37, 43), Header = Color3.fromRGB(28, 29, 34), Text = Color3.fromRGB(255, 255, 255), Element = Color3.fromRGB(32, 32, 38)}
local LibraryName = tostring(math.random(1e6))

function Kavo:EnableDrag(Frame, Parent)
	Parent = Parent or Frame
	local Dragging, DragInput, StartPos, StartMouse
	Frame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			StartMouse = Input.Position
			StartPos = Parent.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
			end)
		end
	end)
	Frame.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then DragInput = Input end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - StartMouse
			Parent.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)
end

function Kavo:ToggleUI()
	local Gui = CoreGui:FindFirstChild(LibraryName)
	if Gui then Gui.Enabled = not Gui.Enabled end
end

function Kavo.CreateLib(Name, ThemeKey)
	Name = Name or "Library"
	local Theme = Themes[ThemeKey] or (type(ThemeKey) == "table" and ThemeKey) or DefaultTheme
	for _, Child in CoreGui:GetChildren() do
		if Child:IsA("ScreenGui") and Child.Name == Name then Child:Destroy() end
	end
	local Screen = Instance.new("ScreenGui", CoreGui)
	Screen.Name = LibraryName
	Screen.ResetOnSpawn = false
	local Main = Instance.new("Frame", Screen)
	Main.BackgroundColor3 = Theme.Background
	Main.ClipsDescendants = true
	Main.Position = UDim2.new(0.336, 0, 0.275, 0)
	Main.Size = UDim2.new(0, 525, 0, 318)
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)
	local Header = Instance.new("Frame", Main)
	Header.BackgroundColor3 = Theme.Header
	Header.Size = UDim2.new(0, 525, 0, 29)
	Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
	local Title = Instance.new("TextLabel", Header)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0.017, 0, 0.345, 0)
	Title.Size = UDim2.new(0, 204, 0, 8)
	Title.Font = Enum.Font.Gotham
	Title.Text = Name
	Title.TextColor3 = Theme.Text
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	local CloseBtn = Instance.new("ImageButton", Header)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Position = UDim2.new(0.95, 0, 0.138, 0)
	CloseBtn.Size = UDim2.new(0, 21, 0, 21)
	CloseBtn.Image = "rbxassetid://3926305904"
	CloseBtn.ImageRectOffset = Vector2.new(284, 4)
	CloseBtn.ImageRectSize = Vector2.new(24, 24)
	CloseBtn.MouseButton1Click:Connect(function()
		TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(), Position = UDim2.new(0, Main.AbsolutePosition.X + Main.AbsoluteSize.X / 2, 0, Main.AbsolutePosition.Y + Main.AbsoluteSize.Y / 2)}):Play()
		task.delay(0.1, function() Screen:Destroy() end)
	end)
	Kavo:EnableDrag(Header, Main)
	local Side = Instance.new("Frame", Main)
	Side.BackgroundColor3 = Theme.Header
	Side.Position = UDim2.new(0, 0, 0.091, 0)
	Side.Size = UDim2.new(0, 149, 0, 289)
	Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 4)
	local TabContainer = Instance.new("Frame", Side)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0.044, 0, 0, 0)
	TabContainer.Size = UDim2.new(0, 135, 0, 283)
	local TabList = Instance.new("UIListLayout", TabContainer)
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	local Pages = Instance.new("Folder", Main)
	local FirstTab = true
	local Tabs = {}
	function Tabs:NewTab(TabName)
		TabName = TabName or "Tab"
		local Page = Instance.new("ScrollingFrame", Pages)
		Page.Active = true
		Page.BackgroundColor3 = Theme.Background
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ScrollBarThickness = 5
		Page.Visible = not FirstTab
		local PageList = Instance.new("UIListLayout", Page)
		PageList.Padding = UDim.new(0, 5)
		local Btn = Instance.new("TextButton", TabContainer)
		Btn.BackgroundColor3 = Theme.Scheme
		Btn.Size = UDim2.new(0, 135, 0, 28)
		Btn.AutoButtonColor = false
		Btn.Font = Enum.Font.Gotham
		Btn.Text = TabName
		Btn.TextColor3 = Theme.Text
		Btn.TextSize = 14
		Btn.BackgroundTransparency = FirstTab and 0 or 1
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
		if FirstTab then FirstTab = false end
		Btn.MouseButton1Click:Connect(function()
			for _, P in Pages:GetChildren() do P.Visible = false end
			Page.Visible = true
			for _, B in TabContainer:GetChildren() do
				if B:IsA("TextButton") then TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
			end
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		end)
		local Sections = {}
		function Sections:NewSection(SecName, Hidden)
			SecName = SecName or "Section"
			local Section = Instance.new("Frame", Page)
			Section.BackgroundColor3 = Theme.Background
			Section.BorderSizePixel = 0
			local SecList = Instance.new("UIListLayout", Section)
			SecList.Padding = UDim.new(0, 5)
			local Head = Instance.new("Frame", Section)
			Head.BackgroundColor3 = Theme.Scheme
			Head.Size = UDim2.new(0, 352, 0, 33)
			Head.Visible = not Hidden
			Instance.new("UICorner", Head).CornerRadius = UDim.new(0, 4)
			local SecLabel = Instance.new("TextLabel", Head)
			SecLabel.BackgroundTransparency = 1
			SecLabel.Size = UDim2.new(0.98, 0, 1, 0)
			SecLabel.Position = UDim2.new(0.02, 0, 0, 0)
			SecLabel.Font = Enum.Font.Gotham
			SecLabel.Text = SecName
			SecLabel.TextColor3 = Theme.Text
			SecLabel.TextSize = 14
			SecLabel.TextXAlignment = Enum.TextXAlignment.Left
			local Inner = Instance.new("Frame", Section)
			Inner.BackgroundTransparency = 1
			local InnerList = Instance.new("UIListLayout", Inner)
			InnerList.Padding = UDim.new(0, 3)
			local function UpdateSize()
				Inner.Size = UDim2.new(1, 0, 0, InnerList.AbsoluteContentSize.Y)
				Section.Size = UDim2.new(0, 352, 0, SecList.AbsoluteContentSize.Y)
				Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y)
			end
			UpdateSize()
			InnerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
			local Elements = {}
			local function Ripple(Button)
				local Sample = Instance.new("ImageLabel", Button)
				Sample.BackgroundTransparency = 1
				Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
				Sample.ImageColor3 = Theme.Scheme
				Sample.ImageTransparency = 0.6
				local Ms = game.Players.LocalPlayer:GetMouse()
				local X, Y = Ms.X - Button.AbsolutePosition.X, Ms.Y - Button.AbsolutePosition.Y
				Sample.Position = UDim2.new(0, X, 0, Y)
				local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
				Sample:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", 0.35, true)
				TweenService:Create(Sample, TweenInfo.new(0.35), {ImageTransparency = 1}):Play()
				task.delay(0.35, function() Sample:Destroy() end)
			end
			function Elements:NewButton(BName, Tip, Callback)
				BName = BName or "Button"
				Callback = Callback or function() end
				local Btn = Instance.new("TextButton", Inner)
				Btn.BackgroundColor3 = Theme.Element
				Btn.ClipsDescendants = true
				Btn.Size = UDim2.new(0, 352, 0, 33)
				Btn.AutoButtonColor = false
				Btn.Text = ""
				Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
				local Label = Instance.new("TextLabel", Btn)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 314, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = BName
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Btn.MouseButton1Click:Connect(function() Ripple(Btn); task.spawn(Callback) end)
				Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element:Lerp(Color3.new(1, 1, 1), 0.05)}):Play() end)
				Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element}):Play() end)
				return {UpdateButton = function(Self, NewText) Label.Text = NewText end}
			end
			function Elements:NewToggle(TName, Tip, Callback)
				TName = TName or "Toggle"
				Callback = Callback or function() end
				local Toggled = false
				local Btn = Instance.new("TextButton", Inner)
				Btn.BackgroundColor3 = Theme.Element
				Btn.ClipsDescendants = true
				Btn.Size = UDim2.new(0, 352, 0, 33)
				Btn.AutoButtonColor = false
				Btn.Text = ""
				Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
				local Icon = Instance.new("ImageLabel", Btn)
				Icon.BackgroundTransparency = 1
				Icon.Position = UDim2.new(0.02, 0, 0.18, 0)
				Icon.Size = UDim2.new(0, 21, 0, 21)
				Icon.Image = "rbxassetid://3926309567"
				Icon.ImageColor3 = Theme.Scheme
				Icon.ImageRectOffset = Vector2.new(784, 420)
				Icon.ImageRectSize = Vector2.new(48, 48)
				Icon.ImageTransparency = 1
				local Label = Instance.new("TextLabel", Btn)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 288, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = TName
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				local function Set(State)
					Toggled = State
					TweenService:Create(Icon, TweenInfo.new(0.11), {ImageTransparency = State and 0 or 1}):Play()
					task.spawn(Callback, State)
				end
				Btn.MouseButton1Click:Connect(function() Ripple(Btn); Set(not Toggled) end)
				Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element:Lerp(Color3.new(1, 1, 1), 0.05)}):Play() end)
				Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element}):Play() end)
				return {UpdateToggle = function(Self, Text, State) if Text then Label.Text = Text end; if State ~= nil then Set(State) end end}
			end
			function Elements:NewSlider(Info, Tip, Max, Min, Callback)
				Info = Info or "Slider"
				Max = Max or 100
				Min = Min or 0
				Callback = Callback or function() end
				local Frame = Instance.new("Frame", Inner)
				Frame.BackgroundColor3 = Theme.Element
				Frame.Size = UDim2.new(0, 352, 0, 33)
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
				local Label = Instance.new("TextLabel", Frame)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 138, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = Info
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				local Track = Instance.new("TextButton", Frame)
				Track.BackgroundColor3 = Theme.Element:Lerp(Color3.new(1, 1, 1), 0.03)
				Track.Position = UDim2.new(0.489, 0, 0.394, 0)
				Track.Size = UDim2.new(0, 149, 0, 6)
				Track.AutoButtonColor = false
				Track.Text = ""
				Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 4)
				local Fill = Instance.new("Frame", Track)
				Fill.BackgroundColor3 = Theme.Scheme
				Fill.Size = UDim2.new(0, 0, 1, 0)
				Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)
				local ValLabel = Instance.new("TextLabel", Frame)
				ValLabel.BackgroundTransparency = 1
				ValLabel.Position = UDim2.new(0.352, 0, 0.273, 0)
				ValLabel.Size = UDim2.new(0, 41, 0, 14)
				ValLabel.Font = Enum.Font.GothamSemibold
				ValLabel.Text = Min
				ValLabel.TextColor3 = Theme.Text
				ValLabel.TextSize = 14
				ValLabel.TextTransparency = 1
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				local Dragging = false
				local function Update(Input)
					local Pos = math.clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
					Fill.Size = UDim2.new(Pos, 0, 1, 0)
					local Value = math.floor(Min + (Max - Min) * Pos)
					ValLabel.Text = Value
					task.spawn(Callback, Value)
				end
				local function StartDrag(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						TweenService:Create(ValLabel, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
						Update(Input)
					end
				end
				Track.InputBegan:Connect(StartDrag)
				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then Update(Input) end
				end)
				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						if Dragging then
							Dragging = false
							TweenService:Create(ValLabel, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
						end
					end
				end)
			end
			function Elements:NewTextBox(TName, Tip, Callback)
				TName = TName or "Textbox"
				Callback = Callback or function() end
				local Frame = Instance.new("Frame", Inner)
				Frame.BackgroundColor3 = Theme.Element
				Frame.Size = UDim2.new(0, 352, 0, 33)
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
				local Label = Instance.new("TextLabel", Frame)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 138, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = TName
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				local Box = Instance.new("TextBox", Frame)
				Box.BackgroundColor3 = Theme.Element:Lerp(Color3.new(0, 0, 0), 0.03)
				Box.BorderSizePixel = 0
				Box.Position = UDim2.new(0.489, 0, 0.212, 0)
				Box.Size = UDim2.new(0, 150, 0, 18)
				Box.ClearTextOnFocus = false
				Box.Font = Enum.Font.Gotham
				Box.PlaceholderText = "Type here..."
				Box.Text = ""
				Box.TextColor3 = Theme.Scheme
				Box.TextSize = 12
				Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
				Box.FocusLost:Connect(function(Enter) if Enter then task.spawn(Callback, Box.Text); Box.Text = "" end end)
			end
			function Elements:NewDropdown(DName, List, Callback)
				DName = DName or "Dropdown"
				List = List or {}
				Callback = Callback or function() end
				local Opened = false
				local DropFrame = Instance.new("Frame", Inner)
				DropFrame.BackgroundColor3 = Theme.Background
				DropFrame.ClipsDescendants = true
				DropFrame.Size = UDim2.new(0, 352, 0, 33)
				local HeaderBtn = Instance.new("TextButton", DropFrame)
				HeaderBtn.BackgroundColor3 = Theme.Element
				HeaderBtn.Size = UDim2.new(0, 352, 0, 33)
				HeaderBtn.AutoButtonColor = false
				HeaderBtn.Text = ""
				Instance.new("UICorner", HeaderBtn).CornerRadius = UDim.new(0, 4)
				local SelectedLabel = Instance.new("TextLabel", HeaderBtn)
				SelectedLabel.BackgroundTransparency = 1
				SelectedLabel.Position = UDim2.new(0.097, 0, 0.273, 0)
				SelectedLabel.Size = UDim2.new(0, 200, 0, 14)
				SelectedLabel.Font = Enum.Font.GothamSemibold
				SelectedLabel.Text = DName
				SelectedLabel.TextColor3 = Theme.Text
				SelectedLabel.TextSize = 14
				SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
				local OptionList = Instance.new("UIListLayout", DropFrame)
				OptionList.SortOrder = Enum.SortOrder.LayoutOrder
				OptionList.Padding = UDim.new(0, 3)
				local function RefreshOptions(NewList)
					for _, V in DropFrame:GetChildren() do if V:IsA("TextButton") and V ~= HeaderBtn then V:Destroy() end end
					for _, Opt in ipairs(NewList or List) do
						local OptBtn = Instance.new("TextButton", DropFrame)
						OptBtn.BackgroundColor3 = Theme.Element
						OptBtn.Size = UDim2.new(0, 352, 0, 33)
						OptBtn.AutoButtonColor = false
						OptBtn.Font = Enum.Font.GothamSemibold
						OptBtn.Text = "  " .. Opt
						OptBtn.TextColor3 = Theme.Text
						OptBtn.TextSize = 14
						OptBtn.TextXAlignment = Enum.TextXAlignment.Left
						Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
						OptBtn.MouseButton1Click:Connect(function()
							Opened = false
							SelectedLabel.Text = Opt
							DropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
							UpdateSize()
							task.spawn(Callback, Opt)
						end)
						OptBtn.MouseEnter:Connect(function() TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element:Lerp(Color3.new(1, 1, 1), 0.05)}):Play() end)
						OptBtn.MouseLeave:Connect(function() TweenService:Create(OptBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element}):Play() end)
					end
				end
				RefreshOptions()
				HeaderBtn.MouseButton1Click:Connect(function()
					Opened = not Opened
					local TargetY = Opened and OptionList.AbsoluteContentSize.Y + 33 or 33
					DropFrame:TweenSize(UDim2.new(0, 352, 0, TargetY), "InOut", "Linear", 0.08)
					UpdateSize()
				end)
				return {Refresh = function(Self, NewList) RefreshOptions(NewList) end}
			end
			function Elements:NewKeybind(KName, DefaultKey, Callback)
				KName = KName or "Keybind"
				DefaultKey = DefaultKey or Enum.KeyCode.Unknown
				Callback = Callback or function() end
				local CurrentKey = DefaultKey
				local Frame = Instance.new("Frame", Inner)
				Frame.BackgroundColor3 = Theme.Element
				Frame.Size = UDim2.new(0, 352, 0, 33)
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
				local Label = Instance.new("TextLabel", Frame)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 222, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = KName
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				local KeyLabel = Instance.new("TextLabel", Frame)
				KeyLabel.BackgroundTransparency = 1
				KeyLabel.Position = UDim2.new(0.727, 0, 0.273, 0)
				KeyLabel.Size = UDim2.new(0, 70, 0, 14)
				KeyLabel.Font = Enum.Font.GothamSemibold
				KeyLabel.Text = CurrentKey.Name
				KeyLabel.TextColor3 = Theme.Scheme
				KeyLabel.TextSize = 14
				KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
				local Btn = Instance.new("TextButton", Frame)
				Btn.BackgroundTransparency = 1
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.Text = ""
				Btn.MouseButton1Click:Connect(function()
					KeyLabel.Text = "..."
					local Input = UserInputService.InputBegan:Wait()
					if Input.KeyCode.Name ~= "Unknown" then CurrentKey = Input.KeyCode; KeyLabel.Text = CurrentKey.Name end
				end)
				UserInputService.InputBegan:Connect(function(Input, Gpe) if not Gpe and Input.KeyCode == CurrentKey then task.spawn(Callback) end end)
			end
			function Elements:NewColorPicker(CName, DefColor, Callback)
				CName = CName or "ColorPicker"
				DefColor = DefColor or Color3.fromRGB(255, 255, 255)
				Callback = Callback or function() end
				local H, S, V = Color3.toHSV(DefColor)
				local Expanded = false
				local Frame = Instance.new("Frame", Inner)
				Frame.BackgroundColor3 = Theme.Element
				Frame.ClipsDescendants = true
				Frame.Size = UDim2.new(0, 352, 0, 33)
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
				local HeaderBtn = Instance.new("TextButton", Frame)
				HeaderBtn.BackgroundTransparency = 1
				HeaderBtn.Size = UDim2.new(1, 0, 0, 33)
				HeaderBtn.Text = ""
				local Label = Instance.new("TextLabel", HeaderBtn)
				Label.BackgroundTransparency = 1
				Label.Position = UDim2.new(0.097, 0, 0.273, 0)
				Label.Size = UDim2.new(0, 200, 0, 14)
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = CName
				Label.TextColor3 = Theme.Text
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				local Preview = Instance.new("Frame", HeaderBtn)
				Preview.BackgroundColor3 = DefColor
				Preview.Position = UDim2.new(0.793, 0, 0.212, 0)
				Preview.Size = UDim2.new(0, 42, 0, 18)
				Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)
				local PickerArea = Instance.new("Frame", Frame)
				PickerArea.BackgroundColor3 = Theme.Element
				PickerArea.Position = UDim2.new(0, 0, 0, 33)
				PickerArea.Size = UDim2.new(0, 352, 0, 105)
				Instance.new("UICorner", PickerArea).CornerRadius = UDim.new(0, 4)
				local SvImg = Instance.new("ImageButton", PickerArea)
				SvImg.Position = UDim2.new(0.02, 0, 0.048, 0)
				SvImg.Size = UDim2.new(0, 211, 0, 93)
				SvImg.Image = "rbxassetid://6523286724"
				Instance.new("UICorner", SvImg).CornerRadius = UDim.new(0, 4)
				local SvCursor = Instance.new("ImageLabel", SvImg)
				SvCursor.AnchorPoint = Vector2.new(0.5, 0.5)
				SvCursor.Size = UDim2.new(0, 14, 0, 14)
				SvCursor.Image = "rbxassetid://3926309567"
				SvCursor.ImageColor3 = Color3.fromRGB(0, 0, 0)
				SvCursor.ImageRectOffset = Vector2.new(628, 420)
				SvCursor.ImageRectSize = Vector2.new(48, 48)
				local HueBar = Instance.new("ImageButton", PickerArea)
				HueBar.Position = UDim2.new(0.636, 0, 0.048, 0)
				HueBar.Size = UDim2.new(0, 18, 0, 93)
				HueBar.Image = "rbxassetid://6523291212"
				Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)
				local HueCursor = Instance.new("ImageLabel", HueBar)
				HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
				HueCursor.Size = UDim2.new(0, 14, 0, 14)
				HueCursor.Image = "rbxassetid://3926309567"
				HueCursor.ImageColor3 = Color3.fromRGB(0, 0, 0)
				HueCursor.ImageRectOffset = Vector2.new(628, 420)
				HueCursor.ImageRectSize = Vector2.new(48, 48)
				local DraggingSv, DraggingHue = false, false
				local function UpdateColor()
					local Col = Color3.fromHSV(H, S, V)
					Preview.BackgroundColor3 = Col
					task.spawn(Callback, Col)
				end
				local function SetInitial()
					SvCursor.Position = UDim2.new(S, 0, 1 - V, 0)
					HueCursor.Position = UDim2.new(0.5, 0, 1 - H, 0)
					UpdateColor()
				end
				SetInitial()
				local function HandleInput(Input)
					if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
					if DraggingSv then
						local X = math.clamp((Input.Position.X - SvImg.AbsolutePosition.X) / SvImg.AbsoluteSize.X, 0, 1)
						local Y = math.clamp((Input.Position.Y - SvImg.AbsolutePosition.Y) / SvImg.AbsoluteSize.Y, 0, 1)
						S, V = X, 1 - Y
						SvCursor.Position = UDim2.new(S, 0, 1 - V, 0)
						UpdateColor()
					elseif DraggingHue then
						local Y = math.clamp((Input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
						H = 1 - Y
						HueCursor.Position = UDim2.new(0.5, 0, 1 - H, 0)
						UpdateColor()
					end
				end
				SvImg.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then DraggingSv = true end end)
				HueBar.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then DraggingHue = true end end)
				UserInputService.InputEnded:Connect(function(I)
					if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
						DraggingSv, DraggingHue = false, false
					end
				end)
				UserInputService.InputChanged:Connect(HandleInput)
				HeaderBtn.MouseButton1Click:Connect(function()
					Expanded = not Expanded
					Frame:TweenSize(UDim2.new(0, 352, 0, Expanded and 141 or 33), "InOut", "Linear", 0.08)
					UpdateSize()
				end)
			end
			function Elements:NewLabel(Text)
				local Lbl = Instance.new("TextLabel", Inner)
				Lbl.BackgroundColor3 = Theme.Scheme
				Lbl.Size = UDim2.new(0, 352, 0, 33)
				Lbl.Font = Enum.Font.Gotham
				Lbl.Text = "  " .. Text
				Lbl.TextColor3 = Theme.Text
				Lbl.TextSize = 14
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 4)
				return {UpdateLabel = function(Self, T) Lbl.Text = "  " .. T end}
			end
			return Elements
		end
		return Sections
	end
	return Tabs
end

return Kavo