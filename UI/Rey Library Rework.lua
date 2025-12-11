repeat wait() until game:IsLoaded()

local ReyUILib = {}

ReyUILib.CallbackManager = {
	Toggles = {},
	Sliders = {},
	Dropdowns = {},
	MultiDropdowns = {},
	Inputs = {}
}

local success, ExternalData = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/Data"))()
end)

if not success or type(ExternalData) ~= "table" then
	ExternalData = {["Execute"] = "0"}
end

ReyUILib.Data = {}
ReyUILib.ExternalData = ExternalData
ReyUILib.UISettings = {}
ReyUILib.UIElements = {}
ReyUILib.alldropdown = {}

local ConfigPath = "ReyHub_Config.json"

function ReyUILib:RegisterCallback(elementType, elementName, callback)
	if not self.CallbackManager[elementType] then
		self.CallbackManager[elementType] = {}
	end
	self.CallbackManager[elementType][elementName] = callback
end

function ReyUILib:ExecuteAllCallbacks()
	for toggleName, callback in pairs(self.CallbackManager.Toggles) do
		local savedState = self.UISettings[toggleName]
		if savedState ~= nil and type(callback) == "function" then
			local state = (savedState == true)
			self.UISettings[toggleName] = state
			
			if self.UIElements[toggleName] and self.UIElements[toggleName].Circle then
				local elementData = self.UIElements[toggleName]
				elementData.State = state
				
				if state then
					elementData.Circle.Position = UDim2.new(1, -22, 0, 2)
					elementData.Circle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
				else
					elementData.Circle.Position = UDim2.new(0, 2, 0, 2)
					elementData.Circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				end
			end
			
			pcall(function() callback(state) end)
		end
	end
	
	for sliderName, callback in pairs(self.CallbackManager.Sliders) do
		local savedValue = self.UISettings[sliderName]
		if savedValue and type(callback) == "function" then
			pcall(function() callback(savedValue) end)
		end
	end
	
	for dropdownName, callback in pairs(self.CallbackManager.Dropdowns) do
		local savedSelection = self.UISettings[dropdownName]
		if savedSelection and type(callback) == "function" then
			pcall(function() callback(savedSelection) end)
		end
	end
	
	for multiName, callback in pairs(self.CallbackManager.MultiDropdowns) do
		local savedSelections = self.UISettings[multiName]
		if savedSelections and type(callback) == "function" then
			pcall(function() callback(savedSelections) end)
		end
	end
	
	for inputName, callback in pairs(self.CallbackManager.Inputs) do
		local savedValue = self.UISettings[inputName]
		if savedValue and type(callback) == "function" then
			pcall(function() callback(savedValue) end)
		end
	end
end

local function Create(className, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties) do
		if property ~= "Parent" then
			instance[property] = value
		end
	end
	if properties.Parent then
		instance.Parent = properties.Parent
	end
	return instance
end

local function SaveConfig()
	if not (writefile and isfile) then 
		return false 
	end
	
	local ConfigData = {}
	
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		if success then
			ConfigData = decoded
		end
	end
	
	ConfigData["Games"] = ConfigData["Games"] or {}
	ConfigData["Games"][tostring(game.GameId)] = ConfigData["Games"][tostring(game.GameId)] or {}
	
	for elementName, elementData in pairs(ReyUILib.UIElements) do
		local currentValue = ReyUILib.UISettings[elementName]
		
		if currentValue == nil then
			if elementData.Type == "Toggle" then
				currentValue = elementData.State or false
			elseif elementData.Type == "Slider" then
				currentValue = elementData.Value or elementData.Min
			elseif elementData.Type == "Dropdown" then
				currentValue = elementData.Selected or ""
			elseif elementData.Type == "MultiDropdown" then
				currentValue = elementData.Selected or {}
			elseif elementData.Type == "Input" then
				currentValue = elementData.Value or ""
			end
			
			ReyUILib.UISettings[elementName] = currentValue
		end
		
		if type(currentValue) ~= "function" then
			ConfigData["Games"][tostring(game.GameId)][elementName] = currentValue
		end
	end
	
	local success, encoded = pcall(function()
		return game:GetService("HttpService"):JSONEncode(ConfigData)
	end)
	
	if success then
		writefile(ConfigPath, encoded)
		return true
	end
	return false
end

local function LoadConfig()
	if not (readfile and isfile) then 
		return {} 
	end
	
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		
		if success and decoded["Games"] and decoded["Games"][tostring(game.GameId)] then
			return decoded["Games"][tostring(game.GameId)]
		end
	end
	return {}
end

