--!strict
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local TweenInfoDragTaptic = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TweenInfoDragBar = TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TweenInfoHover = TweenInfo.new(0.6, Enum.EasingStyle.Exponential)
local TweenInfoClick = TweenInfo.new(0.6, Enum.EasingStyle.Exponential)
local TweenInfoTransition = TweenInfo.new(0.7, Enum.EasingStyle.Exponential)

local RayfieldLibrary = {
	Flags = {},
	Theme = {}
}

local function LoadWithTimeout(url: string, timeout: number?): ...any
	timeout = timeout or 5
	local RequestCompleted = false
	local Success, Result = false, nil
	local RequestThread = task.spawn(function()
		local FetchSuccess, FetchResult = pcall(game.HttpGet, game, url)
		if not FetchSuccess or #FetchResult == 0 then
			Success, Result = false, if #FetchResult == 0 then "Empty response" else FetchResult
			RequestCompleted = true
			return
		end
		local ExecSuccess, ExecResult = pcall(function()
			return loadstring(FetchResult)()
		end)
		Success, Result = ExecSuccess, ExecResult
		RequestCompleted = true
	end)
	local TimeoutThread = task.delay(timeout, function()
		if not RequestCompleted then
			task.cancel(RequestThread)
			Result = "Request timed out"
			RequestCompleted = true
		end
	end)
	while not RequestCompleted do
		task.wait()
	end
	if coroutine.status(TimeoutThread) ~= "dead" then
		task.cancel(TimeoutThread)
	end
	return if Success then Result else nil
end

local RequestsDisabled = false
local CustomAssetId = nil
local SecureMode = false

if getgenv then
	local Ok, Result = pcall(function() return getgenv().DISABLE_RAYFIELD_REQUESTS end)
	if Ok and Result then RequestsDisabled = true end
	local Ok2, Result2 = pcall(function() return getgenv().RAYFIELD_ASSET_ID end)
	if Ok2 and type(Result2) == "number" then CustomAssetId = Result2 end
	local Ok3, Result3 = pcall(function() return getgenv().RAYFIELD_SECURE end)
	if Ok3 and Result3 then SecureMode = true end
end

local SecureWarnings = {}
local CustomAssets = {}

local function SecureNotify(wType: string, title: string, content: string)
	if SecureWarnings[wType] then return end
	SecureWarnings[wType] = true
	task.spawn(function()
		while not RayfieldLibrary or not RayfieldLibrary.Notify do task.wait(0.5) end
		RayfieldLibrary:Notify({ Title = title, Content = content, Duration = 8 })
	end)
end

local InterfaceBuild = 'UU2NX'
local Release = "Build 1.749"
local RayfieldFolder = "Rayfield"
local ConfigurationFolder = RayfieldFolder .. "/Configurations"
local ConfigurationExtension = ".rfld"

local SettingsTable = {
	General = {
		RayfieldOpen = { Type = 'bind', Value = 'K', Name = 'Rayfield Keybind' },
	},
	System = {}
}

local OverriddenSettings: { [string]: any } = {}

local function OverrideSetting(category: string, name: string, value: any)
	OverriddenSettings[category .. "." .. name] = value
end

local function GetSetting(category: string, name: string): any
	if OverriddenSettings[category .. "." .. name] ~= nil then
		return OverriddenSettings[category .. "." .. name]
	elseif SettingsTable[category] and SettingsTable[category][name] ~= nil then
		return SettingsTable[category][name].Value
	end
	return nil
end

local UseStudio = RunService:IsStudio()
local SettingsCreated = false
local SettingsInitialized = false
local Prompt = UseStudio and require(script.Parent.prompt) or LoadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/refs/heads/request/prompt.lua')
local RequestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

if not Prompt and not UseStudio then
	Prompt = { Create = function() end }
end

local function CallSafely(func: (...any) -> ...any, ...: any): any?
	if func then
		local Success, Result = pcall(func, ...)
		if not Success then return false end
		return Result
	end
	return nil
end

local function EnsureFolder(folderPath: string)
	if isfolder and not CallSafely(isfolder, folderPath) then
		CallSafely(makefolder, folderPath)
	end
end

local function LoadSettings()
	local File = nil
	local Success = pcall(function()
		if CallSafely(isfolder, RayfieldFolder) then
			if CallSafely(isfile, RayfieldFolder .. '/settings' .. ConfigurationExtension) then
				File = CallSafely(readfile, RayfieldFolder .. '/settings' .. ConfigurationExtension)
			end
		end
		if UseStudio then
			File = '{"General":{"RayfieldOpen":{"Value":"K","Type":"bind","Name":"Rayfield Keybind","Element":{"HoldToInteract":false,"Ext":true,"Name":"Rayfield Keybind","Set":null,"CallOnChange":true,"Callback":null,"CurrentKeybind":"K"}}},"System":{}}'
		end
		if File then
			local DecodeSuccess, DecodedFile = pcall(function() return HttpService:JSONDecode(File) end)
			File = if DecodeSuccess then DecodedFile else {}
		else
			File = {}
		end
		if not SettingsCreated then return end
		if next(File) ~= nil then
			for CategoryName, CategoryTable in File do
				for SettingName, Setting in CategoryTable do
					local Default = SettingsTable[CategoryName] and SettingsTable[CategoryName][SettingName]
					if not Default then continue end
					if typeof(Default.Value) ~= typeof(Setting.Value) then continue end
					Default.Value = Setting.Value
				end
			end
		end
		for CategoryName, CategoryTable in SettingsTable do
			for SettingName, Setting in CategoryTable do
				if Setting.Element then
					Setting.Element:Set(GetSetting(CategoryName, SettingName))
				end
			end
		end
		SettingsInitialized = true
	end)
end

LoadSettings()

local RayfieldAssetId = CustomAssetId or 10804731440
local Rayfield = UseStudio and script.Parent:FindFirstChild('Rayfield') or game:GetObjects("rbxassetid://" .. RayfieldAssetId)[1]
local BuildAttempts = 0
local CorrectBuild = false
local Warned = false
local GlobalLoaded = false
local RayfieldDestroyed = false

repeat
	if Rayfield:FindFirstChild('Build') and Rayfield.Build.Value == InterfaceBuild then
		CorrectBuild = true
		break
	end
	CorrectBuild = false
	if not Warned then Warned = true end
	local ToDestroy = Rayfield
	Rayfield = UseStudio and script.Parent:FindFirstChild('Rayfield') or game:GetObjects("rbxassetid://" .. RayfieldAssetId)[1]
	if ToDestroy and not UseStudio then ToDestroy:Destroy() end
	BuildAttempts += 1
until BuildAttempts >= 2

Rayfield.Enabled = false

if gethui then
	Rayfield.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(Rayfield)
	Rayfield.Parent = CoreGui
elseif not UseStudio and CoreGui:FindFirstChild("RobloxGui") then
	Rayfield.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not UseStudio then
	Rayfield.Parent = CoreGui
end

local Container = gethui and gethui() or CoreGui
for _, Interface in ipairs(Container:GetChildren()) do
	if Interface.Name == Rayfield.Name and Interface ~= Rayfield then
		Interface.Enabled = false
		Interface.Name = "Rayfield-Old"
	end
end

if SecureMode and not CustomAssetId then
	SecureNotify("default_asset", "Secure Mode", "You are using the default Rayfield asset ID. Set RAYFIELD_ASSET_ID to a custom upload to avoid detection.")
end

do
	local AssetPath = RayfieldFolder .. "/Assets"
	local AssetBaseUrl = "https://github.com/SiriusSoftwareLtd/Rayfield/blob/main/assets/"
	local AssetFiles = {
		["111263549366178"] = AssetBaseUrl .. "111263549366178.png?raw=true",
		["77891951053543"] = AssetBaseUrl .. "77891951053543.png?raw=true",
		["78137979054938"] = AssetBaseUrl .. "78137979054938.png?raw=true",
		["80503127983237"] = AssetBaseUrl .. "80503127983237.png?raw=true",
		["10137832201"] = AssetBaseUrl .. "10137832201.png?raw=true",
		["10137941941"] = AssetBaseUrl .. "10137941941.png?raw=true",
		["11036884234"] = AssetBaseUrl .. "11036884234.png?raw=true",
		["11413591840"] = AssetBaseUrl .. "11413591840.png?raw=true",
		["11745872910"] = AssetBaseUrl .. "11745872910.png?raw=true",
		["12577727209"] = AssetBaseUrl .. "12577727209.png?raw=true",
		["18458939117"] = AssetBaseUrl .. "18458939117.png?raw=true",
		["3259050989"] = AssetBaseUrl .. "3259050989.png?raw=true",
		["3523728077"] = AssetBaseUrl .. "3523728077.png?raw=true",
		["3602733521"] = AssetBaseUrl .. "3602733521.png?raw=true",
		["IconChevronTopMedium"] = AssetBaseUrl .. "IconChevronTopMedium.png?raw=true",
		["4483362458"] = AssetBaseUrl .. "4483362458.png?raw=true",
		["5587865193"] = AssetBaseUrl .. "5587865193.png?raw=true",
		["IconMagnifyingGlass2"] = AssetBaseUrl .. "IconMagnifyingGlass2.png?raw=true",
	}
	for Id, _ in AssetFiles do CustomAssets[tostring(Id)] = "" end
	local HasCustomAsset = type(getcustomasset) == "function"
	local HasFilesystem = type(writefile) == "function" and type(makefolder) == "function" and type(isfile) == "function" and type(isfolder) == "function"
	if HasCustomAsset and HasFilesystem then
		local Ok, Err = pcall(function()
			EnsureFolder(RayfieldFolder)
			EnsureFolder(AssetPath)
			local Attempted = {}
			local function NextToFetch(): string?
				for Id, _ in AssetFiles do
					if not Attempted[Id] and not isfile(AssetPath .. "/" .. tostring(Id) .. ".png") then return Id end
				end
				return nil
			end
			if NextToFetch() then
				task.spawn(function()
					while true do
						local Id = NextToFetch()
						if not Id then break end
						local Ok, Res = pcall(RequestFunc, { Url = AssetFiles[Id], Method = "GET" })
						if Ok and type(Res) == "table" and type(Res.Body) == "string" and #Res.Body > 0 then
							pcall(writefile, AssetPath .. "/" .. tostring(Id) .. ".png", Res.Body)
						end
						Attempted[Id] = true
						task.wait()
					end
				end)
				while NextToFetch() do task.wait(0.1) end
			end
			for Id, _ in AssetFiles do
				local Success, Asset = pcall(getcustomasset, AssetPath .. "/" .. tostring(Id) .. ".png")
				if Success then CustomAssets[tostring(Id)] = Asset end
			end
		end)
		if not Ok then SecureNotify("asset_load_fail", "Rayfield", "Failed to load custom assets. UI images may not display correctly.") end
	else
		SecureNotify("no_getcustomasset", "Rayfield", "Your executor does not support getcustomasset. Some UI images may not render correctly.")
	end
	Rayfield.Main.Shadow.Image.Image = CustomAssets[tostring(5587865193)]
	Rayfield.Main.Topbar.Hide.Image = CustomAssets[tostring(10137832201)]
	Rayfield.Main.Topbar.ChangeSize.Image = CustomAssets[tostring(10137941941)]
	Rayfield.Main.Topbar.Settings.Image = CustomAssets[tostring(80503127983237)]
	Rayfield.Main.Topbar.Icon.Image = CustomAssets[tostring(78137979054938)]
	Rayfield.Main.Topbar.Search.Image = CustomAssets["IconMagnifyingGlass2"]
	Rayfield.Main.Topbar.Search.ImageRectOffset = Vector2.zero
	Rayfield.Main.Topbar.Search.ImageRectSize = Vector2.zero
	Rayfield.Main.Elements.Template.Toggle.Switch.Shadow.Image = CustomAssets[tostring(3602733521)]
	Rayfield.Main.Elements.Template.Slider.Main.Shadow.Image = CustomAssets[tostring(3602733521)]
	Rayfield.Main.Elements.Template.Dropdown.Toggle.Image = CustomAssets["IconChevronTopMedium"]
	Rayfield.Main.Elements.Template.Dropdown.Toggle.ImageRectOffset = Vector2.zero
	Rayfield.Main.Elements.Template.Dropdown.Toggle.ImageRectSize = Vector2.zero
	Rayfield.Main.Elements.Template.Label.Icon.Image = CustomAssets[tostring(11745872910)]
	Rayfield.Main.Elements.Template.ColorPicker.CPBackground.MainCP.Image = CustomAssets[tostring(11413591840)]
	Rayfield.Main.Elements.Template.ColorPicker.CPBackground.MainCP.MainPoint.Image = CustomAssets[tostring(3259050989)]
	Rayfield.Main.Elements.Template.ColorPicker.ColorSlider.SliderPoint.Image = CustomAssets[tostring(3259050989)]
	Rayfield.Main.TabList.Template.Image.Image = CustomAssets[tostring(4483362458)]
	Rayfield.Main.Search.Search.Image = CustomAssets[tostring(18458939117)]
	Rayfield.Main.Search.Shadow.Image = CustomAssets[tostring(5587865193)]
	Rayfield.Notifications.Template.Icon.Image = CustomAssets[tostring(77891951053543)]
	Rayfield.Notifications.Template.Shadow.Image = CustomAssets[tostring(3523728077)]
	Rayfield.Loading.Banner.Image = CustomAssets[tostring(111263549366178)]
