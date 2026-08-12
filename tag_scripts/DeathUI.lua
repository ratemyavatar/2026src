--[[


	Help inquiries, discord.gg/7GPGfTcvyD


]]


-- Settings
local RespawnText = "Respawning in " -- change the text that is displayed on screen.
local PlayerDeathSoundId = "rbxassetid://875087" -- sound that is played locally (not the UI sound)
local DeathTextLabel = "YOU ded boi" -- text for the DeathIcon's TextLabel

-- Options
local DeathTextColor = Color3.new(1, 1, 1) -- change the color of the deathUI text
local PulseDuration = 0 -- scale duration (set to 0 to disable effect)
local PulseScale = 1.1  -- scale of the pulse effect (set to 1 to disable effect)




-- Main Code, Do not touch unless experienced.
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RespawnTime = Players.RespawnTime
local Blur = game.Lighting.DeathUI
local Background = script.Parent.DeathGUI.Background
local DeathIcon = Background.TextHolder
Blur.Size = 0
Background.Visible = false
DeathIcon.Respawning.Visible = false

--[[
	The sizes/positions saved on the gui in this place are all over the
	place (the TextHolder sits miles off screen), so force a clean layout
	here instead of trusting the saved properties. Everything is anchored
	to the middle of the screen so it stays put on any aspect ratio.
--]]
local function fixLayout()
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundColor3 = Color3.new(0, 0, 0)
	Background.BackgroundTransparency = 0.4

	DeathIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	DeathIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	DeathIcon.Size = UDim2.new(0, 340, 0, 160)
	DeathIcon.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	DeathIcon.BackgroundTransparency = 0.2

	local label = DeathIcon.TextLabel
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 0.1, 0)
	label.Size = UDim2.new(1, -20, 0.55, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold

	local respawn = DeathIcon.Respawning
	respawn.AnchorPoint = Vector2.new(0.5, 1)
	respawn.Position = UDim2.new(0.5, 0, 0.95, 0)
	respawn.Size = UDim2.new(1, -20, 0.25, 0)
	respawn.BackgroundTransparency = 1
	respawn.TextScaled = true
	respawn.Font = Enum.Font.SourceSans
	respawn.TextColor3 = Color3.new(1, 1, 1)
end

fixLayout()

local config = {
	Sounds = {
		game.StarterGui.DeathGUI.Death,
	}
}
local function playDeathMusic()
	config.Sounds[1]:Play()

	local deathSound = Instance.new("Sound")
	deathSound.SoundId = PlayerDeathSoundId
	deathSound.Parent = LocalPlayer.Character.Head
	deathSound.Volume = 0.1
	deathSound.RollOffMaxDistance = 20
	deathSound.PlayOnRemove = true
	deathSound:Destroy()
end
local function stopDeathMusic()
	for _, sound in ipairs(config.Sounds) do
		sound:Stop()
	end
end
local function respawn()
	Blur.Size = 0
	Background.Visible = false
	DeathIcon.Respawning.Text = ""
	DeathIcon.TextLabel.Text = ""
	DeathIcon.Respawning.Visible = false
end
local function pulseEffect()
	local originalSize = DeathIcon.TextLabel.TextSize
	local newSize = originalSize * PulseScale

	local tweenInfo = TweenInfo.new(PulseDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
	local pulseTween = game:GetService("TweenService"):Create(DeathIcon.TextLabel, tweenInfo, {TextSize = newSize})

	pulseTween:Play()
end

local currentHumanoid = nil

local function bindHumanoid(humanoid)
	currentHumanoid = humanoid

	humanoid.Died:Connect(function()
		playDeathMusic()

		DeathIcon.TextLabel.Text = DeathTextLabel
		DeathIcon.TextLabel.TextColor3 = DeathTextColor
		Blur.Size = 25
		DeathIcon.Respawning.Text = RespawnText .. RespawnTime

		Background.Visible = true
		DeathIcon.Respawning.Visible = true

		for i = RespawnTime, 0, -1 do
			DeathIcon.Respawning.Text = RespawnText .. i
			wait(1)
		end

		respawn()
	end)
end

if LocalPlayer.Character then
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		bindHumanoid(humanoid)
	end
end

-- re-grab the humanoid every spawn so the death screen works after respawns too
LocalPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	bindHumanoid(humanoid)
end)

RunService.RenderStepped:Connect(function()
	if currentHumanoid and currentHumanoid.Health > 0 then
		stopDeathMusic()
		respawn()
	end
end)

if PulseDuration > 0 and PulseScale ~= 1 then
	pulseEffect()
end
