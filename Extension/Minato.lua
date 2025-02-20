--// Minato
local Rey = loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/UI/Rey%20Library%20New"))()

local Main = Rey:CreateTab(UI, "Minato")

local player = game.Players.LocalPlayer
local marks = {}

Rey:CreateButton(Main, "Get Minato Kunai V1", "Mark nya bisa banyak", "Get", function()
	local tool = Instance.new("Tool")
	tool.Name = "MinatoKunai V1"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 350, 0, 180)
	frame.Position = UDim2.new(0.5, -175, 0.5, -90)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Visible = false
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 2
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Parent = frame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Buat Mark"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.Parent = frame
	
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.85, 0, 0.25, 0)
	textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
	textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	textBox.PlaceholderText = "Masukkan nama mark..."
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.Parent = frame
	
	local textBoxCorner = Instance.new("UICorner")
	textBoxCorner.CornerRadius = UDim.new(0, 6)
	textBoxCorner.Parent = textBox
	
	local okButton = Instance.new("TextButton")
	okButton.Size = UDim2.new(0.4, 0, 0.25, 0)
	okButton.Position = UDim2.new(0.075, 0, 0.65, 0)
	okButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	okButton.Text = "OK"
	okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	okButton.Font = Enum.Font.GothamBold
	okButton.TextSize = 14
	okButton.Parent = frame
	
	local okButtonCorner = Instance.new("UICorner")
	okButtonCorner.CornerRadius = UDim.new(0, 6)
	okButtonCorner.Parent = okButton
	
	local cancelButton = Instance.new("TextButton")
	cancelButton.Size = UDim2.new(0.4, 0, 0.25, 0)
	cancelButton.Position = UDim2.new(0.525, 0, 0.65, 0)
	cancelButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	cancelButton.Text = "Cancel"
	cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelButton.Font = Enum.Font.GothamBold
	cancelButton.TextSize = 14
	cancelButton.Parent = frame
	
	local cancelButtonCorner = Instance.new("UICorner")
	cancelButtonCorner.CornerRadius = UDim.new(0, 6)
	cancelButtonCorner.Parent = cancelButton
	
	sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://97536925165304"
	sfx.Parent = UI.SFX
	
	local function markLocation(name, position)
		table.insert(marks, name)
		marks[name] = position
	end
	
	tool.Activated:Connect(function()
		if not debounce then
			frame.Visible = true
			textBox.Text = "Berak"
			task.spawn(function()
				debounce = true
				task.wait(1)
				debounce = false
			end)
		end
	end)
	
	if _G.SaveTool then
		player.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			if tool then
				tool.Parent = player.Backpack
				tool.Activated:Connect(function()
					if tool.Name == "Marking Kunai" then
						if not debounce then
							frame.Visible = true
							textBox.Text = "Marked Kunai"
							task.spawn(function()
								debounce = true
								task.wait(1)
								debounce = false
							end)
						end
					else
						sfx:Play()
						player.Character.HumanoidRootPart.CFrame = markv3
					end
				end)
			end
		end)
	end
	
	local function CheckName(name)
		for i, v in ipairs (marks) do
			if v == name then
				return false
			end
		end
		return true
	end
	
	okButton.MouseButton1Click:Connect(function()
		local name = textBox.Text
		if name ~= "" and CheckName(name) then
			markLocation(name, player.Character.HumanoidRootPart.Position)
		else
			print("Nama mark gaboleh sama atau kosong cik")
		end
		frame.Visible = false
		task.spawn(function()
			debounce = true
			task.wait(1)
			debounce = false
		end)
	end)
	
	cancelButton.MouseButton1Click:Connect(function()
		frame.Visible = false
		task.spawn(function()
			debounce = true
			task.wait(1)
			debounce = false
		end)
	end)
end)

function Marks()
	return marks
end

pcall(function()
	local httpService = game:GetService('HttpService')
	Data = httpService:JSONDecode(readfile("REY HUB/Extension/Minato.json"))
	local Marksv = Data["Games"][tostring(game.GameId)]["Location"]
	for k, v in pairs(Marksv) do
		table.insert(marks, k)
		local numbers = string.split(v, ", ")
		local cf = Vector3.new(tonumber(numbers[1]), tonumber(numbers[2]), tonumber(numbers[3]))
		marks[k] = cf
		print(k, marks[k])
	end
end)

