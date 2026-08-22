getgenv().MacarellaLoaded = getgenv().MacarellaLoaded or false
if getgenv().MacarellaLoaded then return end
getgenv().MacarellaLoaded = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG (ГЛОБАЛЬНАЯ БАЗА) =================
local BIN_ID = "6a88bc6cf5f4af5e2932d6e9"
local MASTER_KEY = "$2a$10$7kSv0Sq2.FIE2ch8V4cQuOtm9qgLSMH6tXbhg4GSXMme9xwd5dRwy"

local function GetDatabase()
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://api.jsonbin.io/v3/b/" .. BIN_ID .. "/latest", true, {["X-Master-Key"] = MASTER_KEY}))
    end)
    return success and response.record or {BannedUsers = {}, Devs = {}, Testers = {}}
end

local function UpdateDatabase(data)
    pcall(function()
        HttpService:RequestAsync({
            Url = "https://api.jsonbin.io/v3/b/" .. BIN_ID,
            Method = "PUT",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Master-Key"] = MASTER_KEY
            },
            Body = HttpService:JSONEncode({record = data})
        })
    end)
end

-- 🚨 Ранняя проверка при входе (Глобальный бан-хук)
local currentDb = GetDatabase()
if currentDb.BannedUsers and currentDb.BannedUsers[LocalPlayer.Name] then
    LocalPlayer:Kick("Доступ к Macarella Hub навсегда закрыт разработчиком.")
    return
end

-- Проверка глобальных прав для текущего игрока
local isGlobalDev = (LocalPlayer.Name == "Sashaleush") or (currentDb.Devs and currentDb.Devs[LocalPlayer.Name] == true)
local isGlobalTester = isGlobalDev or (currentDb.Testers and currentDb.Testers[LocalPlayer.Name] == true)

local Rayfield = nil
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Не удалось загрузить Rayfield: " .. tostring(err))
    return
end

local function isDevBypassSaved()
    local success, data = pcall(function()
        if readfile and isfile and isfile("MacarellaHub_v3/ConfigurationSettings.json") then
            local content = readfile("MacarellaHub_v3/ConfigurationSettings.json")
            local decoded = HttpService:JSONDecode(content)
            return decoded.DevKeyBypass
        end
    end)
    return success and data == true
end

local useKeySystem = true
if isGlobalDev and isDevBypassSaved() then
    useKeySystem = false
end

local Window = Rayfield:CreateWindow({
    Name = "Macarella Hub | Slap Battles", 
    LoadingTitle = "Загрузка...", 
    LoadingSubtitle = "by макарон | Universal", 
    ConfigurationSaving = { 
        Enabled = true, 
        FolderName = "MacarellaHub_v3",
        FileName = "ConfigurationSettings"
    },
    KeySystem = useKeySystem,
    KeySettings = {
        Title = "Macarella Hub | Ключ",
        Subtitle = "Требуется ключ доступа",
        Note = "",
        FileName = "MacarellaKey_Fresh", 
        SaveKey = false, 
        GrabKeyFromSite = false, 
        Key = {"sashagey6767"},
        WrongKeyCallback = function()
            LocalPlayer:Kick("\nахахахаз ключ не правильный лузер")
        end
    }
})

local VirtualUser = game:GetService("VirtualUser")
local AntiAfkEnabled = false

LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local BackgroundMusic = Instance.new("Sound")
BackgroundMusic.Name = "MacarellaMusic"
BackgroundMusic.SoundId = "rbxassetid://85741102771968"
BackgroundMusic.Volume = 0.5
BackgroundMusic.Looped = true
BackgroundMusic.Parent = game:GetService("SoundService")

