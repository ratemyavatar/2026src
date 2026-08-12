--[[
	Spectate Booths

	Adapted from the original player-spectate script. Cycles the camera
	through every booth in the workspace instead of every player.

	"Every booth" currently means every unclaimed one too - BoothOwner being
	nil does not exclude a booth from the list. If a claimed-only mode is
	wanted later, filter GetBoothList() on Owner.Value ~= nil.
--]]
local UI = script.Parent
local Camera = workspace.CurrentCamera
local Button = UI:WaitForChild("Frame"):WaitForChild("TextButton")
local Debounce = false
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Template/preview booths live under this folder and are not real, ownable
-- booths - they should never show up in the rotation.
local EXCLUDED_ROOTS = {"Booth Themes"}

local OwnerConnection
local DestroyConnection
local Render
local BoothList
local CurrentIndex

local SpectateSettings = {
	["SmoothTransitions"] = {
		["Tween"] = nil;
		--[[
		The drawback of turning this true, is that you cannot rotate your camera
		while spectating. Your camera is fixed at a specific position with respect to
		the booth.
		--]]
		["Status"] = true;
		--[[
		If the above setting is set to false, the camera snaps immediately to the
		next booth to be spectated. In the other case, it will smoothly move towards
		the next booth to be spectated.
		--]]
		["Style"] = Enum.EasingStyle.Quad;
		["Direction"] = Enum.EasingDirection.Out;
		["Time"] = 0.5;
		--[[
		Increase the time for slower movement of the camera,
		and decrease it for faster movement of the camera to the next booth to be spectated.
		--]]
		["DistanceFromBooth"] = 10; -- 10 Studs Distance From Booth
		["HeightDistance"] = 7; -- 7 Studs Above The Display
		["InclinationAngle"] = 30;
		--[[
		Mess around with the above two settings as per your
		preference. You will get what you prefer only with trial and error.
		--]]
	};
	--[[
	Dont mess with the settings below.
	--]]
	["SpectateOn"] = false;
}

local function IsExcluded(booth)
	for _, rootName in ipairs(EXCLUDED_ROOTS) do
		local root = workspace:FindFirstChild(rootName)
		if root and booth:IsDescendantOf(root) then
			return true
		end
	end
	return false
end

-- Real booths are Model instances named "boothgood" with a Display part
-- (Attachment for position, BoothOwner for who claimed it). They currently
-- sit loose in Workspace rather than inside the (empty) Booths folder, so
-- this scans descendants rather than assuming a fixed container.
local function GetBoothList()
	local list = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "boothgood" and not IsExcluded(obj) then
			local display = obj:FindFirstChild("Display")
			if display and display:IsA("BasePart") then
				table.insert(list, obj)
			end
		end
	end
	return list
end

