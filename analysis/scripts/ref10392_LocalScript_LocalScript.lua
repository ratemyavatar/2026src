local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvent = ReplicatedStorage:FindFirstChild("AFKRemoteEvent")

if not RemoteEvent then
	RemoteEvent = Instance.new("RemoteEvent")
	RemoteEvent.Name = "AFKRemoteEvent"
	RemoteEvent.Parent = ReplicatedStorage
end

local AFKPlayers = {}
local LastRequest = {}

local function RemoveAFKLabel(Character)
	if not Character then
		return
	end

	local Head = Character:FindFirstChild("Head")
	if not Head then
		return
	end

	local OldLabel = Head:FindFirstChild("AFKLabel")
	if OldLabel then
		OldLabel:Destroy()
	end
end

local function AddAFKLabel(Character)
	if not Character then
		return
	end

	local Head = Character:FindFirstChild("Head")
	if not Head then
		return
	end

	-- Prevent duplicate labels.
	RemoveAFKLabel(Character)

	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Name = "AFKLabel"
	BillboardGui.Adornee = Head
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Size = UDim2.new(0, 120, 0, 35)
	BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
	BillboardGui.Parent = Head

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "TextLabel"
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.Text = "[AFK]"
	TextLabel.TextColor3 = Color3.fromRGB(255, 220, 70)
	TextLabel.TextScaled = true
	TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.TextStrokeTransparency = 0
	TextLabel.Parent = BillboardGui
end

local function SetPlayerAFK(Player, IsAFK)
	AFKPlayers[Player] = IsAFK

	if IsAFK then
		AddAFKLabel(Player.Character)
	else
		RemoveAFKLabel(Player.Character)
	end
end

local function PlayerAdded(Player)
	AFKPlayers[Player] = false

	Player.CharacterAdded:Connect(function(Character)
		-- Wait for the head without using newer task functions.
		Character:WaitForChild("Head", 10)

		-- Re-add the label if the player respawned while tabbed out.
		if AFKPlayers[Player] then
			AddAFKLabel(Character)
		end
	end)
end

RemoteEvent.OnServerEvent:Connect(function(Player, IsAFK)
	-- Reject unexpected data.
	if type(IsAFK) ~= "boolean" then
		return
	end

	-- Basic remote-event rate limit.
	local CurrentTime = tick()
	local PreviousTime = LastRequest[Player]

	if PreviousTime and CurrentTime - PreviousTime < 0.25 then
		return
	end

	LastRequest[Player] = CurrentTime
	SetPlayerAFK(Player, IsAFK)
end)

for _, Player in ipairs(Players:GetPlayers()) do
	PlayerAdded(Player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(Player)
	AFKPlayers[Player] = nil
	LastRequest[Player] = nil
end)