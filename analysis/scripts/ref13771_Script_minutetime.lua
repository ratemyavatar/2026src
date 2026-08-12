amount = 1
timedelay = 60
currencyname = "Time"
while true do
	wait(timedelay)
	for i,v in pairs(game.Players:GetPlayers()) do
		if v:FindFirstChild("leaderstats") and v then
			v.leaderstats[currencyname].Value = v.leaderstats[currencyname].Value + amount
		end
	end
end