local CombatTab = Window:CreateTab("Combat", 4483362458)
_G.HitboxEnabled = false
_G.HitboxSize = 5
_G.HitboxTransparency = 0.5
_G.AntiKnockbackEnabled = false

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.HitboxEnabled then
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                        root.CanCollide = false
                        root.Velocity = Vector3.new(0, 0, 0)
                        root.Transparency = _G.HitboxTransparency
                        root.Color = (_G.HitboxTransparency >= 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end)
    end
    
    if _G.AntiKnockbackEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local root = LocalPlayer.Character.HumanoidRootPart
            if hum and hum.PlatformStand then
                root.Velocity = Vector3.new(0, 0, 0)
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                root.CFrame = root.CFrame
            end
        end
    end
end)

CombatTab:CreateToggle({Name = "Включить Hitbox", CurrentValue = false, Callback = function(Value) _G.HitboxEnabled = Value end})
CombatTab:CreateSlider({Name = "Размер хитбокса", Range = {1, 20}, CurrentValue = 5, Increment = 1, Callback = function(Value) _G.HitboxSize = Value end})
CombatTab:CreateSlider({Name = "Прозрачность хитбокса", Range = {0, 1}, CurrentValue = 0.5, Increment = 0.1, Callback = function(Value) _G.HitboxTransparency = Value end})
CombatTab:CreateToggle({Name = "Anti-Knockback (Ragdoll Freeze)", CurrentValue = false, Callback = function(Value) _G.AntiKnockbackEnabled = Value end})

local AntiTab = Window:CreateTab("Anti", 4483362458)
_G.AntiBusEnabled = false

game:GetService("RunService").Stepped:Connect(function()
    if _G.AntiBusEnabled then
        pcall(function()
            if LocalPlayer.Character then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("bus") or obj.Name:lower():find("автобус")) then
                        obj.CanCollide = false
                    end
                end
            end
        end)
    end
end)

AntiTab:CreateToggle({
    Name = "Anti-Bus (Отключить сбив автобусом)", 
    CurrentValue = false, 
    Callback = function(Value) 
        _G.AntiBusEnabled = Value 
    end
})

local EspTab = Window:CreateTab("ESP", 4483362458)
_G.EspEnabled = false
_G.EspFillColor = Color3.fromRGB(255, 0, 0)
_G.EspOutlineColor = Color3.fromRGB(255, 255, 255)

local function applyHighlight(character)
    if not character:FindFirstChild("MacarellaHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "MacarellaHighlight"
        highlight.Adornee = character
        highlight.Parent = character
        highlight.FillColor = _G.EspFillColor
        highlight.OutlineColor = _G.EspOutlineColor
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Enabled = _G.EspEnabled
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        applyHighlight(char)
    end)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then applyHighlight(player.Character) end
        player.CharacterAdded:Connect(function(char) task.wait(1) applyHighlight(char) end)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hl = player.Character:FindFirstChild("MacarellaHighlight")
            if hl then
                hl.Enabled = _G.EspEnabled
                hl.FillColor = _G.EspFillColor
                hl.OutlineColor = _G.EspOutlineColor
            end
        end
    end
end)

EspTab:CreateToggle({Name = "Включить ESP (Обводка)", CurrentValue = false, Callback = function(Value) _G.EspEnabled = Value end})

local PlayerTab = Window:CreateTab("Player", 4483362458)
local NoclipEnabled = false
local ShowPosEnabled = false
local PosGui = nil

