local part = script.Parent

-- Create and configure the Sound object
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://22593942"
sound.Volume = 2
sound.Parent = part

-- Create a ClickDetector inside the part if one doesn't exist
local clickDetector = part:FindFirstChildOfClass("ClickDetector")
if not clickDetector then
	clickDetector = Instance.new("ClickDetector")
	clickDetector.Parent = part
end

-- Play the sound when clicked
clickDetector.MouseClick:Connect(function(player)
	sound:Play()
end)