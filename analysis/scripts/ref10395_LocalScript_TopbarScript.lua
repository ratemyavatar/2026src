local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TopbarFolder = ReplicatedStorage:WaitForChild("TopbarPlus")
local Icon = require(TopbarFolder:WaitForChild("Icon"))
local SETTINGS_IMAGE = "rbxassetid://430551"
local VideosEnabled = true
local HiddenVideos = {}
local IsNight = false
local OriginalClockTime = Lighting.ClockTime
local TimeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SpinTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function Scan(Container)
	local Descendants = Container:GetDescendants()
	local i
	for i = 1, #Descendants do
		local Object = Descendants[i]

		if Object:IsA("VideoFrame") then
			if VideosEnabled then
				local Data = HiddenVideos[Object]
				if Data then
					Object.Parent = Data.Parent
					pcall(function()
						Object:Play()
					end)
					HiddenVideos[Object] = nil
				end
			else
				if not HiddenVideos[Object] then
					HiddenVideos[Object] = {Parent = Object.Parent}
					pcall(function()
						Object:Pause()
					end)
					Object.Parent = nil
				end
			end
		end
	end

	if VideosEnabled then
		local Video, Data
		for Video, Data in pairs(HiddenVideos) do
			if Video then
				Video.Parent = Data.Parent
				pcall(function()
					Video:Play()
				end)
			end
		end
		HiddenVideos = {}
	end
end

local function UpdateVideos()
	Scan(PlayerGui)
	Scan(workspace)
end

local function OnVideoAdded(Object)
	if Object:IsA("VideoFrame") then
		Object.Visible = VideosEnabled
	end
end

PlayerGui.DescendantAdded:Connect(OnVideoAdded)
workspace.DescendantAdded:Connect(OnVideoAdded)

local VideoToggle = Icon.new()
:setLabel("Disable Videoframes?")

VideoToggle.deselectWhenOtherIconSelected = false

VideoToggle.selected:Connect(function()
	VideosEnabled = false
	VideoToggle:setLabel("Enable Videoframes?")
	UpdateVideos()
end)

VideoToggle.deselected:Connect(function()
	VideosEnabled = true
	VideoToggle:setLabel("Disable Videoframes?")
	UpdateVideos()
end)

local TimeToggle = Icon.new()
:setLabel("Night Time")

TimeToggle.deselectWhenOtherIconSelected = false

TimeToggle.selected:Connect(function()
	IsNight = true
	TimeToggle:setLabel("Day Time")

	TweenService:Create(Lighting, TimeTweenInfo, {ClockTime = 0}):Play()
end)

TimeToggle.deselected:Connect(function()
	IsNight = false
	TimeToggle:setLabel("Night Time")

	TweenService:Create(Lighting, TimeTweenInfo, {ClockTime = OriginalClockTime}):Play()
end)

local CreditsGui = PlayerGui:WaitForChild("credits")
local CreditsMain = CreditsGui:WaitForChild("main")
local CreditsCenterPoint = CreditsGui:WaitForChild("Centerpoint")

local CreditsTweenInfo = TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local CreditsOpenPosition = CreditsCenterPoint.Position
local CreditsClosedPosition = UDim2.new(CreditsOpenPosition.X.Scale, CreditsOpenPosition.X.Offset, -1, 0)

CreditsMain.Position = CreditsClosedPosition
CreditsMain.Visible = false

local function TweenCredits(Position)
	local Tween = TweenService:Create(CreditsMain, CreditsTweenInfo, {Position = Position})
	Tween:Play()
	Tween.Completed:Wait()
end

local function OpenCredits()
	CreditsMain.Position = CreditsClosedPosition
	CreditsMain.Visible = true
	TweenCredits(CreditsOpenPosition)
end

local function CloseCredits()
	TweenCredits(CreditsClosedPosition)
	CreditsMain.Visible = false
end

local CreditsToggle = Icon.new()
:setLabel("Open Credits")

CreditsToggle.deselectWhenOtherIconSelected = false

CreditsToggle.selected:Connect(function()
	CreditsToggle:setLabel("Close Credits")
	OpenCredits()
end)

CreditsToggle.deselected:Connect(function()
	CreditsToggle:setLabel("Open Credits")
	CloseCredits()
end)

local SettingsIcon = Icon.new()
:setName("Settings")
:setImage(SETTINGS_IMAGE)
:setRight()
:setDropdown({
	VideoToggle,
	TimeToggle,
	CreditsToggle,
})

local function GetSettingsImageObject()
	local Descendants = PlayerGui:GetDescendants()
	local i
	for i = 1, #Descendants do
		local Object = Descendants[i]
		if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
			if Object.Image == SETTINGS_IMAGE and Object.Name:find(SettingsIcon.name) then
				return Object
			end
		end
	end

	for i = 1, #Descendants do
		local Object = Descendants[i]
		if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
			if Object.Image == SETTINGS_IMAGE then
				return Object
			end
		end
	end

	return nil
end

local function SpinSettingsIcon(TargetRotation)
	local ImageObject = GetSettingsImageObject()
	if ImageObject then
		TweenService:Create(ImageObject, SpinTweenInfo, {Rotation = TargetRotation}):Play()
	end
end

SettingsIcon.dropdownOpened:Connect(function()
	SpinSettingsIcon(180)
end)

SettingsIcon.dropdownClosed:Connect(function()
	SpinSettingsIcon(0)
end)

local LocationIcon = Icon.new()
:setName("ServerLocation")
:setLabel("Locating server...")
:setRight()
:lock()

spawn(function()
	local ServerLocationRemote = ReplicatedStorage:WaitForChild("GetServerLocation", 30)
	if not ServerLocationRemote then
		LocationIcon:setLabel("Server location unavailable")
		return
	end

	local ok, location = pcall(function()
		return ServerLocationRemote:InvokeServer()
	end)

	if ok and type(location) == "string" and location ~= "" then
		LocationIcon:setLabel("Server: " .. location)
	else
		LocationIcon:setLabel("Server location unavailable")
	end
end)

UpdateVideos()