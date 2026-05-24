local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local UI_NAME = "DeltaESP_NativeAllFunc_Fix"
local safeParent = (gethui and gethui()) or game:GetService("CoreGui")

if safeParent:FindFirstChild(UI_NAME) then safeParent[UI_NAME]:Destroy() end

-- [สร้าง UI เมนูหลัก]
local ScreenGui = Instance.new("ScreenGui", safeParent)
ScreenGui.Name = UI_NAME
ScreenGui.IgnoreGuiInset = true 

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 400)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TopBarCornerFix = Instance.new("Frame", TopBar)
TopBarCornerFix.Size = UDim2.new(1, 0, 0, 8)
TopBarCornerFix.Position = UDim2.new(0, 0, 1, -8)
TopBarCornerFix.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBarCornerFix.BorderSizePixel = 0

-- [✨ แก้ไข: เปลี่ยนชื่อเมนูตรงนี้]
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 250, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "นิวตั้น&ต้นกล้า (Right Ctrl to Hide)"
Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 26, 0, 26); MinBtn.Position = UDim2.new(1, -65, 0.5, -13)
MinBtn.Text = "➖"; MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -33, 0.5, -13)
CloseBtn.Text = "✕"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- [สร้างแถบเมนู (TabBar)]
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local function CreateTabContainer()
    local container = Instance.new("ScrollingFrame", MainFrame)
    container.Size = UDim2.new(1, -20, 1, -95)
    container.Position = UDim2.new(0, 10, 0, 85)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 4
    container.Visible = false
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    return container
end

local Tab_ESP = CreateTabContainer()
local Tab_Combat = CreateTabContainer()
local Tab_Char = CreateTabContainer() 
local Tab_Misc = CreateTabContainer()

local tabs = {}
local function CreateTabButton(name, container, isFirst)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.25, -4, 1, 0) 
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    table.insert(tabs, {Btn = btn, Container = container})
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Container.Visible = false
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end
        container.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 50)}):Play()
    end)
    
    if isFirst then 
        container.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    end
end

CreateTabButton("👁️ ESP", Tab_ESP, true)
CreateTabButton("⚔️ Fight", Tab_Combat, false)
CreateTabButton("🏃‍♂️ Char", Tab_Char, false)
CreateTabButton("⚙️ Misc", Tab_Misc, false)

-- [ฟังก์ชันสร้างปุ่ม Toggle แบบใช้ได้ทั่วไป]
local function CreateGenericToggle(text, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -5, 0, 42); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32); btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function() 
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(25, 25, 32)}):Play()
        if callback then callback(state) end
    end)
end

-- [ฟังก์ชันสร้าง Slider]
local function CreateSlider(text, minVal, maxVal, defaultVal, parent, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -5, 0, 50); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20); label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1; label.Text = text .. " : " .. defaultVal
    label.TextColor3 = Color3.new(1,1,1); label.Font = Enum.Font.Gotham; label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("TextButton", frame)
    sliderBg.Size = UDim2.new(1, -20, 0, 8); sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20); sliderBg.Text = ""
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    local fillPct = (defaultVal - minVal) / (maxVal - minVal)
    sliderFill.Size = UDim2.new(fillPct, 0, 1, 0); sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 4)
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(minVal + (maxVal - minVal) * pos)
        label.Text = text .. " : " .. value
        if callback then callback(value) end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
end

-- ==========================================
-- [✨ เมนูที่ 1: ESP]
-- ==========================================
local ESP_State = { Glow = false, Box = false, Tracers = false, NameTag = false, Health = false, Color = Color3.fromRGB(255, 0, 50) }
local function CreateESPToggle(text, key)
    CreateGenericToggle(text, Tab_ESP, function(state) ESP_State[key] = state end)
end
CreateESPToggle("⭕ Glow ESP", "Glow"); CreateESPToggle("📦 Box ESP", "Box"); CreateESPToggle("📐 Tracers", "Tracers")
CreateESPToggle("🏷️ Name Tag", "NameTag"); CreateESPToggle("💚 Health Bar", "Health")

-- ==========================================
-- [✨ เมนูที่ 2: Combat]
-- ==========================================
local AimbotBtn = Instance.new("TextButton", Tab_Combat)
AimbotBtn.Size = UDim2.new(1, -5, 0, 50); AimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
AimbotBtn.Text = "🎯 Load Aimbot Script"; AimbotBtn.TextColor3 = Color3.new(1,1,1); AimbotBtn.Font = Enum.Font.GothamBold; AimbotBtn.TextSize = 16
Instance.new("UICorner", AimbotBtn).CornerRadius = UDim.new(0, 6)

AimbotBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile"))() end)
    AimbotBtn.Text = "✅ Loaded!"; AimbotBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    task.wait(1.5)
    AimbotBtn.Text = "🎯 Load Aimbot Script"; AimbotBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)

-- ==========================================
-- [✨ เมนูที่ 3: Character (ตัวละคร)]
-- ==========================================
local CharConfig = { Speed = 16, Jump = 50, Noclip = false, InfJump = false, ClickTP = false }

CreateSlider("🏃‍♂️ Walk Speed", 16, 300, 16, Tab_Char, function(val) CharConfig.Speed = val end)
CreateSlider("🦘 Jump Power", 50, 300, 50, Tab_Char, function(val) CharConfig.Jump = val end)

CreateGenericToggle("🚀 Infinite Jump", Tab_Char, function(state) CharConfig.InfJump = state end)
UserInputService.JumpRequest:Connect(function()
    if CharConfig.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

CreateGenericToggle("👻 Noclip", Tab_Char, function(state) CharConfig.Noclip = state end)

CreateGenericToggle("✨ Click TP (Ctrl + Click)", Tab_Char, function
