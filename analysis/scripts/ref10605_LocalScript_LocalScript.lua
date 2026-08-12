local IDBox = script.Parent
local Remote = game.ReplicatedStorage:WaitForChild("ChangeVideo")

IDBox.FocusLost:Connect(function()
	local id = IDBox.Text:match("%d+")

	if id then
		print("Sending video:", id)
		Remote:FireServer(id)
	end
end)