Rey:CreateDropdown(Main, "Teleport to Mark", Marks, function(mark)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(marks[mark])
	end
sfx:Play()
end, true)

Rey:CreateButton(Main, "Get Minato Kunai V2", "baca note dibawah", "Get", function()
	local tool = Instance.new("Tool")
	tool.Name = "MinatoKunai V2"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://97536925165304"
	sfx.Parent = UI.SFX
	local markv2
	local v2 = 0
	
	if _G.SaveTool then
		player.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			if tool then
				tool.Parent = player.Backpack
				tool.Activated:Connect(function()
					if tool.Name == "Marking Kunai" then
						if not debounce then
							frame.Visible = true
							textBox.Text = "Marked Kunai"
							task.spawn(function()
								debounce = true
								task.wait(1)
								debounce = false
							end)
						end
					else
						sfx:Play()
						player.Character.HumanoidRootPart.CFrame = markv3
					end
				end)
			end
		end)
	end
	
	tool.Activated:Connect(function()
		task.spawn(function()
			if not cd then
				cd = true
				task.wait(0.5)
				if v2 == 1 then
					if markv2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						player.Character.HumanoidRootPart.CFrame = markv2
						sfx:Play()
					else
						if not markv2 then
							game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Kunai"; Text = "Not Marked Yet";}) Duration = 3;
						end
					end
				else if v2 > 2 then
					game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Kunai"; Text = "Marked";}) Duration = 3;
					markv2 = player.Character.HumanoidRootPart.CFrame
					end
				end
				cd = false
				v2 = 0
			end
		end)
		v2 = v2 + 1
	end)
end)

Rey:CreateNote(Main,"V2:\nKlik cepat 3 kali atau lebih untuk Marking,\nliterally sampah😹")

Rey:CreateButton(Main, "Get Minato Kunai V3", "kilat kuning⚡", "Get", function()
	local tool = Instance.new("Tool")
	tool.Name = "Marking Kunai"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://97536925165304"
	sfx.Parent = UI.SFX
	local markv3
	local v2 = 0
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 350, 0, 180)
	frame.Position = UDim2.new(0.5, -175, 0.5, -90)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Visible = false
	frame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 2
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Parent = frame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Buat Mark"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.Parent = frame
	
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.85, 0, 0.25, 0)
	textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
	textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	textBox.PlaceholderText = "Masukkan nama mark..."
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.Parent = frame
	
	local textBoxCorner = Instance.new("UICorner")
	textBoxCorner.CornerRadius = UDim.new(0, 6)
	textBoxCorner.Parent = textBox
	
	local okButton = Instance.new("TextButton")
	okButton.Size = UDim2.new(0.4, 0, 0.25, 0)
	okButton.Position = UDim2.new(0.075, 0, 0.65, 0)
	okButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	okButton.Text = "OK"
	okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	okButton.Font = Enum.Font.GothamBold
	okButton.TextSize = 14
	okButton.Parent = frame
	
	local okButtonCorner = Instance.new("UICorner")
	okButtonCorner.CornerRadius = UDim.new(0, 6)
	okButtonCorner.Parent = okButton
	
	local cancelButton = Instance.new("TextButton")
	cancelButton.Size = UDim2.new(0.4, 0, 0.25, 0)
	cancelButton.Position = UDim2.new(0.525, 0, 0.65, 0)
	cancelButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	cancelButton.Text = "Cancel"
	cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelButton.Font = Enum.Font.GothamBold
	cancelButton.TextSize = 14
	cancelButton.Parent = frame
	
	local cancelButtonCorner = Instance.new("UICorner")
	cancelButtonCorner.CornerRadius = UDim.new(0, 6)
	cancelButtonCorner.Parent = cancelButton
	
	okButton.MouseButton1Click:Connect(function()
		local name = textBox.Text
		if name ~= "" then
			markv3 = player.Character.HumanoidRootPart.CFrame
			tool.Name = name
		else
			print("Nama mark gaboleh sama atau kosong cik")
		end
		frame.Visible = false
		task.spawn(function()
			debounce = true
			task.wait(1)
			debounce = false
		end)
	end)
	
	cancelButton.MouseButton1Click:Connect(function()
		frame.Visible = false
		task.spawn(function()
			debounce = true
			task.wait(1)
			debounce = false
		end)
	end)
	
	if _G.SaveTool then
		player.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			if tool then
				tool.Parent = player.Backpack
				tool.Activated:Connect(function()
					if tool.Name == "Marking Kunai" then
						if not debounce then
							frame.Visible = true
							textBox.Text = "Marked Kunai"
							task.spawn(function()
								debounce = true
								task.wait(1)
								debounce = false
							end)
						end
					else
						sfx:Play()
						player.Character.HumanoidRootPart.CFrame = markv3
					end
				end)
			end
		end)
	end
	
	tool.Activated:Connect(function()
		if tool.Name == "Marking Kunai" then
			if not debounce then
				frame.Visible = true
				textBox.Text = "Marked Kunai"
				task.spawn(function()
					debounce = true
					task.wait(1)
					debounce = false
				end)
			end
		else
			sfx:Play()
			player.Character.HumanoidRootPart.CFrame = markv3
		end
	end)
