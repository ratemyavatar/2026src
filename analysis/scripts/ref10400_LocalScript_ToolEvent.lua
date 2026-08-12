--[[
	@author TwinPlayzDev_YT
	@credit Previized -> https://www.youtube.com/watch?v=6r3eJ3mDsCw&t=358s
	@since 5/23/2021
	This script fires sword events for players.
--]]

--[ SERVICES ]--

local RS = game:GetService('ReplicatedStorage') -- Replicated

--[ LOCALS ]--

local GotSword = false
TOUCHING = nil
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid
local Areas = workspace.SwordFightZone
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
local RemoteEvent = RS:WaitForChild('ToolEvent')
local WEAPON = game.ReplicatedStorage['ClassicSword'] -- Change this to the name of your weapon that is placed in ReplicatedStorage

--[ FUNCTIONS ]--

HumanoidRootPart.Touched:Connect(function(newPart)
	if newPart:IsDescendantOf(Areas) and newPart.Name == 'Main' and TOUCHING == nil then
		TOUCHING = newPart
		if GotSword == false then
			local item = RS:WaitForChild(WEAPON.Name)
			if item then
				RemoteEvent:FireServer('steppedOn',item)
			end
			GotSword = true
		end
	end
end)

HumanoidRootPart.TouchEnded:Connect(function(newPart)
	for _, part in pairs(HumanoidRootPart:GetTouchingParts()) do
		if part == TOUCHING and newPart.Name == 'Main' then return end
	end
	local item = Character:FindFirstChild(WEAPON.Name)
	local item2 = Player.Backpack:FindFirstChild(WEAPON.Name)
	if item or item2 then
		RemoteEvent:FireServer('steppedOff',item or item2)
	end
	TOUCHING = nil
	GotSword = false
end)