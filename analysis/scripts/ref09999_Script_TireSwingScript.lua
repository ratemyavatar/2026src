local Home = script.Parent
local Tire = Home:WaitForChild("Tire")
local TopBar = Home:WaitForChild("TopBar")

-- Parts
local TopBarPart = Home:WaitForChild("TopBarPart")


local Hook1 = Tire:WaitForChild("Hook1")
local Hook2 = Tire:WaitForChild("Hook2")
local TireMesh = Tire:WaitForChild("TireMesh")
local TireSeat = Tire:WaitForChild("TireSeat")

local RopeSupport1 = TopBar:WaitForChild("RopeSupport1")
local RopeSupport2 = TopBar:WaitForChild("RopeSupport2")

-- Body objects
local BodyForce = TireMesh:WaitForChild("BodyForce")

-- Other
local CurrentOccupant = nil
local Vector3New,CFrameNew,CFrameAngles,MathRad,MathAbs = Vector3.new,CFrame.new,CFrame.Angles,math.rad,math.abs

-- Settings
local Configuration = Home:WaitForChild("Configuration")
local SwingPower = Configuration:WaitForChild("SwingPower")

local function SetPhysicalProperties(Part,Density)
	if Part then
		Part.CustomPhysicalProperties = PhysicalProperties.new(Density,Part.Friction,Part.Elasticity)
	end
end

GetAllDescendants = function(instance, func)
	func(instance)
	for _, child in next, instance:GetChildren() do
		GetAllDescendants(child, func)
	end
end

local function SetCharacterToWeight(ToDensity,Char)
	GetAllDescendants(Char,function(d)
		if d and d.Parent and d:IsA("BasePart") then
			SetPhysicalProperties(d,ToDensity)
		end
	end)
end

TireSeat.Changed:connect(function()
	if TireSeat.Occupant then
		local CurrentThrottle = TireSeat.Throttle
		
		-- Adjust swing when interacted
		if CurrentThrottle == 1 then
			BodyForce.Force = TireMesh.CFrame.lookVector * SwingPower.Value * 100
		elseif CurrentThrottle == -1 then
			BodyForce.Force = TireMesh.CFrame.lookVector * SwingPower.Value * -100
		else
			BodyForce.Force = Vector3New()
		end
		
		delay(0.2,function()
			BodyForce.Force = Vector3New()
		end)
		
		-- Make the character weightless for the swing to behave correctly
		if CurrentOccupant == nil then
			CurrentOccupant = TireSeat.Occupant
			SetCharacterToWeight(0,CurrentOccupant.Parent)
		end
		
	elseif CurrentOccupant then
		-- Set the character's weight back
		SetCharacterToWeight(0.7,CurrentOccupant.Parent)
		CurrentOccupant = nil
	end
end)