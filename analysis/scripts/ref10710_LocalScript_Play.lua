-- Assuming the script is a child of the button and the button is located under `PlayButton`
local playButton = script.Parent.Parent.Parent:WaitForChild("PlayControl")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local soundPlayEvent = ReplicatedStorage:WaitForChild("SoundPlayEvent")
local textBox = script.Parent

-- Function to send the text from the TextBox to the server when the PlayButton is clicked
playButton.MouseButton1Click:Connect(function()
	local soundId = textBox.Text
	if soundId and soundId ~= "" then
		-- Send the sound ID to the server to play the sound
		soundPlayEvent:FireServer(soundId)
	end
end)

-- Optionally, you can also send the sound ID when the player presses enter in the text box
textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local soundId = textBox.Text
		if soundId and soundId ~= "" then
			soundPlayEvent:FireServer(soundId)
		end
	end
end)
