if not game:IsLoaded() then
	game.Loaded:Wait()
end

local GuiService = game:GetService('GuiService')
local RunService = game:GetService('RunService')
local httpService = game:GetService('HttpService')
local textService = game:GetService('TextService')
local tweenService = game:GetService('TweenService')
local userInputService = game:GetService('UserInputService')

local screenGui = Instance.new('ScreenGui')
screenGui.Parent = game:GetService('CoreGui')
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local uiScale = Instance.new('UIScale')
uiScale.Parent = screenGui
uiScale.Scale = math.max(screenGui.AbsoluteSize.X / 1920, 0.8)

local clickGui = Instance.new('Frame')
clickGui.Parent = screenGui
clickGui.Size = UDim2.fromScale(1, 1)
clickGui.BackgroundTransparency = 1
clickGui.Visible = false

local arrayList = Instance.new('Frame')
arrayList.Parent = screenGui
arrayList.Position = UDim2.new(1, -400, 0, 10)
arrayList.Size = UDim2.new(0, 390, 1, -20)
arrayList.BackgroundTransparency = 1
arrayList.Name = 'Arraylist'

local arrayListSort = Instance.new('UIListLayout')
arrayListSort.Parent = arrayList
arrayListSort.SortOrder = Enum.SortOrder.LayoutOrder
arrayListSort.HorizontalAlignment = Enum.HorizontalAlignment.Right

local games = loadfile('Strafe/Games.lua')()

local function getGame(idF: number)
	for i, v in games do
		for _, id in v do
			if id == idF then
				return i
			end
		end
	end
	
	return idF
end

if not isfolder('Strafe') then
	makefolder('Strafe')
	makefolder('Strafe/Games')
	makefolder('Strafe/Configs')
	makefolder('Strafe/Libraries')
end

local Config = {}
local savingEnabled = true
local guiLibrary = {
	screen = screenGui,
	garbageCollection = {},
	
	saveCfg = function()
		local GameId = getGame(game.PlaceId)
		
		if savingEnabled then
			writefile('Strafe/Configs/'..GameId..'.json', httpService:JSONEncode(Config))
		end
	end,
	loadCfg = function()
		local GameId = getGame(game.PlaceId)
		
		if isfile('Strafe/Configs/'..GameId..'.json') then
			Config = httpService:JSONDecode(readfile('Strafe/Configs/'..GameId..'.json'))
		end
	end,

	Arraylist = {
		Transparency = 1,
		Outline = false,
		Shadow = false,
	},

	ColorMode = 'Static',

	GuiChange = Instance.new('BindableEvent'),
	GuiColor = 0,
	placeName = getGame(game.PlaceId),
}

local function shadowifyAids(label: TextLabel)
	local Clone = label:Clone()
	Clone.Parent = label
	Clone.Position = UDim2.fromOffset(1, 1)
	Clone.TextColor3 = Color3.fromRGB(0, 0, 0)
	Clone.ZIndex = label.ZIndex - 1
	Clone.Name = 'Shadow'

	return Clone
end

