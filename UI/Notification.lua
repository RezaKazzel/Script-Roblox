local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local MaxStack = 4
local NotifScale = 0.9
local FixedWidth = 280

shared.NotifActive = shared.NotifActive or {}
shared.NotifQueue = shared.NotifQueue or {}

if not shared.NotifGui then
	local gui = Instance.new("ScreenGui")
	gui.Name = "NotifGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = PlayerGui
	shared.NotifGui = gui
end
local gui = shared.NotifGui

local Colors = {
	error = Color3.fromRGB(255, 65, 65),
	warning = Color3.fromRGB(255, 200, 55),
	success = Color3.fromRGB(60, 220, 120),
	info = Color3.fromRGB(120, 180, 255),
	normal = Color3.fromRGB(40, 40, 40)
}

local function ApplyIcon(icon, theme)
	if theme == "error" then
		icon.Image = "rbxassetid://6031071053"
	elseif theme == "warning" then
		icon.Image = "rbxassetid://6031071050"
		icon.Position = UDim2.new(0, 5 * NotifScale, 0, 5 * NotifScale)
		icon.Size = UDim2.new(0, 55 * NotifScale, 0, 55 * NotifScale)
	elseif theme == "success" then
		icon.Image = "rbxassetid://17829956110"
	elseif theme == "info" then
		icon.Image = "rbxassetid://6031075931"
	else
		icon.Image = ""
	end
end

local Colors = {
	error = Color3.fromRGB(255, 65, 65),
	warning = Color3.fromRGB(255, 200, 55),
	success = Color3.fromRGB(60, 220, 120),
	info = Color3.fromRGB(120, 180, 255),
	normal = Color3.fromRGB(40, 40, 40)
}

local function ApplyIcon(icon, theme)
    local themeColor = Colors[theme] or Colors.normal
    icon.ImageColor3 = themeColor

	if theme == "error" then
		icon.Image = "rbxassetid://6031071053"
        icon.ImageColor3 = Colors.error
	elseif theme == "warning" then
		icon.Image = "rbxassetid://6031071050"
		icon.Position = UDim2.new(0, 5 * NotifScale, 0, 5 * NotifScale)
		icon.Size = UDim2.new(0, 55 * NotifScale, 0, 55 * NotifScale)
        icon.ImageColor3 = Colors.warning
	elseif theme == "success" then
		icon.Image = "rbxassetid://17829956110"
        icon.ImageColor3 = Colors.success
	elseif theme == "info" then
		icon.Image = "rbxassetid://6031075931"
        icon.ImageColor3 = Colors.info
	else
		icon.Image = ""
	end
end


local function Reposition()
	local accumulatedHeight = 0
	
	for i = #shared.NotifActive, 1, -1 do
		local data = shared.NotifActive[i]
		if data.Frame and data.Frame.Parent then
			local frameHeight = data.Frame.Size.Y.Offset
			
			local targetYOffset = -(50 * NotifScale + accumulatedHeight)
			
			TweenService:Create(data.Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
				Position = UDim2.new(1, -20 * NotifScale, 1, targetYOffset) 
			}):Play()
			
			accumulatedHeight = accumulatedHeight + frameHeight + (10 * NotifScale)
		end
	end
end

local function SpawnNextFromQueue()
	if #shared.NotifQueue > 0 and #shared.NotifActive < MaxStack then
		local q = table.remove(shared.NotifQueue, 1)
		Notif(q.theme, q.title, q.desc, q.time)
	end
end

