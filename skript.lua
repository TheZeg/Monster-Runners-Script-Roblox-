local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Monster Runners Skript",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "By: TheZeg",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MyScripts",
      FileName = "HubConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "free",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Key System",
      Subtitle = "BuB",
      Note = "TGK: @TzSkripts\nKey: 123",
      FileName = "TzTest",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"123", "345"}
   }
})

-- Создаем вкладки
local MainTab = Window:CreateTab("Main", 4483362458)
local VisualsTab = Window:CreateTab("Visuals/HitBox", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-----------------------------------------------------------
-- ПЕРЕМЕННЫЕ
-----------------------------------------------------------
local ESPEnabled = false
local HitboxEnabled = false
local HitboxSize = 2
local InfJumpEnabled = false

-- Сохраняем стандартное освещение
local NormalFogStart = game.Lighting.FogStart
local NormalFogEnd = game.Lighting.FogEnd
local NormalBrightness = game.Lighting.Brightness
local NormalClockTime = game.Lighting.ClockTime

-----------------------------------------------------------
-- ЕДИНЫЙ ЦИКЛ ОБНОВЛЕНИЯ (ESP И ХИТБОКСЫ)
-----------------------------------------------------------
task.spawn(function()
    while true do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")

                -- Логика ESP (Обводка)
                if ESPEnabled then
                    local highlight = char:FindFirstChild("ESPHighlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.Parent = char
                    end
                    highlight.Enabled = true
                    highlight.FillColor = (player.Team and player.TeamColor.Color) or Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                else
                    if char:FindFirstChild("ESPHighlight") then
                        char.ESPHighlight.Enabled = false
                    end
                end

                -- Логика Хитбоксов
                if HitboxEnabled and root then
                    root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    root.Transparency = 0.7
                    root.CanCollide = false
                elseif not HitboxEnabled and root then
                    if root.Size ~= Vector3.new(2, 2, 1) then
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 1
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Логика Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-----------------------------------------------------------
-- ВКЛАДКА: ГЛАВНАЯ
-----------------------------------------------------------
MainTab:CreateSection("Player")

MainTab:CreateButton({
   Name = "Speed up player",
   Callback = function()
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
   end,
})

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump", 
   Callback = function(Value)
       InfJumpEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 16,
   Flag = "JumpPowerSlider", 
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

MainTab:CreateSection("[[[NEW]]]")

MainTab:CreateButton({
   Name = "Get Crown",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           local originalPos = char.HumanoidRootPart.CFrame
           char:PivotTo(CFrame.new(-166, 6, 379))
           
           Rayfield:Notify({Title = "Getting", Content = "Wait 3 sec...", Duration = 1})
           task.wait(3) 
           
           char:PivotTo(originalPos)
           Rayfield:Notify({Title = "Yay!", Content = "U got crown", Duration = 3})
       end
   end,
})

MainTab:CreateButton({
   Name = "Teleport to end [Beta]",
   Callback = function()
       local targetModel = game.Workspace:FindFirstChild("EndRoom", true) 
       if targetModel then
           game.Players.LocalPlayer.Character:PivotTo(targetModel:GetPivot() * CFrame.new(0, 5, -7))
       else
           Rayfield:Notify({Title = "Uh", Content = "Wait new round", Duration = 3})
       end
   end,
})

MainTab:CreateButton({
   Name = "Delete start door",
   Callback = function()
       local count = 0
       for _, obj in pairs(game.Workspace:GetDescendants()) do
           if obj.Name == "MechanicalDoors" then
               obj:Destroy()
               count = count + 1
           end
       end
       Rayfield:Notify({Title = "Deliting", Content = "Delited =  " .. tostring(count), Duration = 3})
   end,
})

-----------------------------------------------------------
-- ВКЛАДКА: ВИЗУАЛЫ
-----------------------------------------------------------
VisualsTab:CreateSection("Players")

VisualsTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "TeamESP",
   Callback = function(Value)
       ESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "HitBox",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
       HitboxEnabled = Value
   end,
})

VisualsTab:CreateSlider({
   Name = "HitBox size",
   Range = {2, 20},
   Increment = 1,
   CurrentValue = 2,
   Flag = "HitboxSlider",
   Callback = function(Value)
       HitboxSize = Value
   end,
})

VisualsTab:CreateSection("Environment")

VisualsTab:CreateToggle({
   Name = "No Fog",
   CurrentValue = false,
   Flag = "NoFog_Toggle",
   Callback = function(Value)
       game.Lighting.FogEnd = Value and 100000 or NormalFogEnd
       game.Lighting.FogStart = Value and 100000 or NormalFogStart
   end,
})

VisualsTab:CreateToggle({
   Name = "FullBright",
   CurrentValue = false,
   Flag = "FullBright_Toggle",
   Callback = function(Value)
       if Value then
           game.Lighting.Brightness = 2
           game.Lighting.ClockTime = 14
           game.Lighting.GlobalShadows = false
           game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
       else
           game.Lighting.Brightness = NormalBrightness
           game.Lighting.ClockTime = NormalClockTime
           game.Lighting.GlobalShadows = true
           game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
       end
   end,
})

-----------------------------------------------------------
-- ВКЛАДКА: НАСТРОЙКИ
-----------------------------------------------------------
SettingsTab:CreateSection("Gui")

SettingsTab:CreateButton({
   Name = "Destroy Gui",
   Callback = function()
       Rayfield:Destroy()
   end,
})

SettingsTab:CreateSection("About Script")

SettingsTab:CreateParagraph({
    Title = "Monster Runners Skript", 
    Content = "Created by: TheZeg\nVersion: 1.2 [Beta]\nTgk: @TzSkripts"
})

Rayfield:Notify({
   Title = "Yay",
   Content = "Script loaded successfully!",
   Duration = 5,
   Image = 4483362458,
})
