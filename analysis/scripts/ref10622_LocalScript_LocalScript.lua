local exitButton = script.Parent

local tvFrame = exitButton:FindFirstAncestor("tvchanger")

local function onCloseClicked()
	if tvFrame then
		tvFrame.Visible = false
	else
		-- Fallback: if script parent is directly inside the frame
		local parent = exitButton.Parent
		if parent and parent:IsA("GuiObject") then
			parent.Visible = false
		end
	end
end

exitButton.MouseButton1Click:Connect(onCloseClicked)