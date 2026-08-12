local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Reference to the Part containing the ClickDetector
-- REPLACE 'workspace.PartName' WITH THE ACTUAL PATH TO YOUR PART
local targetPart = workspace:WaitForChild("clickgo")
local clickDetector = targetPart:WaitForChild("ClickDetector")

-- Reference to the TV Changer Frame/GUI
local tvChangerGui = script.Parent -- If the script is inside the ScreenGui or Frame
-- If your ScreenGui is named tvchanger and in StarterGui/PlayerGui:
-- local playerGui = localPlayer:WaitForChild("PlayerGui")
-- local tvChangerGui = playerGui:WaitForChild("tvchanger")

local function onPartClicked(playerWhoClicked)
	-- Verify that the player who clicked is the local player
	if playerWhoClicked == localPlayer then
		-- Toggle visibility or force it to true
		tvChangerGui.Enabled = true
	end
end

-- Connect the click event
clickDetector.MouseClick:Connect(onPartClicked)