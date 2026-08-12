--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local increaseVolEvent = ReplicatedStorage:WaitForChild("IncreaseVol")
local clicksound = script.Parent.Sound
local button = script.Parent  -- assuming the script is a child of the button

-- Function to handle button click
local function onButtonPressed()
	-- Fire the IncreaseVol event to the server
	clicksound:Play()
	increaseVolEvent:FireServer()
end

-- Connect the button press to the function
button.MouseButton1Click:Connect(onButtonPressed)