--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playSongEvent = ReplicatedStorage:WaitForChild("PlaySong") -- Get the PlaySong RemoteEvent

-- Get the button (script.Parent) that the player presses
local button = script.Parent

-- Function to handle the button click
local function onButtonPressed()
	local player = game.Players.LocalPlayer
	if player then
		-- Fire the PlaySong event to the server to play the song
		playSongEvent:FireServer()
	end
end

-- Connect the button press to the function
button.MouseButton1Click:Connect(onButtonPressed)