function ReyUILib:CreateUI(Name, NoteText)
	local Note = NoteText or false
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	
	if CoreGui:FindFirstChild(Name) then
		CoreGui:FindFirstChild(Name):Destroy()
	elseif CoreGui:FindFirstChild("ReyUI") then
		CoreGui:FindFirstChild("ReyUI"):Destroy()
	end
	
	self.UISettings["Disable Notif"] = self.UISettings["Disable Notif"] or false
	self.UISettings["Disable Animation"] = self.UISettings["Disable Animation"] or false
	self.UISettings["Mute Sound Effect"] = self.UISettings["Mute Sound Effect"] or false
	
	local screenGui = Create("ScreenGui", {
		Name = Name or "ReyUI",
		Parent = CoreGui,
		ResetOnSpawn = false
	})

	local ReyBtn = Create("TextButton", {
		Name = "Rey",
		Parent = screenGui,
		Size = UDim2.new(0, 70, 0, 30),
		Position = UDim2.new(1, -80, 0, 10),
		BackgroundColor3 = Color3.fromRGB(148, 0, 211),
		Text = "Rey",
		TextColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Active = true,
		Draggable = true
	})
	
	Create("UICorner", {
		Parent = ReyBtn,
		CornerRadius = UDim.new(0, 8)
	})

	local panel = Create("Frame", {
		Parent = screenGui,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, -1, 0),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		Active = true,
		ClipsDescendants = true,
		Draggable = true
	})
	
	Create("UICorner", {
		Parent = panel,
		CornerRadius = UDim.new(0, 10)
	})

	local header = Create("TextLabel", {
		Name = Name or "Rey UI",
		Parent = panel,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		Text = Name or "Rey UI",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Center
	})
	
	Create("UICorner", {
		Parent = header,
		CornerRadius = UDim.new(0, 10)
	})

	local leftFrame = Create("Frame", {
		Parent = panel,
		Size = UDim2.new(0, 130, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(35, 35, 50),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		Parent = leftFrame,
		CornerRadius = UDim.new(0, 10)
	})

	local tabContainer = Create("Frame", {
		Parent = leftFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	})

	Create("UIListLayout", {
		Parent = tabContainer,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 5),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local rightFrame = Create("Frame", {
		Parent = panel,
		Size = UDim2.new(1, -130, 1, -30),
		Position = UDim2.new(0, 130, 0, 30),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {
		Parent = rightFrame,
		CornerRadius = UDim.new(0, 10)
	})
	
	local startframe = Create("Frame", {
		Parent = panel,
		Size = UDim2.new(1, -130, 1, -30),
		Position = UDim2.new(0, 130, 0, 30),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30)
	})

	Create("UICorner", {
		Parent = startframe,
		CornerRadius = UDim.new(0, 10)
	})
	
	if Note then	
		local sFrame = Create("ScrollingFrame", {
			Parent = startframe,
			Size = UDim2.new(1, -25, 0, 0),
			Position = UDim2.new(0, 20, 0.3, 0),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 6,
			ClipsDescendants = true,
			ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
			CanvasSize = UDim2.new(0, 0, 0, 0)
		})
		
		Create("UICorner", {
			Parent = sFrame,
			CornerRadius = UDim.new(0, 8)
		})
		
		Create("UIStroke", {
			Parent = sFrame,
			Thickness = 1.5,
			Color = Color3.fromRGB(255, 255, 255)
		})
		
		local container = Create("Frame", {
			Parent = sFrame,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})
		
		local topPadding = Create("Frame", {
			Parent = container,
			Size = UDim2.new(1, 0, 0, 10),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
		
		local note = Create("TextLabel", {
			Parent = container,
			Size = UDim2.new(1, -20, 0, 0),
			BackgroundTransparency = 1,
			Text = Note or "-",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2
		})
		
		local bottomPadding = Create("Frame", {
			Parent = container,
			Size = UDim2.new(1, 0, 0, 10),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		})
		
		local layout = Create("UIListLayout", {
			Parent = container,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			sFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
		end)
	end
	
	local FTextFrame = Create("Frame", {
		Parent = startframe,
		Size = UDim2.new(0.8, -25, 0, 70),
		Position = UDim2.new(0, 95, 0, 20),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = FTextFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local AvatarBorder = Create("Frame", {
		Parent = startframe,
		Size = UDim2.new(0,70,0,70),
		Position = UDim2.new(0,20,0,20),
		BackgroundColor3 = Color3.fromRGB(30,30,30)
	})
	
	Create("UICorner", {
		Parent = AvatarBorder,
		CornerRadius = UDim.new(0, 10)
	})
	
	Create("UIStroke", {
		Parent = AvatarBorder,
		Thickness = 1.5,
		Color = Color3.fromRGB(255, 255, 255)
	})
	
	local FGLabel = Create("TextLabel", {
		Parent = startframe,
		Size = UDim2.new(1, -50, 0, 40),
		Position = UDim2.new(0, 100, 0, 35),
		BackgroundTransparency = 1,
		Text = "Halo, " .. Player.DisplayName .. "!\n\nKamu Telah menggunakan Rey UI\nsebanyak: "..(ExternalData["Execute"] or 0),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 17,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local profileImage = Create("ImageLabel", {
		Parent = startframe,
		Size = UDim2.new(0, 70, 0, 70),
		Position = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = Players:GetUserThumbnailAsync(
			Player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size100x100
		)
	})
	
	Create("UICorner", {
		Parent = profileImage,
		CornerRadius = UDim.new(0, 10)
	})

	Create("UIStroke", {
		Parent = FTextFrame,
		Thickness = 1.5,
		Color = Color3.fromRGB(255, 255, 255)
	})
	
	local SFX = Create("Folder", {
		Name = "Sound Effect",
		Parent = screenGui
	})
	
	Create("Sound", {
		SoundId = "rbxassetid://80843441506433",
		Name = "Mambo",
		Parent = SFX
	})
	
	Create("Sound", {
		SoundId = "rbxassetid://90255863401034",
		Name = "Wow",
		Parent = SFX
	})
	
	self.SFX = SFX
	
	local showTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -250, 0.5, -200),
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 500, 0, 350)
	})

	local hideTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, -1, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0)
	})
	
	local ReyPosition = ReyBtn.Position
	local isOpen = false
	
	ReyBtn.MouseButton1Click:Connect(function()
		if ReyBtn.Position ~= ReyPosition then 
			ReyPosition = ReyBtn.Position 
			return 
		end
		
		if not isOpen then
			panel.Visible = true
			if not self.UISettings["Disable Animation"] then
				showTween:Play()
			else
				panel.Position = UDim2.new(0.5, -250, 0.5, -200)
				panel.BackgroundTransparency = 0
				panel.Size = UDim2.new(0, 500, 0, 350)
			end
			isOpen = true
		else
			if not self.UISettings["Disable Animation"] then
				hideTween:Play()
				hideTween.Completed:Wait()
				panel.Visible = false
			else
				panel.Visible = false
			end
			isOpen = false
		end
	end)
	
	local settingsTabContent = self:CreateTab({
		ScreenGui = screenGui,
		Panel = panel,
		LeftFrame = leftFrame,
		RightFrame = rightFrame,
		StartFrame = startframe,
		TabContainer = tabContainer,
		SFX = SFX
	}, "Settings")
	
	local configManager = self:CreateConfigManager(settingsTabContent)
	self:CreateNote(settingsTabContent, "💾 Save named configs\n📂 Load saved configs\n🗑️ Delete configs\n🔄 Refresh list")
	
	local disableOptions = {"Disable Notif", "Disable Animation", "Mute Sound Effect"}
	self:CreateMultipleDropdown(settingsTabContent, "Disable Features", disableOptions, function(selected)
		self.UISettings["Disable Notif"] = false
		self.UISettings["Disable Animation"] = false
		self.UISettings["Mute Sound Effect"] = false
		
		for _, feature in ipairs(selected) do
			if feature == "Disable Notif" then
				self.UISettings["Disable Notif"] = true
			elseif feature == "Disable Animation" then
				self.UISettings["Disable Animation"] = true
			elseif feature == "Mute Sound Effect" then
				self.UISettings["Mute Sound Effect"] = true
			end
		end
		
		self:ApplyFeatureSettings()
	end)
	
	self:CreateButton(settingsTabContent, "Load Extension", "Advance Feature", "Load", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/Extension/Extensions.lua"))()
	end)
	
	task.spawn(function()
		wait(0.5)
		self:Notify("success", "Rey UI", "Library loaded successfully!", 3)
	end)
	
	self:MonitorUIDeletion(screenGui)
	
	return {
		ScreenGui = screenGui,
		Panel = panel,
		LeftFrame = leftFrame,
		RightFrame = rightFrame,
		StartFrame = startframe,
		TabContainer = tabContainer,
		SFX = SFX,
		SettingsTab = settingsTabContent
	}
end

function ReyUILib:CreateTab(UI, Name)
	local layoutOrder = 1
	
	if Name == "Settings" then
		layoutOrder = 999
	end
	
	local tabButton = Create("TextButton", {
		Name = Name,
		Parent = UI.TabContainer,
		Size = UDim2.new(1, -10, 0, 25),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Text = Name,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder
	})
	
	Create("UICorner", {
		Parent = tabButton,
		CornerRadius = UDim.new(0, 10)
	})

	local tabContent = Create("ScrollingFrame", {
		Parent = UI.RightFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(85, 85, 255),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y
	})

	local layout = Create("UIListLayout", {
		Parent = tabContent,
		Padding = UDim.new(0, 5),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	tabButton.MouseButton1Click:Connect(function()
		for _, tab in ipairs(UI.RightFrame:GetChildren()) do
			if tab:IsA("Frame") or tab:IsA("ScrollingFrame") then
				tab.Visible = false
			end
		end
		UI.StartFrame.Visible = false
		tabContent.Visible = true
	end)

	if #UI.TabContainer:GetChildren() == 1 then
		tabContent.Visible = true
		UI.StartFrame.Visible = false
	end

	return tabContent
end

function ReyUILib:CreateButton(Parent, Name, Description, ButtonText, Callback)
	local buttonFrame = Create("Frame", {
		Name = Name,
		Parent = Parent,
		Size = UDim2.new(1, -10, 0, 50),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30)
	})

	Create("UICorner", {
		Parent = buttonFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local buttonName = Create("TextLabel", {
		Parent = buttonFrame,
		Size = UDim2.new(0.7, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = Name,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local buttonDesc = Create("TextLabel", {
		Parent = buttonFrame,
		Size = UDim2.new(0.7, 0, 0.3, 0),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundTransparency = 1,
		Text = Description,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local actionButton = Create("TextButton", {
		Parent = buttonFrame,
		Size = UDim2.new(0, 65, 0, 25),
		Position = UDim2.new(1, -70, 0, 12),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Text = ButtonText,
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = actionButton,
		CornerRadius = UDim.new(0, 6)
	})

	actionButton.MouseButton1Click:Connect(Callback)

	return buttonFrame
end

function ReyUILib:CreateToggle(Parent, Name, Description, Callback)
	local buttonFrame = Create("Frame", {
		Name = Name,
		Parent = Parent,
		Size = UDim2.new(1, -10, 0, 50),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30)
	})

	Create("UICorner", {
		Parent = buttonFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local buttonName = Create("TextLabel", {
		Parent = buttonFrame,
		Size = UDim2.new(0.7, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = Name,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local buttonDesc = Create("TextLabel", {
		Parent = buttonFrame,
		Size = UDim2.new(0.7, 0, 0.3, 0),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundTransparency = 1,
		Text = Description,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local toggleContainer = Create("Frame", {
		Name = "ToggleContainer",
		Parent = buttonFrame,
		Size = UDim2.new(0, 60, 0, 25),
		Position = UDim2.new(1, -70, 0, 12),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = toggleContainer,
		CornerRadius = UDim.new(0, 12)
	})

	local toggleCircle = Create("Frame", {
		Parent = toggleContainer,
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, 2, 0, 2),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = toggleCircle,
		CornerRadius = UDim.new(0, 10)
	})
	
	self.CallbackManager.Toggles[Name] = Callback
	
	local savedState = self.UISettings[Name]
	local state = (savedState == true)
	
	self.UIElements[Name] = {
		Type = "Toggle",
		Frame = buttonFrame,
		ToggleContainer = toggleContainer,
		Circle = toggleCircle,
		State = state,
		Callback = Callback
	}
	
	if savedState ~= nil then
		if state then
			toggleCircle.Position = UDim2.new(1, -22, 0, 2)
			toggleCircle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		else
			toggleCircle.Position = UDim2.new(0, 2, 0, 2)
			toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		end
	end

	local function toggle()
		local currentState = self.UISettings[Name]
		
		if currentState == nil then
			currentState = false
		end
		
		local newState = not currentState
		self.UISettings[Name] = newState
		self.UIElements[Name].State = newState
		
		if newState then
			toggleCircle:TweenPosition(UDim2.new(1, -22, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
			toggleCircle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		else
			toggleCircle:TweenPosition(UDim2.new(0, 2, 0, 2), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
			toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		end
		
		Callback(newState)
	end

	toggleContainer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			toggle()
		end
	end)

	return buttonFrame
end

function ReyUILib:CreateDropdown(Tab, Name, Options, Callback, Refresh)
	local Callback = Callback or function() end
	local Refresh = Refresh or false
	
	self.alldropdown[Name] = {
		List = nil,
		Container = nil,
		OriginalOptions = Options
	}
	
	local containerFrame = Create("Frame", {
		Name = Name,
		Parent = Tab,
		Size = UDim2.new(1, -10, 0, 40),
		BackgroundTransparency = 1,
		ZIndex = 1
	})

	local dropdownFrame = Create("Frame", {
		Parent = containerFrame,
		Size = UDim2.new(Refresh and 0.85 or 1, Refresh and -5 or 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30),
		ZIndex = 2
	})

	Create("UICorner", {
		Parent = dropdownFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local dropdownButton = Create("TextButton", {
		Parent = dropdownFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Text = Name,
		BorderSizePixel = 0,
		ZIndex = 2
	})

	local dropdownList = Create("ScrollingFrame", {
		Name = Name,
		Parent = containerFrame,
		Size = UDim2.new(1, 0, 0, 150),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
		ZIndex = 5,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	self.alldropdown[Name].List = dropdownList
	self.alldropdown[Name].Container = dropdownFrame
	self.CallbackManager.Dropdowns[Name] = Callback

	Create("UICorner", {
		Parent = dropdownList,
		CornerRadius = UDim.new(0, 8)
	})

	local dropdownLayout = Create("UIListLayout", {
		Parent = dropdownList,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 5),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})

	local function updateCanvasSize()
		dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
	end

	dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

	local function getOptions()
		local optionsToUse = self.alldropdown[Name] and self.alldropdown[Name].OriginalOptions or Options
		
		local optionsType = typeof(optionsToUse)
		
		if optionsType == "function" then
			local success, result = pcall(optionsToUse)
			if success and type(result) == "table" then
				return result
			else
				return {}
			end
		elseif optionsType == "table" then
			return optionsToUse
		else
			return {}
		end
	end
	
	local function loadOptions()
		for _, child in ipairs(dropdownList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local options = getOptions()
		for _, option in ipairs(options) do
			local optionText = tostring(option.Name or option)
			local optionButton = Create("TextButton", {
				Parent = dropdownList,
				Size = UDim2.new(1, -10, 0, 30),
				BackgroundColor3 = Color3.fromRGB(70, 70, 70),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				Text = optionText,
				BorderSizePixel = 0,
				ZIndex = 6
			})
	
			Create("UICorner", {
				Parent = optionButton,
				CornerRadius = UDim.new(0, 6)
			})
			
			optionButton.MouseButton1Click:Connect(function()
				dropdownButton.Text = optionText
				dropdownList.Visible = false
				self.UISettings[Name] = optionText
				Callback(optionText)
			end)
		end
		
		updateCanvasSize()
	end
	
	local savedSelection = self.UISettings[Name]
	if savedSelection then
		dropdownButton.Text = savedSelection
	end
	
	loadOptions()
	
	dropdownButton.MouseButton1Click:Connect(function()
		for dropdownName, dropdownData in pairs(self.alldropdown) do
			if dropdownName ~= Name and dropdownData.List and dropdownData.List.Visible then
				dropdownData.List.Visible = false
			end
		end
		
		dropdownList.Visible = not dropdownList.Visible
	end)

	if Refresh then
		local refreshFrame = Create("Frame", {
			Parent = containerFrame,
			Size = UDim2.new(0.13, 0, 1, 0),
			Position = UDim2.new(0.85, 5, 0, 0),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderSizePixel = 2,
			BorderColor3 = Color3.fromRGB(30, 30, 30),
			ZIndex = 4
		})

		Create("UICorner", {
			Parent = refreshFrame,
			CornerRadius = UDim.new(0, 8)
		})

		local refreshButton = Create("ImageButton", {
			Parent = refreshFrame,
			Size = UDim2.new(1, -8, 1, -8),
			Position = UDim2.new(0, 4, 0, 4),
			BackgroundTransparency = 1,
			Image = "rbxassetid://122032243989747",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 4
		})

		local debounce = false
		refreshButton.MouseButton1Click:Connect(function()
			if debounce then return end
			debounce = true
			loadOptions()
			debounce = false
		end)
	end

	updateCanvasSize()
	
	self.UIElements[Name] = {
		Type = "Dropdown",
		Frame = containerFrame,
		DropdownButton = dropdownButton,
		DropdownList = dropdownList,
		OriginalOptions = Options,
		Selected = savedSelection,
		Callback = Callback
	}
	return containerFrame
end

function ReyUILib:CreateMultipleDropdown(Tab, Name, Options, Callback, Refresh)
	local Callback = Callback or function() end
	local Refresh = Refresh or false
	local selectedOptions = {}
	local selectedOrder = {}
	
	self.alldropdown[Name] = {
		List = nil,
		Container = nil,
		SelectedOptions = selectedOptions,
		SelectedOrder = selectedOrder
	}

	local containerFrame = Create("Frame", {
		Name = Name,
		Parent = Tab,
		Size = UDim2.new(1, -10, 0, 40),
		BackgroundTransparency = 1,
		ZIndex = 1
	})

	local dropdownFrame = Create("Frame", {
		Parent = containerFrame,
		Size = UDim2.new(Refresh and 0.85 or 1, Refresh and -5 or 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30),
		ZIndex = 2
	})

	Create("UICorner", {
		Parent = dropdownFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local dropdownButton = Create("TextButton", {
		Parent = dropdownFrame,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Text = Name,
		BorderSizePixel = 0,
		ZIndex = 3
	})

	local dropdownList = Create("ScrollingFrame", {
		Name = Name,
		Parent = containerFrame,
		Size = UDim2.new(1, 0, 0, 150),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
		ZIndex = 5,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	self.alldropdown[Name].List = dropdownList

	Create("UICorner", {
		Parent = dropdownList,
		CornerRadius = UDim.new(0, 8)
	})

	local dropdownLayout = Create("UIListLayout", {
		Parent = dropdownList,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 5),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})

	local function updateCanvasSize()
		dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
	end

	dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

	local function getOptions()
		local optionsType = typeof(Options)
		
		if optionsType == "function" then
			local success, result = pcall(Options)
			if success then
				if typeof(result) == "function" then
					local success2, result2 = pcall(result)
					if success2 and type(result2) == "table" then
						return result2
					else
						return {}
					end
				elseif type(result) == "table" then
					return result
				else
					return {}
				end
			else
				return {}
			end
		elseif optionsType == "table" then
			return Options
		else
			return {}
		end
	end
	
	local function createOption(option)
		local optionText = tostring(option.Name or option)
		local optionButton = Create("TextButton", {
			Parent = dropdownList,
			Size = UDim2.new(1, -10, 0, 30),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham,
			TextSize = 12,
			Text = optionText,
			BorderSizePixel = 0,
			ZIndex = 5
		})
	
		Create("UICorner", {
			Parent = optionButton,
			CornerRadius = UDim.new(0, 6)
		})
		
		if selectedOptions[optionText] then
			optionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	
		optionButton.MouseButton1Click:Connect(function()
			if selectedOptions[optionText] then
				selectedOptions[optionText] = nil
				optionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				
				for i, v in ipairs(selectedOrder) do
					if v == optionText then
						table.remove(selectedOrder, i)
						break
					end
				end
			else
				selectedOptions[optionText] = true
				optionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				table.insert(selectedOrder, optionText)
			end
			
			local displayText = table.concat(selectedOrder, ", ")
			if displayText == "" then 
				dropdownButton.Text = Name 
			else
				dropdownButton.Text = displayText
			end
			
			self.UISettings[Name] = selectedOrder
			self.CallbackManager.MultiDropdowns[Name] = Callback
			Callback(selectedOrder)
		end)
	end
	
	local function loadOptions()
		for _, child in ipairs(dropdownList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		selectedOptions = {}
		selectedOrder = {}
		self.alldropdown[Name].SelectedOptions = selectedOptions
		self.alldropdown[Name].SelectedOrder = selectedOrder
		
		local options = getOptions()
		
		for _, option in ipairs(options) do
			createOption(option)
		end
		
		updateCanvasSize()
	end
	
	self.CallbackManager.MultiDropdowns[Name] = Callback
	
	local savedSelections = self.UISettings[Name]
	if savedSelections and type(savedSelections) == "table" then
		for _, option in ipairs(savedSelections) do
			local optionText = tostring(option)
			selectedOptions[optionText] = true
			table.insert(selectedOrder, optionText)
		end
		if #selectedOrder > 0 then
			dropdownButton.Text = table.concat(selectedOrder, ", ")
		end
	end
	
	loadOptions()
	
	dropdownButton.MouseButton1Click:Connect(function()
		for dropdownName, dropdownData in pairs(self.alldropdown) do
			if dropdownName ~= Name and dropdownData.List and dropdownData.List.Visible then
				dropdownData.List.Visible = false
			end
		end
		
		dropdownList.Visible = not dropdownList.Visible
	end)
	
	if Refresh then
		local refreshFrame = Create("Frame", {
			Parent = containerFrame,
			Size = UDim2.new(0.13, 0, 1, 0),
			Position = UDim2.new(0.85, 5, 0, 0),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderSizePixel = 2,
			BorderColor3 = Color3.fromRGB(30, 30, 30),
			ZIndex = 4
		})

		Create("UICorner", {
			Parent = refreshFrame,
			CornerRadius = UDim.new(0, 8)
		})

		local refreshButton = Create("ImageButton", {
			Parent = refreshFrame,
			Size = UDim2.new(1, -8, 1, -8),
			Position = UDim2.new(0, 4, 0, 4),
			BackgroundTransparency = 1,
			Image = "rbxassetid://122032243989747",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 4
		})

		local debounce = false
		refreshButton.MouseButton1Click:Connect(function()
			if debounce then return end
			debounce = true
			loadOptions()
			debounce = false
		end)
	end

	updateCanvasSize()
	self.UIElements[Name] = {
		Type = "MultiDropdown",
		Frame = containerFrame,
		DropdownButton = dropdownButton,
		DropdownList = dropdownList,
		Options = Options,
		Selected = savedSelections,
		Callback = Callback
	}
	return containerFrame
end

function ReyUILib:CreateSlider(parent, Name, min, max, default, callback)
	callback = callback or function() end
	
	self.CallbackManager.Sliders[Name] = callback
	local savedValue = self.UISettings[Name]
	if savedValue then
		default = savedValue
	end
	
	local containerFrame = Create("Frame", {
		Name = Name,
		Parent = parent,
		Size = UDim2.new(1, -10, 0, 70),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30),
		ZIndex = 1
	})

	Create("UICorner", {
		Parent = containerFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local titleLabel = Create("TextLabel", {
		Name = "Title",
		Parent = containerFrame,
		Size = UDim2.new(0.7, 0, 0, 25),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Text = Name.." - "..tostring(default),
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local sliderBackground = Create("Frame", {
		Parent = containerFrame,
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 40),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = sliderBackground,
		CornerRadius = UDim.new(0, 10)
	})

	Create("UIStroke", {
		Parent = sliderBackground,
		Thickness = 1.8,
		Color = Color3.fromRGB(30, 30, 30)
	})

	local sliderFill = Create("Frame", {
		Name = "SliderFill",
		Parent = sliderBackground,
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		BorderSizePixel = 0,
		ZIndex = 2
	})

	Create("UICorner", {
		Parent = sliderFill,
		CornerRadius = UDim.new(0, 10)
	})

	local sliderKnob = Create("Frame", {
		Name = "SliderKnob",
		Parent = sliderBackground,
		Size = UDim2.new(0, 26, 1.5, 0),
		Position = UDim2.new((default - min) / (max - min), -13, -0.25, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 3
	})

	Create("UICorner", {
		Parent = sliderKnob,
		CornerRadius = UDim.new(0, 12)
	})

	Create("UIStroke", {
		Parent = sliderKnob,
		Thickness = 1.8,
		Color = Color3.fromRGB(30, 30, 30)
	})

	local inputBox = Create("TextBox", {
		Name = "InputBox",
		Parent = containerFrame,
		Size = UDim2.new(0.15, 0, 0, 25),
		Position = UDim2.new(0.85, -10, 0, 5),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 16,
		Text = tostring(default),
		PlaceholderText = tostring(default),
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center
	})

	Create("UICorner", {
		Parent = inputBox,
		CornerRadius = UDim.new(0, 6)
	})

	Create("UIStroke", {
		Parent = inputBox,
		Thickness = 1,
		Color = Color3.fromRGB(30, 30, 30)
	})
	
	local currentValue = default
	self.UIElements[Name] = {
		Type = "Slider",
		Frame = containerFrame,
		TitleLabel = titleLabel,
		ValueLabel = valueLabel,
		InputBox = inputBox,
		SliderFill = sliderFill,
		SliderKnob = sliderKnob,
		SliderBackground = sliderBackground,
		Min = min,
		Max = max,
		Value = currentValue,
		Callback = callback
	}
	
	self.UISettings[Name] = currentValue
	
	local function updateSlider(value, forceUpdate)
		value = math.clamp(value, min, max)
		if value ~= currentValue or forceUpdate then
			currentValue = value
			local sliderPos = (value - min) / (max - min)
			
			sliderFill.Size = UDim2.new(sliderPos, 0, 1, 0)
			sliderKnob.Position = UDim2.new(sliderPos, -13, -0.25, 0)
			titleLabel.Text = Name.." - "..tostring(value)
			inputBox.Text = tostring(value)
			self.UISettings[Name] = value
			self.UIElements[Name].Value = value
			
			callback(value)
		end
	end

	local function startDragging()
		local connection
		local lastValue = currentValue
		
		connection = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
				local sliderPos = math.clamp((moveInput.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
				local value = math.floor(sliderPos * (max - min) + min)
				
				if value ~= lastValue then
					lastValue = value
					updateSlider(value)
				end
			end
		end)
		
		game:GetService("UserInputService").InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
				if connection then
					connection:Disconnect()
				end
			end
		end)
	end

	sliderKnob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			startDragging()
		end
	end)

	sliderBackground.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local sliderPos = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
			local value = math.floor(sliderPos * (max - min) + min)
			updateSlider(value)
		end
	end)

	inputBox.FocusLost:Connect(function()
		local value = tonumber(inputBox.Text)
		if value then
			updateSlider(value)
		else
			inputBox.Text = tostring(currentValue)
		end
	end)

	return containerFrame
end

function ReyUILib:CreateNote(parent, text)
	local noteFrame = Create("Frame", {
		Parent = parent,
		Size = UDim2.new(1, -10, 0, 0),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y
	})

	Create("UICorner", {
		Parent = noteFrame,
		CornerRadius = UDim.new(0, 8)
	})

	Create("UIStroke", {
		Parent = noteFrame,
		Thickness = 1.5,
		Color = Color3.fromRGB(30, 30, 30)
	})
	
	local container = Create("Frame", {
		Parent = noteFrame,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	})

	local topPadding = Create("Frame", {
		Parent = container,
		Size = UDim2.new(1, 0, 0, 10),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	})

	local note = Create("TextLabel", {
		Parent = container,
		Size = UDim2.new(1, -20, 0, 0),
		BackgroundTransparency = 1,
		Text = text or "Note",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	})

	local bottomPadding = Create("Frame", {
		Parent = container,
		Size = UDim2.new(1, 0, 0, 10),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	})

	local layout = Create("UIListLayout", {
		Parent = container,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return noteFrame
end

function ReyUILib:CreateInput(parent, title, description, callback)
	local callback = callback or function(text) end
	self.CallbackManager.Inputs[title] = callback
	
	local inputFrame = Create("Frame", {
		Name = title,
		Parent = parent,
		Size = UDim2.new(1, -10, 0, 70),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30)
	})

	Create("UICorner", {
		Parent = inputFrame,
		CornerRadius = UDim.new(0, 8)
	})

	local titleLabel = Create("TextLabel", {
		Parent = inputFrame,
		Size = UDim2.new(0.6, 0, 0, 20),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local descLabel = Create("TextLabel", {
		Parent = inputFrame,
		Size = UDim2.new(0.6, 0, 0, 15),
		Position = UDim2.new(0, 10, 0, 25),
		BackgroundTransparency = 1,
		Text = description,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	})

	local valueLabel = Create("TextLabel", {
		Parent = inputFrame,
		Size = UDim2.new(0.6, 0, 0, 15),
		Position = UDim2.new(0, 10, 0, 45),
		BackgroundTransparency = 1,
		Text = "Value set to: None",
		TextColor3 = Color3.fromRGB(200, 200, 200),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local textBoxContainer = Create("Frame", {
		Parent = inputFrame,
		Size = UDim2.new(0.19, 0, 0, 30),
		Position = UDim2.new(0.62, 0, 0.28, 0),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = textBoxContainer,
		CornerRadius = UDim.new(0, 6)
	})

	Create("UIStroke", {
		Parent = textBoxContainer,
		Thickness = 1.5,
		Color = Color3.fromRGB(85, 85, 255)
	})

	local textBox = Create("TextBox", {
		Parent = textBoxContainer,
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 5, 0, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		PlaceholderText = "Input",
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		ClearTextOnFocus = true,
		Text = "",
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local enterButton = Create("TextButton", {
		Parent = inputFrame,
		Size = UDim2.new(0, 60, 0, 30),
		Position = UDim2.new(0.82, 0, 0.28, 0),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "Set",
		BorderSizePixel = 0
	})

	Create("UICorner", {
		Parent = enterButton,
		CornerRadius = UDim.new(0, 6)
	})

	local function submit()
		local text = textBox.Text
		if text and text ~= "" then
			valueLabel.Text = "Value set to: " .. text
			self.UISettings[title] = text
			callback(text)
		end
	end

	enterButton.MouseButton1Click:Connect(submit)

	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			submit()
		end
	end)

	local savedValue = self.UISettings[title]
	if savedValue then
		valueLabel.Text = "Value set to: " .. savedValue
	end

	self.UIElements[title] = {
		Type = "Input",
		Frame = inputFrame,
		TextBox = textBox,
		TextBoxContainer = textBoxContainer,
		EnterButton = enterButton,
		ValueLabel = valueLabel,
		Value = savedValue or "",
		Callback = callback
	}

	return inputFrame
end

function ReyUILib:Notify(style, title, description, duration)
	if self.UISettings["Disable Notif"] then
		return
	end

	local TweenService = game:GetService("TweenService")
	local TextService = game:GetService("TextService")
	local Players = game:GetService("Players")
	
	if not Players.LocalPlayer then return end
	
	if not self.NotifData then
		self.NotifData = {
			MaxStack = 4,
			NotifScale = 0.9,
			FixedWidth = 280,
			Active = {},
			Queue = {}
		}
		
		local success, playerGui = pcall(function()
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end)
		
		if not success then return end
		
		if playerGui:FindFirstChild("ReyNotifGui") then
			playerGui:FindFirstChild("ReyNotifGui"):Destroy()
		end
		
		local gui = Instance.new("ScreenGui")
		gui.Name = "ReyNotifGui"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.Parent = playerGui
		self.NotifData.Gui = gui
	end
	
	local data = self.NotifData
	local gui = data.Gui
	local Active = data.Active
	local Queue = data.Queue
	
	local Colors = {
		success = Color3.fromRGB(60, 220, 120),
		error = Color3.fromRGB(255, 65, 65),
		warning = Color3.fromRGB(255, 200, 55),
		info = Color3.fromRGB(120, 180, 255),
		normal = Color3.fromRGB(40, 40, 40)
	}
	
	local IconAssets = {
		success = "rbxassetid://17829956110",
		error = "rbxassetid://6031071053",
		warning = "rbxassetid://6031071050",
		info = "rbxassetid://6031075931",
		normal = ""
	}
	
	local scale = data.NotifScale
	local fixedW = data.FixedWidth * scale
	duration = duration or 3
	
	if #Active >= data.MaxStack then
		table.insert(Queue, {style = style, title = title, description = description, duration = duration})
		return
	end
	
	local fontTitle = Enum.Font.GothamBold
	local fontDesc = Enum.Font.Gotham
	local textSizeTitle = 16 * scale
	local textSizeDesc = 13 * scale
	
	local textXOffset = (style == "normal" and 15 or 65) * scale
	local availableWidth = fixedW - textXOffset - (10 * scale)
	
	local titleSize = TextService:GetTextSize(title, textSizeTitle, fontTitle, Vector2.new(availableWidth, 9999))
	local titleHeight = math.max(22 * scale, titleSize.Y)
	
	local descSize = TextService:GetTextSize(description, textSizeDesc, fontDesc, Vector2.new(availableWidth, 9999))
	local descHeight = math.max(20 * scale, descSize.Y)
	
	local totalHeight = (10 * scale) + titleHeight + (2 * scale) + descHeight + (10 * scale)
	totalHeight = math.max(70 * scale, totalHeight)
	
	local themeColor = Colors[style] or Colors.normal
	local baseDark = Color3.fromRGB(20, 20, 20)
	local tintedColor = baseDark:lerp(themeColor, 0.1)
	
	local frame = Create("Frame", {
		Name = "NotifFrame",
		Parent = gui,
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.new(0, fixedW, 0, totalHeight),
		Position = UDim2.new(1, fixedW + 50, 1, -(50 * scale)),
		BackgroundColor3 = tintedColor,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 10 * scale)})
	
	local stroke = Create("UIStroke", {
		Parent = frame,
		Color = themeColor,
		Thickness = 1.5 * scale,
		Transparency = 1
	})
	
	local icon = Create("ImageLabel", {
		Parent = frame,
		Size = UDim2.new(0, 45 * scale, 0, 45 * scale),
		Position = UDim2.new(0, 10 * scale, 0, 10 * scale),
		BackgroundTransparency = 1,
		ImageTransparency = 1
	})
	
	if IconAssets[style] and IconAssets[style] ~= "" then
		icon.Image = IconAssets[style]
		icon.ImageColor3 = themeColor
		if style == "warning" then
			icon.Position = UDim2.new(0, 5 * scale, 0, 5 * scale)
			icon.Size = UDim2.new(0, 55 * scale, 0, 55 * scale)
		end
	end
	
	local titleLabel = Create("TextLabel", {
		Parent = frame,
		Position = UDim2.new(0, textXOffset, 0, 10 * scale),
		Size = UDim2.new(0, availableWidth, 0, titleHeight),
		BackgroundTransparency = 1,
		Font = fontTitle,
		TextSize = textSizeTitle,
		TextColor3 = Color3.fromRGB(230, 230, 230),
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Text = title
	})
	
	local descY = (10 * scale) + titleHeight + (2 * scale)
	local descLabel = Create("TextLabel", {
		Parent = frame,
		Position = UDim2.new(0, textXOffset, 0, descY),
		Size = UDim2.new(0, availableWidth, 0, descHeight),
		BackgroundTransparency = 1,
		Font = fontDesc,
		TextSize = textSizeDesc,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Text = description
	})
	
	table.insert(Active, {Frame = frame})
	
	local function Reposition()
		local accumulatedHeight = 0
		for i = #Active, 1, -1 do
			local data = Active[i]
			if data.Frame and data.Frame.Parent then
				local frameHeight = data.Frame.Size.Y.Offset
				local targetYOffset = -(50 * scale + accumulatedHeight)
				TweenService:Create(data.Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
					Position = UDim2.new(1, -20 * scale, 1, targetYOffset)
				}):Play()
				accumulatedHeight = accumulatedHeight + frameHeight + (10 * scale)
			end
		end
	end
	
	Reposition()
	
	TweenService:Create(frame, TweenInfo.new(0.25), {BackgroundTransparency = 0.08}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.2}):Play()
	TweenService:Create(icon, TweenInfo.new(0.25), {ImageTransparency = style == "normal" and 1 or 0}):Play()
	TweenService:Create(titleLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
	TweenService:Create(descLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
	
	task.spawn(function()
		task.wait(duration)
		
		if frame and frame.Parent then
			TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, fixedW + 50, 1, frame.Position.Y.Offset)
			}):Play()
			
			TweenService:Create(stroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
			TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
			TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			TweenService:Create(descLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		end
		
		task.wait(0.35)
		if frame then frame:Destroy() end
		
		for i, data in ipairs(Active) do
			if data.Frame == frame then
				table.remove(Active, i)
				break
			end
		end
		
		Reposition()
		
		if #Queue > 0 and #Active < data.MaxStack then
			local q = table.remove(Queue, 1)
			self:Notify(q.style, q.title, q.description, q.duration)
		end
	end)
end

function ReyUILib:SendWebhook(Url, Avatar, Content, Embed)
	local OSTime = os.time()
	local Time = os.date("!*t", OSTime)
	local timestamp = string.format("%d-%02d-%02dT%02d:%02d:%02dZ", Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)

	if Embed then
		Embed.timestamp = timestamp
	end

	local httpRequest = syn and syn.request or http_request or request
	if not httpRequest then
		return
	end

	local response = httpRequest({
		Url = Url,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = game:GetService("HttpService"):JSONEncode({
			content = Content,
			avatar_url = Avatar,
			embeds = { Embed }
		})
	})
end

function ReyUILib:RemoveElement(tab, Name)
	if not tab or not Name then
		return
	end

	local element = tab:FindFirstChild(Name)
	if element then
		element:Destroy()
	end
end

function ReyUILib:UpdateUIElements()
	for elementName, elementData in pairs(self.UIElements) do
		if elementData then
			local savedValue = self.UISettings[elementName]
			
			if savedValue ~= nil then
				if elementData.Type == "Toggle" then
					local state = (savedValue == true)
					
					if elementData.Circle and elementData.Circle.Parent then
						if state then
							elementData.Circle.Position = UDim2.new(1, -22, 0, 2)
							elementData.Circle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
						else
							elementData.Circle.Position = UDim2.new(0, 2, 0, 2)
							elementData.Circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
						end
					end
					
					elementData.State = state
					
					if elementData.Callback and type(elementData.Callback) == "function" then
						task.spawn(function()
							wait(0.2)
							pcall(elementData.Callback, state)
						end)
					end
					
				elseif elementData.Type == "Slider" then
					if elementData.FillFrame and elementData.FillFrame.Parent then
						local value = savedValue
						local sliderPos = (value - elementData.Min) / (elementData.Max - elementData.Min)
						
						elementData.FillFrame.Size = UDim2.new(sliderPos, 0, 1, 0)
						if elementData.SliderButton then
							elementData.SliderButton.Position = UDim2.new(sliderPos, -15, 0, 0)
						end
						if elementData.Label then
							elementData.Label.Text = elementName .. " - " .. value
						end
						if elementData.InputBox then
							elementData.InputBox.Text = tostring(value)
						end
						elementData.Value = value
						if elementData.Callback and type(elementData.Callback) == "function" then
							task.spawn(function()
								wait(0.05)
								pcall(elementData.Callback, value)
							end)
						end
					end
					
				elseif elementData.Type == "Dropdown" then
					if elementData.DropdownButton and elementData.DropdownButton.Parent then
						if type(savedValue) == "table" then 
							savedValue = "" 
							self.UISettings[elementName] = ""
						end
						
						elementData.DropdownButton.Text = savedValue or elementName
						elementData.Selected = savedValue
						
						if savedValue and savedValue ~= "" and type(savedValue) == "string" then
							if elementData.Callback and type(elementData.Callback) == "function" then
								task.spawn(function()
									wait(0.1)
									pcall(elementData.Callback, savedValue)
								end)
							end
						end
					end
					
				elseif elementData.Type == "MultiDropdown" then
					if elementData.DropdownButton and elementData.DropdownButton.Parent then
						if type(savedValue) == "table" then
							local displayText = table.concat(savedValue, ", ")
							if displayText == "" then 
								elementData.DropdownButton.Text = elementName 
							else
								elementData.DropdownButton.Text = displayText
							end
							elementData.Selected = savedValue
							
							if self.alldropdown[elementName] then
								self.alldropdown[elementName].SelectedOrder = savedValue
								self.alldropdown[elementName].SelectedOptions = {}
								
								for _, option in ipairs(savedValue) do
									self.alldropdown[elementName].SelectedOptions[tostring(option)] = true
								end
							end
							
							if elementData.Callback and type(elementData.Callback) == "function" then
								task.spawn(function()
									wait(0.05)
									pcall(elementData.Callback, savedValue)
								end)
							end
						end
					end
					
				elseif elementData.Type == "Input" then
					if elementData.ValueLabel and elementData.ValueLabel.Parent then
						elementData.ValueLabel.Text = "Value set to: " .. (savedValue or "None")
						elementData.Value = savedValue
						if elementData.Callback and type(elementData.Callback) == "function" then
							task.spawn(function()
								wait(0.05)
								pcall(elementData.Callback, savedValue)
							end)
						end
					end
				end
			end
		end
	end
end

function ReyUILib:UpdateElement(tab, elementName, properties)
	if not tab or not tab:IsA("Frame") then
		return
	end

	local element = tab:FindFirstChild(elementName)
	if not element then
		return
	end

	for property, value in pairs(properties) do
		if property == "Callback" then
			if element:IsA("TextButton") or element:IsA("TextBox") then
				for _, connection in ipairs(element.MouseButton1Click:GetConnections()) do
					connection:Disconnect()
				end
				element.MouseButton1Click:Connect(value)
			elseif element:IsA("Frame") then
				local dropdownButton = element:FindFirstChild("DropdownButton") or 
									  (element:FindFirstChild("Frame") and element.Frame:FindFirstChild("TextButton"))
				if dropdownButton then
					for _, connection in ipairs(dropdownButton.MouseButton1Click:GetConnections()) do
						connection:Disconnect()
					end
					dropdownButton.MouseButton1Click:Connect(value)
				end
			end
		elseif property == "Description" then
			local desc = element:FindFirstChild("Description") or 
						element:FindFirstChild("buttonDesc") or
						(element:FindFirstChild("Frame") and element.Frame:FindFirstChild("TextLabel"))
			if desc then
				desc.Text = value
			end
		elseif property == "Options" then
			if alldropdown[elementName] and alldropdown[elementName].List then
				local dropdownList = alldropdown[elementName].List
				local dropdownFrame = dropdownList.Parent
				
				for _, child in ipairs(dropdownList:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end
				
				if dropdownFrame:FindFirstChild("TextButton") then
					local dropdownButton = dropdownFrame.TextButton
					
					for _, option in ipairs(value) do
						local optionText = option.Name or option
						local optionButton = Create("TextButton", {
							Parent = dropdownList,
							Size = UDim2.new(1, -10, 0, 30),
							BackgroundColor3 = Color3.fromRGB(70, 70, 70),
							TextColor3 = Color3.fromRGB(255, 255, 255),
							Font = Enum.Font.Gotham,
							TextSize = 12,
							Text = optionText,
							BorderSizePixel = 0,
							ZIndex = 2
						})
		
						Create("UICorner", {
							Parent = optionButton,
							CornerRadius = UDim.new(0, 6)
						})
		
						optionButton.MouseButton1Click:Connect(function()
							dropdownButton.Text = optionText
							dropdownList.Visible = false
							ReyUILib.UISettings[elementName] = optionText
							
							if self.CallbackManager.Dropdowns[elementName] then
								self.CallbackManager.Dropdowns[elementName](optionText)
							elseif self.CallbackManager.MultiDropdowns[elementName] then
								local dropdownData = alldropdown[elementName]
								if dropdownData.SelectedOptions and dropdownData.SelectedOrder then
									if dropdownData.SelectedOptions[optionText] then
										dropdownData.SelectedOptions[optionText] = nil
										for i, v in ipairs(dropdownData.SelectedOrder) do
											if v == optionText then
												table.remove(dropdownData.SelectedOrder, i)
												break
											end
										end
									else
										dropdownData.SelectedOptions[optionText] = true
										table.insert(dropdownData.SelectedOrder, optionText)
									end
									
									local displayText = table.concat(dropdownData.SelectedOrder, ", ")
									dropdownButton.Text = displayText == "" and elementName or displayText
									
									ReyUILib.UISettings[elementName] = dropdownData.SelectedOrder
									if self.CallbackManager.MultiDropdowns[elementName] then
										self.CallbackManager.MultiDropdowns[elementName](dropdownData.SelectedOrder)
									end
								end
							end
						end)
					end
				end
			end
		elseif element[property] ~= nil then
			element[property] = value
		end
	end
end

function ReyUILib:ApplyFeatureSettings()
	if self.SFX then
		if self.UISettings["Mute Sound Effect"] then
			for _, sound in pairs(self.SFX:GetChildren()) do
				if sound:IsA("Sound") then
					sound.Volume = 0
				end
			end
		else
			for _, sound in pairs(self.SFX:GetChildren()) do
				if sound:IsA("Sound") then
					sound.Volume = 1
				end
			end
		end
	end
end

function ReyUILib:SaveConfig()
	local success = SaveConfig()
	if success then
		self:Notify("success", "Config Saved", "Settings saved successfully!", 3)
		return true
	else
		self:Notify("error", "Save Failed", "Failed to save config", 5)
		return false
	end
end

function ReyUILib:LoadConfig()
	local loaded = LoadConfig()
	if loaded then
		for name, value in pairs(loaded) do
			ReyUILib.UISettings[name] = value
		end
		
		self:UpdateUIElements()
		self:ApplyFeatureSettings()
		self:Notify("success", "Config Loaded", "Settings loaded successfully!", 3)
		return true
	end
	return false
end

function ReyUILib:ResetConfig()
	ReyUILib.UISettings = {}
	
	for elementName, elementData in pairs(self.UIElements) do
		if elementData then
			if elementData.Type == "Toggle" then
				if elementData.Circle then
					elementData.Circle.Position = UDim2.new(0, 2, 0, 2)
					elementData.Circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				end
				elementData.State = false
				
			elseif elementData.Type == "Slider" then
				if elementData.FillFrame and elementData.SliderButton then
					local defaultValue = elementData.Value or elementData.Min
					local sliderPos = (defaultValue - elementData.Min) / (elementData.Max - elementData.Min)
					elementData.FillFrame.Size = UDim2.new(sliderPos, 0, 1, 0)
					elementData.SliderButton.Position = UDim2.new(sliderPos, -15, 0, 0)
					if elementData.Label then
						elementData.Label.Text = elementName .. " - " .. defaultValue
					end
					if elementData.InputBox then
						elementData.InputBox.Text = tostring(defaultValue)
					end
					elementData.Value = defaultValue
				end
				
			elseif elementData.Type == "Dropdown" then
				if elementData.DropdownButton then
					elementData.DropdownButton.Text = elementName
					elementData.Selected = nil
				end
				
			elseif elementData.Type == "MultiDropdown" then
				if elementData.DropdownButton then
					elementData.DropdownButton.Text = elementName
					elementData.Selected = {}
				end
				
			elseif elementData.Type == "Input" then
				if elementData.ValueLabel then
					elementData.ValueLabel.Text = "Value set to: None"
					elementData.Value = ""
				end
			end
		end
	end
	self:ExecuteAllCallbacks()
	self:Notify("info", "Config Reset", "All settings reset to default", 3)
	return true
end

function ReyUILib:SaveNamedConfig(configName)
	if not configName or configName == "" then return false end
	if not (writefile and isfile) then return false end
	
	local ConfigData = {}
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		if success then ConfigData = decoded end
	end
	
	ConfigData["Games"] = ConfigData["Games"] or {}
	ConfigData["Games"][tostring(game.GameId)] = ConfigData["Games"][tostring(game.GameId)] or {}
	ConfigData["Games"][tostring(game.GameId)]["Configs"] = ConfigData["Games"][tostring(game.GameId)]["Configs"] or {}
	
	local configSettings = {}
	for elementName, elementData in pairs(self.UIElements) do
		local currentValue = self.UISettings[elementName]
		if currentValue == nil then
			if elementData.Type == "Toggle" then
				currentValue = elementData.State or false
			elseif elementData.Type == "Slider" then
				currentValue = elementData.Value or elementData.Min
			elseif elementData.Type == "Dropdown" then
				currentValue = elementData.Selected or elementName
			elseif elementData.Type == "MultiDropdown" then
				currentValue = elementData.Selected or {}
			elseif elementData.Type == "Input" then
				currentValue = elementData.Value or ""
			end
		end
		configSettings[elementName] = currentValue
	end
	
	ConfigData["Games"][tostring(game.GameId)]["Configs"][configName] = configSettings
	
	local success, encoded = pcall(function()
		return game:GetService("HttpService"):JSONEncode(ConfigData)
	end)
	
	if success then
		writefile(ConfigPath, encoded)
		return true
	end
	return false
end

function ReyUILib:LoadNamedConfig(configName)
	if not configName or configName == "" then return false end
	if not (readfile and isfile) then return false end
	
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		
		if success and decoded["Games"] and decoded["Games"][tostring(game.GameId)] then
			local gameConfigs = decoded["Games"][tostring(game.GameId)]
			if gameConfigs["Configs"] and gameConfigs["Configs"][configName] then
				local configSettings = gameConfigs["Configs"][configName]
				self.UISettings = {}
				for name, value in pairs(configSettings) do
					self.UISettings[name] = value
				end
				self:UpdateUIElements()
				return true
			end
		end
	end
	return false
end

function ReyUILib:GetAllConfigs()
	local configs = {}
	if not (readfile and isfile) then return configs end
	
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		
		if success and decoded["Games"] and decoded["Games"][tostring(game.GameId)] then
			local gameConfigs = decoded["Games"][tostring(game.GameId)]
			if gameConfigs["Configs"] then
				for configName, _ in pairs(gameConfigs["Configs"]) do
					table.insert(configs, configName)
				end
			end
		end
	end
	table.sort(configs)
	return configs
end

function ReyUILib:DeleteNamedConfig(configName)
	if not configName or configName == "" then return false end
	if not (writefile and isfile) then return false end
	
	local ConfigData = {}
	if isfile(ConfigPath) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(ConfigPath))
		end)
		if success then ConfigData = decoded end
	end
	
	if ConfigData["Games"] and ConfigData["Games"][tostring(game.GameId)] then
		if ConfigData["Games"][tostring(game.GameId)]["Configs"] then
			ConfigData["Games"][tostring(game.GameId)]["Configs"][configName] = nil
		end
	end
	
	local success, encoded = pcall(function()
		return game:GetService("HttpService"):JSONEncode(ConfigData)
	end)
	
	if success then
		writefile(ConfigPath, encoded)
		return true
	end
	return false
end

function ReyUILib:CreateConfigManager(parent)
	local configManagerFrame = Create("Frame", {
		Name = "ConfigManager",
		Parent = parent,
		Size = UDim2.new(1, -10, 0, 100),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 2,
		BorderColor3 = Color3.fromRGB(30, 30, 30)
	})
	
	Create("UICorner", {Parent = configManagerFrame, CornerRadius = UDim.new(0, 8)})
	
	local title = Create("TextLabel", {
		Parent = configManagerFrame,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = "Config Manager",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local configNameContainer = Create("Frame", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.5, -10, 0, 30),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = configNameContainer, CornerRadius = UDim.new(0, 6)})
	Create("UIStroke", {Parent = configNameContainer, Thickness = 1.5, Color = Color3.fromRGB(85, 85, 255)})
	
	local configNameInput = Create("TextBox", {
		Parent = configNameContainer,
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 5, 0, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		PlaceholderText = "Config name",
		ClearTextOnFocus = true,
		Text = ""
	})
	
	local dropdownOuter = Create("Frame", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.5, -10, 0, 30),
		Position = UDim2.new(0.5, 0, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false
	})
	
	Create("UICorner", {Parent = dropdownOuter, CornerRadius = UDim.new(0, 6)})
	local stroke = Create("UIStroke", {Parent = dropdownOuter, Thickness = 1.5, Color = Color3.fromRGB(85, 85, 255)})
	
	local dropdownContainer = Create("Frame", {
		Parent = dropdownOuter,
		Size = UDim2.new(1, -3, 1, -3),
		Position = UDim2.new(0, 1.5, 0, 1.5),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = dropdownContainer, CornerRadius = UDim.new(0, 5)})
	
	local configListButton = Create("TextButton", {
		Parent = dropdownContainer,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		Text = "Select Config",
		BorderSizePixel = 0
	})
	
	local dropdownList = Create("ScrollingFrame", {
		Name = "ConfigDropdownList",
		Parent = dropdownContainer,
		Size = UDim2.new(1, 0, 0, 150),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
		ZIndex = 2,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	Create("UICorner", {Parent = dropdownList, CornerRadius = UDim.new(0, 6)})
	
	local dropdownLayout = Create("UIListLayout", {
		Parent = dropdownList,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 5),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})
	
	local function updateCanvasSize()
		if dropdownList then
			dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
		end
	end
	
	dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
	
	local saveBtn = Create("TextButton", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.23, -5, 0, 25),
		Position = UDim2.new(0, 10, 0, 65),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "💾 Save",
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = saveBtn, CornerRadius = UDim.new(0, 6)})
	
	local loadBtn = Create("TextButton", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.23, -5, 0, 25),
		Position = UDim2.new(0.26, 0, 0, 65),
		BackgroundColor3 = Color3.fromRGB(85, 85, 255),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "📂 Load",
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = loadBtn, CornerRadius = UDim.new(0, 6)})
	
	local deleteBtn = Create("TextButton", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.23, -5, 0, 25),
		Position = UDim2.new(0.52, 0, 0, 65),
		BackgroundColor3 = Color3.fromRGB(255, 65, 65),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "🗑️ Delete",
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = deleteBtn, CornerRadius = UDim.new(0, 6)})
	
	local refreshBtn = Create("TextButton", {
		Parent = configManagerFrame,
		Size = UDim2.new(0.23, -5, 0, 25),
		Position = UDim2.new(0.78, 0, 0, 65),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "🔄 Refresh",
		BorderSizePixel = 0
	})
	
	Create("UICorner", {Parent = refreshBtn, CornerRadius = UDim.new(0, 6)})
	
	local selectedConfig = nil
	
	local function populateConfigList()
		if not dropdownList then return end
		
		for _, child in ipairs(dropdownList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local configs = self:GetAllConfigs()
		
		if #configs == 0 then
			local noConfigBtn = Create("TextButton", {
				Parent = dropdownList,
				Size = UDim2.new(1, -10, 0, 30),
				BackgroundColor3 = Color3.fromRGB(70, 70, 70),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				Text = "No configs found",
				BorderSizePixel = 0,
				ZIndex = 2,
				AutoButtonColor = false
			})
			
			Create("UICorner", {Parent = noConfigBtn, CornerRadius = UDim.new(0, 6)})
		else
			for _, configName in ipairs(configs) do
				local configBtn = Create("TextButton", {
					Parent = dropdownList,
					Size = UDim2.new(1, -10, 0, 30),
					BackgroundColor3 = Color3.fromRGB(70, 70, 70),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.Gotham,
					TextSize = 12,
					Text = configName,
					BorderSizePixel = 0,
					ZIndex = 2
				})
				
				Create("UICorner", {Parent = configBtn, CornerRadius = UDim.new(0, 6)})
				
				configBtn.MouseButton1Click:Connect(function()
					selectedConfig = configName
					configListButton.Text = configName
					dropdownList.Visible = false
				end)
			end
		end
		
		updateCanvasSize()
		configListButton.Text = selectedConfig or (#configs > 0 and "Select Config ("..#configs..")" or "No Configs")
	end
	
	configListButton.MouseButton1Click:Connect(function()
		if dropdownList then
			dropdownList.Visible = not dropdownList.Visible
		end
	end)
	
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if dropdownList and dropdownList.Visible then
				local mousePos = game:GetService("UserInputService"):GetMouseLocation()
				local dropdownAbsolutePos = dropdownList.AbsolutePosition
				local dropdownSize = dropdownList.AbsoluteSize
				
				if not (mousePos.X >= dropdownAbsolutePos.X and mousePos.X <= dropdownAbsolutePos.X + dropdownSize.X and
					   mousePos.Y >= dropdownAbsolutePos.Y and mousePos.Y <= dropdownAbsolutePos.Y + dropdownSize.Y) then
					dropdownList.Visible = false
				end
			end
		end
	end)
	
	saveBtn.MouseButton1Click:Connect(function()
		local configName = configNameInput.Text
		if configName and configName ~= "" then
			if self:SaveNamedConfig(configName) then
				self:Notify("success", "Config Saved", "Config '"..configName.."' saved!", 3)
				configNameInput.Text = ""
				selectedConfig = configName
				populateConfigList()
			end
		else
			self:Notify("error", "Save Failed", "Enter config name first!", 3)
		end
	end)
	
	loadBtn.MouseButton1Click:Connect(function()
		if selectedConfig then
			if self:LoadNamedConfig(selectedConfig) then
				self:Notify("success", "Config Loaded", "Config '"..selectedConfig.."' loaded!", 3)
			end
		else
			self:Notify("error", "Load Failed", "Select a config first!", 3)
		end
	end)
	
	deleteBtn.MouseButton1Click:Connect(function()
		if selectedConfig then
			if self:DeleteNamedConfig(selectedConfig) then
				self:Notify("warning", "Config Deleted", "Config '"..selectedConfig.."' deleted!", 3)
				selectedConfig = nil
				populateConfigList()
			end
		else
			self:Notify("error", "Delete Failed", "Select a config first!", 3)
		end
	end)
	
	refreshBtn.MouseButton1Click:Connect(function()
		populateConfigList()
		self:Notify("info", "Config List", "Config list refreshed", 2)
	end)
	
	populateConfigList()
	
	return configManagerFrame
end

function ReyUILib:UpdateDropdownValue(dropdownName, value)
	if self.UIElements[dropdownName] and self.UIElements[dropdownName].Type == "Dropdown" then
		local elementData = self.UIElements[dropdownName]
		if elementData.DropdownButton then
			elementData.DropdownButton.Text = value
		end
		elementData.Selected = value
		self.UISettings[dropdownName] = value
		
		if elementData.Callback and type(elementData.Callback) == "function" then
			pcall(elementData.Callback, value)
		end
		
		if self.CallbackManager.Dropdowns[dropdownName] then
			pcall(self.CallbackManager.Dropdowns[dropdownName], value)
		end
	end
end

function ReyUILib:ClearAllDropdowns()
	alldropdown = {}
end

function ReyUILib:GetActiveDropdowns()
	return alldropdown
end

function ReyUILib:CloseAllDropdowns()
	for dropdownName, dropdownData in pairs(alldropdown) do
		if dropdownData.List and dropdownData.List.Visible then
			dropdownData.List.Visible = false
		end
	end
end

function ReyUILib:TurnOffAllToggles()
	for toggleName, callback in pairs(self.CallbackManager.Toggles) do
		self.UISettings[toggleName] = false
		
		if type(callback) == "function" then
			pcall(function() callback(false) end)
		end
	end
end


function ReyUILib:MonitorUIDeletion(uiInstance)
	if not uiInstance then return end
	
	local connection
	connection = uiInstance.AncestryChanged:Connect(function()
		if not uiInstance:IsDescendantOf(game) then
			self:TurnOffAllToggles()
			if connection then
				connection:Disconnect()
			end
		end
	end)
end

return ReyUILib
