local Players = game:GetService("Players")

local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")

local TARGET_USER_ID = 18205

local success, description = pcall(function()
	return Players:GetHumanoidDescriptionFromUserId(TARGET_USER_ID)
end)

if success and description then
	humanoid:ApplyDescription(description)
else
	warn("Could not fetch avatar for User ID: " .. tostring(TARGET_USER_ID))
end