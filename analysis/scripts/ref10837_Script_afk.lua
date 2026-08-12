local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local RemoteEvent = ReplicatedStorage:WaitForChild("AFKRemoteEvent")
local IsAFK = false

local function SendAFKState(NewState)
	if IsAFK == NewState then
		return
	end

	IsAFK = NewState
	RemoteEvent:FireServer(IsAFK)
end

UserInputService.WindowFocusReleased:Connect(function()
	SendAFKState(true)
end)

UserInputService.WindowFocused:Connect(function()
	SendAFKState(false)
end)