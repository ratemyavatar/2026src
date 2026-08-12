game.Players.PlayerAdded:Connect(function(plr)
	local leader = Instance.new("Folder",plr)
	leader.Name = "leaderstats"
	local stat = Instance.new("IntValue",leader)
	stat.Name = "Time"
	stat.Value = 0
end)

