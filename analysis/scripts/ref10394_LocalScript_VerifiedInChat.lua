-- // verified chat tag
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local VERIFIED_ICON = utf8.char(0xE000)

local verifiedUsers = {
	["qzc"] = true,
	["ywinfe"] = true,
	["vxy"] = true,
	["fuz"] = true,
	["Thugshaker"] = true,
}

local ChatServiceRef = nil

local function ApplyVerifiedTag(player)
	if not ChatServiceRef then
		return
	end
	if not verifiedUsers[player.Name] then
		return
	end

	pcall(function()
		local speaker = ChatServiceRef:GetSpeaker(player.Name)
		if not speaker then
			return
		end

		speaker:SetExtraData("Tags", {
			{TagText = VERIFIED_ICON},
		})
	end)
end

spawn(function()
	local runner = ServerScriptService:WaitForChild("ChatServiceRunner", 60)

	if not runner then
		print("[Verified] Default chat not found, the verified icon will not show in chat.")
		return
	end

	local ok, err = pcall(function()
		ChatServiceRef = require(runner:WaitForChild("ChatService"))
		ChatServiceRef.SpeakerAdded:Connect(function(name)
			local p = Players:FindFirstChild(name)
			if p then
				ApplyVerifiedTag(p)
			end
		end)

		for _, p in ipairs(Players:GetPlayers()) do
			ApplyVerifiedTag(p)
		end
	end)

	if not ok then
		print("[Verified] Could not set chat tags: " .. tostring(err))
	end
end)