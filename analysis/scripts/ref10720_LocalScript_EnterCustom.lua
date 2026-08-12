--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]













-- Main Code be careful!
local button = script.Parent -- Reference to the button
local textbox = script.Parent.Parent.Main.TextBox -- Reference to the TextBox
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local soundPlayEvent = ReplicatedStorage:WaitForChild("SoundPlayEvent") -- Get the RemoteEvent

-- Function to handle button clicks
local function onButtonClick()
	local soundId = textbox.Text -- Get the text from the TextBox
	if soundId ~= "" then -- Ensure the TextBox isn't empty
		soundPlayEvent:FireServer(soundId) -- Send the sound ID to the server
	else
		warn("TextBox is empty. Please enter a valid Sound ID.")
	end
end

-- Connect the button click to the function
button.MouseButton1Click:Connect(onButtonClick)