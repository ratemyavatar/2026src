-- Server Script inside Workspace -> Part

local part = script.Parent
local clickDetector = part:WaitForChild("ClickDetector")

local function onPartClicked(playerWhoClicked)
	local playerGui = playerWhoClicked:FindFirstChild("PlayerGui")
	if not playerGui then return end

	local tvFrame = playerGui:FindFirstChild("tvchanger", true)

	if tvFrame then
		local parentGui = tvFrame:FindFirstAncestorOfClass("ScreenGui")
		if parentGui then
			parentGui.Enabled = true
		end

		-- Force reset so the client registers the visibility change
		tvFrame.Visible = false
		tvFrame.Visible = true
	end
end

clickDetector.MouseClick:Connect(onPartClicked)