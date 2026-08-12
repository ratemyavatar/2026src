local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("PromptGroupJoin")
local clickDetector = script.Parent:WaitForChild("ClickDetector")

clickDetector.MouseClick:Connect(function(player)
	remote:FireClient(player)
end)