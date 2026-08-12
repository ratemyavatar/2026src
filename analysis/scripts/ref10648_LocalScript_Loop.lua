--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local button = script.Parent  -- The ImageButton
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local loopedEvent = ReplicatedStorage:WaitForChild("Looped")  -- RemoteEvent in ReplicatedStorage

-- Function to change the button color based on the Looped state
local function updateButtonColor(isLooped)
	if isLooped then
		button.ImageColor3 = Color3.new(0.294118, 1, 0.576471)  -- Green if Looped is true
	else
		button.ImageColor3 = Color3.new(1, 1, 1)  -- Red if Looped is false
	end
end

-- Listen for the Looped state from the server
loopedEvent.OnClientEvent:Connect(function(isLooped)
	updateButtonColor(isLooped)
end)

-- When the button is clicked, fire the Looped event to the server
button.MouseButton1Click:Connect(function()
	loopedEvent:FireServer()  -- Request to toggle looping on the server
end)