local function MouseEnterTween(ButtonItem)
	ButtonItem.MouseEnter:Connect(function()
		TweenService:Create(ButtonItem, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ButtonItem.MouseLeave:Connect(function()
		TweenService:Create(ButtonItem, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {BackgroundColor3 = Color3.fromRGB(161, 161, 161)}):Play()
	end)
end

local function BoothLabel(Booth)
	local Display = Booth:FindFirstChild("Display")
	local Owner = Display and Display:FindFirstChild("BoothOwner")
	if Owner and Owner.Value then
		return Owner.Value.Name .. "'s Booth"
	end
	return "Unclaimed Booth"
end

local function SetCameraSubject(Booth, OnActivation)
	if OwnerConnection then
		OwnerConnection:Disconnect()
		OwnerConnection = nil
	end
	if DestroyConnection then
		DestroyConnection:Disconnect()
		DestroyConnection = nil
	end
	if typeof(Render) ~= 'nil' then
		Render:Disconnect()
		Render = nil
		if SpectateSettings.SmoothTransitions.Tween then
			SpectateSettings.SmoothTransitions.Tween:Pause()
		end
		SpectateSettings.SmoothTransitions.Tween = nil
	end

	local Display = Booth:FindFirstChild("Display")
	if not Display then
		return
	end

	if SpectateSettings.SmoothTransitions.Status == true then
		Camera.CameraType = Enum.CameraType.Scriptable
		local TargetCFrame
		Render = RunService.RenderStepped:Connect(function()
			TargetCFrame = Display.CFrame
			TargetCFrame *= CFrame.new(0, 0, SpectateSettings.SmoothTransitions.DistanceFromBooth)
			TargetCFrame *= CFrame.new(0, SpectateSettings.SmoothTransitions.HeightDistance, 0)
			TargetCFrame *= CFrame.Angles(math.rad(-SpectateSettings.SmoothTransitions.InclinationAngle), 0, 0)
			SpectateSettings.SmoothTransitions.Tween = TweenService:Create(Camera, TweenInfo.new(SpectateSettings.SmoothTransitions.Time, SpectateSettings.SmoothTransitions.Style, SpectateSettings.SmoothTransitions.Direction, 0, false, 0), {CFrame = TargetCFrame})
			SpectateSettings.SmoothTransitions.Tween:Play()
		end)
	else
		-- No humanoid to hand the camera to for a static booth, so just park
		-- it at the same offset once instead of tracking every frame.
		Camera.CameraType = Enum.CameraType.Scriptable
		local TargetCFrame = Display.CFrame
		TargetCFrame *= CFrame.new(0, 0, SpectateSettings.SmoothTransitions.DistanceFromBooth)
		TargetCFrame *= CFrame.new(0, SpectateSettings.SmoothTransitions.HeightDistance, 0)
		TargetCFrame *= CFrame.Angles(math.rad(-SpectateSettings.SmoothTransitions.InclinationAngle), 0, 0)
		Camera.CFrame = TargetCFrame
	end

	UI.Buttons.Frame.PlayerName.Text = BoothLabel(Booth)

	local Owner = Display:FindFirstChild("BoothOwner")
	if Owner then
		OwnerConnection = Owner.Changed:Connect(function()
			UI.Buttons.Frame.PlayerName.Text = BoothLabel(Booth)
		end)
	end

	-- If the booth we're looking at goes away mid-spectate, back out instead
	-- of leaving the camera pointed at nothing.
	DestroyConnection = Booth.Destroying:Connect(function()
		OnActivation()
	end)
end

local function ValidityCheck()
	if not game.Players.LocalPlayer.Character then return end
	if not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then return end
	if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	return true
end

local function OnActivation()
	if ValidityCheck() ~= true then return end
	SpectateSettings.SpectateOn = not SpectateSettings.SpectateOn
	if SpectateSettings.SpectateOn == true then
		BoothList = GetBoothList()
		if #BoothList == 0 then
			SpectateSettings.SpectateOn = false
			return
		end

		UI.Buttons.Visible = true
		UI.Buttons.Position = UDim2.new(0.5, 0, 1.1, 0)
		TweenService:Create(UI.Buttons, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {Position = UDim2.new(0.5, 0, 0.9, 0)}):Play()
		CurrentIndex = #BoothList
		SetCameraSubject(BoothList[CurrentIndex], OnActivation)
	else
		if OwnerConnection then
			OwnerConnection:Disconnect()
			OwnerConnection = nil
		end
		if DestroyConnection then
			DestroyConnection:Disconnect()
			DestroyConnection = nil
		end
		if typeof(Render) ~= 'nil' then
			Render:Disconnect()
			Render = nil
			if SpectateSettings.SmoothTransitions.Tween then
				SpectateSettings.SmoothTransitions.Tween:Cancel()
			end
			SpectateSettings.SmoothTransitions.Tween = nil
		end
		TweenService:Create(UI.Buttons, TweenInfo.new(0.23, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0), {Position = UDim2.new(0.5, 0, 1.1, 0)}):Play()
		delay(0.23, function()
			UI.Buttons.Visible = false
		end)
		Camera.CameraType = Enum.CameraType.Custom
		Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	end
end

UI.Buttons.Next.Activated:Connect(function()
	if ValidityCheck() ~= true then return end
	if Debounce == true then return end
	if not BoothList or #BoothList == 0 then return end
	Debounce = true
	UI.Buttons.Next.Size = UDim2.new(0.2, 0, .7, 0)
	TweenService:Create(UI.Buttons.Next, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2.new(0.2, 0, .85, 0)}):Play()
	if CurrentIndex == #BoothList then
		CurrentIndex = 1
	else
		CurrentIndex = CurrentIndex + 1
	end
	SetCameraSubject(BoothList[CurrentIndex], OnActivation)
	task.wait(0.2)
	Debounce = false
end)

UI.Buttons.Previous.Activated:Connect(function()
	if ValidityCheck() ~= true then return end
	if Debounce == true then return end
	if not BoothList or #BoothList == 0 then return end
	Debounce = true
	UI.Buttons.Previous.Size = UDim2.new(0.2, 0, .7, 0)
	TweenService:Create(UI.Buttons.Previous, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2.new(0.2, 0, .85, 0)}):Play()
	if CurrentIndex == 1 then
		CurrentIndex = #BoothList
	else
		CurrentIndex = CurrentIndex - 1
	end
	SetCameraSubject(BoothList[CurrentIndex], OnActivation)
	task.wait(0.2)
	Debounce = false
end)

Button.Activated:Connect(function()
	if Debounce == true then return end
	Debounce = true
	Button.Size = UDim2.new(0.7, 0, .7, 0)
	TweenService:Create(Button, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2.new(0.9, 0, .9, 0)}):Play()
	OnActivation()
	task.wait(0.3)
	Debounce = false
end)

MouseEnterTween(Button)
MouseEnterTween(UI.Buttons.Next)
MouseEnterTween(UI.Buttons.Previous)