game:GetService("RunService").RenderStepped:Connect(function()
    if NoclipEnabled then
        if LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
    end
    if ShowPosEnabled and PosGui then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            PosGui.Text = string.format("X: %d | Y: %d | Z: %d", math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
        end
    end
end)

PlayerTab:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(Value) AntiAfkEnabled = Value end})
PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(Value) NoclipEnabled = Value end})
PlayerTab:CreateToggle({
    Name = "Показать позицию", 
    CurrentValue = false, 
    Callback = function(Value)
        ShowPosEnabled = Value
        if Value then
            if not PosGui then
                local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
                PosGui = Instance.new("TextLabel", ScreenGui)
                PosGui.Size = UDim2.new(0, 240, 0, 36)
                PosGui.Position = UDim2.new(1, -255, 0, 15)
                PosGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                PosGui.BackgroundTransparency = 0.35
                PosGui.TextColor3 = Color3.fromRGB(240, 240, 240)
                PosGui.Font = Enum.Font.GothamSemibold
                PosGui.TextSize = 14
                PosGui.TextXAlignment = Enum.TextXAlignment.Center
                Instance.new("UICorner", PosGui).CornerRadius = UDim.new(0, 8)
                local stroke = Instance.new("UIStroke", PosGui)
                stroke.Color = Color3.fromRGB(60, 60, 60)
                stroke.Thickness = 1
            end
            PosGui.Parent.Enabled = true
        else
            if PosGui then PosGui.Parent.Enabled = false end
        end
    end
})
PlayerTab:CreateButton({Name = "Sit (Сесть)", Callback = function() if LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true end end})
PlayerTab:CreateButton({
    Name = "Лежать (Руки по швам)",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animate = char:FindFirstChild("Animate")
            local rightShoulder = char:FindFirstChild("Right Shoulder", true) 
                or (char:FindFirstChild("RightUpperArm") and char.RightUpperArm:FindFirstChild("RightShoulder"))
            if hum then
                if not hum.PlatformStand then
                    hum.PlatformStand = true
                    if animate then animate.Enabled = false end
                    if rightShoulder then
                        rightShoulder.CurrentAngle = 0
                        rightShoulder.DesiredAngle = 0
                        rightShoulder.Transform = CFrame.new()
                    end
                else
                    hum.PlatformStand = false
                    if animate then animate.Enabled = true end
                end
            end
        end)
    end
})

local TeleportTab = Window:CreateTab("Teleports", 4483362458)
TeleportTab:CreateSection("Place Teleports")
TeleportTab:CreateButton({Name = "Teleport to Brazil", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1130, 315, -2) end) end})
TeleportTab:CreateButton({Name = "Teleport to Guide", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(17941, -130, -3559) end) end})

TeleportTab:CreateSection("Island Teleports")
TeleportTab:CreateButton({Name = "Main Arena TP", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9, -5, 13) end) end})
TeleportTab:CreateButton({Name = "Teleport to Moai", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(208, -16, 0) end) end})
TeleportTab:CreateButton({Name = "TP to Cannon", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(260, 34, 194) end) end})
TeleportTab:CreateButton({Name = "TP to Slapple Island", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-398, 49, -17) end) end})
TeleportTab:CreateButton({Name = "TP to Left Island", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3, -5, 198) end) end})
TeleportTab:CreateButton({Name = "TP to Right Island", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9, -5, -196) end) end})
TeleportTab:CreateButton({Name = "TP to Pre-Slapple Island", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-205, -5, -4) end) end})
TeleportTab:CreateButton({Name = "TP to Cloud", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-122, -5, 119) end) end})

TeleportTab:CreateSection("Hiding Teleports")
TeleportTab:CreateButton({Name = "First Tree TP", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-362, 79, 13) end) end})
TeleportTab:CreateButton({Name = "Second Tree TP", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-369, 91, -38) end) end})
TeleportTab:CreateButton({Name = "Third Tree TP", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-423, 108, -24) end) end})
TeleportTab:CreateButton({Name = "Canon Tower 1", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(308, 62, 188) end) end})
TeleportTab:CreateButton({Name = "Canon Tower 2", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(292, 47, 209) end) end})
TeleportTab:CreateButton({Name = "Canon Tower 3", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(278, 47, 225) end) end})
TeleportTab:CreateButton({Name = "Canon Tower 4", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(257, 58, 233) end) end})
TeleportTab:CreateButton({Name = "Canon Tower 5", Callback = function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(229, 53, 206) end) end})

local FarmTab = Window:CreateTab("Farm Gloves", 4483362458)
FarmTab:CreateToggle({
   Name = "Farm Bob (Turbo)",
   CurrentValue = false,
   Callback = function(Value)
      _G.BobFarm = Value
      task.spawn(function()
          while _G.BobFarm do
              task.wait(0.5)
              local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
              if root then
                  if root.Position.Y > 30 then 
                      LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1210, 328, 3))
                  else
                      local rep = game:GetService("ReplicatedStorage")
                      if rep:FindFirstChild("Duplicate") then rep.Duplicate:FireServer() end
                      task.wait(1)
                      LocalPlayer.Character.Humanoid.Health = 0
                  end
              end
          end
      end)
   end
})

