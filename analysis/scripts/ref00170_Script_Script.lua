local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local zone = script.Parent
local swordTemplate = ServerStorage:WaitForChild("SwordTemplate")
local playersInZone = {}
local checkrate = 0.1

local function isPlayerInZone(player)
	local character = player.Character
	if not character then
		return false
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return false
	end

	local relative = zone.CFrame:PointToObjectSpace(root.Position)
	local halfSize = zone.Size / 2

	return math.abs(relative.X) <= halfSize.X
		and math.abs(relative.Y) <= halfSize.Y
		and math.abs(relative.Z) <= halfSize.Z
end

local function removeSword(player)
	local character = player.Character

	if character then
		for _, tool in ipairs(character:GetChildren()) do
			if tool:IsA("Tool") and tool.Name == swordTemplate.Name then
				tool:Destroy()
			end
		end
	end

	for _, tool in ipairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == swordTemplate.Name then
			tool:Destroy()
		end
	end
end

local function ensureSword(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if character:FindFirstChild(swordTemplate.Name)
		or player.Backpack:FindFirstChild(swordTemplate.Name) then
		return
	end

	local sword = swordTemplate:Clone()
	sword.Parent = player.Backpack
	humanoid:EquipTool(sword)
end

spawn(function()
	while true do
		for _, player in ipairs(Players:GetPlayers()) do
			local inside = isPlayerInZone(player)

			if inside then
				playersInZone[player] = true
				ensureSword(player)
			elseif playersInZone[player] then
				playersInZone[player] = nil
				removeSword(player)
			end
		end

		wait(checkrate)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	playersInZone[player] = nil
end)