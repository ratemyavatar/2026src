-- // verified + custom chat tags
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

-- Custom per-user chat tags, keyed by UserId. These override the plain
-- verified icon for that user. TagColor is the text colour of the tag in
-- chat; NameColor recolours the player's name to match (same trick the
-- staff chat tags in the Server script use).
local THUG_GOLD = Color3.fromRGB(255, 200, 0) -- yellow-gold

-- ======================================================================
-- HEAD ADMIN: paste the head admin's Roblox UserId into the line below.
-- ======================================================================
local HEAD_ADMIN_USER_ID = 0 -- TODO: replace 0 with the head admin's UserId

local customChatTags = {
	[49603] = { -- thugshaker
		TagText = "[Thug] ",
		TagColor = THUG_GOLD,
	},
	[HEAD_ADMIN_USER_ID] = { -- head admin
		TagText = "[Head Admin] ",
		TagColor = Color3.fromRGB(255, 215, 0),
	},
}

local ChatServiceRef = nil

local function ApplyChatTag(player)
	if not ChatServiceRef then
		return
	end

	pcall(function()
		local speaker = ChatServiceRef:GetSpeaker(player.Name)
		if not speaker then
			return
		end

		local custom = customChatTags[player.UserId]

		if custom then
			speaker:SetExtraData("Tags", {
				{ TagText = custom.TagText, TagColor = custom.TagColor },
			})
			speaker:SetExtraData("NameColor", custom.TagColor)
			return
		end

		if verifiedUsers[player.Name] then
			speaker:SetExtraData("Tags", {
				{ TagText = VERIFIED_ICON },
			})
		end
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
				ApplyChatTag(p)
			end
		end)

		for _, p in ipairs(Players:GetPlayers()) do
			ApplyChatTag(p)
		end
	end)

	if not ok then
		print("[Verified] Could not set chat tags: " .. tostring(err))
	end
end)
