local tool = script.Parent
local StarterGui = game:GetService("StarterGui")

-- Prevent dropping tools via Backspace
pcall(function()
	StarterGui:SetCore("CanBarberDropTool", false)
end)

-- Helper function to find donogui
local function getDonoGui()
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	return playerGui:FindFirstChild("donogui", true)
end

-- Open GUI when clicking with the tool equipped
tool.Activated:Connect(function()
	local donoGui = getDonoGui()
	if donoGui then
		donoGui.Visible = true
	end
end)

-- Hide GUI automatically if the tool is put away
tool.Unequipped:Connect(function()
	local donoGui = getDonoGui()
	if donoGui then
		donoGui.Visible = false
	end
end)