end

local MinSize = Vector2.new(1024, 768)
local UseMobileSizing = Rayfield.AbsoluteSize.X < MinSize.X and Rayfield.AbsoluteSize.Y < MinSize.Y
local UseMobilePrompt = UserInputService.TouchEnabled

local Main = Rayfield.Main
local MPrompt = Rayfield:FindFirstChild('Prompt')
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local DragBar = Rayfield:FindFirstChild('Drag')
local DragInteract = DragBar and DragBar.Interact or nil
local DragBarCosmetic = DragBar and DragBar.Drag or nil
local DragOffset = 255
local DragOffsetMobile = 150

Rayfield.DisplayOrder = 100
LoadingFrame.Version.Text = Release

local Icons = UseStudio and require(script.Parent.icons) or LoadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua')

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local SearchOpen = false
local Notifications = Rayfield.Notifications
local KeybindConnections = {}
local SelectedTheme = RayfieldLibrary.Theme.Default

local function ChangeTheme(Theme: any)
	if typeof(Theme) == 'string' then
		SelectedTheme = RayfieldLibrary.Theme[Theme]
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end
	Rayfield.Main.BackgroundColor3 = SelectedTheme.Background
	Rayfield.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Rayfield.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Rayfield.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow
	Rayfield.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
	Rayfield.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
	Rayfield.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
	if Topbar:FindFirstChild('Settings') then
		Rayfield.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
		Rayfield.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	end
	Main.Search.BackgroundColor3 = SelectedTheme.TextColor
	Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
	Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke
	if Main:FindFirstChild('Notice') then Main.Notice.BackgroundColor3 = SelectedTheme.Background end
	for _, Text in ipairs(Rayfield:GetDescendants()) do
		if Text.Parent.Parent ~= Notifications and (Text:IsA('TextLabel') or Text:IsA('TextBox')) then
			Text.TextColor3 = SelectedTheme.TextColor
		end
	end
	for _, TabPage in ipairs(Elements:GetChildren()) do
		for _, Element in ipairs(TabPage:GetChildren()) do
			if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
				Element.BackgroundColor3 = SelectedTheme.ElementBackground
				Element.UIStroke.Color = SelectedTheme.ElementStroke
			end
		end
	end
end

local function GetIcon(name: string): { Id: number, ImageRectSize: Vector2, ImageRectOffset: Vector2 }?
	if not Icons then return nil end
	name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
	local SizedIcons = Icons['48px']
	local R = SizedIcons[name]
	if not R then error("Lucide Icons: Failed to find icon by the name of \"" .. name .. "\"", 2) end
	return { Id = R[1], ImageRectSize = Vector2.new(R[2][1], R[2][2]), ImageRectOffset = Vector2.new(R[3][1], R[3][2]) }
end

local function ResolveIcon(icon: any): (string, Vector2?, Vector2?)
	if not icon or icon == 0 then return "", nil, nil end
	if type(icon) == "string" and (string.find(icon, "rbxasset://") == 1 or string.find(icon, "rbxthumb://") == 1) then return icon, nil, nil end
	if SecureMode then
		SecureNotify("icon_blocked", "Secure Mode", "Element icons using asset IDs or Lucide names are blocked.")
		return "", nil, nil
	end
	if typeof(icon) == "string" and Icons then
		local Asset = GetIcon(icon)
		if Asset then return "rbxassetid://" .. Asset.Id, Asset.ImageRectOffset, Asset.ImageRectSize end
	end
	if type(icon) == "number" then return "rbxassetid://" .. icon, nil, nil end
	return "", nil, nil
end

local function MakeDraggable(object: GuiObject, dragObject: GuiObject, enableTaptic: boolean, tapticOffset: { number })
	local Dragging = false
	local Relative = Vector2.zero
	local Offset = Vector2.zero
	local ScreenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
	if ScreenGui and ScreenGui.IgnoreGuiInset then Offset += GuiService:GetGuiInset() end

	if DragBar and enableTaptic then
		DragBar.MouseEnter:Connect(function()
			if not Dragging and not Hidden then
				TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4) }):Play()
			end
		end)
		DragBar.MouseLeave:Connect(function()
			if not Dragging and not Hidden then
				TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4) }):Play()
			end
		end)
	end

	dragObject.InputBegan:Connect(function(input, processed)
		if processed then return end
		local InputType = input.UserInputType.Name
		if InputType == "MouseButton1" or InputType == "Touch" then
			Dragging = true
			Relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
			if enableTaptic and not Hidden then
				TweenService:Create(DragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0 }):Play()
			end
		end
	end)

	local InputEnded = UserInputService.InputEnded:Connect(function(input)
		if not Dragging then return end
		local InputType = input.UserInputType.Name
		if InputType == "MouseButton1" or InputType == "Touch" then
			Dragging = false
			if enableTaptic and not Hidden then
				TweenService:Create(DragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7 }):Play()
			end
		end
	end)

	local RenderStepped = RunService.RenderStepped:Connect(function()
		if Dragging and not Hidden then
			local Position = UserInputService:GetMouseLocation() + Relative + Offset
			if enableTaptic and tapticOffset then
				TweenService:Create(object, TweenInfoDragTaptic, { Position = UDim2.fromOffset(Position.X, Position.Y) }):Play()
				TweenService:Create(dragObject.Parent, TweenInfoDragBar, { Position = UDim2.fromOffset(Position.X, Position.Y + ((UseMobileSizing and tapticOffset[2]) or tapticOffset[1])) }):Play()
			else
				if DragBar and tapticOffset then
					DragBar.Position = UDim2.fromOffset(Position.X, Position.Y + ((UseMobileSizing and tapticOffset[2]) or tapticOffset[1]))
				end
				object.Position = UDim2.fromOffset(Position.X, Position.Y)
			end
		end
	end)

	object.Destroying:Connect(function()
		if InputEnded then InputEnded:Disconnect() end
		if RenderStepped then RenderStepped:Disconnect() end
	end)
end

local function PackColor(Color: Color3): { R: number, G: number, B: number }
	return { R = Color.R * 255, G = Color.G * 255, B = Color.B * 255 }
end

local function UnpackColor(Color: { R: number, G: number, B: number }): Color3
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadConfiguration(Configuration: string): boolean?
	local Success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
	local Changed = false
	if not Success then return nil end
	for FlagName, Flag in pairs(RayfieldLibrary.Flags) do
		local FlagValue = Data[FlagName]
		if (typeof(FlagValue) == 'boolean' and FlagValue == false) or FlagValue then
			task.spawn(function()
				if Flag.Type == "ColorPicker" then
					Changed = true
					Flag:Set(UnpackColor(FlagValue))
				else
					if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then
						Changed = true
						Flag:Set(FlagValue)
					end
				end
			end)
		end
	end
	return Changed
end

local function SaveConfiguration()
	if not CEnabled or not GlobalLoaded then return end
	local Data = {}
	for I, V in pairs(RayfieldLibrary.Flags) do
		if V.Type == "ColorPicker" then
			Data[I] = PackColor(V.Color)
		else
			Data[I] = V.CurrentValue or V.CurrentKeybind or V.CurrentOption or V.Color
			if typeof(V.CurrentValue) == 'boolean' and V.CurrentValue == false then Data[I] = false end
		end
	end
	if UseStudio then
		if script.Parent:FindFirstChild('configuration') then script.Parent.configuration:Destroy() end
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = script.Parent
		ScreenGui.Name = 'configuration'
		local TextBox = Instance.new("TextBox")
		TextBox.Parent = ScreenGui
		TextBox.Size = UDim2.new(0, 800, 0, 50)
		TextBox.AnchorPoint = Vector2.new(0.5, 0)
		TextBox.Position = UDim2.new(0.5, 0, 0, 30)
		TextBox.Text = HttpService:JSONEncode(Data)
		TextBox.ClearTextOnFocus = false
	end
	CallSafely(writefile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
end

function RayfieldLibrary:Notify(data: { Title: string?, Content: string?, Image: any?, Duration: number?, Actions: any? })
	task.spawn(function()
		local NewNotification = Notifications.Template:Clone()
		NewNotification.Name = data.Title or 'No Title Provided'
		NewNotification.Parent = Notifications
		NewNotification.LayoutOrder = #Notifications:GetChildren()
		NewNotification.Visible = false
		NewNotification.Title.Text = data.Title or "Unknown Title"
		NewNotification.Description.Text = data.Content or "Unknown Content"
		if data.Image then
			local Img, RectOffset, RectSize = ResolveIcon(data.Image)
			NewNotification.Icon.Image = Img
			if RectOffset then NewNotification.Icon.ImageRectOffset = RectOffset end
			if RectSize then NewNotification.Icon.ImageRectSize = RectSize end
		else
			NewNotification.Icon.Image = ""
		end
		NewNotification.Title.TextColor3 = SelectedTheme.TextColor
		NewNotification.Description.TextColor3 = SelectedTheme.TextColor
		NewNotification.BackgroundColor3 = SelectedTheme.Background
		NewNotification.UIStroke.Color = SelectedTheme.TextColor
		NewNotification.Icon.ImageColor3 = SelectedTheme.TextColor
		NewNotification.BackgroundTransparency = 1
		NewNotification.Title.TextTransparency = 1
		NewNotification.Description.TextTransparency = 1
		NewNotification.UIStroke.Transparency = 1
		NewNotification.Shadow.ImageTransparency = 1
		NewNotification.Size = UDim2.new(1, 0, 0, 800)
		NewNotification.Icon.ImageTransparency = 1
		NewNotification.Icon.BackgroundTransparency = 1
		task.wait()
		NewNotification.Visible = true
		local Bounds = { NewNotification.Title.TextBounds.Y, NewNotification.Description.TextBounds.Y }
		NewNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)
		NewNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
		NewNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)
		TweenService:Create(NewNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, 0, 0, math.max(Bounds[1] + Bounds[2] + 31, 60)) }):Play()
		task.wait(0.15)
		TweenService:Create(NewNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.45 }):Play()
		TweenService:Create(NewNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
		task.wait(0.05)
		TweenService:Create(NewNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
		task.wait(0.05)
		TweenService:Create(NewNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0.35 }):Play()
		TweenService:Create(NewNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 0.95 }):Play()
		TweenService:Create(NewNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.82 }):Play()
		local WaitDuration = math.min(math.max((#NewNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or WaitDuration)
		NewNotification.Icon.Visible = false
		TweenService:Create(NewNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(NewNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
		TweenService:Create(NewNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
		TweenService:Create(NewNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		TweenService:Create(NewNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		TweenService:Create(NewNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -90, 0, 0) }):Play()
		task.wait(1)
		TweenService:Create(NewNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset) }):Play()
		NewNotification.Visible = false
		NewNotification:Destroy()
	end)
end

local function OpenSearch()
	SearchOpen = true
	Main.Search.BackgroundTransparency = 1
	Main.Search.Shadow.ImageTransparency = 1
	Main.Search.Input.TextTransparency = 1
	Main.Search.Search.ImageTransparency = 1
	Main.Search.UIStroke.Transparency = 1
	Main.Search.Size = UDim2.new(1, 0, 0, 80)
	Main.Search.Position = UDim2.new(0.5, 0, 0, 70)
	Main.Search.Input.Interactable = true
	Main.Search.Visible = true
	for _, TabBtn in ipairs(TabList:GetChildren()) do
		if TabBtn.ClassName == "Frame" and TabBtn.Name ~= "Placeholder" then
			TabBtn.Interact.Visible = false
			TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
			TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
			TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
		end
	end
	Main.Search.Input:CaptureFocus()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.05, Enum.EasingStyle.Quint), { ImageTransparency = 0.95 }):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Position = UDim2.new(0.5, 0, 0, 57), BackgroundTransparency = 0.9 }):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 0.8 }):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.5 }):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -35, 0, 35) }):Play()
