local DS = game:GetService("DataStoreService"):GetDataStore("SaveMyData")
game.Players.PlayerAdded:Connect(function(plr)
	wait()
	local plrkey = "id"..plr.UserId
	local savevalue = plr:WaitForChild("leaderstats"):WaitForChild("Time")

	local getsaved = DS:GetAsync(plrkey)
	if getsaved then
		savevalue.Value = getsaved[1]
	else
		local NumbersForSaving = (savevalue.value)
		DS:GetAsync(plrkey, NumbersForSaving)
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	DS:SetAsync("id"..plr.UserId, {plr.leaderstats.Time.Value})
end)