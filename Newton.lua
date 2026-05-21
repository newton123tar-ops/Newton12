local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vrrexx/uilibrary/main/Source.lua"))()

local Window = Library:CreateWindow("Monster Farm")

local MainTab = Window:CreateTab("Main")

local autofarm = false

MainTab:CreateToggle("Auto Farm", function(value)
	autofarm = value

	while autofarm do
		task.wait(0.5)

		local player = game.Players.LocalPlayer
		local character = player.Character

		if character and character:FindFirstChild("HumanoidRootPart") then

			local closestMob = nil
			local shortestDistance = math.huge

			for _, mob in pairs(workspace.Mobs:GetChildren()) do
				if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then

					local distance = (
						character.HumanoidRootPart.Position -
						mob.HumanoidRootPart.Position
					).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closestMob = mob
					end
				end
			end

			if closestMob then
				character:MoveTo(
					closestMob.HumanoidRootPart.Position
				)

				closestMob.Humanoid:TakeDamage(10)
			end
		end
	end
end)

MainTab:CreateButton("Warp Spawn", function()
	local player = game.Players.LocalPlayer
	local character = player.Character

	if character then
		character:MoveTo(Vector3.new(0,5,0))
	end
end)