function Notif(theme, titleText, descText, duration)
	theme = theme:lower()
	duration = duration or 3

	if #shared.NotifActive >= MaxStack then
		table.insert(shared.NotifQueue, {
			theme = theme,
			title = titleText,
			desc = descText,
			time = duration
		})
		return
	end

	local fontTitle = Enum.Font.GothamBold
	local fontDesc = Enum.Font.Gotham
	local textSizeTitle = 16 * NotifScale
	local textSizeDesc = 13 * NotifScale
	
	local textXOffset = (theme == "normal" and 15 or 65) * NotifScale
	local availableWidth = (FixedWidth * NotifScale) - textXOffset - (10 * NotifScale)
	
	local titleSize = TextService:GetTextSize(titleText, textSizeTitle, fontTitle, Vector2.new(availableWidth, 9999))
	local titleHeight = math.max(22 * NotifScale, titleSize.Y) 
	
	local descSize = TextService:GetTextSize(descText, textSizeDesc, fontDesc, Vector2.new(availableWidth, 9999))
	local descHeight = math.max(20 * NotifScale, descSize.Y)
	
	local totalFrameHeight = (10 * NotifScale) + titleHeight + (2 * NotifScale) + descHeight + (10 * NotifScale)
	totalFrameHeight = math.max(70 * NotifScale, totalFrameHeight) 
	
	local BaseDark = Color3.fromRGB(20, 20, 20)
	local themeColor = Colors[theme] or BaseDark
	local tintedColor = BaseDark:lerp(themeColor, 0.1) 

	local frame = Instance.new("Frame")
	frame.Name = "NotifFrame"
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Size = UDim2.new(0, FixedWidth * NotifScale, 0, totalFrameHeight)
	frame.Position = UDim2.new(1, FixedWidth * NotifScale + 50, 1, -(50 * NotifScale)) 
	frame.BackgroundColor3 = tintedColor
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Parent = gui

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10 * NotifScale)

	local stroke = Instance.new("UIStroke")
	stroke.Parent = frame
	stroke.Color = Colors[theme] or Colors.normal
	stroke.Thickness = 1.5 * NotifScale
	stroke.Transparency = 1 

	local icon = Instance.new("ImageLabel")
	icon.Parent = frame
	icon.Size = UDim2.new(0, 45 * NotifScale, 0, 45 * NotifScale)
	icon.Position = UDim2.new(0, 10 * NotifScale, 0, 10 * NotifScale) 
	icon.BackgroundTransparency = 1
	icon.ImageTransparency = 1 
	ApplyIcon(icon, theme)

	local title = Instance.new("TextLabel")
	title.Parent = frame
	title.Position = UDim2.new(0, textXOffset, 0, 10 * NotifScale)
	title.Size = UDim2.new(0, availableWidth, 0, titleHeight)
	title.BackgroundTransparency = 1
	title.Font = fontTitle
	title.TextSize = textSizeTitle
	title.TextColor3 = Color3.fromRGB(230, 230, 230)
	title.TextTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.TextWrapped = true
	title.Text = titleText

	local desc = Instance.new("TextLabel")
	desc.Parent = frame
	local descY = (10 * NotifScale) + titleHeight + (2 * NotifScale)
	desc.Position = UDim2.new(0, textXOffset, 0, descY)
	desc.Size = UDim2.new(0, availableWidth, 0, descHeight)
	desc.BackgroundTransparency = 1
	desc.Font = fontDesc
	desc.TextSize = textSizeDesc
	desc.TextColor3 = Color3.fromRGB(200, 200, 200)
	desc.TextTransparency = 1
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top
	desc.TextWrapped = true
	desc.Text = descText

	table.insert(shared.NotifActive, {Frame = frame})
	Reposition()

	TweenService:Create(frame, TweenInfo.new(0.25), {BackgroundTransparency = 0.08}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.2}):Play() 
	
	TweenService:Create(icon, TweenInfo.new(0.25), {ImageTransparency = theme == "normal" and 1 or 0}):Play()
	TweenService:Create(title, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
	TweenService:Create(desc, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

	task.spawn(function()
		task.wait(duration)
		
		if frame and frame.Parent then
			TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, FixedWidth * NotifScale + 50, 1, frame.Position.Y.Offset) 
			}):Play()
			
			TweenService:Create(stroke, TweenInfo.new(0.35), {Transparency = 1}):Play()

			TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
			TweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			TweenService:Create(desc, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		end

		task.wait(0.35) 
		if frame then frame:Destroy() end

		for i, data in ipairs(shared.NotifActive) do
			if data.Frame == frame then
				table.remove(shared.NotifActive, i)
				break
			end
		end

		Reposition()
		SpawnNextFromQueue()
	end)
end
