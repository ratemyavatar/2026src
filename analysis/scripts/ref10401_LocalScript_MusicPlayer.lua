--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent to listen for the prompt trigger
local promptTriggeredEvent = ReplicatedStorage:WaitForChild("PromptTriggeredEvent")

-- Function to initialize the GUI
local function initializeGUI()
	local frame = playerGui:WaitForChild("MusicPlayer"):WaitForChild("MainFrame") -- The frame to make visible
	frame.Visible = false -- Set initial visibility to false or based on your preference
end

-- Re-initialize the GUI when the player's character respawns
player.CharacterAdded:Connect(function()
	-- Reinitialize the GUI every time the player respawns
	initializeGUI()
end)

-- When the RemoteEvent is fired, make the frame visible
promptTriggeredEvent.OnClientEvent:Connect(function()
	local frame = playerGui:WaitForChild("MusicPlayer"):WaitForChild("MainFrame")
	frame.Visible = true
end)

-- Initial GUI setup when the player first joins
initializeGUI()