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
local Humanoid = nil
if LocalPlayer.Character then
	Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
else
	LocalPlayer.CharacterAdded:Connect(function(character)
		Humanoid = character:WaitForChild("Humanoid")
	end)
end
local function pulseEffect()
	local originalSize = DeathIcon.TextLabel.TextSize
	local newSize = originalSize * PulseScale

	local tweenInfo = TweenInfo.new(PulseDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
	local pulseTween = game:GetService("TweenService"):Create(DeathIcon.TextLabel, tweenInfo, {TextSize = newSize})

	pulseTween:Play()
end
Humanoid.Died:Connect(function()
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
RunService.RenderStepped:Connect(function()
	if Humanoid and Humanoid.Health > 0 then
		stopDeathMusic()
		respawn()
	end
end)
pulseEffect()