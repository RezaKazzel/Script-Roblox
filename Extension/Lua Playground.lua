--// Lua Playground
--// Rey Library
local Rey = loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/UI/Rey%20Library%20New"))()

--// Hapus
local UI = Rey:CreateUI("Lua Playground")
local Main = Rey:CreateTab(UI, "Lua Playground")

local player = game.Players.LocalPlayer

Rey:CreateNote(Main, "Extension ini hanya untuk sesepuh coding")
Rey:CreateToggle(Main, "Add Button", "Tambahin Tombol", function(state)
GuiButton = state
if GuiButton then
	local player = game.Players.LocalPlayer
	
	frame = Instance.new("Frame")
	frame.Name = "AddButtonFrame"
	frame.Size = UDim2.new(0, 350, 0, 250)
	frame.Position = UDim2.new(0.5, -175, 0.5, -125)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = Main
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 2
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Parent = frame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Buat Tombol"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.Parent = frame
	
	local tb1 = Instance.new("TextBox")
	tb1.Size = UDim2.new(0.45, 0, 0.2, 0)
	tb1.Position = UDim2.new(0.05, 0, 0.2, 0)
	tb1.PlaceholderText = "Nama Tombol"
	tb1.Text = "Button"
	tb1.Parent = frame
	
	local tb2 = Instance.new("TextBox")
	tb2.Size = UDim2.new(0.45, 0, 0.2, 0)
	tb2.Position = UDim2.new(0.5, 0, 0.2, 0)
	tb2.PlaceholderText = "Warna (R,G,B)"
	tb2.Text = "45, 45, 45"
	tb2.Parent = frame
	
	local tb3 = Instance.new("TextBox")
	tb3.Size = UDim2.new(0.9, 0, 0.3, 0)
	tb3.Position = UDim2.new(0.05, 0, 0.45, 0)
	tb3.PlaceholderText = "Code"
	tb3.Text = "print('Miaw')"
	tb3.MultiLine = true
	tb3.Parent = frame
	
	local okButton = Instance.new("TextButton")
	okButton.Size = UDim2.new(0.4, 0, 0.15, 0)
	okButton.Position = UDim2.new(0.05, 0, 0.8, 0)
	okButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	okButton.Text = "OK"
	okButton.Parent = frame
	
	tb1.ClearTextOnFocus = false
	tb2.ClearTextOnFocus = false
	tb3.ClearTextOnFocus = false
	
	local function createButton()
		local function getTextColor(buttonColor)
			local r, g, b = buttonColor.R, buttonColor.G, buttonColor.B
			local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
		
			if luminance < 0.5 then
				return Color3.fromRGB(255, 255, 255)
			else
				return Color3.fromRGB(0, 0, 0)
			end
		end
			
		local name = tb1.Text
		local colorText = tb2.Text
		local code = tb3.Text
		
		local r, g, b = colorText:match("(%d+), (%d+), (%d+)")
		if not (r and g and b) then return print("Warna tidak benar, contoh yang benar: 45, 45, 45")end
		local buttonColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
		
		local newButton = Instance.new("TextButton")
		newButton.Size = UDim2.new(0, 70, 0, 50)
		newButton.Position = UDim2.new(0.5, -50, 0, -20)
		newButton.BackgroundColor3 = buttonColor
		newButton.TextColor3 = getTextColor(buttonColor)
		newButton.Text = name
		newButton.Draggable = true
		newButton.Active = true
		newButton.Parent = UI.ScreenGui
		
		local uiCornerButton = Instance.new("UICorner")
		uiCornerButton.CornerRadius = UDim.new(0, 6)
		uiCornerButton.Parent = newButton
		
		ButtonPosition = newButton.Position
		
		newButton.MouseButton1Click:Connect(function()
		if newButton.Position ~= ButtonPosition then ButtonPosition = newButton.Position return end 
			local func = loadstring(code)
			if func then
				func()
			end
		end)
	end
	
	okButton.MouseButton1Click:Connect(createButton)
else
	Main:FindFirstChild("AddButtonFrame"):Destroy()
end
end)