local arrayItems = {}
local function addToArray(Name: string, ArrayText: () -> string)
	local ObjFrame = Instance.new('Frame')
	ObjFrame.Parent = arrayList
	ObjFrame.BorderSizePixel = 0
	ObjFrame.BackgroundTransparency = guiLibrary.Arraylist.Transparency
	ObjFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ObjFrame.Name = Name
	ObjFrame.ZIndex = 1
	local ObjLabel = Instance.new('TextLabel')
	ObjLabel.Parent = ObjFrame
	ObjLabel.Size = UDim2.fromScale(1, 1)
	ObjLabel.BackgroundTransparency = 1
	ObjLabel.TextColor3 = Color3.fromRGB(0, 100, 255)
	ObjLabel.TextSize = 19
	ObjLabel.Text = ' ' .. Name .. ' '
	ObjLabel.Font = Enum.Font.BuilderSansMedium
	ObjLabel.Name = Name
	ObjLabel.RichText = true
	ObjLabel.ZIndex = 3
	ObjLabel.Name = 'main'
	local ObjSide = Instance.new('Frame')
	ObjSide.Parent = ObjFrame
	ObjSide.Size = UDim2.new(0, 2, 1, 0)
	ObjSide.Position = UDim2.fromScale(1, 0)
	ObjSide.BorderSizePixel = 0
	ObjSide.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
	ObjSide.Name = 'Right'
	ObjSide.ZIndex = 2
	local ObjTop = Instance.new('Frame')
	ObjTop.Parent = ObjFrame
	ObjTop.Size = UDim2.new(1, 2, 0, 2)
	ObjTop.Position = UDim2.fromOffset(0, -2)
	ObjTop.BorderSizePixel = 0
	ObjTop.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
	ObjTop.Name = 'Top'
	ObjTop.ZIndex = 2
	local Shadow = shadowifyAids(ObjLabel)
	Shadow.Visible = guiLibrary.Arraylist.Shadow

	if ArrayText then
		ObjLabel.Text = ' ' .. Name .. ' <font color="rgb(200,200,200)">- ' .. ArrayText() .. ' </font>'
		Shadow.Text = ' ' .. Name .. ' - ' .. ArrayText() .. ' '
	end

	ObjFrame.Size = UDim2.fromOffset(textService:GetTextSize(ObjLabel.ContentText, ObjLabel.TextSize, ObjLabel.Font, Vector2.zero).X, 28)

	table.insert(arrayItems, ObjFrame)
	table.sort(arrayItems, function(a, b)
		return a.Size.X.Offset > b.Size.X.Offset
	end)

	for i, v in arrayItems do
		v.LayoutOrder = i
	end

	guiLibrary.GuiChange.Event:Connect(function(val)
		if guiLibrary.ColorMode == 'Static' or guiLibrary.ColorMode == 'Rainbow' then
			ObjLabel.TextColor3 = val
			ObjSide.BackgroundColor3 = val
			ObjTop.BackgroundColor3 = val
		end
	end)
end
local function removeFromArray(Name: string)
	for i, v in arrayItems do
		if v.Name == Name then
			v:Destroy()
			table.remove(arrayItems, i)
		end
	end
end

local funny = 0
RunService:BindToRenderStep('Arraylist', 9999, function(dt)
	funny += (dt / 5)

	if funny > 1 then
		funny = 0
	end

	for i, v in arrayItems do
		v.BackgroundTransparency = guiLibrary.Arraylist.Transparency
		v.main.Shadow.Visible = guiLibrary.Arraylist.Shadow
		v.Right.Visible = guiLibrary.Arraylist.Outline

		if guiLibrary.ColorMode == 'Rainbow 2' then
			v.main.TextColor3 = Color3.fromHSV((funny + (i / 10)) % 1, 0.65, 1)
			v.Right.BackgroundColor3 = v.main.TextColor3
			v.Top.BackgroundColor3 = v.main.TextColor3
		end

		if i == 1 and guiLibrary.Arraylist.Outline then
			v.Top.Visible = true
		else
			v.Top.Visible = false
		end
	end
end)

guiLibrary.loadCfg()

table.insert(guiLibrary.garbageCollection, userInputService.InputBegan:Connect(function(input: InputObject)
	if not userInputService:GetFocusedTextBox() and input.KeyCode == Enum.KeyCode.RightShift then
		clickGui.Visible = not clickGui.Visible
	end
end))

local windowCount = 0
local Windows = {}
function guiLibrary:getWindow(Name: string)
	for i, v in Windows do
		if v.Name == Name then
			return v
		end
	end
end
function guiLibrary:registerWindow(Name: string)
	local windowFrame = Instance.new('Frame')
	windowFrame.Parent = clickGui
	windowFrame.Size = UDim2.fromOffset(200, 32)
	windowFrame.Position = UDim2.fromOffset(100 + (windowCount * 205), 100)
	windowFrame.BorderSizePixel = 0
	windowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	
	local windowLabel = Instance.new('TextButton')
	windowLabel.Parent = windowFrame
	windowLabel.Size = UDim2.fromScale(1, 1)
	windowLabel.BackgroundTransparency = 1
	windowLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
	windowLabel.TextSize = 20
	windowLabel.Text = Name:lower()
	windowLabel.Font = Enum.Font.BuilderSansMedium
	
	local windowSide = Instance.new('TextButton')
	windowSide.Parent = windowFrame
	windowSide.Size = UDim2.fromOffset(32, 32)
	windowSide.Position = UDim2.fromOffset(200 - 32, 0)
	windowSide.BackgroundTransparency = 1
	windowSide.TextColor3 = Color3.fromRGB(255, 255, 255)
	windowSide.TextSize = 25
	windowSide.Text = '-'
	windowSide.Font = Enum.Font.BuilderSansMedium
	
	local windowModules = Instance.new('Frame')
	windowModules.Parent = windowFrame
	windowModules.Size = UDim2.fromScale(1, 0)
	windowModules.AutomaticSize = Enum.AutomaticSize.Y
	windowModules.Position = UDim2.fromScale(0, 1)
	windowModules.BackgroundTransparency = 1
	windowModules.Name = 'Modules'
	windowModules.Visible = true
	
	local windowModulesSort = Instance.new('UIListLayout')
	windowModulesSort.Parent = windowModules
	windowModulesSort.SortOrder = Enum.SortOrder.LayoutOrder

	windowLabel.MouseButton2Down:Connect(function()
		windowModules.Visible = not windowModules.Visible
		windowSide.Text = (windowModules.Visible and '-' or '+')
	end)
	
	windowSide.MouseButton1Down:Connect(function()
		windowModules.Visible = not windowModules.Visible
		windowSide.Text = (windowModules.Visible and '-' or '+')
	end)
	
	windowCount += 1
	
	table.insert(Windows, {
		Name = Name,
		Modules = {},
		Instance = windowFrame,
	})
	
	return Windows[Name]
