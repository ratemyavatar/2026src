local Remote = game.ReplicatedStorage:WaitForChild("ChangeVideo")

local Video = workspace:WaitForChild("tv")
:WaitForChild("SurfaceGui")
:WaitForChild("Videochanger")

Remote.OnServerEvent:Connect(function(player, id)
	print(player.Name, "changed video to", id)

	Video:Pause()
	Video.Video = "rbxassetid://" .. id
	Video.TimePosition = 0
	Video:Play()
end)