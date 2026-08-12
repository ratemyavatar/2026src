-- // effects by matt and fuz
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagConfig = require(ReplicatedStorage:WaitForChild("TagConfig"))

local elapsed = 0
RunService.RenderStepped:Connect(function(dt)
	elapsed += dt
end)

local function gradient(nameLabel)
	local g = nameLabel:FindFirstChildOfClass("UIGradient")
	if not g then
		g = Instance.new("UIGradient")
		g.Parent = nameLabel
	end
	return g
end

local function removeg(nameLabel)
	local g = nameLabel:FindFirstChildOfClass("UIGradient")
	if g then g:Destroy() end
end

local function apply(nameLabel, tagType)
	local config = TagConfig[tagType]

	if not config then
		removeg(nameLabel)
		return
	end

	local t = elapsed * (config.speed or 1)
	local style  = config.animationStyle
	local hasGradient = config.gradientColors ~= nil

	if style == "Wave" then
		local grad = gradient(nameLabel)
		grad.Color    = config.gradientColors
		grad.Rotation = config.gradientRotation or 0
		local raw    = (t * 0.5) % 1
		local eased  = math.sin(raw * math.pi * 2) * 0.5 
		grad.Offset  = Vector2.new(eased, 0)

	elseif style == "Shimmer" then
		local grad = gradient(nameLabel)
		grad.Color    = config.gradientColors
		grad.Rotation = config.gradientRotation or 0
		local sweep  = (t * 0.6) % 1
		grad.Offset  = Vector2.new(sweep * 2 - 1, 0)

	elseif style == "Spin" then
		local grad = gradient(nameLabel)
		grad.Color   = config.gradientColors
		grad.Offset  = Vector2.new(0, 0)
		grad.Rotation = (t * 90) % 360

	elseif style == "Slide" then
		local grad = gradient(nameLabel)
		grad.Color    = config.gradientColors
		grad.Rotation = config.gradientRotation or 0
		grad.Offset   = Vector2.new((t * 0.4) % 2 - 1, 0)

	elseif style == "Pulse" then
		removeg(nameLabel)
		local a = config.pulseColorA or TagConfig.DefaultColor
		local b = config.pulseColorB or Color3.fromRGB(50, 50, 50)
		local alpha = (math.sin(t * math.pi * 2) + 1) / 2
		nameLabel.TextColor3 = a:Lerp(b, alpha)

	elseif style == "Breath" then
		removeg(nameLabel)
		local base = config.textColor or TagConfig.DefaultColor
		local dim  = config.breathDim or Color3.fromRGB(50, 50, 50)
		local alpha = (math.sin(t * math.pi) + 1) / 2 * 0.45
		nameLabel.TextColor3 = base:Lerp(dim, alpha)

	elseif style == "Bounce" then
		local grad =gradient(nameLabel)
		grad.Color  = config.gradientColors
		grad.Offset = Vector2.new(0, 0)
		local swing = math.abs(math.sin(t * math.pi)) * 90 - 45
		grad.Rotation = swing

	elseif style == "Thug" then
		-- Custom style (used by the "thug" tag): black text with a white
		-- glint sweeping across it on a diagonal. Gradient-only, so it is
		-- fully 2021 compatible.
		local grad = gradient(nameLabel)
		grad.Color    = config.gradientColors
		grad.Rotation = config.gradientRotation or 45
		local sweep    = (t * 0.6) % 2 - 1
		grad.Offset   = Vector2.new(sweep, 0)

	else
		if hasGradient then
			local grad = gradient(nameLabel)
			grad.Color    = config.gradientColors
			grad.Rotation = config.gradientRotation or 0
			grad.Offset   = Vector2.new(0, 0)
		else
			removeg(nameLabel)
		end
	end
end

RunService.RenderStepped:Connect(function()
	for _, desc in ipairs(workspace:GetDescendants()) do
		if desc:IsA("Attachment") and desc.Name == "overhead" then
			local billboard = desc:FindFirstChildOfClass("BillboardGui")
			local nameLabel = billboard and billboard:FindFirstChild("name")
			if billboard and nameLabel then
				local tagType = billboard:GetAttribute("TagType") or "None"
				apply(nameLabel, tagType)
			end
		end
	end
end)

local camera = workspace.CurrentCamera
local start = 75
local max = 100
local textstroke = 0.6

local OcclusionParams = RaycastParams.new()
OcclusionParams.FilterType = Enum.RaycastFilterType.Blacklist
OcclusionParams.IgnoreWater = true

local function BuildExcludeList()
	local list = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			list[#list + 1] = plr.Character
		end
	end
	return list
end

RunService.RenderStepped:Connect(function()
	OcclusionParams.FilterDescendantsInstances = BuildExcludeList()
	local cameraPosition = camera.CFrame.Position

	for _, desc in ipairs(workspace:GetDescendants()) do
		if desc:IsA("Attachment") and desc.Name == "overhead" then
			local billboardGui = desc:FindFirstChildOfClass("BillboardGui")
			local nameLabel = billboardGui and billboardGui:FindFirstChild("name")

			if billboardGui and nameLabel then
				billboardGui.MaxDistance = max

				local offset = desc.WorldPosition - cameraPosition
				local distance = offset.Magnitude

				if distance <= start then
					nameLabel.TextTransparency = 0
					nameLabel.TextStrokeTransparency = textstroke
				elseif distance >= max then
					nameLabel.TextTransparency = 1
					nameLabel.TextStrokeTransparency = 1
				else
					local alpha = (distance - start) / (max - start)
					nameLabel.TextTransparency = alpha
					nameLabel.TextStrokeTransparency = textstroke + (1 - textstroke) * alpha
				end

				if distance < max then
					local hit = workspace:Raycast(cameraPosition, offset, OcclusionParams)
					billboardGui.AlwaysOnTop = hit == nil
				else
					billboardGui.AlwaysOnTop = false
				end
			end
		end
	end
end)