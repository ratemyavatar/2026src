--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local button = script.Parent
local frame = button.Parent -- Assuming the frame is the parent of the button's parent
local sound = script.Parent.Parent:WaitForChild("Close") -- Path to the sound

-- Function to play the sound and make the frame invisible when the button is clicked
button.MouseButton1Click:Connect(function()
	-- Play the sound
	if sound:IsA("Sound") then
		sound:Play()
	else
		warn("Sound not found or invalid!")
	end

	-- Make the frame invisible
	frame.Visible = false
end)