-- Local Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Get the new Preset RemoteEvent
local presetEvent = ReplicatedStorage:WaitForChild("Preset")

-- The button is the parent of the NumberValue
local songID = script.Parent.Parent:WaitForChild("SongID").Value

-- Function to trigger the Preset event on the server
local function triggerPreset()
	presetEvent:FireServer(songID)
end

-- Connect the button click to the function
script.Parent.MouseButton1Click:Connect(triggerPreset)