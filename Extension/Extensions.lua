--// Extension
local Rey = loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/UI/Rey%20Library%20Rework.lua"))()

Extension = Rey:CreateTab(UI, "Extension+")
Rey:CreateButton(Extension, "Minato", "kilat kuning⚡", "Load", function()
    Rey:Notify("info", "Extension", "Loading Minato...", 2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/Extension/Minato.lua"))()
end)

Rey:CreateButton(Extension, "Lua Playground", "hengker💻", "Load", function()
    Rey:Notify("info", "Extension", "Loading Lua Playground...", 2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RezaKazzel/Script-Roblox/refs/heads/main/Extension/Lua%20Playground.lua"))()
end)
