-- Bob Auto Farm | Идёт пешком в портал + скрываемый GUI
-- Delta / большинство executor'ов

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local farming = false
local uses = 0
local guiVisible = true

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BobFarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 260, 0, 280)
Main.Position = UDim2.new(0.5, -130, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(60, 60, 75)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 18)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Bob Farm"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -32, 0, 22)
StatusLabel.Position = UDim2.new(0, 16, 0, 58)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Ожидание"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Main

local CounterLabel = Instance.new("TextLabel")
CounterLabel.Size = UDim2.new(1, -32, 0, 22)
CounterLabel.Position = UDim2.new(0, 16, 0, 84)
CounterLabel.BackgroundTransparency = 1
CounterLabel.Text = "Попыток: 0"
CounterLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
CounterLabel.Font = Enum.Font.Gotham
CounterLabel.TextSize = 13
CounterLabel.TextXAlignment = Enum.TextXAlignment.Left
CounterLabel.Parent = Main

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0, 100, 0, 38)
StartBtn.Position = UDim2.new(0.5, -110, 0, 130)
StartBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 100)
StartBtn.Text = "Start"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 15
StartBtn.Parent = Main

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 10)
StartCorner.Parent = StartBtn

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 100, 0, 38)
StopBtn.Position = UDim2.new(0.5, 10, 0, 130)
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
StopBtn.Text = "Stop"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 15
StopBtn.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 10)
StopCorner.Parent = StopBtn

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(1, -24, 0, 55)
Hint.Position = UDim2.new(0, 12, 1, -70)
Hint.BackgroundTransparency = 1
Hint.Text = "Экипируй Replica\nАлт должен быть в арене\n× скрывает GUI (RightCtrl — показать)"
Hint.TextColor3 = Color3.fromRGB(110, 110, 130)
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 12
Hint.TextWrapped = true
Hint.Parent = Main

-- ==================== Логика ====================
local function updateStatus(text)
	StatusLabel.Text = "Статус: " .. text
end

local function pressKey(key)
	VirtualInputManager:SendKeyEvent(true, key, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function getChar()
	return player.Character
end

local function getHRP()
	local char = getChar()
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
	local char = getChar()
	return char and char:FindFirstChildOfClass("Humanoid")
end

-- Координаты красного портала (основные)
local PORTAL_POS = Vector3.new(-8.5, 3.5, 92)

local function walkToPortal()
	local humanoid = getHumanoid()
	local hrp = getHRP()
	if not humanoid or not hrp then return false end

	updateStatus("Иду в портал...")

	-- Идём пешком к порталу
	humanoid:MoveTo(PORTAL_POS)

	-- Ждём, пока дойдём (или таймаут)
	local startTime = tick()
	while (hrp.Position - PORTAL_POS).Magnitude > 6 do
		if not farming then return false end
		if tick() - startTime > 12 then
			-- Если долго не доходит — немного подталкиваем
			humanoid:MoveTo(PORTAL_POS)
			startTime = tick()
		end
		task.wait(0.2)
	end

	task.wait(0.4)
	return true
end

local function resetCharacter()
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.Health = 0
	end
end

local function farmLoop()
	while farming do
		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char:WaitForChild("Humanoid", 8)
		if not humanoid then
			task.wait(1)
			continue
		end

		task.wait(0.8)

		-- Идём пешком в красный портал
		local success = walkToPortal()
		if not success or not farming then break end

		task.wait(0.3)

		-- Используем способность
		pressKey(Enum.KeyCode.E)
		uses += 1
		CounterLabel.Text = "Попыток: " .. uses
		updateStatus("Способность использована")

		task.wait(0.45)

		-- Ресетим
		resetCharacter()
		updateStatus("Ресет...")

		player.CharacterAdded:Wait()
		task.wait(0.9)
	end
end

-- Кнопки
StartBtn.MouseButton1Click:Connect(function()
	if farming then return end
	farming = true
	updateStatus("Фарм запущен")
	task.spawn(farmLoop)
end)

StopBtn.MouseButton1Click:Connect(function()
	farming = false
	updateStatus("Остановлено")
end)

-- × только скрывает GUI
CloseBtn.MouseButton1Click:Connect(function()
	guiVisible = false
	Main.Visible = false
end)

-- RightControl показывает/скрывает GUI
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		guiVisible = not guiVisible
		Main.Visible = guiVisible
	end
end)

-- Перетаскивание GUI
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

TopBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Ховер-эффекты
local function addHover(btn, normal, hover)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normal}):Play()
	end)
end

addHover(StartBtn, Color3.fromRGB(40, 170, 100), Color3.fromRGB(50, 195, 120))
addHover(StopBtn, Color3.fromRGB(180, 55, 55), Color3.fromRGB(210, 70, 70))
addHover(CloseBtn, Color3.fromRGB(45, 45, 55), Color3.fromRGB(70, 70, 85))

print("Bob Farm загружен | RightCtrl — показать/скрыть GUI")
