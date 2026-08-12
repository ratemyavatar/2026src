-- // handler by matt and fuz
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local TagConfig = require(ReplicatedStorage:WaitForChild("TagConfig"))
local baseOverhead = ServerStorage:WaitForChild("overhead")
local STAFF_DATASTORE = "StaffList_v2"
local STAFF_REFRESH_SECONDS = 60
local RANK_MOD = 1
local RANK_ADMIN = 2

local StaffStore = nil
local ok, res = pcall(function()
	return DataStoreService:GetDataStore(STAFF_DATASTORE)
end)
if ok then
	StaffStore = res
else
	warn("[TagHandler] Staff DataStore unavailable, mod/admin tags will not auto-give: " .. tostring(res))
end

local StaffRanks = {}

local function LoadStaffRanks()
	if not StaffStore then
		return
	end

	local loadOk, loadRes = pcall(function()
		return StaffStore:GetAsync("staff")
	end)

	if not loadOk then
		warn("[TagHandler] Could not load the staff list: " .. tostring(loadRes))
		return
	end
	if type(loadRes) ~= "table" then
		return
	end

	local fresh = {}
	local key, row
	for key, row in pairs(loadRes) do
		local userId = tonumber(key)
		if userId and type(row) == "table" and type(row.Rank) == "number" then
			fresh[userId] = row.Rank
		end
	end

	StaffRanks = fresh
end

spawn(function()
	while true do
		LoadStaffRanks()
		wait(STAFF_REFRESH_SECONDS)
	end
end)

local function getStaffTag(player)
	local rank = StaffRanks[player.UserId]
	if rank == RANK_ADMIN then
		return "admin"
	elseif rank == RANK_MOD then
		return "mod"
	end
	return nil
end

local function setup(character, player)
	local head = character:WaitForChild("Head")

	local old = head:FindFirstChild("overhead")
	if old then
		old:Destroy()
	end

	local attachment = Instance.new("Attachment")
	attachment.Name = "overhead"
	attachment.CFrame = CFrame.new(0, 1.7, 0)
	attachment.Parent = head

	local overheadClone = baseOverhead:Clone()
	overheadClone.Parent = attachment

	local nameLabel = overheadClone:FindFirstChild("name")

	if nameLabel then
		nameLabel.Text = player.Name
		nameLabel.Font = TagConfig.DefaultFont
		nameLabel.TextColor3 = TagConfig.DefaultColor
	end
end

local function applytag(player, tagName)
	local character = player.Character
	if not character then
		return
	end

	local head = character:FindFirstChild("Head")
	local attachment = head and head:FindFirstChild("overhead")
	local billboard = attachment and attachment:FindFirstChildOfClass("BillboardGui")
	local nameLabel = billboard and billboard:FindFirstChild("name")

	if not nameLabel then
		return
	end

	local config = TagConfig[tagName:lower()]

	if config then
		nameLabel.Text = (config.text or "") .. player.Name
		nameLabel.Font = config.font or TagConfig.DefaultFont
		nameLabel.TextColor3 = config.textColor or TagConfig.DefaultColor

		billboard:SetAttribute("TagType", tagName:lower())
		player:SetAttribute("ActiveTag", tagName:lower())
	else
		billboard:SetAttribute("TagType", "None")

		nameLabel.Text = player.Name
		nameLabel.Font = TagConfig.DefaultFont
		nameLabel.TextColor3 = TagConfig.DefaultColor

		player:SetAttribute("ActiveTag", nil)
	end
end

-- Custom user tags that must win when a player is in several users lists
-- (thugshaker is also in the "owner" list, and pairs() order is random, so
-- without this he could randomly get "[Owner]" instead of "[Thug]").
local PRIORITY_TAGS = { "thug", "headadmin" }

local function getAutoTag(player)
	local staffTag = getStaffTag(player)
	if staffTag then
		return staffTag
	end

	local userId = player.UserId

	local i
	for i = 1, #PRIORITY_TAGS do
		local tagName = PRIORITY_TAGS[i]
		local config = TagConfig[tagName]
		if type(config) == "table" and config.users then
			local users = config.users
			local j
			for j = 1, #users do
				if users[j] == userId then
					return tagName
				end
			end
		end
	end

	local tagName, config
	for tagName, config in pairs(TagConfig) do
		if type(config) == "table" and config.users then
			local users = config.users
			local i
			for i = 1, #users do
				if users[i] == userId then
					return tagName
				end
			end
		end
	end

	return nil
end

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		setup(character, player)

		local activeTag = player:GetAttribute("ActiveTag")

		if not activeTag then
			activeTag = getAutoTag(player)
		end

		if activeTag then
			applytag(player, activeTag)
		end
	end)

	--player.Chatted:Connect(function(message)
	--	local args = string.split(message, " ")

	--	if args[1] == ".tag" and args[2] then
	--		applytag(player, args[2])
	--	end
	--end)
end)