end

local funny2 = 0
RunService:BindToRenderStep('Tab Stuff', 99999, function(dt)
	funny2 -= (dt / 5)

	if funny2 < 0 then
		funny2 = 1
	end

	for _, tab in Windows do
		for i, mod in tab.Modules do
			mod.Instance:SetAttribute('Color', Color3.fromHSV((funny2 + (i / 20)) % 1, 0.65, 1))

			if mod.Enabled then
				if guiLibrary.ColorMode ~= 'Rainbow 2' then
					continue
				end

				mod.Instance.MToggled.BackgroundColor3 = mod.Instance:GetAttribute('Color')
			end
		end
	end
end)

function guiLibrary:registerModule(Data: {Name: string, Window: string, ArrayText: () -> string, Callback: () -> nil})
	if not Data or not Data.Name or not Data.Window then
		return
	end
	
	if not Config[Data.Name] then
		Config[Data.Name] = {
			Enabled = false,
			Keybind = 'Unknown',
			
			Toggles = {},
			Sliders = {},
			Selectors = {},
			Textboxes = {},
		}
	end
	
	local moduleFrame = Instance.new('Frame')
	moduleFrame.Parent = guiLibrary:getWindow(Data.Window).Instance:WaitForChild('Modules')
	moduleFrame.Size = UDim2.new(1, 0, 0, 32)
	moduleFrame.BorderSizePixel = 0
	moduleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	moduleFrame.ZIndex = 1
	
	local moduleBackground = Instance.new('Frame')
	moduleBackground.Parent = moduleFrame
	moduleBackground.Size = UDim2.new(1, -2, 1, -1)
	moduleBackground.Position = UDim2.fromOffset(1, 0)
	moduleBackground.BorderSizePixel = 0
	moduleBackground.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
	moduleBackground.Visible = false
	moduleBackground.Name = 'MToggled'
	moduleBackground.ZIndex = 2
	
	local moduleLabel = Instance.new('TextButton')
	moduleLabel.Parent = moduleFrame
	moduleLabel.Size = UDim2.fromScale(1, 1)
	moduleLabel.Position = UDim2.fromOffset(5, 0)
	moduleLabel.BackgroundTransparency = 1
	moduleLabel.TextXAlignment = Enum.TextXAlignment.Left
	moduleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	moduleLabel.TextSize = 16
	moduleLabel.Text = Data.Name:lower()
	moduleLabel.Font = Enum.Font.BuilderSansMedium
	moduleLabel.ZIndex = 4

	local moduleShadow = shadowifyAids(moduleLabel)
	
	local moduleDropdown = Instance.new('Frame')
	moduleDropdown.Parent = guiLibrary:getWindow(Data.Window).Instance:WaitForChild('Modules')
	moduleDropdown.Size = UDim2.fromScale(1, 0)
	moduleDropdown.AutomaticSize = Enum.AutomaticSize.Y
	moduleDropdown.BackgroundTransparency = 1
	moduleDropdown.Visible = false
	
	local moduleDropdownSort = Instance.new('UIListLayout')
	moduleDropdownSort.Parent = moduleDropdown
	moduleDropdownSort.SortOrder = Enum.SortOrder.LayoutOrder

    local keybindFrame = Instance.new('Frame')
    keybindFrame.Parent = moduleDropdown
    keybindFrame.Size = UDim2.new(1, 0, 0, 32)
    keybindFrame.BorderSizePixel = 0
    keybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local keybindLabel = Instance.new('TextButton')
    keybindLabel.Parent = keybindFrame
    keybindLabel.Position = UDim2.fromOffset(10, 0)
    keybindLabel.Size = UDim2.fromScale(1, 1)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    keybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindLabel.TextSize = 16
    keybindLabel.Text = 'Keybind: ' .. Config[Data.Name].Keybind
    keybindLabel.Font = Enum.Font.BuilderSansMedium

	guiLibrary.GuiChange.Event:Connect(function(val)
		if guiLibrary.ColorMode == 'Static' or guiLibrary.ColorMode == 'Rainbow' then
			moduleBackground.BackgroundColor3 = val
		end
	end)

	keybindLabel.MouseButton1Down:Connect(function()
		local aids; aids = userInputService.InputBegan:Connect(function(input: InputObject)
			if not userInputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown then
				if input.KeyCode.Name == Config[Data.Name].Keybind then
					Config[Data.Name].Keybind = 'Unknown'
					keybindLabel.Text = 'Keybind: ' .. Config[Data.Name].Keybind

					aids:Disconnect()

					guiLibrary.saveCfg()

					return
				end
				
				task.wait()
				Config[Data.Name].Keybind = input.KeyCode.Name
				keybindLabel.Text = 'Keybind: ' .. input.KeyCode.Name
				aids:Disconnect()

				guiLibrary.saveCfg()
			end
		end)
	end)
	
	local moduleData = {
		Name = Data.Name,
		Enabled = false,
		Instance = moduleFrame,
	}
	
	function moduleData:Toggle()
		self.Enabled = not self.Enabled
		moduleBackground.Visible = self.Enabled
		
		Config[Data.Name].Enabled = self.Enabled
		guiLibrary.saveCfg()

		if self.Enabled then
			addToArray(Data.Name, Data.ArrayText or nil)
		else
			removeFromArray(Data.Name)
		end
		
		if Data.Callback then
			task.spawn(Data.Callback, self.Enabled)
		end
	end
	
	function moduleData:registerToggle(data: {Name: string, Callback: () -> nil})
		if not data or not data.Name then
			return
		end
		
		if not Config[Data.Name].Toggles[data.Name] then
			Config[Data.Name].Toggles[data.Name] = {
				Enabled = false
			}
		end
		
		local toggleFrame = Instance.new('Frame')
		toggleFrame.Parent = moduleDropdown
		toggleFrame.Size = UDim2.new(1, 0, 0, 32)
		toggleFrame.BorderSizePixel = 0
		toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		
		local toggleLabel = Instance.new('TextButton')
		toggleLabel.Parent = toggleFrame
		toggleLabel.Size = UDim2.fromScale(1, 1)
		toggleLabel.BackgroundTransparency = 1
		toggleLabel.Position = UDim2.fromOffset(10, 0)
		toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
		toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggleLabel.TextSize = 15
		toggleLabel.Text = data.Name:lower()
		toggleLabel.Font = Enum.Font.BuilderSansMedium
		
		local toggleBackground = Instance.new('Frame')
		toggleBackground.Parent = toggleFrame
		toggleBackground.Position = UDim2.new(0.9, 0, 0.5, 0)
		toggleBackground.AnchorPoint = Vector2.new(0.5, 0.5)
		toggleBackground.Size = UDim2.fromOffset(18, 18)
		toggleBackground.BorderSizePixel = 0
		toggleBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		
		local toggledBackground = Instance.new('Frame')
		toggledBackground.Parent = toggleBackground
		toggledBackground.Size = UDim2.fromScale(1, 1)
		toggledBackground.BorderSizePixel = 0
		toggledBackground.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
		toggledBackground.Visible = false
		toggledBackground.Name = 'SetColor'
		
		local toggleData = {Enabled = false}
		function toggleData:Toggle()
			self.Enabled = not self.Enabled
			toggledBackground.Visible = self.Enabled
			
			Config[Data.Name].Toggles[data.Name].Enabled = self.Enabled
			guiLibrary.saveCfg()
			
			if data.Callback then
				task.spawn(data.Callback, self.Enabled)
			end
		end
		
		toggleLabel.MouseButton1Down:Connect(function()
			toggleData:Toggle()
		end)
		
		if Config[Data.Name].Toggles[data.Name].Enabled then
			toggleData:Toggle()
		end

		moduleFrame:GetAttributeChangedSignal('Color'):Connect(function()
			toggledBackground.BackgroundColor3 = moduleFrame:GetAttribute('Color')
		end)
		
		return toggleData
	end
	
	function moduleData:registerSelector(data: {Name: string, Values: {}, Default: string, Callback: () -> nil})
		if not data or not data.Name or not data.Values or #data.Values < 1 then
			return
		end
		
		if not Config[Data.Name].Selectors[data.Name] then
			Config[Data.Name].Selectors[data.Name] = {
				Value = data.Default or data.Values[1]
			}
		end
		
		local selectorFrame = Instance.new('Frame')
		selectorFrame.Parent = moduleDropdown
		selectorFrame.Size = UDim2.new(1, 0, 0, 32)
		selectorFrame.BorderSizePixel = 0
		selectorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

		local selectorLabel = Instance.new('TextButton')
		selectorLabel.Parent = selectorFrame
		selectorLabel.Size = UDim2.fromScale(1, 1)
		selectorLabel.BackgroundTransparency = 1
		selectorLabel.Position = UDim2.fromOffset(10, 0)
		selectorLabel.TextXAlignment = Enum.TextXAlignment.Left
		selectorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		selectorLabel.TextSize = 15
		selectorLabel.Text = data.Name .. ': ' .. Config[Data.Name].Selectors[data.Name].Value
		selectorLabel.Text = selectorLabel.Text:lower()
		selectorLabel.Font = Enum.Font.BuilderSansMedium
		
		local selectorData = {Value = Config[Data.Name].Selectors[data.Name].Value}
		local Index = 1
		
		function selectorData:Set(Value: string)
			selectorLabel.Text = data.Name .. ': ' .. Value
			selectorLabel.Text = selectorLabel.Text:lower()
			
			self.Value = Value

            Config[Data.Name].Selectors[data.Name].Value = self.Value
            guiLibrary.saveCfg()
			
			if data.Callback then
				task.spawn(data.Callback, self.Value)
			end
		end
		
		selectorLabel.MouseButton1Down:Connect(function()
			Index += 1

			if Index > #data.Values then
				Index = 1
			end

			selectorData:Set(data.Values[Index])
		end)
		
		selectorLabel.MouseButton2Down:Connect(function()
			Index -= 1

			if Index < 1 then
				Index = #data.Values
			end

			selectorData:Set(data.Values[Index])
		end)
		
		selectorData:Set(Config[Data.Name].Selectors[data.Name].Value)
		
		return selectorData
	end
	
	function moduleData:registerSlider(data: {Name: string, Step: number, Minimum: number, Maximum: number, Default: number, Callback: () -> nil})
		if not data or not data.Name or not data.Minimum or not data.Maximum then
			return
		end
		
		if not data.Step then
			data.Step = 1
		end
		
		local funnyVal = tostring(Data.Step)
		local factor = 0

		if funnyVal:find(".") then
			factor = 10 ^ (#funnyVal - funnyVal:find("."))
		end
		
		if not Config[Data.Name].Sliders[data.Name] then
			Config[Data.Name].Sliders[data.Name] = {
				Value = data.Default or data.Maximum,
			}
		end
		
		local sliderFrame = Instance.new('Frame')
		sliderFrame.Parent = moduleDropdown
		sliderFrame.Size = UDim2.new(1, 0, 0, 32)
		sliderFrame.BorderSizePixel = 0
		sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		
		local sliderLabel = Instance.new('TextLabel')
		sliderLabel.Parent = sliderFrame
		sliderLabel.Size = UDim2.fromScale(1, 1)
		sliderLabel.Position = UDim2.fromOffset(10, 0)
		sliderLabel.BackgroundTransparency = 1
		sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
		sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		sliderLabel.TextSize = 15
		sliderLabel.Text = data.Name:lower() .. ': ' .. tostring(data.Default or data.Maximum)
		sliderLabel.Font = Enum.Font.BuilderSansMedium
		
		local sliderBackground = Instance.new('Frame')
		sliderBackground.Parent = sliderFrame
		sliderBackground.Position = UDim2.new(0, 2, 1, -6)
		sliderBackground.Size = UDim2.new(1, -4, 0, 4)
		sliderBackground.BorderSizePixel = 0
		sliderBackground.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		
		local sliderFiller = Instance.new('Frame')
		sliderFiller.Parent = sliderBackground
		sliderFiller.Size = UDim2.fromScale(0.5, 1)
		sliderFiller.BorderSizePixel = 0
		sliderFiller.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
		sliderFiller.Name = 'SetColor'

		moduleFrame:GetAttributeChangedSignal('Color'):Connect(function()
			sliderFiller.BackgroundColor3 = moduleFrame:GetAttribute('Color')
		end)
		
		local sliderData = {Value = data.Default or data.Maximum}
		function sliderData:Set(Value: number)
			self.Value = math.round(Value * factor) / factor
			self.Value = math.clamp(self.Value, data.Minimum, data.Maximum)
			
			Config[Data.Name].Sliders[data.Name].Value = self.Value
			guiLibrary.saveCfg()
			
			sliderLabel.Text = data.Name:lower() .. ': ' .. tostring(self.Value)
			tweenService:Create(sliderFiller, TweenInfo.new(0.1), {Size = UDim2.new((self.Value - data.Minimum) / (data.Maximum - data.Minimum), 0, 1, 0)}):Play()
			
			if data.Callback then
				task.spawn(data.Callback, self.Value)
			end
		end
		
		local function move(input)
			local pos = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
			local val = data.Minimum + (data.Maximum - data.Minimum) * pos

			val = math.round(val / data.Step) * data.Step
			sliderData:Set(val)
		end
		
		local dragging = false
		table.insert(guiLibrary.garbageCollection, sliderBackground.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move(input) end
		end))
		table.insert(guiLibrary.garbageCollection, userInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
		end))
		table.insert(guiLibrary.garbageCollection, userInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end))

		sliderData:Set(Config[Data.Name].Sliders[data.Name].Value)
		
		return sliderData
	end
	
	function moduleData:registerTextbox(data: {Name: string, Default: string, Callback: () -> nil})
		if not data or not data.Name or not data.Default then
			return
		end
		
		if not Config[Data.Name].Textboxes[data.Name] then
			Config[Data.Name].Textboxes[data.Name] = {
				Value = data.Default
			}
		end
		
		local textboxFrame = Instance.new('Frame')
		textboxFrame.Parent = moduleDropdown
		textboxFrame.Size = UDim2.new(1, 0, 0, 32)
		textboxFrame.BorderSizePixel = 0
		textboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		
		local textboxLabel = Instance.new('TextLabel')
		textboxLabel.Parent = textboxFrame
		textboxLabel.Size = UDim2.fromScale(1, 1)
		textboxLabel.Position = UDim2.fromOffset(10, 0)
		textboxLabel.BackgroundTransparency = 1
		textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
		textboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textboxLabel.TextSize = 16
		textboxLabel.Text = data.Name:lower()
		textboxLabel.Font = Enum.Font.BuilderSansMedium
		
		local textboxInput = Instance.new('TextBox')
		textboxInput.Parent = textboxFrame
		textboxInput.Size = UDim2.fromOffset(32, 32)
		textboxInput.Position = UDim2.fromScale(0.87, 0.5)
		textboxInput.AnchorPoint = Vector2.new(0.5, 0.5)
		textboxInput.BackgroundTransparency = 1
		textboxInput.TextXAlignment = Enum.TextXAlignment.Right
		textboxInput.TextColor3 = Color3.fromRGB(200, 200, 200)
		textboxInput.TextSize = 16
		textboxInput.Text = Config[Data.Name].Textboxes[data.Name].Value
		textboxInput.Font = Enum.Font.BuilderSansMedium
		textboxInput.ClearTextOnFocus = false
		
		local textboxData = {Value = data.Default}
		function textboxData:Set(Value: string)
			self.Value = Value

			Config[Data.Name].Textboxes[data.Name].Value = self.Value
			guiLibrary.saveCfg()
			
			if data.Callback then
				task.spawn(data.Callback, self.Value)
			end
		end
		
		textboxInput.FocusLost:Connect(function()
			textboxData:Set(textboxInput.Text)
		end)
		
		textboxData:Set(Config[Data.Name].Textboxes[data.Name].Value)
		
		return textboxData
	end
	
	moduleLabel.MouseButton1Down:Connect(function()
		moduleData:Toggle()
	end)
	moduleLabel.MouseButton2Down:Connect(function()
		moduleDropdown.Visible = not moduleDropdown.Visible
	end)
	
	if Config[Data.Name].Enabled then
		task.delay(0.5, function()
            moduleData:Toggle()
        end)
	end

	table.insert(guiLibrary:getWindow(Data.Window).Modules, moduleData)

	userInputService.InputBegan:Connect(function(input: InputObject)
		if not userInputService:GetFocusedTextBox() and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name == Config[Data.Name].Keybind then
			moduleData:Toggle()
		end
	end)
	
	return moduleData
end

shared.GuiLibrary = guiLibrary

return guiLibrary
