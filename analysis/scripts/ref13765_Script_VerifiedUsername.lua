local Players = game:GetService("Players")

local VERIFIED_ICON = utf8.char(0xE000)

Players.PlayerAdded:Connect(function(player)

	if player.Name == "vxy" then -- Change this to your username

		player.CharacterAdded:Connect(function(character)

			local humanoid = character:WaitForChild("Humanoid")

			humanoid.DisplayName = player.DisplayName.. VERIFIED_ICON
		end)
	end
	
	if player.Name == "Thugshaker" then -- Change this to another username

		player.CharacterAdded:Connect(function(character)

			local humanoid = character:WaitForChild("Humanoid")

			humanoid.DisplayName = player.DisplayName .. VERIFIED_ICON
		end)
	end
	
	if player.Name == "qzc" then -- Change this to another username

		player.CharacterAdded:Connect(function(character)

			local humanoid = character:WaitForChild("Humanoid")

			humanoid.DisplayName = player.DisplayName .. VERIFIED_ICON
		end)
	end

	if player.Name == "ywinfe" then -- Change this to another username

		player.CharacterAdded:Connect(function(character)

			local humanoid = character:WaitForChild("Humanoid")

			humanoid.DisplayName = player.DisplayName .. VERIFIED_ICON
		end)
	end
	
	if player.Name == "fuz" then

		player.CharacterAdded:Connect(function(character)

			local humanoid = character:WaitForChild("Humanoid")

			humanoid.DisplayName = player.DisplayName .. VERIFIED_ICON
		end)
	end
end)