local MusicTab = Window:CreateTab("Music", 4483362458)
MusicTab:CreateSection("Audio Player")

MusicTab:CreateToggle({
    Name = "Включить музыку (insanely)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BackgroundMusic:Play()
        else
            BackgroundMusic:Stop()
        end
    end
})

MusicTab:CreateSlider({
    Name = "Громкость музыки",
    Range = {0, 2},
    CurrentValue = 0.5,
    Increment = 0.1,
    Callback = function(Value)
        BackgroundMusic.Volume = Value
    end
})

-- Вкладка Dev tools (Доступна только глобальным разработчикам)
if isGlobalDev then
    local DevToolsTab = Window:CreateTab("Dev tools", 4483362458)
    DevToolsTab:CreateSection("Developer Settings")

    DevToolsTab:CreateToggle({
        Name = "Разработчик: Всегда пропускать ключ",
        CurrentValue = isDevBypassSaved(),
        Callback = function(Value)
            if not isGlobalDev then
                LocalPlayer:Kick("\nнедостаточно прав на использование")
                return
            end
            
            pcall(function()
                if makefolder and not isfolder("MacarellaHub_v3") then
                    makefolder("MacarellaHub_v3")
                end
                if writefile then
                    local data = {DevKeyBypass = Value}
                    writefile("MacarellaHub_v3/ConfigurationSettings.json", HttpService:JSONEncode(data))
                end
            end)
        end
    })

    DevToolsTab:CreateSection("Глобальное управление правами и банами")

    local selectedTarget = ""
    local PlayerDropdown = DevToolsTab:CreateDropdown({
        Name = "Выбрать игрока на сервере",
        Options = {},
        CurrentOption = "",
        Callback = function(Option)
            local rawOption = Option
            selectedTarget = type(rawOption) == "table" and rawOption[1] or tostring(rawOption)
        end,
    })

    local function RefreshServerPlayers()
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            table.insert(names, p.Name)
        end
        PlayerDropdown:Refresh(names, true)
    end

    DevToolsTab:CreateButton({
        Name = "Обновить список игроков",
        Callback = RefreshServerPlayers
    })

    -- Кнопки Банов
    DevToolsTab:CreateButton({
        Name = "🚫 Заблокировать игрока (Бан GUI)",
        Callback = function()
            if selectedTarget == "" then return end
            local db = GetDatabase()
            if not db.BannedUsers then db.BannedUsers = {} end
            db.BannedUsers[selectedTarget] = true
            UpdateDatabase(db)
            Rayfield:Notify({Title = "Macarella Hub", Content = "Игрок " .. selectedTarget .. " заблокирован глобально!", Duration = 3})
        end
    })

    DevToolsTab:CreateButton({
        Name = "✅ Разблокировать игрока (Бан)",
        Callback = function()
            if selectedTarget == "" then return end
            local db = GetDatabase()
            if db.BannedUsers then db.BannedUsers[selectedTarget] = nil end
            UpdateDatabase(db)
            Rayfield:Notify({Title = "Macarella Hub", Content = "Игрок " .. selectedTarget .. " разблокирован от бана!", Duration = 3})
        end
    })

    -- Кнопки управления правами Dev
    DevToolsTab:CreateButton({
        Name = "⭐ Выдать права Dev",
        Callback = function()
            if selectedTarget == "" then return end
            local db = GetDatabase()
            if not db.Devs then db.Devs = {} end
            db.Devs[selectedTarget] = true
            UpdateDatabase(db)
            Rayfield:Notify({Title = "Macarella Hub", Content = "Игроку " .. selectedTarget .. " выданы права Dev!", Duration = 3})
        end
