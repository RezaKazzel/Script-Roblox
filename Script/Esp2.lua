local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESPConnections = {}
local ESPObjects = {}

state = state or nil
function DestroyESP()
    for _, obj in pairs(ESPObjects) do
        if obj.Box then obj.Box:Remove() end
        if obj.Tracer then obj.Tracer:Remove() end
        if obj.Name then obj.Name:Remove() end
    end
    ESPObjects = {}

    for _, conn in pairs(ESPConnections) do
        conn:Disconnect()
    end
    ESPConnections = {}
end

function CreateESP(player)
    if not _G.ESP then return end
    if ESPObjects[player] then return end

    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Box ESP
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false
    box.Visible = false

    -- Tracer ESP
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Visible = false

    -- Nama ESP
    local nameTag = Drawing.new("Text")
    nameTag.Size = 19
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Text = player.DisplayName
    nameTag.Visible = false

    ESPObjects[player] = { Box = box, Tracer = tracer, Name = nameTag, RootPart = rootPart }

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not _G.ESP or not character or not rootPart or not character.Parent then
            box.Visible = false
            tracer.Visible = false
            nameTag.Visible = false
            connection:Disconnect()
            ESPObjects[player] = nil
            return
        end

        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local bottomPos, _ = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

        if onScreen then
            -- Box ESP
            box.Size = Vector2.new(50, 75)  -- Ukuran kotak
            box.Position = Vector2.new(pos.X - 25, pos.Y - 37)
            box.Visible = true

            -- Tracer ESP
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 50)
            tracer.To = Vector2.new(bottomPos.X, bottomPos.Y)
            tracer.Visible = true

            -- Nama ESP
            nameTag.Position = Vector2.new(pos.X, pos.Y - 50)
            nameTag.Visible = true
        else
            box.Visible = false
            tracer.Visible = false
            nameTag.Visible = false
        end
    end)

    table.insert(ESPConnections, connection)
end

function ToggleESP(state)
    _G.ESP = state or _G.ESP or false

    if _G.ESP then
        DestroyESP()
        _G.ESP = false
    else
        _G.ESP = true
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                CreateESP(player)
            end
        end
        table.insert(ESPConnections, Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(1)
                CreateESP(player)
            end)
        end))
    end
end

ToggleESP(state)