end)

Rey:CreateNote(Main,"V3:\nMarking Kunai digunakan untuk Marking,\nMarked Kunai digunakan untuk Teleport ke tempat yang sudah di tandai menggunakan Marking Kunai,\nbtw perlu di ingat kalo v3 masih blm bisa disimpan😋.")

Rey:CreateButton(Main, "Teleport Kunai (Hiraishin)", "Click to Teleport", "Get", function()
	local Mouse = player:GetMouse()
	local tool = Instance.new("Tool")
	tool.Name = "Hiraishin"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://97536925165304"
	sfx.Parent = UI.SFX
	tool.Activated:Connect(function()
		local Char = player.Character or workspace:FindFirstChild(player.Name)
		local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
		if not Char or not HRP then
			return warn("Failed to find HumanoidRootPart")
		end
		HRP.CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z, select(4, HRP.CFrame:components()))
	end)
	if _G.SaveTool then
		player.CharacterAdded:Connect(function(character)
			task.wait(0.5)
			if tool then
				tool.Parent = player.Backpack
				tool.Activated:Connect(function()
					local Char = player.Character or workspace:FindFirstChild(player.Name)
					local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
					if not Char or not HRP then
						return warn("Failed to find HumanoidRootPart")
					end
					sfx:Play()
					HRP.CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z, select(4, HRP.CFrame:components()))
				end)
			end
		end)
	end
end)

Rey:CreateToggle(Main, "Save Tool", "Simpan tool jika mati, Hidupkan sebelum mengambil Kunai", function(value)
	pcall(function()
		_G.SaveTool = value
		if not _G.SaveTool then
			player.CharacterAdded:Disconnect()
		end
	end)
end)

Rey:CreateToggle(Main, "Save Data", "config nya bakal di simpan", function(value)
local httpService = game:GetService('HttpService')
_G.SaveMinato = value
local Data = {}
local MarksV1 = {}
local Path = "REY HUB/Extension/Minato.json"
	while _G.SaveMinato do wait(0.1)
		pcall(function() Data = httpService:JSONDecode(readfile(Path)) end)
		if not Data["Games"] then Data["Games"] = {} end
		if not Data["Games"][tostring(game.GameId)] then Data["Games"][tostring(game.GameId)] = {} end
		
		for k, v in pairs(marks) do
			if typeof(k) ~= "number" then
				MarksV1[tostring(k)] = tostring(v)
			end
		end
		Data["Games"][tostring(game.GameId)]["Location"] = MarksV1
		
		for _, v in pairs(Rey.Data) do
		local check = pcall(function() data = Data["Games"][tostring(game.GameId)][_] end)
			if type(v) ~= "function" then
				Data["Games"][tostring(game.GameId)][_] = v
			end
		end
		
		local Encode = httpService:JSONEncode(Data)
		writefile(Path, tostring(Encode))
	end
	
	while not _G.SaveMinato do wait(0.1)
		Data = httpService:JSONDecode(readfile(Path))
		Data["Games"][tostring(game.GameId)] = nil
		local Encode = httpService:JSONEncode(Data)
		writefile(Path, tostring(Encode))
	end
end)

Rey:CreateNote(Main, "PERINGATAN,\nJika Save Data dimatikan dan keluar Game maka data sebelumnya akan terhapus.\n\nuntuk sementara biarkan sj dlu kaya gini, aing malas cok😹")