end

local function CloseSearch()
	SearchOpen = false
	TweenService:Create(Main.Search, TweenInfo.new(0.35, Enum.EasingStyle.Quint), { BackgroundTransparency = 1, Size = UDim2.new(1, -55, 0, 30) }):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { ImageTransparency = 1 }):Play()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { ImageTransparency = 1 }):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { Transparency = 1 }):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { TextTransparency = 1 }):Play()
	for _, TabBtn in ipairs(TabList:GetChildren()) do
		if TabBtn.ClassName == "Frame" and TabBtn.Name ~= "Placeholder" then
			TabBtn.Interact.Visible = true
			if tostring(Elements.UIPageLayout.CurrentPage) == TabBtn.Title.Text then
				TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
				TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
				TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
			else
				TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play()
				TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
				TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
				TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 0.5 }):Play()
			end
		end
	end
	Main.Search.Input.Text = ''
	Main.Search.Input.Interactable = false
end

local function SetElementsVisible(show: boolean)
	for _, Tab in ipairs(Elements:GetChildren()) do
		if Tab.Name ~= "Template" and Tab.ClassName == "ScrollingFrame" and Tab.Name ~= "Placeholder" then
			for _, Element in ipairs(Tab:GetChildren()) do
				if Element.ClassName == "Frame" then
					if Element.Name ~= "SectionSpacing" and Element.Name ~= "Placeholder" then
						if Element.Name == "SectionTitle" or Element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
							TweenService:Create(Element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = show and 0.4 or 1 }):Play()
						elseif Element.Name == 'Divider' then
							TweenService:Create(Element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = show and 0.85 or 1 }):Play()
						else
							local BgTarget = Element:GetAttribute("BackgroundTransparencyTarget") or 0
							local StrokeTarget = Element:GetAttribute("UIStrokeTransparencyTarget") or 0
							local TitleTarget = Element:GetAttribute("TitleTextTransparencyTarget") or 0
							TweenService:Create(Element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = show and BgTarget or 1 }):Play()
							TweenService:Create(Element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = show and StrokeTarget or 1 }):Play()
							TweenService:Create(Element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = show and TitleTarget or 1 }):Play()
						end
						for _, Child in ipairs(Element:GetChildren()) do
							if Child.ClassName == "Frame" or Child.ClassName == "TextLabel" or Child.ClassName == "TextBox" or Child.ClassName == "ImageButton" or Child.ClassName == "ImageLabel" then
								Child.Visible = show
							end
						end
					end
				end
			end
		end
	end
end

local function SetTabButtonsVisible(show: boolean)
	for _, TabBtn in ipairs(TabList:GetChildren()) do
		if TabBtn.ClassName == "Frame" and TabBtn.Name ~= "Placeholder" then
			if show then
				if tostring(Elements.UIPageLayout.CurrentPage) == TabBtn.Title.Text then
					TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
					TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
					TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
					TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
				else
					TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play()
					TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
					TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
					TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 0.5 }):Play()
				end
			else
				TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
				TweenService:Create(TabBtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
				TweenService:Create(TabBtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
				TweenService:Create(TabBtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
			end
		end
	end
end

local function Hide(notify: boolean?)
	if MPrompt then
		MPrompt.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		MPrompt.Position = UDim2.new(0.5, 0, 0, -50)
		MPrompt.Size = UDim2.new(0, 40, 0, 10)
		MPrompt.BackgroundTransparency = 1
		MPrompt.Title.TextTransparency = 1
		MPrompt.Visible = true
	end
	task.spawn(CloseSearch)
	Debounce = true
	if notify then
		RayfieldLibrary:Notify({ Title = "Interface Hidden", Content = "The interface has been hidden.", Duration = 7, Image = 4400697855 })
	end
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 470, 0, 0) }):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 470, 0, 45) }):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
	if DragBarCosmetic then TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play() end
	if UseMobilePrompt and MPrompt then
		TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.3 }):Play()
		TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0.3 }):Play()
	end
	for _, TopbarButton in ipairs(Topbar:GetChildren()) do
		if TopbarButton.ClassName == "ImageButton" then TweenService:Create(TopbarButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play() end
	end
	SetTabButtonsVisible(false)
	if DragInteract then DragInteract.Visible = false end
	SetElementsVisible(false)
	task.wait(0.5)
	Main.Visible = false
	Debounce = false
end

local function Maximise()
	Debounce = true
	Topbar.ChangeSize.Image = CustomAssets[tostring(10137941941)]
	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 0.6 }):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.7 }):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UseMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475) }):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 500, 0, 45) }):Play()
	TabList.Visible = true
	task.wait(0.2)
	Elements.Visible = true
	SetElementsVisible(true)
	task.wait(0.1)
	SetTabButtonsVisible(true)
	task.wait(0.5)
	Debounce = false
end

local function Unhide()
	Debounce = true
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Visible = true
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UseMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475) }):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 500, 0, 45) }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.6 }):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
	if MPrompt then
		TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 40, 0, 10), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 1 }):Play()
		TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		task.spawn(function() task.wait(0.5) MPrompt.Visible = false end)
	end
	if Minimised then task.spawn(Maximise) end
	DragBar.Position = UseMobileSizing and UDim2.new(0.5, 0, 0.5, DragOffsetMobile) or UDim2.new(0.5, 0, 0.5, DragOffset)
	DragInteract.Visible = true
	for _, TopbarButton in ipairs(Topbar:GetChildren()) do
		if TopbarButton.ClassName == "ImageButton" then
			TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = if TopbarButton.Name == 'Icon' then 0 else 0.8 }):Play()
		end
	end
	SetTabButtonsVisible(true)
	SetElementsVisible(true)
	TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 }):Play()
	task.wait(0.5)
	Minimised = false
	Debounce = false
end

local function Minimise()
	Debounce = true
	Topbar.ChangeSize.Image = CustomAssets[tostring(11036884234)]
	Topbar.UIStroke.Color = SelectedTheme.ElementStroke
	task.spawn(CloseSearch)
	SetTabButtonsVisible(false)
	SetElementsVisible(false)
	TweenService:Create(DragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 495, 0, 45) }):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 495, 0, 45) }):Play()
	task.wait(0.3)
	Elements.Visible = false
	TabList.Visible = false
	task.wait(0.2)
	Debounce = false
end

local function SaveSettings()
	local Encoded = nil
	local Success = pcall(function() Encoded = HttpService:JSONEncode(SettingsTable) end)
	if Success then
		if UseStudio and script.Parent:FindFirstChild('get.val') then script.Parent['get.val'].Value = Encoded end
		CallSafely(writefile, RayfieldFolder .. '/settings' .. ConfigurationExtension, Encoded)
	end
end

local function UpdateSetting(category: string, setting: string, value: any)
	if not SettingsInitialized then return end
	SettingsTable[category][setting].Value = value
	OverriddenSettings[category .. "." .. setting] = nil
	SaveSettings()
end

local function CreateSettings(window: any)
	if not (writefile and isfile and readfile and isfolder and makefolder) and not UseStudio then
		if Topbar['Settings'] then Topbar.Settings.Visible = false end
		Topbar['Search'].Position = UDim2.new(1, -75, 0.5, 0)
		return
	end
	local NewTab = window:CreateTab('Rayfield Settings', 0, true)
	if TabList['Rayfield Settings'] then TabList['Rayfield Settings'].LayoutOrder = 1000 end
	if Elements['Rayfield Settings'] then Elements['Rayfield Settings'].LayoutOrder = 1000 end
	for CategoryName, SettingCategory in pairs(SettingsTable) do
		NewTab:CreateSection(CategoryName)
		for SettingName, Setting in pairs(SettingCategory) do
			if Setting.Type == 'input' then
				Setting.Element = NewTab:CreateInput({ Name = Setting.Name, CurrentValue = Setting.Value, PlaceholderText = Setting.Placeholder, Ext = true, RemoveTextAfterFocusLost = Setting.ClearOnFocus, Callback = function(Value) UpdateSetting(CategoryName, SettingName, Value) end })
			elseif Setting.Type == 'toggle' then
				Setting.Element = NewTab:CreateToggle({ Name = Setting.Name, CurrentValue = Setting.Value, Ext = true, Callback = function(Value) UpdateSetting(CategoryName, SettingName, Value) end })
			elseif Setting.Type == 'bind' then
				Setting.Element = NewTab:CreateKeybind({ Name = Setting.Name, CurrentKeybind = Setting.Value, HoldToInteract = false, Ext = true, CallOnChange = true, Callback = function(Value) UpdateSetting(CategoryName, SettingName, Value) end })
			end
		end
	end
	SettingsCreated = true
	LoadSettings()
	SaveSettings()
end

local function FadeOutKeyUi(KeyMain: Frame)
	TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 467, 0, 175) }):Play()
	TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
	TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
	TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
end

