--[[
	Loading screen  (ReplicatedFirst.LoadingScreen, a LocalScript)

	Spins the camera around your character while the place finishes
	loading, with a big green play button to jump in when you're ready.

	Old client friendly: CameraType.Scriptable, CFrame.new(a, b) for the
	look at, no task.*, no string interpolation.
--]]

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

pcall(function()
	ReplicatedFirst:RemoveDefaultLoadingScreen()
end)

-- how far the camera sits from the character, and how fast it orbits
local ORBIT_RADIUS = 11
local ORBIT_HEIGHT = 5
local ORBIT_SPEED = 0.8 -- radians per second, slow and chill

local GREEN = Color3.fromRGB(46, 204, 113)
local GREEN_HOVER = Color3.fromRGB(39, 174, 96)
local WHITE = Color3.fromRGB(255, 255, 255)
local GREY = Color3.fromRGB(150, 150, 150)

local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 1000
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- dark veil so the camera spin shows but the world stays moody
local veil = Instance.new("Frame")
veil.Name = "Veil"
veil.Size = UDim2.new(1, 0, 1, 0)
veil.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
veil.BackgroundTransparency = 0.45
veil.BorderSizePixel = 0
veil.Parent = gui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0.08, 0)
title.Position = UDim2.new(0.5, 0, 0.06, 0)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "Rate My Avatar"
title.TextColor3 = WHITE
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = gui

local sub = Instance.new("TextLabel")
sub.Name = "Sub"
sub.Size = UDim2.new(1, 0, 0.04, 0)
sub.Position = UDim2.new(0.5, 0, 0.14, 0)
sub.AnchorPoint = Vector2.new(0.5, 0)
sub.BackgroundTransparency = 1
sub.Text = "loading..."
sub.TextColor3 = GREY
sub.TextScaled = true
sub.Font = Enum.Font.SourceSans
sub.Parent = gui

-- the green play button
local play = Instance.new("TextButton")
play.Name = "Play"
play.Size = UDim2.new(0, 200, 0, 56)
play.Position = UDim2.new(0.5, 0, 0.5, 0)
play.AnchorPoint = Vector2.new(0.5, 0.5)
play.BackgroundColor3 = GREEN
play.Text = "PLAY"
play.TextColor3 = WHITE
play.TextScaled = true
play.Font = Enum.Font.GothamBold
play.ZIndex = 5
play.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 28)
corner.Parent = play

local stroke = Instance.new("UIStroke")
stroke.Color = WHITE
stroke.Transparency = 0.6
stroke.Thickness = 2
stroke.Parent = play

play.MouseEnter:Connect(function()
	play.BackgroundColor3 = GREEN_HOVER
end)
play.MouseLeave:Connect(function()
	play.BackgroundColor3 = GREEN
end)

-- keep it spinning while we wait for a character, we just spin the camera
-- around the spawn point instead of a player that isnt there yet
local cam = Workspace.CurrentCamera
if not cam then
	cam = Workspace:WaitForChild("Camera")
end

local spinning = true
local angle = 0

local function tickCamera(centre, bob)
	local x = math.cos(angle) * ORBIT_RADIUS
	local z = math.sin(angle) * ORBIT_RADIUS
	local y = ORBIT_HEIGHT + math.sin(angle * 2) * 0.6

	cam.CFrame = CFrame.new(
		centre + Vector3.new(x, y, z),
		centre + Vector3.new(0, 2.2, 0)
	)
end

RunService.RenderStepped:Connect(function(dt)
	if not spinning then
		return
	end

	angle = angle + (dt or 0.016) * ORBIT_SPEED
	if angle >= math.pi * 2 then
		angle = angle - math.pi * 2
	end

	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local centre = root and root.Position or Vector3.new(0, 3, 0)

	tickCamera(centre)
end)

-- once a character actually shows up, hop the camera over to it
local function snapToCharacter(character)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if not root then
		return
	end
	spinning = false
	cam.CameraType = Enum.CameraScriptType.Scriptable
	cam.CFrame = CFrame.new(
		root.Position + Vector3.new(ORBIT_RADIUS, ORBIT_HEIGHT, 0),
		root.Position + Vector3.new(0, 2.2, 0)
	)
	spinning = true
end

if LocalPlayer.Character then
	snapToCharacter(LocalPlayer.Character)
else
	LocalPlayer.CharacterAdded:Connect(function(character)
		snapToCharacter(character)
	end)
end

-- play: hand the camera back and fade out
local clicked = false

play.MouseButton1Click:Connect(function()
	if clicked then
		return
	end
	clicked = true

	cam.CameraType = Enum.CameraScriptType.Custom

	spinning = false

	local t = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(veil, t, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(title, t, { TextTransparency = 1 }):Play()
	TweenService:Create(sub, t, { TextTransparency = 1 }):Play()
	TweenService:Create(play, t, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()

	delay(0.5, function()
		gui:Destroy()
	end)
end)
