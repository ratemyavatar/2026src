--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pauseEvent = ReplicatedStorage:WaitForChild("Pause") -- Get the Pause RemoteEvent

-- Replace `ParentButton` with the actual button object in the GUI
local button = script.Parent

-- Listen for button clicks
button.MouseButton1Click:Connect(function()
	pauseEvent:FireServer() -- Notify the server to toggle the pause state
end)