function RayfieldLibrary:CreateWindow(Settings: { Name: string, ToggleUIKeybind: any?, ShowText: string?, LoadingTitle: string?, LoadingSubtitle: string?, Icon: any?, Theme: any?, DisableBuildWarnings: boolean?, DisableRayfieldPrompts: boolean?, ConfigurationSaving: { Enabled: boolean?, FileName: string?, FolderName: string? }?, Discord: { Enabled: boolean?, Invite: string?, RememberJoins: boolean? }?, KeySystem: boolean?, KeySettings: { Key: any?, GrabKeyFromSite: boolean?, FileName: string?, MaxAttempts: number?, SaveKey: boolean?, Title: string?, Subtitle: string?, Note: string? }? })
	if Rayfield:FindFirstChild('Loading') then
		if getgenv and not getgenv().rayfieldCached then
			Rayfield.Enabled = true
			Rayfield.Loading.Visible = true
			task.wait(1.4)
			Rayfield.Loading.Visible = false
		end
	end
	if getgenv then getgenv().rayfieldCached = true end
	if not CorrectBuild and not Settings.DisableBuildWarnings then
		task.delay(3, function()
			RayfieldLibrary:Notify({ Title = 'Build Mismatch', Content = 'Rayfield may encounter issues.', Image = 4335487866, Duration = 15 })
		end)
	end
	if Settings.ToggleUIKeybind then
		local Keybind = Settings.ToggleUIKeybind
		if type(Keybind) == "string" then
			Keybind = string.upper(Keybind)
			OverrideSetting("General", "RayfieldOpen", Keybind)
		elseif typeof(Keybind) == "EnumItem" then
			OverrideSetting("General", "RayfieldOpen", Keybind.Name)
		end
	end
	EnsureFolder(RayfieldFolder)
	local Passthrough = false
	Topbar.Title.Text = Settings.Name
	Main.Size = UDim2.new(0, 420, 0, 100)
	Main.Visible = true
	Main.BackgroundTransparency = 1
	if Main:FindFirstChild('Notice') then Main.Notice.Visible = false end
	Main.Shadow.Image.ImageTransparency = 1
	LoadingFrame.Title.TextTransparency = 1
	LoadingFrame.Subtitle.TextTransparency = 1
	if Settings.ShowText then MPrompt.Title.Text = 'Show ' .. Settings.ShowText end
	LoadingFrame.Version.TextTransparency = 1
	LoadingFrame.Title.Text = Settings.LoadingTitle or "Rayfield"
	LoadingFrame.Subtitle.Text = Settings.LoadingSubtitle or "Interface Suite"
	if Settings.LoadingTitle ~= "Rayfield Interface Suite" then LoadingFrame.Version.Text = "Rayfield UI" end
	if Settings.Icon and Settings.Icon ~= 0 and Topbar:FindFirstChild('Icon') then
		Topbar.Icon.Visible = true
		Topbar.Title.Position = UDim2.new(0, 47, 0.5, 0)
		local Img, RectOffset, RectSize = ResolveIcon(Settings.Icon)
		Topbar.Icon.Image = Img
		if RectOffset then Topbar.Icon.ImageRectOffset = RectOffset end
		if RectSize then Topbar.Icon.ImageRectSize = RectSize end
	end
	if DragBar then
		DragBar.Visible = false
		DragBarCosmetic.BackgroundTransparency = 1
		DragBar.Visible = true
	end
	if Settings.Theme then
		local Success = pcall(ChangeTheme, Settings.Theme)
		if not Success then pcall(ChangeTheme, 'Default') end
	end
	Topbar.Visible = false
	Elements.Visible = false
	LoadingFrame.Visible = true
	if not Settings.DisableRayfieldPrompts then
		task.spawn(function()
			while not RayfieldDestroyed do
				task.wait(math.random(180, 600))
				if RayfieldDestroyed then break end
				RayfieldLibrary:Notify({ Title = "Rayfield Interface", Content = "Enjoying this UI library?", Duration = 7, Image = 4370033185 })
			end
		end)
	end
	pcall(function()
		if not Settings.ConfigurationSaving.FileName then Settings.ConfigurationSaving.FileName = tostring(game.PlaceId) end
		if Settings.ConfigurationSaving.Enabled == nil then Settings.ConfigurationSaving.Enabled = false end
		CFileName = Settings.ConfigurationSaving.FileName
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
		CEnabled = Settings.ConfigurationSaving.Enabled
		if Settings.ConfigurationSaving.Enabled then EnsureFolder(ConfigurationFolder) end
	end)
	MakeDraggable(Main, Topbar, false, { DragOffset, DragOffsetMobile })
	if DragBar then
		DragBar.Position = UseMobileSizing and UDim2.new(0.5, 0, 0.5, DragOffsetMobile) or UDim2.new(0.5, 0, 0.5, DragOffset)
		MakeDraggable(Main, DragInteract, true, { DragOffset, DragOffsetMobile })
	end
	for _, TabButton in ipairs(TabList:GetChildren()) do
		if TabButton.ClassName == "Frame" and TabButton.Name ~= "Placeholder" then
			TabButton.BackgroundTransparency = 1
			TabButton.Title.TextTransparency = 1
			TabButton.Image.ImageTransparency = 1
			TabButton.UIStroke.Transparency = 1
		end
	end
	if Settings.Discord and Settings.Discord.Enabled and not UseStudio and not SecureMode then
		EnsureFolder(RayfieldFolder .. "/Discord Invites")
		if not CallSafely(isfile, RayfieldFolder .. "/Discord Invites" .. "/" .. Settings.Discord.Invite .. ConfigurationExtension) then
			if RequestFunc then
				pcall(function()
					RequestFunc({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = "POST",
						Headers = { ['Content-Type'] = 'application/json', Origin = 'https://discord.com' },
						Body = HttpService:JSONEncode({ cmd = 'INVITE_BROWSER', nonce = HttpService:GenerateGUID(false), args = { code = Settings.Discord.Invite } })
					})
				end)
			end
			if Settings.Discord.RememberJoins then
				CallSafely(writefile, RayfieldFolder .. "/Discord Invites" .. "/" .. Settings.Discord.Invite .. ConfigurationExtension, "Rayfield RememberJoins is true")
			end
		end
	end
	if Settings.KeySystem then
		if not Settings.KeySettings then Passthrough = true else
			EnsureFolder(RayfieldFolder .. "/Key System")
			if typeof(Settings.KeySettings.Key) == "string" then Settings.KeySettings.Key = { Settings.KeySettings.Key } end
			if Settings.KeySettings.GrabKeyFromSite then
				for I, Key in ipairs(Settings.KeySettings.Key) do
					local Success, Response = pcall(function()
						Settings.KeySettings.Key[I] = tostring(game:HttpGet(Key):gsub("[\n\r]", " "))
						Settings.KeySettings.Key[I] = string.gsub(Settings.KeySettings.Key[I], " ", "")
					end)
				end
			end
			if not Settings.KeySettings.FileName then Settings.KeySettings.FileName = "No file name specified" end
			if CallSafely(isfile, RayfieldFolder .. "/Key System" .. "/" .. Settings.KeySettings.FileName .. ConfigurationExtension) then
				for _, MKey in ipairs(Settings.KeySettings.Key) do
					local SavedKeys = CallSafely(readfile, RayfieldFolder .. "/Key System" .. "/" .. Settings.KeySettings.FileName .. ConfigurationExtension)
					if SavedKeys and string.find(SavedKeys, MKey) then Passthrough = true end
				end
			end
			if not Passthrough and SecureMode then
				Rayfield.Enabled = false
				return RayfieldLibrary
			end
			if not Passthrough then
				local AttemptsRemaining = Settings.KeySettings.MaxAttempts or 5
				Rayfield.Enabled = false
				local KeyUi = UseStudio and script.Parent:FindFirstChild('Key') or game:GetObjects("rbxassetid://11380036235")[1]
				KeyUi.Enabled = true
				if gethui then KeyUi.Parent = gethui() elseif syn and syn.protect_gui then syn.protect_gui(KeyUi) KeyUi.Parent = CoreGui elseif not UseStudio and CoreGui:FindFirstChild("RobloxGui") then KeyUi.Parent = CoreGui:FindFirstChild("RobloxGui") elseif not UseStudio then KeyUi.Parent = CoreGui end
				local KeyMain = KeyUi.Main
				KeyMain.Title.Text = Settings.KeySettings.Title or Settings.Name
				KeyMain.Subtitle.Text = Settings.KeySettings.Subtitle or "Key System"
				KeyMain.NoteMessage.Text = Settings.KeySettings.Note or "No instructions"
				KeyMain.Size = UDim2.new(0, 467, 0, 175)
				KeyMain.BackgroundTransparency = 1
				KeyMain.Shadow.Image.ImageTransparency = 1
				KeyMain.Title.TextTransparency = 1
				KeyMain.Subtitle.TextTransparency = 1
				KeyMain.KeyNote.TextTransparency = 1
				KeyMain.Input.BackgroundTransparency = 1
				KeyMain.Input.UIStroke.Transparency = 1
				KeyMain.Input.InputBox.TextTransparency = 1
				KeyMain.NoteTitle.TextTransparency = 1
				KeyMain.NoteMessage.TextTransparency = 1
				KeyMain.Hide.ImageTransparency = 1
				TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
				TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 500, 0, 187) }):Play()
				TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 0.5 }):Play()
				task.wait(0.05)
				TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				task.wait(0.05)
				TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
				TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				task.wait(0.05)
				TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
				task.wait(0.15)
				TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { ImageTransparency = 0.3 }):Play()
				KeyUi.Main.Input.InputBox.FocusLost:Connect(function()
					if #KeyUi.Main.Input.InputBox.Text == 0 then return end
					local KeyFound = false
					local FoundKey = ''
					for _, MKey in ipairs(Settings.KeySettings.Key) do
						if KeyMain.Input.InputBox.Text == MKey then KeyFound = true FoundKey = MKey end
					end
					if KeyFound then
						FadeOutKeyUi(KeyMain)
						task.wait(0.51)
						Passthrough = true
						KeyMain.Visible = false
						if Settings.KeySettings.SaveKey then
							CallSafely(writefile, RayfieldFolder .. "/Key System" .. "/" .. Settings.KeySettings.FileName .. ConfigurationExtension, FoundKey)
							RayfieldLibrary:Notify({ Title = "Key System", Content = "Key saved.", Image = 3605522284 })
						end
					else
						if AttemptsRemaining == 0 then
							FadeOutKeyUi(KeyMain)
							task.wait(0.45)
							Players.LocalPlayer:Kick("No Attempts Remaining")
							game:Shutdown()
						end
						KeyMain.Input.InputBox.Text = ""
						AttemptsRemaining -= 1
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 467, 0, 175) }):Play()
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), { Position = UDim2.new(0.495, 0, 0.5, 0) }):Play()
						task.wait(0.1)
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), { Position = UDim2.new(0.505, 0, 0.5, 0) }):Play()
						task.wait(0.1)
						TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 500, 0, 187) }):Play()
					end
				end)
				KeyMain.Hide.MouseButton1Click:Connect(function()
					FadeOutKeyUi(KeyMain)
					task.wait(0.51)
					Passthrough = true
					RayfieldLibrary:Destroy()
					KeyUi:Destroy()
				end)
			else
				Passthrough = true
			end
		end
		if Settings.KeySystem then
			repeat task.wait() until Passthrough
			if RayfieldDestroyed then return end
		end
	end
	Notifications.Template.Visible = false
	Notifications.Visible = true
	Rayfield.Enabled = true
	task.wait(0.5)
	TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.6 }):Play()
	task.wait(0.1)
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
	task.wait(0.05)
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
	task.wait(0.05)
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
	Elements.Template.LayoutOrder = 100000
	Elements.Template.Visible = false
	Elements.UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
	Elements.UIPageLayout.ScrollWheelInputEnabled = false
	Elements.UIPageLayout.GamepadInputEnabled = false
	Elements.UIPageLayout.TouchInputEnabled = false
	TabList.Template.Visible = false
	local FirstTab = false
	local Window = {}

	function Window:CreateTab(Name: string, Image: any?, Ext: boolean?)
		local SDone = false
		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Parent = TabList
		TabButton.Title.TextWrapped = false
		TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 30, 0, 30)
		if Image and Image ~= 0 then
			local Img, RectOffset, RectSize = ResolveIcon(Image)
			TabButton.Image.Image = Img
			if RectOffset then TabButton.Image.ImageRectOffset = RectOffset end
			if RectSize then TabButton.Image.ImageRectSize = RectSize end
			TabButton.Title.AnchorPoint = Vector2.new(0, 0.5)
			TabButton.Title.Position = UDim2.new(0, 37, 0.5, 0)
			TabButton.Image.Visible = true
			TabButton.Title.TextXAlignment = Enum.TextXAlignment.Left
			TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 52, 0, 30)
		end
		TabButton.BackgroundTransparency = 1
		TabButton.Title.TextTransparency = 1
		TabButton.Image.ImageTransparency = 1
		TabButton.UIStroke.Transparency = 1
		TabButton.Visible = not Ext or false
		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = true
		TabPage.LayoutOrder = Ext and 10000 or #Elements:GetChildren()
		for _, TemplateElement in ipairs(TabPage:GetChildren()) do
			if TemplateElement.ClassName == "Frame" and TemplateElement.Name ~= "Placeholder" then TemplateElement:Destroy() end
		end
		TabPage.Parent = Elements
		if not FirstTab and not Ext then
			Elements.UIPageLayout.Animated = false
			Elements.UIPageLayout:JumpTo(TabPage)
			Elements.UIPageLayout.Animated = true
		end
		TabButton.UIStroke.Color = SelectedTheme.TabStroke
		if Elements.UIPageLayout.CurrentPage == TabPage then
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
		else
			TabButton.BackgroundColor3 = SelectedTheme.TabBackground
			TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
		end
		task.wait(0.1)
		if FirstTab or Ext then
			TabButton.BackgroundColor3 = SelectedTheme.TabBackground
			TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
			TweenService:Create(TabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0.5 }):Play()
		elseif not Ext then
			FirstTab = Name
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
		end
		TabButton.Interact.MouseButton1Click:Connect(function()
			if Minimised then return end
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(TabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.TabBackgroundSelected }):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextColor3 = SelectedTheme.SelectedTabTextColor }):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageColor3 = SelectedTheme.SelectedTabTextColor }):Play()
			for _, OtherTabButton in ipairs(TabList:GetChildren()) do
				if OtherTabButton.Name ~= "Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton and OtherTabButton.Name ~= "Placeholder" then
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.TabBackground }):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextColor3 = SelectedTheme.TabTextColor }):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageColor3 = SelectedTheme.TabTextColor }):Play()
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
					TweenService:Create(OtherTabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0.5 }):Play()
				end
			end
			if Elements.UIPageLayout.CurrentPage ~= TabPage then Elements.UIPageLayout:JumpTo(TabPage) end
		end)
		local Tab = {}

		function Tab:CreateButton(ButtonSettings: { Name: string, Callback: () -> (), Ext: boolean? })
			local ButtonValue = {}
			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Visible = true
			Button.Parent = TabPage
			Button.BackgroundTransparency = 1
			Button.UIStroke.Transparency = 1
			Button.Title.TextTransparency = 1
			TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			Button.Interact.MouseButton1Click:Connect(function()
				local Success, Response = pcall(ButtonSettings.Callback)
				if RayfieldDestroyed then return end
				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = Color3.fromRGB(85, 0, 0) }):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					Button.Title.Text = "Callback Error"
					task.wait(0.5)
					Button.Title.Text = ButtonSettings.Name
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { TextTransparency = 0.9 }):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				else
					if not ButtonSettings.Ext then SaveConfiguration(ButtonSettings.Name .. '\n') end
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					task.wait(0.2)
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { TextTransparency = 0.9 }):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				end
			end)
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfoHover, { TextTransparency = 0.7 }):Play()
			end)
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfoHover, { TextTransparency = 0.9 }):Play()
			end)
			function ButtonValue:Set(NewButton: string)
				Button.Title.Text = NewButton
				Button.Name = NewButton
			end
			return ButtonValue
		end

		function Tab:CreateColorPicker(ColorPickerSettings: { Name: string, Color: Color3, Flag: string?, Callback: (Color3) -> (), Ext: boolean? })
			ColorPickerSettings.Type = "ColorPicker"
			local ColorPicker = Elements.Template.ColorPicker:Clone()
			local Background = ColorPicker.CPBackground
			local Display = Background.Display
			local Main = Background.MainCP
			local Slider = ColorPicker.ColorSlider
			ColorPicker.ClipsDescendants = true
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage
			ColorPicker.Size = UDim2.new(1, -10, 0, 45)
			Background.Size = UDim2.new(0, 39, 0, 22)
			Display.BackgroundTransparency = 0
			Main.MainPoint.ImageTransparency = 1
			ColorPicker.Interact.Size = UDim2.new(1, 0, 1, 0)
			ColorPicker.Interact.Position = UDim2.new(0.5, 0, 0.5, 0)
			ColorPicker.RGB.Position = UDim2.new(0, 17, 0, 70)
			ColorPicker.HexInput.Position = UDim2.new(0, 17, 0, 90)
			Main.ImageTransparency = 1
			Background.BackgroundTransparency = 1
			for _, RgbInput in ipairs(ColorPicker.RGB:GetChildren()) do
				if RgbInput:IsA("Frame") then
					RgbInput.BackgroundColor3 = SelectedTheme.InputBackground
					RgbInput.UIStroke.Color = SelectedTheme.InputStroke
				end
			end
			ColorPicker.HexInput.BackgroundColor3 = SelectedTheme.InputBackground
			ColorPicker.HexInput.UIStroke.Color = SelectedTheme.InputStroke
			local Opened = false
			local Mouse = Players.LocalPlayer:GetMouse()
			local MainDragging = false
			local SliderDragging = false
			ColorPicker.Interact.MouseButton1Down:Connect(function()
				task.spawn(function()
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					task.wait(0.2)
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				end)
				if not Opened then
					Opened = true
					TweenService:Create(Background, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 18, 0, 15) }):Play()
					task.wait(0.1)
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -10, 0, 120) }):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 173, 0, 86) }):Play()
					TweenService:Create(Display, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Position = UDim2.new(0.289, 0, 0.5, 0) }):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), { Position = UDim2.new(0, 17, 0, 40) }):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Position = UDim2.new(0, 17, 0, 73) }):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0.574, 0, 1, 0) }):Play()
					TweenService:Create(Main.MainPoint, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
					TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { ImageTransparency = SelectedTheme ~= RayfieldLibrary.Theme.Default and 0.25 or 0.1 }):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
				else
					Opened = false
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -10, 0, 45) }):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 39, 0, 22) }):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, 0, 1, 0) }):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Position = UDim2.new(0, 17, 0, 70) }):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Position = UDim2.new(0, 17, 0, 90) }):Play()
					TweenService:Create(Display, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
					TweenService:Create(Main.MainPoint, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
					TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
				end
			end)
			local ColorPickerInputConnection = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					MainDragging = false
					SliderDragging = false
				end
			end)
			Main.MouseButton1Down:Connect(function() if Opened then MainDragging = true end end)
			Main.MainPoint.MouseButton1Down:Connect(function() if Opened then MainDragging = true end end)
			Slider.MouseButton1Down:Connect(function() SliderDragging = true end)
			Slider.SliderPoint.MouseButton1Down:Connect(function() SliderDragging = true end)
			local H, S, V = ColorPickerSettings.Color:ToHSV()
			local Color = Color3.fromHSV(H, S, V)
			local Hex = string.format("#%02X%02X%02X", Color.R * 0xFF, Color.G * 0xFF, Color.B * 0xFF)
			ColorPicker.HexInput.InputBox.Text = Hex
			local function SetDisplay()
				Main.MainPoint.Position = UDim2.new(S, -Main.MainPoint.AbsoluteSize.X / 2, 1 - V, -Main.MainPoint.AbsoluteSize.Y / 2)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(H, S, V)
				Background.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
				Display.BackgroundColor3 = Color3.fromHSV(H, S, V)
				local X = H * Slider.AbsoluteSize.X
				Slider.SliderPoint.Position = UDim2.new(0, X - Slider.SliderPoint.AbsoluteSize.X / 2, 0.5, 0)
				Slider.SliderPoint.ImageColor3 = Color3.fromHSV(H, 1, 1)
				local C = Color3.fromHSV(H, S, V)
				local R, G, B = math.floor((C.R * 255) + 0.5), math.floor((C.G * 255) + 0.5), math.floor((C.B * 255) + 0.5)
				ColorPicker.RGB.RInput.InputBox.Text = tostring(R)
				ColorPicker.RGB.GInput.InputBox.Text = tostring(G)
				ColorPicker.RGB.BInput.InputBox.Text = tostring(B)
				Hex = string.format("#%02X%02X%02X", C.R * 0xFF, C.G * 0xFF, C.B * 0xFF)
				ColorPicker.HexInput.InputBox.Text = Hex
			end
			SetDisplay()
			ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
				local Success = pcall(function()
					local R, G, B = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
					local RgbColor = Color3.fromRGB(tonumber(R, 16), tonumber(G, 16), tonumber(B, 16))
					H, S, V = RgbColor:ToHSV()
					Hex = ColorPicker.HexInput.InputBox.Text
					SetDisplay()
					ColorPickerSettings.Color = RgbColor
				end)
				if not Success then ColorPicker.HexInput.InputBox.Text = Hex end
				pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end)
				local R, G, B = math.floor((H * 255) + 0.5), math.floor((S * 255) + 0.5), math.floor((V * 255) + 0.5)
				ColorPickerSettings.Color = Color3.fromRGB(R, G, B)
				if not ColorPickerSettings.Ext then SaveConfiguration() end
			end)
			local function RgbBoxes(box: TextBox, toChange: string)
				local Value = tonumber(box.Text)
				local C = Color3.fromHSV(H, S, V)
				local OldR, OldG, OldB = math.floor((C.R * 255) + 0.5), math.floor((C.G * 255) + 0.5), math.floor((C.B * 255) + 0.5)
				local Save = 0
				if toChange == "R" then Save = OldR OldR = Value elseif toChange == "G" then Save = OldG OldG = Value else Save = OldB OldB = Value end
				if Value then
					Value = math.clamp(Value, 0, 255)
					H, S, V = Color3.fromRGB(OldR, OldG, OldB):ToHSV()
					SetDisplay()
				else
					box.Text = tostring(Save)
				end
				local R, G, B = math.floor((H * 255) + 0.5), math.floor((S * 255) + 0.5), math.floor((V * 255) + 0.5)
				ColorPickerSettings.Color = Color3.fromRGB(R, G, B)
				if not ColorPickerSettings.Ext then SaveConfiguration(ColorPickerSettings.Flag .. '\n' .. tostring(ColorPickerSettings.Color)) end
			end
			ColorPicker.RGB.RInput.InputBox.FocusLost:Connect(function() RgbBoxes(ColorPicker.RGB.RInput.InputBox, "R") pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end) end)
			ColorPicker.RGB.GInput.InputBox.FocusLost:Connect(function() RgbBoxes(ColorPicker.RGB.GInput.InputBox, "G") pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end) end)
			ColorPicker.RGB.BInput.InputBox.FocusLost:Connect(function() RgbBoxes(ColorPicker.RGB.BInput.InputBox, "B") pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end) end)
			local ColorPickerRenderConnection = RunService.RenderStepped:Connect(function()
				if MainDragging then
					local LocalX = math.clamp(Mouse.X - Main.AbsolutePosition.X, 0, Main.AbsoluteSize.X)
					local LocalY = math.clamp(Mouse.Y - Main.AbsolutePosition.Y, 0, Main.AbsoluteSize.Y)
					Main.MainPoint.Position = UDim2.new(0, LocalX - Main.MainPoint.AbsoluteSize.X / 2, 0, LocalY - Main.MainPoint.AbsoluteSize.Y / 2)
					S = LocalX / Main.AbsoluteSize.X
					V = 1 - (LocalY / Main.AbsoluteSize.Y)
					Display.BackgroundColor3 = Color3.fromHSV(H, S, V)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(H, S, V)
					Background.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
					local C = Color3.fromHSV(H, S, V)
					local R, G, B = math.floor((C.R * 255) + 0.5), math.floor((C.G * 255) + 0.5), math.floor((C.B * 255) + 0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(R)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(G)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(B)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X", C.R * 0xFF, C.G * 0xFF, C.B * 0xFF)
					pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end)
					ColorPickerSettings.Color = Color3.fromRGB(R, G, B)
					if not ColorPickerSettings.Ext then SaveConfiguration() end
				end
				if SliderDragging then
					local LocalX = math.clamp(Mouse.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
					H = LocalX / Slider.AbsoluteSize.X
					Display.BackgroundColor3 = Color3.fromHSV(H, S, V)
					Slider.SliderPoint.Position = UDim2.new(0, LocalX - Slider.SliderPoint.AbsoluteSize.X / 2, 0.5, 0)
					Slider.SliderPoint.ImageColor3 = Color3.fromHSV(H, 1, 1)
					Background.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(H, S, V)
					local C = Color3.fromHSV(H, S, V)
					local R, G, B = math.floor((C.R * 255) + 0.5), math.floor((C.G * 255) + 0.5), math.floor((C.B * 255) + 0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(R)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(G)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(B)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X", C.R * 0xFF, C.G * 0xFF, C.B * 0xFF)
					pcall(function() ColorPickerSettings.Callback(Color3.fromHSV(H, S, V)) end)
					ColorPickerSettings.Color = Color3.fromRGB(R, G, B)
					if not ColorPickerSettings.Ext then SaveConfiguration() end
				end
			end)
			ColorPicker.Destroying:Connect(function()
				if ColorPickerRenderConnection then ColorPickerRenderConnection:Disconnect() end
				if ColorPickerInputConnection then ColorPickerInputConnection:Disconnect() end
			end)
			if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and ColorPickerSettings.Flag then
				RayfieldLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
			end
			function ColorPickerSettings:Set(RGBColor: Color3)
				ColorPickerSettings.Color = RGBColor
				H, S, V = ColorPickerSettings.Color:ToHSV()
				Color = Color3.fromHSV(H, S, V)
				SetDisplay()
			end
			ColorPicker.MouseEnter:Connect(function() TweenService:Create(ColorPicker, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end)
			ColorPicker.MouseLeave:Connect(function() TweenService:Create(ColorPicker, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				for _, RgbInput in ipairs(ColorPicker.RGB:GetChildren()) do
					if RgbInput:IsA("Frame") then
						RgbInput.BackgroundColor3 = SelectedTheme.InputBackground
						RgbInput.UIStroke.Color = SelectedTheme.InputStroke
					end
				end
				ColorPicker.HexInput.BackgroundColor3 = SelectedTheme.InputBackground
				ColorPicker.HexInput.UIStroke.Color = SelectedTheme.InputStroke
			end)
			return ColorPickerSettings
		end

		function Tab:CreateSection(SectionName: string)
			local SectionValue = {}
			if SDone then
				local SectionSpace = Elements.Template.SectionSpacing:Clone()
				SectionSpace.Visible = true
				SectionSpace.Parent = TabPage
			end
			local Section = Elements.Template.SectionTitle:Clone()
			Section.Title.Text = SectionName
			Section.Visible = true
			Section.Parent = TabPage
			Section.Title.TextTransparency = 1
			TweenService:Create(Section.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0.4 }):Play()
			function SectionValue:Set(NewSection: string) Section.Title.Text = NewSection end
			SDone = true
			return SectionValue
		end

		function Tab:CreateDivider()
			local DividerValue = {}
			local Divider = Elements.Template.Divider:Clone()
			Divider.Visible = true
			Divider.Parent = TabPage
			Divider.Divider.BackgroundTransparency = 1
			TweenService:Create(Divider.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.85 }):Play()
			function DividerValue:Set(Value: boolean) Divider.Visible = Value end
			return DividerValue
		end

		function Tab:CreateLabel(LabelText: string, Icon: number?, Color: Color3?, IgnoreTheme: boolean?)
			local LabelValue = {}
			local Label = Elements.Template.Label:Clone()
			Label.Title.Text = LabelText
			Label.Visible = true
			Label.Parent = TabPage
			Label.BackgroundColor3 = Color or SelectedTheme.SecondaryElementBackground
			Label.UIStroke.Color = Color or SelectedTheme.SecondaryElementStroke
			if Icon then
				local Img, RectOffset, RectSize = ResolveIcon(Icon)
				Label.Icon.Image = Img
				if RectOffset then Label.Icon.ImageRectOffset = RectOffset end
				if RectSize then Label.Icon.ImageRectSize = RectSize end
			else
				Label.Icon.Image = ""
			end
			if Icon and Label:FindFirstChild('Icon') then
				Label.Title.Position = UDim2.new(0, 45, 0.5, 0)
				Label.Title.Size = UDim2.new(1, -100, 0, 14)
				Label.Icon.Visible = true
			end
			Label.Icon.ImageTransparency = 1
			Label.BackgroundTransparency = 1
			Label.UIStroke.Transparency = 1
			Label.Title.TextTransparency = 1
			Label:SetAttribute("BackgroundTransparencyTarget", Color and 0.8 or 0)
			Label:SetAttribute("UIStrokeTransparencyTarget", Color and 0.7 or 0)
			Label:SetAttribute("TitleTextTransparencyTarget", Color and 0.2 or 0)
			TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = Color and 0.8 or 0 }):Play()
			TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = Color and 0.7 or 0 }):Play()
			TweenService:Create(Label.Icon, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
			TweenService:Create(Label.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = Color and 0.2 or 0 }):Play()
			function LabelValue:Set(NewLabel: string, NewIcon: number?, NewColor: Color3?)
				Label.Title.Text = NewLabel
				if NewColor then
					Label.BackgroundColor3 = NewColor or SelectedTheme.SecondaryElementBackground
					Label.UIStroke.Color = NewColor or SelectedTheme.SecondaryElementStroke
				end
				if NewIcon and Label:FindFirstChild('Icon') then
					Label.Title.Position = UDim2.new(0, 45, 0.5, 0)
					Label.Title.Size = UDim2.new(1, -100, 0, 14)
					local Img, RectOffset, RectSize = ResolveIcon(NewIcon)
					Label.Icon.Image = Img
					if RectOffset then Label.Icon.ImageRectOffset = RectOffset end
					if RectSize then Label.Icon.ImageRectSize = RectSize end
					Label.Icon.Visible = true
				end
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Label.BackgroundColor3 = IgnoreTheme and (Color or Label.BackgroundColor3) or SelectedTheme.SecondaryElementBackground
				Label.UIStroke.Color = IgnoreTheme and (Color or Label.BackgroundColor3) or SelectedTheme.SecondaryElementStroke
			end)
			return LabelValue
		end

		function Tab:CreateParagraph(ParagraphSettings: { Title: string, Content: string })
			local ParagraphValue = {}
			local Paragraph = Elements.Template.Paragraph:Clone()
			Paragraph.Title.Text = ParagraphSettings.Title
			Paragraph.Content.Text = ParagraphSettings.Content
			Paragraph.Visible = true
			Paragraph.Parent = TabPage
			Paragraph.BackgroundTransparency = 1
			Paragraph.UIStroke.Transparency = 1
			Paragraph.Title.TextTransparency = 1
			Paragraph.Content.TextTransparency = 1
			Paragraph.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			Paragraph.UIStroke.Color = SelectedTheme.SecondaryElementStroke
			TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			TweenService:Create(Paragraph.Content, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			function ParagraphValue:Set(NewParagraphSettings: { Title: string, Content: string })
				Paragraph.Title.Text = NewParagraphSettings.Title
				Paragraph.Content.Text = NewParagraphSettings.Content
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Paragraph.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
				Paragraph.UIStroke.Color = SelectedTheme.SecondaryElementStroke
			end)
			return ParagraphValue
		end

		function Tab:CreateInput(InputSettings: { Name: string, CurrentValue: string?, PlaceholderText: string?, Flag: string?, RemoveTextAfterFocusLost: boolean?, Callback: (string) -> (), Ext: boolean? })
			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage
			Input.BackgroundTransparency = 1
			Input.UIStroke.Transparency = 1
			Input.Title.TextTransparency = 1
			Input.InputFrame.InputBox.Text = InputSettings.CurrentValue or ''
			Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
			Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke
			TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Input.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
			Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
			Input.InputFrame.InputBox.FocusLost:Connect(function()
				local Success, Response = pcall(function()
					InputSettings.Callback(Input.InputFrame.InputBox.Text)
					InputSettings.CurrentValue = Input.InputFrame.InputBox.Text
				end)
				if not Success then
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = Color3.fromRGB(85, 0, 0) }):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					Input.Title.Text = "Callback Error"
					task.wait(0.5)
					Input.Title.Text = InputSettings.Name
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				end
				if InputSettings.RemoveTextAfterFocusLost then Input.InputFrame.InputBox.Text = "" end
				if not InputSettings.Ext then SaveConfiguration() end
			end)
			Input.MouseEnter:Connect(function() TweenService:Create(Input, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end)
			Input.MouseLeave:Connect(function() TweenService:Create(Input, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Input.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 24, 0, 30) }):Play()
			end)
			function InputSettings:Set(text: string)
				Input.InputFrame.InputBox.Text = text
				InputSettings.CurrentValue = text
				pcall(function() InputSettings.Callback(text) end)
				if not InputSettings.Ext then SaveConfiguration() end
			end
			if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and InputSettings.Flag then
				RayfieldLibrary.Flags[InputSettings.Flag] = InputSettings
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke
			end)
			return InputSettings
		end

		function Tab:CreateDropdown(DropdownSettings: { Name: string, Options: { string }, CurrentOption: any?, MultipleOptions: boolean?, Flag: string?, Callback: ({ string }) -> (), Ext: boolean? })
			local Dropdown = Elements.Template.Dropdown:Clone()
			Dropdown.Name = if string.find(DropdownSettings.Name, "closed") then "Dropdown" else DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			Dropdown.Visible = true
			Dropdown.Parent = TabPage
			Dropdown.List.Visible = false
			if DropdownSettings.CurrentOption then
				if type(DropdownSettings.CurrentOption) == "string" then DropdownSettings.CurrentOption = { DropdownSettings.CurrentOption } end
				if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then DropdownSettings.CurrentOption = { DropdownSettings.CurrentOption[1] } end
			else
				DropdownSettings.CurrentOption = {}
			end
			if DropdownSettings.MultipleOptions then
				if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
					if #DropdownSettings.CurrentOption == 1 then Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then Dropdown.Selected.Text = "None"
					else Dropdown.Selected.Text = "Various" end
				else
					DropdownSettings.CurrentOption = {}
					Dropdown.Selected.Text = "None"
				end
			else
				Dropdown.Selected.Text = DropdownSettings.CurrentOption[1] or "None"
			end
			Dropdown.Toggle.ImageColor3 = SelectedTheme.TextColor
			TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
			Dropdown.BackgroundTransparency = 1
			Dropdown.UIStroke.Transparency = 1
			Dropdown.Title.TextTransparency = 1
			Dropdown.Size = UDim2.new(1, -10, 0, 45)
			TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Dropdown.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			for _, Ununusedoption in ipairs(Dropdown.List:GetChildren()) do
				if Ununusedoption.ClassName == "Frame" and Ununusedoption.Name ~= "Placeholder" then Ununusedoption:Destroy() end
			end
			Dropdown.Toggle.Rotation = 180
			Dropdown.Interact.MouseButton1Click:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
				task.wait(0.1)
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				if Debounce then return end
				if Dropdown.List.Visible then
					Debounce = true
					TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -10, 0, 45) }):Play()
					for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
						if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
							TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
							TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
							TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
						end
					end
					TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ScrollBarImageTransparency = 1 }):Play()
					TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Rotation = 180 }):Play()
					task.wait(0.35)
					Dropdown.List.Visible = false
					Debounce = false
				else
					TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -10, 0, 180) }):Play()
					Dropdown.List.Visible = true
					TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ScrollBarImageTransparency = 0.7 }):Play()
					TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Rotation = 0 }):Play()
					for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
						if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
							if DropdownOpt.Name ~= Dropdown.Selected.Text then TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play() end
							TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
							TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
						end
					end
				end
			end)
			Dropdown.MouseEnter:Connect(function() if not Dropdown.List.Visible then TweenService:Create(Dropdown, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end end)
			Dropdown.MouseLeave:Connect(function() TweenService:Create(Dropdown, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			local function SetDropdownOptions()
				for _, Option in ipairs(DropdownSettings.Options) do
					local DropdownOption = Elements.Template.Dropdown.List.Template:Clone()
					DropdownOption.Name = Option
					DropdownOption.Title.Text = Option
					DropdownOption.Parent = Dropdown.List
					DropdownOption.Visible = true
					DropdownOption.BackgroundTransparency = 1
					DropdownOption.UIStroke.Transparency = 1
					DropdownOption.Title.TextTransparency = 1
					DropdownOption.Interact.ZIndex = 50
					DropdownOption.Interact.MouseButton1Click:Connect(function()
						if not DropdownSettings.MultipleOptions and table.find(DropdownSettings.CurrentOption, Option) then return end
						if table.find(DropdownSettings.CurrentOption, Option) then
							table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, Option))
							if DropdownSettings.MultipleOptions then
								if #DropdownSettings.CurrentOption == 1 then Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
								elseif #DropdownSettings.CurrentOption == 0 then Dropdown.Selected.Text = "None"
								else Dropdown.Selected.Text = "Various" end
							else
								Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
							end
						else
							if not DropdownSettings.MultipleOptions then table.clear(DropdownSettings.CurrentOption) end
							table.insert(DropdownSettings.CurrentOption, Option)
							if DropdownSettings.MultipleOptions then
								if #DropdownSettings.CurrentOption == 1 then Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
								elseif #DropdownSettings.CurrentOption == 0 then Dropdown.Selected.Text = "None"
								else Dropdown.Selected.Text = "Various" end
							else
								Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
							end
							TweenService:Create(DropdownOption.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
							TweenService:Create(DropdownOption, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.DropdownSelected }):Play()
							Debounce = true
						end
						pcall(function() DropdownSettings.Callback(DropdownSettings.CurrentOption) end)
						for _, Droption in ipairs(Dropdown.List:GetChildren()) do
							if Droption.ClassName == "Frame" and Droption.Name ~= "Placeholder" and not table.find(DropdownSettings.CurrentOption, Droption.Name) then
								TweenService:Create(Droption, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.DropdownUnselected }):Play()
							end
						end
						if not DropdownSettings.MultipleOptions then
							task.wait(0.1)
							TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -10, 0, 45) }):Play()
							for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
								if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
									TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
									TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
									TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
								end
							end
							TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ScrollBarImageTransparency = 1 }):Play()
							TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Rotation = 180 }):Play()
							task.wait(0.35)
							Dropdown.List.Visible = false
						end
						Debounce = false
						if not DropdownSettings.Ext then SaveConfiguration() end
					end)
					Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function() DropdownOption.UIStroke.Color = SelectedTheme.ElementStroke end)
				end
			end
			SetDropdownOptions()
			for _, Droption in ipairs(Dropdown.List:GetChildren()) do
				if Droption.ClassName == "Frame" and Droption.Name ~= "Placeholder" then
					if not table.find(DropdownSettings.CurrentOption, Droption.Name) then Droption.BackgroundColor3 = SelectedTheme.DropdownUnselected else Droption.BackgroundColor3 = SelectedTheme.DropdownSelected end
					Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
						if not table.find(DropdownSettings.CurrentOption, Droption.Name) then Droption.BackgroundColor3 = SelectedTheme.DropdownUnselected else Droption.BackgroundColor3 = SelectedTheme.DropdownSelected end
					end)
				end
			end
			function DropdownSettings:Set(NewOption: any)
				DropdownSettings.CurrentOption = NewOption
				if typeof(DropdownSettings.CurrentOption) == "string" then DropdownSettings.CurrentOption = { DropdownSettings.CurrentOption } end
				if not DropdownSettings.MultipleOptions then DropdownSettings.CurrentOption = { DropdownSettings.CurrentOption[1] } end
				if DropdownSettings.MultipleOptions then
					if #DropdownSettings.CurrentOption == 1 then Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then Dropdown.Selected.Text = "None"
					else Dropdown.Selected.Text = "Various" end
				else
					Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
				end
				pcall(function() DropdownSettings.Callback(DropdownSettings.CurrentOption) end)
				for _, Droption in ipairs(Dropdown.List:GetChildren()) do
					if Droption.ClassName == "Frame" and Droption.Name ~= "Placeholder" then
						if not table.find(DropdownSettings.CurrentOption, Droption.Name) then Droption.BackgroundColor3 = SelectedTheme.DropdownUnselected else Droption.BackgroundColor3 = SelectedTheme.DropdownSelected end
					end
				end
			end
			function DropdownSettings:Refresh(optionsTable: { string })
				DropdownSettings.Options = optionsTable
				for _, Option in Dropdown.List:GetChildren() do
					if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" then Option:Destroy() end
				end
				SetDropdownOptions()
				for _, Droption in ipairs(Dropdown.List:GetChildren()) do
					if Droption.ClassName == "Frame" and Droption.Name ~= "Placeholder" then
						if not table.find(DropdownSettings.CurrentOption, Droption.Name) then Droption.BackgroundColor3 = SelectedTheme.DropdownUnselected else Droption.BackgroundColor3 = SelectedTheme.DropdownSelected end
					end
				end
				if Dropdown.List.Visible then
					for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
						if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
							DropdownOpt.BackgroundTransparency = 0
							DropdownOpt.Title.TextTransparency = 0
							if not table.find(DropdownSettings.CurrentOption, DropdownOpt.Name) then DropdownOpt.UIStroke.Transparency = 0 end
						end
					end
				end
			end
			if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
				RayfieldLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Dropdown.Toggle.ImageColor3 = SelectedTheme.TextColor
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
			end)
			return DropdownSettings
		end

		function Tab:CreateKeybind(KeybindSettings: { Name: string, CurrentKeybind: string, HoldToInteract: boolean?, Flag: string?, CallOnChange: boolean?, Callback: (any) -> (), Ext: boolean? })
			local CheckingForKey = false
			local Keybind = Elements.Template.Keybind:Clone()
			Keybind.Name = KeybindSettings.Name
			Keybind.Title.Text = KeybindSettings.Name
			Keybind.Visible = true
			Keybind.Parent = TabPage
			Keybind.BackgroundTransparency = 1
			Keybind.UIStroke.Transparency = 1
			Keybind.Title.TextTransparency = 1
			Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
			Keybind.KeybindFrame.UIStroke.Color = SelectedTheme.InputStroke
			TweenService:Create(Keybind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Keybind.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
			Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.KeybindBox.TextBounds.X + 24, 0, 30)
			Keybind.KeybindFrame.KeybindBox.Focused:Connect(function() CheckingForKey = true Keybind.KeybindFrame.KeybindBox.Text = "" end)
			Keybind.KeybindFrame.KeybindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Keybind.KeybindFrame.KeybindBox.Text == nil or Keybind.KeybindFrame.KeybindBox.Text == "" then
					Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
					if not KeybindSettings.Ext then SaveConfiguration() end
				end
			end)
			Keybind.MouseEnter:Connect(function() TweenService:Create(Keybind, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end)
			Keybind.MouseLeave:Connect(function() TweenService:Create(Keybind, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			local Connection = UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						local SplitMessage = string.split(tostring(input.KeyCode), ".")
						local NewKeyNoEnum = SplitMessage[3]
						Keybind.KeybindFrame.KeybindBox.Text = tostring(NewKeyNoEnum)
						KeybindSettings.CurrentKeybind = tostring(NewKeyNoEnum)
						Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
						if not KeybindSettings.Ext then SaveConfiguration() end
						if KeybindSettings.CallOnChange then KeybindSettings.Callback(tostring(NewKeyNoEnum)) end
					end
				elseif not KeybindSettings.CallOnChange and KeybindSettings.CurrentKeybind ~= nil and (input.KeyCode == Enum.KeyCode[KeybindSettings.CurrentKeybind] and not processed) then
					local Held = true
					local InputConnection = nil
					InputConnection = input.Changed:Connect(function(prop)
						if prop == "UserInputState" then InputConnection:Disconnect() Held = false end
					end)
					if not KeybindSettings.HoldToInteract then
						pcall(KeybindSettings.Callback)
					else
						task.wait(0.25)
						if Held then
							local Loop = nil
							Loop = RunService.Stepped:Connect(function()
								if not Held then KeybindSettings.Callback(false) Loop:Disconnect() else KeybindSettings.Callback(true) end
							end)
						end
					end
				end
			end)
			table.insert(KeybindConnections, Connection)
			Keybind.KeybindFrame.KeybindBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Keybind.KeybindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, Keybind.KeybindFrame.KeybindBox.TextBounds.X + 24, 0, 30) }):Play()
			end)
			function KeybindSettings:Set(NewKeybind: string)
				Keybind.KeybindFrame.KeybindBox.Text = tostring(NewKeybind)
				KeybindSettings.CurrentKeybind = tostring(NewKeybind)
				Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
				if not KeybindSettings.Ext then SaveConfiguration() end
				if KeybindSettings.CallOnChange then KeybindSettings.Callback(tostring(NewKeybind)) end
			end
			if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
				RayfieldLibrary.Flags[KeybindSettings.Flag] = KeybindSettings
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Keybind.KeybindFrame.UIStroke.Color = SelectedTheme.InputStroke
			end)
			return KeybindSettings
		end

		function Tab:CreateToggle(ToggleSettings: { Name: string, CurrentValue: boolean, Flag: string?, Callback: (boolean) -> (), Ext: boolean? })
			local ToggleValue = {}
			local Toggle = Elements.Template.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage
			Toggle.BackgroundTransparency = 1
			Toggle.UIStroke.Transparency = 1
			Toggle.Title.TextTransparency = 1
			Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground
			if SelectedTheme ~= RayfieldLibrary.Theme.Default then Toggle.Switch.Shadow.Visible = false end
			TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Toggle.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			if ToggleSettings.CurrentValue == true then
				Toggle.Switch.Indicator.Position = UDim2.new(1, -20, 0.5, 0)
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleEnabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleEnabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleEnabledOuterStroke
			else
				Toggle.Switch.Indicator.Position = UDim2.new(1, -40, 0.5, 0)
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
			end
			Toggle.MouseEnter:Connect(function() TweenService:Create(Toggle, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end)
			Toggle.MouseLeave:Connect(function() TweenService:Create(Toggle, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			Toggle.Interact.MouseButton1Click:Connect(function()
				if ToggleSettings.CurrentValue == true then
					ToggleSettings.CurrentValue = false
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -40, 0.5, 0) }):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleDisabledStroke }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { BackgroundColor3 = SelectedTheme.ToggleDisabled }):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleDisabledOuterStroke }):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				else
					ToggleSettings.CurrentValue = true
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -20, 0.5, 0) }):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleEnabledStroke }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { BackgroundColor3 = SelectedTheme.ToggleEnabled }):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleEnabledOuterStroke }):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				end
				pcall(function() ToggleSettings.Callback(ToggleSettings.CurrentValue) end)
				if not ToggleSettings.Ext then SaveConfiguration() end
			end)
			function ToggleSettings:Set(NewToggleValue: boolean)
				if NewToggleValue == true then
					ToggleSettings.CurrentValue = true
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -20, 0.5, 0) }):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleEnabledStroke }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { BackgroundColor3 = SelectedTheme.ToggleEnabled }):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleEnabledOuterStroke }):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				else
					ToggleSettings.CurrentValue = false
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -40, 0.5, 0) }):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleDisabledStroke }):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { BackgroundColor3 = SelectedTheme.ToggleDisabled }):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Color = SelectedTheme.ToggleDisabledOuterStroke }):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
				end
				pcall(function() ToggleSettings.Callback(ToggleSettings.CurrentValue) end)
				if not ToggleSettings.Ext then SaveConfiguration() end
			end
			if not ToggleSettings.Ext and Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
				RayfieldLibrary.Flags[ToggleSettings.Flag] = ToggleSettings
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground
				if SelectedTheme ~= RayfieldLibrary.Theme.Default then Toggle.Switch.Shadow.Visible = false end
				task.wait()
				if not ToggleSettings.CurrentValue then
					Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
					Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
					Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
				else
					Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleEnabledStroke
					Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleEnabled
					Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleEnabledOuterStroke
				end
			end)
			return ToggleSettings
		end

		function Tab:CreateSlider(SliderSettings: { Name: string, Range: { number }, Increment: number, Suffix: string?, CurrentValue: number, Flag: string?, Callback: (number) -> (), Ext: boolean? })
			local SlDragging = false
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage
			Slider.BackgroundTransparency = 1
			Slider.UIStroke.Transparency = 1
			Slider.Title.TextTransparency = 1
			if SelectedTheme ~= RayfieldLibrary.Theme.Default then Slider.Main.Shadow.Visible = false end
			Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
			Slider.Main.UIStroke.Color = SelectedTheme.SliderStroke
			Slider.Main.Progress.UIStroke.Color = SelectedTheme.SliderStroke
			Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
			TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0 }):Play()
			TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
			Slider.Main.Progress.Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)
			Slider.Main.Information.Text = if not SliderSettings.Suffix then tostring(SliderSettings.CurrentValue) else tostring(SliderSettings.CurrentValue) .. " " .. SliderSettings.Suffix
			Slider.MouseEnter:Connect(function() TweenService:Create(Slider, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play() end)
			Slider.MouseLeave:Connect(function() TweenService:Create(Slider, TweenInfoHover, { BackgroundColor3 = SelectedTheme.ElementBackground }):Play() end)
			Slider.Main.Interact.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					TweenService:Create(Slider.Main.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					TweenService:Create(Slider.Main.Progress.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
					SlDragging = true
				end
			end)
			Slider.Main.Interact.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					TweenService:Create(Slider.Main.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0.4 }):Play()
					TweenService:Create(Slider.Main.Progress.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { Transparency = 0.3 }):Play()
					SlDragging = false
				end
			end)
			Slider.Main.Interact.MouseButton1Down:Connect(function(X)
				local Current = Slider.Main.Progress.AbsolutePosition.X + Slider.Main.Progress.AbsoluteSize.X
				local Start = Current
				local Location = X
				local Loop = nil
				Loop = RunService.Stepped:Connect(function()
					if SlDragging then
						Location = UserInputService:GetMouseLocation().X
						Current = Current + 0.025 * (Location - Start)
						if Location < Slider.Main.AbsolutePosition.X then Location = Slider.Main.AbsolutePosition.X
						elseif Location > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then Location = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X end
						if Current < Slider.Main.AbsolutePosition.X + 5 then Current = Slider.Main.AbsolutePosition.X + 5
						elseif Current > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then Current = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X end
						if Current <= Location and (Location - Start) < 0 then Start = Location
						elseif Current >= Location and (Location - Start) > 0 then Start = Location end
						TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, Current - Slider.Main.AbsolutePosition.X, 1, 0) }):Play()
						local NewValue = SliderSettings.Range[1] + (Location - Slider.Main.AbsolutePosition.X) / Slider.Main.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])
						NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000
						NewValue = math.clamp(NewValue, SliderSettings.Range[1], SliderSettings.Range[2])
						Slider.Main.Information.Text = if not SliderSettings.Suffix then tostring(NewValue) else tostring(NewValue) .. " " .. SliderSettings.Suffix
						if SliderSettings.CurrentValue ~= NewValue then
							pcall(function() SliderSettings.Callback(NewValue) end)
							SliderSettings.CurrentValue = NewValue
							if not SliderSettings.Ext then SaveConfiguration() end
						end
					else
						TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X > 5 and Location - Slider.Main.AbsolutePosition.X or 5, 1, 0) }):Play()
						Loop:Disconnect()
					end
				end)
			end)
			function SliderSettings:Set(NewVal: number)
				local NewValClamped = math.clamp(NewVal, SliderSettings.Range[1], SliderSettings.Range[2])
				TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((NewValClamped - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * ((NewValClamped - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0) }):Play()
				Slider.Main.Information.Text = tostring(NewValClamped) .. " " .. (SliderSettings.Suffix or "")
				pcall(function() SliderSettings.Callback(NewValClamped) end)
				SliderSettings.CurrentValue = NewValClamped
				if not SliderSettings.Ext then SaveConfiguration() end
			end
			if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
				RayfieldLibrary.Flags[SliderSettings.Flag] = SliderSettings
			end
			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				if SelectedTheme ~= RayfieldLibrary.Theme.Default then Slider.Main.Shadow.Visible = false end
				Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
				Slider.Main.UIStroke.Color = SelectedTheme.SliderStroke
				Slider.Main.Progress.UIStroke.Color = SelectedTheme.SliderStroke
				Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			end)
			return SliderSettings
		end

		Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
			TabButton.UIStroke.Color = SelectedTheme.TabStroke
			if Elements.UIPageLayout.CurrentPage == TabPage then
				TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
				TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
				TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
			else
				TabButton.BackgroundColor3 = SelectedTheme.TabBackground
				TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
				TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
			end
		end)
		return Tab
	end

	Elements.Visible = true
	task.wait(1.1)
	TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 390, 0, 90) }):Play()
	task.wait(0.3)
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
	task.wait(0.1)
	TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UseMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475) }):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { ImageTransparency = 0.6 }):Play()
	Topbar.BackgroundTransparency = 1
	Topbar.Divider.Size = UDim2.new(0, 0, 0, 1)
	Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	Topbar.CornerRepair.BackgroundTransparency = 1
	Topbar.Title.TextTransparency = 1
	Topbar.Search.ImageTransparency = 1
	if Topbar:FindFirstChild('Settings') then Topbar.Settings.ImageTransparency = 1 end
	Topbar.ChangeSize.ImageTransparency = 1
	Topbar.Hide.ImageTransparency = 1
	task.wait(0.5)
	Topbar.Visible = true
	TweenService:Create(Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0 }):Play()
	task.wait(0.1)
	TweenService:Create(Topbar.Divider, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, 0, 0, 1) }):Play()
	TweenService:Create(Topbar.Title, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
	task.wait(0.05)
	TweenService:Create(Topbar.Search, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { ImageTransparency = 0.8 }):Play()
	task.wait(0.05)
	if Topbar:FindFirstChild('Settings') then
		TweenService:Create(Topbar.Settings, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { ImageTransparency = 0.8 }):Play()
		task.wait(0.05)
	end
	TweenService:Create(Topbar.ChangeSize, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { ImageTransparency = 0.8 }):Play()
	task.wait(0.05)
	TweenService:Create(Topbar.Hide, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { ImageTransparency = 0.8 }):Play()
	task.wait(0.3)
	if DragBar then TweenService:Create(DragBarCosmetic, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play() end

	function Window.ModifyTheme(NewTheme: any)
		local Success = pcall(ChangeTheme, NewTheme)
		if not Success then
			RayfieldLibrary:Notify({ Title = 'Unable to Change Theme', Content = 'We are unable find a theme on file.', Image = 4400704299 })
		else
			RayfieldLibrary:Notify({ Title = 'Theme Changed', Content = 'Successfully changed theme.', Image = 4483362748 })
		end
	end

	local Success = pcall(function() CreateSettings(Window) end)
	if not Success then warn('Rayfield had an issue creating settings.') end
	return Window
end

local function SetVisibility(visibility: boolean, notify: boolean?)
	if Debounce then return end
	if visibility then Hidden = false Unhide() else Hidden = true Hide(notify) end
end

function RayfieldLibrary:SetVisibility(visibility: boolean) SetVisibility(visibility, false) end
function RayfieldLibrary:IsVisible(): boolean return not Hidden end

local HideHotkeyConnection = nil

function RayfieldLibrary:Destroy()
	RayfieldDestroyed = true
	if HideHotkeyConnection then HideHotkeyConnection:Disconnect() end
	for _, Connection in KeybindConnections do Connection:Disconnect() end
	Rayfield:Destroy()
end

Topbar.ChangeSize.MouseButton1Click:Connect(function()
	if Debounce then return end
	if Minimised then Minimised = false Maximise() else Minimised = true Minimise() end
end)

Main.Search.Input:GetPropertyChangedSignal('Text'):Connect(function()
	if #Main.Search.Input.Text > 0 then
		if not Elements.UIPageLayout.CurrentPage:FindFirstChild('SearchTitle-fsefsefesfsefesfesfThanks') then
			local SearchTitle = Elements.Template.SectionTitle:Clone()
			SearchTitle.Parent = Elements.UIPageLayout.CurrentPage
			SearchTitle.Name = 'SearchTitle-fsefsefesfsefesfesfThanks'
			SearchTitle.LayoutOrder = -100
			SearchTitle.Title.Text = "Results from '" .. Elements.UIPageLayout.CurrentPage.Name .. "'"
			SearchTitle.Visible = true
		end
	else
		local SearchTitle = Elements.UIPageLayout.CurrentPage:FindFirstChild('SearchTitle-fsefsefesfsefesfesfThanks')
		if SearchTitle then SearchTitle:Destroy() end
	end
	for _, Element in ipairs(Elements.UIPageLayout.CurrentPage:GetChildren()) do
		if Element.ClassName ~= 'UIListLayout' and Element.Name ~= 'Placeholder' and Element.Name ~= 'SearchTitle-fsefsefesfsefesfesfThanks' then
			if Element.Name == 'SectionTitle' then
				Element.Visible = #Main.Search.Input.Text == 0
			else
				Element.Visible = string.lower(Element.Name):find(string.lower(Main.Search.Input.Text), 1, true) ~= nil
			end
		end
	end
end)

Main.Search.Input.FocusLost:Connect(function()
	if #Main.Search.Input.Text == 0 and SearchOpen then task.wait(0.12) CloseSearch() end
end)

Topbar.Search.MouseButton1Click:Connect(function()
	task.spawn(function() if SearchOpen then CloseSearch() else OpenSearch() end end)
end)

if Topbar:FindFirstChild('Settings') then
	Topbar.Settings.MouseButton1Click:Connect(function()
		task.spawn(function()
			for _, OtherTabButton in ipairs(TabList:GetChildren()) do
				if OtherTabButton.Name ~= "Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton.Name ~= "Placeholder" then
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundColor3 = SelectedTheme.TabBackground }):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextColor3 = SelectedTheme.TabTextColor }):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageColor3 = SelectedTheme.TabTextColor }):Play()
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { BackgroundTransparency = 0.7 }):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { TextTransparency = 0.2 }):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.2 }):Play()
					TweenService:Create(OtherTabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Transparency = 0.5 }):Play()
				end
			end
			Elements.UIPageLayout:JumpTo(Elements['Rayfield Settings'])
		end)
	end)
