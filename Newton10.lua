--// Newton Hub | by นิวตั้น
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NewtonHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,250,0,300)
main.Position = UDim2.new(0.05,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.Text = "Newton Hub | นิวตั้น"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,35,0,35)
minimize.Position = UDim2.new(1,-35,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimize.TextColor3 = Color3.new(1,1,1)

local holder = Instance.new("Frame", main)
holder.Size = UDim2.new(1,0,1,-35)
holder.Position = UDim2.new(0,0,0,35)
holder.BackgroundTransparency = 1

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	holder.Visible = not minimized
	main.Size = minimized and UDim2.new(0,250,0,35) or UDim2.new(0,250,0,300)
end)

local function makeButton(text,posY)
	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(0.9,0,0,35)
	b.Position = UDim2.new(0.05,0,0,posY)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 20
	b.Text = text
	return b
end

local flyBtn = makeButton("FLY",10)
local spinBtn = makeButton("SPIN360",55)
local speedBtn = makeButton("SPEED+",100)
local jumpBtn = makeButton("JUMP+",145)
local espBtn = makeButton("ESP BOX",190)

-- Fly
local flying = false
local bv,bg

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	local char = LP.Character
	local hrp = char:WaitForChild("HumanoidRootPart")

	if flying then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)

		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

		RunService.RenderStepped:Connect(function()
			if flying then
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
				bg.CFrame = workspace.CurrentCamera.CFrame
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- Spin
local spinning = false

spinBtn.MouseButton1Click:Connect(function()
	spinning = not spinning
	local hrp = LP.Character:WaitForChild("HumanoidRootPart")

	while spinning do
		hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0)
		task.wait()
	end
end)

-- Speed
local speed = 16
speedBtn.MouseButton1Click:Connect(function()
	speed += 20
	if speed > 200 then speed = 16 end
	LP.Character.Humanoid.WalkSpeed = speed
	speedBtn.Text = "SPEED : "..speed
end)

-- Jump
local jump = 50
jumpBtn.MouseButton1Click:Connect(function()
	jump += 25
	if jump > 250 then jump = 50 end
	LP.Character.Humanoid.JumpPower = jump
	jumpBtn.Text = "JUMP : "..jump
end)

-- ESP BOX
local esp = false
local espObjects = {}

local function createESP(plr)
	if plr == LP then return end
	local box = Drawing.new("Square")
	box.Visible = false
	box.Color = Color3.fromRGB(255,0,0)
	box.Thickness = 2
	box.Filled = false

	RunService.RenderStepped:Connect(function()
		if esp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			local pos,vis = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

			if vis then
				local size = 1000 / pos.Z
				box.Size = Vector2.new(size,size*1.5)
				box.Position = Vector2.new(pos.X-size/2,pos.Y-size/1.5)
				box.Visible = true
			else
				box.Visible = false
			end
		else
			box.Visible = false
		end
	end)

	espObjects[plr] = box
end

for _,v in pairs(Players:GetPlayers()) do
	createESP(v)
end

Players.PlayerAdded:Connect(createESP)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = esp and "ESP : ON" or "ESP : OFF"
end)
