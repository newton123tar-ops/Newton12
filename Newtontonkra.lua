--// Newton Hub | ผู้สร้าง: นิวตั้น & ต้นกล้า

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Newton Hub",
        Text = "ผู้สร้าง: นิวตั้น และ ต้นกล้า",
        Duration = 5
    })
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NewtonHub"
gui.Parent = game.CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "Newton Hub | นิวตั้น & ต้นกล้า"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-10,1,-45)
scroll.Position = UDim2.new(0,5,0,40)
scroll.CanvasSize = UDim2.new(0,0,0,800)
scroll.ScrollBarThickness = 5
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)

-- ย่อ UI
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,3)
minimize.Text = "-"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)

local hidden = false
minimize.MouseButton1Click:Connect(function()
    hidden = not hidden
    scroll.Visible = not hidden
    main.Size = hidden and UDim2.new(0,320,0,40) or UDim2.new(0,320,0,420)
end)

-- ปุ่มสร้าง
function makeButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-5,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = text
    btn.Parent = scroll
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,8)
    
    return btn
end

-- Fly
local fly = false
local flyBtn = makeButton("บิน")

flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    
    if fly then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyForce"
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = LP.Character.HumanoidRootPart
        
        RunService.RenderStepped:Connect(function()
            if fly and bv then
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80
            end
        end)
    else
        if LP.Character.HumanoidRootPart:FindFirstChild("FlyForce") then
            LP.Character.HumanoidRootPart.FlyForce:Destroy()
        end
    end
end)

-- Speed
local speedBtn = makeButton("วิ่งไว")
speedBtn.MouseButton1Click:Connect(function()
    LP.Character.Humanoid.WalkSpeed = 100
end)

-- Jump
local jumpBtn = makeButton("กระโดดสูง")
jumpBtn.MouseButton1Click:Connect(function()
    LP.Character.Humanoid.JumpPower = 150
end)

-- Infinite Jump
local infJump = false
local infBtn = makeButton("Infinite Jump")

infBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
end)

UIS.JumpRequest:Connect(function()
    if infJump then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Spin 360
local spin = false
local spinBtn = makeButton("Spin 360")

spinBtn.MouseButton1Click:Connect(function()
    spin = not spin
end)

RunService.RenderStepped:Connect(function()
    if spin then
        LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(15), 0)
    end
end)

-- ESP
local espBtn = makeButton("ESP Box / Name")

espBtn.MouseButton1Click:Connect(function()
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            if not v.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", v.Character)
                h.FillTransparency = 1
                h.OutlineColor = Color3.new(1,0,0)
                
                local bill = Instance.new("BillboardGui", v.Character.Head)
                bill.Size = UDim2.new(0,100,0,40)
                bill.AlwaysOnTop = true
                
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = v.Name
                txt.TextColor3 = Color3.new(1,1,1)
                txt.TextScaled = true
            end
        end
    end
end)

-- เปลี่ยนสี UI
local colorBtn = makeButton("เปลี่ยนสี UI")

colorBtn.MouseButton1Click:Connect(function()
    main.BackgroundColor3 = Color3.fromRGB(
        math.random(0,255),
        math.random(0,255),
        math.random(0,255)
    )
end)

-- วาร์ปหาผู้เล่น
local tpBox = Instance.new("TextBox", scroll)
tpBox.Size = UDim2.new(1,-5,0,40)
tpBox.PlaceholderText = "ใส่ชื่อผู้เล่นเพื่อวาร์ป"
tpBox.Text = ""
tpBox.TextScaled = true
tpBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
tpBox.TextColor3 = Color3.new(1,1,1)

local tpBtn = makeButton("วาร์ปไปหา")

tpBtn.MouseButton1Click:Connect(function()
    for _,v in pairs(Players:GetPlayers()) do
        if string.lower(v.Name):find(string.lower(tpBox.Text)) then
            LP.Character.HumanoidRootPart.CFrame =
                v.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
end)

-- เตะผู้เล่น (เฉพาะฝั่งเรา)
local kickBox = Instance.new("TextBox", scroll)
kickBox.Size = UDim2.new(1,-5,0,40)
kickBox.PlaceholderText = "ใส่ชื่อผู้เล่น"
kickBox.Text = ""
kickBox.TextScaled = true
kickBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
kickBox.TextColor3 = Color3.new(1,1,1)

local kickBtn = makeButton("เตะผู้เล่น")

kickBtn.MouseButton1Click:Connect(function()
    for _,v in pairs(Players:GetPlayers()) do
        if string.lower(v.Name):find(string.lower(kickBox.Text)) then
            v:Kick("โดนเตะโดย Newton Hub")
        end
    end
end)

-- เสกของ
local spawnBtn = makeButton("เสก Part")

spawnBtn.MouseButton1Click:Connect(function()
    local p = Instance.new("Part")
    p.Size = Vector3.new(5,5,5)
    p.Position = LP.Character.HumanoidRootPart.Position + Vector3.new(0,10,0)
    p.Anchored = false
    p.Parent = workspace
end)