Rey:CreateToggle(Main, "Add Toggle", "Tambahin Toggle", function(state)
GuiToggle = state
if GuiToggle then
	local player = game.Players.LocalPlayer
	
	frame = Instance.new("Frame")
	frame.Name = "AddToggleFrame"
	frame.Size = UDim2.new(0, 350, 0, 250)
	frame.Position = UDim2.new(0.5, -175, 0.5, -125)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = Main
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 2
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Parent = frame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Buat Toggle"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.Parent = frame
	
	local tb1 = Instance.new("TextBox")
	tb1.Size = UDim2.new(0.45, 0, 0.2, 0)
	tb1.Position = UDim2.new(0.05, 0, 0.2, 0)
	tb1.PlaceholderText = "Nama Toggle"
	tb1.Text = "Toggle"
	tb1.Parent = frame
	
	local tb2 = Instance.new("TextBox")
	tb2.Size = UDim2.new(0.45, 0, 0.2, 0)
	tb2.Position = UDim2.new(0.5, 0, 0.2, 0)
	tb2.PlaceholderText = "Warna (R,G,B)"
	tb2.Text = "45, 45, 45"
	tb2.Parent = frame
	
	local tb3 = Instance.new("TextBox")
	tb3.Size = UDim2.new(0.9, 0, 0.3, 0)
	tb3.Position = UDim2.new(0.05, 0, 0.45, 0)
	tb3.PlaceholderText = "Code"
	tb3.Text = "if state then print('ON') else print('OFF') end"
	tb3.MultiLine = true
	tb3.Parent = frame
	
	local okToggle = Instance.new("TextButton")
	okToggle.Size = UDim2.new(0.4, 0, 0.15, 0)
	okToggle.Position = UDim2.new(0.05, 0, 0.8, 0)
	okToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	okToggle.Text = "OK"
	okToggle.Parent = frame
	
	tb1.ClearTextOnFocus = false
	tb2.ClearTextOnFocus = false
	tb3.ClearTextOnFocus = false
	
	local function createToggle()
		local function getTextColor(ToggleColor)
			local r, g, b = ToggleColor.R, ToggleColor.G, ToggleColor.B
			local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
		
			if luminance < 0.5 then
				return Color3.fromRGB(255, 255, 255)
			else
				return Color3.fromRGB(0, 0, 0)
			end
		end
			
		local name = tb1.Text
		local colorText = tb2.Text
		local code = tb3.Text
		local State = "OFF"
		local state = false
		
		local r, g, b = colorText:match("(%d+), (%d+), (%d+)")
		if not (r and g and b) then return print("Warna tidak benar, contoh yang benar: 45, 45, 45")end
		local ToggleColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
		
		local newToggle = Instance.new("TextButton")
		newToggle.Size = UDim2.new(0, 70, 0, 50)
		newToggle.Position = UDim2.new(0.5, -50, 0, -20)
		newToggle.BackgroundColor3 = ToggleColor
		newToggle.TextColor3 = getTextColor(ToggleColor)
		newToggle.Text = name..": "..State
		newToggle.Draggable = true
		newToggle.Active = true
		newToggle.Parent = UI.ScreenGui
		
		local uiCornerToggle = Instance.new("UICorner")
		uiCornerToggle.CornerRadius = UDim.new(0, 6)
		uiCornerToggle.Parent = newToggle
		
		local TogglePosition = newToggle.Position
		
		newToggle.MouseButton1Click:Connect(function()
			if newToggle.Position ~= TogglePosition then TogglePosition = newToggle.Position return end
			state = not state
			if state then
				State = "ON"
			else
				State = "OFF"
			end
			newToggle.Text = name..": "..State
			local func = loadstring("return function(state) " .. code .. " end")
			if func then
				Code = func()
				Code(state)
			end
		end)
	end
	
	okToggle.MouseButton1Click:Connect(createToggle)
else
	Main:FindFirstChild("AddToggleFrame"):Destroy()
end
end)