end

Topbar.Hide.MouseButton1Click:Connect(function() SetVisibility(Hidden, not UseMobileSizing) end)

HideHotkeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
	if (input.KeyCode == Enum.KeyCode[GetSetting("General", "RayfieldOpen")]) and not processed then
		if Debounce then return end
		if Hidden then Hidden = false Unhide() else Hidden = true Hide() end
	end
end)

if MPrompt then
	MPrompt.Interact.MouseButton1Click:Connect(function()
		if Debounce then return end
		if Hidden then Hidden = false Unhide() end
	end)
end

for _, TopbarButton in ipairs(Topbar:GetChildren()) do
	if TopbarButton.ClassName == "ImageButton" and TopbarButton.Name ~= 'Icon' then
		TopbarButton.MouseEnter:Connect(function() TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play() end)
		TopbarButton.MouseLeave:Connect(function() TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { ImageTransparency = 0.8 }):Play() end)
	end
end

function RayfieldLibrary:LoadConfiguration()
	local Config = nil
	if UseStudio then Config = '{"Toggle1adwawd":true,"ColorPicker1awd":{"B":255,"G":255,"R":255},"Slider1dawd":100,"ColorPicfsefker1":{"B":255,"G":255,"R":255},"Slidefefsr1":80,"dawdawd":"","Input1":"hh","Keybind1":"B","Dropdown1":["Ocean"]}' end
	if CEnabled then
		local Notified = false
		local Loaded = false
		local Success, Result = pcall(function()
			if UseStudio and Config then Loaded = LoadConfiguration(Config) return end
			if isfile then
				if CallSafely(isfile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
					Loaded = LoadConfiguration(CallSafely(readfile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension))
				end
			else
				Notified = true
				RayfieldLibrary:Notify({ Title = "Rayfield Configurations", Content = "Filesystem not supported.", Image = 4384402990 })
			end
		end)
		if Success and Loaded and not Notified then
			RayfieldLibrary:Notify({ Title = "Rayfield Configurations", Content = "Configuration loaded.", Image = 4384403532 })
		elseif not Success and not Notified then
			RayfieldLibrary:Notify({ Title = "Rayfield Configurations", Content = "Error loading configuration.", Image = 4384402990 })
		end
	end
	GlobalLoaded = true
end

if CEnabled and Main:FindFirstChild('Notice') then
	Main.Notice.BackgroundTransparency = 1
	Main.Notice.Title.TextTransparency = 1
	Main.Notice.Size = UDim2.new(0, 0, 0, 0)
	Main.Notice.Position = UDim2.new(0.5, 0, 0, -100)
	Main.Notice.Visible = true
	TweenService:Create(Main.Notice, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 280, 0, 35), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 0.5 }):Play()
	TweenService:Create(Main.Notice.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { TextTransparency = 0.1 }):Play()
end

task.delay(4, function()
	RayfieldLibrary.LoadConfiguration()
	if Main:FindFirstChild('Notice') and Main.Notice.Visible then
		TweenService:Create(Main.Notice, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 100, 0, 25), Position = UDim2.new(0.5, 0, 0, -100), BackgroundTransparency = 1 }):Play()
		TweenService:Create(Main.Notice.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		task.wait(0.5)
		Main.Notice.Visible = false
	end
end)

return RayfieldLibrary