--[[

  YouTube.com/@VenexLua
  discord.gg/Venex

]]



-- Main Code be careful!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local decreaseVolEvent = ReplicatedStorage:WaitForChild("DecreaseVol")
local clicksound = script.Parent.Sound
-- Reference to the button that will trigger the volume decrease
local button = script.Parent  -- assuming the script is a child of the button

-- Function to handle button click
local function onButtonPressed()
	-- Fire the DecreaseVol event to the server
	clicksound:Play()
	decreaseVolEvent:FireServer()
end

-- Connect the button press to the function
button.MouseButton1Click:Connect(onButtonPressed)