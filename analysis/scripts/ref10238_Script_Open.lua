-- Assuming the ProximityPrompt is inside a part
local prompt = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent to communicate with the client
local promptTriggeredEvent = Instance.new("RemoteEvent")
promptTriggeredEvent.Name = "PromptTriggeredEvent"
promptTriggeredEvent.Parent = ReplicatedStorage

-- When the ProximityPrompt is triggered
prompt.Triggered:Connect(function(player)
	-- Fire the event to the client to make the frame visible
	promptTriggeredEvent:FireClient(player)
end)